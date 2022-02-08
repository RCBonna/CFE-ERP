*-----------------------------------------------------------------------------*
 static aVariav := {.T.,{},{}}
 //..................1...2..3..4..5.6
*-----------------------------------------------------------------------------*
#xtranslate lRT      => aVariav\[  1 \]
#xtranslate EMITENTE	=> aVariav\[  2 \]
#xtranslate TOMADOR	=> aVariav\[  3 \]

#INCLUDE 'RCB.CH'
*-----------------------------------------------------------------------------*
function GDFPCFES(lNFS,pEmpr)
*-----------------------------------------------------------------------------*
local VLRS:={}
pb_msg('Saidas:')
select('PEDCAB')
ORDEM DTEPED
DbGoTop()
dbseek(dtos(DATA[1]),.T.)
while !eof().and.PC_DTEMI<=DATA[2]
	@24,60 say dtoc(PC_DTEMI)+'>'+str(PC_PEDID,8)
	NATOP->(dbseek(str(PEDCAB->PC_CODOP,7)))
	SERIE   :=upper(PEDCAB->PC_SERIE)
	if (PC_DTEMI>=DATA[1].and.;
		 PC_DTEMI<=DATA[2].and.;
		 PC_FLAG).and.!(lNFS=='N'.and.SERIE=='NPS')
		
		VLRS:={}
		* 
		CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
		CGC   :=SONUMEROS(CLIENTE->CL_CGC)
		INSCR :='ISENTO'

		TPEmitente:='P' // Terceiro ou Próprio

		if len(trim(CLIENTE->CL_CGC))>11
			CGC  :=SONUMEROS(CLIENTE->CL_CGC)
			if left(upper(CLIENTE->CL_INSCR),6)#'ISENTO'
				INSCR:=SONUMEROS(CLIENTE->CL_INSCR)
			end
		end
		MODELO  :=verserie(SERIE,PC_PEDID)
		if MODELO$'06..21..22..'
			SERIE:='U  '
		end
		SITUA    :=if(PC_FLCAN,'S','N')
		VLRS     :=CfeVlrs(pEmpr,PEDCAB->PC_PEDID,MODELO)
		TIPO     :=50
		if MODELO=='02'	// NF D2
			TIPO  :=61
		elseif MODELO=='08' // FRETE
			TIPO  :=70
		end
		Y:=1
		if TIPO==50
			for X:=Y to len(VLRS)
				if VLRS[X,1]+VLRS[X,2]+VLRS[X,3]+VLRS[X,4]+VLRS[X,5] > 0.00
					gravaDVS({pEmpr,;				//  1-Empresa
								TIPO,;						//  2-TIPO DE REGISTRO
								PC_DTEMI,;					//  3-Data emissao
								CGC,;							//  4-CGC Cliente
								INSCR,;						//  5-INSCR Cliente
								CLIENTE->CL_UF,;			//  6-UF DO Cliente
								MODELO,;						//  7-Modelo
								SERIE,;						//  8-Serie NF
								'  ',;						//  9-Subserie
								PC_NRNF,;					// 10-NR NOTA FISCAL
								val(left(str(PEDCAB->PC_CODOP,7),4)),;// 11-NAT OPERACAO
								VLRS[X,1],;					// 12-TOTAL NF/ALIQUOTA
								VLRS[X,2],;					//	13-BASE ICMS
								VLRS[X,3],;					// 14-VLR ICMS
								VLRS[X,4],;					// 15-VLR ISENTAS
								VLRS[X,5],;					// 16-VLR OUTRAS
								VLRS[X,6],;					// 17-% ICMS
								SITUA,;						// 18-SITUACAO DA NF
								1,;							// 19-MODO CIF
								0,;							// 20-ITEM NF
								0,;							// 21-COD PROD
								'',;							// 22-SIT TRIB
								'',;							// 23-UNIDADE
								0,;							// 24-QTDADE
								0,;							// 25-VLR IPI
								'G',;							// 26-registro Gerado
								'',;							// 27-Descricao Prod
								0,;							// 28-
								TPEmitente})				// 29-Tipo Emitente <T> ou <P>
				end
			next
			//------------------------------------------------FIM DESCONTO
		elseif TIPO==61
			gravaDVS({pEmpr,;						//  1-Empresa
						TIPO,;						//  2-TIPO
						PC_DTEMI,;					//  3-Data emissao
						CGC,;							//  4-CGC Cliente
						INSCR,;						//  5-INSCR Cliente
						CLIENTE->CL_UF,;			//  6-UF DO Cliente
						MODELO,;						//  7-Modelo
						SERIE,;						//  8-Serie NF
						'',;							//  9-Subserie
						PC_NRNF,;					// 10-NR NOTA FISCAL
						val(left(str(PEDCAB->PC_CODOP,7),4)),;// 11-NAT OPERACAO
						PC_TOTAL-PC_DESC,;		// 12-TOTAL NF/ALIQUOTA
						0,;							//	13-BASE ICMS
						0,;							// 14-VLR ICMS
						0,;							// 15-VLR ISENTAS
						0,;							// 16-VLR OUTRAS
						0,;							// 17-% ICMS
						SITUA,;						// 18-SITUACAO DA NF
						1,;							// 19-MODO CIF
						0,;							// 20-ITEM NF
						0,;							// 21-COD PROD
						'',;							// 22-SIT TRIB
						'',;							// 23-UNIDADE
						0,;							// 24-QTDADE
						0,;							// 25-VLR IPI
						'G',;							// 26-registro Gerado
						'',;							// 27-Descricao Prod
						0,;							// 28-Desconto
						TPEmitente})				// 29-Tipo Emitente <T> ou <P>
	
		elseif TIPO==70
			EMITENTE:={'','',''}
			TOMADOR :={'','','','','','',0}
			* 
			EMITENTE[1]:=SONUMEROS(PARAMETRO->PA_CGC)
			EMITENTE[2]:=SONUMEROS(PARAMETRO->PA_INSCR)
			EMITENTE[3]:=          PARAMETRO->PA_UF

			TOMADOR[7]:=val(substr(PEDCAB->PC_CFRETE, 1, 5))		// Cod Cliente NF acoberta frete
			CLIENTE->(dbseek(str(TOMADOR[7],5)))
			TOMADOR[1]:=SONUMEROS(CLIENTE->CL_CGC) // CGC OU CPF
			TOMADOR[2]:='ISENTO'
			TOMADOR[3]:=CLIENTE->CL_UF
			TOMADOR[4]:=val(substr(PEDCAB->PC_CFRETE, 6, 6))		// Nr nf acoberta frete
			TOMADOR[5]:=substr(PEDCAB->PC_CFRETE,    12, 3)		// Serie nf acoberta frete
			TOMADOR[6]:=val(substr(PEDCAB->PC_CFRETE,15,14))/100 // Valor NF acoberta frete

			if CLIENTE->CL_TIPOFJ=='J'
				if left(upper(CLIENTE->CL_INSCR),6)#'ISENTO'
					TOMADOR[2]:=SONUMEROS(CLIENTE->CL_INSCR)
				end
			end
		
			gravaDVS({	pEmpr,;									//  1-Empresa
							TIPO,;									//  2-TIPO
							PEDCAB->PC_DTEMI,;					//  3-Data Emissao
							EMITENTE[1],;							//  4-CGC Emitente
							EMITENTE[2],;							//  5-INSCR Emitente
							EMITENTE[3],;							//  6-UF Emitente (Coolacer)
							MODELO,;									//  7-Modelo
							SERIE,;									//  8-Serie NF
							'',;										//  9-Subserie
							PEDCAB->PC_NRNF,;						// 10-NR NOTA FISCAL
							val(left(str(PEDCAB->PC_CODOP,7),4)),;// 11-NAT OPERACAO
							PC_TOTAL-PC_DESC,;					// 12-TOTAL NF/ALIQUOTA
							PEDCAB->TR_BICMS,;					//	13-BASE ICMS
							PEDCAB->TR_VICMS,;					// 14-VLR ICMS
							max(PC_TOTAL-PC_DESC-TR_BICMS,0),;// 15-VLR ISENTAS
							0,;										// 16-VLR OUTRAS
							PEDCAB->TR_PICMS,;					// 17-% ICMS
							SITUA,;									// 18-SITUACAO DA NF
							max(PEDCAB->TR_TIPO,1),;			// 19-MODO CIF
							0,;										// 20-ITEM NF
							0,;										// 21-COD PROD
							'',;										// 22-SIT TRIB
							'',;										// 23-UNIDADE
							0,;										// 24-QTDADE
							0,;										// 25-VLR IPI
							'G',;										// 26-registro Gerado
							'',;										// 27-Descricao Prod
							0,;										// 28-
							TPEmitente})							// 29-Tipo Emitente <T> ou <P>
			
			gravaDVS({	pEmpr,;									//  1-Empresa
							71,;										//  2-TIPO = 71
							PC_DTEMI,;								//  3-Data emissao
							EMITENTE[1],;							//  4-CGC Emitente
							EMITENTE[2],;							//  5-INSCR Emitente
							EMITENTE[3],;							//  6-UF Emitente (Coolacer)
							MODELO,;									//  7-Modelo
							SERIE,;									//  8-Serie NF
							'',;										//  9-Subserie
							PC_NRNF,;								// 10-NR NOTA FISCAL
							val(left(str(PEDCAB->PC_CODOP,7),4)),;// 11-NAT OPERACAO
							PC_TOTAL-PC_DESC,;					// 12-TOTAL NF/ALIQUOTA
							TR_BICMS,;								//	13-BASE ICMS
							TR_VICMS,;								// 14-VLR ICMS
							max(PC_TOTAL-PC_DESC-TR_BICMS,0),;// 15-VLR ISENTAS
							0,;										// 16-VLR OUTRAS
							TR_PICMS,;								// 17-% ICMS
							SITUA,;									// 18-SITUACAO DA NF
							max(TR_TIPO,1),;						// 19-MODO CIF
							0,;										// 20-ITEM NF
							0,;										// 21-COD PROD
							'',;										// 22-SIT TRIB
							'',;										// 23-UNIDADE
							0,;										// 24-QTDADE
							0,;										// 25-VLR IPI
							'G',;										// 26-registro Gerado
							'',;										// 27-Descricao Prod
							0,;										// 28-
							TPEmitente,;							// 29-Tipo Emitente <T> ou <P>
							TOMADOR[1],;							// 30-CGC-Tomador -> só para reg 71
							TOMADOR[2],;							// 31-IE-Tomador -> só para reg 71
							TOMADOR[3],;							// 32-UF-Tomador Do Conhecimento de Frete-> só para reg 71
							TOMADOR[4],;							// 33-71-Número NF-Levada no conhecimento de Frete
							TOMADOR[5],;							// 34-71-Série NF-Levada no conhecimento de Frete
							TOMADOR[6]})							// 35-71-Valor NF-Levada no conhecimento de Frete
		end
	end
	dbskip()
end
return NIL

*-----------------------------------------------------------------------------*
 static function CFEVLRS(pEmpr,P1,MODELO) // Valores Saidas
*-----------------------------------------------------------------------------*
local VLRS :={{0,0,0,0,0,0,0}} // ISENTO PICMS = 0
local VALOR:=0
local X
if MODELO=='08' .or. MODELO=='02' //....FRETE --- NF TIPO "D"
	return VLRS
end
salvabd(SALVA)
select('PEDDET')
dbseek(str(P1,6),.T.)
while !eof().and.PD_PEDID==P1
	X:=ascan(VLRS,{|DET|DET[6]==PD_ICMSP})
	if X==0
		aadd(VLRS,{0,0,0,0,0,PD_ICMSP})
		X:=len(VLRS)
	end
	VALOR    :=round(PD_QTDE*PD_VALOR,2)
	VLRS[X,1]+=VALOR											// Vlr Contabil
	VLRS[X,2]+=PD_BAICM										//	Vlr Base Icms
	VLRS[X,3]+=PD_VLICM										//	Vlr Icms
	VLRS[X,4]+=PD_VLRIS										// Vlr Isentas
	VLRS[X,5]+=PD_VLROU										// Vlr Outras
	if PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))//............PROCURAR ITEM
		GRFPROD(pEmpr)//..................................GRAVAR REGISTRO TIPO 75 (PRODUTOS USADOS)
		gravaDVS({pEmpr,;										//  1-Empresa
				54,;														//  2-Tipo Registro
				PEDCAB->PC_DTEMI,;									//  3-Data emissao
				CGC,;														//  4-CGC Cliente
				INSCR,;													//  5-INSCR Cliente
				CLIENTE->CL_UF,;										//  6-UF DO Cliente
				MODELO,;													//  7-Modelo
				SERIE,;													//  8-Serie NF
				'',;														//  9-Subserie
				PEDCAB->PC_NRNF,;										// 10-NR NOTA FISCAL
				val(left(str(PEDCAB->PC_CODOP,7),4)),;			// 11-NAT OPERACAO
				VALOR,;													// 12-TOTAL NF/ALIQUOTA
				PD_BAICM,;												//	13-BASE ICMS
				PD_VLICM,;												// 14-VLR ICMS
				PD_VLRIS,;												// 15-VLR ISENTAS
				PD_VLROU,;												// 16-VLR OUTRAS
				PD_ICMSP,;												// 17-% ICMS
				SITUA,;													// 18-SITUACAO DA NF
				max(PEDCAB->TR_TIPO,1),;							// 19-MODO CIF
				PD_ORDEM,;												// 20-SEQ.ITEM NF
				PD_CODPR,;												// 21-COD PRODUTO
				PD_CODTR,;												// 22-SIT TRIB
				PROD->PR_UND,;											// 23-UNIDADE
				PD_QTDE,;												// 24-QTDADE
				0,;														// 25-VLR IPI
				'G',;														// 26-Registro Gerado
				'',;														// 27-DESCRICAO PRODUTO
				PD_DESCG,;												// 28-DESCONTO
				''})
	end
	dbskip()
end
salvabd(RESTAURA)
return VLRS
