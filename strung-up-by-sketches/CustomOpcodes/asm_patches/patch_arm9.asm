.org CallUpdateFrameStruct
.area 0x4
	bl UpdateFrameHook
.endarea

.org PrepareDBoxColor
.area 0x4
	bl DBoxColorHook
.endarea

.org PrepareDisplayDBoxBackground
.area 0x8
	push r4,r5,r14
	mov r4,r0
.endarea

.org PrepareDisplayDBoxBackgroundEnd
.area 0x4
	pop r4,r5,r15
.endarea

.org 0x02028e40
.area 0x4
	push r3-r8,r14
.endarea

.org NextDBoxIteration
.area 0x4
	bl NextDBoxIterHook
.endarea

.org 0x02028e7c
.area 0x4
	pop r3-r8,r15
.endarea

.org PrepareDBoxStartingYPos
.area 0x4
	bl LowerBoxTransitionHook
.endarea

.org PrepareDBoxEndingYPos
.area 0x4
	bl UpperBoxTransitionHook
.endarea
