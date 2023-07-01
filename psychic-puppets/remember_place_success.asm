; ------------------------------------------------------------------------------
; Success Script String SprintF
; Calculates the number of special teams having completed Illusory Grotto + Remember Place and displays the result in a string!
; Real Param 1: game_var_id
; Real Param 2: has_lost
; ------------------------------------------------------------------------------
;
; Param 1: format_string_id
; Param 2: destination_string_id
; Returns: Nothing
; 
; As an example of how to use this:
;
; debug_Print("[CN]Your score is %d!");
; debug_Print("                      "); // Some arbitrarily long string
; ProcessSpecial(SELECT_ID, $CONDITION, 0);
; ProcessSpecial(STRING_SPRINTF, 0, 1);
; message_Notice(1);
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x810

; For US
.include "lib/stdlib_us.asm"
.definelabel ProcStartAddress, 0x022E7248
.definelabel ProcJumpAddress, 0x022E7AC0
.definelabel GetStringFromScript, 0x022E4248
.definelabel GetGameVar, 0x0204B4EC
.definelabel GetGameVarIndexed, 0x0204B678
.definelabel SetGameVarIndexed, 0x0204B988
.definelabel AssemblyPointer, 0x20B0A48

; For EU
;.include "lib/stdlib_eu.asm"
;.definelabel ProcStartAddress, 0x022E7B88
;.definelabel ProcJumpAddress, 0x022E8400
;.definelabel GetStringFromScript, 0x022E4B88
;.definelabel GetGameVar, 0x0204B824

; File creation
.create "./code_out.bin", 0x022E7248 ; For EU: 0x022E7B88
	.org ProcStartAddress
	.area MaxSize

		push r5,r8
		; If r6 is 1, skip to the display
		cmp r6,#1
		beq @@after_increase
		mov r0,#0
		mov r1,r7
		bl GetGameVar
		add r2,r0,#50
		mov r1,#17
		mov r3,#1
		mov r0,#0
		bl SetGameVarIndexed
@@after_increase:
		mov r5,#51
		mov r8,#0
@@gather_special_success:
		mov r0,#0
		mov r1,#17
		mov r2,r5
		bl GetGameVarIndexed
		add r8,r8,r0
		cmp r5,#93
		addlt r5,r5,#1
		blt @@gather_special_success
		cmp r8,#43
		bne @@resume
		ldr r0,=AssemblyPointer
		ldr r0,[r0]
		mov r2,#2
		add r0,r0,#0x9300
    		add r0,r0,#0x6C
		mov r1,#0x1A0
    		mla r0,r2,r1,r0
		mov r2,#2
		mov r1,#0x68
		mla r0,r2,r1,r0
		add r0,r0,#0x5e
		mov r1,#114
		strb r1,[r0,#+0x4]
@@resume:
		; r8 should be the number to display
		mov r5,r8
		add r0,r4,#0x14
		mov r1,#0
		bl GetStringFromScript ; Get destination string
		mov r8,r0
		add r0,r4,#0x14
		mov r1,#1
		bl GetStringFromScript ; Get format string
		mov r1,r8
		mov r2,r5
		bl SPrintF
		pop r5,r8
		b ProcJumpAddress
		.pool
	.endarea
.close