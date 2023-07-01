.nds
.open "overlay9_29", 0x22DC240

    .org 0x22F856C
    .area 0x4
        bl AllyPanic
EndHook:
    .endarea

.close

.open "overlay9_36", 0x23A7080
.org 0x023A7080+0x33F70+0xAC
.area 0x28

AllyPanic:
    
	ldrb r0,[r7,#+0xa8]
	cmp r0,#4
	moveq r0,#1
	beq EndHook
	ldrb r0,[r7,#+0x7]
	b EndHook
    .pool
.endarea
.close