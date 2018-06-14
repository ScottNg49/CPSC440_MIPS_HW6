#Scott Ng
#CPSC 440-04
#Assignment 6
#Due Date: 03/07/18

.data	
	promptScale: .asciiz "\n           Enter Scale: "
        promptTempr: .asciiz "     Enter Temperature: "
	promptCelci: .asciiz "   Celcius Temperature: "
        promptFaren: .asciiz "Fahrenheit Temperature: "
        promptCompl: .asciiz "Done"
	userScale: .space 3                             #allowing max 3 spaces for userScale
                                                        #letter + enter + end of line
.text

.globl main

main: 
	li $v0, 4                                       #loads display command
	la $a0, promptScale                             #load address for display promptScale
	syscall                                         #execute instructions

	li $v0, 8                                       #command for user input
        la $a0, userScale                               #asks user for scale F or C or Q
	li $a1, 3                                       #max space for user input
        syscall

	lb $t0, userScale($zero)
	beq $t0, 0x43, celci                            #if scale is C go to celci
	beq $t0, 0x46, faren                            #if scale is F go to faren
        beq $t0, 0x51, exit                             #if scale is Q go to exit
	beq $t0, 0x71, exit                             #if scale is q go to exit

faren:
	#function goes from Farenheit to Celcius
	#prompting user for temperature
	li $v0, 4
	la $a0, promptTempr
	syscall

	#asking user for temperature input
	li $v0, 5                                       #loads user input integer command               
	syscall
	
	move $t0, $v0                                   #moves user value from $v0 to $t0
 	
	#convert temperature
	sub $t0, $t0, 0x20

	li $t1, 5
	multu $t0, $t1                                  #mul result is tored in LO
	mflo $t0                                        #moves LO to $t0

	li $t1, 9
	divu $t0, $t1

	#display
	li $v0, 4
	la $a0, promptCelci
	syscall

	li $v0, 1                                       #display from register
	mflo $a0                                        #moves quotient into a0
	syscall

	j main
	
celci:
	#function goes from Celcius to Farenheit
	#prompting user for temperature
	li $v0, 4
	la $a0, promptTempr
	syscall

	#asking user for temperature input
	li $v0, 5                                       #loads user input integer command               
	syscall
	
	move $t0, $v0                                   #moves user value from $v0 to $t0

	#convert temperature
	li $t1, 0x09
	multu $t0, $t1                                  #mul, result is stored in LO
	mflo $t0                                        #moves $LO to $t0

	li $t1, 0x05
	divu $t0, $t1                                   #div, result is stored in HI
	mflo $t1                                        #moves $HI to $t0

	addi $t0, $t1, 0x20

	#display
	li $v0, 4
	la $a0, promptFaren
	syscall

	li $v0, 1                                       #display from register
	move $a0, $t0                                   #moves $t0 to $a0 for displayqts
	syscall

	j main
exit:
	li $v0, 4                                       #loads display command
	la $a0, promptCompl
	syscall
	
	li $v0, 10                                      #exits
	syscall
