.org 0x23A7080+0x30F70+0x820
.area 0x28

FloorHook:
	bl GenerateFloor ; Original instruction
	mov r0,#0
	mov r1,#21
	ldrb r2,[r9,#+0x749]
	bl SetGameVar
	b FloorHookEnd
.endarea
