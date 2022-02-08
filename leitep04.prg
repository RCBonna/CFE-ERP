//-----------------------------------------------------------------------------*
  static aVariav := {'', 0, .T. ,0, 0, 0}
//....................1..2...3...4..5..6
//-----------------------------------------------------------------------------*
#xtranslate cArq		=> aVariav\[  1 \]
#xtranslate nX			=> aVariav\[  2 \]
#xtranslate LCONT		=> aVariav\[  3 \]
#xtranslate nXL		=> aVariav\[  4 \]
#xtranslate nROTA		=> aVariav\[  5 \]
#xtranslate nReg		=> aVariav\[  6 \]

#include 'RCB.CH'

//-----------------------------------------------------------------------------*
  function LeiteP04()	//	Cadastro Complementar Dados Leite Produtor
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'R->CLIENTE',;
				'C->LEIROTA',;		// Criado arquivo no LEITEP00.PRG
				'C->LEICPROD';		// Criado arquivo no LEITEP00.PRG
				})
	return NIL
end
set relation to str(LEICPROD->LC_CDCLI,5) into CLIENTE

pb_dbedit1('LeiteP04')  // tela
aCAMPO:=Array(FCount())
aFields(aCAMPO)
aCAMPO[2]:='str(LC_CDCLI,5)+chr(45)+left(CLIENTE->CL_RAZAO,25)'

dbedit(06,01,maxrow()-3,maxcol()-1,;
			aCAMPO,;
			'PB_DBEDIT2',;
			{ mI2 ,     mXXX ,  mI2 ,  mI6 ,   mI2 ,   mI6 , mI3 , mI61, mI61,    mI9 ,  mI9 ,       mI9 ,       mDT },;
			{'Fil','Produtor','Prop','Rota','Estab','Tarro','Seq','CCS','CBT','SIGSIF','NIRF','CAP.RESFR','DtIniEntr'};
			)
dbcommit()
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP041() // Rotina de Inclusão
//-----------------------------------------------------------------------------*
local GETLIST := {}
private nX1
while lastkey()#K_ESC
	for nX :=1 to fCount()
		nX1 :="VM"+substr(fieldname(nX),3)
		&nX1:=FieldGet(nX)
	next
	VM_DTIENTR	:=if(empty(VM_DTIENTR),date()	,VM_DTIENTR)
	VM_CDFILI	:=if(empty(VM_CDFILI),		1	,VM_CDFILI)
	VM_ESTABUL	:=if(empty(VM_CDPROP),		1	,VM_CDPROP)
	VM_ESTABUL	:=if(empty(VM_ESTABUL),		1	,VM_ESTABUL)
	nXL:=6
	pb_box(nXL++,20,,,,'LEITE-Dados Compl.Produtores')
	nXL++
	@nXL++,22 say 'Cod.Rota......:'	get VM_CDROTA	pict mI6		valid fn_codigo(@VM_CDROTA,{'LEIROTA',{||LEIROTA->(dbseek(str(VM_CDROTA,6)))},NIL,{2,1}});
												when pb_msg('Informe codigo da Rota de Coleta de Leite')
	@nXL++,22 say 'Cod.Tarro.....:'	get VM_TARRO	pict mI6		valid VM_TARRO>0.and.;
																							pb_ifcod2(str(VM_CDROTA,6)+str(VM_TARRO,6),'LEICPROD',.F.,1);
												when pb_msg('Informe Nr. Tarro dentro da Rota da Coleta')
	@nXL++,22 say 'Sequencia.....:'	get VM_SEQUENC	pict mI3		valid VM_SEQUENC>0;
												when pb_msg('Informe Nr. Sequencia/Tarro dentro da Rota da Coleta')
	nXL++
	@nXL++,22 say 'Cod.Filiada...:'  get VM_CDFILI	pict mI2		valid VM_CDFILI>=0;
												when pb_msg('Informe Codigo da Filiada')
	@nXL++,22 say 'Cod.Propriedade'  get VM_CDPROP	pict mI2		valid VM_CDPROP>=0;
												when pb_msg('Informe Codigo da Propriedade')
	@nXL++,22 say 'Cod.Produtor..:'  get VM_CDCLI	pict mI5		valid fn_codigo(@VM_CDCLI,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CDCLI,5)))},NIL,{2,1}}).and.;
																							pb_ifcod2(str(VM_CDCLI,5),'LEICPROD',.F.,2);
												when pb_msg('Informe Codigo Produtor - so pode existir cadastro de um Produtor')
	@nXL++,22 say 'Nr.Estabulo...:'  get VM_ESTABUL	pict mI2		valid VM_ESTABUL>=0.and.;
																							pb_ifcod2(str(VM_CDFILI,2)+str(VM_CDCLI,5)+str(VM_CDPROP,2)+str(VM_CDROTA,6)+str(VM_ESTABUL,2)+str(VM_TARRO,6)+str(VM_SEQUENC,3),'LEICPROD',.F.,3);
												when pb_msg('Nr.Estabulo-Valida Cod Filiada+Cod Cliente+Cod Propr+Cod Rota+Cod Tarro+Sequ')
	@nXL++,22 say 'Analise-CCS...:'	get VM_ANA_CCS pict mD12	valid VM_ANA_CCS>=0;
												when pb_msg('Informar Analise Contagem de Celulas Somáticas (CCS)')
	@nXL++,22 say 'Analise-CBT...:'	get VM_ANA_CBT pict mD12	valid VM_ANA_CBT>=0;
												when pb_msg('Informar Analise Contagem Bacteriana Total (CBT)')
	@nXL++,22 Say 'Cod.SIGSIF....:'	get VM_SIGSIF 	pict mI4		valid VM_SIGSIF>=0;
												when pb_msg('Informe Codigo SIG-SIF')
	@nXL++,22 Say 'Cod.NIRF......:'	get VM_NIRF 	pict mI8		valid VM_NIRF>=0;
												when pb_msg('Informe Codigo NIRF')
	@nXL++,22 Say 'Cap.Resfriament'	get VM_CAPRESF	pict mI8		valid VM_CAPRESF>=0;
												when pb_msg('Informe Capacidade de Resfriamento')
	@nXL++,22 Say 'Dt.Inic.Entreg:'	get VM_DTIENTR pict mDT		valid !empty(VM_DTIENTR);
												when pb_msg('Data inicial de entrega de leite')
	read
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		LCONT:=AddRec()
		if LCONT
			for nX:=1 to fcount()
				nX1:="VM"+substr(fieldname(nX),3)
				replace &(fieldname(nX)) with &nX1
			next
			dbcommit()
		end
	end
	dbrunlock(recno())
end
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP042() // Rotina de Alteração
//-----------------------------------------------------------------------------*
local GETLIST := {}
nReg:=RecNo()
private nX1
for nX :=1 to fCount()
	nX1 :="VM"+substr(fieldname(nX),3)
	&nX1:=FieldGet(nX)
next
nXL:=6
pb_box(nXL++,20,,,,'LEITE-Dados Compl.Produtores')
nXL++
@nXL++,22 say 'Cod.Rota......:'	get VM_CDROTA	pict mI6		valid fn_codigo(@VM_CDROTA,{'LEIROTA',{||LEIROTA->(dbseek(str(VM_CDROTA,6)))},NIL,{2,1}});
											when pb_msg('Informe codigo da Rota de Coleta de Leite').and. .F.
@nXL++,22 say 'Cod.Tarro.....:'	get VM_TARRO	pict mI6		valid VM_TARRO>0.and. pb_ifcod2(str(VM_CDROTA,6)+str(VM_TARRO,6),'LEICPROD',.F.,1);
											when pb_msg('Informe Nr. Tarro dentro da Rota da Coleta').and. .F.
@nXL++,22 say 'Sequencia.....:'	get VM_SEQUENC	pict mI3		valid VM_SEQUENC>0;
											when pb_msg('Informe Nr. Sequencial/Tarro dentro da Rota da Coleta')
nXL++
@nXL++,22 say 'Cod.Filiada...:'  get VM_CDFILI	pict mI2		valid VM_CDFILI>=0;
											when pb_msg('Informe Codigo Filiada').and. .F.
@nXL++,22 say 'Cod.Propriedade'  get VM_CDPROP	pict mI2		valid VM_CDPROP>=0;
											when pb_msg('Informe Codigo da Propriedade').and. .F.
@nXL++,22 say 'Cod.Produtor..:'  get VM_CDCLI	pict mI5		valid fn_codigo(@VM_CDCLI,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CDCLI,5)))},NIL,{2,1}}).and.;
																						pb_ifcod2(str(VM_CDCLI,5),'LEICPROD',.F.,2);
											when pb_msg('Informe Codigo do Cliente/Produtor')
@nXL++,22 say 'Nr.Estabulo...:'  get VM_ESTABUL	pict mI2		valid VM_ESTABUL>=0.and.;
																						pb_ifcod2(str(VM_CDFILI,2)+str(VM_CDCLI,5)+str(VM_CDPROP,2)+str(VM_CDROTA,6)+str(VM_ESTABUL,2)+str(VM_TARRO,6)+str(VM_SEQUENC,3),'LEICPROD',.F.,3);
											when pb_msg('Nr.Estabulo-Valida Cod Filiada+Cod Cliente+Cod Propr+Cod Rota+Cod Tarro+Sequ').and. .F.
@nXL++,22 say 'Analise-CCS...:'	get VM_ANA_CCS pict mI4		valid VM_ANA_CCS>=0;
											when pb_msg('Informar Analise Contagem de Celulas Somáticas (CCS)')
@nXL++,22 say 'Analise-CBT...:'	get VM_ANA_CBT pict mI4		valid VM_ANA_CBT>=0;
											when pb_msg('Informar Analise Contagem Bacteriana Total (CBT)')
@nXL++,22 Say 'Cod.SIGSIF....:'	get VM_SIGSIF 	pict mI9		valid VM_SIGSIF>=0;
											when pb_msg('Informe Codigo SIG-SIF')
@nXL++,22 Say 'Cod.NIRF......:'	get VM_NIRF 	pict mI8		valid VM_NIRF>=0;
											when pb_msg('Informe Codigo NIRF')
@nXL++,22 Say 'Cap.Resfriament'	get VM_CAPRESF	pict mI8		valid VM_CAPRESF>=0;
											when pb_msg('Informe Capacidade de Resfriamento')
@nXL++,22 Say 'Dt.Inic.Entreg:'	get VM_DTIENTR pict mDT		valid !empty(VM_DTIENTR);
											when pb_msg('Data inicial de entrega de leite')
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	DbGoTo(nReg)
	LCONT:=RecLock()
	if LCONT
		for nX:=1 to fcount()
			nX1:="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &nX1
		next
		dbcommit()
	end
end
dbrunlock(recno())
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP043() // Rotina de Pesquisa
//-----------------------------------------------------------------------------*
  return NIL

//-----------------------------------------------------------------------------*
  function LeiteP044() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
ELIMINA_REG('Cadastro Rota Cliente:'+str(LC_CDFILI,2)+str(LC_CDCLI,5)+str(LC_CDPROP,2)+str(LC_CDROTA,6)+str(LC_ESTABUL,2)+str(LC_TARRO,6)+str(LC_SEQUENC,3))
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP045() // Impressão
//-----------------------------------------------------------------------------*
NAO('IMPRESSAO')
return NIL

//------------------------------------------------------------EOF--------------*
