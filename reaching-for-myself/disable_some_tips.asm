; hi espik, the parameters for this SP don't matter

.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x810

.include "lib/stdlib_us.asm"
.definelabel ProcStartAddress, 0x022E7248
.definelabel ProcJumpAddress, 0x022E7AC0
.definelabel HelpMessageThing, 0x020AFF74


; File creation
.create "./code_out.bin", 0x022E7248
    .org ProcStartAddress
    .area MaxSize

        ldr r1, =HelpMessageThing
        ldr r1, [r1]
        ldr r0, =0b11111111111111111111110000000000
        str r0, [r1, #+0x94]
		mov r0,#0
        b ProcJumpAddress
        .pool
    .endarea
.close