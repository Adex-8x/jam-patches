.org 0x023A7080+0x30F70+0x450+0xB0+0x38+0x150+0x110+0x3A0+0x400
.area 0x20
CheckTalkFlag:
	mov r0,#0
	mov r1,#18
	mov r2,#1
	bl GetGameVarIndexed
	cmp r0,#0
	beq VanillaBehavior
	b BeforeSetGroundDeletion+28
.endarea
