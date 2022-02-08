*-----------------------------------------------------------------------------*
function CXAP0001() // Abertura de Caixa
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local LogStat
local DTCXA
local Data
local X

pb_lin4(_MSG_,ProcName())
setcolor(VM_CORPAD)
if !abre({'C->PARAMETRO','C->CAIXA01'})
	return NIL
end
if !xxsenha(ProcName(),_MSG_+'/'+pb_zer(NUM_CXA,2))
	dbcloseall()
	return NIL
end
VM_DTCXA:=PARAMETRO->PA_DATA
LogStat:=fn_StatCxa(NUM_CXA)
if LogStat=="ERRO-1"
	Alert('Erro na Abertura do Caixa='+LogStat)
	dbcloseall()
	return NIL
end
if LogStat=='ABERTO'
	alert("Caixa Numero : "+pb_zer(NUM_CXA,2)+";Esta Aberto em: "+dtoc(CAIXA01->AX_DATA))
	dbcloseall()
	return NIL
end
select CAIXA01
if NUM_CXA == 1
	ORDEM CXA01
elseif NUM_CXA == 2
	ORDEM CXA02
end

Saldo:=CAIXA01->AX_VLRINI
if !dbseek(str(NUM_CXA,2)+dtos(VM_DTCXA))
	if !pb_sn("Caixa N: "+pb_zer(NUM_CXA,2)+";Nao esta aberto para o Dia "+dtoc(VM_DTCXA)+;
				";Deseja Abrir o Caixa para este Dia ?")
		dbcloseall()
		return NIL
	end
else
	Alert('Caixa ja foi aberto para o dia '+dtoc(VM_DTCXA)+ " e fechado")
	dbcloseall()
	return NIL
end
SeqI:=0
SeqF:=0
X   :=15
pb_box(X++,20,,,,'Abertura do Caixa :'+pb_zer(NUM_CXA,2)+' para '+dtoc(VM_DTCXA)+'-Informe!')
 X++
@X++,22 say 'Saldo Inicial Caixa............:' get Saldo    pict mI122 valid Saldo>=0
@X++,22 say 'Sequencia Inicial Documento....:' get SeqI     pict mI5   valid SeqI>=1
@X++,22 say 'Sequencia Final Documento......:' get SeqF     pict mI5   valid SeqF>=SeqI
read
if if(Lastkey()#K_ESC,pb_sn(),.F.)
	AddRec(,{NUM_CXA,;//........1
				VM_DTCXA,;//.......2
				Saldo,;//..........3
				.F.,;//............4-fechado
				SeqI,;//...........5-
				SeqF})//...........6

	alert('Caixa Inicializado')
end
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*

*----------------------------------------------------------------------------------------------
function CRIA_CXAAUX(P1,P2)
local ARQ

*------------------------------------------------* Caixa - Abertura 
ARQ:='CAIXA01'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'AX_CAIXA', 'N', 2, 0},;	//.............1
				 {'AX_DATA',  'D', 8, 0},;	//.............2
				 {'AX_VLRINI','N',15, 2},;	//.............3
				 {'AX_FECHAD','L', 1, 0},;	//.............4
				 {'AX_SEQ_I', 'N', 6, 0},;	//.............5
				 {'AX_SEQ_F', 'N', 6, 0}},;//.............6 Usuario
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* Indices
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Caixa/01 - Reg:'+str(LastRec(),7))
		pack
		Index on str(AX_CAIXA,2)+dtos(AX_DATA) tag CXA01 to (Arq) eval {||ODOMETRO('CXA-1')} for AX_CAIXA == 1
		Index on str(AX_CAIXA,2)+dtos(AX_DATA) tag CXA02 to (Arq) eval {||ODOMETRO('CXA-2')} for AX_CAIXA == 2
		close
	end
end


ARQ:='CAIXA02'
*------------------------------------------------* Caixa - Documentos
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'AX_SEQ',   'N', 6, 0},;	//1
				 {'AX_DATA',  'D', 8, 0},;	//2
				 {'AX_VALOR', 'N',15, 2},;	//3
				 {'AX_CAIXA', 'N', 2, 0},;	//4
				 {'AX_USUAR', 'C',30, 0}},;//5 Observacao NF Padrao
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* Indices
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Caixa Auxiliar - Reg:'+str(LastRec(),7))
		pack
		Index on str(AX_SEQ,6)                               tag CODIGO  to (Arq) eval {||ODOMETRO()}
		Index on str(AX_CAIXA,2)+dtos(AX_DATA)+str(AX_SEQ,6) tag CXADATA to (Arq) eval {||ODOMETRO()}
		close
	end
end

return NIL

//-----------------------------------------------------------------
function FN_SelCxa(P1)
local NroCxa:=NUM_CXA
	pb_box(19,40,21,78,,P1)
	@20,42 say 'Caixa Numero.:' get NroCxa pict mI2 valid NroCxa>0.and.NroCxa<3 when pb_msg("Informe 1 ou 2")
	read
	setcolor(VM_CORPAD)
	if lastkey()==K_ESC
		return 0
	end
return NroCxa

//------------------------------------------------------------
function FN_StatCxa(P1)
local RT:="OK"
SALVABANCO
select CAIXA01
if P1 == 1
	ORDEM CXA01

elseif P1 == 2
	ORDEM CXA02

else
	RT:="ERRO-1"
end
if RT=="OK"
	RT:="FECHADO"
	dbgobottom() // Caixa X ultimo dia
	if AX_CAIXA==P1
		if !AX_FECHAD // não fechado
			RT:="ABERTO"
		end
	else
		RT:="ERRO-2"
	end
end
RESTAURABANCO
return RT
