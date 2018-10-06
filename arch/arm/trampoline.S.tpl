  .globl $sym
$sym:
  .cfi_startproc

1:
  // Load address
  // TODO: can we do this faster on newer ARMs?
  ldr ip, 3f
2:
  add ip, pc, ip
  ldr ip, [ip, #$offset]

  cmp ip, #0

  // Fast path
  bxne ip

  // Slow path
  ldr ip, =$number
  push {ip}
  .cfi_adjust_cfa_offset 4
  PUSH_REG(lr)
  bl _${sym_suffix}_save_regs_and_resolve
  POP_REG(lr)
  add sp, #4
  .cfi_adjust_cfa_offset -4
  b 1b
  .cfi_endproc

3:
  .word _${sym_suffix}_tramp_table - (2b + 8)
