format binary as 'img'   ;����������� �������������� ����� .bin �� flat assembler � .img ����� ���������� ����

org 0x7C00     ;��������� ���������� ������ ��������� � ������ ����������

jmp start       ;������� � ����� "start"


msg db "Var14", 0
msg1 db "Nazarov", 0
msg2 db "Mikhail", 0
msg3 db "Evgenievich", 0
msg4 db "NMT-313901", 0         
;����������� ��������� ���������� `msg`, `msg1`, `msg2`, `msg3`, `msg4`(�������, ���, ������) � �� �������������


start:
    cli                 ;��������� ����������
    mov ax, 0           ;������������� �������� �����
    mov ss, ax
    mov sp, 0xFFFF      ;��������� ��������� ����� �� ����
    sti                 ;�������� ����������
;��������� �����: ��������� ����������, �������������� ������� �����, ������������� ��������� ����� �� ������� ������� � �������� ����������

    mov ax, 0x13        ; ������������ � ����� 320x200 256-�����
    int 0x10
    mov ax, 0x0010      ; ��������� ������������ ������ ������
    int 0x10            
;����������� ���������� �� 320x200 �������� � 256 ������� � ������������� ����������� ����� ������


push 320        ; X0
push 175        ; Y0
push 140        ; RX (������� ���)
push 70         ; RY (����� ���)
push 7          ; ���� ����� ��� �����
call DrawEllipse ; ����� ������� DrawEllipse
;�������� ��������� ������� `DrawEllipse` � ���� � �������� ��� �������, ������ �������� � 640�350

; ��������� ����� ����
    mov ah, 0x0B        ; ������� ��� ��������� ����� ����
    mov bl, 0x01        ; ����� ���� ����
    int 0x10

;����� ������ �� ������� �� �����(������� + � + � + � + ������)
    mov ah, 0x13        ; ������� ��� ������ ������
    mov al, 0           
    mov bh, 0           ; �������� ������
    mov bl, 0x0C        ; ���� ������: �������
    mov dl, 34          ;�������
    mov dh, 10          ;������
    push cs
    pop es
    mov bp, msg         ;�����, ����� ������ �����
    mov cx, 5           ;����� ������
    int 0x10

    mov ah, 0x13        
    mov al, 0           
    mov bh, 0           
    mov bl, 0x0C          
    mov dl, 34          
    mov dh, 11          
    push cs
    pop es
    mov bp, msg1
    mov cx, 7           
    int 0x10

    mov ah, 0x13        
    mov al, 0           
    mov bh, 0           
    mov bl, 0x0C        
    mov dl, 34          
    mov dh, 12          
    push cs
    pop es
    mov bp, msg2
    mov cx, 7          
    int 0x10

    mov ah, 0x13        
    mov al, 0           
    mov bh, 0           
    mov bl, 0x0C          
    mov dl, 34          
    mov dh, 13          
    push cs
    pop es
    mov bp, msg3
    mov cx, 11          
    int 0x10

    mov ah, 0x13        
    mov al, 0           
    mov bh, 0           
    mov bl, 0x0C        
    mov dl, 34          
    mov dh, 14          
    push cs
    pop es
    mov bp, msg4
    mov cx, 10          
    int 0x10


hang:
    jmp hang
;����������� ����, ����� ��������� �� �����������

; ������� DrawEllipse
DrawEllipse:
push bp
mov bp, sp
sub sp, 2         ; ��������� ����� ��� ��������� ����������
;������ ������� DrawEllipse. ���������� �������� �������� ���� ����� (BP) �� ����� � ��������� �������� �������� ���� ����� ������ �������� ��������� ����� (SP). ��������� 2 ������ ������ ��� ��������� ����������

fld1             ; �������� 1.0 �� ������� ����� FPU
fadd st, st       ; ��������� �� 2 ��� ��������� 2.0
fadd st, st
fimul word [bp+8] ; ��������� �� RX (������� ���)
fldpi             ; �������� ����� �� �� ������� ����� FPU
fdivrp            ; ������� �� 4*RX ��� ��������� da (���������� ����)
;���������� �������� ���������� ���� (da) ��� ��������� �������. �������� �������� 1.0 �� ������� ����� FPU, ��������� �� 2 ������, ��������� �� RX (������� ���), �������� �������� ����� �� �� ������� ����� FPU � ������� �� 4*RX

fldz             ; �������� 0.0 �� ������� ����� FPU

mov cx, [bp+8]    ; CX = RX
shl cx, 3         ; ��������� �� 8 ��� ��������� 8*RX
xor bh, bh        ; BH = 0 (����� ��������)
mov ax, [bp+4]    ; AX = AH
mov ah, 0ch       ; AH = ���� �������
;��������� �������� �������� CX ������ RX, ��������� CX �� 8 ��� ��������� 8*RX, ��������� �������� �������� BH � 0 (����� ��������), �������� �������� AH � ������� AX � ��������� �������� �������� AH ������ 0Ch (���� �������)

@@: push cx          ; ���������� CX (�������� �����)
    fld st           ; ������������ ������� ����� FPU (����)
    fsincos             ; ���������� ������ � �������� ����
    fimul word [bp+8]   ; ��������� �� RX (������� ���) ��� ��������� X
    fistp word [bp-2]   ; ���������� X � ��������� ����������
    mov cx, [bp-2]      ; CX = X
    add cx, [bp+12]     ; ���������� X0 ��� ��������� ������������� ���������� X
    fimul word [bp+6]   ; ��������� �� RY (����� ���) ��� ��������� Y
    fistp word [bp-2]   ; ���������� Y � ��������� ����������
    mov dx, [bp-2]      ; DX = Y
    add dx, [bp+10]     ; ���������� Y0 ��� ��������� ������������� ���������� Y
    int 10h             
    fadd st, st1        ; ���������� da (���������� ����) � ����
    pop cx              ; �������������� CX (�������� �����)
    loop @b             ; ���� �� ��� ���, ���� CX �� ������ �����
;����, ������� ������ ������ �� ������. ���������� �������� �������� CX �� �����, ������������ ������� ����� FPU (����), ���������� ������ � �������� ����, ��������� �� RX ��� ��������� ���������� X, ���������� X � ��������� ����������, ��������� �������� �������� CX ������ X, ���������� X0 ��� ��������� ������������� ���������� X, ��������� �� RY ��� ��������� ���������� Y, ���������� Y � ��������� ����������, ��������� �������� �������� DX ������ Y, ���������� Y0 ��� ��������� ������������� ���������� Y, ����� ���������� ����� BIOS ��� ��������� �������, ���������� ���������� ���� � ����, �������������� �������� �������� CX �� ����� � ���������� ����� �� ��� ���, ���� �������� �������� CX �� ������ �����

mov sp, bp      
pop bp
ret 10
;�������������� �������� �������� ����� (SP) �� �������� ���� ����� (BP), �������������� �������� �������� ���� ����� (BP) �� ����� � ������� �� ������� � ��������� 10 ������ �� �����

; ���������� ���������� ���� ������������ ������� ������
times 510-($-$$) db 0
; ������� ����������
dw 0xAA55