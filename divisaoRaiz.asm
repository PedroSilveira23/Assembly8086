org  100h	

jmp start

raiz db 7 dup(0)

len dw 0  ; array inicializado a 0 
lenTotal equ 7   ; numero de digitos da raiz 

r dw 0    

cont1 db 0    ;conta o numero de digitos usados e compara los com 4


;-----------------------variaveis da divisao
dividendo  db 4 dup(0)  ; numero de digitos do dividendo 
divisor db 4 dup(0)     ; numero de digitos do divisor 

Dlen equ 4    ; valor maximo do array que e 4 
mlen dw 0     ; array inicializado a 0 


dv db 0     ; divisor 
s db 0

cont dw 0    ;iniciliza o contador dos digitos a 0

msg1 db 13,10,"Pressione [1]Divisao [2]Raiz Quadrada [3]Sair",13,10,"$"  ; menu incial 


start:
                
        mov dx,offset msg1 ; passa se a mensagem do menu incial  
        mov ah,9   ; funcao de escrever strings   
        int 21h
        
        mov ah,1     ; e pedido ao utilizador para inserir um caracter 
        int 21h
        
        cmp al,50        ; compara o valor 2 em ASCII para iniciar a raiz
        je startRaiz
        
        cmp al,49        ; compara o valor 1 em ASCII para iniciar a divisao
        je startDivisao
        
        cmp al,51        ; se for selecionado o 3 em ASCII salta para o fim 
        jne start
        jmp fim


startRaiz:

        mov ah,2
        mov dl,0
        int 21h
        
        
        xor dx,dx
        xor ax,ax
        xor bx,bx
        mov len,0
        mov lenTotal,7  ; numero de digitos que o utilizador pode utilizar na raiz 
                                                                                                        
      
scan2:

        mov ah, 1   ; introducao de um digito 
        int 21h    
        push ax
        
        cmp al,8
        je decrem
               
        cmp al,48  ; ASCII para 0, se for menor do que este numero LIMPA
        jl limpaN 
                   ; ASCII para 9, se for maior do que este numero LIMPA 
        cmp al,57
        jg limpaN      
                           
        inc len  ; tamanho do array 
        inc bx
        
        cmp bx, lenTotal    ; compara com o tamanho de digitos 
        jae ini
        jl scan2
        
decrem:
        
        dec len
        jmp right 
        
right:
        mov ah, 3  ;Get current position
        int 10h
    
        mov ah, 2  ;Move cursor Right
        add dl, 1
        int 10h

        jmp scan2
        
        
limpaN:
        pop ax
        mov ah, 2
        mov dl, 8    ;backspace
        int 21h
        mov ah, 2
        mov dl, 0    ;espaco vazio
        int 21h
        mov ah, 2
        mov dl, 8    ;backspace
        int 21h
        
        jmp scan2        

ini:
        
        mov ah, 2
        mov dl, 0    
        int 21h
        
        mov ah, 2
        mov dl, 26    ;seta
        int 21h
        
        mov cx, len       
        mov bx, lenTotal  
        dec bx

preenche2:
        pop ax
        sub al,30h
        mov raiz[bx],al
        dec bx 
        loop preenche2   ; preenche array com os valores guardados na stack( valores do user)
        
        xor bx,bx
        mov cx, lenTotal  ; 
        
        
        mov ah, 2
        mov dl, 0    
        int 21h
        mov ah, 2
        mov dl, 61   ; =
        int 21h
        mov ah, 2
        mov dl, 0     
        int 21h
        
        
        lea si, raiz  ; ponteiro do array
        
        xor ax,ax
        add al, [si]
        mov bl, al
        xor bh,bh

inicioRaiz:

        mov cx, 9 
        CA:        
        
        mov ax, 20
        mul r      ; (20*r+cx)*cx
        add ax, cx 
        mul cx     
        
        cmp ax,bx  
        jbe saiCiclo
        
        
        loop CA:
        
        
        mov ax, 20
        mul r
        add ax, cx
        mul cx

saiCiclo:

        sub bx, ax  ; resto=resto-CA        sub de bx 
        mov ax, 100 ; resto=resto*100+Ho
        mul bx
        mov bx, ax
        
        inc si
        mov ax, 10
        mul [si]     ;ho_next
        inc si
        add al, [si]
        add bx, ax
        
        
        mov ah, 2   ;"raiz" do algoritmo da aula um a um
        mov dl, cl
        add dl, 30h
        int 21h     ; escreve o digito seguinte da raiz 
        
        
        mov ax, 10   ; "raiz"="raiz"*10+cx
        mul r
        add ax, cx
        mov r,ax
        
        
        inc cont1
        cmp cont1, 4
        jb inicioRaiz
        
        xor bx,bx
        
        mov cx,7
        
        mov cont1,0
        mov r,0
        
        jmp start     ; retorna ao menu inicial 
;---------------------------------------AQUI COMECA A DIV
startDivisao:

        mov ah,2
        mov dl,0
        int 21h
        
        
        xor ah,ah
        xor bx,bx
        mov mlen, 0   ; tamanho do array esta a 0   
      
scan1:

        mov ah, 1    ; introducao de um digito 
        int 21h
        push ax     
          
        cmp al,48   ; ASCII para 0, se for menor do que este numero LIMPA   
        jl limpaM 
        
        cmp al,57   ; ASCII para 9, se for maior do que este numero LIMPA
        jg limpaM  
        
        inc mlen    ; incrementa o tamanho do array
        inc bx
        
        cmp bx, Dlen ; compara com o valor maximo de digitos (4)  
        jae pross1
        jl scan1     ; volta ao scan1 
        
        
limpaM:
        pop ax
        mov ah, 2
        mov dl, 8    ;backspace
        int 21h
        mov ah, 2
        mov dl, 0    ;espaco vazio
        int 21h
        mov ah, 2
        mov dl, 8    ;backspace
        int 21h
        
        jmp scan1
;----------------------
pross1:
        
        mov ah, 2
        mov dl, 0
        int 21h
        
        mov ah, 2
        mov dl, 47    ;/
        int 21h
        
        mov ah, 2
        mov dl, 0
        int 21h
        
        mov cx, mlen
        mov bx, Dlen
        dec bx

preenche1:
        pop ax
        sub ax,30h
        mov dividendo[bx],al ; preencher dividendo
        dec bx 
        loop preenche1:
        
        xor bx,bx
        mov cx, Dlen
        
        
        
        xor ah,ah
        xor bx,bx
        mov mlen, 0      
;-----------------------scan divisor      
scan3:

        mov ah, 1
        int 21h
        push ax 
        
        cmp al,48   ; ASCII para 0, se for menor do que este numero LIMPA
        jl limpaB 
        
        cmp al,57   ; ASCII para 9, se for maior do que este numero LIMPA
        jg limpaB
        
        inc mlen    ; tamanho do array
        inc bx
        
        cmp bx, Dlen 
        jae ini2 
        jl scan3
        
limpaB:
        pop ax
        mov ah, 2
        mov dl, 8    ;backspace
        int 21h
        mov ah, 2
        mov dl, 0    ;espaco vazio
        int 21h
        mov ah, 2
        mov dl, 8    ;backspace
        int 21h
        
        jmp scan3

ini2:

        
        mov cx, mlen
        mov bx, Dlen
        dec bx
        
ciclo6:
        pop ax
        sub ax,30h
        mov divisor[bx],al
        dec bx 
        loop ciclo6  ; stack para array  divisor
        
        xor bx,bx
        mov cx, Dlen
        
        
        mov ah, 2
        mov dl, 0
        int 21h
        
        mov ah, 2
        mov dl, 61  ; =
        int 21h
        
        mov ah, 2
        mov dl, 0
        int 21h
        
        
        mov cx, Dlen
        xor bx, bx
        
comparacao:

        mov al, dividendo[bx]
        cmp al, divisor[bx]  ; dividendo>divisor?
        ja maior
        jb menor
        inc bx
        
        loop comparacao
        
        mov ah, 2
        mov dl, 49    ;1 se forem iguais
        int 21h
        jmp start
        

menor:
        mov ah, 2    ;0 se dividendo for menor
        mov dl, 48
        int 21h
        jmp fim
        

maior:

        
        lea si, dividendo
        
        mov cont,si
        
        mov ax, Dlen
        add cont, ax
        
        mov cx, Dlen
        xor bx,bx

ciclo:
        mov ax, 10
        mul dv
        mov dv, al
        mov al,divisor[bx]
        add dv, al   ;dv=divisor
        inc bx
        loop ciclo

        
        xor dx,dx
        mov dl, [si]   ;dividendo
        
        cmp dl,dv
        ja saiCiclo8


ciclo8:
        mov ax, 10
        mul dx
        mov dx,ax
        inc si
        add dl, [si]
        
        cmp dl,dv   ;  so sai quando for maior que divisor
        jb ciclo8

saiCiclo8:

inicio:
        
        xor ax,ax
        mov cx, 9

quociente:

        mov al,dv
        mul cl
        
        cmp dx, ax   ;so quando encontrar o valor*divisor mais proximo do dividendo ->ax
        jae mostrar
         
        
        loop quociente
        
        xor ax,ax

mostrar:
        
        sub dx,ax   ;dividendo menos esse valor
        
        mov ax, 10
        mul dx
        add dx,ax 
        inc si
        add dx, [si]          ;adiciona ho_next
        
        mov dh, dl
        
        mov ah,2
        mov dl, cl         ;print
        add dl, 30h
        int 21h
        
        mov dl,dh
        xor dh,dh
        
        mov ax, 10 ; atualiza quociente
        mul s
        mov s, al
        add s, cl
        
        
        cmp si, cont ; vai calcular ate nao haver mais numeros no dividendo
        jb inicio
        
        mov dv,0
        mov s,0
        jmp start   ;retorna ao menu inicial 
        
        
fim:
        ret
