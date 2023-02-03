PCRSR = $CB
    ORG $2000
DLS
    .BY $70,$70,$70,$46
    .WO SHOW
    .BY $70,$70,$02
    .BY $70,$70,$70,$02
    .BY $70,$70,$70,$06
    .BY $70,$70,$70,$02
    .BY $70,$70,$70,$70,$70,$02
    .BY $41
    .WO DLS
SHOW
    .SB "COPIADOR NHP VER 2.2"
    .SB " "
    .SB +128," POR PARCHE NEGRO SOFT (DOGDARK 2023) "
    .SB " "
    .SB +128,"NOMBRE CARATULA:"
CRSR
    .SB "_                       "
NAME
    .SB "********************"
    .SB +128,"FILE:"
FILE
    .SB "_                                  "
    .SB +128,"BYTES LEIDOS:"
    .SB " "
BYTES
    .SB "*****        "
    .SB +128,"BLOQUES:"
    .SB " "
BLOQUES
    .SB "*** "
RY
    .BYTE 0,0 
RESTORE
    LDX #19
    LDA #$00
?RESTORE
    STA NAME,X
    DEX
    BPL ?RESTORE
    LDX #4
    LDA #$10
??RESTORE
    STA BYTES,X 
    DEX 
    BPL ??RESTORE
    STA BLOQUES
    STA BLOQUES+1
    STA BLOQUES+2
    RTS
ASCINT
    CMP #32
    BCC ADD64
    CMP #96
    BCC SUB32
    CMP #128
    BCC REMAIN
    CMP #160
    BCC ADD64
    CMP #224
    BCC SUB32
    BCS REMAIN
ADD64
    CLC 
    ADC #64
    BCC REMAIN
SUB32
    SEC 
    SBC #32
REMAIN
    RTS 
FLSH
    LDY RY
    LDA (PCRSR),Y
    EOR #63
    STA (PCRSR),Y
    LDA #$10
    STA $021A
    RTS 
OPENK
    LDA #255
    STA 764
    LDX #$10
    LDA #$03
    STA $0342,X
    STA $0345,X
    LDA #$26
    STA $0344,X
    LDA #$04
    STA $034A,X
    JSR $E456
    LDA #$07
    STA $0342,X
    LDA #$00
    STA $0348,X
    STA $0349,X
    STA RY
    RTS 
RUTLEE
    LDX # <FLSH
    LDY # >FLSH
    LDA #$10
    STX $0228
    STY $0229
    STA $021A
    JSR OPENK
GETEC
    JSR $E456
    CMP #$7E
    BNE C0
    LDY RY
    BEQ GETEC
    LDA #$00
    STA (PCRSR),Y
    LDA #63
    DEY 
    STA (PCRSR),Y
    DEC RY
    JMP GETEC
C0
    CMP #155
    BEQ C2
    JSR ASCINT
    LDY RY
    STA (PCRSR),Y
    CPY #20
    BEQ C1
    INC RY
C1
    JMP GETEC
C2
    JSR CLOSE
    LDA #$00
    STA $021A
    LDY RY
    STA (PCRSR),Y
    RTS 


CLOSE
    LDX #$10
    LDA #$0C
    STA $0342,X
    JMP $E456



START
    LDX # <DLS
    LDY # >DLS
    STX $230
    STY $231
    LDA #$92
    STA $2C6
    STA $2C8
;RESETEAMOS LOS VALORES
    JSR RESTORE
;ACTIVAMOS LA ESCRITURA DEL TITULO
    LDX # <CRSR
    LDY # >CRSR
    STX PCRSR
    STY PCRSR+1
    JSR RUTLEE
;COLOCAMOS EN GRANDE EL TITULO Y LO PASAMOS A NAME
    TYA
    BEQ NOTITLE
    LSR 
	STA RY+1
	LDA #10
	SEC
	SBC RY+1
	STA RY+1
	LDX #$00
	LDY RY+1
WRITE
    LDA CRSR,X
    STA NAME,Y
    INY 
    INX 
    CPX RY
    BNE WRITE
;INGRESAMOS EL FILE A CARGAR
NOTITLE
    LDX # <FILE
    LDY # >FILE
    STX PCRSR
    STY PCRSR+1
    JSR RUTLEE
;


    JMP *
    RUN START