.org 0x023A7080+0x30F70
.area 0x54

DungeonHook:
	cmp r0,#165
	bleq TryInflictBadlyPoisonStatusWholeTeam
	b DungeonChecksOver

TryInflictBadlyPoisonStatusWholeTeam:
	push r3-r7,r14
	mov r7,#0
	ldr r4,=DUNGEON_PTR
team_loop:
	ldr r0,[r4]
	mov r2,r5
	add r0,r0,r7, lsl #0x2
	add r0,r0,#0x12000
	ldr r0,[r0,#+0xB28]
	mov r1,r0
	mov r2,#1
	mov r3,#0
	bl TryInflictBadlyPoisonedStatus
	add r7,r7,#1
	cmp r7,#0x4
	blt team_loop
	pop r3-r7,r15
.pool
.endarea