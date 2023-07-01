; ------------------------------------------------------------------------------
; Set All IQ Party Member
; Sets all IQ skills of a current party member! (0-3)
; Param 1: member_id
; Returns: 1 if successful, 0 if not!
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
.definelabel AssemblyPointer, 0x020B0A48
.definelabel IdkWhatThisIsLolIWroteThisBackInOctober, 0x02058EB0

; For EU
;.include "lib/stdlib_eu.asm"
;.definelabel ProcStartAddress, 0x022E7B88
;.definelabel ProcJumpAddress, 0x022E8400
;.definelabel AssemblyPointer, 0x20B138C
;.definelabel IdkWhatThisIsLolIWroteThisBackInOctober, 0x0205922C

; File creation
.create "./code_out.bin", 0x022E7248 ; For EU: 0x022E7B88
	.org ProcStartAddress
	.area MaxSize
		
		push r4-r5
		mov r0,#0
		cmp r7,#0
		blt @@ret
		cmp r7,#3
		bgt @@ret
		ldr r3,=AssemblyPointer
		ldr r3,[r3]
		add r0,r3,#0x9800
		add r0,r0,#0x4c
		ldr r0,[r0]
		mov r1,#0x68
		mla r4,r7,r1,r0
		ldr r1,=#0x9870
		ldr r2,[r3,r1]
		lsl r1,r7,#+0x1
		ldrsh r2,[r2,r1]
		cmp r2,#0
		movlt r0,#0
		blt @@ret ; Sanity check
		mov r1,#0x44
		mla r5,r2,r1,r3
		; r4 = Party Member Struct
		; r5 = Mentry Struct
		ldrsh r1,[r5,#+0x4]
		ldrh r2,[r5,#+0x8]
		add r5,r5,#0x14
		add r4,r4,#0x4C
		mov r0,r5
		bl IdkWhatThisIsLolIWroteThisBackInOctober
		ldmia [r5],r0-r2
		stmia [r4],r0-r2
		mov r0,#1
@@ret:
		pop r4-r5
		b ProcJumpAddress
		.pool
	.endarea
.close