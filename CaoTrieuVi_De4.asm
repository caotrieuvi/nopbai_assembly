; DE 4

.model small
.stack 100h
.data 
    tb1 db 'Nhap so luong phan tu cua mang: $'
    tb2 db 10,13, 'Phan tu $'
    tb22 db ': $'
    tb3 db 10,13,'Cac phan tu da duoc nhap: $' 
    msg_wrongnum db 13,10, 'So ban nhap chi trong khoang 0->9, xin hay nhap lai: $'

    character db ?
    number dw 0 
    
     tb_chia_het_4 db 10,13,'Cac phan tu chia het cho 4 la: $' 
     tb_4_tong db 10,13,'Tong cac phan tu chia het cho 4 trong mang la: $' 
      
     
     tb_9 db 10,13,'Cac phan tu chia het cho 9 la: $' 
     tb_9_tong db 10,13,'Tong cac phan tu chia het cho 9 trong mang la: $'
     

    
    array_length dw 0
    a dw 100 dup(0)
    count dw 1    
    
    
    
    msg_thi9 db 10,13,'In ra cac phan tu chia het cho 9: $'
    
.code
main proc
    mov ax, @data
    mov ds, ax
    

    
    ;NHAP SO LUONG PHAN TU CUA MANG=================================
    lea dx, tb1
    mov ah, 9
    int 21h
           
    
    call char2num
    mov array_length, ax
    

    ;NHAP MANG======================================================
    mov cx, array_length  ;nhap 10 phan tu kieu word
    xor si,si  ;xoa thanh ghi si

    nhapmang:
    push cx
    
    lea dx, tb2
    mov ah,9
    int 21h
    
    mov ax,count  ;hien vi tri phan tu
    call num2char
    
    
    inc count
    
    lea dx, tb22
    mov ah, 9h
    int 21h
    
    
    
    nhapso:
    mov ah, 1
    int 21h
    cmp al,13
    je catkq
    
    ; BEGIN check char is number ------------------------
    mov bl,al
    
    cmp bl,'0';hoac so sanh voi 30h
    jge checknum_compare ; lon hon 0
    jmp checknum_input_again
    
    checknum_compare:
    cmp bl,'9'
    jle checknum_ok ;nho hon 9
    jmp checknum_input_again
    
    checknum_input_again:
    mov ah,9
    lea dx,msg_wrongnum
    int 21h
    dec count
    jmp nhapmang
    
    checknum_ok:
    ; END check char is number ------------------------
    
    
    sub al, 30h
    mov cl,al
    xor ch,ch
    mov bx, 10
    mov ax,a[si]
    mul bx
    add ax, cx
    mov a[si],ax
    jmp nhapso
    
    
    catkq:
    add si,2
    pop cx 
    
    loop nhapmang ; cx = cx - 1
    
    exit_nhapmang:
    
    ;KET THUC NHAP MANG==============================================
    
    
    ;BAT DAU XUAT MANG ==============================================
    call print_newline      
    lea dx, tb3 
    mov ah, 9
    int 21h
    
    mov cx, array_length
    mov si,0
    
    view:
        push cx
        mov ax, a[si]
        xor cx,cx
        mov bx, 10
        tach:
            xor dx,dx
            div bx
            push dx
            inc cx
            cmp ax,0
            jne tach
            mov ah, 2
            
        hien1chuso:
        pop dx     
        add dl,30h
        int 21h
        loop hien1chuso
        
        mov ah,2
        mov dl,' '
        int 21h
        
        add si,2
        pop cx
        loop view
            
     ;KET THUC XUAT MANG =============================================   
                 
              

;---------------------------------------------------------------------            
;Bat dau Cau chia het cho 4     
;--------------------------------------------------------------------- 



        ;IN RA CAC PHAN TU CHIA HET CHO 4===============================================
        call print_newline
        PrintOddElement:
            lea dx, tb_chia_het_4
            mov ah,9
            int 21h    
            
            
            mov cx, array_length
            mov si,0
            
            view_pt_chia4:
                push cx
                
                mov ax, a[si]
                
                call check_divisible_by_4
                
                cmp ax, 0; 
                je ignore_num2
                
                mov ax, a[si]
                call num2char
                
                mov ah,2
                mov dl,' '
                int 21h
                
                ignore_num2:        
                
                add si,2 
                
                pop cx
                loop view_pt_chia4 

                
                
        ;TINH TONG PHAN TU CHIA HET CHO 4===============================================
        SumChiaHet4:
            lea dx, tb_4_tong
            mov ah,9
            int 21h    
            
            
            mov cx, array_length
            mov si,0
            xor bx, bx ; SUM result is save at bx
            
            calc_pt_chia_4:
                push cx
                
                mov ax, a[si]   
                
              
                push bx 
                call check_divisible_by_4   
                pop bx
                

                cmp ax, 0; AX = 0 if ko chia het cho 4
                je ignore_num1
                
                mov ax, a[si]
                
                
                ;calculate sum 
                add bx, ax
                
       
                
                ignore_num1:        
                
                add si,2 
                
                pop cx
                loop calc_pt_chia_4 
                
                
                mov  ax,bx
                call num2char                  
                
                
;---------------------------------------------------------------------            
;Bat dau Cau chia het cho 9     
;---------------------------------------------------------------------   

        ;IN RA CAC PHAN TU CHIA HET CHO 9===============================================
        call print_newline
        PrintElement_CHIA_HET9:
            lea dx, tb_9
            mov ah,9
            int 21h    
            
            
            mov cx, array_length
            mov si,0
            
            view_pt_chia9:
                push cx
                
                mov ax, a[si]
                
                call check_divisible_by_9   
                
                cmp ax, 0; 
                je ignore_num3
                
                mov ax, a[si]
                call num2char
                
                mov ah,2
                mov dl,' '
                int 21h
                
                ignore_num3:        
                
                add si,2 
                
                pop cx
                loop view_pt_chia9 
                
        ;TINH TONG PHAN TU CHIA HET CHO 9===============================================
        SumOddElement:
            lea dx, tb_9_tong
            mov ah,9
            int 21h    
            
            
            mov cx, array_length
            mov si,0  
            xor bx, bx ; SUM result is save at bx
            
            calc_pt_chia_het_cho9:
                push cx
                
                mov ax, a[si]
                
                push bx
                call check_divisible_by_9
                pop bx
                
                
                cmp ax, 0; 
                je ignore_num
                
                mov ax, a[si]
                
                ;calculate 
                add bx, ax
                
       
                
                ignore_num:        
                
                add si,2 
                
                pop cx
                loop calc_pt_chia_het_cho9 
                
                mov  ax,bx
                call num2char   
                                     
                 
        
        mov ah,4ch
        int 21h        
main endp



;======================================================
; INPUT A CHARACTER AND CONVERT IT TO NUMBER
;======================================================
;.DATA
;
;msg_wrongnum db 13,10,'So ban nhap chi trong khoang 0->9, xin hay nhap lai: $' 
;    
;character db ?
;number dw 0

;RESULT SAVE IN AX REGISTER
;======================================================

char2num proc
    start_char2num:
    
mov number, 0


convert:
    mov ah, 1
    int 21h

    cmp al, 13
    jz exit_convert

    ; BEGIN check char is number ------------------------
        mov bl, al

        cmp bl, '0' ; hoac so sanh voi 30h
        jl checknum_input_again1 ; nho hon 0
        cmp bl, '9'
        jg checknum_input_again1 ; lon hon 9
        
        jmp checknum_ok1

    checknum_input_again1:
        mov ah, 9
        lea dx, msg_wrongnum
        int 21h
        jmp start_char2num

    checknum_ok1:
    ; END check char is number ------------------------

    sub al, 30h
    mov character, al

    mov ax, number
    mov bx, 10
    mul bx
    add al, character
    mov number, ax

    jmp convert

exit_convert:
    ; RESULT SAVE IN AX
    mov ax, number
    ret

    
char2num endp     

;======================================================
; PRINT A NUMBER (COVERT NUMBER TO CHAR AND PRINT)
;======================================================
;.CODE
;mov ax, <sum>
;
;======================================================
num2char proc
    ; Save registers
    pusha

    ; Convert number to string
    mov cx, 10
    mov bx, 0

    print_number_loop:
        xor dx, dx
        div cx
        add dl, 30h
        push dx
        inc bx
        cmp ax, 0
        jne print_number_loop
    
        ; Print the converted string
        mov ah, 02h
    
    print_number_pop_loop:
        pop dx
        int 21h
        dec bx
        cmp bx, 0
        jne print_number_pop_loop
    
        ; Restore registers
        popa
        ret 
                        
num2char endp



;kiem tra so chia het cho 4
check_divisible_by_4 PROC
  MOV BX, 4      
  XOR DX, DX     
  DIV BX         
  CMP DX, 0       
  JNE not_divisible 
  MOV AX, 1     
  RET

not_divisible:
  MOV AX, 0       
  RET

check_divisible_by_4 ENDP    


;kiem tra so chia het cho 9
check_divisible_by_9 PROC
  MOV BX, 9      
  XOR DX, DX     
  DIV BX         
  CMP DX, 0       
  JNE not_divisible1 
  MOV AX, 1     
  RET

not_divisible1:
  MOV AX, 0       
  RET

check_divisible_by_9 ENDP

     
     
     
;======================================================
; PRINT A NEW LINE
;======================================================
;.CODE
;call print a new line
;
;======================================================
print_newline PROC
    ; Save registers
    pusha

    ; Print newline
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h

    ; Restore registers
    popa
    ret
print_newline ENDP  

end main  



