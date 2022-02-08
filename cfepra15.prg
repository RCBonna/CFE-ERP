*-----------------------------------------------------------------------------*
function CFEPRA15()	// Produtos por Cultura
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
private FILTRO:=''

if !abre({	'R->PARAMETRO','C->PROD','C->PRODAPL2','C->PRODAPL'})
	return NIL
end
select('PROD')
ordem CODIGO
select('PRODAPL2')
ordem CULTURA
set relation to str(P2_CODPR,L_P) into PROD
DbGoTop()
pb_tela()
pb_lin4(_MSG_,ProcName())
pb_dbedit1('CFEPRA15','Selec.PesquiImprim')
VM_CAMPO:={'P2_CULTUR','pb_zer(P2_CODPR,L_P)+chr(45)+left(PROD->PR_DESCR,30)','left(P2_UTILIZ,60)','right(P2_UTILIZ,60)','P2_DOSAGE','P2_CARENC'}
VM_MASC :={mUUU,        mXXX,                                               mXXX,                mXXX,                 mXXX,       mUUU      }
VM_CABE :={'Cultura',  'Produto',                                          'Aplicacao/1',       'Aplicacao/2',        'Dosagem',  'Carencia' }
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
						VM_MASC,VM_CABE)
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*
function CFEPRA151() // Rotina de Selecao
FILTRO:=space(20)
pb_box(20,20,22,60,,'Selecao de Cultura')
@21,21 get FILTRO pict mXXX
read
if !empty(FILTRO)
	FILTRO:=alltrim(FILTRO)
	set filter to FILTRO$P2_CULTUR
else
	set filter to
end
DbGoTop()
return NIL

*-----------------------------------------------------------------------------*
function CFEPRA152() // Rotina de Pesquisa
local CHAVE:=P2_CULTUR
pb_box(20,20,,,,'Pesquisa Cultura')
@21,22 get CHAVE pict mXXX
read
dbseek(trim(CHAVE),.T.)
return NIL

*-----------------------------------------------------------------------------*
function CFEPRA153() // Rotina de Pesquisa
local VM_PAG:=0,X,CPO,;
		VM_REL:='Produtos por Cultura'
      VM_LAR:= 160
if pb_ligaimp(I20CPP)
	DbGoTop()
	while !eof()
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRA15A',VM_LAR)
		?
		for X:=1 to len(VM_CAMPO)
			CPO:=VM_CAMPO[X]
			if X==4
				if !empty(&CPO)
					?space(60)+&CPO + space(1)
				end
			else
				??&CPO + space(1)
			end
		next
		pb_brake()
	end
	DbGoTop()
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C20CPP)
end

function CFEPRA15A() // Cabecalho
local X,CPO
?padc(if(empty(FILTRO),'Todas as Culturas','Cultura : '+alltrim(FILTRO)),VM_LAR)
?
?
for X:=1 to len(VM_CAMPO)
	if X#4
		CPO:=VM_CAMPO[X]
		??padr(VM_CABE[X],len(&CPO)+1)
	end
next
?replicate('-',VM_LAR)
return NIL

