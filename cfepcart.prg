*-----------------------------------------------------------------------------*
function CFEPCART() // Registro no SPC														*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
#define SIM ' Env '
#define NAO '     '
local OPC
if !abre(	{'R->PARAMETRO',	'R->BANCO',	'R->CTACTB',;
				 'C->CLIENTE',		'C->CLIOBS','R->DPCLI',;
				 'R->HISCLI',		'R->DIARIO','E->CARTAS'})
	return NIL
end
pb_tela()
pb_lin4(_MSG_,ProcName())
OPC:=alert('Selecione uma op‡„o....',{'Imprimir Cartas', 'Editar Cartas'})
if OPC==1
	CFEPCART1()
elseif OPC==2
	CFEPCART2()
end
// dbcommitall()
dbcloseall()
return NIL

*----------------------------------------------------------------------------*
function CFEPCART1()
*----------------------------------------------------------------------------*
local ENVIOS:={}
local X
private VM_DET
private VM_CODIG
private VM_DATAE
private VM_CAB
private VM_MAS
private VM_TAM
select('DPCLI')
dbsetorder(5)
select('CLIENTE')
VM_CODIG:=0
VM_CARTA:=CARTAS->CA_CODIG
VM_DATAA:={ctod(''),bom(PARAMETRO->PA_DATA-30)-1}
VM_DATAE:=PARAMETRO->PA_DATA
VM_REREG:='N'
scroll(06,01,21,78)
@05,02 say 'Enviar Carta.......:'  get VM_CARTA    picture masc(1) valid pb_ifcod2(VM_CARTA,'CARTAS',.T.)
@06,02 say 'Data envio da carta:'  get VM_DATAE    picture masc(7)
@07,02 say 'Dupls atrasadas de :'  get VM_DATAA[1] picture masc(7)
@07,34 say 'ate '                  get VM_DATAA[2] picture masc(7) valid VM_DATAA[1]<=VM_DATAA[2]
read
if lastkey()#K_ESC
	select('CLIENTE')
	DbGoTop()
	while !eof()
		@08,02 say 'Cliente : '+pb_zer(CLIENTE->CL_CODCL,5)+'-'+CLIENTE->CL_RAZAO
		@09,40 say 'Enviado Carta '+str(CLIENTE->CL_NRCART,2)
		while !reclock();end
		VM_DET:={}
		salvabd(SALVA)
		select('DPCLI')
		dbseek(str(CLIENTE->CL_CODCL,5),.T.) // Procura 1.DPL
		dbeval({||if(reclock(),;
					aadd(VM_DET,{	SIM,;//................................ 1-Selecao
										&(fieldname(1)),;//.................... 2-Nr Dpl
										&(fieldname(3)),;//.................... 3-Dt Emis
										&(fieldname(4)),;//.................... 4-Dt Venc
										&(fieldname(6)),;//.................... 5-Vlr Compra
										&(fieldname(6))-&(fieldname(7)),;//.... 6-Vlr Atrasado
										&(fieldname(10)),;//................... 7-Nr NF
										&(fieldname(11))}),;//................. 8-Serie
					pb_msg('Duplicata '+transform(&(fieldname(1)),masc(16))+' em uso.',0,.T.))},;
					{||&(fieldname(4))>=VM_DATAA[1].and.&(fieldname(4))<=VM_DATAA[2]},;
					{||&(fieldname(2))==CLIENTE->CL_CODCL})
		salvabd(RESTAURA)
		if len(VM_DET)>0
			VM_CAB:={'Selec','N§ Dpls','Dt Emiss','Dt Venc','Valor Total','Valor Atraso','Nt Fisc','Ser'   }
			VM_TAM:={     5,       10 ,        8 ,       8 ,           12,           12 ,       6 ,   3    }
			VM_MAS:={masc(1), masc(16),   masc(7),  masc(7),      masc(5),       masc(5), masc(19),masc(1) }
			OPC:=1
			while OPC>0
				pb_msg('Pressione <ENTER> para mudar Situa‡„o, <ESC> Sair',NIL,.F.)
				OPC:=abrowse(10,00,22,79,VM_DET,VM_CAB,VM_TAM,VM_MAS)
				if OPC>0
					VM_DET[OPC,1]:=if(VM_DET[OPC,1]==SIM,NAO,SIM)
					Keyboard replicate(chr(K_DOWN),OPC)
				end
			end
			FLAG:=.F.
			aeval(VM_DET,{|DET|FLAG:=if(DET[1]==SIM,.T.,FLAG)})
			if FLAG
				OPC:=alert('Selecione ... ',{'Imprimir Registro','Pr¢ximo Cliente','Sair'})
				if OPC==1
					CFEPCTIMP()
					VALOREN:=0
					CLIENTE->CL_NRCART:=CARTAS->CA_NRCAR
				elseif OPC==3
					dbgobottom()
					dbskip()
				end
			end
		end
		select('CLIENTE')
		pb_brake()
	end
end
// dbcommitall()
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CFEPCTIMP() // Impressao
*-----------------------------------------------------------------------------*
local XX
local X
local Y
//----------------------1----------2-------------3--------4---------5-----------6--------7---------8-
if pb_ligaimp(C15CPP)
	XX:=fn_tranct(CARTAS->CA_DESCR)
	for VM_X:=1 to mlcount(XX,70)
		? trim(memoline(XX,70,VM_X,,.F.))
	next
	pb_deslimp(C15CPP)
end
return NIL

*-----------------------------------------------------------------------------*
 function FN_TRANCT(P1)
*-----------------------------------------------------------------------------*
local P2:=''
local X
P1:=strtran(P1,'<CLINOME>',CLIENTE->CL_RAZAO)
P1:=strtran(P1,'<CLICOD>' ,transform(CLIENTE->CL_CODCL,masc(4)))
P1:=strtran(P1,'<CLIENDE>',CLIENTE->CL_ENDER)
P1:=strtran(P1,'<CLIBAIR>',CLIENTE->CL_BAIRRO)
P1:=strtran(P1,'<CLICIDA>',CLIENTE->CL_CIDAD)
P1:=strtran(P1,'<CLICEP>' ,CLIENTE->CL_CEP)
P1:=strtran(P1,'<CLIUF>'  ,CLIENTE->CL_UF)
P1:=strtran(P1,'<CLICPF>' ,transform(CLIENTE->CL_CGC,masc(17)))
P1:=strtran(P1,'<CLIFIL>' ,CLIENTE->CL_FILIAC)
P1:=strtran(P1,'<CLICI>'  ,CLIENTE->CL_INSCR)
P1:=strtran(P1,'<CLITRAB>',CLIENTE->CL_LOCTRA)
P2:=padc(VM_CAB[2],VM_TAM[2])+' | '
P2+=padc(VM_CAB[3],VM_TAM[3])+' | '
P2+=padc(VM_CAB[4],VM_TAM[4])+' | '
P2+=padc(VM_CAB[6],VM_TAM[6])+chr(13)+chr(10)
P2+=replicate('-',69)+chr(13)+chr(10)
for X:=1 to len(VM_DET)
	if VM_DET[X,1]==SIM
		P2+=padc(transform(VM_DET[X,2],VM_MAS[2]),VM_TAM[2])+' | '
		P2+=padc(transform(VM_DET[X,3],VM_MAS[3]),VM_TAM[3])+' | '
		P2+=padc(transform(VM_DET[X,4],VM_MAS[4]),VM_TAM[4])+' | '
		P2+=padc(transform(VM_DET[X,6],VM_MAS[6]),VM_TAM[6])+chr(13)+chr(10)
	end
next
P2+=replicate('-',69)+chr(13)+chr(10)
P1:=strtran(P1,'<DPLS>',P2)
return(P1)

*-----------------------------------------------------------------------------*
function CFEPCART2()
pb_lin4('Editar Cartas de Cobran‡a',ProcName())
select('CARTAS')
pb_dbedit1('CFEPCAR')  // tela
VM_CAMPO=array(3)
afields(VM_CAMPO)
VM_CAMPO[3]:="fn_mostrac()"
pb_box(10,00,22,maxcol(),'W+/B,B/W,,,,W+/B')
pb_box(05,00,09,maxcol(),'W+/B,B/W,,,,W+/B')
dbedit(06,01,08,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',{masc(1),masc(28)},{'C¢digo da Carta','Nr',' '})
return NIL

*-----------------------------------------------------------------------------*
function FN_MOSTRAC()
keyboard chr(27)
memoedit(CA_DESCR,11,03,21,72,.F.)
return('')

*-----------------------------------------------------------------------------*
function CFEPCAR1() // incluir
dbgobottom()
dbskip()
VM_CODIG:=CA_CODIG
VM_NRCAR:=CA_NRCAR
VM_DESCR:=CA_DESCR
salvacor(SALVA)
pb_box(10,00,22,maxcol(),'W+/GR,GR/W,,,,W+/GR')
@10,02 say 'C¢digo da Carta:' get VM_CODIG pict masc(01) valid pb_ifcod2(VM_CODIG,NIL,.F.)
@10,52 say 'Nr da Carta....:' get VM_NRCAR pict masc(28)
read
if lastkey()#K_ESC
	set cursor on
	pb_msg('ESC - Sai sem gravar   CTRL+W = Gravar',nil,.f.)
	setcolor('R/W')
	VM_DESCR:=memoedit(VM_DESCR,11,03,21,72,.T.)
	set cursor off
	if pb_sn()
		dbappend()
		replace  CA_CODIG with VM_CODIG,;
					CA_NRCAR with VM_NRCAR,;
					CA_DESCR with VM_DESCR
	end
end
salvacor(RESTAURA)
return NIL

function CFEPCAR2() // Alterar
VM_CODIG:=CA_CODIG
VM_NRCAR:=CA_NRCAR
VM_DESCR:=CA_DESCR
salvacor(SALVA)
pb_box(10,00,22,maxcol(),'W+/RB,RB/W,,,,W+/RB')
fn_mostrac()
@10,02 say 'C¢digo da Carta: '+VM_CODIG
@10,52 say 'Nr da Carta....:' get VM_NRCAR pict masc(28)
read
if lastkey()#K_ESC
	set cursor on
	pb_msg('ESC - Sai sem gravar   CTRL+W = Gravar',nil,.f.)
	setcolor('R/W')
	VM_DESCR:=memoedit(VM_DESCR,11,03,21,72,.T.)
	set cursor off
	if pb_sn()
		replace  CA_NRCAR with VM_NRCAR,;
					CA_DESCR with VM_DESCR
	end
end
salvacor(RESTAURA)

function CFEPCAR3() // incluir
nao()
function CFEPCAR4() // incluir
nao()
function CFEPCAR5() // incluir
nao()
