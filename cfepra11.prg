*-----------------------------------------------------------------------------*
 function CFEPRA11()	// Cadastro de Itens - Receituario Agronomico
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local X
local SENHA:=''
local CodX :=trunca(TimeToSec(Time()),0)
if !abre({	'R->PARAMETRO',;
				'C->PARALINH',;
				'C->GRUPOS',;
				'C->PROD',;
				'C->PRODAPL2',;
				'C->PRODAPL'})
	return NIL
end
	select('PROD')
	ordem CODIGO
	select('PRODAPL')
	set relation to str(P1_CODPR,L_P) into PROD
	DbGoTop()
	pb_tela()
	pb_lin4(_MSG_,ProcName())
	pb_dbedit1('CFEPRA11','IncluiAlteraPesquiExclui')
	VM_CAMPO:={'str(P1_CODPR,L_P)+chr(45)+left(PROD->PR_DESCR,30)','P1_CLTOX','P1_PRINAT'}
	VM_MASC :={                                            masc(1),  masc(28), mXXX}
	VM_CABE :={                                          'Produto', 'CTox','Princ Ativo' }
	dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
							 VM_MASC,VM_CABE)
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CFEPRA111() // Rotina de Inclus„o
while lastkey()#27
	dbgobottom()
	dbskip()
	CFEPRA11T(.T.)
	dbrunlock()
end
return NIL
*-----------------------------------------------------------------------------*

function CFEPRA112() // Rotina de Alteracao
if reclock()
	CFEPRA11T(.F.)
	dbrunlock(recno())
end
return NIL
*-----------------------------------------------------------------------------*

function CFEPRA11T(VM_FL)
local GETLIST := {},LCONT:=.T.,X,Y
local ORDANT:=indexord()
for X:=1 to fcount()
	Y :='VM'+substr(fieldname(X),3)
	&Y:=&(fieldname(X))
next
if VM_FL
	VM_CLTOX :=1
	VM_APLICA:= ''
end

pb_box(,,,,,'Produtos Agronomicos')
@06,02 say 'C¢digo Produto.:' get VM_CODPR pict masc(21) valid pb_ifcod2(str(VM_CODPR,L_P),NIL,.F.).and.fn_codpr(@VM_CODPR,77).and.PROD->(reclock()) when VM_FL
if !VM_FL
	@06,36 say PROD->PR_DESCR+'|'
end
@07,02 say 'Cl.Toxicologica:' get VM_CLTOX  pict masc(28) valid VM_CLTOX>0.and.VM_CLTOX<5
@07,22 say 'Grupo Quimic...:' get VM_GRQUIM pict mXXX
@08,02 say 'Princ. Ativo...:' get VM_PRINAT pict mXXX
@09,02 say 'Diagnostico....:' get VM_DIAGN  pict mXXX

read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		for VM_X:=1 to fcount()
			VM_Y:="VM"+substr(fieldname(VM_X),3)
			replace &(fieldname(VM_X)) with &VM_Y
		next
		// dbcommit()
		dbskip(0)
	end
	fn_edprod2()
	if VM_FL
		DbGoTop()
	end
end
setcolor(VM_CORPAD)
return NIL
*-----------------------------------------------------------------------------*

function CFEPRA113() // Rotina de Pesquisa
local VM_CODPR:=P1_CODPR
@21,30 say 'Pesquisar ' get VM_CODPR pict masc(21)
read
setcolor(VM_CORPAD)
dbseek(str(VM_CODPR,L_P),.T.)
return NIL
*-----------------------------------------------------------------------------*

function CFEPRA114() // Rotina de Exclusao
if reclock().and.pb_sn('Excluir PRODUTO..:'+pb_zer(P1_CODPR,L_P)+chr(45)+trim(PROD->PR_DESCR))
	fn_elimi()
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
function FN_EDPROD2() // Rotina de Exclusao
local X
VM_DET:={}
for X:=1 to 99
	aadd(VM_DET,{space(20),space(120),space(25),space(10),space(20),0})
end
X:=1
salvabd(SALVA)
select('PRODAPL2')
dbseek(str(VM_CODPR,L_P),.T.)
while !eof().and.VM_CODPR==P2_CODPR
	if reclock()
		VM_DET[X,1]:=P2_CULTUR
		VM_DET[X,2]:=P2_UTILIZ
		VM_DET[X,3]:=P2_DOSAGE
		VM_DET[X,4]:=P2_CARENC
		VM_DET[X,6]:=recno()
	end
	X++
	if X>len(VM_DET)
		dbgobottom()
	end
	dbskip()
end
OPC:=1
while OPC>0
	OPC:=abrowse(9,0,22,79,VM_DET,  {'Cultura','Aplicacao','Dosag','Carencia'},;
												{      20 ,        35 ,    6  ,       10},;
												{     mUUU,      mXXX ,  mXXX ,     mXXX},,;
												'Culturas Aplicacao')
	if OPC>0
		VM_CULT  :=VM_DET[OPC,1]
		VM_APLIC :={left(VM_DET[OPC,2],60),right(VM_DET[OPC,2],60)}
		VM_DOSAG :=VM_DET[OPC,3]
		VM_CARENC:=VM_DET[OPC,4]
		pb_box(16,0,22,79,,'Dados da Cultura/Aplicacao')
		@17,02 say 'Cultura..:' get VM_CULT     pict mUUU when pb_msg('Para apagar a informacao digite Brancos')
		@18,02 say 'Aplicacao:' get VM_APLIC[1] pict mUUU when !empty(VM_CULT)
		@19,13                  get VM_APLIC[2] pict mUUU when !empty(VM_CULT)
		@20,02 say 'Dosagem..:' get VM_DOSAG    pict mUUU when !empty(VM_CULT)
		@21,02 say 'Carencia.:' get VM_CARENC   pict mUUU when !empty(VM_CULT)
		read
		if if(lastkey()#K_ESC,pb_sn(),.F.)
			if empty(VM_CULT)
				VM_DET[OPC,1]:=space( 20)
				VM_DET[OPC,2]:=space(120)
				VM_DET[OPC,3]:=space( 25)
				VM_DET[OPC,4]:=space( 10)
			else
				VM_DET[OPC,1]:=VM_CULT
				VM_DET[OPC,2]:=VM_APLIC[1]+VM_APLIC[2]
				VM_DET[OPC,3]:=VM_DOSAG
				VM_DET[OPC,4]:=VM_CARENC
			end
		end
	else
		if pb_sn()
			for X:=1 to len(VM_DET)
				if empty(VM_DET[X,1]) 
					if VM_DET[X,6]>0 // EXISTE REG APAGAR
						DbGoTo(VM_DET[X,6])
						dbdelete()
					end
				else
					if VM_DET[X,6]<1
						AddRec()
						replace  P2_CODPR  with VM_CODPR
					else
						DbGoTo(VM_DET[X,6])
					end
						replace  P2_CULTUR with VM_DET[X,1],;
									P2_UTILIZ with VM_DET[X,2],;
									P2_DOSAGE with VM_DET[X,3],;
									P2_CARENC with VM_DET[X,4]
				end
			next
		end
	end		
end
salvabd(RESTAURA)
return NIL
// eof //
