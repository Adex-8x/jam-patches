.org BeforeAllyTalks
.area 0x4
	b PartnerHook
NotPartner:
.endarea

.org CreateEnemyCheck
.area 0x4
	b FigmentHook
EndFigmentHook:
.endarea

.org BranchBattle
.area 0x4
	b 0x0230995c ; was bne
.endarea

.org 0x022f5d4c
.area 0x4
	mov r0,#0
.endarea

; Targeting

.org InsideCanSeeTarget
.area 0x4
	; ldrb r0,[r4,#+0x20 
	bl OldTargetHook
.endarea

.org InsideCanTargetEntity
.area 0x4
	; ldrb r0,[r4,#+0x20]
	bl OldTargetHook
.endarea

.org CheckKecByte
.area 0x4
	b TargetHook
ReturnTargetCheck:
.endarea