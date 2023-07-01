.org 0x23A7080+0x30F70+0x820+0x38+0x50+0x60
.area 0x50

DamageHook:
	push r0-r3,r14
	mov r11,r9 ; Original instruction
	bl EntityIsValid
	cmp r0,#0
	cmpne r7,r8
	popeq r0-r3,r15
	bl GetLeader
	ldr r1,=DungeonBaseStructPtr
	ldr r1,[r1]
	ldrb r1,[r1,#+0x748]
	cmp r1,DUNGEON_ID
	cmpeq r0,r8
	popne r0-r3,r15
	ldr r0,=#999999
	str r0,[r6]
	pop r0-r3,r15
.pool
.endarea
