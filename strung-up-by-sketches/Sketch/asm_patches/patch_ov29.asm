.org SelectIsPressed
.area 0x8
	bl SelectHook
	beq PassTurn
.endarea

.org DisplayMoveLearnMessage
.area 0x4
	bl PatiencePlease
.endarea

.org CallSomeInitMoveWrapper
.area 0x4
	b AdjustPPHook
EndPPHook:
.endarea