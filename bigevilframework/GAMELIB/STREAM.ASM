;==============================================================
;   BIG EVIL FRAMEWORK - Matt Phillips (c) 2015
;==============================================================
;   http://www.bigevilcorporation.co.uk
;==============================================================
;   stream.asm - Map streaming logic
;==============================================================

MAP_StreamInit:
	move.w #0x0, MapStreamLoadedCol
	move.w #0x0, MapStreamLoadedRow

	lea    BlockMapColumnIndexCache, a5
	move.w #BlockMapColumnCacheWidth-1, d0
	@IdxLp:
	move.w #0xFFFF, (a5)+
	dbra   d0, @IdxLp

	move.w #0x0, d0
	jsr    VDP_SetHScrollPlaneA
	jsr    VDP_SetHScrollPlaneB
	jsr    VDP_SetVScrollPlaneA
	jsr    VDP_SetVScrollPlaneB

	move.w d0, vdp_hscroll_a
	move.w d0, vdp_hscroll_b
	move.w d0, vdp_vscroll_a
	move.w d0, vdp_vscroll_b

	rts

MAP_UpdateStreaming:
	; a1 --- Level addr
	; d0 (b) Process VDP queue immediately (for initial loading)
	
	; Level to a1
	move.l  (CurrentLevel), a1
	
	;==============================================================
	
	; Calculate rows remaining
	moveq #0x0, d1
	move.w  (WorldScrollY), d1		; Get world scroll Y position (incl. camera shake + peek offset)
									; (top word = integer part)
	
	PIXELS2TILES d1					; To tiles
	TILES2BLOCKS d1					; To blocks
	move.w  d1, d2

	move.w  Level_MapHeightBlocks(a1), d6 ; Clamp to map height
	subi.w  #MapStreamHeight-1, d6
	cmp.w   d6, d2
	ble     @WithinHeight
	move.w  d6, d2
	@WithinHeight:

	sub.w   (MapStreamLoadedRow), d2
	ABSW    d2
	
	;==============================================================
	
	; Calculate cols remaining
	moveq #0x0, d3
	move.w  (WorldScrollX), d3		; Get world scroll X position (incl. camera shake + peek offset)
									; (top word = integer part)
	
	PIXELS2TILES d3					; To tiles
	TILES2BLOCKS d3					; To blocks
	move.w  d3, d4

	move.w  Level_MapWidthBlocks(a1), d6 ; Clamp to map width
	subi.w  #MapStreamWidth-1, d6
	cmp.w   d6, d4
	ble     @WithinWidth
	move.w  d6, d4
	@WithinWidth:

	sub.w   (MapStreamLoadedCol), d4
	ABSW    d4
	
	;==============================================================
	
	; Process one row followed by one col at a time
	@WorkLoop:
	
	tst.w   d2
	beq     @NoPendingRows
	
	; Stream next pending row
	PUSHM   d0-d4
	jsr     MAP_StreamNextRow
	POPM    d0-d4
	
	subq.w   #0x1, d2
	
	@NoPendingRows:
	
	;==============================================================
	
	tst.w   d4
	beq     @NoPendingCols
	
	; Stream next pending col
	PUSHM   d0-d4
	move.w  d3, d1
	jsr     MAP_StreamNextColumn
	POPM    d0-d4
	
	subq.w   #0x1, d4
	
	@NoPendingCols:
	
	;==============================================================
	
	; Process the VDP job queue immediately if required
	tst.b   d0
	beq     @NoFlush
	PUSHALL
	jsr     VDP_JobQueue_ExecuteAll
	POPALL
	@NoFlush:
	
	;==============================================================
	
	; Loop until all pending rows and cols processed
	tst.w   d2
	bne     @WorkLoop
	tst.w   d4
	bne     @WorkLoop
	
	rts
	
MAP_StreamNextRow:
	; a1 --- Level addr
	; d1 (w) Target row

	; Check streaming direction
	move.w  (MapStreamLoadedRow), d0
	cmp.w   d0, d1
	blt		@StreamTop
	bgt		@StreamBottom
	bra     @End
	
	@StreamTop:
	subq.w   #0x1, d0				; Stream one row above last streamed
	move.w  d0, MapStreamLoadedRow	; Last loaded row back to RAM
	bra		@Stream
	@StreamBottom:
	addq.w  #0x1, d0				; Stream one row below last streamed
	move.w  d0, MapStreamLoadedRow	; Last loaded row back to RAM
	addi.w  #MapStreamHeight-MapStreamBorderY, d0	; Offset to bottom of stream window
	@Stream:

	; Source rect left in upper d0
	swap	d0
	move.w  (MapStreamLoadedCol), d0
	move.w	d0, d1
	swap	d0
	
	; Dest rect left in upper d1
	divu	#vdp_plane_width_blocks, d1	; Div/scroll width
	clr.w	d1						; Clear exponent (remainder in upper d1)
	
	; Dest rect top in lower d1
	moveq #0x0, d2
	move.w	d0, d2					; Dest rect top to lower d2
	divu    #vdp_plane_height_blocks, d2	; Div/scroll height
	clr.w	d2						; Clear exponent
	swap	d2						; Remainder (modulus) to lower d1
	move.w	d2, d1
	
	move.w	#MapStreamWidth, d2		; Stream whole width, ignoring column overlap (rows can be done in 1 DMA)
	swap	d2
	move.w  #0x1, d2				; Streaming one row per frame (to load balance)
	
	; Check if width crosses scroll plane bounds
	move.w	#0x0, d4 ; Don't loop by default
	move.l	d1, d3
	swap	d3
	add.w	#MapStreamWidth, d3
	cmp.w	#vdp_plane_width_blocks, d3
	ble		@WithinBounds
	
	; Clamp width to bounds
	sub.w	#vdp_plane_width_blocks, d3
	move.w	d3, d5		; Keep overflow
	swap	d2
	sub.w	d3, d2		; Truncate width
	swap	d2
	move.w	#0x1, d4	; Loop for second half of row
	@WithinBounds:
	
	; Loop
	@Loop:
	
	; Backup source/dest rects, width/height, loop counter and overflow
	PUSHM   a0-a1/d0-d5

	; Clamp to map width
	;move.l d0, d6						; Source top/left
	;move.l d2, d7						; Dest width/height
	;swap   d6							; Get X
	;swap   d7							; Get X
	;add.w  d6, d7						; Get right-hand col
	;move.w Level_MapWidthBlocks(a1), d5	; Get map width
	;cmp.w  d5, d7
	;ble    @WidthInBounds
	;sub.w  d6, d5
	;swap   d2
	;move.w d5, d2
	;swap   d2
	;@WidthInBounds:
	
	; Load map segment
	move.w  Level_MapHeightBlocks(a1), d3		; d3 (w)  Source map total height (blocks)
	move.l  Level_BlocksAddr(a1), a0			; a0 ---  Source blocks address
	move.l  Level_BlockColOffsetsAddr(a1), a2	; a2 --- Source blockmap compressed column offsets
	move.l  Level_BlockMapAddr(a1), a1			; a1 ---  Source block map address
	move.w  (vram_addr_leveltiles), d4			; d4 (w)  Art tile ID
	BYTES2TILES d4
	move.b  #PaletteId_World0, d5				; d5 (b)  Palette ID
	jsr     VDP_LoadMapBlockSegmentPlaneA
	
	; Restore source/dest rects, width/height, loop counter and overflow
	POPM    a0-a1/d0-d5
	
	; Continue second half of row from left of scroll plane
	swap	d0
	swap	d2
	add.w	d2, d0		; Advance source left by last width
	swap	d0
	move.w	d5, d2		; Overflow is new width
	swap 	d2
	
	and.l	#0x0000FFFF, d1	; Dest left
	
	; Loop
	dbra	d4, @Loop
	
	@End:
	rts
	
MAP_StreamNextColumn:
	; a1 --- Level addr
	; d1 (w) Target cols

	; Check streaming direction
	move.w  (MapStreamLoadedCol), d0
	cmp.w   d0, d1
	blt		@StreamLeft
	bgt		@StreamRight
	bra     @End
	
	@StreamLeft:
	subq.w   #0x1, d0				; Stream one col left of last streamed
	move.w  d0, MapStreamLoadedCol	; Last loaded col back to RAM
	bra		@Stream
	@StreamRight:
	addq.w  #0x1, d0				; Stream one col right of last streamed
	move.w  d0, MapStreamLoadedCol	; Last loaded col back to RAM
	addi.w  #MapStreamWidth-MapStreamBorderX, d0	; Offset to right of stream window
	@Stream:

	; Dest rect left in upper d2
	moveq #0x0,	d2
	move.w	d0, d2					; Dest rect left to lower d2
	divu    #vdp_plane_width_blocks, d2	; Div/scroll width
	clr.w	d2						; Clear exponent (remainder in upper d2)

	; Source rect top in lower d0
	swap	d0
	move.w  (MapStreamLoadedRow), d0
	move.w  d0, d1
	
	; Dest rect top in lower d1
	divu	#vdp_plane_height_blocks, d1	; Div/scroll height
	clr.w	d1						; Clear exponent
	swap	d1						; Remainder to lower d1
	
	; Dest rect left to upper d1
	or.l	d2, d1					
	move.w  #0x1, d2				; Streaming one col per frame (to load balance)
	swap	d2
	move.w	#MapStreamHeight, d2	; Stream whole height (TODO: don't include overlap)
	
	; Check if height crosses scroll plane bounds
	move.w	#0x0, d4 ; Don't loop by default
	move.w	d1, d3
	add.w	#MapStreamHeight, d3
	cmp.w	#vdp_plane_height_blocks, d3
	ble		@WithinBounds
	
	; Clamp height to bounds
	sub.w	#vdp_plane_height_blocks, d3
	move.w	d3, d5		; Keep overflow
	sub.w	d3, d2		; Truncate height
	move.w	#0x1, d4	; Loop for second half of column
	@WithinBounds:
	
	; Loop
	@Loop:
	
	; Backup source/dest rects, width/height, loop counter and overflow
	PUSHM   a0-a1/d0-d5
	
	; Load map segment
	move.w  Level_MapHeightBlocks(a1), d3	; d3 (w)  Source map total height (blocks)

	; Clamp to map height
	;move.w d0, d6						; Source top
	;move.w d2, d7						; Dest height
	;add.w  d6, d7						; Get right-hand col
	;move.w d3, d5						; Get map height
	;cmp.w  d5, d7
	;blt    @HeightInBounds
	;sub.w  d6, d5
	;move.w d5, d2
	;@HeightInBounds:

	move.l  Level_BlocksAddr(a1), a0		; a0 ---  Source blocks address
	move.l  Level_BlockColOffsetsAddr(a1), a2 ; a2 --- Source blockmap compressed column offsets
	move.l  Level_BlockMapAddr(a1), a1		; a1 ---  Source block map address
	move.w  (vram_addr_leveltiles), d4		; d4 (w)  Art tile ID
	BYTES2TILES d4
	move.b  #PaletteId_World0, d5			; d5 (b)  Palette ID
	jsr     VDP_LoadMapBlockSegmentPlaneA
	
	; Restore source/dest rects, width/height, loop counter and overflow
	POPM    a0-a1/d0-d5
	
	; Continue second half of column from top of scroll plane
	add.w	d2, d0		; Advance source top by last height
	move.w	d5, d2		; Overflow is new height
	move.w	#0x0, d1	; Dest top
	
	; Loop
	dbra	d4, @Loop
	
	@End:
	rts
