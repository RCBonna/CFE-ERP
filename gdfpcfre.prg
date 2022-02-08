*-----------------------------------------------------------------------------*
 static aVariav := {'N','',.T.,0,'',0}
 //.................1....2..3..4..5.6
*-----------------------------------------------------------------------------*
#xtranslate SERIE    => aVariav\[  1 \]
#xtranslate EMITENTE => aVariav\[  2 \]
#xtranslate TOMADOR	=> aVariav\[  3 \]
#xtranslate nX       => aVariav\[  4 \]
#xtranslate cRT      => aVariav\[  5 \]
#xtranslate TOTALCF  => aVariav\[  6 \]

#INCLUDE 'RCB.CH'
*-----------------------------------------------------------------------------*
function GDFPCFRE(lNFS,pEmpr)
*-----------------------------------------------------------------------------*
local VLRS:={}
pb_msg('Conhecimento Frete:')
select('CFEACFC') // Frete
ORDEM DTCFRE // ORDEM DATA + NR Conhecimento de Frete

DbGoTop()
dbseek(dtos(DATA[1]),.T.)
while !eof().and.CFEACFC->CFC_DTEMI<=DATA[2]
	@24,60 say dtoc(CFEACFC->CFC_DTEMI)+'>'+str(CFEACFC->CFC_NUMCF,8)
	NATOP->(dbseek(str(CFEACFC->CFC_CODOP,7)))
	SERIE   :=upper(CFEACFC->CFC_SERCF)
	EMITENTE:={"","",""}
	TOMADOR :={"","",""}
	* 
	CLIENTE->(dbseek(str(CFEACFC->CFC_CODRE,5)))
	EMITENTE[1]:=SONUMEROS(CLIENTE->CL_CGC)
	EMITENTE[2]:=SONUMEROS(CLIENTE->CL_INSCR)
	EMITENTE[3]:=CLIENTE->CL_UF

	CLIENTE->(dbseek(str(CFEACFC->CFC_CODDE,5)))
	TOMADOR[1]:=SONUMEROS(CLIENTE->CL_CGC) // CGC OU CPF
	TOMADOR[2]:='ISENTO'
	TOMADOR[3]:=CLIENTE->CL_UF
	if CLIENTE->CL_TIPOFJ=='J'
		if left(upper(CLIENTE->CL_INSCR),6)#'ISENTO'
			TOMADOR[2]:=SONUMEROS(CLIENTE->CL_INSCR)
		end
	end
	TPEmitente	:="P"
	MODELO		:="08"
	SITUA			:="N" // Situação Normal
	TIPO			:=70
	TOTALCF		:=	CFEACFC->CFC_TARIFA+;
						CFEACFC->CFC_VLFRET+;
						CFEACFC->CFC_VLSEC+;
						CFEACFC->CFC_VLDESP+;
						CFEACFC->CFC_VLITR+;
						CFEACFC->CFC_VLOUTR+;
						CFEACFC->CFC_VLSEG+;
						CFEACFC->CFC_VLPED
	gravaDVS({pEmpr,;						//  1-Empresa
				TIPO,;						//  2-TIPO DE REGISTRO
				CFEACFC->CFC_DTEMI,;		//  3-Data emissao
				EMITENTE[1],;				//  4-CGC Cliente
				EMITENTE[2],;				//  5-INSCR Cliente
				EMITENTE[3],;				//  6-UF DO Cliente
				MODELO,;						//  7-Modelo
				SERIE,;						//  8-Serie NF
				'  ',;						//  9-Subserie
				CFEACFC->CFC_NUMCF,;		// 10-NR NOTA FISCAL/Conhecimento de Frete
				val(left(str(CFEACFC->CFC_CODOP,7),4)),;// 11-NAT OPERACAO
				TOTALCF,;					// 12-TOTAL NF-CONH.FRETE/ALIQUOTA
				CFEACFC->CFC_VLBASE,;	//	13-BASE ICMS
				CFEACFC->CFC_VLICMS,;	// 14-VLR ICMS
				0,;							// 15-VLR ISENTAS
				0,;							// 16-VLR OUTRAS
				CFEACFC->CFC_VLALIQ,;	// 17-% ICMS
				SITUA,;						// 18-SITUACAO DA NF
				val(CFEACFC->CFC_TPFRE1),;// 19-MODO CIF (1-Pago/2-A Pagar = "1" - CIF ou "2" - FOB)
				0,;							// 20-ITEM NF
				0,;							// 21-COD PROD
				'',;							// 22-SIT TRIB
				'',;							// 23-UNIDADE
				0,;							// 24-QTDADE
				0,;							// 25-VLR IPI
				'G',;							// 26-registro Gerado
				'',;							// 27-Descricao Prod
				0,;							// 28-Vlr Desconto
				TPEmitente,;				// 29-Tipo Emitente <T>erceito ou <P>róprio
				TOMADOR[1],;				// 30-CGC-Tomador -> só para reg 71
				TOMADOR[2],;				// 31-IE-Tomador -> só para reg 71
				TOMADOR[3],;				// 32-UF-Tomador Do Conhecimento de Frete-> só para reg 71
				0,;							// 33-71-Número NF-Levada no conhecimento de Frete
				'',;							// 34-71-Série NF-Levada no conhecimento de Frete
				0.00})						// 35-71-Valor NF-Levada no conhecimento de Frete
	//------------------------------------------------FIM 70
	
	GDFPITCFD(pEmpr,CFEACFC->CFC_CHAVE) // NFS DO FRETE
	
	dbskip()
end
return NIL

*-----------------------------------------------------------------------------*
 static function GDFPITCFD(pEmpr,pChave) // Valores Detalhes
*-----------------------------------------------------------------------------*
TIPO			:=71
SALVABANCO
select('CFEACFD') // seleciona Detalhe
dbseek(str(pChave,6),.T.)
while !eof().and.str(CFEACFD->CFD_CHAVE,6)==str(pChave,6)
	gravaDVS({pEmpr,;						//  1-Empresa
				TIPO,;						//  2-TIPO DE REGISTRO
				CFEACFC->CFC_DTEMI,;		//  3-Data emissao
				EMITENTE[1],;				//  4-CGC Cliente
				EMITENTE[2],;				//  5-INSCR Cliente
				EMITENTE[3],;				//  6-UF DO Cliente
				MODELO,;						//  7-Modelo
				SERIE,;						//  8-Serie NF
				'  ',;						//  9-Subserie
				CFEACFC->CFC_NUMCF,;		// 10-NR NOTA FISCAL/Conhecimento de Frete
				val(left(str(CFEACFC->CFC_CODOP,7),4)),;// 11-NAT OPERACAO
				TOTALCF,;					// 12-TOTAL NF-CONH.FRETE/ALIQUOTA
				CFEACFC->CFC_VLBASE,;	//	13-BASE ICMS
				CFEACFC->CFC_VLICMS,;	// 14-VLR ICMS
				0,;							// 15-VLR ISENTAS
				0,;							// 16-VLR OUTRAS
				CFEACFC->CFC_VLALIQ,;	// 17-% ICMS
				SITUA,;						// 18-SITUACAO DA NF
				val(CFEACFC->CFC_TPFRE1),;// 19-MODO CIF (1-Pago/2-A Pagar = "1" - CIF ou "2" - FOB)
				0,;							// 20-ITEM NF
				0,;							// 21-COD PROD
				'',;							// 22-SIT TRIB
				'',;							// 23-UNIDADE
				0,;							// 24-QTDADE
				0,;							// 25-VLR IPI
				'G',;							// 26-registro Gerado
				'',;							// 27-Descricao Prod
				0,;							// 28-Vlr Desconto
				TPEmitente,;				// 29-Tipo Emitente <T>erceito ou <P>róprio
				TOMADOR[1],;				// 30-CGC-Tomador -> só para reg 71
				TOMADOR[2],;				// 31-IE-Tomador -> só para reg 71
				TOMADOR[3],;				// 32-UF-Tomador Do Conhecimento de Frete-> só para reg 71
				CFEACFD->CFD_NRNF,;		// 33-71-Número NF-Levada no conhecimento de Frete
				CFEACFD->CFD_SERCF,;		// 34-71-Série NF-Levada no conhecimento de Frete
				CFEACFD->CFD_VLNF})		// 35-71-Valor NF-Levada no conhecimento de Frete

	dbskip()
end
RESTAURABANCO
return NIL
*----------------------------------------EOF----------------------------------------
