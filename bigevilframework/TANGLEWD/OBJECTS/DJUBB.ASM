;==============================================================
;   TANGLEWOOD - A game by Matt Phillips - (c) 2017
;==============================================================
;   http://www.bigevilcorporation.co.uk
;==============================================================
;   djubb.asm - Fish with sharp teeth, tastes awful
;==============================================================

; Constants
Djubb_Width				equ 0x28
Djubb_Height			equ 0x18
Djubb_Mass				equ 0x02
Djubb_SwimAccel			equ 0x001000
Djubb_SwimDecelIdle		equ 0x000800
Djubb_SwimDecelForced	equ 0x002000
Djubb_MaxSwimVel		equ 0x03E000
Djubb_MaxFloatVel		equ 0x010000
Djubb_FloatAccel		equ 0x000800
Djubb_FloatAccelTop		equ 0x000200
Djubb_WallBoundsLeft	equ -0x0010
Djubb_WallBoundsRight	equ Djubb_Width+0x0010
Djubb_WallProbeTop		equ 0x0000
Djubb_WallProbeBottom	equ Djubb_Height-1
Djubb_ProbeWallX		equ (Djubb_Width/2)-8	; Distance from centre to start wall search
Djubb_PlayerYViewDist	equ 0x20
Djubb_AttackDamage		equ 0xFF
Djubb_FloatSurfaceOffset	equ 0x10

Djubb_BoundsLeft		equ 0x0000
Djubb_BoundsTop			equ 0x000A
Djubb_BoundsWidth		equ Djubb_Width
Djubb_BoundsHeight		equ 0x0006

Djubb_SwimSFX			equ SFX_DjubbSwim2

; Animations
DjubbAnimIdx_Bite		equ 0x0
; -------------------------------
Djubb_NumAnims			equ 1

; Struct
	rsset (Character_Struct_Size)
;-----------------------------
Djubb_Animations		rs.b (Animation_Struct_Size*Djubb_NumAnims)
Djubb_PlayingSFX		rs.b 1
;-----------------------------
	RS_ALIGN
Djubb_Struct_Size		rs.b 0
;-----------------------------

DjubbInit:
	; a0 --- GameObj addr
	; a1 --- Level addr
	
	; Base functionality
	jsr CharacterInit
	
	; Count
	addq.w #0x1, EntityCount_Djubb
	
	; Set update and render routines
	move.l #DjubbUpdate, Entity_UpdateRoutine(a0)
	move.l #AnimObjDraw, Entity_RenderRoutine(a0)
	move.l #EntitySerialise, Entity_SerialiseRoutine(a0)
	
	; Add to update and render lists
	;jsr EntityAddToUpdateList
	;jsr EntityAddToRenderList
	jsr EntityAddToSerialiseList

	; Default properties
	move.w  #Djubb_Width, Entity_Width(a0)
	move.w  #Djubb_Height, Entity_Height(a0)
	MOVE_NTSC_L Djubb_MaxSwimVel, PhysicsObj_MaxVelFloorX(a0), d0
	MOVE_NTSC_L Djubb_MaxSwimVel, PhysicsObj_MaxVelAirX(a0), d0
	MOVE_NTSC_L Djubb_MaxFloatVel, PhysicsObj_MaxVelYUp(a0), d0
	MOVE_NTSC_ACCEL_W Djubb_SwimDecelIdle, PhysicsObj_DecelX(a0), d0
	move.w  #Djubb_WallBoundsLeft, PhysicsObj_WallBoundsLeft(a0)
	move.w  #Djubb_WallBoundsRight, PhysicsObj_WallBoundsRight(a0)
	move.w  #Djubb_WallProbeTop, PhysicsObj_WallProbeTop(a0)
	move.w  #Djubb_WallProbeBottom, PhysicsObj_WallProbeBottom(a0)
	move.w  #Djubb_ProbeWallX, PhysicsObj_WallProbeCentreX(a0)
	move.b  #Djubb_Mass, PhysicsObj_Mass(a0)
	move.b  #0x0, PhysicsObj_CollideCeilings(a0)
	move.b  #0x0, PhysicsObj_AffectedByGravity(a0)
	move.b  #0x0, PhysicsObj_AffectedByWind(a0)
	move.b  #0x1, PhysicsObj_DecelInAir(a0)
	move.b  #0x0, Djubb_PlayingSFX(a0)
	
	MOVE_NTSC_L Djubb_MaxSwimVel, Character_MaxVelXWalk(a0), d0
	MOVE_NTSC_L Djubb_MaxSwimVel, Character_MaxVelXRun(a0), d0
	MOVE_NTSC_L Djubb_MaxSwimVel, Character_WalkToRunVel(a0), d0
	MOVE_NTSC_ACCEL_W Djubb_SwimAccel, Character_AccelWalk(a0), d0
	MOVE_NTSC_ACCEL_W Djubb_SwimAccel, Character_AccelRun(a0), d0
	MOVE_NTSC_ACCEL_W Djubb_SwimDecelIdle, Character_DecelIdle(a0), d0
	MOVE_NTSC_ACCEL_W Djubb_SwimDecelForced, Character_DecelForced(a0), d0

	; Setup collision bounds
	move.w  #Djubb_BoundsLeft, PhysicsObj_BoundsLeft(a0)
	move.w  #Djubb_BoundsTop, PhysicsObj_BoundsTop(a0)
	move.w  #Djubb_BoundsWidth, PhysicsObj_BoundsWidth(a0)
	move.w  #Djubb_BoundsHeight, PhysicsObj_BoundsHeight(a0)

	rts

DjubbLoadGfx:
	; a0 --- GameObj addr
	; a1 --- Level addr

	; Load sprite
	SPRITE_LOAD_DEFAULT djubb,idle,0,PaletteId_Monster,0x0

	; Setup default character animations
	ANIM_LOAD_DEFAULT djubb,idle,idle,Character_Animations,CharacterAnimIdx_Idle,1,0,0
	ANIM_LOAD_DEFAULT djubb,swim,swim,Character_Animations,CharacterAnimIdx_Run,1,0,0
	ANIM_LOAD_DEFAULT djubb,swim,swim,Character_Animations,CharacterAnimIdx_Walk,1,0,0
	ANIM_LOAD_DEFAULT djubb,death,death,Character_Animations,CharacterAnimIdx_Dead,0,0,1

	; Setup bespoke character animations
	ANIM_LOAD_DEFAULT djubb,bite,bite,Djubb_Animations,DjubbAnimIdx_Bite,0,1,0

	; Add to world grid
	move.b  #(1<<EntityWorldGridFlag_GridUpdates)|(1<<EntityWorldGridFlag_GridRenders)|(1<<EntityWorldGridFlag_GridPhysics), d0
	jsr     EntityAddToWorldGrid

	rts

DjubbUpdate:
	; a0 --- GameObj addr
	; a1 --- Level addr

	; If dead, set buoyant and float upwards
	tst.b  Character_Dead(a0)
	bne    @Dead

	; Get player
	move.l (Player1), a2

	; If dead, don't bother
	tst.b  Character_Dead(a2)
	bne    @PlayerDead

	; If within Y window
	PHYSICS_GETBOUNDS d1,d2,d5,a0
	PHYSICS_GETBOUNDS d3,d4,d5,a2
	PUSHM  d1-d4
	jsr    PHYS_TestBoxIntersectBoxY
	POPM   d1-d4
	tst.b  d0
	beq    @PlayerOutOfView

	; If touching, bite
	jsr    PHYS_TestBoxIntersectBox
	tst.b  d0
	beq    @NotTouching

	; Attack
	PUSHL  a0
	move.l a2, a0
	move.b #Djubb_AttackDamage, d0
	jsr    CharacterDealDamage
	POPL   a0

	PUSHL  a1
	lea    Djubb_Animations+(DjubbAnimIdx_Bite*Animation_Struct_Size)(a0), a1
	move.b #0x0, d0
	move.l #0x0, a2
	move.l #0x0, a3
	jsr    AnimObjSetAnimation
	POPL   a1

	bra    @EndMove

	@NotTouching:

	; Move towards
	move.b PhysicsObj_HitWall(a0), d2
	ENTITY_GETCENTREX d0, a0
	ENTITY_GETCENTREX d1, a2
	sub.l  d0, d1
	tst.l  d1
	bgt    @MoveRight
	jsr    CharacterMoveLeft
	bra    @EndMove
	@MoveRight:
	jsr    CharacterMoveRight
	bra    @EndMove

	@PlayerOutOfView:

	jsr    CharacterCancelXMovement

	bra    @EndMove

	;==============================================================

	@Dead:

	; Cancel X move
	jsr    CharacterCancelXMovement

	; Set buoyant
	move.b #0x1, PhysicsObj_Buoyant(a0)

	; TODO: Move to physicsobj
	; TODO: Move floor probe to top so fish stays emerged
	subi.w #Djubb_FloatSurfaceOffset, Entity_WorldPosY(a0)
	jsr    DjubbTestUnderwater
	addi.w #Djubb_FloatSurfaceOffset, Entity_WorldPosY(a0)
	tst.b  PhysicsObj_Underwater(a0)
	beq    @OutOfWater
	MOVE_NTSC_ACCEL_W Djubb_FloatAccel, PhysicsObj_AccelY(a0), d0
	move.b #0x0, PhysicsObj_AffectedByGravity(a0)
	bra    @Underwater
	@OutOfWater:
	MOVE_NTSC_ACCEL_W Djubb_FloatAccelTop, PhysicsObj_AccelY(a0), d0
	move.b #0x1, PhysicsObj_AffectedByGravity(a0)
	@Underwater:

	;==============================================================

	@EndMove:
	@PlayerDead:

	; Base functionality
	jsr CharacterUpdate

	; Update swim SFX
	tst.l  PhysicsObj_VelX(a0)
	beq    @NotMoving
	PLAYSFX #Djubb_SwimSFX
	move.b #0x1, Djubb_PlayingSFX(a0)
	bra    @EndSFX
	@NotMoving:
	tst.b  Djubb_PlayingSFX(a0)
	beq    @EndSFX
	cmp.l  #Djubb_SwimSFX, audio_current_sfx
	bne    @EndSFX
	jsr    SND_StopSFX
	move.b #0x0, Djubb_PlayingSFX(a0)
	@EndSFX:
	
	rts

; TODO: Move to physicsobj
DjubbTestUnderwater:
	; a0 --- GameObj addr
	; a1 --- Level addr
	
	; Reset in water
	move.b #0x0, PhysicsObj_Underwater(a0)

	;==============================================================
	
	; Check all water bodies
	move.l (EntityPoolStart_WaterBody), a2
	move.w (EntityCount_WaterBody), d6
	beq    @NoWaterBodies
	subq.w #0x1, d6
	@BodyLoop:
	
	; Check player vs. box
	PUSHL  d5
	ENTITY_GETBOUNDS d1,d2,d3,a0
	ENTITY_GETBOUNDS d3,d4,d5,a2
	jsr    PHYS_TestBoxIntersectBox
	POPL   d5
	tst.b  d0
	beq    @NoIntersect
	
	; Set in water
	move.b #0x1, PhysicsObj_Underwater(a0)

	bra    @Found
	
	@NoIntersect:
	
	; Next body
	lea  WaterBody_Struct_Size(a2), a2
	dbra d6, @BodyLoop
	
	@NoWaterBodies:

	;==============================================================

	; Check all water pools
	move.l (EntityPoolStart_Pool), a2
	move.w (EntityCount_Pool), d6
	beq    @NoPools
	subq.w #0x1, d6
	@PoolLoop:
	
	; Check player vs. box
	PUSHL  d5
	ENTITY_GETBOUNDS d1,d2,d3,a0
	ENTITY_GETBOUNDS d3,d4,d5,a2
	lea    Pool_Platform(a2), a3	; Use pool platform Y as bounds top
	move.w Platform_PosY(a3), d3
	PUSHL  d3
	jsr    PHYS_TestBoxIntersectBox
	POPL   d3
	POPL   d5
	tst.b  d0
	beq    @NoIntersectPool
	
	; Set in water
	move.b #0x1, PhysicsObj_Underwater(a0)

	bra    @Found
	
	@NoIntersectPool:
	
	; Next body
	lea  Pool_Struct_Size(a2), a2
	dbra d6, @PoolLoop
	
	@NoPools:

	;==============================================================

	; Check all water terrain
	move.w Entity_WorldPosX(a0), d0
	move.w Entity_WorldPosY(a0), d4
	add.w  Entity_Height(a0), d4
	subi.w #vdp_sprite_border_x, d0
	subi.w #vdp_sprite_border_y, d4

	move.w Level_NumTerrainDescs(a1), d6	; Get 'special' terrain count
	beq    @NoWaterTerrain
	subq.w  #0x1, d6						; -1 for loop counter
	move.l Level_TerrainDescAddr(a1), a2	; Get 'special' terrain desc table

	@TerrainLp:
	
	; Get terrain spline start/end/flags
	move.l (a2)+, d1
	move.l (a2)+, d2
	move.w (a2)+, d3

	; Check water type
	andi.w #col_tile_flag_water, d3
	beq    @NextTerrain

	; Get X
	swap   d1
	swap   d2

	; Check if within X bounds
	cmp.w  d0, d1
	bge    @NextTerrain
	cmp.w  d0, d2
	ble    @NextTerrain

	; Check under surface
	swap   d1
	cmp.w  d1, d4
	blt    @NextTerrain

	; Set in water
	move.b #0x1, PhysicsObj_Underwater(a0)

	bra    @Found
	
	@NextTerrain:
	dbra   d6, @TerrainLp
	bra    @NoWaterTerrain

	@NoWaterTerrain:

	;==============================================================

	@Found:
	
	rts