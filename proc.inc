uprow proc far
    dec row        
    mov ah,02h
    mov dh,row
    mov dl,column
    mov bh,0
    int 10h
    ret
uprow endp

downrow proc far
    inc row       
    mov ah,02h
    mov dh,row
    mov dl,column
    mov bh,0
    int 10h
    ret
downrow endp

rightcolumn proc far
    inc column
    mov ah,02h
    mov dh,row
    mov dl,column
    mov bh,0
    int 10h
    ret
rightcolumn endp


leftcolumn proc far
    dec column        
    mov ah,02h
    mov dh,row
    mov dl,column
    mov bh,0
    int 10h
    ret
leftcolumn endp

arrowcheck proc far
    ; check if the button is arrow up
    cmp ah, 48h
    jne arrowDownCheck
    arrowUP:
        call uprow
        mov ax, 1 ; ax = 1 if an arrow key was actually pressed
        jmp exitarrowcheck
            
    arrowDownCheck:
    cmp ah,50h
        jne arrowRightCheck
        
    arrowDown:
        call downrow
        mov ax, 1 ; ax = 1 if an arrow key was actually pressed
        jmp exitarrowcheck
            
    arrowRightCheck:
    cmp ah,4Dh
        jne arrowLeftCheck
            
    arrowRight:
            
        call rightcolumn
        mov ax, 1 ; ax = 1 if an arrow key was actually pressed
        jmp exitarrowcheck
        
    arrowLeftCheck:
    cmp ah, 4Bh
    jne exitarrowcheck
       
    arrowLeft:  
    call leftcolumn
    mov ax, 1 ; ax = 1 if an arrow key was actually pressed
    jmp exitarrowcheck
       
            
    exitarrowcheck:
    ret      
arrowcheck endp

select proc far
        mov si, offset select_buffer ; initialize the si to point at the first byte of the byffer 
        mov cx, select_buffer_length ; set the maximum amount of characters to be selcted
    select_loop:
        mov ah, 10h
        int 16h
        call arrowcheck
        cmp ax, 1 ; see if an arrow is pressed
        ;jne exit_select
    read_char:
        mov ah,10h
        int 16h ; read a charcter at cursor position
        cmp al, 13 ; check if enter is pressed
        je exit_select
        mov [si], al ; store the charcter in the buffer  
        inc si ; move the pointer to the next byte of the buffer    
        loop select_loop
    exit_select: 
    ret
select endp


save_file_Proc proc far
    ;open file
    mov ah, 3ch
    mov cx, 0
    mov dx, offset filename
    mov ah, 3ch
    int 21h
    mov handle, ax
    
    ;write into file the input char
    mov ah,40h
    mov bx, handle
    mov cx, file_buffer_length
    mov dx, offset file_buffer
    int 21h
                
    ;close file
    mov ah,3eh
    mov bx,handle
    int 21h
    ret
save_file_Proc endp