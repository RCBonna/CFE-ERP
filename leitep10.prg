//-----------------------------------------------------------------------------*
  static aVariav := {'',0,.T.,'',1,{},0}
//....................1.2..3...4.5.6..7
//-----------------------------------------------------------------------------*
#xtranslate cArq       => aVariav\[  1 \]
#xtranslate nX         => aVariav\[  2 \]
#xtranslate LCONT      => aVariav\[  3 \]
#xtranslate dLctos     => aVariav\[  4 \]
#xtranslate iTipo      => aVariav\[  5 \]
#xtranslate aVlr       => aVariav\[  6 \]
#xtranslate nY         => aVariav\[  7 \]

#include 'RCB.CH'
//-----------------------------------------------------------------------------*
  function LeiteP10()	//	Informações de Coleta de Leite
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO'		,;
				'R->LEIPARAM'		,;
				'R->PROD'			,;
				'R->CLIENTE'		,;
				'R->LEITRANS'		,;
				'R->LEIMOTIV'		,;
				'R->LEIVEIC'		,;
				'R->LEIROTA'		,;		// criado arquivo no LEITEP00.PRG
				'R->LEICPROD'		,;		// Criado arquivo no LEITEP00.PRG
				'C->LEIDADOS'		;		// Criado arquivo no LEITEP00.PRG
			})
	return NIL
end
set relation to str(LEIDADOS->LD_CDCLI,5) into CLIENTE

dLctos:=PARAMETRO->PA_DATA
pb_dbedit1('LeiteP10')  // tela
VM_CAMPO:=array(5)
VM_CAMPO[1]:='LD_DTCOLET'
VM_CAMPO[2]:='str(LD_CDROTA,6)+str(LD_TARRO,6)+str(LD_SEQUENC,4)'
VM_CAMPO[3]:='str(LD_CDCLI,5)+chr(45)+left(CLIENTE->CL_RAZAO,25)'
VM_CAMPO[4]:='LD_PLACA'
VM_CAMPO[5]:='LD_VOLTANT'

dbedit(06,01,maxrow()-3,maxcol()-1,;
			VM_CAMPO,;
			'PB_DBEDIT2',;
			{       mDT ,				mXXX ,		 mXXX ,mPLACA ,       mD10 },;
			{'Dt Coleta','Rota+Tarro+Seq',   'Cliente','Placa','Qtd.Coleta'};
			)
dbcommit()
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP101() // Rotina de Inclus„o
//-----------------------------------------------------------------------------*
NAO('ATENCAO;Validar se sera necessario')
return NIL
//-----------------------------------------------------------------------------*
	function LeiteP102() // Rotina de Altera‡„o
//-----------------------------------------------------------------------------*
if RecLock()
	LeiteP10T(.F.)
end
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP103() // Rotina de Pesquisa
//-----------------------------------------------------------------------------*
NAO('Nao desenvolvido')
return NIL
//-----------------------------------------------------------------------------*
	function LeiteP104() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
ELIMINA_REG('Registro ( '+DtoC(LEIDADOS->LD_DTCOLET)+'-Cliente:'+Str(LEIDADOS->LD_CDCLI,5)+')')
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP10T(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST := {}
private nX1
for nX :=1 to fcount()
	nX1 :="VM"+substr(fieldname(nX),3)
	&nX1:=FieldGet(nX)
next

nX:=05
pb_box(nX++,,,,,'Informacoes Leite-Movimentacao')
@nX  ,01 say 'Cod.Filiada......:'	get VM_CDFILI	pict mI2			valid VM_CDFILI>0
@nX  ,30 say 'Cod.Propriedade:'		get VM_CDPROP	pict mI2			valid VM_CDPROP>0
@nX++,60 say 'Cod.Estabulo:'			get VM_ESTABUL	pict mI2			valid VM_ESTABUL>0
@nX++,01 say 'Cod.Produtor.....:'	get VM_CDCLI	pict mI5			valid fn_codigo(@VM_CDCLI,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CDCLI,5)))},{||NIL},{2,1}}).and.;
																								pb_ifcod2(str(VM_CDCLI,5),'LEICPROD',.T.,2)
@nX++,01 say 'Nome Produtor....:'	get VM_NOMEPRO	pict mXXX+'S50'								when .F. color 'GR+/G'
@nX++,01 say 'CPF/CNPJ.........:'	get VM_CPFCPPJ	pict mXXX										when .F. color 'GR+/G'
@nX++,01 say 'Cod.Rota.........:'	get VM_CDROTA	pict mI6			valid fn_codigo(@VM_CDROTA,{'LEIROTA',{||LEIROTA->(dbseek(str(VM_CDROTA,6)))},{||NIL},{2,1}})
@nX  ,01 say 'Cod.Tarro........:'	get VM_TARRO	pict mI6			valid pb_ifcod2(str(VM_CDROTA,6)+str(VM_TARRO,6),'LEICPROD',.T.,1)
@nX++,30 say 'Sequencia:'				get VM_SEQUENC	pict mI4			valid VM_SEQUENC>0
@nX++,01 say 'Placa Transp.....:'	get VM_PLACA	pict mPLACA		valid pb_ifcod2(VM_PLACA,'LEIVEIC',.T.,2)
@nX  ,01 say 'Alizarol.........:'	get VM_ALIZAR	pict mXXX
@nX++,60 say 'Alterado depois:'		get VM_ALTERAD	pict mXXX		valid VM_ALTERAD$'SN'
@nX++,01 say 'Cod.Motivo Rej...:'	get VM_CDMOTIV	pict mI4			valid VM_CDMOTIV=0.or. fn_codigo(@VM_CDMOTIV,{'LEIMOTIV',{||LEIMOTIV->(dbseek(str(VM_CDMOTIV,4)))},{||NIL},{2,1}})
@nX  ,01 say 'Nro da Viagem....:'	get VM_NRVIAG	pict mI4			valid VM_NRVIAG>0
@nX  ,30 say 'Dt Int.Leitor:'			get VM_DTEMISS	pict mDT											when .F. color 'GR+/G'
@nX++,60 say 'Hr Leitor:'				get VM_HREMISS	pict mXXX										when .F. color 'GR+/G'
@nX  ,01 say 'Feito Reenvio?...:'	get VM_REENVIA	pict mXXX		valid VM_REENVIA$'SN'
@nX++,30 say 'Dt Coleta....:'			get VM_DTCOLET	pict mDT
@nX  ,01 say 'Coleta Rejeitada?:'	get VM_REJEITA	pict mXXX		valid VM_REJEITA$'SN'
@nX++,30 say 'Temperatura......:'	get VM_TEMPER	pict mI62		valid VM_TEMPER>=0.and. VM_TEMPER<50
@nX  ,01 say 'Quatid.Tanque 1..:'	get VM_VOLTAN1	pict mD10		valid VM_VOLTAN1>=0
@nX++,30 say 'Quatid.Tanque 2..:'	get VM_VOLTAN2	pict mD10		valid VM_VOLTAN2>=0
@nX  ,01 say 'Quatid.Tanque 3..:'	get VM_VOLTAN3	pict mD10		valid VM_VOLTAN3>=0
@nX++,30 say 'Quatid.Tanque 4..:'	get VM_VOLTAN4	pict mD10		valid VM_VOLTAN4>=0
@nX  ,01 say 'Quatid.Tanque 5..:'	get VM_VOLTAN5	pict mD10		valid VM_VOLTAN5>=0
@nX++,30 say 'Quatid.Total.....:'	get VM_VOLTANT	pict mD10										when .F.  color 'GR+/G'
@nX++,01 say 'Dt Importacao....:'	get VM_DTIMPOR	pict mDT											when .F.  color 'GR+/G'
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCont:=AddRec()
	end
	if LCont
		VM_VOLTANT:=VM_VOLTAN1+VM_VOLTAN2+VM_VOLTAN3+VM_VOLTAN4+VM_VOLTAN5
		for nX:=1 to fcount()
			nX1:="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &nX1
		next
		DbCommit()
	end
end
DbRunLock(RecNo())
return NIL

//------------------------------------------------------------------EOF
