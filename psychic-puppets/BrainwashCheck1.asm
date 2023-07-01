.nds
.open "overlay_0029.bin", 0x22DC240

    .org 0x23001AC
    .area 0x4
        bl UnusedTactic
    .endarea

.close

.open "overlay_0036.bin", 0x23A7080
.orga 0x34F70
.area 0x38F80 - 0x34F70

UnusedTactic:
    
	ldr r0,[r4,#+0xb4]
	ldrb r1,[r0,#+0x6]
	cmp r1,#1
	moveq r0,#1 ; not part of the party, so use species name
	bxeq ret
	ldrb r1,[r0,#+0xa8]
	cmp r1,#4
	moveq r0,#1 ; brainwashed ally, use species
	movne r0,#0 ; current party member, use assembly name
	bx r14
    .pool
.endarea
.close