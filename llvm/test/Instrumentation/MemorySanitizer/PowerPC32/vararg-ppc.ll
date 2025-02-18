; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 5
; RUN: opt < %s -S -passes=msan -msan-origin-base=0x40000000 -msan-and-mask=0x80000000 2>&1 | FileCheck %s

target datalayout = "E-m:e-i64:64-n32:64"
target triple = "powerpc--linux"

define i32 @foo(i32 %guard, ...) {
; CHECK-LABEL: define i32 @foo(
; CHECK-SAME: i32 [[GUARD:%.*]], ...) {
; CHECK-NEXT:    [[TMP2:%.*]] = load i64, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    [[TMP3:%.*]] = alloca i8, i64 [[TMP2]], align 8
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[TMP3]], i8 0, i64 [[TMP2]], i1 false)
; CHECK-NEXT:    [[TMP4:%.*]] = call i64 @llvm.umin.i64(i64 [[TMP2]], i64 800)
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr align 8 [[TMP3]], ptr align 8 @__msan_va_arg_tls, i64 [[TMP4]], i1 false)
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[VL:%.*]] = alloca ptr, align 8
; CHECK-NEXT:    [[TMP5:%.*]] = ptrtoint ptr [[VL]] to i64
; CHECK-NEXT:    [[TMP8:%.*]] = and i64 [[TMP5]], -2147483649
; CHECK-NEXT:    [[TMP9:%.*]] = inttoptr i64 [[TMP8]] to ptr
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[TMP9]], i8 0, i64 8, i1 false)
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 32, ptr [[VL]])
; CHECK-NEXT:    [[TMP18:%.*]] = ptrtoint ptr [[VL]] to i64
; CHECK-NEXT:    [[TMP19:%.*]] = and i64 [[TMP18]], -2147483649
; CHECK-NEXT:    [[TMP10:%.*]] = inttoptr i64 [[TMP19]] to ptr
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 [[TMP10]], i8 0, i64 12, i1 false)
; CHECK-NEXT:    call void @llvm.va_start.p0(ptr [[VL]])
; CHECK-NEXT:    [[TMP11:%.*]] = ptrtoint ptr [[VL]] to i64
; CHECK-NEXT:    [[TMP12:%.*]] = add i64 [[TMP11]], 8
; CHECK-NEXT:    [[TMP13:%.*]] = inttoptr i64 [[TMP12]] to ptr
; CHECK-NEXT:    [[TMP14:%.*]] = load ptr, ptr [[TMP13]], align 8
; CHECK-NEXT:    [[TMP15:%.*]] = ptrtoint ptr [[TMP14]] to i64
; CHECK-NEXT:    [[TMP16:%.*]] = and i64 [[TMP15]], -2147483649
; CHECK-NEXT:    [[TMP17:%.*]] = inttoptr i64 [[TMP16]] to ptr
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr align 8 [[TMP17]], ptr align 8 [[TMP3]], i64 [[TMP2]], i1 false)
; CHECK-NEXT:    call void @llvm.va_end.p0(ptr [[VL]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 32, ptr [[VL]])
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 0
;
  %vl = alloca ptr, align 8
  call void @llvm.lifetime.start.p0(i64 32, ptr %vl)
  call void @llvm.va_start(ptr %vl)
  call void @llvm.va_end(ptr %vl)
  call void @llvm.lifetime.end.p0(i64 32, ptr %vl)
  ret i32 0
}

; First, check allocation of the save area.




declare void @llvm.lifetime.start.p0(i64, ptr nocapture) #1
declare void @llvm.va_start(ptr) #2
declare void @llvm.va_end(ptr) #2
declare void @llvm.lifetime.end.p0(i64, ptr nocapture) #1

define i32 @bar() {
; CHECK-LABEL: define i32 @bar() {
; CHECK-NEXT:    [[TMP1:%.*]] = load i64, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    store i32 0, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    store i32 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 8) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 24) to ptr), align 8
; CHECK-NEXT:    store i32 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 4) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 8) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    store i64 24, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    [[TMP3:%.*]] = call i32 (i32, ...) @foo(i32 0, i32 1, i64 2, double 3.000000e+00)
; CHECK-NEXT:    [[_MSRET:%.*]] = load i32, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %1 = call i32 (i32, ...) @foo(i32 0, i32 1, i64 2, double 3.000000e+00)
  ret i32 %1
}

; Save the incoming shadow value from the arguments in the __msan_va_arg_tls
; array.  The first argument is stored at position 4, since it's right
; justified.

; Check vector argument.
define i32 @bar2() {
; CHECK-LABEL: define i32 @bar2() {
; CHECK-NEXT:    [[TMP1:%.*]] = load i64, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    store i32 0, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    store <2 x i64> zeroinitializer, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 8) to ptr), align 8
; CHECK-NEXT:    store <2 x i64> zeroinitializer, ptr @__msan_va_arg_tls, align 8
; CHECK-NEXT:    store i64 16, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    [[TMP3:%.*]] = call i32 (i32, ...) @foo(i32 0, <2 x i64> <i64 1, i64 2>)
; CHECK-NEXT:    [[_MSRET:%.*]] = load i32, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %1 = call i32 (i32, ...) @foo(i32 0, <2 x i64> <i64 1, i64 2>)
  ret i32 %1
}

; The vector is at offset 16 of parameter save area, but __msan_va_arg_tls
; corresponds to offset 8+ of parameter save area - so the offset from
; __msan_va_arg_tls is actually misaligned.

; Check i64 array.
define i32 @bar4() {
; CHECK-LABEL: define i32 @bar4() {
; CHECK-NEXT:    [[TMP1:%.*]] = load i64, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    store i32 0, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    store [2 x i64] zeroinitializer, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 8) to ptr), align 8
; CHECK-NEXT:    store [2 x i64] zeroinitializer, ptr @__msan_va_arg_tls, align 8
; CHECK-NEXT:    store i64 16, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    [[TMP3:%.*]] = call i32 (i32, ...) @foo(i32 0, [2 x i64] [i64 1, i64 2])
; CHECK-NEXT:    [[_MSRET:%.*]] = load i32, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %1 = call i32 (i32, ...) @foo(i32 0, [2 x i64] [i64 1, i64 2])
  ret i32 %1
}


; Check i128 array.
define i32 @bar5() {
; CHECK-LABEL: define i32 @bar5() {
; CHECK-NEXT:    [[TMP1:%.*]] = load i64, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    store i32 0, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    store [2 x i128] zeroinitializer, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 8) to ptr), align 8
; CHECK-NEXT:    store [2 x i128] zeroinitializer, ptr @__msan_va_arg_tls, align 8
; CHECK-NEXT:    store i64 32, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    [[TMP3:%.*]] = call i32 (i32, ...) @foo(i32 0, [2 x i128] [i128 1, i128 2])
; CHECK-NEXT:    [[_MSRET:%.*]] = load i32, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %1 = call i32 (i32, ...) @foo(i32 0, [2 x i128] [i128 1, i128 2])
  ret i32 %1
}


; Check 8-aligned byval.
define i32 @bar6(ptr %arg) {
; CHECK-LABEL: define i32 @bar6(
; CHECK-SAME: ptr [[ARG:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = load i64, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    store i32 0, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP3:%.*]] = ptrtoint ptr [[ARG]] to i64
; CHECK-NEXT:    [[TMP6:%.*]] = and i64 [[TMP3]], -2147483649
; CHECK-NEXT:    [[TMP7:%.*]] = inttoptr i64 [[TMP6]] to ptr
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 8) to ptr), i8 0, i64 16, i1 false)
; CHECK-NEXT:    [[TMP9:%.*]] = ptrtoint ptr [[ARG]] to i64
; CHECK-NEXT:    [[TMP10:%.*]] = and i64 [[TMP9]], -2147483649
; CHECK-NEXT:    [[TMP8:%.*]] = inttoptr i64 [[TMP10]] to ptr
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr align 8 @__msan_va_arg_tls, ptr align 8 [[TMP8]], i64 16, i1 false)
; CHECK-NEXT:    store i64 16, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    [[TMP13:%.*]] = call i32 (i32, ...) @foo(i32 0, ptr byval([2 x i64]) align 8 [[ARG]])
; CHECK-NEXT:    [[_MSRET:%.*]] = load i32, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[TMP13]]
;
  %1 = call i32 (i32, ...) @foo(i32 0, ptr byval([2 x i64]) align 8 %arg)
  ret i32 %1
}


; Check 16-aligned byval.
define i32 @bar7(ptr %arg) {
; CHECK-LABEL: define i32 @bar7(
; CHECK-SAME: ptr [[ARG:%.*]]) {
; CHECK-NEXT:    [[TMP1:%.*]] = load i64, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    store i32 0, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP3:%.*]] = ptrtoint ptr [[ARG]] to i64
; CHECK-NEXT:    [[TMP6:%.*]] = and i64 [[TMP3]], -2147483649
; CHECK-NEXT:    [[TMP7:%.*]] = inttoptr i64 [[TMP6]] to ptr
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 8 inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 8) to ptr), i8 0, i64 32, i1 false)
; CHECK-NEXT:    [[TMP9:%.*]] = ptrtoint ptr [[ARG]] to i64
; CHECK-NEXT:    [[TMP10:%.*]] = and i64 [[TMP9]], -2147483649
; CHECK-NEXT:    [[TMP8:%.*]] = inttoptr i64 [[TMP10]] to ptr
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr align 8 @__msan_va_arg_tls, ptr align 8 [[TMP8]], i64 32, i1 false)
; CHECK-NEXT:    store i64 32, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    [[TMP13:%.*]] = call i32 (i32, ...) @foo(i32 0, ptr byval([4 x i64]) align 16 [[ARG]])
; CHECK-NEXT:    [[_MSRET:%.*]] = load i32, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[TMP13]]
;
  %1 = call i32 (i32, ...) @foo(i32 0, ptr byval([4 x i64]) align 16 %arg)
  ret i32 %1
}



; Test that MSan doesn't generate code overflowing __msan_va_arg_tls when too many arguments are
; passed to a variadic function.
define dso_local i64 @many_args() {
; CHECK-LABEL: define dso_local i64 @many_args() {
; CHECK-NEXT:  [[ENTRY:.*:]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i64, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    store i64 0, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 8) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 24) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 32) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 40) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 48) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 56) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 64) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 72) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 80) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 88) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 96) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 104) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 112) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 120) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 128) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 136) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 144) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 152) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 160) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 168) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 176) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 184) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 192) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 200) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 208) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 216) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 224) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 232) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 240) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 248) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 256) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 264) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 272) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 280) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 288) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 296) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 304) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 312) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 320) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 328) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 336) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 344) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 352) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 360) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 368) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 376) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 384) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 392) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 400) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 408) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 416) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 424) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 432) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 440) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 448) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 456) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 464) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 472) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 480) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 488) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 496) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 504) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 512) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 520) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 528) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 536) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 544) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 552) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 560) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 568) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 576) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 584) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 592) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 600) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 608) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 616) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 624) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 632) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 640) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 648) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 656) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 664) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 672) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 680) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 688) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 696) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 704) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 712) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 720) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 728) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 736) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 744) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 752) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 760) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 768) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 776) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 784) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 792) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr @__msan_va_arg_tls, align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 8) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 24) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 32) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 40) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 48) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 56) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 64) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 72) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 80) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 88) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 96) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 104) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 112) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 120) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 128) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 136) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 144) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 152) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 160) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 168) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 176) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 184) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 192) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 200) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 208) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 216) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 224) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 232) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 240) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 248) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 256) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 264) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 272) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 280) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 288) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 296) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 304) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 312) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 320) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 328) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 336) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 344) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 352) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 360) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 368) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 376) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 384) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 392) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 400) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 408) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 416) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 424) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 432) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 440) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 448) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 456) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 464) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 472) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 480) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 488) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 496) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 504) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 512) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 520) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 528) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 536) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 544) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 552) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 560) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 568) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 576) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 584) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 592) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 600) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 608) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 616) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 624) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 632) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 640) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 648) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 656) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 664) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 672) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 680) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 688) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 696) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 704) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 712) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 720) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 728) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 736) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 744) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 752) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 760) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 768) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 776) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 784) to ptr), align 8
; CHECK-NEXT:    store i64 0, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_va_arg_tls to i64), i64 792) to ptr), align 8
; CHECK-NEXT:    store i64 960, ptr @__msan_va_arg_overflow_size_tls, align 8
; CHECK-NEXT:    store i64 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    [[RET:%.*]] = call i64 (i64, ...) @sum(i64 120, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1)
; CHECK-NEXT:    [[_MSRET:%.*]] = load i64, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    store i64 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i64 [[RET]]
;
entry:
  %ret = call i64 (i64, ...) @sum(i64 120,
  i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1,
  i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1,
  i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1,
  i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1,
  i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1,
  i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1,
  i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1,
  i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1,
  i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1,
  i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1,
  i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1,
  i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1, i64 1
  )
  ret i64 %ret
}

; If the size of __msan_va_arg_tls changes the second argument of `add` must also be changed.
declare i64 @sum(i64 %n, ...)
