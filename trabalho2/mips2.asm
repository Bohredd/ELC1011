.data
  x_value: .float 57.23
  sym_fnc: .asciiz "cos(x): "
  nl:      .asciiz "\n"

.text
.globl main

main:
  # Carregar o valor de x
  lwc1 $f0, x_value

  jal qcos

  # Imprimir o resultado
  li $v0, 4
  la $a0, sym_fnc
  syscall

  li $v0, 2
  mov.s $f12, $f0
  syscall

  # Sair do programa
  li $v0, 10
  syscall

# qcos -- calcular cosseno
#
# RETORNA:
#   $f0 -- cos(x)
#
# argumentos:
#   $f0 -- valor x
#
# registradores:
#   $f2 -- valor x
#   $f4 -- soma
#   $f6 -- xpow (x^n)
#   $f8 -- n2m1
#   $f10 -- fatorial (nfac)
#   $f12 -- RESERVADO (usado em prtflt)
#   $f14 -- termo atual
#   $f16 -- x^2
#
#   $f18 -- valor 1
#
#   $t0 -- valor zero
#   $t1 -- valor um
#
#   $t6 -- sinal de negação
#   $t7 -- contador de iterações
qcos:
  move $s0, $ra      # salvar endereço de retorno
  mov.s $f2, $f0    # salvar valor x

  mul.s $f16, $f2, $f2   # obter x^2

  li $t0, 0       # obter um zero
  li $t1, 1       # obter um um

  li $t6, 1       # começar com termo positivo

  # xpow = 1
  mtc1 $t1, $f6   # xpow = 1
  cvt.s.w $f6, $f6   # converter para float

  # n2m1 = 0
  mtc1 $t0, $f8   # n2m1 = 0
  cvt.s.w $f8, $f8   # converter para float

  # nfac = 1
  mtc1 $t1, $f10   # nfac = 1
  cvt.s.w $f10, $f10   # converter para float

  # obter um valor de 1
  mtc1 $t1, $f18   # valor temporário de um
  cvt.s.w $f18, $f18   # converter para float

  # zerar a soma
  mtc1 $t0, $f4   # soma = 0
  cvt.s.w $f4, $f4   # converter para float

  li $t7, 10     # definir número de iterações

cosloop:
  div.s $f14, $f6, $f10   # cur = xpow / nfac

  # aplicar o termo à soma
  bgtz $t6, cospos   # fazer positivo? sim, vá em frente
  sub.s $f4, $f4, $f14   # subtrair o termo
  b cosneg

cospos:
  add.s $f4, $f4, $f14   # adicionar o termo

cosneg:
  subi $t7, $t7, 1   # diminuir o contador de iterações
  blez $t7, cosdone   # estamos prontos? se sim, vá em frente

  # calcular valores intermediários para o _próximo_ termo

  # obter o próximo termo de potência
  mul.s $f6, $f6, $f16   # xpow *= x^2

  # ir de fatorial(2n) para fatorial(2n+1)
  add.s $f8, $f8, $f18   # n2m1 += 1
  mul.s $f10, $f10, $f8   # nfac *= n2m1

  # ir de fatorial(2n+1) para fatorial(2n+1+1)
  add.s $f8, $f8, $f18   # n2m1 += 1
  mul.s $f10, $f10, $f8   # nfac *= n2m1

  neg $t6, $t6   # inverter sinal para a próxima vez
  j cosloop

cosdone:
  mov.s $f0, $f4   # definir o valor de retorno
  
  jr $ra

# prtflt -- imprimir número float
#
# argumentos:
#   $a0 -- string de prefixo (nome do símbolo)
#   $f12 -- número para imprimir
prtflt:
  li $v0, 4   # syscall: imprimir string
  syscall

  li $v0, 2   # imprimir float
  syscall

  li $v0, 4   # syscall: imprimir string
  la $a0, nl   # imprimir nova linha
  syscall

  jr $ra
