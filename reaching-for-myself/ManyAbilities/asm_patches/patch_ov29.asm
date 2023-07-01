.org BeforeStatItemBoosts
.area 0x4
	b ProtoHook1
EndProtoHook1:
.endarea

.org PassMonsterPointer
.area 0x4
	bl ProtoHook2
.endarea

.org TryPoisonSuccess
.area 0x4
	bl CorrosionHook1
EndCorrosionHook1:
.endarea

.org TryBadPoisonSuccess
.area 0x4
	bl CorrosionHook2
EndCorrosionHook2:
.endarea

.org AttackStatDownSuccess
.area 0x4
	b DefiantAttackHook
.endarea

.org DefenseStatDownSuccess
.area 0x4
	b DefiantDefenseHook
.endarea

.org FocusStatDownSuccess1
.area 0x4
	b DefiantFocusHook
.endarea

.org FocusStatDownSuccess2
.area 0x4
	b DefiantFocusHook
.endarea

.org SpeedStatDownSuccess
.area 0x4
	bl DefiantSpeedHook
.endarea

.org AttackStatMinMaxSuccess
.area 0x4
	b DefiantAttackMinMaxHook
.endarea

.org DefenseStatMinMaxSuccess
.area 0x4
	b DefiantDefenseMinMaxHook
.endarea

.org EndOfApplyDamage
.area 0x4
	b ElectromorphosisHook
EndElectroHook:
.endarea

.org SafeguardStart
.area 0x4
	bl FlowerVeilHook1
.endarea

.org MistStart
.area 0x4
	bl FlowerVeilHook2
.endarea

.org InfiltratorReflect
.area 0x4
	bleq InfiltratorHook1
.endarea

.org InfiltratorLightScreen
.area 0x4
	bleq InfiltratorHook1
.endarea

.org InfiltratorSafeguard
.area 0x4
	bl InfiltratorHook2
.endarea

.org InfiltratorMist
.area 0x4
	bl InfiltratorHook2
.endarea

.org SandVeilCheck
.area 0x4
	b OvercoatAndSandRushHook
NoSandVeilOROvercoatORSandRush:
.endarea

.org IceBodyCheck
.area 0x4
	b OvercoatHailHook
NoIceBodyOrOvercoat:
.endarea

.org MotorDriveFail1
.area 0x4
	beq SapSipperHook
.endarea

.org MotorDriveFail2
.area 0x4
	bne SapSipperHook
.endarea

.org NotSunnyWeather
.area 0x4
	bne SandRushAttackHook
.endarea

.org BeforeSereneGraceUT
.area 0x4
	b SheerForceHook1; cmp r4,#0 ; b SheerForceHook1
NoSheerForceEnd1:
.endarea

.org BeforeSereneGraceU
.area 0x4
	b SheerForceHook2 ;cmp r4,#0 ; b SheerForceHook2
NoSheerForceEnd2:
.endarea

.org EarlyDealDamage
.area 0x4
	bl SheerForceHook3 ; mov r4,r3 ; bl SheerForceHook3
.endarea

.org EarlyApplyItemEffect
.area 0x4
	b UnnerveHook
EndUnnerveHook:
.endarea

; Removing abilities!

.org AirLockCheck
.area 0x4
	mov r0,#0
.endarea

.org SuctionCupsCheck1
.area 0x4
	mov r0,#0
.endarea

.org SuctionCupsCheck2
.area 0x4
	mov r0,#0
.endarea

.org SuctionCupsCheck3
.area 0x4
	mov r0,#0
.endarea

.org SuctionCupsCheck4
.area 0x4
	mov r0,#0
.endarea

.org SuctionCupsCheck5
.area 0x4
	mov r0,#0
.endarea

.org SuctionCupsCheck6
.area 0x4
	mov r0,#0
.endarea

.org SuctionCupsCheck7
.area 0x4
	mov r0,#0
.endarea

.org TryActivateSlowStart
.area 0x4
	bx r14
.endarea

.org TryActivateTruant
.area 0x4
	bx r14
.endarea

.org NormalizeCheck1
.area 0x4
	mov r0,#0
.endarea

.org NormalizeCheck2
.area 0x4
	mov r0,#0
.endarea

.org NormalizeCheck3
.area 0x4
	mov r0,#0
.endarea

.org NormalizeCheck4
.area 0x4
	mov r0,#0
.endarea

.org DownloadCheck
.area 0x4
	mov r0,#0
.endarea

.org WaterVeilCheck1
.area 0x4
	mov r0,#0
.endarea

.org WaterVeilCheck2
.area 0x4
	mov r0,#0
.endarea

.org ImmunityCheck1
.area 0x4
	mov r0,#0
.endarea

.org ImmunityCheck2
.area 0x4
	mov r0,#0
.endarea

.org ImmunityCheck3
.area 0x4
	mov r0,#0
.endarea

.org FilterCheck
.area 0x4
	mov r0,#0
.endarea

.org HeatproofCheck
.area 0x4
	mov r0,#0
.endarea

.org WorrySeedTruant
.area 0x4
	mov r0,#0
.endarea


; Reverse Disable Tips

.org 0x234CEF0
.area 0x4
	push r3-r5,r14
.endarea

; TODO: Remove the following abilities:
	; $$$ !
	; Air Lock !
	; Download !
	; Filter !
	; Heatproof !
	; Immunity !
	; Normalize !
	; Slow Start ! 
	; Suction Cups !
	; Truant !
	; Water Veil !

; TODO: Add the following abilities:
	; Protosynthesis - Raises the highest stat by 30% in Sun - $$$ (0x74) ! 
	; Corrosion - Can inflict Poison/Badly Poison status on Poison and Steel types !
	; Defiant - Raises Attack by 2 stages when an opponent lowers its stats or speed !
	; Electromorphosis - Gives the Pokémon the Charged status when hit by a move  !
	; Flower Veil - Adjacent Grass type allies are immune to stat drops and bad statuses !
	; Infiltrator - Moves bypass Reflect, Light Screen, Safeguard, and Mist !
	; Overcoat - Immune to Sandstorm and Hail damage !
	; Sap Sipper - When hit by a Grass move, boosts Attack by 1 stage and is immune !
	; Sand Rush - Raises Attack Frequency in Sandstorm and immune to Sandstorm damage !
	; Sheer Force - Boosts power of moves with secondary effects, but removes those effects 
	; Unnerve - Adjacent enemies cannot eat items !
