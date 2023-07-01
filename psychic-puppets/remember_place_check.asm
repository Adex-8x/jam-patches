; ------------------------------------------------------------------------------
; Remember Place Special Team Check
; Param 1 = Variable
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x810

; Uncomment/comment the following labels depending on your version.

; For US
.include "lib/stdlib_us.asm"
.definelabel ProcStartAddress, 0x022E7248
.definelabel ProcJumpAddress, 0x022E7AC0
.definelabel AssemblyPointer, 0x20B0A48
.definelabel SetGameVar, 0x0204B820

; For EU
;.include "lib/stdlib_eu.asm"
;.definelabel ProcStartAddress, 0x022E7B88
;.definelabel ProcJumpAddress, 0x022E8400
;.definelabel AssemblyPointer, 0x20B138C


; File creation
.create "./code_out.bin", 0x022E7248 ; For EU: 0x022E7B88
	.org ProcStartAddress
	.area MaxSize ; Define the size of the area

		push r4,r5,r6
		ldr r0,=AssemblyPointer
		ldr r0,[r0]
		mov r2,r0
		ldr r1,=#0x9870
		ldr r0,[r0,r1]
		mov r1,#0x44
		ldrh r5,[r0],#+0x2
		mla r5,r5,r1,r2
		ldrh r5,[r5,#+0x4]
		ldrh r4,[r0],#+0x2
		mla r4,r4,r1,r2
		ldrh r4,[r4,#+0x4]
		ldrh r3,[r0],#+0x2
		mla r3,r3,r1,r2
		ldrh r3,[r3,#+0x4]
		ldrh r6,[r0]
		mla r6,r6,r1,r2
		ldrh r6,[r6,#+0x4]
		ldr r2,=special_teams
		mov r0,#1
@@special_loop:
		ldrh r1,[r2,#+0x0]
		cmp r1,r5
		bne @@next_loop_iter
		ldrh r1,[r2,#+0x2]
		cmp r1,r4
		bne @@next_loop_iter
		; Members 3 and 4 can be empty
		ldrh r1,[r2,#+0x4]
		cmp r1,#0
		beq @@ret
		cmp r1,r3
		bne @@next_loop_iter
		ldrh r1,[r2,#+0x6]
		cmp r1,#0
		beq @@ret
		cmp r1,r6
		bne @@next_loop_iter
		b @@ret
@@next_loop_iter:
		cmp r0,#43
		addlt r0,r0,#1
		addlt r2,r2,#0x8
		blt @@special_loop
		mov r0,#0

		
@@ret:
		mov r4,r0
		mov r1,r7
		mov r2,r0
		mov r0,#0
		bl SetGameVar
		mov r0,r4
		pop r4,r5,r6
		b ProcJumpAddress
		.pool
	; Retold, Cubone's Desire, Azure Sky, EotS, FrCh2, Abridged, BS, Alpha, Death
	; Chip 2, FrCh1, EotU, FoV, CC, DC, AotHS, BIG, Victorious, STP, Algernon
	; CCOotC, Divided, Delusion, FrCh3, SoR, Gengar, Otherworld, THF, 3DAYS, DtSG, PMDND
	; PAATSFOLN, Turnabout, FoH, CoL, OL, MvP, Templum, SoS, Probopass, BLORG, Templum
	special_teams:
		.halfword 425, 25, 0, 0,  104, 94, 0, 0,  133, 752, 0, 0,  428, 283, 314, 0,  340, 31, 0, 0,  4, 1, 0, 0,  4, 428, 487, 0,  1148, 637, 0, 0,  637, 438, 0, 0,  601, 120, 0, 0,  1139, 295, 718, 0,  314, 363, 663, 545,  129, 377, 0, 0,  489, 733, 0, 0,  438, 1138, 0, 0,  1137, 160, 0, 0,  540, 415, 0, 0,  541, 540, 539, 0,  485, 6, 0, 0,  286, 538, 0, 0,  483, 40, 0, 0,  93, 386, 387, 0,  797, 544, 532, 546,  830, 12, 0, 0,  849, 1149, 0, 0,  94, 94, 94, 94,  1142, 543, 0, 0,  25, 133, 0, 0,  544, 545, 0, 0,  519, 1145, 0, 0,  363, 1150, 0, 0,  512, 133, 0, 0,  434, 526, 0, 0,  59, 798, 775, 0,  551, 542, 0, 0,  444, 625, 0, 0,  383, 384, 0, 0,  197, 342, 908, 0,  133, 133, 133, 0,  518, 961, 113, 0,  96, 326, 0, 0,  490, 547, 0, 0,  58, 1148, 0, 0
	.endarea
.close