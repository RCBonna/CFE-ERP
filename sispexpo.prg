*-----------------------------------------------------------------------------*
 #include 'RCB.CH'
 function SISPEXPO()	// Exportacao de dados
*-----------------------------------------------------------------------------*
local SALDO
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'R->CODTR',;
				'R->ALIQUOTAS',;
				'R->ENTCAB',;
				'R->ENTDET',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->SALDOS',;
				'R->CLIENTE',;
				'R->GRUPOS',;
				'R->PROD'})
	return NIL
end
select('GRUPOS')
set filter to GRUPOS->GE_CODGR%10000>0

select('PROD')
DbGoTop()
VM_DATA:={boy(boy(date())-1), boy(date())-1}
ARQUIVO:='\TEMP\LFDCD30.TXT'
pb_box(19,19,,,,'Exportar/Liscal-WK')
@20,21 say "NF-Data Inicial:" get VM_DATA[1] pict mDT
@21,21 say "NF-Data Final..:" get VM_DATA[2] pict mDT valid VM_DATA[2]>=VM_DATA[1]
read
if lastkey()#27.and.pb_sn('Exporta de arquivos para '+ARQUIVO)
	set print to (ARQUIVO)
	set print on
	set console off
	ordem CODIGO
	DbGoTop()
	while !eof()
		pb_msg('Exportando Produtos:'+ARQUIVO+' -> '+ str(PROD->PR_CODPR,13))
		SALDO:=fn_SaldoEstoque(PROD->PR_CODPR,VM_DATA[1],VM_DATA[2])
		??xp('I')                   +','
		??xp(str(PROD->PR_CODPR))   +','
		??xp(PROD->PR_CODNBM)       +','
		??xp(PROD->PR_DESCR)        +','
		??xp(PROD->PR_UND)          +','
		??xp('')					       +',' // BASE REDUZIDA
		??xp(str(PROD->PR_PIPI,14,4))+','
		??xp(pb_zer(SALDO[1],14,4)) +','
		??xp(pb_zer(SALDO[2],14,2)) +','
		??xp(pb_zer(SALDO[3],14,4)) +','
		??xp(pb_zer(SALDO[4],14,2)) +','
		??xp('')        +',' //TIPO
		??xp(PROD->PR_CODTR)        +','
		?
		dbskip()
	end
	DbGoTop()
	set console on
	set print off
	set print to

	ARQUIVO:='\TEMP\LFDCD90.TXT'
	set print to (ARQUIVO)
	set print on
	set console off
	select('CLIENTE')
	ordem CODIGO
	DbGoTop()
	while !eof()
		pb_msg('Exportando Clientes:'+ARQUIVO+' -> '+ str(CL_CODCL,5))
		??xp('I')+','
		??xp(pb_zer(CL_CODCL,))+','// CLIENTE +  60.000 
		??xp('A')+','
		??xp('')+','
		??xp(CL_RAZAO)+','
		??xp(CL_ENDER)+','
		??xp(CL_BAIRRO)+','
		??xp(CL_UF)+','
		??xp('')+','
		??xp(CL_CIDAD)+','
		??xp(CL_CEP)+','
		??xp('')+','
		??xp(CL_FONE)+','
		??xp(CL_FAX)+','
		??xp('')+','
		??xp('')+','
		??xp('N')+','
		??xp(CL_CGC)+','
		??xp(CL_INSCR)+','
		??xp('')+','//conta contabil fornec
		??xp('')+','//conta contabil cliente
		??xp('')
		?
		dbskip()
	end

	select CLIENTE
	ordem CODIGO
	DbGoTop()
	while !eof()
		pb_msg('Exportando Fornecedor:'+ARQUIVO+' -> '+ str(60000+CLIENTE->CL_CODCL,5))
		??xp('I')+','
		??xp(pb_zer(60000+CLIENTE->CL_CODCL,))+','// FORNECEDOR  +  60.000 
		??xp('A')+','
		??xp('')+','
		??xp(CLIENTE->CL_RAZAO)+','
		??xp(CLIENTE->CL_ENDER)+','
		??xp(CLIENTE->CL_BAIRRO)+','
		??xp(CLIENTE->CL_UF)+','
		??xp('')+','
		??xp(CLIENTE->CL_CIDAD)+','
		??xp(CLIENTE->CL_CEP)+','
		??xp('')+','
		??xp(CLIENTE->CL_FONE)+','
		??xp(CLIENTE->CL_FAX)+','
		??xp('')+','
		??xp('')+','
		??xp('N')+','
		??xp(CLIENTE->CL_CGC)+','
		??xp(CLIENTE->CL_INSCR)+','
		??xp('')+','//conta contabil fornec
		??xp('')+','//conta contabil cliente
		??xp('')
		?
		dbskip()
	end
	DbGoTop()
	set console on
	set print off
	set print to
	
	ARQUIVO:='\TEMP\LFDCD50.TXT'
	set print to (ARQUIVO)
	set print on
	set console off
	select('PEDCAB')
	ordem DTENNF	
	dbseek(dtos(VM_DATA[1]),.T.)
	while !eof().and.PEDCAB->PC_DTEMI<=VM_DATA[2]
		pb_msg('Exportando SAIDAS :'+ARQUIVO+' -> '+ dtoc(PC_DTEMI))
		if PEDCAB->PC_FLAG
			VICMS:=fn_nfsoma(PEDCAB->PC_PEDID,{PC_TOTAL,PC_DESC,1/*,NATOP->NO_CDVLFIW*/})
			VM_TP:=if(empty(PEDCAB->PC_TPDOC),'NF ',PEDCAB->PC_TPDOC)
			TOTALNF:=0.00
			aeval(VICMS,{|DET|TOTALNF+=DET[2]})
			CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
			??xp('I')                    +','
			??xp(CLIENTE->CL_CGC)        +','
			??xp(left(str(PC_CODOP,7),5))+','
			??xp(pb_zer(PC_NRNF,6))      +','
			??xp(PC_TPDOC)               +','
			??xp(PC_SERIE)               +','
			??xp(dtos(PC_DTEMI))         +','
			??xp(dtos(PC_DTEMI))         +','
			??xp(pb_zer(VICMS[1,1], 6,2))+','//aliquota
			??xp(pb_zer(TOTALNF,   14,2))+','//vlr contabil
			??xp('')                     +','//base reduz
			??xp(pb_zer(VICMS[1,3],14,2))+','//base de calc do 1. imposto
			??xp(pb_zer(VICMS[1,4],14,2))+','//vlr do 1. imposto
			??xp(pb_zer(VICMS[1,2]-VICMS[1,3],14,2))+','	//vlr de isentas
			??xp(pb_zer(0,         14,2))+','//vlr de outras
			??xp('')+','//valor base calculo imposto indireto
			??xp('')+','//valor do imposto indireto
			if len(VICMS)>1
				??xp(pb_zer(VICMS[2,3],14,2))+','//base de calc do 2. imposto
				??xp(pb_zer(VICMS[2,4],14,2))+','//vlr do 2. imposto
				??xp(pb_zer(VICMS[2,2]-VICMS[2,3],14,2))+','	//vlr de isentas
				??xp(pb_zer(0,         14,2))+','//	vlr de outras
			else
				??xp('')+','//base de calculo do 2. imposto
				??xp('')+','//valor do 2. imposto
				??xp('')+','//valor de isentas
				??xp('')+','//valor de outras
			end
			??xp(left(PC_OBSER,57))       +','
			??xp(pb_zer(0,14))+','	//valor do acrescimo financ
			??xp('')+','	//conta credora vlr contab
			??xp('')+','	//conta devedor vlr contab
			??xp('')+','	//cod hist cred
			??xp('')+','	//cod hist deb
			??xp('')+','	//contribuinte ?
			??xp('')+','	//nr final do interv do docto
			??xp('')+','	//estado origem
			??xp(if(empty(CLIENTE->CL_UF),'SC',CLIENTE->CL_UF))+','//estado destin
			??xp('')+','	//cod fisc munic desti
			??xp('')+','	//IPI embutido/icms responsab
			??xp('')+','	//complem contabil deb
			??xp('')+','	//complem contabil cred
			??xp('')//dt venc docto
			?
		end
		dbskip()
	end
	DbGoTop()
	set console on
	set print off
	set print to
	
	
	ARQUIVO:='\TEMP\LFDCD51.TXT' // entradas
	set print to (ARQUIVO)
	set print on
	set console off
	select('ENTCAB')
	ordem DTEDOC
	dbseek(dtos(VM_DATA[1]),.T.)
	while !eof().and.ENTCAB->EC_DTEMI<=VM_DATA[2]
		pb_msg('Exportando ENTRADAS :'+ARQUIVO+' -> '+ dtoc(EC_DTEMI))
		CLIENTE->(dbseek(str(ENTCAB->EC_CODFO,5)))
		??xp('I')                    +','
		??xp(CLIENTE->CL_CGC)         +','
		??xp(left(str(EC_CODOP,7),5))+','
		??xp(pb_zer(EC_DOCTO,6))     +','
		??xp(EC_TPDOC)               +','
		??xp(EC_SERIE)               +','
		??xp(dtos(EC_DTEMI))         +','
		??xp(dtos(EC_DTENT))         +','
		??xp(pb_zer(EC_ICMSP, 6,2))  +','//aliquota
		??xp(pb_zer(EC_TOTAL-EC_DESC,14,2))+','//vlr contabil
		??xp('')                     +','//base reduz
		??xp(pb_zer(EC_ICMSB,14,2))+','//base de calc do 1. imposto
		??xp(pb_zer(EC_ICMSV,14,2))+','//vlr do 1. imposto
		??xp(pb_zer(EC_TOTAL-EC_DESC-EC_ICMSB,14,2))+','	//vlr de isentas
		??xp(pb_zer(0,         14,2))+','//vlr de outras
		??xp('')+','//valor base calculo imposto indireto
		??xp('')+','//valor do imposto indireto
		??xp('')+','//base de calculo do 2. imposto
		??xp('')+','//valor do 2. imposto
		??xp('')+','//valor de isentas
		??xp('')+','//valor de outras
		??xp('')       +','
		??xp(pb_zer(0,14))+','	//valor do acrescimo financ
		??xp('')+','	//conta credora vlr contab
		??xp('')+','	//conta devedor vlr contab
		??xp('')+','	//cod hist cred
		??xp('')+','	//cod hist deb
		??xp('')+','	//contribuinte ?
		??xp('')+','	//nr final do interv do docto
		??xp(if(empty(CLIENTE->CL_UF),'SC',CLIENTE->CL_UF))+','//estado origem
		??xp('SC')+','//estado destin
		??xp('')+','	//cod fisc munic desti
		??xp('')+','	//IPI embutido/icms responsab
		??xp('')+','	//complem contabil deb
		??xp('')+','	//complem contabil cred
		??xp('')//dt venc docto
		?
		dbskip()
	end
	DbGoTop()
	set console on
	set print off
	set print to

	ARQUIVO:='\TEMP\LFDCD52.TXT' //DIPI
	set print to (ARQUIVO)
	set print on
	set console off
	select('ENTCAB')
	ordem DTEDOC
	dbseek(dtos(VM_DATA[1]),.T.)
	while !eof().and.ENTCAB->EC_DTEMI<=VM_DATA[2]
		pb_msg('Exportando DIPI :'+ARQUIVO+' -> '+ dtoc(EC_DTEMI))
		CLIENTE->(dbseek(str(ENTCAB->EC_CODFO,5)))
		select('ENTDET')
		dbseek(str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5),.T.)
		while !eof().and.;
				str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5) == ;
				str(ENTDET->ED_DOCTO,8)+ENTDET->ED_SERIE+str(ENTDET->ED_CODFO,5)
			PROD->(dbseek(str(ENTDET->ED_CODPR,L_P)))
			??xp('I')										+','
			??xp('E')										+','
			??xp(CLIENTE->CL_CGC)							+','
			??xp(pb_zer(ENTCAB->EC_DOCTO,6))			+','
			??xp(ENTCAB->EC_TPDOC)						+','
			??xp(ENTCAB->EC_SERIE)						+','
			??xp(left(str(ENTCAB->EC_CODOP,7),5))	+','
			??xp(str(ED_CODPR))							+',' // COD PRODUTO
			??xp(PROD->PR_CODNBM)						+','
			??xp(pb_zer(ED_QTDE,14,4))					+','// QUANTIDADE
			??xp(pb_zer(pb_divzero(ED_IPI,ED_PIPI),14,2))+','//base ipi
			??xp(pb_zer(ED_IPI ,14,2))					+','//vlr ipi
			??xp(pb_zer(ED_VALOR-pb_divzero(ED_IPI,ED_PIPI),14,2)) +','//isentas IPI
			??xp(pb_zer(0,14,2))							+','//vlr de outras ipi
			??xp(ED_CODTR)									+','//codigo trib
			?
			dbskip()
		end
		select('ENTCAB')
		dbskip()
	end
	DbGoTop()
	set console on
	set print off
	set print to

	ARQUIVO:='\TEMP\LFDCD53.TXT' //ICMS
	set print to (ARQUIVO)
	set print on
	set console off
	select('ENTCAB')
	ordem DTEDOC
	dbseek(dtos(VM_DATA[1]),.T.)
	while !eof().and.ENTCAB->EC_DTEMI<=VM_DATA[2]
		pb_msg('Exportando ICMS-ENTRADAS :'+ARQUIVO+' -> '+ dtoc(EC_DTEMI))
		CLIENTE->(dbseek(str(ENTCAB->EC_CODFO,5)))
		select('ENTDET')
		dbseek(str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5),.T.)
		while !eof().and.;
				str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5) == ;
				str(ENTDET->ED_DOCTO,8)+ENTDET->ED_SERIE+str(ENTDET->ED_CODFO,5)
			PROD->(dbseek(str(ENTDET->ED_CODPR,L_P)))
			??xp('I')								+','
			??xp('E')								+','
			??xp(CLIENTE->CL_CGC)					+','
			??xp(pb_zer(ENTCAB->EC_DOCTO,6))	+','
			??xp(ENTCAB->EC_SERIE)				+','
			??xp(left(str(ENTCAB->EC_CODOP,7),5))+','
			??xp(str(ED_CODPR))					+',' // COD PRODUTO
			??xp(PROD->PR_CODNBM)				+','
			??xp(pb_zer(ED_QTDE ,14,4))		+','// QUANTIDADE
			??xp(pb_zer(ED_VALOR,14,2))		+','//total
			??xp(pb_zer(pb_divzero(ED_VLICM,ED_PCICM),14,2))+','//base icm
			??xp(pb_zer(ED_PCICM ,14,2))		+','	//% icms
			??xp('')									+','	//vlr base subst trib
			??xp(pb_zer(ED_ORDEM,3))			//Ordem
			?
			dbskip()
		end
		select('ENTCAB')
		dbskip()
	end
	DbGoTop()

	// agora as vendas 
	select('PEDCAB')
	ordem DTENNF	
	dbseek(dtos(VM_DATA[1]),.T.)
	while !eof().and.PEDCAB->PC_DTEMI<=VM_DATA[2]
		pb_msg('Exportando ICMS-SAIDAS :'+ARQUIVO+' -> '+ dtoc(PC_DTEMI))
		if PEDCAB->PC_FLAG
			CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
			select('PEDDET')
			dbseek(str(PEDCAB->PC_PEDID,6),.T.)
			while !eof().and.PEDCAB->PC_PEDID==PEDDET->PD_PEDID
				PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
				??xp('I')							 	+','
				??xp('S')							 	+','
				??xp(CLIENTE->CL_CGC)			 	+','
				??xp(pb_zer(PEDCAB->PC_NRNF,6))	+','//nr docto
				??xp(PEDCAB->PC_SERIE)				+','
				??xp(left(str(PEDCAB->PC_CODOP,7),5))+',' // Natureza
				??xp(str(PD_CODPR))					+',' // COD PRODUTO
				??xp(PROD->PR_CODNBM)				+','
				??xp(pb_zer(PD_QTDE,14,4))			+','
				??xp(pb_zer(PD_QTDE*PD_VALOR-PD_DESCG+PD_ENCFI,14,2))+','
				??xp(pb_zer(PD_BAICM,14,2))		+','
				??xp(pb_zer(PD_ICMSP, 6,2))		+','	//aliquota
				??xp('')                   		+','	//base reduz
				??xp(pb_zer(PD_ORDEM,3))					//ordem na nf
				?
				dbskip()
			end
			select('PEDCAB')
		end
		dbskip()
	end
	DbGoTop()
	// terminou as venda
	set console on
	set print off
	set print to

end
dbcloseall()
return NIL

static function XP(P1)
return('"'+strtran(alltrim(P1),',','.')+'"')

static function fn_SaldoEstoque(P1,P2,P3)
local SALDO:={0,0,0,0}
salvabd(SALVA)
select('SALDOS')
if dbseek(str(1,2)+left(dtos(bom(P2)-1),6)+str(P1,L_P))
	SALDO[1]:=SA_QTD
	SALDO[2]:=SA_VLR
end
if	dbseek(str(1,2)+left(dtos(eom(P3)),6)+str(P1,L_P))
	SALDO[1]:=SA_QTD
	SALDO[2]:=SA_VLR
end
salvabd(RESTAURA)
return SALDO
*--------------------------------------------------------------EOF----------------------------------*