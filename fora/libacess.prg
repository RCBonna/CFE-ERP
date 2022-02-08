*-----------------------------------------------------------------------------*
* EDITA-Editor de MENU																			*
*-----------------------------------------------------------------------------*
#include 'INKEY.CH'
static LINHA:=0
function libacesso(P1)
LOCAL nSaveSel, aMenu := {}
private FILT1,FILT2
LINHA:=0
if rt_nrusu()>'1'
	alert('Usu rio '+rt_nomeusu()+' sem acesso a este programa')
end
dbcloseall()
if !net_use('SENHAS.RCB',.T., ,'SENHAS',, .F.,DBSETDRIVER())
	quit
end
if rt_nrusu()==' '
	set filter to SENHAS->_NR_>" " // nao mostra o desenvolvimento
else
	set filter to SENHAS->_NR_>"1" // nao mostra o desenvolvimento e gerente
end
dbgotop()

if !net_use(P1+'.RCB',.T., ,'MENU',, .F.,DBSETDRIVER())
	dbcloseall()
	quit
end
	dbsetindex(P1)
	FILT1:="rt_nrusu()$MENU->ACESSO"
	FILT2:=".T."
//	set filter to &FILT1 .and. &FILT2 // nao mostra os outros acessos
	dbgotop()
	pb_tela()
	pb_lin4('Liberacao a usuarios',procname())
	while fn_modulos('M¢dulos','0     ')
	end
dbcloseall()
return nil

static function FN_MODULOS(P1,P2)
local TF:=savescreen()
local RT:=.T.
private P4:=P2
private FILT3:=FILT2
FILT2:="MENU->MENU==P4"
salvabd()
select('MENU')
set filter to &FILT1 .and. &FILT2 // nao mostra os outros acessos
dbgotop()
salvacor()
pb_box(6+LINHA,1+LINHA,21,33+LINHA,'W+/B',P1)
dbedit(7+LINHA,2+LINHA,20,32+LINHA,{'substr(MENU->PROMPT,2)'},,'','','')
if lastkey()==K_ENTER
	FN_QUSU()
else
	RT:=.F.
end
set filter to &FILT1 .and. &FILT3 // nao mostra os outros acessos
salvacor(.f.)
salvabd(.f.)
restscreen(,,,,TF)
return RT

*------------------------------------------------------------------------*
static function FN_QUSU()
local TF:=savescreen()
local POS,REGISTRO:=MENU->(recno())
local OPC
salvacor()
pb_box(7+LINHA,36+LINHA,21,74+LINHA,'W+/R*',trim(substr(MENU->PROMPT,2)))
select('SENHAS')
while .T.
	dbgotop()
	dbedit(8+LINHA,37+LINHA,20,73+LINHA,;
		{"left(SENHAS->_NOME_,25)+'=>'+if(SENHAS->_NR_$MENU->ACESSO,'Liberado','........')"},,,;
		'',' ','')
	if lastkey()==K_ENTER
		POS:=at(SENHAS->_NR_,MENU->ACESSO) // tem acesso ?
		OPC:=2
		if !empty(MENU->PROXMENU)
			OPC:=alert('Selecione...',{'Pr¢ximo Menu',if(POS>0,'Cancela Libera‡Æo','Libera')})
		end
		if OPC==2
			if POS > 0 // tem acesso
				replace	MENU->ACESSO with ;
							strtran(MENU->ACESSO,SENHAS->_NR_,'')	// tirar acesso
			else	// colocar
				POS:=at(' ',MENU->ACESSO) // colocar acesso
				replace 	MENU->ACESSO with ;
							posrepl(MENU->ACESSO,SENHAS->_NR_,POS)	// dar acesso
			end
		elseif OPC==1
			LINHA++
			fn_modulos(trim(substr(MENU->PROMPT,2)),MENU->PROXMENU)
			LINHA--
			MENU->(dbgoto(REGISTRO))
		end
	else
		exit
	end
end
select('MENU')
restscreen(,,,,TF)
salvacor(.F.)
return NIL
