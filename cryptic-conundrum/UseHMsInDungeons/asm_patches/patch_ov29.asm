.org HM_MenuCheck
.area 0x4
	mov r0,#0
.endarea

.org HM_SanityCheck
.area 0x8
	mov r0,#0
	cmp r0,#0
.endarea