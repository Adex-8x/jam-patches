.org 0x023A7080+0x30F70+0x450+0xB0+0x38+0x150+0x110+0x3A0
.area 0x400


FigmentHook:
	; This is the end of the function, we can mess with r5-r7!
	bl IsCurrentFixedRoomBossFight
	ldr r5,[r4,#+0xB4]
	ldrb r1,[r5,#0x6]
	cmp r0,#0
	cmpeq r1,#1
	bne figment_ret ; We don't want this for bosses or team members...
	ldrh r0,[r5,#+0x2]
	bl HasMonsterBeenIdentified
	cmp r0,#0
	bne figment_ret
	; It hasn't been identified; change its sprite!
	mov r0,r4
	ldr r1,=#581
	bl ChangeMonsterSprite
figment_ret:
	mov r0,r4
	b EndFigmentHook

PartnerHook:
	; r10 = Partner Entity Pointer, r9 = Partner Monster Pointer
	bl IsCurrentFixedRoomBossFight
	ldrb r1,[r9,#+0x48]
	cmp r1,#0xD7
	cmpeq r0,#0
	addne r1,r13,#0x8 ; Original instruction
	bne NotPartner
	; Add a check for if Amber is being talked to from far away!
	mov r11,r5
	bl GetLeader
	mov r1,r10
	bl AreEntitiesAdjacent
	cmp r0,#0
	moveq r1,#300
	addeq r1,r1,#2
	moveq r0,r11
	beq setup_failure_string
	; This is where the fun begins...
	; TODO: Probably a Belly check.
	add r0,r13,#0x8
	mov r1,#300
	mov r2,#1
	mov r3,#0
	bl YesNoMenu
	cmp r0,#1
	bne ExitAllyTalk
	; Attempt to identify adjacent enemies!
	mov r0,#0
	str r0,[SMEARGLE_FLAG]
	mov r8,#0 ; Flag: Identified any enemy
	mov r5,#0 ; Direction Counter
	ldr r4,=DIRECTIONS_XY
	b direction_loop_next_iter
direction_loop:
	mov r1,r5,lsl #0x2
	add r0,r4,r5,lsl #0x2
	ldrsh r3,[r4,r1]
	ldrsh r12,[r10,#0x4]
	ldrsh r1,[r0,#0x2]
	ldrsh r2,[r10,#0x6]
	add r0,r12,r3
	add r1,r2,r1
	bl GetTile
	ldr r0,[r0,#+0xC]
	mov r7,r0
	bl EntityIsValid
	cmp r0,#0
	beq direction_loop_nope
	; Okay, so the entity is valid. Is it on our team?
	ldr r12,[r7,#+0xB4]
	ldrb r1,[r12,#0x6]
	;ldrb r2,[r12,#0x8]
	cmp r1,#0
	;cmpeq r2,#0
	beq direction_loop_nope
	; Let's identify them!
	ldrsh r6,[r12,#+0x2]
	mov r0,r6
	bl HasMonsterBeenIdentified
	cmp r0,#0
	bne direction_loop_nope
	cmp r8,#0
	bne no_animation
	; Let's do a cool animation!
	mov r0,r10
	mov r1,#9 ; Double Anim
	ldrb r2,[r9,#+0x4C]
	bl SetEntityAnimation
	mov r0,#0xFF
	strb r0,[r10,#+0xAF]
	ldrsh r0,[r9,#+0x4]
	bl GetSpriteIndex
	mov r1,r0
	mov r0,#1
	bl UNK_FUNC_1
	ldrb r1,[r10,#+0xAE]
	bl UNK_FUNC_0
	cmp r0,#0
	movne r0,#1
	strb r0,[r10,#+0x28]
	mov r0,#0
	strb r0,[r10,#+0x21]
	; Fades screen to white
	mov r0,FADE_OUT
	mov r1,#0xFE0
	bl FadeBothScreensWhite
	mov r0,r10
	ldr r1,=#597
	bl LoadAndPlayAnimation
	mov r8,#1
no_animation:
	mov r0,r6
	bl IdentifySpecies
	; Check for Smeargle
	ldr r0,=#537
	cmp r6,r0
	addne r0,r0,#600
	cmpne r6,r0
	moveq r0,#1
	streq r0,[SMEARGLE_FLAG]
	; TODO: Maybe subtract Belly?
direction_loop_nope:
	add r5,r5,#1
direction_loop_next_iter:
	cmp r5,#8
	blt direction_loop
	; Play a sound effect!
	cmp r8,#0
	beq no_enemies_identified
	mov r0,#3
	bl WaitManyFrames
	mov r0,FADE_IN
	mov r1,#0x1400
	bl FadeBothScreensWhite
	ldr r0,=#1030
	mov r1,#0x100
	mov r2,#0x1F
	bl PlaySE
	mov r0,#24
	bl WaitManyFrames
	; Check Smeargle flag
	ldreq r0,[SMEARGLE_FLAG]
	cmp r0,#0
	beq ExitAllyTalk
	; Display a string and exit the floor!
	mov r0,#0
	bl StopMusic
	add r0,r13,#0x8
	ldr r1,=#537
	mov r2,#0
	bl InitPortraitData
	mov r0,r11
	mov r1,#300
	add r1,r1,#3
	bl GetStringFromFileVeneer
	mov r0,#0
	add r1,r13,#0x8
	mov r2,r11
	mov r3,#1
	bl ExecuteDialogue
	ldr r0,=DungeonBaseStructPtr
	ldr r0,[r0]
	mov r1,#1
	strb r1,[r0,#+0x6]
	b ExitAllyTalk
no_enemies_identified:
	mov r0,r10
	mov r1,#62
	bl LoadAndPlayAnimation
	mov r0,r11
	mov r1,#300
	add r1,r1,#1
setup_failure_string:
	bl GetStringFromFileVeneer
	add r0,r13,#0x8
	ldrsh r1,[r9,#+0x4]
	mov r2,#0
	bl InitPortraitData
	mov r0,#0
	add r1,r13,#0x8
	mov r2,r11
	mov r3,#1
	bl ExecuteDialogue
	b ExitAllyTalk

ChangeMonsterSprite: ; r0 = ent_ptr, r1 = target_species_id
	push r4-r6,r14
	mov r5,r0
	mov r4,r1
	ldr r6,[r5,#+0xB4]
	mov r1,#1
	mov r0,r4
	bl LoadMonsterSprite
	mov r0,r4
	bl GetDungeonSpriteIndex
	strh r0,[r5,#+0xA8]
	strh r4,[r6,#+0x4]
	mov r0,r5
	bl UnkFunc4
    mov r0,r5
    bl GetSleepAnimationId
    mov r1,r0
    mov r0,r5
    bl UnkFunc6
	pop r4-r6,r15

IdentifySpecies: ; r0 = species_id
	push r4-r11,r14
	mov r4,r0
	bl SetMonsterAsIdentified
	mov r0,r4
	bl SetPokemonBattled
	ldr r5,=DungeonBaseStructPtr ; Dungeon Pointer
    mov r6,#0 ; Counter
entity_loop:
    ldr r0,[r5]
    add r0,r0,r6, lsl #+0x2
    add r0,r0,#0x12000
    ldr r7,[r0,#+0xB78]
    mov r0,r7
    bl EntityIsValid
	; r7 = Target Entity Pointer
    cmp r0,#0
    beq entity_next_iter
    ldr r8,[r7,#+0xB4]
	ldrsh r1,[r8,#+0x2]
	ldrb r0,[r8,#0x6]
	;ldrb r2,[r8,#0x8]
	cmp r0,#1
	;cmpeq r2,#0
	cmpeq r1,r4
	bne entity_next_iter
	mov r0,r7
	bl ChangeMonsterSprite
	;mov r0,#0
	;mov r1,r7
	;mov r2,#0
	;bl ChangeString
	;mov r0,r7
	;mov r1,#300
	;sub r1,r1,#1
	;bl SendMessageWithIDCheckULog
entity_next_iter:
    add r6,r6,#1
    cmp r6,#0x14
    blt entity_loop
	pop r4-r11,r15

FadeBothScreensWhite:
	push r4,r5,r14
	mov r4,r0
	mov r5,r1
	mov r2,#0x0
	bl FadeInOutWhite
	mov r0,r4
	mov r1,r5
	mov r2,#0x1
	bl FadeInOutWhite
	pop r4,r5,r15

WaitManyFrames:
	push r4,r14
	mov r4,r0
wait_loop:
	mov r0,#0x59
	bl WaitOneFrame
	subs r4,r4,#1
	bne wait_loop
	pop r4,r15


TargetHook:
	ldrb r1,[r5,#+0x48]
	cmp r1,#0xD7
	popeq r3-r5,r15
	ldrb r1,[r4,#0x9] ; Original instruction
	b ReturnTargetCheck


OldTargetHook:
	; I am so glad these two functions share one brain cell
	ldr r0,[r4,#+0xB4]
	ldrb r0,[r0,#+0x48]
	cmp r0,#0xD7
	moveq r0,#0
	ldrneb r0,[r4,#+0x20] ; Original instruction
	bx r14
.pool
SMEARGLE_FLAG:
	.word 0x0
.endarea