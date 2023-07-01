.org 0x23A7080+0x30F70+0x800+0x30+0x30
.area 0x5C
ItemHook:
	; r5 = Item Pointer
	push r14
	ldrh r1,[r5,#+0x4]
	mov r2,#139
	mov r3,#148
	bl is_in_range
	cmp r0,#1
	popeq r15
	mov r2,#150
	mov r3,#155
	bl is_in_range
	cmp r0,#1
	popeq r15
	mov r0,r5
	bl ClearItem
	pop r15
is_in_range:
	cmp r1,r2
	blt not_in_range
	cmp r1,r3
	bgt not_in_range
	mov r0,#1
	bx r14
not_in_range:
	mov r0,#0
	bx r14
.endarea