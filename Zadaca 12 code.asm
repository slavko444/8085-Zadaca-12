 2Ch: CALL SERVIS_55
 RET
 34h: CALL SERVIS_55
 RET
 3Ch: CALL SERVIS_75
 RET
 SERVIS_55: MVI E, 0
 CALL POLNI_TIMER ; се полни и се стартува тајмерот
 SERVIS_65: INR H ;бројач на бајти
 RET
SERVIS_75: DCR C ако С=0 изминала 1 сек
 JNZ КРАЈ
DCR D
 JZ GOTOVO ;Aко C и D се 0 изминалe 5 sec.
 MVI C,156d ;ако не се полни тајмерот да брои отпоново
 CALL POLNI_TIMER
 JMP KRAJ
 GOTOVO: MVI E,0 ;крај на јамката во главната програма
 KRAJ: NOP
 RET
POLNI_TIMER:MVI A,10111110 ;62d+128d(краток импулс)=190
 OUT THB ;се полни горниот бајт
 MVI A,10000000 ;128d
 OUT TLB ;се полни долниот бајт
 MVI A,11XXXXXX ;се стартува тајмерот
 OUT CSR
 RET
Главна Програма:
MVI А, X0X01111b ; маскирај ги сите прекини.
SIM
MVI H,0 ;бројач на бајти.
 MVI C, 156d ;бројач за 1 секунда
MVI D,5d ;бројач за 5 секунди
MVI E,1 ;флег за јамка
MVI А, X0X01110b ; овозможи го само RST 5.5
SIM
VRTI: MOV A,E ;креираме јамка за старт
 ANI FFh
 JNZ VRTI
MVI А, X0X01001b ; овозможи ги само RST 6.5 и RST 7.5
SIM
 MVI E,1
LOOP: MOV A,E
 ANI FFh
 JNZ LOOP
 MOV A,H ;дали се внесени 2 бајти
 CPI 2d
 JZ OK_E
 //NE SE VNESENI DVA BAJTI ;соодветна акција, пр. вклучи аларм
 JMP KRAJ
 OK_E://OK E ;соодветна акција, пр. отвори врата
 KRAJ: NOP
 END 
