; ------------------------------------------------------------------------------
; Remember Place Boss
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
.definelabel GetGameVar, 0x0204B4EC
.definelabel RandRange, 0x2002318
.definelabel Copy4BytesArray, 0x0200330C
.definelabel MemZero, 0x2003250
.definelabel SetGameVar, 0x0204B820
.definelabel DynamicActorList, 0x20B0B08

; For EU
;.include "lib/stdlib_eu.asm"
;.definelabel ProcStartAddress, 0x022E7B88
;.definelabel ProcJumpAddress, 0x022E8400
;.definelabel AssemblyPointer, 0x20B138C


; File creation
.create "./code_out.bin", 0x022E7248 ; For EU: 0x022E7B88
	.org ProcStartAddress
	.area MaxSize ; Define the size of the area

		push r5-r10
		ldr r8,=AssemblyPointer
		ldr r8,[r8]
		ldr r0,=#0x9898
		add r0,r8,r0
		mov r1,#0x110
		bl MemZero ; Clearing stuff just in case
		; r5 = Current Special Team
		; r6-r7 = Needed for Put Recruitable (pkmn_id and origin_id+pkmn_level*256)
		; r8-r9 = Range for RNG in case r5 is rolled
		mov r0,#0
		mov r1,r7
		bl GetGameVar
		mov r5,r0
		cmp r0,#9
		movle r8,#1
		movle r9,#10
		ble @@DecideTeam ; Group A
		cmp r0,#20
		movle r8,#10
		movle r9,#21
		ble @@DecideTeam ; Group B 
		cmp r0,#31
		movle r8,#21
		movle r9,#32
		ble @@DecideTeam ; Group C
		cmp r0,#43
		movle r8,#32
		movle r9,#44
		ble @@DecideTeam ; Group D
@@DecideTeam:
		mov r0,r8
		mov r1,r9
		bl RandRange
		cmp r0,r5
		beq @@DecideTeam
		mov r10,r0
		ldr r8,=special_teams
		lsl r0,r0,#3
		add r8,r8,r0
		sub r8,r8,#0x8 ; because I was a dummy with indexing
		mov r9,#0
@@CreateLoop:
		lsl r0,r9,#1
		ldrh r7,[r8,r0]
		; Dynamic Actors
		add r1,r0,#0xA
		ldr r0,=DynamicActorList
		strh r7,[r0,r1]
		cmp r7,#0
		subeq r9,r9,#1
		beq @@ret
		cmp r10,#37
		ldreq r6,=0x2061 ; Kecleon Check
		ldrne r6,=0x2A61
		bl @@PutRecruitable
		mov r7,#3
		mov r6,r9
		bl @@MentryToTradeTeam
@@next_loop_iter:
		cmp r9,#3
		addlt r9,r9,#1
		blt @@CreateLoop
@@ret:

		mov r1,#51
		mov r2,r10
		mov r0,#0
		bl SetGameVar	
		mov r0,r9
		pop r5-r10
		b ProcJumpAddress
@@PutRecruitable:
		push r14
		mov r0,#3
		stmdb r13!, {r4}
		mov r4,r0
		mov r1,r7
		and r2,r6,#0xFF
		mov r3,#0
		bl 0x02055B78
		mov r0,r4
		bl 0x020555A8
		mov r4,r0
		mov  r1,r6,lsr #0x8
		mov  r2,#0x0
		bl 0x020544C8
		mov  r0,r4
		bl 0x02053568
		ldmia r13!, {r4}
		ldr r1,=AssemblyPointer
		ldr r1,[r1]
		mov r2,#0x44
		mov r3,#3
		mla r1,r3,r2,r1
		ldr r3,=#960
		strh r3,[r1,#+0x8]
		pop r15
@@MentryToTradeTeam:
		push r14
		mov r2,#0x44
		ldr r1,=AssemblyPointer
		ldr r1,[r1]
		add r0,r1,#0x9800
		add r0,r0,#0x98
		mla r0,r6,r2,r0
		mov r2,#0x44
		mla r1,r7,r2,r1
		bl Copy4BytesArray
		mov r0,#1
		pop r15
		.pool
	; Retold, Cubone's Desire, Azure Sky, EotS, FrCh2, Abridged, BS, Alpha, Death
	; Chip 2, FrCh1, EotU, FoV, CC, DC, AotHS, BIG, Victorious, STP, Algernon
	; CCOotC, Divided, Delusion, FrCh3, SoR, Gengar, Otherworld, THF, 3DAYS, DtSG, PMDND
	; PAATSFOLN, Turnabout, FoH, CoL, OL, MvP, Templum, SoS, Probopass, BLORG, Templum
	special_teams:
		.halfword 425, 25, 0, 0,  104, 94, 0, 0,  133, 752, 0, 0,  428, 283, 314, 0,  340, 31, 0, 0,  4, 1, 0, 0,  4, 428, 487, 0,  1148, 637, 0, 0,  637, 438, 0, 0,  601, 120, 0, 0,  1139, 295, 718, 0,  314, 363, 663, 545,  129, 377, 0, 0,  489, 733, 0, 0,  438, 1138, 0, 0,  1137, 160, 0, 0,  540, 415, 0, 0,  541, 540, 539, 0,  485, 6, 0, 0,  286, 538, 0, 0,  483, 40, 0, 0,  93, 386, 387, 0,  797, 544, 532, 546,  830, 12, 0, 0,  849, 1149, 0, 0,  94, 94, 94, 94,  1142, 543, 0, 0,  25, 133, 0, 0,  544, 545, 0, 0,  519, 1145, 0, 0,  363, 1150, 0, 0,  512, 133, 0, 0,  434, 526, 0, 0,  59, 798, 775, 0,  551, 542, 0, 0,  444, 625, 0, 0,  383, 384, 0, 0,  197, 342, 908, 0,  133, 133, 133, 0,  518, 961, 113, 0,  96, 326, 0, 0,  490, 547, 0, 0,  58, 1148, 0, 0
	.endarea
.close