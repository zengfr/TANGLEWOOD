;==============================================================
;   BIG EVIL FRAMEWORK - Matt Phillips (c) 2015
;==============================================================
;   http://www.bigevilcorporation.co.uk
;==============================================================
;   character.asm - Character structure and routines
;==============================================================

; ************************************
; Constants
; ************************************
Character_LandVel		    equ 0x020000
Character_FallVel		    equ 0x020000
Character_WaterSplashVel	equ 0x010000

Character_PushLight			equ 0x1
Character_PushHeavy			equ 0x2

Character_WalkInteract			equ 0x1
Character_WalkWater				equ 0x2
Character_WalkRollingPlatform	equ 0x3
Character_WalkGeneral			equ 0x4
Character_WalkAI				equ 0x5

Character_RollingObjCentre		equ 0x8

; ************************************
; Animation ids
; ************************************
CharacterAnimIdx_Idle		equ 0
CharacterAnimIdx_Dead		equ 1
CharacterAnimIdx_Run		equ 2
CharacterAnimIdx_Walk		equ 3
CharacterAnimIdx_Jump		equ 4
CharacterAnimIdx_Hang		equ 5
CharacterAnimIdx_Glide		equ 6
CharacterAnimIdx_Push		equ 7
CharacterAnimIdx_PushHeavy	equ 8
CharacterAnimIdx_Fall		equ 9
CharacterAnimIdx_WalkToRun	equ 10
CharacterAnimIdx_WaterWade	equ 11
CharacterAnimIdx_RideTrot	equ 12
CharacterAnimIdx_RideGallop	equ 13
CharacterAnimIdx_RideJump	equ 14
CharacterAnimIdx_Climb		equ 15
CharacterAnimIdx_TakeDamage	equ 16
; -------------------------------
Character_NumAnims			equ 17

; ************************************
; SFX ids
; ************************************
CharacterSFXIdx_Land		equ 0
CharacterSFXIdx_WaterSplash	equ 1
CharacterSFXIdx_WaterJump	equ 2
; -------------------------------
Character_NumSFX			equ 3

; ************************************
; Character struct
; ************************************

; Struct
	rsset (PhysicsObj_Struct_Size)
;---------------------------------
	LINKED_LIST_NODE Characters		; Linked list entry for characters
;---------------------------------
Character_InteractStartA	rs.l 1	; Interact routine type A address
Character_InteractCancelA	rs.l 1	; Cancel interact routine type A address
Character_InteractStartB	rs.l 1	; Interact routine type B address
Character_InteractCancelB	rs.l 1	; Cancel interact routine type B address
Character_Animations		rs.b (Animation_Struct_Size*Character_NumAnims)
Character_SFX				rs.l Character_NumSFX
Character_JumpVelX			rs.l 1
Character_JumpVelY			rs.l 1
Character_JumpCancelVelLo	rs.l 1
Character_JumpCancelVelHi	rs.l 1
Character_MaxVelXRun		rs.l 1
Character_MaxVelXWalk		rs.l 1
Character_WalkToRunVel		rs.l 1
Character_ClimbVel			rs.l 1
Character_AccelRun			rs.w 1
Character_AccelWalk			rs.w 1
Character_DecelIdle			rs.w 1
Character_DecelForced		rs.w 1
Character_ControlX			rs.b 1
Character_ControlY			rs.b 1
Character_CanJump			rs.b 1
Character_CanClimb			rs.b 1
Character_CanUseRollPlatform rs.b 1
Character_CanFall			rs.b 1
Character_Walking			rs.b 1
Character_Jumping			rs.b 1
Character_Falling			rs.b 1
Character_Pushing			rs.b 1	; 1 = Light object, 2 = Heavy object
Character_Gliding			rs.b 1
Character_Riding			rs.b 1	; 1 = Trotting, 2 = Galloping
Character_Climbing			rs.b 1
Character_Interacting		rs.b 1
Character_CanCancelJump		rs.b 1	; Letting go of jump button early cancels jump
Character_UpdateAnim		rs.b 1
Character_AnimIdx	    	rs.b 1
Character_Health        	rs.b 1
Character_Dead          	rs.b 1
Character_LockSpriteFlip	rs.b 1	; Don't change flip direction
Character_InvertSpriteFlip	rs.b 1	; Invert flip direction
Character_JumpScaleX		rs.b 1	; Jump vel X is a scalar, not impulse
;---------------------------------
	RS_ALIGN
Character_Struct_Size   	rs.b 0

;==============================================================
; Character initialisation
;==============================================================

CharacterInit:

	; Base functionality
	jsr PhysicsObjInit
	
	; Set type
	ori.l  #entity_type_character, Entity_TypeBits(a0)

	; Add to characters list
	LIST_APPEND_TAIL Characters, a0, a3

	; Default state
	move.l #0x0, Character_InteractStartA(a0)
	move.l #0x0, Character_InteractCancelA(a0)
	move.l #0x0, Character_InteractStartB(a0)
	move.l #0x0, Character_InteractCancelB(a0)
	move.b #0x1, Character_CanJump(a0)
	move.b #0x0, Character_CanClimb(a0)
	move.b #0x0, Character_CanUseRollPlatform(a0)
	move.b #0x1, Character_CanFall(a0)
	move.b #0x0, Character_Walking(a0)
	move.b #0x0, Character_Jumping(a0)
	move.b #0x0, Character_Pushing(a0)
	move.b #0x0, Character_Gliding(a0)
	move.b #0x0, Character_Riding(a0)
	move.b #0x0, Character_Climbing(a0)
	move.b #0x0, Character_Interacting(a0)
	move.b #0x0, Character_CanCancelJump(a0)
	move.b #0x1, Character_UpdateAnim(a0)
	move.b #0xFF, Character_Health(a0)
	move.b #0x0, Character_Dead(a0)
	move.b #0x0, Character_LockSpriteFlip(a0)
	move.b #0x0, Character_InvertSpriteFlip(a0)
	move.b #0x0, Character_ControlX(a0)
	move.b #0x0, Character_ControlY(a0)
	move.b #0x0, Character_JumpScaleX(a0)

	rts
	
;==============================================================
; Character update routines
;==============================================================

CharacterUpdate:
	; a0 --- GameObj addr
	; a1 --- Level addr

	; Store current floor flag and Y velocity to check landing
	move.b PhysicsObj_OnFloor(a0), d0
	move.l PhysicsObj_VelY(a0), d1
	PUSHL  d0
	PUSHL  d1
	
	; Base functionality
	jsr PhysicsObjUpdate
	
	; Retrieve floor flag and Y velocity
	POPL   d1
	POPL   d0
	
	; If on floor, no longer jumping or falling
	tst.b  PhysicsObj_OnFloor(a0)
	beq    @OffFloor
	move.b #0x0, Character_Jumping(a0)
	move.b #0x0, Character_Falling(a0)
	move.b #0x0, Character_CanCancelJump(a0)

	; =====================================================================
	
	; If hit floor at landing velocity
	cmp.l  #-Character_LandVel, PhysicsObj_FloorImpactVelY(a0)
	bge    @LowLandVel
	
	; Play land SFX
	lea    (Character_SFX+(CharacterSFXIdx_Land*size_long))(a0), a2
	tst.l  (a2)
	beq    @NoLandSFX
	PLAYSFX (a2)
	@NoLandSFX:
	
	@OffFloor:
	@PrevOnFloor:
	@LowLandVel:
	
	; If off floor, affect by gravity, and Y vel < falling vel, set as falling
	tst.b  Character_CanFall(a0)
	beq    @NotFalling
	tst.b  PhysicsObj_CloseToFloor(a0)
	bne    @NotFalling
	tst.b  PhysicsObj_AffectedByGravity(a0)
	beq    @NotFalling
	cmp.l  #-Character_FallVel, d1
	bge    @NotFalling
	move.b #0x1, Character_Falling(a0)
	@NotFalling:
 
	; If not locked, apply sprite flipping
	tst.b Character_LockSpriteFlip(a0)
	bne   @FlipLocked
	jsr   CharacterApplySpriteFlip
	@FlipLocked:

	tst.b Character_UpdateAnim(a0)
	beq   @ManualAnim
	jsr   CharacterUpdateAnimState
	@ManualAnim:

	; Update rolling platforms
	jsr   CharacterUpdateRollingPlatform
	
	; Reset control
	move.b #0x0, Character_ControlX(a0)
	move.b #0x0, Character_ControlY(a0)
	
	rts

CharacterUpdateRollingPlatform:
	; a0 --- GameObj addr
	; a1 --- Level addr

	; Clear reverse animation
	move.b #0x0, AnimObj_Reverse(a0)

	; If can use rolling platform
	tst.b  Character_CanUseRollPlatform(a0)
	beq    @NotRollingPlatform

	; Clear rolling platform walk flag
	btst.b #Character_WalkRollingPlatform, Character_Walking(a0)
	beq    @NoClearWalkFlag
	move.b #Character_WalkRollingPlatform, d2
	jsr    CharacterAllowRun
	@NoClearWalkFlag:

	; If on a rolling platform
	tst.b  PhysicsObj_OnPlatform(a0)
	beq    @NotOnPlatform
	move.l PhysicsObj_LastPlatform(a0), a2
	beq    @NotOnPlatform
	cmp.b  #PlatformType_Rolling, Platform_Type(a2)
	bne    @NotRollingPlatform

	; If rolling object isn't hitting a wall
	move.l Platform_Owner(a2), a3
	PHYSICS_HITFACINGWALL a3
	tst.b  d0
	bne    @PlatformHittingWall

	; If within centre
	ENTITY_GETCENTREX d0,a0
	ENTITY_GETCENTREX d1,a3
	sub.l  d1, d0
	ABS    d0
	TOPIXELS d0
	cmp.w  #Character_RollingObjCentre, d0
	bgt    @OutOfCentre

	; Match rolling object velocity
	move.l PhysicsObj_VelX(a0), PhysicsObj_ImpulseX(a3)

	@OutOfCentre:

	; Cannot run
	move.b #Character_WalkRollingPlatform, d2
	jsr    CharacterPreventRun

	; Reverse walk animation
	move.b #0x1, AnimObj_Reverse(a0)

	@NotOnPlatform:
	@NotRollingPlatform:
	@PlatformHittingWall:

	rts
	
CharacterDealDamage:
	; a0 --- GameObj addr
	; a1 --- Level addr
	; d0 (b) Damage to deal
	
	; TODO - Damage/death anim type
	
	; Get current health
	move.b Character_Health(a0), d1
	
	; If already dead, do nothing
	beq    @AlreadyDead

	; Cancel all actions
	PUSHMW d0-d1
	jsr    CharacterCancelXMovement
	jsr    CharacterCancelJump
	move.b #0x0, Character_Interacting(a0)
	
	; Cancel velocity
	move.l #0x0, PhysicsObj_VelX(a0)
	move.l #0x0, PhysicsObj_VelY(a0)
	POPMW  d0-d1
	
	; Subtract health
	sub.b  d0, d1
	bcc    @NoClamp	; Branch if Carry Clear (did not wrap to zero)
	move.b #0x0, d1	; Clamp to 0
	@NoClamp:
	move.b d1, Character_Health(a0)
	
	; Check if depleted
	tst.b  d1
	bne    @StillAlive
	
	; Health reached zero, character is dead
	IF !AUTOTEST_ENABLED
	move.b #0x1, Character_Dead(a0)
	ENDIF

	bra    @AlreadyDead

	@StillAlive:

	; Play take damage anim
	PUSHL  a1
	lea    Character_Animations+(CharacterAnimIdx_TakeDamage*Animation_Struct_Size)(a0), a1
	move.b #0x0, d0
	move.l #0x0, a2
	move.l #0x0, a3
	jsr    AnimObjSetAnimation
	POPL   a1

	@AlreadyDead:
	
	rts
	
CharacterApplySpriteFlip:

	; Sprite X flip direction
	move.l PhysicsObj_VelX(a0), d0
	tst.l  d0
	beq    @NoFlip
	blt    @FlipLeft
	@FlipRight:
	move.b #0x0, SpriteObj_FlippedX(a0)
	bra    @EndFlip
	@FlipLeft:
	move.b #0x1, SpriteObj_FlippedX(a0)
	@EndFlip:

	tst.b  Character_InvertSpriteFlip(a0)
	beq    @NoInvert
	eor.b  #0x1, SpriteObj_FlippedX(a0)
	@NoInvert:

	@NoFlip:
	
	rts
	
CharacterUpdateAnimState:
	; a0 --- GameObj addr
	; a1 --- Level addr
	
	;Get current animation
	move.l AnimObj_CurrentAnim(a0), a2
	
	tst.b  Animation_Looping(a2)	; If playing a looping anim, anim is interruptible
	bne    @InterruptibleAnim
	
	tst.b  AnimObj_Playing(a0)		; If interruptible anim has finished, start next anim
	beq    @AnimFinished
	bra	   @EndAnim
	
	@InterruptibleAnim:
	@AnimFinished:
	
	moveq #0x0, d1

	; =====================================================================
	; Dead
	; =====================================================================
	move.b #CharacterAnimIdx_Dead, d1
	tst.b  Character_Dead(a0)			; If player dead, set death anim
	bne    @SetAnim
	
	; =====================================================================
	; Gliding
	; =====================================================================
	move.b #CharacterAnimIdx_Glide, d1
	tst.b  Character_Gliding(a0)		; If player is gliding, set glide anim
	bne    @SetAnim

	; =====================================================================
	; Riding (trotting)
	; =====================================================================
	move.b #CharacterAnimIdx_RideTrot, d1
	move.b Character_Riding(a0), d0		; If player is riding, set ride anim
	cmp.b  #0x1, d0
	beq    @SetAnim

	; =====================================================================
	; Riding (galloping)
	; =====================================================================
	move.b #CharacterAnimIdx_RideGallop, d1
	move.b Character_Riding(a0), d0		; If player is riding, set ride anim
	cmp.b  #0x2, d0
	beq    @SetAnim

	; =====================================================================
	; Climbing
	; =====================================================================
	move.b #CharacterAnimIdx_Climb, d1
	tst.b  Character_Climbing(a0)		; If player is climbing, set climb anim
	bne    @SetAnim
	
	; =====================================================================
	; Jumping
	; =====================================================================
	move.b #CharacterAnimIdx_Jump, d1
	tst.b  Character_Jumping(a0)		; If player is jumping, set jump anim
	bne    @SetAnim
	
	; =====================================================================
	; Falling
	; =====================================================================
	move.b #CharacterAnimIdx_Fall, d1
	tst.b  Character_Falling(a0)		; If player is falling, set fall anim
	bne    @SetAnim
	
	; =====================================================================
	; Pushing (light object)
	; =====================================================================
	move.b #CharacterAnimIdx_Push, d1
	move.b Character_Pushing(a0), d0	; If player is pushing, set push anim
	cmp.b  #Character_PushLight, d0
	beq    @SetAnim
	
	; =====================================================================
	; Pushing (heavy object)
	; =====================================================================
	move.b #CharacterAnimIdx_PushHeavy, d1
	move.b Character_Pushing(a0), d0	; If player is pushing, set push anim
	cmp.b  #Character_PushHeavy, d0
	beq    @SetAnim
	
	; =====================================================================
	; Idle
	; =====================================================================
	move.b #CharacterAnimIdx_Idle, d1
	tst.l PhysicsObj_VelX(a0)			; If X velocity == 0, set idle anim
	beq    @SetAnim

	; =====================================================================
	; Running/Walking
	; =====================================================================
	move.l PhysicsObj_VelX(a0), d0		; If X velocity > WalkToRun speed, set run anim
	cmp.l  Character_WalkToRunVel(a0), d0
	bgt    @Running
	neg.l  d0
	cmp.l  Character_WalkToRunVel(a0), d0
	bgt    @Running
	bra    @Walking
	
	; Running
	@Running:
	
	; If in water, set water wade anim
	move.b #CharacterAnimIdx_WaterWade, d1
	cmp.b  #0x1, PhysicsObj_Underwater(a0)
	beq    @SetAnim

	; If transitioning from walking/jumping/falling anim, set transition anim
	move.b #CharacterAnimIdx_WalkToRun, d1
	cmp.b  #CharacterAnimIdx_Walk, Character_AnimIdx(a0)
	beq    @SetAnim
	cmp.b  #CharacterAnimIdx_Jump, Character_AnimIdx(a0)
	beq    @SetAnim
	cmp.b  #CharacterAnimIdx_Fall, Character_AnimIdx(a0)
	beq    @SetAnim
	
	; else set running anim
	move.b #CharacterAnimIdx_Run, d1
	bra    @SetAnim
	
	; Walking
	@Walking:
	
	; If in water, set water wade anim
	move.b #CharacterAnimIdx_WaterWade, d1
	cmp.b  #0x1, PhysicsObj_Underwater(a0)
	beq    @SetAnim

	; If transitioning from running anim, set transition anim
	move.b #CharacterAnimIdx_WalkToRun, d1
	cmp.b  #CharacterAnimIdx_Run, Character_AnimIdx(a0)
	beq    @SetAnim
	
	; else set walking anim
	move.b #CharacterAnimIdx_Walk, d1

	@SetAnim:

	; Set anim index
	move.b d1, Character_AnimIdx(a0)
	
	; Get anim struct address from character
	PUSHL  a1
	lea    Character_Animations(a0), a1
	mulu   #Animation_Struct_Size, d1
	add.l  d1, a1
	
	; Apply animation
	move.b #0x0, d0
	move.l #0x0, a2
	move.l #0x0, a3
	jsr AnimObjSetAnimation
	
	POPL   a1

	@EndAnim:
	
	rts

;==============================================================
; Character control
;==============================================================

CharacterMoveLeft:
	; a0 --- GameObj addr
	; NB: Gamepad state in d0-d1, leave alone

	; Set control
	move.b #-1, Character_ControlX(a0)
	
	; Check if player dead
	tst.b  Character_Dead(a0)
	bne    @End

	; Check if player climbing
	tst.b  Character_Climbing(a0)
	bne    @End
	
	; Check if heading in opposite direction
	tst.l  PhysicsObj_VelX(a0)
	bgt    @Decelerate
	
	; Check if running or walking
	tst.b  Character_Walking(a0)
	bne    @Else
	clr.w  d5
	sub.w  Character_AccelRun(a0), d5
	move.w d5, PhysicsObj_AccelX(a0)
	bra    @End
	@Else:
	clr.w  d5
	sub.w  Character_AccelWalk(a0), d5
	move.w d5, PhysicsObj_AccelX(a0)
	bra    @End
	
	@Decelerate:
	
	; Heading in opposite direction, fast deceleration
	clr.w  d5
	sub.w  Character_DecelForced(a0), d5
	move.w d5, PhysicsObj_AccelX(a0)
	
	@End:
	
	rts
	
CharacterMoveRight:
	; a0 --- GameObj addr
	; NB: Gamepad state in d0-d1, leave alone
	
	; Set control
	move.b #1, Character_ControlX(a0)

	; Check if player dead
	tst.b  Character_Dead(a0)
	bne    @End

	; Check if player climbing
	tst.b  Character_Climbing(a0)
	bne    @End
	
	; Check if heading in opposite direction
	tst.l  PhysicsObj_VelX(a0)
	blt    @Decelerate
	
	; Check if running or walking
	tst.b  Character_Walking(a0)
	bne    @Else
	move.w Character_AccelRun(a0), PhysicsObj_AccelX(a0)
	bra    @End
	@Else:
	move.w Character_AccelWalk(a0), PhysicsObj_AccelX(a0)
	bra    @End
	
	@Decelerate:

	; Heading in opposite direction, fast deceleration
	move.w  Character_DecelForced(a0), PhysicsObj_AccelX(a0)
	
	@End:
	
	rts

CharacterMoveUp:
	; a0 --- GameObj addr
	; NB: Gamepad state in d0-d1, leave alone

	; If climbing available
	tst.b   Character_CanClimb(a0)
	beq     @NotClimbing

	; Can move up
	move.b #1, Character_ControlY(a0)

	@NotClimbing:

	rts

CharacterMoveDown:
	; a0 --- GameObj addr
	; NB: Gamepad state in d0-d1, leave alone

	; If climbing available
	tst.b   Character_CanClimb(a0)
	beq     @NotClimbing

	; Can move down
	move.b #-1, Character_ControlY(a0)

	; Force physics step to check for floors
	move.b #0x1, PhysicsObj_ForceUpdate(a0)

	@NotClimbing:

	rts

CharacterCancelXMovement:
	; a0 --- GameObj addr
	; NB: Gamepad state in d0-d1, leave alone
	
	move.w #0x0, PhysicsObj_AccelX(a0)
	move.b #0x0, Character_ControlX(a0)
	move.b #0x0, Character_ControlY(a0)

	rts

CharacterCancelYMovement:
	; a0 --- GameObj addr
	; NB: Gamepad state in d0-d1, leave alone
	
	move.w #0x0, PhysicsObj_AccelY(a0)
	move.b #0x0, Character_ControlY(a0)

	rts
	
CharacterStartJump:
	; a0 --- GameObj addr
	; NB: Gamepad state in d0-d1, leave alone
	; d2 (b) Force (ignore all tests)

	PUSHM  d0-d1

	; Check if jump is to be forced
	tst.b d2
	bne   @CanJump

	; Check if player can jump
	tst.b Character_CanJump(a0)
	beq   @CantJump
	
	; Check if player dead
	tst.b  Character_Dead(a0)
	bne    @Dead

	; Check if player is riding
	tst.b  Character_Riding(a0)
	bne    @CanJump
	
	; Check if player is interacting
	cmp.b  #0x1, Character_Interacting(a0)
	beq    @CantJump

	; Check if player climbing
	tst.b  Character_Climbing(a0)
	bne    @CanJump
	
	; Check if player close enough to floor to jump
	tst.b  PhysicsObj_CloseToFloor(a0)
	beq    @CantJump

	@CanJump:

	; Set off floor
	move.b #0x0, PhysicsObj_OnFloor(a0)
	move.b #0x0, PhysicsObj_CloseToFloor(a0)
	move.w #0x0, PhysicsObj_LastFloor(a0)
	move.l #0x0, PhysicsObj_LastPlatform(a0)

	; Wake physics
	move.b #0x0, PhysicsObj_Asleep(a0)
	
	; Set Y velocity
	move.l Character_JumpVelY(a0), PhysicsObj_VelY(a0)

	tst.b  Character_JumpScaleX(a0)
	bne    @JumpScaleX

	; Set min X velocity
	move.l Character_JumpVelX(a0), d0
	move.l PhysicsObj_VelX(a0), d1
	tst.b  SpriteObj_FlippedX(a0)
	beq    @Positive
	neg.l  d0
	cmp.l  d1, d0
	bgt    @EndXVel
	move.l d0, PhysicsObj_VelX(a0)
	bra    @EndXVel
	@Positive:
	cmp.l  d1, d0
	blt    @EndXVel
	move.l d0, PhysicsObj_VelX(a0)
	@EndXVel:
	bra    @EndJumpX

	@JumpScaleX:

	; Jump X is scalar
	move.l PhysicsObj_VelX(a0), d0
	move.l Character_JumpVelX(a0), d1
	jsr    Muls1616

	; Clamp to max X in-air vel
	move.l PhysicsObj_MaxVelAirX(a0), d1
	move.l d1, d2
	neg.l  d1
	CLAMPL d0, d1, d2
	move.l d0, PhysicsObj_VelX(a0)

	@EndJumpX:

	; Set jumping
	move.b #0x1, Character_Jumping(a0)

	; Jumped from floor, can cancel
	move.b #0x1, Character_CanCancelJump(a0)
	
	bra    @End

	tst.b  PhysicsObj_Underwater(a0)
	beq    @NoWaterJumpSFX

	; Play water jump SFX
	lea    (Character_SFX+(CharacterSFXIdx_WaterJump*size_long))(a0), a2
	tst.l  (a2)
	beq    @NoWaterJumpSFX
	PLAYSFX (a2)
	@NoWaterJumpSFX:
	
	@Dead:
	@CantJump:
	@End:

	POPM   d0-d1
	
	rts
	
CharacterCancelJump:	
	; a0 --- GameObj addr
	; NB: Gamepad state in d0-d1, leave alone

	PUSHM  d0-d1
	
	; Check if player dead
	tst.b  Character_Dead(a0)
	bne    @Dead
	
	; Check if jumping
	tst.b  Character_Jumping(a0)
	beq    @NotJumping

	; Check if jump can be canceled
	tst.b  Character_CanCancelJump(a0)
	beq    @NotJumping
	
	; Check if not gliding
	tst.b  Character_Gliding(a0)
	bne    @Gliding
	
	; Check if Y vel is greater than min jump cancel vel
	move.l PhysicsObj_VelY(a0), d4
	cmp.l  Character_JumpCancelVelLo(a0), d4
	ble    @VelTooLow
	
	; Check if Y vel is lower than max jump cancel vel
	cmp.l  Character_JumpCancelVelHi(a0), d4
	bge    @VelTooHigh
	
	; Cancel jump
	move.l Character_JumpCancelVelLo(a0), PhysicsObj_VelY(a0)
	
	@Dead:
	@NotJumping:
	@Gliding:
	@VelTooLow:
	@VelTooHigh:

	POPM   d0-d1
	
	rts
	
CharacterAllowRun:
	; a0 --- GameObj addr
	; NB: Gamepad state in d0-d1, leave alone
	; d2 (b) Reason bit (CharacterWalk_*)

	PUSHM  d0-d1
	
	; Clear walking flags
	bclr.b d2, Character_Walking(a0)

	; Set max X velocity and snap to floor flag
	tst.b  Character_Walking(a0)
	beq    @Running
	move.l Character_MaxVelXWalk(a0), PhysicsObj_MaxVelFloorX(a0)
	move.b #0x0, PhysicsObj_SnapToFloor(a0)
	bra    @Walking
	@Running:
	move.l Character_MaxVelXRun(a0), PhysicsObj_MaxVelFloorX(a0)
	move.b #0x1, PhysicsObj_SnapToFloor(a0)
	@Walking:
	
	@Dead:
	@CantRun:

	POPM   d0-d1
	
	rts
	
CharacterPreventRun:
	; a0 --- GameObj addr
	; NB: Gamepad state in d0-d1, leave alone
	; d2 (b) Reason bit (CharacterWalk_*)

	PUSHM  d0-d1
	
	; Clear running flag
	bset.b d2, Character_Walking(a0)

	; Set max X velocity and snap to floor flag
	tst.b  Character_Walking(a0)
	beq    @Running
	move.l Character_MaxVelXWalk(a0), PhysicsObj_MaxVelFloorX(a0)
	move.b #0x0, PhysicsObj_SnapToFloor(a0)
	bra    @Walking
	@Running:
	move.l Character_MaxVelXRun(a0), PhysicsObj_MaxVelFloorX(a0)
	move.b #0x1, PhysicsObj_SnapToFloor(a0)
	@Walking:

	POPM   d0-d1
	
	rts

CharacterStartInteractA:
	move.l Character_InteractStartA(a0), a2
	cmpa.w #0x0, a2
	beq    @NoInteract
	jsr    (a2)
	@NoInteract:
	rts
	
CharacterCancelInteractA:
	move.l Character_InteractCancelA(a0), a2
	cmpa.w #0x0, a2
	beq    @NoInteract
	jsr    (a2)
	@NoInteract:
	rts

CharacterStartInteractB:
	move.l Character_InteractStartB(a0), a2
	cmpa.w #0x0, a2
	beq    @NoInteract
	jsr    (a2)
	@NoInteract:
	rts
	
CharacterCancelInteractB:
	move.l Character_InteractCancelB(a0), a2
	cmpa.w #0x0, a2
	beq    @NoInteract
	jsr    (a2)
	@NoInteract:
	rts
