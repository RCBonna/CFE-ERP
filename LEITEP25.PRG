//-----------------------------------------------------------------------------*
  static aVariav := {0,0,'',{},{},'',0,.F.,0,''}
//...................1.2..3..4..5..6.7..8..9.10
//-----------------------------------------------------------------------------*
#xtranslate nTotLeite	=> aVariav\[  1 \]
#xtranslate nCodPr		=> aVariav\[  2 \]
#xtranslate cVlrAdi		=> aVariav\[  3 \]
#xtranslate aValidar		=> aVariav\[  4 \]
#xtranslate aValores		=> aVariav\[  5 \]
#xtranslate wObsP			=> aVariav\[  6 \]
#xtranslate nY				=> aVariav\[  7 \]
#xtranslate lRT			=> aVariav\[  8 \]
#xtranslate nPer			=> aVariav\[  9 \]
#xtranslate cArq			=> aVariav\[ 10 \]

#include 'RCB.CH'
#include 'ENTRADA.CH'

*-----------------------------------------------------------------------------*
 function LEITEP25() //Imprimir Nota Fiscal de Leite
*-----------------------------------------------------------------------------*
local aCampo

pb_lin4(_MSG_,ProcName())

if !abre({	'R->PARAMETRO'		,;
				'R->CLIENTE'		,;
				'C->PARALINH'		,;
				'C->PROD'			,;
				'C->MOVEST'			,;
				'C->DIARIO'			,;
				'C->ENTCAB'			,;
				'C->ENTDET'			,;
				'R->PEDCAB'			,; // Pesquisar NR.NF Devolução
				'R->PEDDET'			,; // Pesquisar ITENS Devolução
				'C->HISFOR'			,;
				'C->CTRNF'			,;
				'R->CODTR'			,;
          	'R->FISACOF'		,;
				'C->NATOP'			,;
				'C->XOBS'			,;
				'C->OBS'				,;
				'R->NCM'				,;
          	'C->PROFOR'			,;
          	'C->DPFOR'			,;
				'R->LEIPARAM'		,;		// Criado arquivo no LEITEP00.PRG
				'C->LEIVOL'			,;		// Valor Leite por Quantidade
				'C->LEIBON'			,;		// Dados de Adicionais Qualidade (% e Vlrs)
				'R->LEITRANS'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIMOTIV'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIVEIC'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIROTA'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEICPROD'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIDADOS'		;		// Criado arquivo no LEITEP00.PRG
			})
	return NIL
end
Select LEIBON
ORDEM PERCLI // Ordem Período + Cliente

Select PROD
ORDEM CODIGO	// Odem Codigo de Produto

SELECT LEIVEIC
ORDEM PLACA		// Ordem Placa Transportador

private;
	DADOC:={ PARAMETRO->PA_DATA,;		// 01-Data Emissão
				0,;							//	02-VM_DOCNF......= 2 DOC1
				1102009,;					//	03-Nat Oper NF...= 3 NNAT
				0,;							//	04-VLR NF........= 4 VNF
				0,;							//	05-Vlr IPI.......= 5
				0,;							//	06-Vlr Funrural..= 6
				0,;							//	07-Vlr ICMS......= 7
				0,;							//	08-VLR DESC......= 8
				{||DADOC[NVNF]-DADOC[NDES]-DADOC[NVIPI]},;	//	09-VLR LIQNF
				1,;							//	10-Parcelam.....=10 (1= A Prazo)
				10,;							//	11-Banco........=11
				0,;							//	12-Docto Parc...=12
				0,;							//	13-Fornecedor...=13
				0,;							//	14-%ICMS........=14
				'NF ',;						//	15-TP DOCTO.....=15
				'NFE',;						//	16-Serie........=16
				0.00,;						//	17-Base ICMS....=17
				0.00,;						//	18-Vlr Acessorio=18
				0,;							//	19-Código Caixa quando a Vista
				PARAMETRO->PA_DATA,;		// 20-Data Entrada
				'N',;							// 21-Adiantamento Fornecedor?
				Space(25),;					// 22-Observação para Livros Fiscais
				Padr('0',44,'0'),;		// 23-Chave NFE
				0.00,;						//	24-Valor Acessorio-Frete
				0.00,;						//	25-Valor Acessorio-Seguro
				0.00,;						//	26-Valor Acessorio-Outras Despesas
				0.00,;						//	27-Base ICMS ST
				0.00,;						//	28-Valor ICMS ST
				0.00,;						//	29-Valor Contábil
				Padr('0',44,'0');			//	30-Chave NFe - Quando Devolução
				}
				
private;
	DADOF:={ PARAMETRO->PA_DATA,;					//	FDT = 1
				0,;										//	FNF = 2
				0,;										//	FNAT= 3
				0,;										//	FVNF= 4
				0,;										//	FVICM=5
				0,;										//	FDES= 6
				{||DADOF[FVNF]-DADOF[FVICMS]},;	//	FLIQ= 7
				{||pb_divzero(eval(DADOF[FLIQ]),eval(DADOC[NLIQ]))},;// % FRETE..= FPERC 8
				0,;		// 09-PARCELAMENTO (0=a vista)
				0,;		// 10-CODIGO DO BANCO
				0,;		// 11-DOCUMENTO DO PARCELAMENTO
				0,;		// 12-COD FORNECEDOR
				0,;		// 13-% ICMS FRETE
				0,;		// 14-
				'CF ',;	// 15-TIPO DE DOCUMENTO
				'   ',;	// 16-Serie Documento
				0,;		//	17-Base Icms
				0,;		//	18-NADA
				0,;		//	19-Codigo Caixa quando a vista
				PARAMETRO->PA_DATA,;//20-Data
				'N'}       //21-Nao é adiantamento
private;
	DADOPC:={}	// parcelas do cabecalho
private;
	DADOPF:={}	// parcelas do Frete
private;
	VM_FLADTO:="N" // Não é adiantamento
private;
	I_TRANS:=CFEPTRANL() // dados do transportador

dbgobottom()
dbskip()

X			:=6
CodPr  	:=LEIPARAM->LP_PROD		// Código Leite - dos parâmetros
nPer   	:=LEIPARAM->LP_PERIODO	// AAAAMM-Left(dtos(PARAMETRO->PA_DATA),6) // Periodo
dLctos 	:={Bom(CtoD('01/'+SubStr(nPer,5,2)+'/'+SubStr(nPer,1,4))),;
				Eom(CtoD('20/'+SubStr(nPer,5,2)+'/'+SubStr(nPer,1,4)))}
dLctos[1]-- // Inicio do mes MENOS 1 DIA
dLctos[2]--	// Fim do mes MENOS 1 DIA

dData	 	:={Date(),Eom(Date())}
cArq   	:=''
aValidar	:={}
NATOP  	:=DADOC[NNAT ]
TSERIE 	:=DADOC[SERIE]
TIPODOC	:=DADOC[TPDOC]
CDT 	   :='051' // Código tributário
PROD->(dbseek(str(CodPr,L_P))) // Achar produto

//----------------------------------------------buscar Valores por Quantidade
Select LEIVOL
DbGoTop()
aValores:={}
while !eof()
	aadd(aValores,{'Leite '+Str(VL_QTLIT1,5)+' - '+Str(VL_QTLIT2,5),VL_VLRPLT,RecNo()})
	skip
end

wObsP	:= padr(PLinha('OBS p/ NF Leite',space(132)),132)

pb_box(,,,,,'Informe Dados de Selecao')
//@X  ,02 say 'Data Inicial:' Get DATA[1] pict mDT                             when pb_msg('Informe Data do Inicio do Mes. Sera considerado um dia anterior da data informada para gerar a NF')
//@X  ,28 say 'Data Final..:' Get DATA[2] pict mDT      valid DATA[1]<=DATA[2] when pb_msg('Informe Data Final do Mes. Sera considerado um dia anterior da data informada para gerar a NF')
@X  ,02 say 'Periodo.:'     Get nPer		pict mPER
@X++,54 say 'Data NFe....:' Get dData[1]	pict mDT
@X  ,02 say 'Nat.Operacao:' Get NATOP		pict mNAT     valid fn_codigo(@NATOP,{'NATOP',{||NATOP->(dbseek(str(NATOP,7)))},{||CFEPNATT(.T.)},{2,1}}).and.NATOP->NO_TIPO='E'.and.right(str(NATOP,8),1)=='9'
@X++,54 say 'Data Vencto.:' Get dData[2]	pict mDT
@X++,02 say 'Cod.Produto.: '+Str(CodPr,L_P)+'-'+PROD->PR_DESCR color 'GR+/G,GR+/B'
@X  ,02 say 'Serie.......:' Get TSERIE		pict mUUU     valid fn_codigo(@TSERIE,{'CTRNF',{||CTRNF->(dbseek(TSERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}})
@X++,54 say 'Periodo Ini.: ' +DtoC(dLctos[1]) 						color 'GR+/G,GR+/B'
@X  ,02 say 'Tipo Docto..:' Get TIPODOC	pict mUUU     valid fn_codar(@TIPODOC,'TP_DOCTO.ARR') when (CDT:=PROD->PR_CODTRE)>=''
@X++,54 say 'Periodo Fim.: ' +DtoC(dLctos[2])						color 'GR+/G,GR+/B'
@X++,02 say 'Cod.Tributar:' Get CDT			pict mI3      valid fn_codigo(@CDT,{'CODTR',{||CODTR->(dbseek(CDT))},{||NIL},{2,1,3}}) when pb_msg('Codigo Tributario para este Produto')
@X++,02 say 'Obs Padrao..:' Get wObsP		pict mXXX+'S60'
 X++
pb_box(X,0,X+8,66,,'Valores por Faixa-Tabela')
 X++
for nY:=1 to len(aValores)
	@X  ,02 say aValores[nY  ,1]+Space(3)+Transform(aValores[nY  ,2],mI64) color 'GR+/G,GR+/B'
	if nY+1 <= Len(aValores)
		@X++,37 say aValores[nY+1,1]+Space(3)+Transform(aValores[nY+1,2],mI64) color 'GR+/G,GR+/B'
	end
	nY++
next
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)

	SLinha('OBS p/ NF Leite',padr(wObsP,300))
	
	DADOC[NNAT ]:=NATOP
	DADOC[SERIE]:=TSERIE

	if CriaTmpLeite() 	// Criar tabela interna de Leite
		AcumularLeiteN()	// Aculular VLR por Cliente
		CalculaVlrLeite()	// Calcular VLR das variaveis de leite
		aCont :={'Produtor','Qtdade','VlUnit','VlTotal','Status','Obs'}
		aCampo:={'str(WORK->WK_CDCLI,5)+chr(45)+left(CLIENTE->CL_RAZAO,25)',;
					'WORK->WK_QTDTOT',;			//...................Quantidade Total
					'WORK->WK_VLUNIT',;			//...................Vlr Unitário
					'WORK->WK_VLTOT',;			//...................Vlr Total
					'left(WK_STATUS,8)',;		//...................Imprime ou Não
					'left(WORK->WK_CARAC,50)';	//...................Obaservação
					}
		select WORK
		set relation to str(WORK->WK_CDCLI,5) into CLIENTE
		DbGoTop()
		while .T.
			pb_msg('<Enter> Mudar Situacao (Imprimir/Nao Imprimir)    <ESC> para Imprime')
			@23,62 say 'Total:'+transform(nTotLeite,mI102) color 'W*+/B'
			setcolor('W/B')
			pb_box(7,0,22,79,'W/B','Selecione')
			dbedit(8,1,21,78,aCampo,,{mXXX,mI6,mI64,mD52,mXXX,mXXX},aCont)
			if lastkey()==K_ENTER
				if left(WORK->WK_STATUS,8) == 'Imprimir'
					replace WORK->WK_STATUS with ''
				else
					replace WORK->WK_STATUS with 'Imprimir'
				end
				skip
			end
			if lastkey()==K_ESC
				exit
			end
		end
		//-------------------------------------------Imprimir
		if pb_sn('Imprimir Notas Fiscais de Entrada de Leite;Para a selecao acima ?')
			I_TRANS[05]:=2 // Tipo de frete FOB por conta do destinatário
			I_TRANS[10]:=1	// Quantidade de Embalagens
			I_TRANS[11]:='Leite in natura'
			I_TRANS[12]:='Sem Marca'
			I_TRANS[13]:=0	// Peso Bruto   = É a quantidade de leite
			I_TRANS[14]:=0	// Peso Liquido = É a quantidade de leite
//			I_TRANS:=CFEPTRANE(I_TRANS,.F.,'E') // Digitar Dados do transportador (Não Peso L/B,Qtd, Especie,Marca)
			DbGoTop()
			NATOP->(dbseek(str(NATOP,7)))
			while !eof()
				if left(WORK->WK_STATUS,8) == 'Imprimir'
					CLIENTE->(dbseek(str(WORK->WK_CDTRAN,5)))	// Transportador=Buscar Dados
					I_TRANS[01]:=CLIENTE->CL_RAZAO	// Transportador=Nome
					I_TRANS[02]:=CLIENTE->CL_ENDER	// Transportador=Endereço
					I_TRANS[03]:=CLIENTE->CL_CIDAD	// Transportador=Cidade
					I_TRANS[04]:=CLIENTE->CL_UF		// Transportador=UF
					I_TRANS[08]:=CLIENTE->CL_CGC		// Transportador=CGC
					I_TRANS[09]:=CLIENTE->CL_INSCR	// Transportador=Inscr
					
					I_TRANS[06]:=WORK->WK_PLACA		// Placa Caminhão
					I_TRANS[07]:=WORK->WK_UFPLACA		// Transportador=UF
					I_TRANS[13]:=WORK->WK_QTDTOT		// Peso Bruto   = É a quantidade de leite
					I_TRANS[14]:=WORK->WK_QTDTOT		// Peso Liquido = É a quantidade de leite
					I_TRANS[15]:=WORK->WK_CDTRAN		// Cod.Fornecedor de transporte é Coolacer Matriz
										
					CLIENTE->(dbseek(str(DADOC[NFOR],5)))
					DADOC[NFOR ]   :=WORK->WK_CDCLI	// Cod Produtor
					FORNEC         :=DADOC[NFOR ]		// Para Nota Fiscal
					PRODUTOS       :=DetProdEnt('I') // Inicializar Matriz de Produtos
					PRODUTOS[01,01]:=1				// SEQ
					PRODUTOS[01,02]:=CodPr
					PRODUTOS[01,03]:=padr(PROD->PR_DESCR,40)
					PRODUTOS[01,04]:=WORK->WK_QTDTOT	// Qtdade Total
					PRODUTOS[01,05]:=WORK->WK_VLTOT	// Valor Total
					PRODUTOS[01,06]:=WORK->WK_VLUNIT // Vlr Unitário
					PRODUTOS[01,07]:=0				// Pipi
					PRODUTOS[01,08]:=0				// Vipi
					PRODUTOS[01,09]:=0				// Picms
					PRODUTOS[01,10]:=0				// Vicms
					PRODUTOS[01,11]:=0				// Desc
					PRODUTOS[01,12]:=0				// Desc
					PRODUTOS[01,13]:=PROD->PR_UND	// Desc
					PRODUTOS[01,14]:=CDT				// Cod Trib
					PRODUTOS[01,15]:=0				// 
					PRODUTOS[01,16]:=0				// 
					PRODUTOS[01,17]:=0				// CCONTABIL
					PRODUTOS[01,18]:=NATOP			// Cod.NatOperac
					PRODUTOS[01,19]:=0
					PRODUTOS[01,20]:=0
					PRODUTOS[01,21]:=WORK->WK_VLTOT
					PRODUTOS[01,22]:=PROD->PR_CODCOE // Código Pis+Cofins <Entrada>
					
					if NATOP->NO_FLPISC=='S' // Considerar no PIS+COFINS
						SALVABANCO
						select FISACOF
						if dbseek(PRODUTOS[X,22]+CLIENTE->CL_TIPOFJ)
							PRODUTOS[X,23]:=Trunca((PRODUTOS[X,05]-PRODUTOS[X,08])*FISACOF->CO_PERC1/100,2)
							PRODUTOS[X,24]:=Trunca((PRODUTOS[X,05]-PRODUTOS[X,08])*FISACOF->CO_PERC2/100,2)
						else
							PRODUTOS[X,23]:=0
							PRODUTOS[X,24]:=0
						end
						RESTAURABANCO
					end
					SomProdEnt()
					DADOC[NDT ]		:=dDATA[1]
					DADOC[NDT1]		:=dDATA[1]
					DADOC[NNF ]    :=fn_psnf(DADOC[SERIE]) // Número NFe
					DADOC[NDOC]    :=DADOC[NNF]
					DADOC[TPDOC]   :=TIPODOC
					DADOC[NVNF]    :=PRODUTOS[01,05]
					DADOC[BICMS]   :=0
					DADOC[NVFUNR]  :=round((DADOC[NVNF]-DADOC[NDES])*PARAMETRO->PA_FUNRUR/100,2)
					DADOPC         :={}
					aadd(DADOPC,{DADOC[NNF ]*100,;
									 dDATA[2],; // ctod('10/'+right(dtoc(addmonth(DADOC[NDT1],1)),7)),; // Dt Vencto
									 DADOC[NVNF]-DADOC[NVFUNR]-DADOC[NDES]})
					NATOP->  (dbseek(str(DADOC[NNAT],7)))

					CONTINUAR:=CFEP441I({	WORK->WK_CARAC,;
													if(WORK->WK_VLVOLU>0,;
													' Vlr.Faixa:R$'			+str(WORK->WK_VLVOLU,6,4),'')+;
													' Adic.Gordura('			+str(WORK->WK_GORDUR,6,2)	+; // 10-Per Adic Gordura
																		'%): R$'	+str(WORK->WK_VLGORD,6,4)	+;	// 16-Vlr Adic.Gordura
													' Adic.Proteina('			+str(WORK->WK_PROTEI,6,2)	+;	// 11-Per Adic.Proteina
																		'%): R$'	+str(WORK->WK_VLPROT,6,4)	+;	// 17-Vlr Adic.Proteina
													' Adic.ESD.('				+str(WORK->WK_ESD,	6,2)	+;	// 12-Per Adic.ESD
																		'%): R$'	+str(WORK->WK_VLESD, 6,4)	+;	// 18-Vlr Adic.ESD
													' Adic.CCS.('				+str(WORK->WK_NRCCS,   5)	+;	// 13-Nr. Adic.CCS
																		'): R$'	+str(WORK->WK_VLCCS, 7,4)	+;	// 19-Vlr Adic.CCS
													' Adic.CPP.('				+str(WORK->WK_NRCPP,	  5)	+;	// 14-Nr. Adic.CPP
																		'): R$'	+str(WORK->WK_VLCPP, 7,4)	+;	// 20-Vlr Adic.CPP
													if(WORK->WK_VLBONU>0,;
													' Bonificacao:R$'		 +str(WORK->WK_VLBONU,6,4),'');	// 15-Vlr Adic Bonus
												})
					if CONTINUAR[1]
						CFEP441G1(CONTINUAR) // Gravar Dados NFe Entrada
					else
						if pb_sn('Voce deseja encerrar todo resto esta impressao ?')
							select WORK
							dbgobottom()
						end
					end
					select WORK
				end
				skip
				//-----------------------------------------------------------------------
			end
		end
		close
	end
end
dbcloseall()
if len(cArq)>0 // Precisa ter conteúdo para deletar os arquivos temporários
	FileDelete (cArq + '.*')
end
return NIL

*-----------------------------------------------------------------------------*
*------------------------NOVO SISTEMA DE LEITE--------------------------------*
*-----------------------------------------------------------------------------*
	static function AcumularLeiteN() // Novo arquivo de dados de LEITE 			*
*-----------------------------------------------------------------------------*
pb_msg('Acumulando Quantidade Leite...')
select LEIVEIC
ORDEM PLACA
select LEIDADOS
ORDEM DTCLI // Data + Cliente
DbGoTop()
dbseek(dtos(dLctos[1]),.T.)
while !eof().and.			LEIDADOS->LD_DTCOLET<=dLctos[2]	// Validar período
	@24,68 say DtoC(		LEIDADOS->LD_DTCOLET)				// Acompanhamento - Mostrar Data
	LEIVEIC->(dbseek(		LEIDADOS->LD_PLACA))					// Buscar Cod Transportador
	CLIENTE->(dbseek(str(LEIDADOS->LD_CDCLI,5)))				// Buscar Vlrs Ad do Cliente
	
	LEIBON->(DbSeek(nPer+Str(LEIDADOS->LD_CDCLI,5))) // Pesquisar Qualidade do Cliente na Anpalise
	aAdicQualidade:={;
							{LEIBON->CB_GORDUR,LEIBON->CB_VLGORD},;	// 1
							{LEIBON->CB_PROTEI,LEIBON->CB_VLPROT},;	// 2
							{LEIBON->CB_ESD	,LEIBON->CB_VLESD	},;	// 3
							{LEIBON->CB_NRCCS	,LEIBON->CB_VLCCS	},;	// 4
							{LEIBON->CB_NRCPP	,LEIBON->CB_VLCPP	},;	// 5
							{LEIBON->CB_NRNFPR,0	};							// 6-Nr NF Produtor
						}

	*--------------------------------------------------------------------------*
	select WORK
	if !WORK->(dbseek(str(LEIDADOS->LD_CDCLI,5)))// Não Está Gravado (Criar)
		AddRec(,{	LEIDADOS->LD_CDCLI,;				// 01-Cod Cliente
						abs(LEIDADOS->LD_VOLTANT),;	// 02-Quantidade (Inicial)
						0,;									// 03-Vlr Unitário NFe
						0,;									// 04-Vlr Total NFe
						'Imprimir',; 						// 05-Status
						LEIDADOS->LD_CDROTA,;			// 06-Cod Rota
						LEIDADOS->LD_PLACA,;				// 07-Placa Caminhão
						LEIVEIC->LV_UFPLACA,;			// 08-UF-Placa Caminhão
						LEIVEIC->LV_CDTRAN,;				// 09-Cod Transportador
						0,;									// 10-Vlr Ref Volume (Unit)						
						aAdicQualidade[1,1],;			// 11-Per.Adic.Gordura------
						aAdicQualidade[2,1],;			// 12-Per.Adic.Proteina
						aAdicQualidade[3,1],;			// 13-Per.Adic.E.S.D.
						aAdicQualidade[4,1],;			// 14-Per.Adic.C.C.S.
						aAdicQualidade[5,1],;			// 15-Per.Adic.C.P.P.
						aAdicQualidade[1,2],;			// 16-Vlr.Adic.Gordura-------
						aAdicQualidade[2,2],;			// 17-Vlr.Adic.Proteina
						aAdicQualidade[3,2],;			// 18-Vlr.Adic.E.S.D.
						aAdicQualidade[4,2],;			// 19-Vlr.Adic.C.C.S.
						aAdicQualidade[5,2],;			// 20-Vlr.Adic.C.P.P.
						0,;									// 21-Vlr.Adic.Bonificação
						aAdicQualidade[6,1],;			// 22-Nr Fiscal Produtor
						'';									// 23-Observação
					})
	else
		replace WORK->WK_QTDTOT with WORK->WK_QTDTOT + abs(LEIDADOS->LD_VOLTANT)
	end
//	dbedit()

	*--------------------------------------------------------------------------*
	select LEIDADOS
	dbskip()
end
return NIL

*-----------------------------------------------------------------------------*
	static function CalculaVlrLeite()
*-----------------------------------------------------------------------------*
pb_msg('Calculando Valores/Quantidade de Leite')
select WORK
set relation to str(WORK->WK_CDCLI,5) into CLIENTE
DbGoTop()
nTotLeite:=0
while !eof()	//...................................Produtores Valida Qtde --> Vlr Litro
	@24,68 say Str(WK_CDCLI,8)
	lRT:=.T. 
	Select LEIVOL
	DbGoTop()
	
	while !eof().and.lRT
		if WORK->WK_QTDTOT>=VL_QTLIT1.and.WORK->WK_QTDTOT<=VL_QTLIT2
			replace WORK->WK_VLVOLU with VL_VLRPLT
			lRT:=.F.
		end
		DbSkip()
	end
	if lRT
		Alert('ERRO FAIXA QUANTIDADE;Nao encontrato faixa de Leite para:'+str(WORK->WK_CDCLI,5)+;
				';Faixa Nao encontrada:'+Str(WORK->WK_QTDTOT,5))
	end
	replace 	WORK->WK_VLUNIT	with ;	// Soma do Valor por Litro
				WORK->WK_VLVOLU+;				//-09-Vlr Ref Volume (Unit)
				WORK->WK_VLGORD+;				//-10-Vlr Adic Gordura
				WORK->WK_VLPROT+;				//-11-Vlr Adic Proteina
				WORK->WK_VLESD +;				//-12-Vlr Adic ESD
				WORK->WK_VLCCS +;				//-13-Vlr Adic CCS
				WORK->WK_VLCPP +;				//-14-Vlr Adic CPP
				WORK->WK_VLBONU				//-15-Vlr Adic Bonus
	replace 	WORK->WK_CARAC 	with	AllTrim(wObsP)+;// Observação
												if(!empty(WORK->WK_NRNFPR),;
												'-Nr NF Prod.Rural:'+AllTrim(Str(WORK->WK_NRNFPR,6)),''),;
				WORK->WK_VLTOT		with	Trunca(WORK->WK_VLUNIT*WORK->WK_QTDTOT,2)

	if empty(WORK->WK_UFPLACA)	// Temporário até ajuste no cadastro
		replace WORK->WK_UFPLACA with CLIENTE->CL_UF
	end
	nTotLeite+=WORK->WK_VLTOT // Somatório Total de Leite
	select WORK
	skip
end
set relation to
return NIL

*-----------------------------------------------------------------------------*
	static function CriaTmpLeite()
*-----------------------------------------------------------------------------*
LCont:=.T.
cArq :=ArqTemp(,,'')
SALVABANCO
dbcreate(cArq,{{'WK_CDCLI',	'N',  5,0},;	//-01-Cod Cliente / Produtor
					{'WK_QTDTOT',	'N',  9,0},;	//-02-Qtd Total
					{'WK_VLUNIT',	'N',  9,4},;	//-03-Vlr Unitário NFe
					{'WK_VLTOT',	'N', 12,2},;	//-04-Vlr Total NFe
					{'WK_STATUS',	'C', 10,0},;	//-05-Situação
					{'WK_CDROTA',	'N',  6,0},;	//-06-Cod Rota
					{'WK_PLACA',	'C',  7,0},;	//-07-Placa Caminhão
					{'WK_UFPLACA',	'C',  2,0},;	//-08-UF-Placa Caminhão
					{'WK_CDTRAN',	'N',  5,0},;	//-09-Cod Transportador
					{'WK_VLVOLU',	'N',  8,4},;	//-10-Vlr Ref Volume (Unit)
					{'WK_GORDUR',	'N',  6,2},;	//-11-Perc Gordura
					{'WK_PROTEI',	'N',  6,2},;	//-12-Perc Proteina
					{'WK_ESD',		'N',  6,2},;	//-13-Perc ESD
					{'WK_NRCCS',	'N',  5,0},;	//-14-Qtdade CCS
					{'WK_NRCPP',	'N',  5,0},;	//-15-Qtdade CPP
					{'WK_VLGORD',	'N',  8,4},;	//-16-Vlr Ad Gordura
					{'WK_VLPROT',	'N',  8,4},;	//-17-Vlr Ad Proteina
					{'WK_VLESD',	'N',  8,4},;	//-18-Vlr Ad ESD
					{'WK_VLCCS',	'N',  8,4},;	//-19-Vlr Ad CCS
					{'WK_VLCPP',	'N',  8,4},;	//-20-Vlr Ad CPP
					{'WK_VLBONU',	'N',  8,4},;	//-21-Vlr Bonus
					{'WK_NRNFPR',	'N',  6,0},;	//-22-NR NF Produtor
					{'WK_CARAC',	'C',300,0};		//-23-Observação
					})
if !net_use(cArq,.T., ,'WORK', ,.F.,RDDSETDEFAULT())
	LCont:=.F.
	pb_msg('Erro na criacao da tabela temporaria de leite')
else
	Index on str(WK_CDCLI,5)				tag CODIGO_CLI to (cArq)
	OrdSetFocus('CODIGO_CLI')
end
RESTAURABANCO
return LCont
//-------------------------------------------EOF---------------
