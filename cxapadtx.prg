*-----------------------------------------------------------------------------*
 static aVariav := {0,0,0,4,.T.,0,'ADT',0,0, 0, 0, 0, 0,{}, 0, 0, 0, 0,'','A',0}
 //.................1.2.3,4, 5..6,  7,  8,9,10,11.12,13,14.15.16,17.18.19,20.21
*---------------------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate nX1        => aVariav\[  2 \]
#xtranslate nCodCli    => aVariav\[  3 \]
#xtranslate TipoAdto   => aVariav\[  4 \]
#xtranslate LCont      => aVariav\[  5 \]
#xtranslate NroAdto    => aVariav\[  6 \]
#xtranslate cTipoCTRL  => aVariav\[  7 \]
#xtranslate nRec       => aVariav\[  8 \]
#xtranslate nProgCont  => aVariav\[  9 \]
#xtranslate dData      => aVariav\[ 10 \]
#xtranslate nNro       => aVariav\[ 11 \]
#xtranslate nVLRTOT    => aVariav\[ 12 \]
#xtranslate nVLRUSA    => aVariav\[ 13 \]
#xtranslate aADTO      => aVariav\[ 14 \]
#xtranslate cREL       => aVariav\[ 15 \]
#xtranslate nPag       => aVariav\[ 16 \]
#xtranslate cLAT       => aVariav\[ 17 \]
#xtranslate nTOT       => aVariav\[ 18 \]
#xtranslate cTELA      => aVariav\[ 19 \]
#xtranslate cTipoSIT   => aVariav\[ 20 \]
#xtranslate nCopias    => aVariav\[ 21 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
 function CXAPADTI(pTipo) // Impressao Adiantamento
*-----------------------------------------------------------------------------*
TipoAdto :=pTipo
dData    :={bom(date()),eom(date())}
nNro     :={0,99999}
cTipoCTRL:='S'
cTipoSIT :='T'
CodCl1   :=0
CodCl2   :=99999
nX1      :=17
cREL     :='Adiantamentos a '+if(TipoAdto=='C','Clientes','Fornecedores')
nPag     :=0
nLar     :=132
TOT      :={0,0}
lCont    :=.T.
nCodCli  :=0
pb_box(nX1++,20,,,,'Selecione Impressao')
@nX1++,22 say 'Tipo Listagem........:' get cTipoCTRL pict mUUU valid cTipoCTRL$'ASN' when pb_msg('<A>nalitico <S>intetico com <N>F')
@nX1++,22 say 'Situacao Adto........:' get cTipoSIT  pict mUUU valid cTipoSIT $'AT'  when pb_msg('<A>bertas   <T>odas')
@nX1++,22 say 'Cliente/Fornec(Inic).:' get CodCl1    pict mI5  valid CodCl1==    0.or.fn_codigo(@CodCl1,  {'CLIENTE', {||CLIENTE->(dbseek(str(CodCl1,5)))},  {||CFEP3100T(.T.)},{2,1,8,7}})
@nX1++,22 say 'Cliente/Fornec(Final):' get CodCl2    pict mI5  valid CodCl2==99999.or.fn_codigo(@CodCl2,  {'CLIENTE', {||CLIENTE->(dbseek(str(CodCl2,5)))},  {||CFEP3100T(.T.)},{2,1,8,7}}).and.CodCl2>=CodCl1

//@nX1  ,22 say 'Data Inicial/Final...:' get dData[1]  pict mDT 
//@nX1++,60                              get dData[2]  pict mDT  valid dData[2]>=dData[1]
//@nX1  ,22 say 'Cod.Adto Inic/Final..:' get nNro[1]   pict mI5
//@nX1++,60                              get nNro[2]   pict mDT  valid nNro[2]>=nNro[1]

read
if if(LastKey()#K_ESC,pb_sn(),.F.)
	cREL+='('+if(cTipoCTRL=='A','Analitico',if(cTipoCTRL=='S','Sintetico','C/Nota Fiscal'))+'-'
	cREL+=if(cTipoSIT=='A','Abertos','Todos')+')'
	if pb_ligaimp(I15CPP)
		go top
		dbseek(str(CodCl1,5),.T.)
		while !eof().and.C2_CODCL>=CodCl1.and.C2_CODCL<=CodCl2
			nPag:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),cRel,nPag,'CXAPADT5X',nLAR)
			if cTipoSIT=='T'.or.C2_PEND
				if nCodCli#C2_CODCL
					? pb_zer(C2_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,25)
					nCodCli:=C2_CODCL
					lCont  :=.T.
				else
					if lCont
						? space(30)+'+'
					end
				end
				??' ' +dtoc(C2_DTEMI)
				??str(C2_NRO,6)+' '
				??transform(C2_VLRADT          ,mI102)
				??transform(C2_VLRUSA          ,mI102)
				??transform(C2_VLRADT-C2_VLRUSA,mI102)
				TOT[1]+=C2_VLRADT
				TOT[2]+=C2_VLRUSA
				if cTipoCTRL$'AN'
					CXAPADT5A()
				end
			end
			pb_brake()
		end
		? replicate('-',nLar)
		? space(6)+'Total'+space(38)
		??transform(TOT[1]       ,mI102)
		??transform(TOT[2]       ,mI102)
		??transform(TOT[1]-TOT[2],mI102)
		? replicate('-',nLar)
		? 'Impresso as '+time()
		pb_deslimp(C15CPP,PULA_PAGINA)
		go top
	end
end
return NIL

*-----------------------------------------------------------------------------*
 function CXAPADT5X() // Cabec 2 Impressao Adiantamento
*-----------------------------------------------------------------------------*
? 'Codig/Nome '+if(TipoAdto=='C','Clientes    ','Fornecedores')
??space(9)+'Dt Emissao NroAdt VlrAdiant VlrBaixado VlrSaldo'
if cTipoCTRL$'AN'
	??' *----Quantidade-----*'
	?space(10)+padr('Produto',L_P+69)
	??' Adiant. Baixado Saldo'
end
? replicate('-',nLar)
return NIL

*-----------------------------------------------------------------------------*
 static function CXAPADT5A() // Impressao Adiantamento (Produtos)
*-----------------------------------------------------------------------------*
select ADTOSD
dbseek(Str(ADTOSC->C2_NRO,5),.T.)
while !eof().and.C3_NRO==ADTOSC->C2_NRO
	PROD->(dbseek(str(ADTOSD->C3_CODPR,L_P)))
	? space(6)
	??str(C3_CODPR,L_P)+'-'
	??padr(PROD->PR_DESCR,59)
	??transform((C3_QTDEPE-C3_QTDESA)*C3_VLRVEN,mI113 )
	??transform(C3_QTDEPE                      ,mI123)
	??transform(C3_QTDESA                      ,mI123)
	??transform(C3_QTDEPE-C3_QTDESA            ,mI123 )
	if cTipoCTRL=='N'// com nota fiscal
		CXAPADT5B()
	end
	pb_brake()
end
select ADTOSC
return NIL

*-----------------------------------------------------------------------------*
 static function CXAPADT5B() // Impressao Adiantamento (NF)
*-----------------------------------------------------------------------------*
SALVABANCO
if TipoAdto=='C'
	CXAPADT5C()
elseif TipoAdto=='F'
	CXAPADT5F()
end
RESTAURABANCO
return NIL

*-----------------------------------------------------------------------------*
 static function CXAPADT5C() // Impressao Adiantamento (NF)
*-----------------------------------------------------------------------------*
select PEDCAB
dbseek(str(ADTOSC->C2_CODCL,5),.T.)
while !eof().and.PEDCAB->PC_CODCL == ADTOSC->C2_CODCL
	if PEDCAB->PC_FLADTO // É adiantamento
		select PEDDET
		dbseek(str(PEDCAB->PC_PEDID,6),.T.)
		while !eof().and.PEDDET->PD_PEDID==PEDCAB->PC_PEDID
			if PD_NROADT==ADTOSC->C2_NRO.and.PD_CODPR==ADTOSD->C3_CODPR
				? space(31)
				??'-'+dtoc(PEDCAB->PC_DTEMI)+' '
				??"NF:"+str(PEDCAB->PC_NRNF,5)+'/'+PEDCAB->PC_SERIE+space(38)
				??transform(-PD_QTDE,mI102)
			end
			pb_brake()
		end
		select PEDCAB
	end
	pb_brake()
end
return NIL

*-----------------------------------------------------------------------------*
 static function CXAPADT5F() // Impressao Adiantamento (NF)
*-----------------------------------------------------------------------------*
select ENTCAB
dbseek(str(ADTOSC->C2_CODCL,5),.T.)
while !eof().and.ENTCAB->EC_CODFO == ADTOSC->C2_CODCL
	if ENTCAB->EC_FLADTO // É Adiantamento
		select ENTDET
		dbseek(str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5),.T.)
		while !eof().and.	str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5)==;
								str(ENTDET->ED_DOCTO,8)+ENTDET->ED_SERIE+str(ENTDET->ED_CODFO,5)

			if ED_NROADT==ADTOSC->C2_NRO.and.ENTDET->ED_CODPR==ADTOSD->C3_CODPR
				? space(31)
				??'-'+dtoc(ENTCAB->EC_DTEMI)+' '
				??"NF:"+str(ENTCAB->EC_DOCTO,8)+'/'+ENTCAB->EC_SERIE+space(35)
				??transform(-ED_QTDE,mI123)
			end
			pb_brake()
		end
		select ENTCAB
	end
	pb_brake()
end
return NIL

*-----------------------------------------------------------------------------*
 function CXAPADT6() // Lista Contrato
*-----------------------------------------------------------------------------*
nLar     :=80
TOT      :={0,0}
if pb_sn('Imprimir Contrato')
	if pb_ligaimp(C15CPP)
		for nCopias:=1 to 2
			??VM_EMPR
			? PARAMETRO->PA_ENDER
			? transform(PARAMETRO->PA_CEP,masc(10))+' '+PARAMETRO->PA_CIDAD+' '+PARAMETRO->PA_UF
			? 'Fone : '+PARAMETRO->PA_FONE+space(5)+'Fax : '+PARAMETRO->PA_FAX
			?
			? replicate('-',nLar)
			? padc('Contrato de Adiantamento Nr:'+pb_zer(ADTOSC->C2_NRO,5),nLar,'.')
			? replicate('-',nLar)
			?
			? padr('Cliente' ,15,'.')+': '+pb_zer(CLIENTE->CL_CODCL,6)+'-'+CLIENTE->CL_RAZAO
			? padr('Endereco',15,'.')+': '+CLIENTE->CL_ENDER+space(1)+left(CLIENTE->CL_BAIRRO,26)
			? padr('Cidade',  15,'.')+': '+CLIENTE->CL_CIDAD+' CEP : '+CLIENTE->CL_CEP+'-'+CLIENTE->CL_UF
	
			if len(trim(CLIENTE->CL_CGC))>11
				? padr('C.N.P.J.',   15,'.')+': '+transform(CLIENTE->CL_CGC,masc(18))
				??space(5)+'Inscricao Estad:'
			else
				? padr('C.P.F',   15,'.')+': '+transform(CLIENTE->CL_CGC,masc(17))
				??space(5)+'RG/Identidade :'
			end
			??CLIENTE->CL_INSCR
			?
			? padr('Dt Emissao:',15,'.')+': '+dtoc(C2_DTEMI)+' as '+time()
			?
			TOT[1]:=0
			select ADTOSD
			dbseek(Str(ADTOSC->C2_NRO,5),.T.)
			?'*'+padc('Produto',L_P+43,'-')+'* Qtdade Vlr Adiant'
			? replicate('-',nLar)
			while !eof().and.C3_NRO==ADTOSC->C2_NRO
				PROD->(dbseek(str(ADTOSD->C3_CODPR,L_P)))
				? str(C3_CODPR,L_P)+'-'
				??padr(PROD->PR_DESCR,39)
				??transform(C3_QTDEPE          ,mI123)
				??transform(C3_QTDEPE*C3_VLRVEN,mI102)
				TOT[1]+=(C3_QTDEPE*C3_VLRVEN)
				pb_brake()
			end
			select ADTOSC
			? replicate('-',nLar)
			? padc('Total',31,'.')+space(28)+transform(TOT[1],mI102)
			? replicate('-',nLar)
			?
			?if(!empty(C2_HIST),'OBS:'+C2_HIST,'')
			?
			?
			?
			?space(2)+replicate('_',40)+space(5)+replicate('_',30)
			?space(2)+padc(VM_EMPR,40) +space(5)+padc(CLIENTE->CL_RAZAO,30)
			?
			eject
			select ADTOSC
		next
		pb_deslimp(C15CPP)
	end
end
return NIL

//-----------------------------------------------EOF----------------------------------------
