.model small
.stack 100h
.data 

    tb1 db 'Nhap so luong phan tu cua mang: $'
    tb2 db 10,13, 'Phan tu $'
    tb22 db ': $'
    
    msg_cau53 db 10,13, '********************* CAU 53 *********************$'
    msg_cau54 db 10,13, '********************* CAU 54 *********************$'
    msg_cau21 db 10,13, '********************* CAU 21 *********************$' 
    
    
    tb3 db 10,13,'Cac phan tu da duoc nhap: $'
    tb4 db 10,13,'Gia tri lon nhat (MAX) cua mang: $'
    tb5 db 10,13,'Gia tri nho nhat (MIN) cua mang: $'
    tb8 db 10,13, 'Trung binh cong cua mang la: $'
    msg_sum db 10,13, 'Tong gia tri cua cac phan tu trong mang la: $'    
    
    
    msg_wrongnum db 13,10, 'So ban nhap chi trong khoang 0->9, xin hay nhap lai: $'
    
    character db ?
    number dw 0
    
    msg_find_x db 10,13, 'Moi ban nhap vao gia tri can tim: $'
    not_found_value db 10,13, 'Khong tim thay gia tri ban muon tim! $'
    msg_found_x_begin db 10,13, 'Tim thay gia tri ban da nhap tai vi tri thu $' 
    msg_found_x_end db ' cua mang$'
    
    x dw ?; Cho cau 54 tim gia tri x
    div2 dw 2
    add1 dw 1  
    
    
     NUM DW 0  
     
     even_msg db 'So chan!$'
     odd_msg db 'So le!$'
     
     tb6 db 10,13,'Cac phan tu le trong mang la: $' 
     tb7 db 10,13,'Tong cac phan tu le trong mang la: $'
     
     
    
    array_length dw 0
    a dw 100 dup(0)
    count dw 1 
    
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
;Bat dau Cau 53        
;--------------------------------------------------------------------- 

        call print_newline
        lea dx,msg_cau53 
        mov ah,9
        int 21h            
            
            
        ;TIM MAX =====================================================
        call print_newline
        lea dx,tb4 
        mov ah,9
        int 21h
        
        xor si,si
        mov ax, a[si]
        mov cx, array_length
        
        duyet_mang:
            cmp a[si],ax
            jbe tang_pt
            mov ax,a[si]
        tang_pt:
            add si,2
            loop duyet_mang
            
            call num2char 
            
            
              
        ;TIM MIN ======================================================
        lea dx, tb5
        mov ah,9
        int 21h
        
        xor si,si
        mov ax, a[si] 
        mov cx, array_length
        
        duyet_mang1:
        cmp ax, a[si] 
        jbe tang_pt1
        mov ax, a[si]
        tang_pt1:
            add si,2
            loop duyet_mang1
            
            call num2char
        
        
        ;TINH TRUNG BINH CONG CUA MANG======================================
        AvgArray:  
            
            
            mov cx, array_length
            mov si,0
            xor bx, bx ; SUM result is save at bx
            
            Avg_arr_loop:
                push cx
                
                mov ax, a[si]
                ; calc sum of all element
                add bx, ax       
                
                add si,2 
                pop cx
                loop Avg_arr_loop 
                
                
                lea dx, msg_sum
                mov ah,9
                int 21h
                
                
                mov  ax,bx ; sum is saved at ax  
                call num2char 
                
                lea dx, tb8
                mov ah,9
                int 21h 
                
                 
                mov  ax,bx ; sum is saved at ax 
                mov cx, array_length
                cwd                   ; Mo rong do rong cua AX thanh DX:AX (ghi chu: su dung cdq cho so nguyen 32 bit)
                idiv cx               ; AX = DX:AX / CX ket qua luu vao ax du luu vao dx
                
                
                call num2char
        

;---------------------------------------------------------------------            
;Bat dau Cau 54        
;---------------------------------------------------------------------
        call print_newline
        lea dx,msg_cau54 
        mov ah,9
        int 21h  
        
        call print_newline
        lea dx,msg_find_x 
        mov ah,9
        int 21h  
        
        ; nhap gia tri muon tim
        call char2num
        mov bx, ax ; bx luu gia tri x muon tim
        
        
        mov cx, array_length
        mov si,0
        
            
            Findx_arr_loop:
                push cx
                
                mov ax, a[si]
                ; calc sum of all element
                cmp bx, ax
                je found_x       
                
                add si,2 
                pop cx
                loop Findx_arr_loop  
                
           not_found_x:
                lea dx, not_found_value
                mov ah, 9
                int 21h
                jmp exit_find_x
                    
            found_x:
                lea dx, msg_found_x_begin
                mov ah, 9
                int 21h
                
                
                mov ax, si
                mov cx, div2
                cwd 
                idiv cx
                add ax, 1
                call num2char 
                
                lea dx, msg_found_x_end
                mov ah, 9
                int 21h
                
            exit_find_x:     
                
;---------------------------------------------------------------------            
;Bat dau Cau 21        
;--------------------------------------------------------------------- 
        call print_newline
        lea dx,msg_cau21 
        mov ah,9
        int 21h         
        
        ;IN RA CAC PHAN TU LE===============================================
        call print_newline
        PrintOddElement:
            lea dx, tb6
            mov ah,9
            int 21h    
            
            
            mov cx, array_length
            mov si,0
            
            view_pt_le:
                push cx
                
                mov ax, a[si]
                
                call is_even
                
                cmp ax, 1; AX = 1 if even, 0 if not even (odd)
                je ignore_even_num
                
                mov ax, a[si]
                call num2char
                
                mov ah,2
                mov dl,' '
                int 21h
                
                ignore_even_num:        
                
                add si,2 
                
                pop cx
                loop view_pt_le 
                
                
        ;TINH TONG PHAN TU LE===============================================
        SumOddElement:
            lea dx, tb7
            mov ah,9
            int 21h    
            
            
            mov cx, array_length
            mov si,0
            xor bx, bx ; SUM result is save at bx
            
            calc_pt_le:
                push cx
                
                mov ax, a[si]
                
                call is_even
                
                cmp ax, 1; AX = 1 if even, 0 if not even (odd)
                je ignore_even_num1
                
                mov ax, a[si]
                
                ;calculate sum of odd element
                add bx, ax
                
       
                
                ignore_even_num1:        
                
                add si,2 
                
                pop cx
                loop calc_pt_le 
                
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

;======================================================
; PRINT EVEN OR ODD NUMBER
;======================================================

;.DATA
;even_msg db 'So chan!$'
;odd_msg db 'So le!$'
;
;.CODE
;mov ax,<num>
;
;======================================================
print_even_odd proc
    ;mov ax, number
    and ax, 1
    jz chk_even

    chk_odd:
        ; In ra thong bao so le
        lea dx, odd_msg
        mov ah, 09h
        int 21h
        jmp chek_even_odd_exit:
    
    chk_even:
        ; In ra thong bao so chan
        lea dx, even_msg
        mov ah, 09h
        int 21h
    
    chek_even_odd_exit:
        ret
    
print_even_odd endp

;======================================================
; CHECK EVEN OR ODD NUMBER
;======================================================
; Subroutine: CheckEven
; Input: AX = number to check
; Output: AX = 1 if even, 0 if not even (odd)
;
;.CODE
;mov ax,<num>
;
;======================================================
is_even PROC
    test ax, 1   ; And the last bit of AX with 1
    jz even      ; If the result is zero (even), jump to the Even label

    ; Odd case
    mov ax, 0    ; Set AX to 0 (not even)
    ret          ; Return from the subroutine

even:
    ; Even case
    mov ax, 1    ; Set AX to 1 (even)
    ret          ; Return from the subroutine
is_even ENDP


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
