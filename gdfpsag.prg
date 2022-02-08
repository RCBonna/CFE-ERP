#include 'RCB.CH'
*--------------------------------------------------------------------------*
 function GDFPSAG(lNFS)
*--------------------------------------------------------------------------*
private SITUA    :='N'
private SERIE    :=''
pb_msg('SAG : Entradas/Saidas:')
select CLIENTE
ORDEM CODIGO
select('NFD')
ORDEM CODIGO
select('NFC')
ORDEM DATA
DbGoTop()
dbseek(dtos(DATA[1]),.T.)
while !eof().and.NFC->NF_DTEMI<=DATA[2]
	@24,55 say dtoc(NFC->NF_DTEMI)+'/'+NFC->NF_TIPO+'/'+NFC->NF_SERIE+'/'+str(NFC->NF_NRNF,6)
	if !CLIENTE->(dbseek(str(NFC->NF_EMIT,5)))
		alert('Erro Ao processar GDF-SAG;Cliente '+str(NFC->NF_EMIT,5)+' nao encontrado no cadastro.')
	end
	if !NATOP->  (dbseek(str(NFC->NF_CODOP,7)))
		alert('Erro Ao processar GDF-SAG;Natureza '+str(NFC->NF_CODOP,7)+' nao encontrado no cadastro.')
	end
	if lNFS=='S'.or.(lNFS=='N'.and.NATOP->NO_TIPO#'O')
		GDFPSAGX()
	end
	dbskip()
end
return NIL


*-----------------------------------------------------------------------------*
 function GDFPSAGX()
*-----------------------------------------------------------------------------*
	CGC       :=SONUMEROS(CLIENTE->CL_CGC)
	INSCR     :='ISENTO'
	TPEmitente:='T' // Terceiro ou Próprio
	if len(trim(CLIENTE->CL_CGC))>11
		if left(upper(CLIENTE->CL_INSCR),6)#'ISENTO'
			INSCR:=SONUMEROS(CLIENTE->CL_INSCR)
		end
	end
	*----------------------------------------------------------
	SERIE   :=upper(NFC->NF_SERIE)
	MODELO  :=VERSERIE(SERIE,NFC->NF_NRNF)
	TPEmitente:='P' // sempre próprio
	if MODELO$'06..08..22..' // CELESC-FRETE-TELESC
		SERIE:='U  '
	end
	VLRTOT  :=NFC->NF_VLRTOT-NFC->NF_VLRDESG-NFC->NF_VLRDESI
	VLRS    :=cfevlre(	NFC->NF_TIPO,;//	1
								NFC->NF_SERIE,;//	2
								NFC->NF_NRNF,;//	3
								MODELO,;//			4-
								)//					5-
	TIPO    :=50
	if MODELO=='02'	// NF D2
		TIPO  :=61
		CGC   :=''
		INSCR :='ISENTO'
	elseif MODELO=='08' // FRETE
		TIPO  :=70
	end
	Y:=1
	if len(VLRS)>1
		Y:=2
		for X:=1 to 6
			VLRS[2,X]+=VLRS[1,X]
		next
	else // SO TEM UMA
		if str(VLRS[1,1]+VLRS[1,2]+VLRS[1,3]+VLRS[1,4]+VLRS[1,5]+VLRS[1,6],15,2)==str(0,15,2)
			VLRS[1,1]:=VLRTOT
			VLRS[1,2]:=NFC->NF_BASICMS
			VLRS[1,3]:=NFC->NF_VLRICMS
			VLRS[1,4]:=max(VLRTOT-NFC->NF_BASICMS,0)	// ISENTAS
			VLRS[1,5]:=0.00									// OUTRAS
			VLRS[1,6]:=NFC->NF_PERICMS
		end
	end
	SITUA    :='N'
	if TIPO == 50 
		for X:=Y to len(VLRS)
			if VLRS[X,1]+VLRS[X,2]+VLRS[X,3]+VLRS[X,4]+VLRS[X,5]+VLRS[X,6] > 0.00
				gravaDVS({1,;							//  1-Empresa
							TIPO,;						//  2-TIPO
							NFC->NF_DTEMI,;			//  3-Data Emissao
							CGC,;							//  4-CGC CLIENTE
							INSCR,;						//  5-INSCR CLIENTE
							CLIENTE->CL_UF,;			//  6-UF DO CLIENTE
							MODELO,;						//  7-Modelo
							SERIE,;						//  8-Serie NF
							'  ',;						//  9-Subserie
							NFC->NF_NRNF,;				// 10-NR NOTA FISCAL
							val(left(str(NFC->NF_CODOP,7),4)),;	// 11-NAT OPERACAO
							VLRS[X,1],;					// 12-TOTAL NF/ALIQUOTA
							VLRS[X,2],;					//	13-BASE ICMS
							VLRS[X,3],;					// 14-VLR ICMS
							VLRS[X,4],;					// 15-VLR ISENTAS
							VLRS[X,5],;					// 16-VLR OUTRAS
							VLRS[X,6],;					// 17-% ICMS
							SITUA,;						// 18-SITUACAO DA NF
							max(NFC->TR_TIPO,1),;	// 19-MODO CIF
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
	elseif TIPO==61 // SERIE D2
		for X:=Y to len(VLRS)
			if VLRS[X,1]+VLRS[X,2]+VLRS[X,3]+VLRS[X,4]+VLRS[X,5]+VLRS[X,6] > 0.00
				gravaDVS({1,;							//  1-Empresa
							TIPO,;						//  2-TIPO
							NFC->NF_DTEMI,;			//  3-Data emissao
							CGC,;							//  4-CGC FORNEC
							INSCR,;						//  5-INSCR FORNEC
							CLIENTE->CL_UF,;			//  6-UF DO FORNECEDOR
							MODELO,;						//  7-Modelo
							SERIE,;						//  8-Serie NF
							'',;							//  9-Subserie
							NFC->NF_NRNF,;				// 10-NR NOTA FISCAL
							val(left(str(NFC->NF_CODOP,7),4)),;	// 11-NAT OPERACAO
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
							'',;							// 27-Descricao Prod
							0,;							// 28-
							TPEmitente})				// 29-Tipo Emitente <T> ou <P>
			end
		next
	elseif TIPO==70
		gravaDVS({	1,;								//  1-Empresa
						TIPO,;							//  2-TIPO
						NFC->NF_DTEMI,;				//  3-Data Emissao
						CGC,;								//  4-CGC
						INSCR,;							//  5-INSCR
						CLIENTE->CL_UF,;				//  6-UF
						MODELO,;							//  7-Modelo
						SERIE,;							//  8-Serie NF
						'',;								//  9-Subserie
						NFC->NF_NRNF,;					// 10-NR NOTA FISCAL
						val(left(str(NFC->NF_CODOP,7),4)),;	// 11-NAT OPERACAO
						NFC->NF_VLRTOT-NFC->NF_VLRDESG-NF_VLRDESI,;	// 12-TOTAL NF/ALIQUOTA
						NFC->NF_BASICMS,;				//	13-BASE ICMS
						NFC->NF_ICMSV,;				// 14-VLR ICMS
						max(NFC->NF_VLRTOT-NFC->NF_VLRDESG-NF_VLRDESI-NFC->NF_BASICMS,0),;// 15-VLR ISENTAS
						0,;								// 16-VLR OUTRAS
						NFC->NF_PERICMS,;				// 17-% ICMS
						SITUA,;							// 18-SITUACAO DA NF
						max(NFC->TR_TIPO,1),;		// 19-MODO CIF
						0,;								// 20-ITEM NF
						0,;								// 21-COD PROD
						'',;								// 22-SIT TRIB
						'',;								// 23-UNIDADE
						0,;								// 24-QTDADE
						0,;								// 25-VLR IPI
						'G',;								// 26-registro Gerado
						'',;								// 27-Descricao Prod
						0,;								// 28-
						TPEmitente})					// 29-Tipo Emitente <T> ou <P>
	end

return NIL

//-----------------------------------------------------------------------------*
  static function CFEVLRE(VTIPO,VSERIE,VNRNF,MODELO) // valores das entradas
//-----------------------------------------------------------------------------*
local VLRS   :={{0,0,0,0,0,0,0}} // ISENTO PICMS = 0
local X
local BICMS:=0
local VALOR:=0

if MODELO=='08'.or.MODELO=='02'
	return VLRS
end

salvabd(SALVA)
select('NFD')
dbseek(VTIPO+VSERIE+str(VNRNF,6),.T.)
while !eof().and.NFD->ND_TIPO+NFD->ND_SERIE+str(NFD->ND_NRNF,6)==VTIPO+VSERIE+str(VNRNF,6)
	X:=ascan(VLRS,{|DET|DET[6]==NFD->ND_PERICMS})
	if X==0
		aadd(VLRS,{0,0,0,0,0,NFD->ND_PERICMS})
		X:=len(VLRS)
	end
	VALOR    :=NFD->ND_VLRTOT-NFD->ND_VLRDESP-NFD->ND_VLRDESI
	BICMS    :=NFD->ND_BASICMS										//	base icms
	VLRS[X,1]+=VALOR													// valor total
	VLRS[X,2]+=BICMS													// Soma base icms
	VLRS[X,3]+=NFD->ND_VLRICMS										//	Vlr icms
	VLRS[X,4]+=max(VALOR - BICMS, 0)								// isentos
	VLRS[X,5]:=0
	if PROD->(dbseek(str(NFD->ND_CODPR,L_P)))
		GRFPROD(1)
		gravaDVS({	1,;						//  1-Empresa
					54,;							//  2-PRODUTO
					NFC->NF_DTEMI,;			//  3-Data emissao
					CGC,;							//  4-CGC fornec
					INSCR,;						//  5-INSCR fornec
					CLIENTE->CL_UF,;			//  6-UF DO fornec
					MODELO,;						//  7-Modelo
					SERIE,;						//  8-Serie NF
					'',;							//  9-Subserie
					NFD->ND_NRNF,;				// 10-NR NOTA FISCAL
					val(left(str(NFC->NF_CODOP,7),4)),;// 11-NAT OPERACAO
					VALOR,;						// 12-TOTAL NF/ALIQUOTA
					BICMS,;						//	13-BASE ICMS
					NFD->ND_VLRICMS,;			// 14-VLR ICMS
					max(VALOR-BICMS,0),;		// 15-VLR ISENTAS
					0,;							// 16-VLR OUTRAS
					NFD->ND_PERICMS,;			// 17-% ICMS
					SITUA,;						// 18-SITUACAO DA NF
					max(NFC->TR_TIPO,1),;	// 19-MODO CIF
					NFD->ND_ORDEM,;			// 20-ITEM NF
					NFD->ND_CODPR,;			// 21-COD PROD
					NFD->ND_CODTR,;			// 22-SIT TRIB
					PROD->PR_UND,;				// 23-UNIDADE
					NFD->ND_QTDE,;				// 24-QTDADE
					NFD->ND_VLRIPI,;			// 25-VLR IPI
					'G',;							// 26-Registro Gerado
					'',;							// 27-Descricao Prod
					0,;							// 28-
					TPEmitente})				// 29-Tipo Emitente <T> ou <P>
	end
	dbskip()
end
salvabd(RESTAURA)
return VLRS
//----------------------------------------------EOF
