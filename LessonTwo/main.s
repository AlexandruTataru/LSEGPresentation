	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 12, 0	sdk_version 12, 3
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	stp	x29, x30, [sp, #-16]!           ; 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w0, #1
	mov	w1, #2
	bl	__Z3sumIiET_S0_S0_
	fmov	d0, #1.00000000
	fmov	d1, #2.00000000
	bl	__Z3sumIdET_S0_S0_
	mov	w0, #0
	ldp	x29, x30, [sp], #16             ; 16-byte Folded Reload
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z3sumIiET_S0_S0_              ; -- Begin function _Z3sumIiET_S0_S0_
	.weak_def_can_be_hidden	__Z3sumIiET_S0_S0_
	.p2align	2
__Z3sumIiET_S0_S0_:                     ; @_Z3sumIiET_S0_S0_
	.cfi_startproc
; %bb.0:
	add	w0, w1, w0
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	__Z3sumIdET_S0_S0_              ; -- Begin function _Z3sumIdET_S0_S0_
	.weak_def_can_be_hidden	__Z3sumIdET_S0_S0_
	.p2align	2
__Z3sumIdET_S0_S0_:                     ; @_Z3sumIdET_S0_S0_
	.cfi_startproc
; %bb.0:
	fadd	d0, d0, d1
	ret
	.cfi_endproc
                                        ; -- End function
.subsections_via_symbols
