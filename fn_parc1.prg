#include 'RCB.CH'
static P2   := 0	// %DES
static P3   := 0	// VDES -
static P4   := 0	// NR PARC
static P5   := 0	// TOTAL LIQ para parcelamento
static P6   := 0	// + Vlr Encargos
static P7   := 0	// Vlr Entrada
static P8   := 0	// % Encargos
static P9   := 0	// Valor 
static FAT  := {}
static VLRT := 0
static VPARC:= 0
static CLI  :=1
static NOMNF:=''
static OBS  :=''
static TpFun

*------------------------------------------------------> Tipo de Fechamento 0
 function Fechar_0(P1,pTIPO,pCli,pNomeCli)
*------------------------------------------------------> Tipo de Fechamento 0
local vSoma
local SN:='N'
P2    := 0
P3    := 0	// Vlr Desc
P4    := 0	// NR PARC
P5    := 0	// TOTAL LIQ
P6    := 0	// Vlr de Encargo Financeiro
P7    := 0	// Entrada / Dinheiro
P8    := 0	// % Juros 
P1    := trunca(P1,2)
P9    := P1
FAT   := {}
VPARC := 0
VLRT  := 0
CLI   := 1
NOMNF := space(40)
OBS   := space(80)
TpFun := 0
AVista:=.F.
if PARAMETRO->PA_EDESCUP
	P8 := PARAMETRO->PA_PJUROS
end

pb_box(16,23,,,,'Tipo Fechamento = 0')
while .T.
	AVista:=.F.
	if pTIPO=='V'
		CLI  := 1
		NOMNF:=space(40)
		@17,25 say 'Cod.Cliente.:'  get CLI   pict mI5  valid (fn_codigo(@CLI,{'CLIENTE',{||CLIENTE->(dbseek(str(CLI,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})) when MostraVlrs(10).and.pb_msg('1-Cliente a Vista ou escolha outro')
		@17,45                      get NOMNF pict mUUU+'S28' when (NOMNF:=CLIENTE->CL_RAZAO)>=''.and.CLI==1
	else
		CLI  :=pCli
		NOMNF:=pNomeCli
		@17,25 say 'Cod.Cliente.: '+transform(CLI,mI5)+'-'+NOMNF
	end
	@18,25 say "Acres.Finac.:"   get P6    pict mI122 valid P6>=0              when MostraVlrs(12).and.pb_msg('Informe o vlr de Acrescimo Financeiro')
	@19,25 say "Vlr.Desconto:"   get P3    pict mI122 valid P3>=0.and.P3<=P1   when MostraVlrs(13).and.pb_msg('Informe o vlr para Desconto')
	@20,25 say "Vlr.Recebido:"   get P7    pict mI122 valid P7>=0              when MostraVlrs(14).and.pb_msg('Informe o vlr recebido em Dinheiro/Cheque/Cartao')
	@21,25 say "Parcelas....:"   get P4    pict mI2   valid P4>=0					when MostraVlrs(15).and.pb_msg('Infome se existe parcelamento')
	@21,55 say "Imprime Carne?"  get SN    pict mUUU  valid SN$'SN'            when MostraVlrs(16).and.pb_msg('Deseja ao final imprimir o Carne de parcelas ? <S>im   <N>ao')
	read
	if lastkey()#K_ESC
		if P4>0
			FAT:=CriaParc(VlrLiqParc)
			EditParcel(VlrLiqParc) // dividir as parcelas e editar
		end
		vSoma:=P7+P3
		if len(FAT)>0
			aeval(FAT,{|DET|vSoma+=DET[3]})
		end
		if str(vSoma,15,2)>=str(P1,15,2)
			exit
		else
			alert('Avaliar fechamento;Soma Valores:'+Str(vSoma,9,2)+';Venda:'+str(P1,9,2))
		end
	end
end
pb_msg('Continuar Venda...')
return ({P1,P2,P3,P4,P5,P6,P7,P8,P9,VLRT,VPARC,FAT,CLI,NOMNF,SN,OBS})

*---------------------------------------------------------------------------*
 function Fechar_1(P1,pTIPO,pCli,pNomeCli)
*                     pTipo=V = Venda CUPOM
*                     pTIPO=P = Venda Pedido
*                 P1=Valor Compra
*---------------------------------------------------------------------------*
local vSoma
local SN:='N'
P1      := trunca(P1,2)
P2      := 0
P3      := 0
P4      := 0	// NR PARC
P5      := 0	// TOTAL LIQ para parcelamento ANTES DO % ACRESCIMO
P6      := 0	// Encargos
P7      := 0	// Entrada
P8      := 0	// % Desconto 
P9      := P1
FAT     := {}
VPARC   := 0
VLRT    := 0
TpFun   := 1
OBS     := space(80)
pb_box(10,23,,,,'Tipo Fechamento = 1')
while .T.
	if pTIPO=='V'
		CLI  := 1
		NOMNF:=space(40)
		@11,25 say 'Cod.Cliente.:'  get CLI   pict mI5  valid (fn_codigo(@CLI,{'CLIENTE',{||CLIENTE->(dbseek(str(CLI,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})) when MostraVlrs(1).and.pb_msg('1-Cliente a Vista ou escolha outro')
		@11,45                      get NOMNF pict mUUU+'S28' when (NOMNF:=CLIENTE->CL_RAZAO)>=''.and.CLI==1
	else
		CLI  :=pCli
		NOMNF:=pNomeCli
		@11,25 say 'Cod.Cliente.: '+transform(CLI,mI5)+'-'+NOMNF
	end
		@12,25 say 'Sub-Total...:'  get P9    pict mI92                     color 'W+/GR'               when .F.
		@13,25 say '(%)Desconto.:'  get P2    pict mI92 valid P2<=100   when MostraVlrs(2).and.pb_msg('% de desconto para Venda')
		@14,25 say '(-)Desconto.:'  get P3    pict mI92 valid P3>=0  .and.P3<=P9                        when MostraVlrs(3).and.pb_msg('Valor de desconto para esta Compra')
		@15,25 say 'Vlr Entrada.:'  get P7    pict mI92 valid ChkVlrs(7)                                when MostraVlrs(7).and.pb_msg('Valor de Entrada/Pago para esta Compra')

		@17,25 say 'Nr.Parcelas.:'  get P4    pict mI2  valid ChkVlrs(4)                                when MostraVlrs(4).and.pb_msg('Numero de Parcelas da Compra')

		@18,25 say 'Imprim.Carne: ' get SN    pict mUUU valid SN$'SN'                                   when P4>0.and.pb_msg('Deseja imprimir Carne de Pagamentos ao final desta venda')
		@19,25 say '%Acres Finac:'  get P8    pict mI92 valid MostraVlrs(9)                             when P4>0.and.MostraVlrs(8).and.pb_msg('% de encargos para parcelamento ao mes')
	read
	if lastkey()#K_ESC
		if P4>0
			EditParcel(P5)
		end
		vSoma:=P7+P3
		if len(FAT)>0
			aeval(FAT,{|DET|vSoma+=DET[3]})
		end
		if str(vSoma,15,2)>=str(P1,15,2)
			exit
		else
			alert('Avaliar fechamento;Soma Valores:'+Str(vSoma,10,3)+';Venda:'+str(P1,10,3))
		end
	end
end
pb_msg('Continuar Venda...')
return ({P1,P2,P3,P4,P5,P6,P7,P8,P9,VLRT,VPARC,FAT,CLI,NOMNF,SN,OBS})
//........1..2..3..4..5..6..7..8..9...10....11..12..13....14,15,,16

*-------------------------------------------------------------------------
 static function ChkVlrs(pX)
*-------------------------------------------------------------------------
local RT:=.F.
if pX==4
	if P4<=0
		alert('Quantidade de Parcelas deve ser Maior que Zero')
	else
		RT:=.T.
	end
end
if pX==7
	P5:=P9+P6-P3 // LIQUIDO
	if P7>=0
		if str(P7,15,2)>=str(P5,15,2) // valor igual OU MAIOR
			RT:=.T.
		else
			if ' VISTA '$NOMNF
				alert('Para vendas a vista o pagamento deve ser integral.')
			else
				RT:=.T.
				P4:= 1
			end
		end
	else
		alert('Valor deve ser Maior ou Igual a Zero')
	end
end
return RT

*-------------------------------------------------------------------------
 static function MostraVlrs(pX)
*-------------------------------------------------------------------------
local RT:=.T.
P5:=P9+P6-P3-P7
if pX<10 // só para tipo = 1
	if pX==2 // digitar % desconto ?
		RT:=PARAMETRO->PA_EDESCUP
		P3:=0
		P4:=0
		p6:=0
		P7:=0
		P8:=0
	end
	if pX==3 // digirar vlr desconto ?
		RT:=PARAMETRO->PA_EDESCUP
		P3:=trunca(P9*P2/100,2)
		P7:=0
	end
	if pX==4 // Será solicitado Nr Parcelas ?
		P4:=0
		RT:=.F.
		if P5>0.and.Str(P5,15,2)>Str(0,15,2) // FALTA ALOCAR ?
			if !' VISTA '$NOMNF
				RT:=.T.
			end
		end
	end
	if pX==7 // Digita Vlr Entrada ?
		p6:=0
		P7:=P9+P6-P3
		P8:=0
	end

	if pX==8 // Digita Acresc Financ ?
		P8:=0
		if PARAMETRO->PA_EFINCUP // sim
			if ' VISTA '$NOMNF // é a vista 
				RT:=.F.
			else//...................nao
				P8:= PARAMETRO->PA_PJUROS
				if str(P3,15,2)>str(15,2,0)
					Alert('Nao pode haver Vlr de Desconto;e Vlr acrescimo ao mesmo tempo')
					P8:= 0
				end
			end
		end
	end

	if pX==9
		if P8>=0
			CalculaParc()
		else
			
		end
	end
	@16,25 say 'Total(1)....: '+transform(P5,mI92) color 'W+/GR'
	@20,25 say 'Encargos....: '+transform(P6,mI92)
	@21,25 say 'Total.......: '+transform(P5+P6,mI92)    color 'W+/GR'

else
	if pX==12
		RT:=PARAMETRO->PA_EFINCUP.and.!' VISTA '$NOMNF // digita encargos e não é a vista
		P6:=0 // zerar Encargos
	end
	if pX==13
		RT:=str(P6,15,2)==str(0,15,2).and.PARAMETRO->PA_EDESCUP // digita desconto e encargo # 0
		P3:=0 // zerar desconto
	end
	if pX==14
		MOSTRA_NUM(1,str(P9+P6-P3,7,2)) // ?
	end
	if pX==15
		RT:=str(P5,15,2)>str(0,15,2).and.!' VISTA '$NOMNF // TEM VALOR A SER PARCELADO E NÃO É A VISTA
	end
	if pX==16
		RT:=(P4>0) // tem valor a ser parcelado - então pergunta se irá imprimir cupom
	end
end

return RT

*-------------------------------------------------------------------------
static function CalculaParc()
*-------------------------------------------------------------------------
local X :=(P4-1)+if(PARAMETRO->PA_1PGTO>27,+1,+0) // numero de meses
local RT:=.T.
	VLRT :=Trunca((P5)+((P5)*(P8/100)*X),2)
	VPARC:=Trunca(pb_divzero(VLRT,P4),2)
	if str(P8,15,2)>str(0,15,2)
		VLRT :=trunca(VPARC*P4,2)
	end
	P6   := max(VLRT - (P5),0) // Valor Enc Financ
	FAT  := CriaParc(VLRT)
return RT

*-------------------------------------------------------------Divide em parcelas
 static function CriaParc(VlrLiqParc)
*-------------------------------------------------------------------------------
local DATAI :=date()+PARAMETRO->PA_1PGTO
local FATX  := {}
local Soma  := 0
VPARC       := Trunca(pb_divzero(VlrLiqParc,P4),2)
for X:=1 to P4
	Soma+=VPARC
	aadd(FATX,{X,DATAI,VPARC})
	if PARAMETRO->PA_TPPRZ=='D'
		DATAI:=AddMonth(DATAI,1)
	else
		DATAI+=PARAMETRO->PA_OPGTO
	end
next
if str(Soma,15,2)#str(VlrLiqParc,15,2)
	FATX[len(FATX),3]+=(VlrLiqParc-Soma)
end
VLRT:=VlrLiqParc
return FATX

*-------------------------------------------------------------------------
static function EditParcel(VlrLiqParc)
*-------------------------------------------------------------------------
local GetList:={}
local _DATA
local _VLR
local OPC
While .T.
	_VLR:=0.00
	aeval(FAT,{|DET|_VLR+=DET[3]})

	pb_msg('Selecione uma sequencia ou <esc> para sair.')
	@23,54 say padr(' Diferenca',15,'.')+transform(_VLR-VLRT,mI92)
	OPC:=Abrowse(12,54,22,79,FAT,;
					{'SQ','DtVenc','Vlr Parc'},;
					{   2,      10,       10 },;
					{ mI2,     mDT,     mI92 },,' Parcelamento:'+transform(VLRT,mI92))

	if OPC > 0
		_DATA:=FAT[OPC,2]
		_VLR :=FAT[OPC,3]
		@row(),58 get _DATA pict mDT                   when pb_msg('Data de Vencimento desta Parcela')
		if Len(FAT)>1
			@row(),69 get _VLR  pict mI92 valid _VLR>0  when pb_msg('Valor desta Parcela')
		end
		read
		if lastkey()#K_ESC
			FAT[OPC,2]:=_DATA
			FAT[OPC,3]:=_VLR
		end
	else
		if str(_VLR,15,2)#str(VLRT,15,2)
			alert('O valor da soma das parcelas ='+str(_VLR,10,2)+';nao fecha com o total parcelado='+str(VLRT,10,2)+';Favor Corrigir')
		else
			exit
		end
	end
end
return .T.
