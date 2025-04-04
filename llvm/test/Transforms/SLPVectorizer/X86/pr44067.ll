; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=slp-vectorizer -S -mtriple=x86_64-unknown-linux-gnu < %s | FileCheck %s

; See https://reviews.llvm.org/D83779

define <2 x float> @foo(ptr %A) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x float>, ptr [[A:%.*]], align 8
; CHECK-NEXT:    [[TMP2:%.*]] = fmul <2 x float> [[TMP1]], splat (float 2.000000e+00)
; CHECK-NEXT:    ret <2 x float> [[TMP2]]
;
entry:
  %0 = load <2 x float>, ptr %A
  %L0 = extractelement <2 x float> %0, i32 0
  %L1 = extractelement <2 x float> %0, i32 1
  %Mul0 = fmul float %L0, 2.000000e+00
  %Mul1 = fmul float %L1, 2.000000e+00
  %Ins1 = insertelement <2 x float> undef, float %Mul1, i32 1
  %Ins0 = insertelement <2 x float> %Ins1, float %Mul0, i32 0
  ret <2 x float> %Ins0
}


%Struct1Ty = type { i16, i16 }
%Struct2Ty = type { %Struct1Ty, %Struct1Ty}

define {%Struct2Ty, %Struct2Ty} @StructOfStructOfStruct(ptr %Ptr) {
; CHECK-LABEL: @StructOfStructOfStruct(
; CHECK-NEXT:    [[TMP2:%.*]] = load <8 x i16>, ptr [[PTR:%.*]], align 2
; CHECK-NEXT:    [[TMP3:%.*]] = add <8 x i16> [[TMP2]], <i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7, i16 8>
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <8 x i16> [[TMP3]], i32 1
; CHECK-NEXT:    [[STRUCTIN0:%.*]] = insertvalue [[STRUCT1TY:%.*]] undef, i16 [[TMP4]], 1
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <8 x i16> [[TMP3]], i32 0
; CHECK-NEXT:    [[STRUCTIN1:%.*]] = insertvalue [[STRUCT1TY]] [[STRUCTIN0]], i16 [[TMP5]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <8 x i16> [[TMP3]], i32 2
; CHECK-NEXT:    [[STRUCTIN2:%.*]] = insertvalue [[STRUCT1TY]] undef, i16 [[TMP6]], 0
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <8 x i16> [[TMP3]], i32 3
; CHECK-NEXT:    [[STRUCTIN3:%.*]] = insertvalue [[STRUCT1TY]] [[STRUCTIN2]], i16 [[TMP7]], 1
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <8 x i16> [[TMP3]], i32 4
; CHECK-NEXT:    [[STRUCTIN4:%.*]] = insertvalue [[STRUCT1TY]] undef, i16 [[TMP8]], 0
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <8 x i16> [[TMP3]], i32 5
; CHECK-NEXT:    [[STRUCTIN5:%.*]] = insertvalue [[STRUCT1TY]] [[STRUCTIN4]], i16 [[TMP9]], 1
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <8 x i16> [[TMP3]], i32 7
; CHECK-NEXT:    [[STRUCTIN6:%.*]] = insertvalue [[STRUCT1TY]] undef, i16 [[TMP10]], 1
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <8 x i16> [[TMP3]], i32 6
; CHECK-NEXT:    [[STRUCTIN7:%.*]] = insertvalue [[STRUCT1TY]] [[STRUCTIN6]], i16 [[TMP11]], 0
; CHECK-NEXT:    [[STRUCT2IN0:%.*]] = insertvalue [[STRUCT2TY:%.*]] undef, [[STRUCT1TY]] [[STRUCTIN1]], 0
; CHECK-NEXT:    [[STRUCT2IN1:%.*]] = insertvalue [[STRUCT2TY]] [[STRUCT2IN0]], [[STRUCT1TY]] [[STRUCTIN3]], 1
; CHECK-NEXT:    [[STRUCT2IN2:%.*]] = insertvalue [[STRUCT2TY]] undef, [[STRUCT1TY]] [[STRUCTIN5]], 0
; CHECK-NEXT:    [[STRUCT2IN3:%.*]] = insertvalue [[STRUCT2TY]] [[STRUCT2IN2]], [[STRUCT1TY]] [[STRUCTIN7]], 1
; CHECK-NEXT:    [[RET0:%.*]] = insertvalue { [[STRUCT2TY]], [[STRUCT2TY]] } undef, [[STRUCT2TY]] [[STRUCT2IN3]], 1
; CHECK-NEXT:    [[RET1:%.*]] = insertvalue { [[STRUCT2TY]], [[STRUCT2TY]] } [[RET0]], [[STRUCT2TY]] [[STRUCT2IN1]], 0
; CHECK-NEXT:    ret { [[STRUCT2TY]], [[STRUCT2TY]] } [[RET1]]
;
  %L0 = load i16, ptr %Ptr
  %GEP1 = getelementptr inbounds i16, ptr %Ptr, i64 1
  %L1 = load i16, ptr %GEP1
  %GEP2 = getelementptr inbounds i16, ptr %Ptr, i64 2
  %L2 = load i16, ptr %GEP2
  %GEP3 = getelementptr inbounds i16, ptr %Ptr, i64 3
  %L3 = load i16, ptr %GEP3
  %GEP4 = getelementptr inbounds i16, ptr %Ptr, i64 4
  %L4 = load i16, ptr %GEP4
  %GEP5 = getelementptr inbounds i16, ptr %Ptr, i64 5
  %L5 = load i16, ptr %GEP5
  %GEP6 = getelementptr inbounds i16, ptr %Ptr, i64 6
  %L6 = load i16, ptr %GEP6
  %GEP7 = getelementptr inbounds i16, ptr %Ptr, i64 7
  %L7 = load i16, ptr %GEP7

  %Fadd0 = add i16 %L0, 1
  %Fadd1 = add i16 %L1, 2
  %Fadd2 = add i16 %L2, 3
  %Fadd3 = add i16 %L3, 4
  %Fadd4 = add i16 %L4, 5
  %Fadd5 = add i16 %L5, 6
  %Fadd6 = add i16 %L6, 7
  %Fadd7 = add i16 %L7, 8

  %StructIn0 = insertvalue %Struct1Ty undef, i16 %Fadd1, 1
  %StructIn1 = insertvalue %Struct1Ty %StructIn0, i16 %Fadd0, 0

  %StructIn2 = insertvalue %Struct1Ty undef, i16 %Fadd2, 0
  %StructIn3 = insertvalue %Struct1Ty %StructIn2, i16 %Fadd3, 1

  %StructIn4 = insertvalue %Struct1Ty undef, i16 %Fadd4, 0
  %StructIn5 = insertvalue %Struct1Ty %StructIn4, i16 %Fadd5, 1

  %StructIn6 = insertvalue %Struct1Ty undef, i16 %Fadd7, 1
  %StructIn7 = insertvalue %Struct1Ty %StructIn6, i16 %Fadd6, 0

  %Struct2In0 = insertvalue %Struct2Ty undef, %Struct1Ty %StructIn1, 0
  %Struct2In1 = insertvalue %Struct2Ty %Struct2In0, %Struct1Ty %StructIn3, 1

  %Struct2In2 = insertvalue %Struct2Ty undef, %Struct1Ty %StructIn5, 0
  %Struct2In3 = insertvalue %Struct2Ty %Struct2In2, %Struct1Ty %StructIn7, 1

  %Ret0 = insertvalue {%Struct2Ty, %Struct2Ty} undef, %Struct2Ty %Struct2In3, 1
  %Ret1 = insertvalue {%Struct2Ty, %Struct2Ty} %Ret0, %Struct2Ty %Struct2In1, 0
  ret {%Struct2Ty, %Struct2Ty} %Ret1
}
