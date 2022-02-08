//-----------------------------------------------------------------------------*
  static aVariav := {0,0,'',{},{},''}
//...................1.2..3..4..5..6
//-----------------------------------------------------------------------------*
#xtranslate nTotLeite	=> aVariav\[  1 \]
#xtranslate nCodPr		=> aVariav\[  2 \]
#xtranslate cVlrAdi		=> aVariav\[  3 \]
#xtranslate aValidar		=> aVariav\[  4 \]
#xtranslate aValores		=> aVariav\[  5 \]
#xtranslate wObsP			=> aVariav\[  6 \]
#xtranslate wObsP			=> aVariav\[  6 \]

#include 'RCB.CH'
#include 'ENTRADA.CH'

*-----------------------------------------------------------------------------*
 function LEITEP21() //Imprimir Nota Fiscal de Leite
*-----------------------------------------------------------------------------*
local aCampo

alert('CUIDADO;Esta rotina so pode ser usada em casos especiais;Ha uma nova rotina de impressao;favor entar em contao com Edna.')

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
				'R->LEITRANS'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIMOTIV'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIVEIC'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIROTA'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEICPROD'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIDADOS'		;		// Criado arquivo no LEITEP00.PRG
			})
	return NIL
end
SELECT PROD
ORDEM CODIGO

SELECT LEIVEIC
ORDEM PLACA

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
CodPr  	:=LEIPARAM->LP_PROD // Código Leite - dos parâmetros
dLctos 	:={Bom(PARAMETRO->PA_DATA),Eom(PARAMETRO->PA_DATA)}
nPer   	:= left(dtos(PARAMETRO->PA_DATA),6) // Periodo
dData	 	:={Date(),Eom(Date())}
cArq   	:=''
aValidar	:={}
NATOP  	:=DADOC[NNAT ]
TSERIE 	:=DADOC[SERIE]
TIPODOC	:=DADOC[TPDOC]
CDT 	   :='051' // Código tributário
PROD->(dbseek(str(CodPr,L_P))) // Achar produto

DesValX:={	'Leite     0 -  3000',;	// 01
				'Leite  3001 -  4500',;	// 02
				'Leite  4501 -  6000',;	// 03
				'Leite  6001 -  7500',;	// 04
				'Leite  7501 -  9000',;	// 05
				'Leite  9001 - 10500',;	// 06
				'Leite 10501 - 12500',;	// 07
				'Leite 12501 - 15000',;	// 08
				'Leite 15001 - 20000',;	// 09
				'Leite 20001 - 30000',;	// 10
				'Leite 30001 - 99999'}	// 11

aValores:={;
				PLinha(DesValX[01],0.46),; //01-Inicialização
				PLinha(DesValX[02],0.47),;	//02
				PLinha(DesValX[03],0.48),;	//03
				PLinha(DesValX[04],0.49),;	//04
				PLinha(DesValX[05],0.50),;	//05
				PLinha(DesValX[06],0.51),;	//06
				PLinha(DesValX[07],0.52),;	//07
				PLinha(DesValX[08],0.53),;	//08
				PLinha(DesValX[09],0.54),;	//09
				PLinha(DesValX[10],0.54),;	//10
				PLinha(DesValX[11],0.54);	//11
			}

wObsP	:= padr(PLinha('OBS p/ NF Leite',space(132)),132)

pb_box(,,,,,'Informe Dados de Selecao')
//@X  ,02 say 'Data Inicial:' Get DATA[1] pict mDT                             when pb_msg('Informe Data do Inicio do Mes. Sera considerado um dia anterior da data informada para gerar a NF')
//@X  ,28 say 'Data Final..:' Get DATA[2] pict mDT      valid DATA[1]<=DATA[2] when pb_msg('Informe Data Final do Mes. Sera considerado um dia anterior da data informada para gerar a NF')
@X  ,02 say 'Periodo.:'     Get nPer		pict mPER
@X++,54 say 'Data NF.....:' Get dData[1]	pict mDT
@X  ,02 say 'Nat.Operacao:' Get NATOP		pict mNAT     valid fn_codigo(@NATOP,{'NATOP',{||NATOP->(dbseek(str(NATOP,7)))},{||CFEPNATT(.T.)},{2,1}}).and.NATOP->NO_TIPO='E'.and.right(str(NATOP,8),1)=='9'
@X++,54 say 'Data Venc...:' Get dData[2]	pict mDT
@X++,02 say 'Cod.Produto.: '+Str(CodPr,L_P)+'-'+PROD->PR_DESCR
@X++,02 say 'Serie.......:' Get TSERIE		pict mUUU     valid fn_codigo(@TSERIE,{'CTRNF',{||CTRNF->(dbseek(TSERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}})
@X++,02 say 'Tipo Docto..:' Get TIPODOC	pict mUUU     valid fn_codar(@TIPODOC,'TP_DOCTO.ARR') when (CDT:=PROD->PR_CODTRE)>=''
@X++,02 say 'Cod.Tributar:' Get CDT			pict mI3      valid fn_codigo(@CDT,{'CODTR',{||CODTR->(dbseek(CDT))},{||NIL},{2,1,3}}) when pb_msg('Codigo Tributario para este Produto')
@X++,02 say 'Obs Padrao..:' Get wObsP		pict mXXX+'S60'
 X++
pb_box(X,1,X+7,66,,'Valores por Faixa')
 X++
@X  ,02 say DesValX[01]      get aValores[01] pict mI64  valid aValores[01]>=0 color 'GR+/G,GR+/B'
@X++,37 say DesValX[02]      get aValores[02] pict mI64  valid aValores[02]>=0 color 'GR+/G,GR+/B'

@X  ,02 say DesValX[03]      get aValores[03] pict mI64  valid aValores[03]>=0 color 'GR+/G,GR+/B'
@X++,37 say DesValX[04]      get aValores[04] pict mI64  valid aValores[04]>=0 color 'GR+/G,GR+/B'

@X  ,02 say DesValX[05]      get aValores[05] pict mI64  valid aValores[05]>=0 color 'GR+/G,GR+/B'
@X++,37 say DesValX[06]      get aValores[06] pict mI64  valid aValores[06]>=0 color 'GR+/G,GR+/B'

@X  ,02 say DesValX[07]      get aValores[07] pict mI64  valid aValores[07]>=0 color 'GR+/G,GR+/B'
@X++,37 say DesValX[08]      get aValores[08] pict mI64  valid aValores[08]>=0 color 'GR+/G,GR+/B'

@X  ,02 say DesValX[09]      get aValores[09] pict mI64  valid aValores[09]>=0 color 'GR+/G,GR+/B'
@X++,37 say DesValX[10]      get aValores[10] pict mI64  valid aValores[10]>=0 color 'GR+/G,GR+/B'

@X  ,02 say DesValX[11]      get aValores[11] pict mI64  valid aValores[11]>=0 color 'GR+/G,GR+/B'
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	
	dLctos[1]:=CtoD('01/'+right(nPer,2)+'/'+left(nPer,4)) // Data Inicial Mes
	dLctos[2]:=eom(dLctos[1])		// Data Fim do mes
	dLctos[1]-- 						// Inicio do mes MENOS 1 DIA
	dLctos[2]--							// Fim do mes MENOS 1 DIA
	// ---------------------------   Salvar valores
	for X:=1 to len(DesValX)
		SLinha(DesValX[X],aValores[X])
	next
		SLinha('OBS p/ NF Leite',padr(wObsP,132))
	
	DADOC[NNAT ]:=NATOP
	DADOC[SERIE]:=TSERIE

	if CriaTmpLeite() // Criar tabela interna de Leite
		AcumularLeiteN()	// Aculular valores por Cliente
		CalculaVlrLeite()	// Calcular valores das variaveis de leite
		aCont :={'Produt','Qtdade','VlUnit','VlTotal','Status','Obs'}
		aCampo:={'str(WORK->WK_CDCLI,5)+chr(45)+left(CLIENTE->CL_RAZAO,25)',;
					'WORK->WK_QTDTOT',;//..................Quantidade Total
					'WORK->WK_VLUNIT',;//..................Vlr Unitário
					'WORK->WK_VLTOT',;//...................Vlr Total
					'left(WK_STATUS,8)',;//................Imprime ou Não
					'left(WORK->WK_CARAC,50)';
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

					CONTINUAR :=CFEP441I({	WORK->WK_CARAC,;
													if(WORK->WK_VLVOLU>0,;
													' Vlr.Faixa:R$'		+str(WORK->WK_VLVOLU,6,4),'')+;
													' Adic.Gordura:R$' 	+str(WORK->WK_VLGORD,6,4)+;	// 10-Vlr Ad Gordura
													' Adic.Proteina:R$'	+str(WORK->WK_VLPROT,6,4)+;	// 11-Adic.Proteina
													' Adic.E.S.D.:R$'  	+str(WORK->WK_VLESD, 6,4)+;	// 12-Adic.E.S.D.
													' Adic.C.C.S.:R$'		+str(WORK->WK_VLCCS, 7,4)+;	// 13-Adic.C.C.S.
													' Adic.C.P.P.:R$'  	+str(WORK->WK_VLCPP, 7,4)+;	// 14-Adic.C.P.P.
													if(WORK->WK_VLBONU>0,;
													' Bonificacao:R$'  	+str(WORK->WK_VLBONU,6,4),'');// 15-Adic Bonus
												})
					if CONTINUAR[1]
						// Alert('Marcar como impresso...')
						CFEP441G1(CONTINUAR) // GRAVAR DADOS
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
	static function AcumularLeiteN() // Novo arquivo de dados de LEITE 			   *
*-----------------------------------------------------------------------------*
pb_msg('Acumulando Quantidade Leite')
select LEIVEIC
ORDEM PLACA
select LEIDADOS
ORDEM DTCLI // Data + Cliente
DbGoTop()
dbseek(dtos(dLctos[1]),.T.)
while !eof().and.LEIDADOS->LD_DTCOLET<=dLctos[2] // validar período
	@24,68 say DtoC(LEIDADOS->LD_DTCOLET)
	LEIVEIC->(dbseek(LEIDADOS->LD_PLACA))				// Buscar Cod Transportador
	CLIENTE->(dbseek(str(LEIDADOS->LD_CDCLI,5)))		// Buscar Vlrs Ad do Cliente
	cVlrAdi:=if(empty(CLIENTE->CL_STATUS),'0.0000|0.0000|0.0000|0.0000|0.0000|0.0000|',;
							CLIENTE->CL_STATUS)
	*--------------------------------------------------------------------------*
	select WORK
	if !WORK->(dbseek(str(LEIDADOS->LD_CDCLI,5)))
		AddRec(,{	LEIDADOS->LD_CDCLI,;				// 01-Cod Cliente
						LEIDADOS->LD_VOLTANT,;			// 02-Quantidade
						0,;									// 03-Vlr Unitário NFe
						0,;									// 04-Vlr Total NFe
						'Imprimir',; 						// 05-Status
						LEIDADOS->LD_CDROTA,;			// 06-Cod Rota
						LEIDADOS->LD_PLACA,;				// 07-Placa Caminhão
						LEIVEIC->LV_UFPLACA,;			// 08-UF-Placa Caminhão
						LEIVEIC->LV_CDTRAN,;				// 09-Cod Transportador
						0,;									// 10-Vlr Ref Volume (Unit)
						val(token(cVlrAdi,'|',1)),;	// 11-Adic.Gordura
						val(token(cVlrAdi,'|',2)),;	// 12-Adic.Proteina
						val(token(cVlrAdi,'|',3)),;	// 13-Adic.E.S.D.
						val(token(cVlrAdi,'|',4)),;	// 14-Adic.C.C.S.
						val(token(cVlrAdi,'|',5)),;	// 15-Adic.C.P.P.
						val(token(cVlrAdi,'|',6)),;	// 16-Adic.Bonificação
						CLIENTE->CL_NFPR;					// 17-Nr Fiscal Produtor
					})
	else
		replace WORK->WK_QTDTOT with WORK->WK_QTDTOT + abs(LEIDADOS->LD_VOLTANT)
	end
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
while !eof()
	@24,68 say Str(WK_CDCLI,8)
	if     WORK->WK_QTDTOT>30000
		replace WORK->WK_VLVOLU with aValores[11]
	elseif WORK->WK_QTDTOT>20000
		replace WORK->WK_VLVOLU with aValores[10]
	elseif WORK->WK_QTDTOT>15000
		replace WORK->WK_VLVOLU with aValores[09]
	elseif WORK->WK_QTDTOT>12500
		replace WORK->WK_VLVOLU with aValores[08]
	elseif WORK->WK_QTDTOT>10500
		replace WORK->WK_VLVOLU with aValores[07]
	elseif WORK->WK_QTDTOT>9000
		replace WORK->WK_VLVOLU with aValores[06]
	elseif WORK->WK_QTDTOT>7500
		replace WORK->WK_VLVOLU with aValores[05]
	elseif WORK->WK_QTDTOT>6000
		replace WORK->WK_VLVOLU with aValores[04]
	elseif WORK->WK_QTDTOT>4500
		replace WORK->WK_VLVOLU with aValores[03]
	elseif WORK->WK_QTDTOT>3000
		replace WORK->WK_VLVOLU with aValores[02]
	elseif WORK->WK_QTDTOT>=0
		replace WORK->WK_VLVOLU with aValores[01]
	end
	replace 	WORK->WK_VLUNIT	with  ;	// Valor por Litro
				WORK->WK_VLVOLU+;				//-09-Vlr Ref Volume (Unit)
				WORK->WK_VLGORD+;				//-10-Vlr Ad Gordura
				WORK->WK_VLPROT+;				//-11-Vlr Ad Proteina
				WORK->WK_VLESD+;				//-12-Vlr Ad ESD
				WORK->WK_VLCCS+;				//-13-Vlr Ad CCS
				WORK->WK_VLCPP+;				//-14-Vlr Ad CPP
				WORK->WK_VLBONU				//-15-Vlr Bonus
	replace 	WORK->WK_CARAC 	with	trim(wObsP)+;// Observação
												if(!empty(CLIENTE->CL_NFPR),;
												'-Nr NF Prod.Rural:'+trim(CLIENTE->CL_NFPR),''),;
				WORK->WK_VLTOT		with	trunca(WORK->WK_VLUNIT*WORK->WK_QTDTOT,2)

	if empty(WORK->WK_UFPLACA)	// Temporário até ajuste no cadastro
		replace WORK->WK_UFPLACA with CLIENTE->CL_UF
	end
	nTotLeite+=WORK->WK_VLTOT // Somatório Total de Leite
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
					{'WK_VLVOLU',	'N',  7,4},;	//-10-Vlr Ref Volume (Unit)
					{'WK_VLGORD',	'N',  7,4},;	//-11-Vlr Ad Gordura
					{'WK_VLPROT',	'N',  7,4},;	//-12-Vlr Ad Proteina
					{'WK_VLESD',	'N',  7,4},;	//-13-Vlr Ad ESD
					{'WK_VLCCS',	'N',  7,4},;	//-14-Vlr Ad CCS
					{'WK_VLCPP',	'N',  7,4},;	//-15-Vlr Ad CPP
					{'WK_VLBONU',	'N',  7,4},;	//-16-Vlr Bonus
					{'WK_NRNFPR',	'C', 20,0},;	//-17-NR NF Produtor
					{'WK_CARAC',	'C',200,0};		//-18-NR NF Produtor
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

//--------------------------------------------------------------------EOF---------------
