;==============================================================
;   BIG EVIL FRAMEWORK - Matt Phillips (c) 2017
;==============================================================
;   http://www.bigevilcorporation.co.uk
;==============================================================
;   uitext.asm - Text label UI widget
;==============================================================

UIWidgetText_MaxStringLen		equ 0x20

UIWidgetText_DrawPlane_PlaneA	equ 0x0
UIWidgetText_DrawPlane_PlaneB	equ 0x1
UIWidgetText_DrawPlane_Sprite	equ 0x2

UIWidgetText_Width				equ 0x08
UIWidgetText_Height				equ 0x08

	rsset UIWidget_Struct_Size
;---------------------------------
UIWidgetText_String			rs.b UIWidgetText_MaxStringLen
UIWidgetText_FontAddr		rs.l 1
UIWidgetText_FontAddrVRAM	rs.w 1
UIWidgetText_StringAddrVRAM	rs.w 1
UIWidgetText_Palette		rs.b 1
UIWidgetText_DrawPlane		rs.b 1
UIWidgetText_TileCount		rs.b 1
;---------------------------------
	RS_ALIGN
UIWidgetText_Struct_Size	rs.b 0
;---------------------------------

UIWidgetTextInit:
	; a0 --- Widget addr

	; Base init
	jsr    UIWidgetInit

	; Set update/render routines
	move.l #UIWidgetTextUpdate, UIWidget_UpdateRoutine(a0)
	move.l #UIWidgetTextRender, UIWidget_RenderRoutine(a0)

	; Initial state
	move.w #UIWidgetText_Width, UIWidget_Width(a0)
	move.w #UIWidgetText_Height, UIWidget_Height(a0)
	move.l #0x0, UIWidgetText_FontAddr(a0)
	move.w #0x0, UIWidgetText_FontAddrVRAM(a0)
	move.w #0x0, UIWidgetText_StringAddrVRAM(a0)
	move.b #0x0, UIWidgetText_Palette(a0)
	move.b #UIWidgetText_DrawPlane_PlaneA, UIWidgetText_DrawPlane(a0)
	move.b #0x0, UIWidgetText_TileCount(a0)
	
	; Blank string
	move.l a0, a3
	move.l #UIWidgetText_MaxStringLen, d1
	lea    UIWidgetText_String(a3), a3
	MEMZEROB a3, d1
	
	rts

UIWidgetTextSetString:
	; a0 --- Widget addr
	; a1 --- String
	; a2 --- Font
	; d0 (w) Font (VRAM)
	; d1 (b) Palette
	; d2 (b) Draw plane
	
	move.l a2, UIWidgetText_FontAddr(a0)
	move.w d0, UIWidgetText_FontAddrVRAM(a0)
	move.b d1, UIWidgetText_Palette(a0)
	move.b d2, UIWidgetText_DrawPlane(a0)
	
	; Calc string length
	PUSHM  d0/a0-a1
	move.l a1, a0
	jsr    TXT_StrLen
	move.b d0, d1
	POPM   d0/a0-a1
	move.b d1, UIWidgetText_TileCount(a0)
	
	; Set width/height
	moveq #0x0, d2
	move.b d1, d2
	lsl.w  #0x3, d2
	move.w d2, UIWidget_Width(a0)
	move.w #0x8, UIWidget_Height(a0)

	; Clear original
	move.l a0, a3
	move.l #UIWidgetText_MaxStringLen, d3
	lea    UIWidgetText_String(a3), a3
	MEMZEROB a3, d3

	; Copy string
	move.l a0, a3
	andi.w #0x00FF, d1
	lea    UIWidgetText_String(a3), a3
	MEMCPYB a3, a1, d1

	; If using sprites
	cmp.b  #UIWidgetText_DrawPlane_Sprite, UIWidgetText_DrawPlane(a0)
	bne    @NoSprites
	
	; Round size to nearest 4
	moveq #0x0, d0
	moveq #0x0, d1
	move.b UIWidgetText_TileCount(a0), d0
	addq.b #0x3, d0
	andi.w #0xFFFC, d0
	move.b d0, UIWidgetText_TileCount(a0)

	; TODO: Uses first string as max size, allow reallocation
	move.w UIWidgetText_StringAddrVRAM(a0), d1
	bne    @Allocd

	; Alloc VRAM for string tiles
	PUSHM  d0/a0-a1
	clr.w  d0
	move.b UIWidgetText_TileCount(a0), d0
	TILES2BYTES d0
	jsr    VRAM_PoolAlloc
	move.w d0, d1
	POPM   d0/a0-a1

	move.w d1, UIWidgetText_StringAddrVRAM(a0)

	@Allocd:

	; Copy glyph tiles
	PUSHM  a0-a1
	moveq #0x0, d0
	moveq #0x0, d2
	move.w d1, d0
	BYTES2TILES d0							; VRAM addr to tile ID
	move.l UIWidgetText_FontAddr(a0), a1	; Font
	move.b UIWidgetText_TileCount(a0), d2	; Count (incl. padding)
	lea    UIWidgetText_String(a0), a0		; String
	jsr    TXT_LoadStringSpriteTiles
	POPM   a0-a1

	@NoSprites:

	rts

UIWidgetTextUpdate:
	; a0 --- Widget addr

	jsr    UIWidgetUpdate

	rts

UIWidgetTextRender:
	; a0 --- Widget addr
	; d2 (w) Camera left
	; d3 (w) Camera right
	; d4 (w) Camera top
	; d5 (w) Camera bottom

	PUSHMW d2-d5

	; TODO - Offset by window pos
	move.l UIWidget_Window(a0), a2

	PUSHL   a0

	move.b UIWidgetText_DrawPlane(a0), d0
	cmp.b  #UIWidgetText_DrawPlane_PlaneA, d0
	beq    @DrawPlane
	cmp.b  #UIWidgetText_DrawPlane_PlaneB, d0
	beq    @DrawPlane
	cmp.b  #UIWidgetText_DrawPlane_Sprite, d0
	beq    @DrawSprites

	;==============================================================

	@DrawPlane:

	move.w UIWidget_PositionX(a0), d1			; X pos
	sub.w  (WorldScrollX), d1
	lsr.w  #0x3, d1								; Pixels to tiles
	swap   d1
	move.w UIWidget_PositionY(a0), d1			; Y pos
	sub.w  (WorldScrollY), d1
	lsr.w  #0x3, d1								; Pixels to tiles

	move.w UIWidgetText_FontAddrVRAM(a0), d0	; Font (VRAM)
	BYTES2TILES d0								; To tiles
	move.b UIWidgetText_Palette(a0), d2			; Palette
	move.b UIWidgetText_DrawPlane(a0), d3		; Plane
	lea    UIWidgetText_String(a0), a0			; String
	jsr    TXT_DrawPlane

	bra @End

	;==============================================================

	@DrawSprites:

	moveq #0x0, d2
	move.w UIWidgetText_StringAddrVRAM(a0), d2
	BYTES2TILES d2
	
	; Add all text glyphs for drawing
	moveq #0x0, d4
	move.b UIWidgetText_TileCount(a0), d4	; Count
	move.b #%1100, d0						; 4x1 sprite
	move.w UIWidget_PositionX(a0), d1		; X pos
	addi.w #vdp_sprite_border_x, d1
	swap   d1
	move.w UIWidget_PositionY(a0), d1		; Y pos
	addi.w #vdp_sprite_border_y, d1
	clr.w  d3
	move.b UIWidgetText_Palette(a0), d3		; Palette
	ror.w  #0x3, d3							; Palette/flip/priority bits
	ori.w  #(1<<15), d3

	; Create 1 sprite for each 4 glyphs
	lsr.w  #0x2, d4	; Div char count by 4
	subq.w #0x1, d4	; -1 for loop
	@GlyphLp:
	PUSHL  d4

	; Create and link sprite
	PUSHM  d0-d3/a0-a1
	jsr    SPR_AddSubSprite
	POPM   d0-d3/a0-a1

	; Next X * 4
	addi.l #0x00200000, d1

	; Next tile * 4
	addq.w #0x4, d2

	POPL   d4
	dbra   d4, @GlyphLp

	;==============================================================

	@End:

	POPL    a0

	POPMW   d2-d5

	jsr    UIWidgetRender
	
	rts