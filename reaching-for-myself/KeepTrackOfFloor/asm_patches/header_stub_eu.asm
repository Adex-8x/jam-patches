.relativeinclude on
.nds
.arm

; TODO: Find offsets!


MenuHook:
	; r5 is some pointer to a Pokémon struct
	; 0x2 = Attack
	; 0x4 = Sp. Attack
	; 0x6 = Defense
	; 0x8 = Sp. Defense
	;push r0-r4,r6,r14
	;mov r4,r1
	;mov r0,#34
	;bl OverlayIsLoaded
	;cmp r0,#0
	;beq MenuRet
	; TODO: Ability Check

	; TODO: Sunny Check
	;cmp r0,#0
	;beq MenuRet
	;mov r2,#8
	;mov r6,r2
	;mov r0,#0
;find_menu_max_loop:
	;ldrh r3,[r5,r2]
	;cmp r3,r0
	;movle r0,r3
	;movle r6,r2
	;subs r2,r2,#2
	;bne find_menu_max_loop
	;mov r1,#332
	;bl UMultiplyByFixedPoint
	;strh r0,[r5,r6]
;MenuRet:
	;cmp r4,#0 ; OGI
	;pop r0-r4,r6,r7,r15