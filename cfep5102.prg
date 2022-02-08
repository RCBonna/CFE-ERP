 static aVariav := {0,0}
 //.................1.2.
*---------------------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate nX1        => aVariav\[  2 \]

static EXCLUI:=.F.
*-------------------------------------------------------------------------
  function CFEP5102() // Alterar Pedidos
*-------------------------------------------------------------------------
#include 'RCB.CH'

local Z         :=0
local TF        :=savescreen()

for nX :=1 to fcount()
	X1 :="VM"+substr(fieldname(nX),3)
	&X1:=&(fieldname(nX))
next

VM_FLADTO:=if(VM_FLADTO,"S","N")

private FLAG_A  :={.F.,.F.,.F.}
private VM_ICMS :={} // %ICMS,BASE
private VM_ICMT :={0,0}	// Valor total ICMS, Base Total ICMS

pb_tela()
pb_lin4('Alteracao do Pedido '+pb_zer(PC_PEDID,6),ProcName())

if PC_FLAG
	alert('Pedido ja foi transformado em Nota Fiscal')
	return NIL
end
if PC_FLSVC
	alert('Pedido tipo Servico;Entrar na rotina de servico')
	return NIL
end

private VM_ULTPD	:=PC_PEDID
private VM_ULTDP	:=PC_NRDPL
private VM_NSU		:=PC_NSU
private VM_DTEMI	:=PC_DTEMI
private VM_CODOP	:=PC_CODOP
private VM_SERIE	:=PC_SERIE
private VM_PARCE	:=PC_FATUR
private VM_CLI		:=PC_CODCL
private VM_VEND	:=PC_VEND
private VM_TOT		:=PC_TOTAL+PC_DESC
private VM_DESCIT	:=PC_DESCIT
private VM_OBS		:=PC_OBSER
private VM_CODFC	:=PC_CODFC
private VM_SVC		:=PC_DESVC		//Descricao para servicos
private NUM_CXA	:=PC_NRCXA
private VM_LOTE	:=PC_LOTE
private VM_TPTRAN	:=PC_TPTRAN
private VM_DESCG	:=PC_DESC
private VM_FAT		:=fn_retparc(VM_ULTPD,PEDCAB->PC_FATUR,VM_ULTDP)
//.....................................DEVOLUÇÃO
private VM_DEVNFE	:=PC_NFEDEV //........Nr Chave NFE
private VM_DEVNNF	:=0 //................Nr NF
private VM_DEVSER	:=space(003) //.......Serie
private VM_DEVDTE	:=ctod('')//..........DT Emissão
//............................................................

NATOP->(dbseek(str(VM_CODOP,7)))
CTRNF->(dbseek(VM_SERIE))
VM_DET   :=fn_rtprdped(VM_ULTPD)

while .T.
	OPC:=alert('Alteracao do pedido '+pb_zer(VM_ULTPD,6)+;
			';de '+pb_zer(PC_CODCL,5)+chr(45)+trim(left(CLIENTE->CL_RAZAO,30)),;
			{'Cabecalho','Produtos','Rodape/Fim'})
	if OPC==1
		CFEP5102A('ALTERA')//..........CABECALHO
	elseif OPC==2
		CFEP5102B('ALTERA')//..........PRODUTOS
	elseif OPC==3
		CFEP5102C('ALTERA')//..........RODAPE
	else
		if FLAG_A[1].or.FLAG_A[2].or.FLAG_A[3]
			VMTOT:=0 // Somar Valor NF
			VMFAT:=0	// Somar Valor Duplicata
			aeval(VM_DET,{|DET|VMTOT+=Trunca(DET[4]*DET[5],2)-DET[6]-DET[30]+DET[7]})
			aeval(VM_FAT,{|DET|VMFAT+=DET[3]})
			
			if str(VMTOT,15,2)#str(VMFAT,15,2).and.PEDCAB->PC_FATUR>0
				if pb_sn('Valor dos Itens x Parcelamento nao Fecham.;Valor Itens:'+Transform(VMTOT,masc(25))+;
																					';Valor Parc.:'+Transform(VMFAT,masc(25))+;
																					';Nr.Parcelas:'+Str(PEDCAB->PC_FATUR,2)+;
																					';Cancelar?')
					keyboard 'N'
				else
					loop
				end
			end
			if pb_sn(ProcName()+';Gravar Alteracoes do Pedido?')
				FATPGRPE('Alterar','Produto') //.......................Atualizar Pedidos
			end
		end
		exit
	end
	restscreen(,,,,TF)
end
return NIL

//----------------------------------ALTERA CABECALHO--------------------------/
function CFEP5102A()
*-----------------------------------------------------------------------------*
VM_DTSAI:=if(Empty(VM_DTSAI),date(),VM_DTSAI)
pb_box(5,0,22,79,,'Altera Cabecalho do pedido')
@07,03 say 'Pedido...: '+pb_zer(VM_ULTPD,6)
@07,25 say 'Serie:'			get VM_SERIE pict mUUU valid VM_SERIE==SCOLD.or.fn_codigo(@VM_SERIE,{'CTRNF',{||CTRNF->(dbseek(VM_SERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}}).and.CTRNF->NF_NRLIN>0 color 'R/W'
@08,03 say 'Cliente..:'		get VM_CLI   pict mI5  valid fn_codigo(@VM_CLI,  {'CLIENTE', {||CLIENTE->(dbseek(str(VM_CLI,5)))},  {||CFEP3100T(.T.)},{2,1,8,7}})
@09,03 say 'Vendedor.:  '+ str(VM_VEND,3)+'-'+PR('VENDEDOR',str(VM_VEND,3),2,.F.)
@11,03 say 'Nat.Oper.:'		get VM_CODOP pict mNAT valid fn_codigo(@VM_CODOP,{'NATOP',   {||NATOP->(dbseek(str(VM_CODOP,7)))},  {||CFEPNATT(.T.)},{2,1,3}}).and.NATOP->NO_TIPO$'SO'.and.confNatOp(CLIENTE->CL_UF,'CLIENTE')
@12,03 say 'DtEmissao:' 	get VM_DTEMI pict mDT  valid VM_DTEMI<=PARAMETRO->PA_DATA
@13,03 say 'DtSaida..:'		get VM_DTSAI pict mDT  valid VM_DTSAI>=VM_DTEMI
read
if lastkey()#K_ESC
	FLAG_A[1]:=.T.
end
return NIL

*----------------------------------ALTERA PRODUTOS--------------------------
function CFEP5102B()
*---------------------------------------------------------------------------
local X
local Y
local Z
pb_box(5,0,22,79,,'Altera Produtos do pedido')
@16,01 to 16,78
if NATOP->NO_TIPO=='S' // Venda de Produtos
	while .T.
		EXCLUI:=.F.
		set key K_F10 to Elimina_Item()
		pb_msg('Selecione um item e press <Enter> ou <ESC> para sair <F10> Exclui item .',NIL,.F.)
		X:=abrowse(6,1,21,78,;
						VM_DET,;
					{    'Sq', 'Prod.','Descricao','Qtdade','VlrVendaUnit','Vlr Desconto','EncFin',    'CT',   '%ICMS', 'Unid','%Tribut'},;
					{       2,     L_P,         20,      10,            13,            12,       6,       2,         5,      6,       6 },;
					{     mI2,masc(21),       mXXX, masc(6),  masc(25)+'9',      masc(25), masc(20),    mI2,      mI62,   mUUU,    mI62 })

		set key K_F10 to
		if X>0
			if Exclui
				Z:=0
				aeval(VM_DET,{|DET|Z+=if(DET[2]>0,1,0)})
				if Z==1
					alert('Item nao pode ser eliminado;pois o pedido nao pode ficar sem item')
					loop
				end
				for Y:=X to len(VM_DET)-1
					for Z:=2 to len(VM_DET[Y])
						VM_DET[Y,Z]:=VM_DET[X+1,Z]
					next
				next
				VM_DET[Y]:=LinDetProd(Y)
				keyboard chr(K_ESC)
			end
			VM_ICMS:=CFEP5110(VM_DET,X,.T.,@VM_TOT,{NATOP->NO_CODIG})	// editar * retorna ICMS *
																							// edita se produto novo
			if lastkey()#K_ESC
				FLAG_A[3]:=.T.
			end
			keyboard replicate(chr(K_DOWN),X)
		else
			exit
		end
	end
else
	// VENDA DE SERVICOS
end
return NIL


*----------------------------------ALTERA RODAPE--------------------------/
function CFEP5102C(pTipoMov)
*-------------------------------------------------------------------------/
FinalPedido(pTipoMov,'Produto')
return NIL

*-------------------------------------------------------------------------/
static function Elimina_Item()
*-------------------------------------------------------------------------/
EXCLUI:=.T.
keyboard chr(K_ENTER)
return NIL
//---------------------------------------------------------------EOF-------
