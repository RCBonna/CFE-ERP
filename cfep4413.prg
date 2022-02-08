*-----------------------------------------------------------------------------*
 function CFEP4412()	//	Movimentacoes do Estoque ENTRADA-PESQUISA
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local VM_DATA :=EC_DTENT
local VM_DOCTO:=0
pb_box(19,20,,,,'Selecione')
@20,22 say 'Data.....:' get VM_DATA  pict mDT
@21,22 say 'Documento:' get VM_DOCTO pict mI8
read
if lastkey()#K_ESC
	dbseek(dtos(VM_DATA)+str(VM_DOCTO,8),.T.)
end
return NIL

function CFEP4413()	//	Movimentacoes do Estoque ENTRADA-PESQUISA
local X,LCONT:=.T.
for X:=1 to fcount()
	X1:="VM"+substr(fieldname(X),3)
	&X1:=&(fieldname(X))
next
pb_box(5,0,17,79,,'Informacoes')
@06,01 say 'Data Emiss„o:' get VM_DTEMI pict masc(08)  when .F.
@06,41 say 'Data Entrada:' get VM_DTENT pict masc(08)  when .F.
@07,01 say 'Emitente....:' get VM_CODFO pict masc(04)  when .F.
@07,22 say CLIENTE->CL_RAZAO
@08,01 say 'Tipo Docto..:' get VM_TPDOC pict masc(01)  when .F.
@09,01 say 'Documento...:' get VM_DOCTO pict masc(09)  when .F.
@09,40 say 'Serie.......:' get VM_SERIE pict masc(01)  when .F.
@10,01 say 'Nat.Operacao:' get VM_CODOP pict mNAT      when .F.
@10,22 say NATOP->NO_DESCR
@12,01 say 'Total Docto.:' get VM_TOTAL pict masc(05)  when .F.
@13,01 say 'Vlr Desconto:' get VM_DESC  pict masc(05)  when .F.
@13,40 say 'Vlr Funrural:' get VM_FUNRU pict masc(05)  when .F.
@14,01 say 'Vlr BaseICMS:' get VM_ICMSB pict masc(05)  when .F.
@14,40 say 'Vlr I.P.I...:' get VM_IPI   pict masc(05)  when .F.
@15,01 say '% ICMS......:' get VM_ICMSP pict masc(14)  when .F.
@15,40 say 'Vlr I.C.M.S.:' get VM_ICMSV pict masc(05)  when .F.
@16,01 say 'C¢d.Tribut r:' get VM_CODTR pict mI3       when .F.
read
if if(lastkey()#K_ESC,pb_sn('Excluir ?'),.F.)
	Nao(ProcName())
end
return NIL
//-------------------------------------------------EOF----------------------------
