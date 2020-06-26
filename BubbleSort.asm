# 1- Ler arquivo
# 2- Salvar caracteres do arquivo em array
# 3- Percorrer array transformando caracteres em inteiros
# 4- Mandar array para o bubble sort
# 5- Printar array ordenado

.data  
antes:		.asciiz "\n-------- Numeros antes da Ordenacao --------\n\n"
ordenado:	.asciiz "\n\n------------ Numeros Ordenados ------------\n\n"
myFile: 	.asciiz "numeros.txt"		# filename
buffer: 	.space 4096
vetor:		.word 10
.text

# Open file for reading

li	$v0, 13         			# system call for open file
la	$a0, myFile     			# input file name
li	$a1, 0          			# flag for reading
li	$a2, 0          			# mode is ignored
syscall               				# open a file 

move	$s0, $v0        			# save the file descriptor  


# reading from file just opened

li	$v0, 14        				# system call for reading from file
move	$a0, $s0       				# file descriptor 
la	$a1, buffer   				# address of buffer from which to read
li	$a2, 50       				# hardcoded buffer length
syscall             				# read from file


# Printing File Content

li	$v0, 4					
la	$a0, antes
syscall

li 	$v0, 4          			# system Call for PRINT STRING
la 	$a0, buffer     			# buffer contains the values
syscall             				# print string

la 	$a0, buffer 				# load byte space into address
move 	$t0, $a0 				# save string to t0


addi  	$t1, $0, 0  				# i = 0
sw 	$zero, vetor($t1)			# zera a primeira posição do vetor

percorre:
	lb  	$a0, ($t0)
	beq 	$a0, 0, fimpercorre		# condição pro loop
	
	move 	$t2, $a0
        
        sub 	$t4, $t2, 48			# converte para inteiro o que está em t2 e salva em t4
        
        beq 	$t4, -16, proximo		# pula iteração quando o caractere é um espaço
        beq 	$t4, -38, proximo		# pula iteração quando o caractere é uma quebra de linha
        
        lw	$t5, vetor($t1)			# carrega o valor guardado na posição t1 do vetor em t5
        
        mul 	$t5, $t5, 10			# multiplica o valor na posicao $t1 por 10
        add 	$t4, $t4, $t5			# salva no t4 a soma de t4 + t5
        
        sw  	$t4, vetor($t1)			# salva o valor no vetor

        addi  	$t0, $t0, 1 			# incrementa índice do leitor da string
  
        j 	percorre
        
proximo:
        addi  	$t0, $t0, 1 			# incrementa índice do leitor da string
        addi  	$t1, $t1, 4			# incrementa índice do leitor do vetor
        
	sw    	$zero, vetor($t1)		# inicializa com 0 a posição t1 do vetor
        
        j   	percorre
        
fimpercorre:        
       	addi   	 $t0, $0, 0
        addi    $t3, $0, 4 
	addi	$t7, $0, 4			# t7 = 4
	
for1:
	slti	$t1, $t0, 10			# ? (i menor 10)
	beq	$t1, $0, fimfor1		# se for falso, pula para fimfor1
	addi	$t2, $t0, 1 			# j = i + 1
	
for2:
	slti	$t3, $t2, 10			# ? (j menor 10)
	beq	$t3, $0, fimfor2		# se for falso, pula para fimfor2
	mul 	$t4, $t7, $t0			# indice i
	mul	$t5, $t7, $t2			# indice j
	lw	$s1, vetor($t4)			# vetor[i]
	lw	$s2, vetor($t5)			# vetor[j]
	
if1:
	sgt	$t6, $s1, $s2			# ? (vetor[i] maior vetor[j])
	beq	$t6, $0, fimif1
	add	$t6, $s1, $0			# aux = vetor[i]
	add	$s1, $s2, $0			# vetor[i] = vetor[j]
	add	$s2, $t6, $0			# vetor[j] = aux
	sw	$s1, vetor($t4)			# salva vetor[i] na memoria
	sw	$s2, vetor($t5)			# salva vetor[j] na memoria
	
fimif1:

	addi	$t2, $t2, 1			# j++
	j	for2
	
fimfor2:

	addi 	$t0, $t0, 1			# i++
	j 	for1
	
fimfor1:

	addi 	$t0, $0, 0			# i = 0
	addi 	$t3, $0, 4			# t3 = 4
	
	li	$v0, 4					
	la	$a0, ordenado
	syscall
	
forimprimir:
	slti 	$t1, $t0, 10			# ? (i < 10)
	beq	$t1, $0, fimforimprimir
	mul	$t2, $t0, $t3			# indice I
	
	lw	$a0, vetor($t2)			# vetor[i]
	li	$v0, 1	
	syscall
	
	li 	$v0, 11					
	la	$a0, 32				# imprimi " " na tela
	syscall					# chamada do Sistema 
	
	addi 	$t0, $t0, 1			# i++
	j	forimprimir
	
fimforimprimir:

termina:
	li $v0, 10
	syscall

