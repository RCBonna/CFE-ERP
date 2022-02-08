//-----------------------------------------------------------------------------*
  static aVariav := {'',0,0}
//....................1.2.3..4..5..6..7...8..9.10.11.12.13.14.15.16.17
//-----------------------------------------------------------------------------*
#xtranslate cPeriodo		=> aVariav\[  1 \]
#xtranslate nCliente		=> aVariav\[  2 \]
#xtranslate nX				=> aVariav\[  3 \]

#include 'RCB.CH'

//-----------------------------------------------------------------------------*
	function LeiteP24()	//	Apresentar os Valores Calculados
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
cFilter		:=''
VM_Periodo	:=Space(6)
VM_CTarro	:=0
if !abre({	'R->PARAMETRO'		,;
				'R->CLIENTE'		,;		//
				'R->LEIPARAM'		,;		// Parametros do Leite (LEITEP00.PRG)
				'C->LEILABOR'		,;		// Dados de Analise Leite Laboratório (LEITEP00.PRG)
				'R->LEIROTA'		,;		// criado arquivo no LEITEP00.PRG
				'R->LEICPROD'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIGORD'		,;		// Faixa de Gordura (LEITEP12.PRG)
				'R->LEIPROT'		,;		// Faixa de Proteina (LEITEP13.PRG)
				'R->LEIESD'			,;		// Faixa de ESD (LEITEP14.PRG)
				'R->LEICCS'			,;		// Faixa de CCS (LEITEP15.PRG)
				'R->LEICPP'			,;		// Faixa de CPP (LEITEP16.PRG)
				'C->LEIDADOS'		,;		// Dados dos Cliente (LEITEP00.PRG)
				'C->LEIBON'			;		// Calculo Valores Qualidade Leite (LEITEP00.PRG)
			})
	return NIL
end

select LEIBON
ORDEM CLIPER
DbGoTop()
set relation to Str(LEIBON->CB_CDCLI,5) into CLIENTE

nX:=Alert(	'Apresentar os Calculos para o Periodo',;
				{Transform(LEIPARAM->LP_PERIODO,mPER),'Outro'})

if nX==1
	cFilter='LEIBON->CB_PERIOD==LEIPARAM->LP_PERIODO' // Verificar no Parametro

elseif nX==2
	setcolor('W+/R,R/W+,,,W+/R')
	@22,30 say PadR('Filtro',40)
	@22,40 say 'Nr Tarro :' get VM_CTarro 	pict mI6  when pb_msg('Tarro Zerado sera apresentado todos - <ESC> para Sair')
	@22,58 say 'Periodo:'   get VM_Periodo pict mPER when pb_msg('Data em Branco sera apresentado todas - <ESC> para Sair')
	read
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,.T.,.F.)
		if VM_CTarro>0
			cFilter:='str(LEIBON->CB_TARRO,6)==str(VM_CTarro,6)'
		end
		if !Empty(VM_Periodo)
			if len(cFilter)>0
				cFilter+='.and.'
			end
			cFilter+='LEIBON->CB_PERIOD==VM_Periodo' // se Informar Data
		end
	end
end
if !Empty(cFilter)
	set filter to &cFilter
	DbGoTop()
end

pb_dbedit1('LeiteP24')  // tela
VM_CAMPO:=Array(FCount())
VM_DESCR:=Array(FCount())
VM_MASC :={mXXX,mPER,mI52,mI52,mI52,mI52,mI52,mI6,mI6,mI74,mI74,mI74,mI74,mI74,mI6,mXXX}
AFields(VM_CAMPO)
VM_CAMPO[1]:='Str(CB_CDCLI,5)+chr(45)+Left(CLIENTE->CL_RAZAO,20)'
AFields(VM_DESCR)
AEval(VM_DESCR,{|DET,N|VM_DESCR[N]:=substr(VM_DESCR[N],4)})

dbedit(06,01,maxrow()-3,maxcol()-1,;
				VM_CAMPO,;
				'PB_DBEDIT2',;
				VM_MASC,; // Mascara
				VM_DESCR;
				)
set relation to
DbCommit()	
DbCloseAll()
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP241() // Rotina de Inclus„o
//-----------------------------------------------------------------------------*
NAO('Avaliar com Edna sobre necessidade neste estagio de Leite')
LeiteP24T(.F.)
return NIL
//-----------------------------------------------------------------------------*
	function LeiteP242() // Rotina de Altera‡„o
//-----------------------------------------------------------------------------*
//if reclock()
	NAO('Avaliar com Edna sobre necessidade neste estagio de Leite')
	LeiteP24T(.F.)
//end
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP243() // Rotina de Pesquisa
//-----------------------------------------------------------------------------*
//cPeriodo:=LEIBON->CB_PERIODO
//nCliente:=LEIBON->CB_CDCLI
	NAO('Avaliar com Edna sobre necessidade neste estagio de Leite')

return NIL

//-----------------------------------------------------------------------------*
	function LeiteP244() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
ELIMINA_REG('Mensagem: Cliente:'+str(FieldGet(1),5)+' Periodo:'+FieldGet(2))
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP24T(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST := {}
private nX1
for nX 	:=1 to FCount()
	nX1 	:="VM"+substr(fieldname(nX),3)
	&nX1	:=FieldGet(nX)
next
nX			:=09

pb_box(nX++,20,,,,'LEITE - Dados com Valor Calculado das Analises')
@nX  ,22 say 'Produtor......:' get VM_CDCLI		pict mI5 	when .F.
@nX++,43 say '-'+Left(CLIENTE->CL_RAZAO,30)
@nX++,22 say 'Periodo.......:' get VM_PERIOD		pict mPER	when .F. // valid pb_ifcod2(str(VM_TARRO,6)+DtoS(VM_DTCOLE),NIL,.F.)
 nX++
@nX  ,22 say '% Gordura.....: ' get VM_GORDUR	pict mI52	when .F. 
@nX++,52 say 'Vlr Gordura...:'  get VM_VLGORD	pict mI74	when .F. 

@nX  ,22 say '% Proteina....: ' get VM_PROTEI	pict mI52	when .F.
@nX++,52 say 'Vlr Proteina..:' get VM_VLPROT		pict mI74	when .F.

@nX  ,22 say '% ESD.........: ' get VM_ESD		pict mI52	when .F.
@nX++,52 say 'Vlr ESD.......:' get VM_VLESD		pict mI74	when .F.

@nX  ,22 say 'Nr CCS*1000...:' get VM_NRCCS		pict mI6		when .F.
@nX++,52 say 'Vlr CCS.......:' get VM_VLCCS		pict mI74	when .F.

@nX  ,22 say 'Nr CPP*1000...:' get VM_NRCPP		pict mI6		when .F.
@nX++,52 say 'Vlr CPP.......:' get VM_VLCPP		pict mI74	when .F.
 nX++

@nX  ,22 say '% Lactose.....: ' get VM_LACTOS	pict mI52	when .F.
@nX++,52 say '% Solido Total:' get VM_PERSOL		pict mI52	when .F.
 nX++

@nX  ,22 say 'Nr.NF.Produtor:' get VM_NRNFPR		pict mI6 	when .F.
@nX++,52 say 'ERRO Calculo..:' get VM_ERFXCL		pict mXXX 	when .F.

read
setcolor(VM_CORPAD)
pb_msg('Informacoes do calculo de valores da analise de Leite-Press <Enter>')
inkey(0)
dbrunlock(RecNo())
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP245() // Impressão
//-----------------------------------------------------------------------------*
NAO('IMPRESSAO')
return NIL

//------------------------------------------------------------------EOF
