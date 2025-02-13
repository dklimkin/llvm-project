; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s -passes=instcombine | FileCheck %s

; Fold
;   (X & C) - X
; to
;   - (X & ~C)
;
; This allows us to possibly hoist said negation further out,
; and decreases use count of X.

; https://bugs.llvm.org/show_bug.cgi?id=44427

; Base tests

define i8 @t0(i8 %x) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[X:%.*]], -43
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    ret i8 [[NEGBIAS]]
;
  %unbiasedx = and i8 %x, 42
  %negbias = sub i8 %unbiasedx, %x
  ret i8 %negbias
}

define <2 x i8> @t1_vec(<2 x i8> %x) {
; CHECK-LABEL: @t1_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i8> [[X:%.*]], splat (i8 -43)
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub <2 x i8> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    ret <2 x i8> [[NEGBIAS]]
;
  %unbiasedx = and <2 x i8> %x, <i8 42, i8 42>
  %negbias = sub <2 x i8> %unbiasedx, %x
  ret <2 x i8> %negbias
}

define <2 x i8> @t2_vec_undef(<2 x i8> %x) {
; CHECK-LABEL: @t2_vec_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i8> [[X:%.*]], <i8 -43, i8 undef>
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub <2 x i8> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    ret <2 x i8> [[NEGBIAS]]
;
  %unbiasedx = and <2 x i8> %x, <i8 42, i8 undef>
  %negbias = sub <2 x i8> %unbiasedx, %x
  ret <2 x i8> %negbias
}

define <2 x i8> @t3_vec_nonsplat(<2 x i8> %x) {
; CHECK-LABEL: @t3_vec_nonsplat(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i8> [[X:%.*]], <i8 -43, i8 -45>
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub <2 x i8> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    ret <2 x i8> [[NEGBIAS]]
;
  %unbiasedx = and <2 x i8> %x, <i8 42, i8 44>
  %negbias = sub <2 x i8> %unbiasedx, %x
  ret <2 x i8> %negbias
}

; Extra uses always prevent fold

declare void @use8(i8)

define i8 @n4_extrause(i8 %x) {
; CHECK-LABEL: @n4_extrause(
; CHECK-NEXT:    [[UNBIASEDX:%.*]] = and i8 [[X:%.*]], 42
; CHECK-NEXT:    call void @use8(i8 [[UNBIASEDX]])
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub i8 [[UNBIASEDX]], [[X]]
; CHECK-NEXT:    ret i8 [[NEGBIAS]]
;
  %unbiasedx = and i8 %x, 42
  call void @use8(i8 %unbiasedx)
  %negbias = sub i8 %unbiasedx, %x
  ret i8 %negbias
}

; Negative tests

define i8 @n5(i8 %x) {
; CHECK-LABEL: @n5(
; CHECK-NEXT:    [[NEGBIAS:%.*]] = and i8 [[X:%.*]], -43
; CHECK-NEXT:    ret i8 [[NEGBIAS]]
;
  %unbiasedx = and i8 %x, 42
  %negbias = sub i8 %x, %unbiasedx ; wrong order
  ret i8 %negbias
}

define i8 @n6(i8 %x0, i8 %x1) {
; CHECK-LABEL: @n6(
; CHECK-NEXT:    [[UNBIASEDX:%.*]] = and i8 [[X1:%.*]], 42
; CHECK-NEXT:    [[NEGBIAS:%.*]] = sub i8 [[UNBIASEDX]], [[X0:%.*]]
; CHECK-NEXT:    ret i8 [[NEGBIAS]]
;
  %unbiasedx = and i8 %x1, 42 ; not %x0
  %negbias = sub i8 %unbiasedx, %x0 ; not %x1
  ret i8 %negbias
}
