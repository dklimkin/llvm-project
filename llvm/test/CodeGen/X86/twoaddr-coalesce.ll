; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s
; rdar://6523745

@"\01LC" = internal constant [4 x i8] c"%d\0A\00"		; <ptr> [#uses=1]

define i32 @foo() nounwind {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %bb1.thread
; CHECK-NEXT:    pushl %ebx
; CHECK-NEXT:    xorl %ebx, %ebx
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB0_1: # %bb1
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movl %ebx, %eax
; CHECK-NEXT:    shrb $7, %al
; CHECK-NEXT:    addb %bl, %al
; CHECK-NEXT:    sarb %al
; CHECK-NEXT:    movsbl %al, %eax
; CHECK-NEXT:    pushl %eax
; CHECK-NEXT:    pushl $LC
; CHECK-NEXT:    calll printf@PLT
; CHECK-NEXT:    addl $8, %esp
; CHECK-NEXT:    incl %ebx
; CHECK-NEXT:    cmpl $258, %ebx # imm = 0x102
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:  # %bb.2: # %bb2
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    popl %ebx
; CHECK-NEXT:    retl
bb1.thread:
	br label %bb1

bb1:		; preds = %bb1, %bb1.thread
	%i.0.reg2mem.0 = phi i32 [ 0, %bb1.thread ], [ %indvar.next, %bb1 ]		; <i32> [#uses=2]
	%0 = trunc i32 %i.0.reg2mem.0 to i8		; <i8> [#uses=1]
	%1 = sdiv i8 %0, 2		; <i8> [#uses=1]
	%2 = sext i8 %1 to i32		; <i32> [#uses=1]
	%3 = tail call i32 (ptr, ...) @printf(ptr @"\01LC", i32 %2) nounwind		; <i32> [#uses=0]
	%indvar.next = add i32 %i.0.reg2mem.0, 1		; <i32> [#uses=2]
	%exitcond = icmp eq i32 %indvar.next, 258		; <i1> [#uses=1]
	br i1 %exitcond, label %bb2, label %bb1

bb2:		; preds = %bb1
	ret i32 0
}

declare i32 @printf(ptr, ...) nounwind
