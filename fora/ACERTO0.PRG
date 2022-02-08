function ACERTO0()
clear
use CFEAME new index CFEIME01 alias MOV
@10,10 say 'Aguarde, processando...'
repl all ME_QTD with abs(ME_QTD) for ME_TIPO='S'
close
return NIL
