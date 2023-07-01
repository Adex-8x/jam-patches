.nds
.open "overlay9_29", 0x22DC240

    .org 0x22F8020
    .area 0x4
        bl AllyPanic
EndHook:
    .endarea

.close

.open "overlay9_36", 0x23A7080
.org 0x023DB160
.area 0x30

AllyPanic:
	push r0
	ldrb r0,[r7,#+0xA8]
	cmp r0,#4
	pop r0
	beq #0x22F8594
	str r1,[r0]
	b EndHook
    .pool
.endarea
.close