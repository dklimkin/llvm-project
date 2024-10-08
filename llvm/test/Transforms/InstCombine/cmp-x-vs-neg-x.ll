; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

declare i8 @gen8()
declare void @use8(i8)

define i1 @t0(i8 %x) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg_x = sub nsw i8 0, %x
  %cmp = icmp sgt i8 %neg_x, %x
  ret i1 %cmp
}

define i1 @t0_commutative() {
; CHECK-LABEL: @t0_commutative(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[X]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %x = call i8 @gen8()
  %neg_x = sub nsw i8 0, %x
  %cmp = icmp slt i8 %x, %neg_x
  ret i1 %cmp
}

define i1 @t0_extrause(i8 %x) {
; CHECK-LABEL: @t0_extrause(
; CHECK-NEXT:    [[NEG_X:%.*]] = sub nsw i8 0, [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[NEG_X]])
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[X]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg_x = sub nsw i8 0, %x
  call void @use8(i8 %neg_x)
  %cmp = icmp sgt i8 %neg_x, %x
  ret i1 %cmp
}

define i1 @t1(i8 %x) {
; CHECK-LABEL: @t1(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[X:%.*]], 1
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg_x = sub nsw i8 0, %x
  %cmp = icmp sge i8 %neg_x, %x
  ret i1 %cmp
}

define i1 @t2(i8 %x) {
; CHECK-LABEL: @t2(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg_x = sub nsw i8 0, %x
  %cmp = icmp slt i8 %neg_x, %x
  ret i1 %cmp
}

define i1 @t3(i8 %x) {
; CHECK-LABEL: @t3(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[X:%.*]], -1
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg_x = sub nsw i8 0, %x
  %cmp = icmp sle i8 %neg_x, %x
  ret i1 %cmp
}

define i1 @t4(i8 %x) {
; CHECK-LABEL: @t4(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg_x = sub nsw i8 0, %x
  %cmp = icmp ugt i8 %neg_x, %x
  ret i1 %cmp
}

define i1 @t5(i8 %x) {
; CHECK-LABEL: @t5(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[X:%.*]], -1
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg_x = sub nsw i8 0, %x
  %cmp = icmp uge i8 %neg_x, %x
  ret i1 %cmp
}

define i1 @t6(i8 %x) {
; CHECK-LABEL: @t6(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg_x = sub nsw i8 0, %x
  %cmp = icmp ult i8 %neg_x, %x
  ret i1 %cmp
}

define i1 @t7(i8 %x) {
; CHECK-LABEL: @t7(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[X:%.*]], 1
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg_x = sub nsw i8 0, %x
  %cmp = icmp ule i8 %neg_x, %x
  ret i1 %cmp
}

define i1 @t8(i8 %x) {
; CHECK-LABEL: @t8(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg_x = sub nsw i8 0, %x
  %cmp = icmp eq i8 %neg_x, %x
  ret i1 %cmp
}

define i1 @t9(i8 %x) {
; CHECK-LABEL: @t9(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i8 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg_x = sub nsw i8 0, %x
  %cmp = icmp ne i8 %neg_x, %x
  ret i1 %cmp
}

define i1 @n10(i8 %x) {
; CHECK-LABEL: @n10(
; CHECK-NEXT:    [[NEG_X:%.*]] = sub i8 0, [[X:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[X]], [[NEG_X]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg_x = sub i8 0, %x ; not nsw
  %cmp = icmp sgt i8 %neg_x, %x
  ret i1 %cmp
}

define i1 @n11(i8 %x) {
; CHECK-LABEL: @n11(
; CHECK-NEXT:    [[NEG_X:%.*]] = sub nsw i8 1, [[X:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[NEG_X]], [[X]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg_x = sub nsw i8 1, %x ; not negation
  %cmp = icmp sgt i8 %neg_x, %x
  ret i1 %cmp
}

define i1 @n12(i8 %x1, i8 %x2) {
; CHECK-LABEL: @n12(
; CHECK-NEXT:    [[NEG_X:%.*]] = sub nsw i8 0, [[X1:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[X2:%.*]], [[NEG_X]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %neg_x = sub nsw i8 0, %x1 ; not %x2
  %cmp = icmp sgt i8 %neg_x, %x2 ; not %x1
  ret i1 %cmp
}
