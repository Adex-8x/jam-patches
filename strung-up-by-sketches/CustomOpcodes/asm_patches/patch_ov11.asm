.org OpcodeCheck
.area 0x4
	b NewOpcodesHook
EndHook:
.endarea

.org GetParameterCount
.area 0x4
	bl NewOpcodeParameterHook
.endarea

.org CaseExecuteActing
.area 0x4
	bl ExecuteActingHook
.endarea

.org CaseCancelCut
.area 0x4
	bl CancelCutHook
.endarea
