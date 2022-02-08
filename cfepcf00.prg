static PORTA    :=''
static NROCUP   :=0
static TXT_FORMA:=''
static ACK      :=0
static ST1      :=0
static ST2      :=0
static P_ICMS   :={}
static CF_Adv   :=''
#include 'COMMON.CH' 

*---------------------------------------------------------------------------*
function CupomFiscal()
*---------------------------------------------------------------------------*
local RT:=PARAMETRO->PA_EMCUFI
local HAND
local P1:=space(100)
if !RT
	alert(';MODULO CUPOM FISCAL;NAO HABILITADO')
else
	RT:=CFSetPorta()
	if RT
		HAND:=fopen(PORTA,2)
		if ferror()=0
		else
			alert('BEMATECH=Erro de comunicacao com a porta da impressora;CFEPCF00')
			RT:=.F.
		end
	end
end
return RT

*---------------------------------------------------------------------------*
function CFSetPorta()
*---------------------------------------------------------------------------*
local VM_VARAMB
local RT:=.T.
if empty(PORTA)
	VM_VARAMB:=getenv('CFE')
	PORTA    :=padr(substr(VM_VARAMB,at('PORTA:',VM_VARAMB)+6),4)
	if empty(PORTA)
		alert('Parametros incorretos para Impressao Fiscal SET CFE=//PORTA:=COMx')
		RT    :=.F.
	end
end
return RT

*---------------------------------------------------------------------------*
 function CF_LeNumCup()
*---------------------------------------------------------------------------*
return (val(CF_INFO("06")))

*---------------------------------------------------------------------------*
 function CF_ImprAbert() // Abertura Cupom
*---------------------------------------------------------------------------*
local RT:=ImprFisc("00|")
return RT

*---------------------------------------------------------------------------*
 function ImprFisc(P1)
*---------------------------------------------------------------------------*
local HAND
local P2:=' '
local RT:=.T.
ACK     :=0
ST1     :=0
ST2     :=0
if !empty(PORTA)
	HAND:=fopen(PORTA,2)
	if FError()=0
		P1  :=CHR(27)+CHR(251)+P1+CHR(27)
		FWrite(HAND, @P1, len(P1))
		P2:=' ';fread(HAND, @P2, 1);ACK:=asc(P2)
		P2:=' ';fread(HAND, @P2, 1);ST1:=asc(P2)
		P2:=' ';fread(HAND, @P2, 1);ST2:=asc(P2)

		if ACK==6.and.ST2==0
			pb_msg('Impressora OK /\ ACK='+str(ACK,4)+' ST1='+str(ST1,4)+' ST2='+str(ST2,4),0.01)
		else
			alert('CF_DISP_ERRO;ACK='+str(ACK,4)+' ST1='+str(ST1,4)+' ST2='+str(ST2,4)+';'+CF_TRATA_ERRO())
			RT:=.F.
		end
	else
		RT:=.F.
	end
	FClose(HAND)
end
return (RT)

*---------------------------------------------------------------------------*
 function LeImprFis(NTAM)
*---------------------------------------------------------------------------*
local HAND
local RET:=''
local P1 :=''
local X
if !empty(PORTA)
	HAND:=fopen(PORTA,2)
	if ferror()=0
		for X:=1 to NTAM
			P1  :=space(1)
			fread(HAND, @P1, 1)
			RET += P1
		next
		P1:=if(RET==Nil,'',RET)
	else
		alert('Erro abertura - Leitura Impressora')
		ACK:=21
		ST1:=0
		ST2:=1
		P1 :=''
	end
	FClose(HAND)
end
return (P1)

*-------------------------------------------------------------------------------------------*
 function CF_ImprItem(aDET)	//	Impressao da linha = produto
*-------------------------------------------------------------------------------------------*
local RT:=.T.
if aDET[2]>0
	if empty(aDET[18])
		aDET[18]:='II'
	end
	RT:=ImprFisc("09|"+pb_zer(aDET[2],13)  +"|"+;	// Código
		  	         left(aDET[3],29)        +"|"+;	// Descricao
						aDET[18]                +"|"+;	// Aliquota
						pb_zer(aDET[4]*1000,7,0)+"|"+;	// Quantidade
						pb_zer(aDET[5]*100,8,0) +"|"+;	// Valor
						pb_zer(0,4)            +"|")		// %Desconto
						
end
return RT

*---------------------------------------------------------------------------------*
 function CF_FECHCUP(vTOT,vENCFI,vDESCG,vNOMNF,aFAT,vDinh,vTpPag)
*---------------------------------------------------------------------------------*
*------------------> VM_TOT das mercadorias

local TEXTO   :=""
local INICIO  :=.F.

	if !' VISTA '$vNOMNF
		TEXTO:=padr('Cliente : '+vNOMNF,48)
		TEXTO+=padr('Endereco: '+CLIENTE->CL_ENDER,48)
		TEXTO+=padr('Cidade..: '+CLIENTE->CL_CIDAD+'/'+CLIENTE->CL_UF,48)

		if len(trim(CLIENTE->CL_CGC)) < 12
			if left(CLIENTE->CL_CGC,11)#"00000000000"
				TEXTO+=padr('C.P.F...: '+transform(CLIENTE->CL_CGC,masc(17))+' CI:'+CLIENTE->CL_INSCR,48)
			end
		else
			if left(CLIENTE->CL_CGC,14)#"00000000000000"
				TEXTO+=padr('C.N.P.J.: '+transform(CLIENTE->CL_CGC,masc(18))+' IE:'+CLIENTE->CL_INSCR,48)
			end
		end
		TEXTO+=chr(10)+chr(13)
	end
	if vENCFI>0
		ImprFisc("32|a|"+pb_zer(vENCFI*100,14))
		INICIO:=.T.
	end
	if vDESCG>0
		ImprFisc("32|d|"+pb_zer(vDESCG*100,14))
		INICIO:=.T.
	end
	if !INICIO
		ImprFisc("32|a|"+pb_zer(0			 ,14))
	end

	*---------------------------------------------------------------------------------
	for X:=1 to len(aFAT)
		ImprFisc("72|04|"+pb_zer(aFAT[X,3]*100,14)+"|"+Str(X,5)+".Parc.Dt Vencto: "+dtoc(aFAT[X,2])) // Fechamento Cupom a Prazo
		//		DINHEIRO-=P_FAT[X,3]
		//		alert('Parcela '+str(X,2)+' Vlr.'+str(P_FAT[X,3],6,2)+' Dinh:'+str(DINHEIRO,7,2))
	next

	if vDinh > 0
		ImprFisc("72|"+pb_zer(vTpPag,2)+"|"+pb_zer(vDinh*100,14)) // Pagamento dinheiro
	end
	
	ImprFisc("34|"+;
				TEXTO+;
				padr(left(PARAMETRO->PA_OBSCUP ,40),48)+;
				padr(right(PARAMETRO->PA_OBSCUP,40),49)+"|"+CHR(10)+CHR(13)) // fechamento cupom

return NIL

*--------------------------------------------------------------------------*
 function CF_ImprGeral(vTOT,vENCFI,vDESCG,vNOMNF,aFAT,vDinh,vTpPag,aDet)	//	Impressao/Atualizacao da NF					*
*--------------------------------------------------------------------------*
local X      :=0
local CF_DATA:=CF_Info('23')
CF_DATA      :=ctod(substr(CF_DATA,1,2)+'/'+substr(CF_DATA,3,2)+'/'+substr(CF_DATA,5,2)) // data da impressora
if dtos(PARAMETRO->PA_DATA)#dtos(CF_DATA)
		Alert('Data Impressora Fiscal:'+dtoc(CF_DATA)+';'+;
				'Data do Sistema.......:'+dtoc(PARAMETRO->PA_DATA)+;
				';Devem ser Iguais;Ajute Parametros no Micro;'+ProcName())
	Return .F.
end

CF_ImprAbert() // abertura cupom
for X:=1 to len(aDet)
	if aDet[X,2]>0
		CF_ImprItem(aDet[X])
	end
next
CF_FechCup(vTOT,vENCFI,vDESCG,vNOMNF,aFAT,vDinh,vTpPag)
return .T.

*--------------------------------------------------------------------------*
function CF_ProgFormPgto()	//	Programar formas de pagamento
*--------------------------------------------------------------------------*
local RT:=.T.
local ;
TXT_FORMA:= 'Cheque..........|'+;	//02
				'Cartao Credito..|'+;	//03
				'A Prazo.........|'		//04

	ALERT('Programar Formas de Pagamentos;'+;
			'1-Dinheiro......;2-'+;
			substr(TXT_FORMA,01,16)+';3-'+;
			substr(TXT_FORMA,18,16)+';4-'+;
			substr(TXT_FORMA,35,16)+";"+ProcName())
	RT:=ImprFisc("73|"+TXT_FORMA)

return RT

*--------------------------------------------------------------------------*
 function CF_RetAliquota()	//	Programar formas de pagamento
*--------------------------------------------------------------------------*
local Ret
local X
local VPer
if len(P_ICMS)==0
//	ALERT(ProcName()+';Enviar Comando;Retorno de Aliquotas')
	if ImprFisc("26|")
		Ret  :=LeImprFis(66)
		for X:=1 to 16
			vPer:=val(substr(Ret,X*4-1,4))/100
			aadd(P_ICMS,vPer)
		next
	end
end
return P_ICMS

*--------------------------------------------------------------------------*
function CF_Info(vPA)
*--------------------------------------------------------------------------*
local xLen:= 10
ACK       :=  0
ST1       :=  0
ST2       :=  0
Ret       := ""

	ImprFisc("35|"+vPA)
	Do Case
		Case vPA = "00"	//	Numero de Serie
			xLen:=15
		Case vPA = "01"	// Versao do Firm Ware
			xLen:=4
		Case vPA = "02"	// CGC/IE
			xLen:=33
		Case vPA = "03"	// Grande Total
			xLen:=18
		Case vPA = "04"	// Cancelamentos
			xLen:=14
		Case vPA = "05"	// Descontos
			xLen:=14
		Case vPA = "06"	// Contador Sequencial
			xLen:=6
		Case vPA = "14"	// Nr Caixa
			xLen:=4
		Case vPA = "17"	// FlagFiscal
			XLen:=1
		Case vPA = "23"	// Data + Hora
			xLen:=12
		Case vPA = "26"	// Data ultima Reducao
			xLen:=12
		Case vPA = "27"	// Data do Movimento
			xLen:=6

	EndCase
	Ret:=LeImprFis(xLen)

return Ret

*--------------------------------------------------------------------------*
 function CF_RES_ERRO()
*--------------------------------------------------------------------------*
if if(pb_sn('Enviar comando de Reset;'+ProcName()),abre({'C->PARAMETRO'}),.F.)
	if CupomFiscal()
		ImprFisc("70|")
	end
end
Close
Return Nil


*--------------------------------------------------------------------------*
 static function CF_TRATA_ERRO()
*--------------------------------------------------------------------------*
local RT:=''
CF_Adv  :=''
* --- Verificando o ST1 ---*
IF ST1 >= 128
	RT += "Fim de papel;"
	ST1+= -128
	CF_Adv:='Pouco Papel'
End

If ST1 >= 64
	RT += "Pouco papel;"
	ST1+= -64
	CF_Adv:='Pouco Papel'
End

If ST1 >= 32
	RT += "Erro no relogio;"
	ST1+= -32
End

If ST1 >= 16
	RT += "Impressora em erro;"
	ST1+= -16
End

If ST1 >= 8
	RT += "Primeiro dado de CMD nao foi ESC (1Bh);"
	ST1+= -8
End

If ST1 >= 4
	RT += "Comando inexistente;"
	ST1+= -4
End

If ST1 >= 2
	RT += "Cupom aberto;"
	ST1+= -2
End

If ST1 >= 1
	RT += "Nro parametros <CMD> invalido;"
End

* --- Verificando o ST2 ---*
IF ST2 >= 128
	RT += "Tipo parametro <CMD> invalido;"
	ST2+= -128
End

If ST2 >= 64
	RT += "Memoria fiscal lotada;"
	ST2+= -64
End

If ST2 >= 32
	RT += "Erro na Memoria RAM CMOS nao volatil;"
	ST2+= -32
End

If ST2 >= 16
	RT += "Aliquota nao programada;"
	ST2+= -16
End

If ST2 >= 8
	RT += "Capacidade de aliquotas programaveis lotada;"
	ST2+= -8
End

If ST2 >= 4
	RT += "Cancelamento nao permitido;"
	ST2+= -4
End

If ST2 >= 2
	RT += "CNPJ/IE do proprietario nao programados;"
	ST2+= -2
End

If ST2 >= 1
	RT += 'Comando nao executado;'
	*----------------------------------Porque?
	RT += '---------------------;'+CF_VerFlagFisc()
	*-----------------------------------------
End
if empty(RT)
	RT:='.......'
end
Return RT

*--------------------------------------------------------------------------*
static function CF_VerFlagFisc()
*--------------------------------------------------------------------------*
local RT :=''
local Ret:=CF_Info("17") // Flags Fiscais
//alert(ProcName()+';Enviando CMD FlagFiscais;'+str(asc(RET)))
Ret:=asc(RET)
IF Ret >= 128
	RT += "Memoria Fiscal sem espaco.;"// 7-
	Ret+= - 128
End
If Ret >= 64
	RT += "" // 6-Erro Não existe
	Ret+= - 64
End
If Ret >= 32
	RT += "Permite cancelar Cupom Fiscal;" // 5
	Ret+= - 32
End
If Ret >= 16
	RT += "" // 4-Erro Não existe
	Ret+= - 16
End
If Ret >= 8
	RT += "Ja houve Reducao Z no dia;" // 3
	Ret+= - 8
End
If Ret >= 4
	RT += "Horario de Verao OK;" // 2
	Ret+= - 4
End
If Ret >= 2
	RT += "Fechamento Forma Pgto iniciado;" // 1
	Ret+= - 2
End
If Ret >= 1
	RT += "Cupom Fiscal aberto;"
End

return RT


function CF_Advert()
return (CF_Adv)