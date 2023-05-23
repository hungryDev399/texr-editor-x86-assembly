.MODEL SMALL
.DATA
    msg db "Elnaggar"
    msg1 db "  File   Help                                                                   "
    msg1end db 0
    msg2 db "File   ",0ah,0dh
         db "Open       CTRL+O",0ah,0dh
         db "Save       CTRL+S",0ah,0dh
         db "Delete     CTRL+D",0ah,0dh
         db "Exit(ESC)  CTRL+E",0ah,0dh
    msg2end db 0
    ;file3 db "t1.txt", o
    handle dw ?
    mystack db ?
        col db ?
        column db 0
        row db 6
.STACK 
    dw 128 dup(0)

.code
    main proc far
        mov ax, @data
        mov ds, ax
        mov es,ax
        ;setting the screen to 80x25 text mode
        mov ah,0h
        mov al, 03h
        int 10h
        
        ; set cursor shape
        mov ah,2
        mov ch, 0
        mov cl, 7
        int 10h
        ; set cursor position
        mov dh, 0 ;row
        mov dl,3  ; column
        mov bh, 0 ; page
        mov ah, 2
        int 10h
        ;code start
        ;print the first line
        mov al,1
        mov bh, 0
        mov bl, 01001111b
        mov cx, offset msg1end - offset msg1
        mov dl,0
        mov dh, 0
        push ds
        pop es
        mov bp, offset msg1
        mov ah,13h
        int 10h
        
        wait_for_key: ;Mouse initialization
            mov ax,0
            int 33h
         ;int 33h
         ;It gets mouse status and position of it's buttons
         ;left button -> bx = 1
         ;right button -> bx = 2
         ;both buttons -> bx = 3
         mov ax,3
         int 33h
         cmp bx,1
         je mymouse_bridge2
         ; check for keystroke in keyboard buffer
         mov ah, 1
         int 16h
         jz wait_for_key

        
         cmp al, 'i'
         je input_loop ; IF input is I accept user input
        
         jmp wait_for_key ; wait for another key

       
        input_loop:

        mov ah,0
        int 16h ;taking a character from std in
        
        
        cmp al, 8 ;see if it is backspace
        je backspace
        jne newline
        

        mymouse_bridge2:
        jmp mymouse
        wait_for_key_bridge:
            jmp wait_for_key
        input_loop_bridge:
            jmp input_loop
      backspace:
        ; set  cursor position back
        mov ah,02h
        mov dh,row
        dec column
        mov dl,column
        mov bh,0
        int 10h
        ;print space
        mov al, ' '
        mov ah,0ah
        mov cx,1
        mov bh,0
        int 10h
        cmp column, 0
        jne input_loop
        back_line:
        ; move the cursor position to the end of the row above
            dec row
            mov column, 80
            mov ah,02h
            mov dh,row
            mov dl,column
            mov bh,0
            int 10h
        jmp input_loop
            
            ;jmp input_loop 
        ; check if at start of row

        newline:
        ; check if the enter the key press
        cmp al,13
        jne print
        ; set  cursor position down a row
        mov ah,02h
        inc row
        mov dh,row
        mov column, 0
        mov dl,column
        mov bh,0
        int 10h
        jmp input_loop
        mymouse_bridge:
            jmp mymouse
        input_loop_bridge2:
            jmp input_loop_bridge
        ; print character
       print:
        mov ah,0ah
        mov cx,1
        mov bh,0
        int 10h 
        ; set cursor position one column to the right every time
        mov ah,02h
        mov dh,row
        inc column
        mov dl,column
        mov bh,0
        int 10h
        cmp column,80
        jne checkESC
        reset_column:
            mov column,0
            inc row
      checkESC:
        cmp al, 27 ;check if ESC is pressed
        je exit
        jmp input_loop_bridge
       save:
       ;;;;;
       
       mymouse:
        mov al,1
        mov bh, 0
        mov bl, 01001111b
        mov cx, offset msg2end - offset msg2
        mov dl,0
        mov dh, 0
        push ds
        pop es
        mov bp, offset msg2
        mov ah,13h
        int 10h
        jmp input_loop_bridge2
        
        ;int 21h / ah=1 -> read character from standard input, with echo, result is stored in AL

        
        
        ;code end
        exit:
        mov ah, 1
        int 21h; wait for a key input
        
        mov ah,4ch
        int 21h
        main endp
    end main