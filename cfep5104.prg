*-----------------------------------------------------------------------------*
 static aVariav := {0, 0,  0,  0}
 //.................1..2...3...4...5..6...7...8...9, 10, 11, 12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate nY         => aVariav\[  2 \]
#xtranslate nContaD    => aVariav\[  3 \]
#xtranslate nContaC    => aVariav\[  4 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
 function CFEP5104(FLAG) // MOSTRA
*-----------------------------------------------------------------------------*

local VM_ULTPD:=PC_PEDID
local VM_ULTDP:=PC_PEDID

for nX :=1 to fcount()
	X1 :="VM"+substr(fieldname(nX),3)
	&X1:=&(fieldname(nX))
next
VM_FLADTO:=if(VM_FLADTO,"S","N")

NATOP->(dbseek(str(PEDCAB->PC_CODOP,7)))
CTRNF->(dbseek(PEDCAB->PC_SERIE))

		VM_DET  :={}
      VM_ICMS :={}
      VM_ICMT :={0,0}	// Valor total ICMS, Base Total ICMS
      FLAG    :=if(FLAG==NIL,.T.,FLAG)
		VM_FAT  :=fn_retparc(VM_ULTPD,PEDCAB->PC_FATUR,VM_ULTDP)

	setcolor(VM_CORPAD)
	scroll(6,1,21,78,0)
	setcolor('W+/B,N/W,,,W+/B')
	VM_DET :=fn_rtprdped(VM_ULTPD)	//............Retorna todos dos itens da nota num vetor.

	I_TRANS:=CFEPTRANL(NATOP->NO_TIPO#'O') //......Se for serviço deve enviar Falso para função retornar brancos.
	VM_OBSP:=DevObsPr()
	VM_ICMS:=FN_ICMSC(VM_DET)

@06,01 say 'Pedido...: '+pb_zer(PC_PEDID,6)
@06,19 say dtoc(PC_DTEMI)
@06,30 say 'Cliente..: '+pb_zer(PC_CODCL,5)+'-'+trim(CLIENTE->CL_RAZAO)
@07,01 say 'Faturamento '+if(PC_FATUR=0,'a vista',str(PC_FATUR,1)+' parcelas')
if PARAMETRO->PA_VENDED==chr(255)+chr(25).and.!PEDCAB->PC_FLSVC
	VM_VEND:=PC_VEND
	@07,33 say 'Vendedor: '+pb_zer(VM_VEND,3)+'-'+PR('VENDEDOR',str(VM_VEND,3),2,.F.)
end
@17,01 say 'TOTAL do Pedido.....: '+transform(PEDCAB->PC_TOTAL+PEDCAB->PC_DESC,masc(2))
@17,50 say 'Descontos.: '+transform(PEDCAB->PC_DESC-PEDCAB->PC_DESCIT, masc(2))
@18,01 say 'TOTAL Liquido.......: '+transform(PEDCAB->PC_TOTAL,masc(2))
@19,01 say left(PEDCAB->PC_OBSER,37)      color 'R/W'
@20,01 say substr(PEDCAB->PC_OBSER,38,37) color 'R/W'
@21,01 say substr(PEDCAB->PC_OBSER,75)    color 'R/W'

NATOP->(dbseek(str(PEDCAB->PC_CODOP,7)))
@21,59 say 'NatOper:'+transform(PC_CODOP,mNAT)+chr(45)+NATOP->NO_DESCR
pb_msg('Press <ENTER> para continuar.',NIL,.F.)
if len(VM_DET)>0
	if !PEDCAB->PC_FLSVC
		Abrowse(8,1,16,78,;
						VM_DET,;
						{'Sq',     'Prod.','Descricao','Qtdade','VlrVendaUnit','Desconto','Enc Financ',   'CT',   '%ICMS', 'Unid','%Tribut'},;
						{ 2,           L_P,         20,      12,           13,        15,          15,      2,         5,      6,       6 },;
						{masc(11),masc(21),       mXXX,   mI123, masc(45)+'9',  masc(25),    masc(25),masc(11), masc(14),   mXXX, masc(20)})
	else
		Abrowse(8,1,16,78,;
						VM_DET,;
					{    'Sq', 'CodSVC','Descricao','Qtdade','Vlr Venda T','Vlr Desconto','EncFin',    'CT',   '%ICMS', 'Unid','%Tribut'},;
					{       2,       6,         20,      10,           12,            12,       6,       2,         5,      6,       6 },;
					{     mI2,     mI6,       mXXX, masc(6),     masc(25),      masc(25), masc(20),masc(11), masc(14),   mUUU,masc(20)})

	end
else
	alert('Advertencia;Nao encontrado itens para este Pedido')
end
if if(lastkey()#K_ESC,FLAG.and.pb_sn('Imprimir o pedido ?'),.F.)
	if PARAMETRO->PA_TIPPD==2
			CFEPVEBC(VM_FAT)
	else
		if pb_ligaimp(C15CPP)
			ImpresPed()
			pb_deslimp(C15CPP)
		end
	end
	if PEDCAB->PC_SERIE=='ADT'
		nConta:=DigContas()
		fn_atdiario(PEDCAB->PC_DTEMI,;
						nConta[1],;	// CTA Banco
						DEB*(PEDCAB->PC_TOTAL-PEDCAB->PC_DESC-PEDCAB->PC_DESCIT),;
						'Adto Recebido de '+CLIENTE->CL_RAZAO,;
						'FAT/'+pb_zer(PEDCAB->PC_PEDID,6)+':'+PEDCAB->PC_SERIE)

		fn_atdiario(PEDCAB->PC_DTEMI,;
						nConta[2],;	// CTA Adiantamento
						CRE*(PEDCAB->PC_TOTAL-PEDCAB->PC_DESC-PEDCAB->PC_DESCIT),;
						'Recebido de '+CLIENTE->CL_RAZAO,;
						'FAT/'+pb_zer(PEDCAB->PC_PEDID,6)+':'+PEDCAB->PC_SERIE)

		Grav_Bco(nConta[3],;
					PEDCAB->PC_DTEMI,;
					PEDCAB->PC_PEDID,;
					'REC '+CLIENTE->CL_RAZAO,;
					+(PEDCAB->PC_TOTAL-PEDCAB->PC_DESC-PEDCAB->PC_DESCIT),;
					'FT')
					
		select HISCLI
		while !AddRec(30);end
		replace  HC_CODCL with PEDCAB->PC_CODCL,;
					HC_DUPLI with PEDCAB->PC_PEDID*100,;
					HC_DTEMI with PEDCAB->PC_DTEMI,;
					HC_DTVEN with PEDCAB->PC_DTEMI,;
					HC_DTPGT with PEDCAB->PC_DTEMI,;
					HC_VLRDP with (PEDCAB->PC_TOTAL-PEDCAB->PC_DESC-PEDCAB->PC_DESCIT),;
					HC_VLRPG with (PEDCAB->PC_TOTAL-PEDCAB->PC_DESC-PEDCAB->PC_DESCIT),;
					HC_VLRMO with pb_divzero((PEDCAB->PC_TOTAL-PEDCAB->PC_DESC-PEDCAB->PC_DESCIT),PARAMETRO->PA_VALOR),;
					HC_CXACG with nConta[4],;
					HC_NRNF  with PEDCAB->PC_PEDID,;
					HC_SERIE with PEDCAB->PC_SERIE
		select PEDCAB
	end
end

/*
if !FLAG.and.!pb_sn('Data de Emiss„o '+dtoc(VM_DTEMI)+' Correta ?')
	pb_msg('Altere a Data Emiss„o se necessario.',nil,.F.)
	@06,19 get VM_DTEMI pict mDT valid VM_DTEMI<=PARAMETRO->PA_DATA
	if NATOP->NO_FLTRAN=='S'
		@07,21 say 'Lote:'      get VM_LOTE   pict mI4
		@08,21 say 'Tp Transf:' get VM_TPTRAN pict mI1
	end
	read
	if lastkey()#K_ESC
		while !reclock(recno());end
		replace PEDCAB->PC_DTEMI with VM_DTEMI //----------------> ATUALIZA DATA
		dbrunlock(recno())
	end
end
*/
select PEDCAB
return NIL

*-------------------------------------------------------------------
  static function ImpresPed()
*-------------------------------------------------------------------
local VM_LAR:=80
local ORD
local X
for X:=1 to min(PARAMETRO->PA_VZIPD,1)
	if PARAMETRO->PA_PEDCAB#'N'
		??VM_EMPR
		? PARAMETRO->PA_ENDER
		? transform(PARAMETRO->PA_CEP,masc(10))+' '+PARAMETRO->PA_CIDAD+' '+PARAMETRO->PA_UF
		? 'Fone : '+PARAMETRO->PA_FONE+space(5)+'Fax : '+PARAMETRO->PA_FAX
		?
		? replicate('-',VM_LAR)
		? padc('Orcamento Nr: '+pb_zer(PEDCAB->PC_PEDID,6),VM_LAR,'.')
		? replicate('-',VM_LAR)
	else
		? replicate('-',VM_LAR)
		? padc('O R C A M E N T O',VM_LAR)
		? replicate('-',VM_LAR)
	end

	?
	? padr('Cliente' ,15,'.')+': '+pb_zer(PEDCAB->PC_CODCL,6)+'-'+CLIENTE->CL_RAZAO
	? padr('Endereco',15,'.')+': '+CLIENTE->CL_ENDER+space(1)+I15CPP+left(CLIENTE->CL_BAIRRO,26)+C15CPP
	? padr('Cidade',  15,'.')+': '+CLIENTE->CL_CIDAD+' CEP : '+CLIENTE->CL_CEP+'-'+CLIENTE->CL_UF
	if len(trim(CLIENTE->CL_CGC))>11
		? padr('C.N.P.J.',   15,'.')+': '+transform(CLIENTE->CL_CGC,masc(18))
		??space(5)+'Inscricao Estad: '
	else
		? padr('C.P.F',   15,'.')+': '+transform(CLIENTE->CL_CGC,masc(17))
		??' RG/Identidade : '
	end
	??CLIENTE->CL_INSCR
	?
	? padr('Dt Emissao:',15,'.')+': '+dtoc(PC_DTEMI)+space(2)+time()+space(2)
	??'Cod. Operacao :'+str(PC_CODOP/100,5)+chr(45)+NATOP->NO_DESCR
	if PC_VEND>0
		? padr('Vendedor',15,'.')+': '+pb_zer(PC_VEND,3)+chr(45)
		??VENDEDOR->VE_NOME
	end
	?
	if PEDCAB->PC_FATUR>0
		? padr('Numero de parcelas',18)+': '+pb_zer(PEDCAB->PC_FATUR,2)
		if PEDCAB->PC_VLRENT>0
			??space(10)+'Vlr Entrada : '+transform(PEDCAB->PC_VLRENT,masc(2))
		end
		?space(10)+'Nr Parcela'+space(5)+'Dt. Vencto'+space(5)+'Valor Parcela'
		if len(VM_FAT) # PEDCAB->PC_FATUR
			?
			?'+---------------------------------------------------------------------+'
			?'* Problemas no arquivo de parcelamento - nao sera impresso as parcelas*'
			?'* recomenda-se excluir este pedido e refaze-lo                        *'
			?'+---------------------------------------------------------------------+'
			?
		else
			for ORD:=1 to PEDCAB->PC_FATUR
				? space(12)+str(ORD,8)
				??space(05)+transform(VM_FAT[ORD,2],mDT)
				??space(08)+transform(VM_FAT[ORD,3],mI102)
			next
		end
	else
		? 'Venda a Vista'
	end
	?I15CPP
	? replicate('-',120)
	? 'Unid. Quantidad '+padr('Produto',45,'.')+space(2)+'CT '
	??padl('Valor Unit.',14)
	??padl('Desconto',16)
	??padl('Valor Total',16)
	? replicate('-',120)
	for ORD:=1 to len(VM_DET)
		if VM_DET[ORD,2]#0
			? VM_DET[ORD,10]+space(1) //......................unidade
			??transform(VM_DET[ORD,4],masc(6))+space(1) //....qtdade
			??padr(pb_zer(VM_DET[ORD,2],L_P)+'-'+VM_DET[ORD,03],46)+space(1) //..Prod/descricao
			??pb_zer(VM_DET[ORD,8],2) //......................cod tributario
			??transform(VM_DET[ORD,5],masc(2))+space(1) //....vlr unitario
			??transform(VM_DET[ORD,6],masc(2))+space(1) //....descontos
			??transform(trunca(VM_DET[ORD,4]*VM_DET[ORD,5],2)-VM_DET[ORD,6]+VM_DET[ORD,7],masc(2)) //..vlr venda
		end
	next
	?
	?padr('Total do Pedido',97,'.')+transform(PC_TOTAL-PC_ENCFI,masc(2)) // EM R$
	?
	if PC_DESC>0
		? padr('(-) Desconto',97,'.')+transform(PC_DESC,masc(2))
		? padr('(+) Enc.Financeiros',97,'.')+transform(PC_ENCFI,masc(2))
		? padr('(=) Total com Desconto',97,'.')+transform(PC_TOTAL-PC_DESC,masc(2)) // EM R$
		?
	end
	? PC_OBSER
	?
	? C15CPP
	if len(VM_ICMS)>0.and.PARAMETRO->PA_PEDCAB#'N'
		?padc('Valores de ICMS',VM_LAR,'-')
		?
		?space(15)+'Valor Base'+space(7)+'%'+space(12)+'Valor ICMS'
		for ORD:=1 to len(VM_ICMS)
			if ORD<=len(VM_ICMS)
				? space(10)+transform(VM_ICMS[ORD,2],masc(02))+space(5) //....BASE
				??transform(VM_ICMS[ORD,1],masc(14))+space(5) //..........%
				??transform(round(VM_ICMS[ORD,2]*VM_ICMS[ORD,1]/100,2),masc(02)) //.VALOR
			end
		next
	end	
	?replicate('-',VM_LAR)
	eject
Next X
return NIL

*-------------------------------------------------------------*
static function DigContas()
*-------------------------------------------------------------*
private nBanco:=0
private nCaixa:=BuscTipoCx('R')
private nConta:=0
while .T.
	pb_box(17,20,,,,'Lancamentos de Adiantamento')
	@19,22 say 'D-Codigo Banco....:' get nBanco pict mI2 valid fn_codigo(@nBanco,{'BANCO',{||BANCO->(dbseek(str(nBanco,2)))},{||CFEP1500T(.T.)},{2,1}})
	@20,22 say 'C-CC Adto Cliente.:' get nConta pict mI4 valid fn_ifconta(,@nConta)
	@21,22 say 'Cod.Lcto Caixa....:' get nCaixa pict mI3 valid fn_codigo(@nCaixa,{'CAIXACG',{||CAIXACG->(dbseek(str(nCaixa,3)))},{||CXAPCDGRT(.T.)},{2,1}}) when nCaixa==0.and.USACAIXA
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		exit
	else
		alert('Voce deve informar dados para contabilizacao')
	end
end
return ({BANCO->BC_CONTA,nConta,nBanco,nCaixa})
//--------------------------------------------------EOF----------------------//
