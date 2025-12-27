; assembly code for simple letter guessing game
; the game prints some information to the screen
; As an array of the guesses over the time
; Has comparison of the guess with the actual letter thinking of
; Some of the concepts in here could be adapted for use your coursework Task 2

section	.data
welcome db "Welcome to this simple guessing game", 10 ;Welcome message for game

welcomeLen equ $-welcome ; calculate thec welcome message length
samemsg db "You guess correctly.  They are the same.  ", 10 ;Message that the guess is correct
samelen equ $-samemsg ;Calculate the length of the message

notsamemsg db "Your guess is incorrect. They are not the same: ", 10 ;Message that the guess is incorrect 
notsamelen equ $-notsamemsg ;Calculate the length of the message

question db "Guess the letter I am thinking of", 10 ; Message asking question
questionLen equ $-question ; Calculate the length of the message
letterMessage db "The letter I was thinking of is: " ; Message explaining the letter that was selected
letterMessageLen equ $-letterMessage ; calculate the length of the Message
cr db 10 ;for creating a new line same as endl in C++

;the array we are using to store the correct answers for the guessing game
global listAnswers
listAnswers:    
  dq  'a' ; the answer letters are stores in 8 bytes to aid the comparison that is why we are using the data type dq
  dq  'b'
  dq  'c'
  dq 'd'
  dq 'e'
letter: 
  dq  0 ; where we store each of the answers one at a time

section .bss
guess resb 1  ; variable to store the user's character guess

section	.text
   global _start   ;must be declared for linker (ld)
_start:	
call displayWelcome
call newLine
mov  rax,5      ;number of answers and so possible questions
mov  rbx,0      ;RBX will store the letter currently being guessed
mov  rcx, listAnswers     ;RCX will point to the current element in array to be guessed

;Main function that calls other functions
top:  
  mov  rbx, [rcx] ; put the current letter being guessed in rbx
  mov [letter],rbx ; move rbx into a variable letter that stores the current correct answer
  push rax ; push rax on stack
  push rcx ; push rax on stack
  call displayQuestion ; call subroutine to display the question
  call reading ; call subroutine to get the users guess and compare the guess with the correct letter
  call displayletterMessage ; call subroutine to display the message for the correct letter
  call display ; call subroutine to print the correct letter 
  call newLine ; new line like endl in C++
  pop rcx ; get back from stack
  pop rax ; get back from stack
  add  rcx,8     ;move pointer to next element in the essay.  As 8 bits for each letter move on by 8
  dec  rax        ;decrement counter by one so going down 
  jnz  top        ;if counter not 0, then loop again
  call done ; call subroutine to end program

;Display function
display:
  mov  edx,1      ;message length
  mov  ecx, letter   ;message to write the correct letter
  mov  ebx, 1     ;file descriptor (stdout)
  mov  eax, 4     ;system call number (sys_write)
  int  0x80       ;call kernel
	ret

 ;function to read the user guess and do comparison with the answer
 reading:
  mov eax, 3 ; read from keyboard
  mov ebx, 2;  stdin
  mov ecx, guess ; move user guess into ecx
  mov edx, 1 ;  As single letter using 1 byte
  int 80h	; invoke the kernel to get the user's guess
  mov   rax, [guess] ; move guess by user into rax
  cmp   rax, [letter]  ; compare correct answer with what in rax
  je    same ; if guess was correct jump to same function
  call Notsame ; if the guess is incorrect then go to Notsame function
  ret ; return to the main section

; function to show message that answer was not correct answer
 Notsame:
  mov   ecx,notsamemsg ; Not same message
  mov   edx, notsamelen ; length of same message
  mov   ebx,1	;file descriptor (stdout)
  mov   eax,4	;system call number (sys_write)
  int 80h ; invoke the kernel to display message

  mov eax, 3 ; read to clear the keyboard buffer
  mov ebx, 2 ;  stdin
  mov ecx, guess ; Clear the key press from the user input so it does not messy up loop
  mov edx, 1 ;  As single character using 1 byte
  int 80h	; invoke the kernel to take the enter key press to clear the keyboard buffer
   ret ; return to main code

; function to show message answer was correct
same:
  mov   ecx,samemsg ; same message
  mov   edx, samelen ; length of same message
  mov   ebx,1	;file descriptor (stdout)
  mov   eax,4	;system call number (sys_write)
  int 80h ; invoke the kernel to display message

  mov eax, 3 ; read to clear the keyboard buffer
  mov ebx, 2 ;  stdin
  mov ecx, guess ; Clear the key press from the user input so it does not messy up loop
  mov edx, 1 ;  As single character using 1 byte
  int 80h	; invoke the kernel to take the enter key press to clear the keyboard buffer
   ret ; return to main code


; Function to create a New line like endl in C++
 newLine:
  mov eax,4 	; Put 4 in eax register into which is system 
               ;call for write (sys_write)	
  mov ebx,1 	; Put 1 in ebx register which is the standard 
			; output to the screen 
  mov ecx, cr	; Put the newline value into ecx register
  mov edx, 1	; Put the length of the newline value into edx 
			; register
  int 80h 	; Call the kernel with interrupt to check the 
			; registers and perform the action of moving to 
			; the next line like endl in c++
   ret	; return to previous position in code 

;Function to display welcome to game message
displayWelcome:
   mov  edx,welcomeLen      ;message length
   mov  ecx, welcome   ;message to write
   mov  ebx, 1     ;file descriptor (stdout)
   mov  eax, 4     ;system call number (sys_write)
   int  0x80       ;invoke the kernel to print the message
   ret ; return to the main section

;Function to display question for quiz
displayQuestion:
   mov  edx,questionLen      ;message length
   mov  ecx, question  ;message to write
   mov  ebx, 1     ;file descriptor (stdout)
   mov  eax, 4     ;invoke the kernel to print the message
   int  0x80       ;call kernel
   ret ; return to the main section

; Function to display the correct answer sentence
displayletterMessage:
   mov  edx,letterMessageLen      ;message length
   mov  ecx, letterMessage  ;message to write
   mov  ebx, 1     ;file descriptor (stdout)
   mov  eax, 4     ;system call number (sys_write)
   int  0x80       ;invoke the kernel to print the message
   ret ; return to the main section

; Function to end the program
 done:
   mov  eax, 1     ;system call number (sys_exit)
   int  0x80       ;invoke the kernel to end the program