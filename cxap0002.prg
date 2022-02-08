*-----------------------------------------------------------------------------*
function CXAP0002()	//	Digitacao Documentos de Caixa
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local NroCxa  :=NUM_CXA
local VM_DTCXA:=date()
local NroLimit:={0,0}
local LogStat
local X
pb_lin4(_MSG_,ProcName())
NroCxa:=FN_SelCxa('Digitar Valores dos Documentos')

if NroCxa==0
	Return Nil
end

if !abre({'C->PARAMETRO','C->CAIXA01','E->CAIXA02'})
	return NIL
end

pb_lin4(_MSG_+"/ Caixa="+pb_zer(NroCxa,2),ProcName())
pb_box(10,18,,,,'Digitar Documentos do Caixa')
LogStat:=fn_StatCxa(NroCxa)

if LogStat=="ERRO-1"
	Alert('Erro na Abertura do Caixa='+LogStat)
	dbcloseall()
	return NIL
end
if LogStat=="FECHADO"
	alert('Caixa Numero : '+pb_zer(NroCxa,2)+';Ja esta FECHADO em: '+dtoc(CAIXA01->AX_DATA))
	dbcloseall()
	return NIL
end

VM_DTCXA:=CAIXA01->AX_DATA
NroLimit:={CAIXA01->AX_SEQ_I,CAIXA01->AX_SEQ_F}
ArrDig  :=array(10,3)
VM_SEQ  :=1
aeval(ArrDig,{|DET|DET[1]:=0})
aeval(ArrDig,{|DET|DET[2]:=0})
aeval(ArrDig,{|DET|DET[3]:=0})
set key K_F10 to AltArrDig()		// F10-Grava ajuda on line
while .T.
	VM_SEQ    :=0
	VM_NUM_CXA:=NUM_CXA
	Valor     :=0
	pb_msg('- F10 - Altera os valores ja digitados ao lado')
	@11,22 say padr('Caixa Numero',16,'.')+transform(NroCxa,  mI2)
	@12,22 say padr('Data'        ,16,'.')+transform(VM_DTCXA,mDT)
	@13,22 say padr('Limites'     ,16,'.')+str(NroLimit[1],6)+" ate "+str(NroLimit[2],6)
	@15,22 say padr('Sequencia'   ,16,'.') get VM_SEQ  pict mI6   valid pb_ifcod2(str(VM_SEQ,6),NIL,.F.,1).and.Fn_ChkLimit(VM_SEQ,NroLimit)
	@16,22 say padr('Valor'       ,16,'.') get VALOR   pict mI102 valid VALOR>=0
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		AddRec(0,{	VM_SEQ,;//..............1
						PARAMETRO->PA_DATA,;//..2
						Valor,;//...............3
						NroCxa,;//..............4
						'Super'})//.............5
		for X:=10 to 2 step -1
			ARRDIG[X,1]:=ARRDIG[X-1,1]
			ARRDIG[X,2]:=ARRDIG[X-1,2]
			ARRDIG[X,3]:=ARRDIG[X-1,3]
		next
		ARRDIG[1,1]:=VM_SEQ
		ARRDIG[1,2]:=Valor
		ARRDIG[1,3]:=RecNo()
		for X:=1 to 10
			@10+X,55 say str(X,2)+":."+str(ARRDIG[X,1],6)+">"+transform(ARRDIG[X,2],mI102) color 'r+/g'
 		next
   else
   	EXIT
   end
end
set key K_F10 to 
setcolor(VM_CORPAD)
dbcloseall()
return NIL

static function AltArrDig()
local GetList:={}
local Y      :=0
@18,22 say padr('Ordem a Alterar',16,'.') get Y pict mI2 valid Y>0.and.Y<11
read
if lastkey()#27.and.Y>0.and.ARRDIG[Y,3]>0
	@18,43 say str(ARRDIG[Y,1],6)
	@19,22 say padr('Novo Valor',16,'.') get ARRDIG[Y,2] pict mI102 valid ARRDIG[Y,2]>=0
	read
	DbGoTo(ARRDIG[Y,3])
	if reclock()
		replace AX_VALOR with ARRDIG[Y,2]
		dbrunlock(recno())
	end
	for X:=1 to 10
		@10+X,55 say str(X,2)+":."+str(ARRDIG[X,1],6)+">"+transform(ARRDIG[X,2],mI102) color 'r+/g'
	next
end
set cursor ON
return NIL

//------------------------------------------------------------
static function Fn_ChkLimit(VM_SEQ,P1)
local RT:=.T.
if VM_SEQ<P1[1].or.VM_SEQ>P1[2]
	pb_msg('Sequencia fora do Limite <'+pb_zer(P1[1],6)+' ate '+pb_zer(P1[2],6)+'> na abertura do caixa.')
	RT:=.F.
end
return RT
