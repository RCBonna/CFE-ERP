#include 'RCB.CH'
*--------------------------------------------------------------------------*
 function GDFPCFEE(lNFS,pEmpr)
*--------------------------------------------------------------------------*
SITUA   :='N'	//       <N>=Normal      <S>=Cancelado     <E>=Extemporaneo Normal    <X>=Extemporaneo Cancelado
pb_msg('Entradas:')
select('ENTCAB')
ORDEM DTEDOC
DbGoTop()
dbseek(dtos(DATA[1]),.T.)
while !eof().and.EC_DTENT<=DATA[2]
	@24,60 say dtoc(ENTCAB->EC_DTENT)+'>'+str(ENTCAB->EC_DOCTO,8)
	*------------------------------------------------------------------
	if !CLIENTE->(dbseek(str(ENTCAB->EC_CODFO,5)))
		alert('Erro Ao processar GDF;Cliente '+str(ENTCAB->EC_CODFO,5)+' nao encontrado no cadastro;Arquivo gerado incorretamente')
	end
	NATOP->(dbseek(str(ENTCAB->EC_CODOP,7)))
	SERIE   :=upper(ENTCAB->EC_SERIE)
	if !(lNFS=='N'.and.SERIE=='NPS') // Não enviar a nf de serviços
		CGC       :=SONUMEROS(CLIENTE->CL_CGC)
		INSCR     :='ISENTO'
		TPEmitente:='T' // Terceiro ou Próprio
		if right(str(ENTCAB->EC_CODOP,7),2)=='99' // emitido pela origem
			TPEmitente:='P' // Terceiro ou Próprio
		end
		if len(trim(CLIENTE->CL_CGC))>11
			if left(upper(CLIENTE->CL_INSCR),6)#'ISENTO'
				INSCR:=SONUMEROS(CLIENTE->CL_INSCR)
			end
		end
		*----------------------------------------------------------
		MODELO  :=VERSERIE(SERIE,ENTCAB->EC_DOCTO)
		if MODELO$'06..08..22..' // CELESC-FRETE-TELESC
			SERIE:='U  '
		end
		VLRTOT  :=ENTCAB->EC_TOTAL-ENTCAB->EC_DESC
		VLRS    :=CfeVlrE(pEmpr,;
								ENTCAB->EC_DOCTO,;
								VLRTOT,;
								ENTCAB->EC_CODFO,;
								pb_divzero(ENTCAB->EC_DESC,ENTCAB->EC_TOTAL),;
								MODELO,;
								ENTCAB->EC_SERIE)
		//...............................1......2........3............................4......5........6
		TIPO    :=50
		if MODELO$'02..08'	// NF D2
			TIPO  :=61
//			CGC   :=''
			INSCR :='ISENTO'
			MODELO:='02'
//		elseif MODELO=='08' // FRETE
//			TIPO  :=70
		end
		Y			:=1
		if len(VLRS)>1
			//		Y		:=1
			//		for X:=1 to 6
			//			VLRS[2,X]+=VLRS[1,X]
			//		next
		else //..........................SO TEM UMA
			if str(VLRS[1,1]+VLRS[1,2]+VLRS[1,3]+VLRS[1,4]+VLRS[1,5]+VLRS[1,6],15,2)==str(0,15,2)
				VLRS[1,1]:=VLRTOT
				VLRS[1,2]:=EC_ICMSB
				VLRS[1,3]:=EC_ICMSV
				VLRS[1,4]:=max(VLRTOT-EC_ICMSB,0)	// ISENTAS
				VLRS[1,5]:=0.00							// OUTRAS
				VLRS[1,6]:=EC_ICMSP
			end
		end
		//...........................................................
		SITUA    :='N'
		if TIPO == 50 
			for X:=Y to len(VLRS)
				if str(VLRS[X,1]+VLRS[X,2]+VLRS[X,3]+VLRS[X,4]+VLRS[X,5]+VLRS[X,6],15,2) > str(0,15,2)
					gravaDVS({	pEmpr,;							// 01-Empresa
									TIPO,;									// 02-TIPO
									ENTCAB->EC_DTENT,;					// 03-Data Entrada
									CGC,;										// 04-CGC fornec
									INSCR,;									// 05-INSCR fornec
									CLIENTE->CL_UF,;						// 06-UF DO fornecedor
									MODELO,;									// 07-Modelo
									SERIE,;									// 08-Serie NF
									'  ',;									// 09-Subserie
									val(right(str(EC_DOCTO,8),6)),;	// 10-NR NOTA FISCAL
									val(left(str(EC_CODOP,7),4)),;	// 11-NAT OPERACAO
									VLRS[X,1],;								// 12-TOTAL NF/ALIQUOTA
									VLRS[X,2],;								//	13-BASE ICMS
									VLRS[X,3],;								// 14-VLR ICMS
									VLRS[X,4],;								// 15-VLR ISENTAS
									VLRS[X,5],;								// 16-VLR OUTRAS
									VLRS[X,6],;								// 17-% ICMS
									SITUA,;									// 18-SITUACAO DA NF
									max(ENTCAB->TR_TIPO,1),;			// 19-MODO CIF
									0,;										// 20-ITEM NF
									0,;										// 21-COD PROD
									'',;										// 22-SIT TRIB
									'',;										// 23-UNIDADE
									0,;										// 24-QTDADE
									0,;										// 25-VLR IPI
									'G',;										// 26-Registro Gerado
									'',;										// 27-Produto
									0,;										// 28-Desconto
									TPEmitente})							// 29-Tipo Emitente <T> ou <P>
				end
			next
		elseif TIPO==61 // SERIE D2
			for X:=Y to len(VLRS)
				if str(VLRS[X,1]+VLRS[X,2]+VLRS[X,3]+VLRS[X,4]+VLRS[X,5]+VLRS[X,6],15,2) > str(0,15,2)
					gravaDVS({	pEmpr,;				//  1-Empresa
									TIPO,;						//  2-TIPO
									ENTCAB->EC_DTENT,;		//  3-Data emissao
									CGC,;							//  4-CGC FORNEC
									INSCR,;						//  5-INSCR FORNEC
									CLIENTE->CL_UF,;			//  6-UF DO FORNECEDOR
									MODELO,;						//  7-Modelo
									SERIE,;						//  8-Serie NF
									'',;							//  9-Subserie
									val(right(str(EC_DOCTO,8),6)),;	// 10-NR NOTA FISCAL
									val(left(str(EC_CODOP,7),4)),;	// 11-NAT OPERACAO
									VLRS[X,1],;					// 12-TOTAL NF/ALIQUOTA
									0,;							//	13-BASE ICMS
									0,;							// 14-VLR ICMS
									0,;							// 15-VLR ISENTAS
									0,;							// 16-VLR OUTRAS
									0,;							// 17-% ICMS
									SITUA,;						// 18-SITUACAO DA NF
									0,;							// 19-MODO CIF
									0,;							// 20-ITEM NF
									0,;							// 21-COD PROD
									'',;							// 22-SIT TRIB
									'',;							// 23-UNIDADE
									0,;							// 24-QTDADE
									0,;							// 25-VLR IPI
									'G',;							// 26-registro Gerado
									'',;							// 27-Produto
									0,;							// 28-Desconto
									TPEmitente})				// 29-Tipo Emitente <T> ou <P>
				end
			next
		elseif TIPO==70
			gravaDVS({	pEmpr,;					//  1-Empresa
							TIPO,;							//  2-TIPO
							ENTCAB->EC_DTENT,;			//  3-Data emissao
							CGC,;								//  4-CGC fornec
							INSCR,;							//  5-INSCR fornec
							CLIENTE->CL_UF,;				//  6-UF DO fornec
							MODELO,;							//  7-Modelo
							SERIE,;							//  8-Serie NF
							'',;								//  9-Subserie
							val(right(str(EC_DOCTO,8),6)),;	// 10-NR NOTA FISCAL
							val(left(str(EC_CODOP,7),4)),;	// 11-NAT OPERACAO
							EC_TOTAL-EC_DESC,;			// 12-TOTAL NF/ALIQUOTA
							EC_ICMSB,;						//	13-BASE ICMS
							EC_ICMSV,;						// 14-VLR ICMS
							max(EC_TOTAL-EC_DESC-EC_ICMSB,0),;// 15-VLR ISENTAS
							0,;								// 16-VLR OUTRAS
							EC_ICMSP,;						// 17-% ICMS
							SITUA,;							// 18-SITUACAO DA NF
							max(TR_TIPO,1),;				// 19-MODO CIF
							0,;								// 20-ITEM NF
							0,;								// 21-COD PROD
							'',;								// 22-SIT TRIB
							'',;								// 23-UNIDADE
							0,;								// 24-QTDADE
							0,;								// 25-VLR IPI
							'G',;								// 26-registro Gerado
							'',;								// 27-Produto
							0,;								// 28-Desconto
							TPEmitente})					// 29-Tipo Emitente <T> ou <P>
		end
	end
	dbskip()
end
return NIL

//----------------------------------------------------------------------------------
  static function CFEVLRE(pEmpr,P1,P2,P3,PERC_DESC,MODELO,VSERIE) // valores das entradas
//----------------------------------------------------------------------------------
local VLRS  :={{0,0,0,0,0,0,0}} // ISENTO PICMS = 0
local VALOR :=0
local X
if MODELO=='08' .or. MODELO=='02' // FRETE OU NOTA FISCAL SERIE =D=
	return VLRS
end
SALVABANCO
select('ENTDET')
dbseek(str(P1,8)+VSERIE,.T.)
while !eof().and.ED_DOCTO==P1.and.ED_SERIE==VSERIE
	if ED_CODFO==P3 // <<-------------------------Cod Fornecedor
		X:=ascan(VLRS,{|DET|str(DET[6],9,2)==str(ED_PCICM,9,2)})
		if X==0
			aadd(VLRS,{0,0,0,0,0,ED_PCICM})
			X:=len(VLRS)
		end
		VALOR    :=ED_VALOR-round(PERC_DESC*ED_VALOR,2)
		VLRS[X,1]+=VALOR													// Vlr Contabil
		VLRS[X,2]+=ED_BICMS												// Vlr Base Icms
		VLRS[X,3]+=ED_VLICM												//	Vlr Icms
		VLRS[X,4]+=ED_ISENT												// Vlr Isentos
		VLRS[X,5]+=ED_OUTRA												// Vlr Outras
		if PROD->(dbseek(str(ENTDET->ED_CODPR,L_P)))
			GRFPROD(pEmpr)//.....................................GRAVA REGISTRO 75
			gravaDVS({	pEmpr,;				//  1-Empresa
							54,;							//  2-PRODUTO
							ENTCAB->EC_DTENT,;		//  3-Data emissao
							CGC,;							//  4-CGC fornec
							INSCR,;						//  5-INSCR fornec
							CLIENTE->CL_UF,;			//  6-UF DO fornec
							MODELO,;						//  7-Modelo
							SERIE,;						//  8-Serie NF
							'',;							//  9-Subserie
							val(right(pb_zer(ENTCAB->EC_DOCTO,8),6)),;	// 10-NR NOTA FISCAL
							val(left(str(ENTCAB->EC_CODOP,7),4)),;// 11-NAT OPERACAO
							VALOR,;						// 12-TOTAL NF/ALIQUOTA
							ED_BICMS,;					//	13-BASE ICMS
							ED_VLICM,;					// 14-VLR ICMS
							ED_ISENT,;					// 15-VLR ISENTAS
							ED_OUTRA,;					// 16-VLR OUTRAS
							ED_PCICM,;					// 17-% ICMS
							SITUA,;						// 18-SITUACAO DA NF
							max(ENTCAB->TR_TIPO,1),;// 19-MODO CIF
							ED_ORDEM,;					// 20-ITEM NF
							ED_CODPR,;					// 21-COD PROD
							ED_CODTR,;					// 22-SIT TRIB
							PROD->PR_UND,;				// 23-UNIDADE
							ED_QTDE,;					// 24-QTDADE
							ED_IPI,;						// 25-VLR IPI
							'G',;							// 26-Registro Gerado
							'',;							// 27-Produto
							0,;							// 28-Desconto
							TPEmitente})				// 29-Tipo Emitente <T> ou <P>
		end
	end
	dbskip()
end
RESTAURABANCO
return VLRS
//--------------------------------------------------------EOF