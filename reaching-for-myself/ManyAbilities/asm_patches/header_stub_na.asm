.relativeinclude on
.nds
.arm

; Protosynthesis
.definelabel BeforeMenuComparisons, 0x0205B19C
.definelabel BeforeStatItemBoosts, 0x0230C338
.definelabel OverlayIsLoaded, 0x02003ED0
.definelabel UMultiplyByFixedPoint, 0x02001B0C
.definelabel AbilityIsActiveVeneer, 0x02301D78
.definelabel DefenderAbilityIsActive, 0x02332A0C
.definelabel GetApparentWeather, 0x02334D08
.definelabel LogMessageByIdWithPopupCheckUser, 0x0234B2A4
.definelabel PassMonsterPointer, 0x022F8AA4

; Corrosion
.definelabel TryPoisonSuccess, 0x02312778
.definelabel PoisonSuccess, 0x02312798
.definelabel TryBadPoisonSuccess, 0x02312A50
.definelabel BadPoisonSuccess, 0x02312A70
.definelabel AirLockCheck, 0x022F93C8

; Defiant
.definelabel DownloadCheck, 0x0230bdf0

; Electromorphosis
.definelabel FilterCheck, 0x0230b058
.definelabel DoMoveCharge, 0x023282c8
.definelabel EndOfApplyDamage, 0x02309B18
.definelabel SomeBidingFunction, 0x02318bbc
.definelabel StringFromMessageId, 0x020258C4
.definelabel LoadAndPlayAnimation, 0x022e42e8

; Flower Veil
.definelabel HeatproofCheck, 0x0230b1b0
.definelabel SafeguardStart, 0x02301944
.definelabel EndOfSafeguard, 0x02301980
.definelabel AreEntitiesAdjacent, 0x022FB678
.definelabel DIRECTIONS_XY, 0x0235171C
.definelabel GetTile, 0x023360FC
.definelabel EntityIsValid, 0x022E0354
.definelabel MonsterIsType, 0x02301E50
.definelabel MistStart, 0x02301b34
.definelabel EndOfMist, 0x02301ba8

; Infiltrator
.definelabel ImmunityCheck1, 0x022fa96c
.definelabel ImmunityCheck2, 0x02312724
.definelabel ImmunityCheck3, 0x023129fc
.definelabel InfiltratorReflect, 0x0230ccb8
.definelabel InfiltratorLightScreen, 0x0230cd04
.definelabel InfiltratorSafeguard, 0x02301958
.definelabel InfiltratorMist, 0x02301b74

; Overcoat
.definelabel NormalizeCheck1, 0x0230b814
.definelabel NormalizeCheck2, 0x0230bc8c
.definelabel NormalizeCheck3, 0x023022b0
.definelabel NormalizeCheck4, 0x02313c9c
.definelabel SandVeilCheck, 0x02310210
.definelabel ProtectedFromWeather, 0x02310360
.definelabel IceBodyCheck, 0x0231019c

; Sap Sipper
.definelabel TryActivateSlowStart, 0x022f923c
.definelabel MotorDriveFail1, 0x023093b0
.definelabel MotorDriveFail2, 0x023093bc
.definelabel NoSapSipper, 0x023093d8
.definelabel ApplyDamageRet, 0x0230a918
.definelabel TryIncreaseHp, 0x023152e4


; Sand Rush
.definelabel SuctionCupsCheck1, 0x022EB18C
.definelabel SuctionCupsCheck2, 0x022eb20c
.definelabel SuctionCupsCheck3, 0x0231ee5c
.definelabel SuctionCupsCheck4, 0x0231fc84
.definelabel SuctionCupsCheck5, 0x0231feb4
.definelabel SuctionCupsCheck6, 0x02320d80
.definelabel SuctionCupsCheck7, 0x0232ac04
.definelabel NotSunnyWeather, 0x022fffbc
.definelabel AfterWeatherChecks, 0x022fffd8

; Sheer Force
.definelabel TryActivateTruant, 0x022f97f0
.definelabel WorrySeedTruant, 0x0232ddc4
.definelabel BeforeSereneGraceUT, 0x023249a0
.definelabel ReturnZeroUT, 0x02324a10
.definelabel BeforeSereneGraceU, 0x02324a3c
.definelabel EarlyDealDamage, 0x02332b38


; Unnerve
.definelabel WaterVeilCheck1, 0x022fa860
.definelabel WaterVeilCheck2, 0x023123c4
.definelabel EarlyApplyItemEffect, 0x0231b6a4
.definelabel GetItemCategoryVeneer, 0x0200CAF0


; Misc.
.definelabel ExecuteMoveBeforeLoop, 0x0232e928 ; Was originally b 0x02332824, or bd 0f 00 ea
.definelabel StartExecuteMoveLoop, 0x02332824 
.definelabel IsAbilityActive, 0x2301D10
.definelabel GetMoveType, 0x0230227C
.definelabel LogMessageByIdWithPopupCheckUserTarget, 0x0234B350
.definelabel SubstitutePlaceholderStringTags, 0x022E2AD8
.definelabel UNK_NA_234B084, 0x0234B084
.definelabel UNK_NA_22E647C, 0x022E647C
.definelabel MagicianDamageCheck, 0x02309B18 ; was mov r0,#0
.definelabel AbilityIsActive, 0x02301D10
.definelabel AttackStatDownStart, 0x02313604 ; was mov r7, r1
.definelabel DefenseStatDownStart, 0x0231381C ; was mov r7, r1
.definelabel AttackStatUpStart, 0x023139a4 ; was mov r8, r1
.definelabel DefenseStatUpStart, 0x02313b10 ; was mov r8, r1
.definelabel FocusStatUpStart, 0x023140ec ; was mov r6, r1
.definelabel FocusStatDownStart, 0x02314234 ; was mov r6, r1
.definelabel SpeedStatUpStart, 0x02314814 ; was mov r8, r1
.definelabel SpeedStatDownStart, 0x02314958 ; was mov r9, r1
;.definelabel DefenderAbilityIsActive, 0x22F96CC
.definelabel AttackStatMinMaxStart, 0x02313d50 ; was mov r7,r3
.definelabel DefenseStatMinMaxStart, 0x02313f74 ; was mov r7,r3

.definelabel AttackStatDown, 0x023135FC
.definelabel DefenseStatDown, 0x02313814
.definelabel AttackStatUp, 0x0231399c
.definelabel DefenseStatUp, 0x02313b08
.definelabel FocusStatUp, 0x023140e4
.definelabel FocusStatDown, 0x0231422c
.definelabel SpeedStatUp, 0x02314810
.definelabel SpeedStatDown, 0x02314954
.definelabel AttackStatMinMax, 0x02313d40
.definelabel DefenseStatMinMax, 0x02313f64

.definelabel AttackStatDownSuccess, 0x023137CC
.definelabel DefenseStatDownSuccess, 0x02313960
.definelabel FocusStatDownSuccess1, 0x023143A8
.definelabel FocusStatDownSuccess2, 0x02314394
.definelabel SpeedStatDownSuccess, 0x02314a9c ; was originally bl 02314e1c
.definelabel AttackStatMinMaxSuccess, 0x02313f08
.definelabel DefenseStatMinMaxSuccess, 0x0231408C

.definelabel AttackStatDownEnd, 0x023137e0
.definelabel DefenseStatDownEnd, 0x02313974
.definelabel FocusStatDownEnd, 0x023143bc
; No SpeedStatDownEnd needed, after it finishes it leads right into the return
.definelabel AttackStatMinMaxEnd, 0x02313f34
.definelabel DefenseStatMinMaxEnd, 0x23140b8
