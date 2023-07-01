.org 0x23A7080+0x30F70
.area 0x81C

; Protosynthesis
ProtoHook1:
	; We have to check the attacker and the defender! r10 and r9, respectively
	; Power boost is at r13+#0x90 originally, so 0x94 in this function and 0x9C in ApplyProtosynthesisBoost...
	mov r0,r10
	mov r1,#0x74
	bl AbilityIsActiveVeneer
	cmp r0,#0
	beq defender_check
	mov r0,r10
	bl GetApparentWeather
	cmp r0,#1
	moveq r0,r10
	bleq ApplyProtosynthesisBoost
defender_check:
	mov r0,r10
	mov r1,r9
	mov r2,#0x74
	mov r3,#1
	bl DefenderAbilityIsActive
	cmp r0,#0
	beq proto_hook_ret1
	mov r0,r9
	bl GetApparentWeather
	cmp r0,#1
	moveq r0,r9
	bleq ApplyProtosynthesisBoost
proto_hook_ret1:
	ldr r0,[r13,#+0x18] ; Original instruction
	b EndProtoHook1

ApplyProtosynthesisBoost: ; r0 = Entity pointer
	ldr r2,[r0,#+0xb4]
	add r2,r2,0x1A
	mov r1,#3 ; 0 : Atk, 1 : Sp. Atk, 2 : Def, 3 : Sp. Def
	mov r0,#0
	mov r12,r1
find_highest_stat_loop:
	ldrb r3,[r2,r1]
	cmp r3,r0
	movge r0,r3
	movge r12,r1
	subs r1,r1,#1
	bpl find_highest_stat_loop
	; Ensure we're boosting the right stat...
	ldr r2,[r13,#+0x18] ; 0 = Physical, 1 = Special
	and r1,r12,#0x1
	cmp r1,r2
	bxne r14
	; Okay, time to boost!
	mov r1,#0x90
	cmp r12,#2 ; r12 = Index of highest stat
	movlt r2,#12
	movge r2,#8
	addge r1,r1,#4
	ldr r0,[r13,r1]
	add r0,r0,r2
	str r0,[r13,r1]
	ldr r1,=BOOST_BYTE_LOCATIONS
	ldrb r1,[r1,r12]
	; Atk is [r5,#0x30], Sp. Atk is [r5,#0x31], Def is [r5,#0x36], Sp. Def is Def is [r5,#0x37]
	ldrb r3,[r5,r1]
	add r3,r3,r2
	strb r3,[r5,r1]
	bx r14

ProtoHook2:
	mov r0,r7 ; Original instruction
	ldr r12,=PROTO_PTR
	str r6,[r12]
	bx r14

ProtoHook3:
	; r5 is some pointer to a Pokémon struct
	; 0x2 = Attack
	; 0x4 = Sp. Attack
	; 0x6 = Defense
	; 0x8 = Sp. Defense
	push r0-r3,r4,r6,r14
	strh r0,[r5] ; Original instruction
	mov r0,#34
	bl OverlayIsLoaded
	ldr r4,=PROTO_PTR
	ldr r4,[r4]
	cmp r0,#0
	cmpne r4,#0
	popeq r0-r3,r4,r6,r15
	mov r0,r4
	mov r1,#0x74
	bl AbilityIsActiveVeneer
	mov r6,r0
	mov r0,r4
	bl GetApparentWeather
	cmp r0,#1
	cmpeq r6,#1
	popne r0-r3,r4,r6,r15
	ldr r2,[r4,#+0xb4]
	add r2,r2,0x1A
	mov r1,#3 ; 0 : Atk, 1 : Sp. Atk, 2 : Def, 3 : Sp. Def
	mov r0,#0
	mov r12,r1
find_menu_max_loop:
	ldrb r3,[r2,r1]
	cmp r3,r0
	movge r0,r3
	movge r12,r1
	subs r1,r1,#1
	bpl find_menu_max_loop
	cmp r12,#2 ; r12 = Index of highest stat
	lsl r12,r12,#1
	add r12,r12,#2
	ldrh r0,[r5,r12]
	addlt r0,r0,#12
	addge r0,r0,#8
	strh r0,[r5,r12] ; 2-3: Atk, 4-5: Sp. Atk, 6-7: Def, 8-9: Sp. Def
	pop r0-r3,r4,r6,r15

; Corrosion
CorrosionHook1:
	mov r0,r10
	mov r1,#0x8
	bl AbilityIsActiveVeneer
	cmp r0,#0
	bne PoisonSuccess
	cmp r8,#0 ; Original instruction
	b EndCorrosionHook1

CorrosionHook2:
	mov r0,r10
	mov r1,#0x8
	bl AbilityIsActiveVeneer
	cmp r0,#0
	bne BadPoisonSuccess
	cmp r8,#0 ; Original instruction
	b EndCorrosionHook2


; Defiant
DefiantAttackHook:
	cmp r8,r7
	beq AttackStatDownEnd
	mov r0,r8
	mov r1,r7
	mov r2,#0x60
	mov r3,#1
	bl DefenderAbilityIsActive
	cmp r0,#0
	beq AttackStatDownEnd
	mov r0,r8
	mov r1,r7
	mov r2,#0
	mov r3,#2
	bl AttackStatUp
	b AttackStatDownEnd
DefiantDefenseHook:
	cmp r8,r7
	beq DefenseStatDownEnd
	mov r0,r8
	mov r1,r7
	mov r2,#0x60
	mov r3,#1
	bl DefenderAbilityIsActive
	cmp r0,#0
	beq DefenseStatDownEnd
	mov r0,r8
	mov r1,r7
	mov r2,#0
	mov r3,#2
	bl AttackStatUp
	b AttackStatDownEnd
DefiantFocusHook:
	cmp r7,r6
	beq FocusStatDownEnd
	mov r0,r7
	mov r1,r6
	mov r2,#0x60
	mov r3,#1
	bl DefenderAbilityIsActive
	cmp r0,#0
	beq FocusStatDownEnd
	mov r0,r7
	mov r1,r6
	mov r2,#0
	mov r3,#2
	bl AttackStatUp
	b FocusStatDownEnd
DefiantSpeedHook:
	push r14
	bl #0x02314e1c
	cmp r10,r9
	popeq r15
	mov r0,r10
	mov r1,r9
	mov r2,#0x60
	mov r3,#1
	bl DefenderAbilityIsActive
	cmp r0,#0
	popeq r15
	mov r0,r10
	mov r1,r9
	mov r2,#0
	mov r3,#2
	bl AttackStatUp
	pop r15
DefiantAttackMinMaxHook:
	cmp r8,r9
	beq AttackStatMinMaxEnd
	mov r0,r9
	mov r1,r8
	mov r2,#0x60
	mov r3,#1
	bl DefenderAbilityIsActive
	cmp r0,#0
	beq AttackStatMinMaxEnd
	mov r0,r9
	mov r1,r8
	mov r2,#0
	mov r3,#2
	bl AttackStatUp
	b AttackStatMinMaxEnd
DefiantDefenseMinMaxHook:
	cmp r8,r9
	beq DefenseStatMinMaxEnd
	mov r0,r9
	mov r1,r8
	mov r2,#0x60
	mov r3,#1
	bl DefenderAbilityIsActive
	cmp r0,#0
	beq DefenseStatMinMaxEnd
	mov r0,r9
	mov r1,r8
	mov r2,#0
	mov r3,#2
	bl AttackStatUp
	b DefenseStatMinMaxEnd

; Electromorphosis
ElectromorphosisHook:
	sub r13,r13,#0x10
	ldr r0,=#558
	cmp r5,r0
	bgt electro_ret
	mov r0,r8
	mov r1,r7
	mov r2,#0x6E
	mov r3,#1
	bl DefenderAbilityIsActive
	cmp r0,#0
	beq electro_ret
	ldr r0,[r7,#+0xB4]
	ldrb r0,[r0,#+0xD2]
	cmp r0,#0xB
	beq electro_ret
	ldr r0,=#0xCD9
	bl StringFromMessageId
	str r0,[r13]
	mov r0,r7
	mov r1,r7
	mov r2,#0xB
	mov r3,#128
	bl SomeBidingFunction
	; Cool animation
	mov r0,r7
	ldr r1,=#0x1A5
	bl LoadAndPlayAnimation
electro_ret:
	add r13,r13,#0x10
	mov r0,#0
	b EndElectroHook

; Flower Veil
FlowerVeilHook1:
	push r0-r3,r5,r14
	mov r5,r1
	mov r0,r1
	mov r1,#0x5F
	mov r2,#0
	bl TryActivateAdjacentAbility
	cmp r0,#0
	moveq r4,r5 ; Original instruction, sorta
	popeq r0-r3,r5,r15
	pop r0-r3,r5,r14
	cmp r2,#0
	beq EndOfSafeguard
	ldr r1,=#296
	bl LogMessageByIdWithPopupCheckUser
	b EndOfSafeguard

FlowerVeilHook2:
	push r1-r3,r14
	cmp r0,r1
	beq no_protection
	mov r0,r1
	mov r1,#0x5F
	mov r2,#0
	bl TryActivateAdjacentAbility
	cmp r0,#0
no_protection:
	moveq r0,#0
	popeq r1-r3,r15
	pop r1-r3,r14
	cmp r2,#0
	beq EndOfMist
	mov r0,r1
	ldr r1,=#296
	bl LogMessageByIdWithPopupCheckUser
	b EndOfMist

TryActivateAdjacentAbility: ; r0 = Target, r1 = ability, r2 = flag (ally or enemy)
	push r4-r9,r14
	mov r6,r0
	mov r8,r1
	mov r9,r2
	cmp r2,#0x5F
	bne ignore_type_check
	mov r1,#4
	bl MonsterIsType
	cmp r0,#0
	beq flower_veil_failure
ignore_type_check:
	mov r5,#0
	ldr r4,=DIRECTIONS_XY
	b direction_loop_next_iter
direction_loop:
	mov r1,r5,lsl #0x2
	add r0,r4,r5,lsl #0x2
	ldrsh r3,[r4,r1]
	ldrsh r12,[r6,#0x4]
	ldrsh r1,[r0,#0x2]
	ldrsh r2,[r6,#0x6]
	add r0,r12,r3
	add r1,r2,r1
	bl GetTile
	ldr r0,[r0,#+0xC]
	mov r7,r0
	bl EntityIsValid
	cmp r0,#0
	beq direction_loop_nope
	; Okay, so the entity is valid. Is it our ally?
	ldr r0,[r7,#+0xB4]
	ldrb r1,[r0,#0x6]
	ldrb r2,[r0,#0x8]
	eor r0,r1,r2
	ldr r1,[r6,#+0xb4]
	ldrb r2,[r1,#0x6]
	ldrb r3,[r1,#0x8]
	eor r1,r2,r3
	cmp r0,r1
	bne adjacent_target_is_enemy
	; Ally
	cmp r9,#0
	bne direction_loop_nope
	b adjacent_ability_check
adjacent_target_is_enemy:
	cmp r9,#0
	beq direction_loop_nope
	; Moment of truth, does it have the ability?
adjacent_ability_check:
	mov r0,r7
	mov r1,r8
	bl AbilityIsActiveVeneer
	cmp r0,#0
	beq direction_loop_nope
	mov r0,#1
	pop r4-r9,r15
direction_loop_nope:
	add r5,r5,#1
direction_loop_next_iter:
	cmp r5,#8
	blt direction_loop
flower_veil_failure:
	mov r0,#0
	pop r4-r9,r15


; Infiltrator
InfiltratorHook1:
	push r14
	mov r0,r10
	mov r1,#0x45
	bl AbilityIsActiveVeneer
	cmp r0,#0
	pop r14
	bxne r14 ; We have Infiltrator, so just return to where we came from.
	ldr r0,=InfiltratorReflect+4
	cmp r0,r14
	beq 0x0230ccd0 ; Does not have Infiltrator, but Reflect passed!
	b 0x0230cd1c ; Does not have Infiltrator, but Light Screen passed!

InfiltratorHook2:
	beq HasSafeguardOrMist
	ldr r0,=InfiltratorSafeguard+4
	cmp r0,r14
	beq 0x02301988 ; Does not have Safeguard active OR has Infiltrator
	b 0x02301b8c ; Does not have Mist active OR has Infiltrator

HasSafeguardOrMist:
	push r0-r4,r14
	ldr r0,=InfiltratorSafeguard+4
	cmp r0,r14
	moveq r4,#0
	movne r4,#1
	moveq r0,r5
	movne r0,r7
	mov r1,#0x45
	bl AbilityIsActiveVeneer
	cmp r0,#0
	popeq r0-r4,r15
	cmp r4,#0
	pop r0-r4,r14
	beq 0x02301988 ; Infiltrator against Safeguard
	b 0x02301bb0 ; Infiltrator against Mist

; Overcoat
OvercoatAndSandRushHook:
	bl AbilityIsActiveVeneer
	cmp r0,#0
	bne ProtectedFromWeather
	mov r0,r5
	mov r1,#0x6B
	bl AbilityIsActiveVeneer
	cmp r0,#0
	bne ProtectedFromWeather
	mov r0,r5
	mov r1,#0xE
	bl AbilityIsActiveVeneer
	cmp r0,#0
	bne ProtectedFromWeather
	b NoSandVeilOROvercoatORSandRush

OvercoatHailHook:
	bl AbilityIsActiveVeneer
	cmp r0,#0
	bne ProtectedFromWeather
	mov r0,r5
	mov r1,#0x6B
	bl AbilityIsActiveVeneer
	cmp r0,#0
	bne ProtectedFromWeather
	b NoIceBodyOrOvercoat

; Sap Sipper
SapSipperHook:
	mov r0,r8
	mov r1,r7
	mov r2,#0x5E
	mov r3,#0x1
	bl DefenderAbilityIsActive
	cmp r0,#0
	beq NoSapSipper
	ldrb r0,[r6,#+0xC]
	cmp r0,#4
	bne NoSapSipper
	mov r2,#0
	;str r2,[r13]
	mov r3,#1
	mov r0,r8
	mov r1,r7
	bl AttackStatUp
	mov r0,#1
	strb r0,[r6,#+0x10]
	mov r0,#0
	b ApplyDamageRet

; Sand Rush
SandRushAttackHook:
	cmp r8,#0x2
	bne AfterWeatherChecks
	mov r0,r10
	mov r1,#0xE
	bl AbilityIsActiveVeneer
	cmp r0,#0
	movne r5,#0x1
	movne r6,r5
	b AfterWeatherChecks

; Sheer Force
SheerForceHook1:
	mov r0,r6
	mov r1,#0x2A
	bl AbilityIsActiveVeneer
	cmp r0,#0
	bne ReturnZeroUT
	cmp r4,#0
	b NoSheerForceEnd1

SheerForceHook2:
	mov r0,r5
	mov r1,#0x2A
	bl AbilityIsActiveVeneer
	cmp r0,#0
	movne r0,#0
	popne r3-r5,r15
	cmp r4,#0
	b NoSheerForceEnd2

SheerForceHook3:
	push r0-r3,r14
	mov r4,r3 ; Original instruction
	mov r1,#0x2A
	bl AbilityIsActiveVeneer
	cmp r0,#0
	popeq r0-r3,r15
	ldr r1,=SHEER_FORCE_MOVE_IDS
sheer_force_loop:
	ldrh r0,[r1],#+0x2
	cmp r0,#0
	popeq r0-r3,r15
	cmp r0,r5
	addeq r4,r4,#0x30
	popeq r0-r3,r15
	b sheer_force_loop

UnnerveHook:
	ldr r6,[sp,#0x84] ; Original instruction
	push r0-r3
	ldrh r0,[r6,#+0x4]
	bl GetItemCategoryVeneer
	cmp r0,#2
	cmpne r0,#3
	bne unnerve_ret
	mov r0,r7
	mov r1,#0x42
	mov r2,#1
	bl TryActivateAdjacentAbility
	cmp r0,#0
	beq unnerve_ret
	mov r0,r7
	ldr r1,=#297
	bl LogMessageByIdWithPopupCheckUser
	pop r0-r3
	b 0x0231CB14 ; ItemJumpAddress
unnerve_ret:
	pop r0-r3
	cmp r9,#0
	b EndUnnerveHook

.pool
PROTO_PTR:
	.word 0x0
BOOST_BYTE_LOCATIONS:
	.byte 0x30, 0x31, 0x36, 0x37
.align
SHEER_FORCE_MOVE_IDS:
	.halfword 0x1, 0x10, 0x19, 0x1e, 0x20, 0x2a, 0x2e, 0x34, 0x35, 0x3e, 0x3f, 0x40, 0x41, 0x45, 0x47, 0x49, 0x4e, 0x52, 0x5d, 0x60, 0x61, 0x64, 0x65, 0x67, 0x6b, 0x6d, 0x72, 0x78, 0x7d, 0x7f, 0x81, 0x85, 0x8b, 0x8f, 0x90, 0x92, 0x93, 0x95, 0x9d, 0x9e, 0x9f, 0xa2, 0xa4, 0xbc, 0xc1, 0xc6, 0xc8, 0xcd, 0xcf, 0xd5, 0xdd, 0xe2, 0xe6, 0xea, 0xeb, 0xf4, 0xf6, 0xff, 0x105, 0x106, 0x107, 0x108, 0x10e, 0x10f, 0x113, 0x114, 0x117, 0x118, 0x11b, 0x121, 0x123, 0x124, 0x12b, 0x12f, 0x133, 0x135, 0x136, 0x145, 0x14c, 0x14f, 0x156, 0x158, 0x159, 0x162, 0x19b, 0x19d, 0x1a2, 0x1a4, 0x1af, 0x1b4, 0x1b5, 0x1ba, 0x1bb, 0x1be, 0x1c4, 0x1c6, 0x1cb, 0x1cd, 0x1d4, 0x1d9, 0x1e4, 0x1e5, 0x1e9, 0x1ef, 0x1f2, 0x1f5, 0x1fb, 0x205, 0x207, 0x209, 0x20a, 0x20c, 0x212, 0x218, 0x21d, 0x0
.align
.endarea
