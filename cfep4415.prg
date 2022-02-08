//-----------------------------------------------------------------------------*
  static aVariav := {0}
//...................1.
//-----------------------------------------------------------------------------*
#xtranslate nTotLeite    => aVariav\[  1 \]
*-----------------------------------------------------------------------------*
 function CFEP4415() //Imprimir Nota Fiscal de Leite
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
#include 'ENTRADA.CH'

local DATA  :={bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA),date(),eom(PARAMETRO->PA_DATA)+16}
local X     :=6
local CLI   :={0,99999}
local CodPr := 30910 // Código Leite
local ARQ   := ArqTemp(,,'')
local wObsP := space(112)
local wImpr :=' '
local wValor
local wCodCL
local aCampo
local CStatus
local Vlr:={0,0,0,0,0,0,0} // 6 + 1

alert('CUIDADO;Esta rotina so pode ser usada em casos especiais;Ha uma nova rotina de impressao;favor entar em contao com Edna.')

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
				'N',;							// 21- Adiantamento Fornecedor?
				Space(25),;					// 22-Observação para Livros Fiscais
				Padr('0',44,'0'),;		// 23-Chave NFE
				0.00,;						//	24-Valor Acessorio-Frete
				0.00,;						//	25-Valor Acessorio-Seguro
				0.00,;						//	26-Valor Acessorio-Outras Despesas
				0.00,;						//	27-Base ICMS ST
				0.00,;						//	28-Valor ICMS ST
				0.00,;						//	29-Valor Contábil
				Padr('0',44,'0');			//	30-Chave NFe - Devolução
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
private VM_FLADTO:="N"

dbgobottom()
dbskip()
private I_TRANS:=CFEPTRANL()

NATOP  :=DADOC[NNAT ]
TSERIE :=DADOC[SERIE]
TIPODOC:=DADOC[TPDOC]

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

CDT    :='051' // Código tributário

Valores:={PLinha(DesValX[01],0.46),; 	//01
			 PLinha(DesValX[02],0.47),;	//02
			 PLinha(DesValX[03],0.48),;	//03
			 PLinha(DesValX[04],0.49),;	//04
			 PLinha(DesValX[05],0.50),;	//05
			 PLinha(DesValX[06],0.51),;	//06
			 PLinha(DesValX[07],0.52),;	//07
			 PLinha(DesValX[08],0.53),;	//08
			 PLinha(DesValX[09],0.54),;	//09
			 PLinha(DesValX[10],0.54),;	//10
			 PLinha(DesValX[11],0.54);		//11
			}

wObsP := padr(PLinha('OBS p/ NF Leite',space(112)),112)

pb_box(,,,,,'Informe Dados de Selecao')
@X  ,02 say 'Data Inicial:' Get DATA[1] pict mDT                             when pb_msg('Informe Data do Inicio do Mes. Sera considerado um dia anterior da data informada para gerar a NF')
@X  ,28 say 'Data Final..:' Get DATA[2] pict mDT      valid DATA[1]<=DATA[2] when pb_msg('Informe Data Final do Mes. Sera considerado um dia anterior da data informada para gerar a NF')
@X++,54 say 'Data NF.....:' Get DATA[3] pict mDT
@X  ,02 say 'Nat.Operacao:' Get NATOP   pict mNAT     valid fn_codigo(@NATOP,{'NATOP',{||NATOP->(dbseek(str(NATOP,7)))},{||CFEPNATT(.T.)},{2,1}}).and.NATOP->NO_TIPO='E'.and.right(str(NATOP,8),1)=='9'
@X++,54 say 'Data Venc...:' Get DATA[4] pict mDT
@X++,02 say 'Cod.Produto.:' Get CODPR   pict masc(21) valid fn_codpr(@CODPR,77)
@X++,02 say 'Serie.......:' Get TSERIE  pict mUUU     valid fn_codigo(@TSERIE,{'CTRNF',{||CTRNF->(dbseek(TSERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}})
@X++,02 say 'Tipo Docto..:' Get TIPODOC pict mUUU     valid fn_codar(@TIPODOC,'TP_DOCTO.ARR') when (CDT:=PROD->PR_CODTRE)>=''
@X++,02 say 'Cod.Tributar:' Get CDT     pict mI3      valid fn_codigo(@CDT,{'CODTR',{||CODTR->(dbseek(CDT))},{||NIL},{2,1,3}}) when pb_msg('Codigo Tributario para este Produto')
@X++,02 say 'Obs Padrao..:' Get wObsP   pict mXXX+'S60'
 X++
pb_box(X,1,X+7,66,,'Valores')
 X++
@X  ,02 say DesValX[01]      get VALORES[01] pict mI64  valid VALORES[01]>=0 color 'GR+/G,GR+/B'
@X++,37 say DesValX[02]      get VALORES[02] pict mI64  valid VALORES[02]>=0 color 'GR+/G,GR+/B'

@X  ,02 say DesValX[03]      get VALORES[03] pict mI64  valid VALORES[03]>=0 color 'GR+/G,GR+/B'
@X++,37 say DesValX[04]      get VALORES[04] pict mI64  valid VALORES[04]>=0 color 'GR+/G,GR+/B'

@X  ,02 say DesValX[05]      get VALORES[05] pict mI64  valid VALORES[05]>=0 color 'GR+/G,GR+/B'
@X++,37 say DesValX[06]      get VALORES[06] pict mI64  valid VALORES[06]>=0 color 'GR+/G,GR+/B'

@X  ,02 say DesValX[07]      get VALORES[07] pict mI64  valid VALORES[07]>=0 color 'GR+/G,GR+/B'
@X++,37 say DesValX[08]      get VALORES[08] pict mI64  valid VALORES[08]>=0 color 'GR+/G,GR+/B'

@X  ,02 say DesValX[09]      get VALORES[09] pict mI64  valid VALORES[09]>=0 color 'GR+/G,GR+/B'
@X++,37 say DesValX[10]      get VALORES[10] pict mI64  valid VALORES[10]>=0 color 'GR+/G,GR+/B'

@X  ,02 say DesValX[11]      get VALORES[11] pict mI64  valid VALORES[11]>=0 color 'GR+/G,GR+/B'
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	for X:=1 to len(DesValX)
		SLinha(DesValX[X],Valores[X])
	next
	SLinha('OBS p/ NF Leite',padr(wObsP,132))
	
	DADOC[NNAT ]:=NATOP
	DADOC[SERIE]:=TSERIE
	if !CriaTmpLeite(ARQ)
		return NIL
	end
	GeraLeite(DATA,CLI,CODPR) // Buscar Valores
	select WORK
	set relation to str(WORK->WK_CODCL,5) into CLIENTE
	DbGoTop()
	nTotLeite:=0
	while !eof()
		//CLIENTE->(dbseek(str(WORK->WK_CODCL,5)))
		if     WORK->WK_QTDE>30000
			replace WORK->WK_VLR1 with VALORES[11]
		elseif WORK->WK_QTDE>20000
			replace WORK->WK_VLR1 with VALORES[10]
		elseif WORK->WK_QTDE>15000
			replace WORK->WK_VLR1 with VALORES[09]
		elseif WORK->WK_QTDE>12500
			replace WORK->WK_VLR1 with VALORES[08]
		elseif WORK->WK_QTDE>10500
			replace WORK->WK_VLR1 with VALORES[07]
		elseif WORK->WK_QTDE>9000
			replace WORK->WK_VLR1 with VALORES[06]
		elseif WORK->WK_QTDE>7500
			replace WORK->WK_VLR1 with VALORES[05]
		elseif WORK->WK_QTDE>6000
			replace WORK->WK_VLR1 with VALORES[04]
		elseif WORK->WK_QTDE>4500
			replace WORK->WK_VLR1 with VALORES[03]
		elseif WORK->WK_QTDE>3000
			replace WORK->WK_VLR1 with VALORES[02]
		elseif WORK->WK_QTDE>=0
			replace WORK->WK_VLR1 with VALORES[01]
		end
		
		CStatus:=if(empty(CLIENTE->CL_STATUS),'0.0000|0.0000|0.0000| 0.0000| 0.0000|0.00|',CLIENTE->CL_STATUS)
		Vlr[1] :=val(token(CStatus,'|',1))	// Gordura
		Vlr[2] :=val(token(CStatus,'|',2))	// Proteina
		Vlr[3] :=val(token(CStatus,'|',3))	// E.S.D.
		Vlr[4] :=val(token(CStatus,'|',4))	// C.C.S.
		Vlr[5] :=val(token(CStatus,'|',5))	// C.P.P.
		Vlr[6] :=val(token(CStatus,'|',6))	// Bonificação

		Vlr[7] :=WORK->WK_VLR1					// Vlr unit por quantidade
		replace 	WORK->WK_VLR1		with WORK->WK_VLR1 + Vlr[1] + Vlr[2] + Vlr[3] + Vlr[4] + Vlr[5] + Vlr[6] // VALOR POR LITRO
		replace 	WORK->WK_CARAC		with wObsP,;
					WORK->WK_INFVLR	with allTrim(CStatus)+str(Vlr[7],5,2)+'|'

		replace WK_CARAC with trim(wObsP)+if(!empty(CLIENTE->CL_NFPR),'-Nr NF Produtor Rural:'+trim(CLIENTE->CL_NFPR),'')
					
		nTotLeite+=(WORK->WK_VLR1*WORK->WK_QTDE)
		skip
	end
	aCont :={'Fornec','Qtdade','VlUnit','VlTotal','Status','Obs'}
	aCampo:={'str(WORK->WK_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,25)',;
				FieldName(3),;//..................Quantidade
				FieldName(5),;//..................Vlr Unitário
				'FieldGet(3)*FieldGet(5)',;//.....Vlr Total
				'left(WK_CHAVE,8)',;
				FieldName(6)}
	DbGoTop()
	while .T.
		pb_msg('<Enter> Mudar Situacao (Imprimir/Nao Imprimir)    <ESC> para Continuar ')
		@23,62 say 'Total:'+transform(nTotLeite,mI102) color 'W*+/B'
		setcolor('W/B')
		pb_box(7,0,22,79,'W/B','Selecione')
		dbedit(8,1,21,78,aCampo,,{mXXX,mI6,mI64,mD52,mXXX,mXXX},aCont)
		if lastkey()==K_ENTER
			wImpr:=if(left(WK_CHAVE,1)=='I','N','S')
//			pb_box(19,0,,,,'Informe')
//			@20,01 say 'Imprime?' get wImpr pict mUUU       valid wImpr$'SN' when pb_msg('<S>Imprimir NF         <N>ao imprimir NF')
//			@21,01 say 'OBS'      get wObsP pict mXXX+'S74' valid .T.        when pb_msg('Informe a observacao para este produto').and.wImpr=='S'
//			read
//			if if(Lastkey()#K_ESC,pb_sn(),.F.)
				if wImpr == 'S'
					replace WK_CHAVE with 'Imprimir'
				else
					replace WK_CHAVE with ''
				end
				skip
//			end
		end
		if lastkey()==K_ESC
			exit
		end
	end
	//-------------------------------------------Imprimir
	if pb_sn('Imprimir Notas Fiscais de Entrada de Leite;Para a selecao acima ?')

		I_TRANS[05]:=2 // Tipo de frete FOB por conta do destinatário
		I_TRANS[10]:=1	// Quantidade 
		I_TRANS[11]:='Leite in natura'
		I_TRANS[12]:='Sem Marca'
		I_TRANS[13]:=0	// Peso Bruto   = É a quantidade de leite
		I_TRANS[14]:=0	// Peso Liquido = É a quantidade de leite
		I_TRANS[15]:=23479	// Fornecedor de transporte é Coolacer Matriz
		I_TRANS[06]:='MFH4433'	// Placa Caminhão
		I_TRANS:=CFEPTRANE(I_TRANS,.F.,'E') // Digitar Dados do transportador (Não Peso L/B,Qtd, Especie,Marca)
		DbGoTop()
		while !Eof()
			if left(WK_CHAVE,2) == 'Im'
				PROD->(dbseek(str(CODPR,L_P)))
				CLIENTE->(dbseek(str(CODPR,5)))
				NATOP->(dbseek(str(NATOP,7)))
				DADOC[NFOR ]   :=WORK->WK_CODCL
				FORNEC         :=DADOC[NFOR ]
				PRODUTOS       :=DetProdEnt('I') // INICIALIZAR
				PRODUTOS[01,01]:=1				// SEQ
				PRODUTOS[01,02]:=CODPR
				PRODUTOS[01,03]:=padr(PROD->PR_DESCR,40)
				PRODUTOS[01,04]:=WORK->WK_QTDE
				PRODUTOS[01,05]:=trunca(WORK->WK_QTDE * WORK->WK_VLR1,2) // Valor Total
				PRODUTOS[01,06]:=WORK->WK_VLR1 // Vlr Unitário
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
				PRODUTOS[01,18]:=NATOP
				PRODUTOS[01,19]:=0
				PRODUTOS[01,20]:=0
				PRODUTOS[01,21]:=trunca(WORK->WK_QTDE * WORK->WK_VLR1,2)
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
				DADOC[NDT ]		:=DATA[3]
				DADOC[NDT1]		:=DATA[3]
				DADOC[NNF ]    :=fn_psnf(DADOC[SERIE])
				DADOC[NDOC]    :=DADOC[NNF]
				DADOC[TPDOC]   :=TIPODOC
				DADOC[NVNF]    :=PRODUTOS[01,05]
				DADOC[BICMS]   :=0
				DADOC[NVFUNR]  :=round((DADOC[NVNF]-DADOC[NDES])*PARAMETRO->PA_FUNRUR/100,2)
				DADOPC         :={}
				aadd(DADOPC,{DADOC[NNF ]*100,;
								 DATA[4],; // ctod('10/'+right(dtoc(addmonth(DADOC[NDT1],1)),7)),; // Dt Vencto
								 DADOC[NVNF]-DADOC[NVFUNR]-DADOC[NDES]})
				CLIENTE->(dbseek(str(DADOC[NFOR],5)))
				NATOP->  (dbseek(str(DADOC[NNAT],7)))
				
				alert("Adicionais;"+WORK->WK_INFVLR)
				
				PRODUTOS[02,01]:=2				// SEQ
				PRODUTOS[02,02]:=0.01
				PRODUTOS[02,03]:='Vlr Unit:R$ '+token(WORK->WK_INFVLR,'|',7)+'*'
//				PRODUTOS[02,06]:=val(token(WORK->WK_INFVLR,'|',5)) // valor unitário

				PRODUTOS[03,01]:=3				// SEQ
				PRODUTOS[03,02]:=0.01
				PRODUTOS[03,03]:='Adic.Gordura:R$ '+token(WORK->WK_INFVLR,'|',1)+'*'
//				PRODUTOS[03,06]:=val(token(WORK->WK_INFVLR,'|',1)) // valor unitário

				PRODUTOS[04,01]:=4				// SEQ - Gordur|Protei|E.S.D.|C.C.S.|C.P.P.| BONUS
				PRODUTOS[04,02]:=0.01
				PRODUTOS[04,03]:='Adic.Proteina:R$ '+token(WORK->WK_INFVLR,'|',2)+'*'
//				PRODUTOS[04,06]:=val(token(WORK->WK_INFVLR,'|',2)) // valor unitário

				PRODUTOS[05,01]:=5				// SEQ
				PRODUTOS[05,02]:=0.01
				PRODUTOS[05,03]:='Adic.E.S.D.:R$ '+token(WORK->WK_INFVLR,'|',3)+'*'
//				PRODUTOS[05,06]:=val(token(WORK->WK_INFVLR,'|',3)) // valor unitário

				PRODUTOS[06,01]:=6				// SEQ
				PRODUTOS[06,02]:=0.01
				PRODUTOS[06,03]:='Adic.C.C.S.:R$ '+token(WORK->WK_INFVLR,'|',4)+'*'
//				PRODUTOS[06,06]:=val(token(WORK->WK_INFVLR,'|',4)) // valor unitário
				PRODUTOS[07,01]:=6				// SEQ
				PRODUTOS[07,02]:=0.01
				PRODUTOS[07,03]:='Adic.C.P.P.:R$ '+token(WORK->WK_INFVLR,'|',5)+'*'
//				PRODUTOS[06,06]:=val(token(WORK->WK_INFVLR,'|',4)) // valor unitário
				if Val(token(WORK->WK_INFVLR,'|',6))>0 // tem Bonus - caso não tenha não mostrar
				PRODUTOS[08,01]:=6				// SEQ
				PRODUTOS[08,02]:=0.01
				PRODUTOS[08,03]:='Bonificacao:R$ '+token(WORK->WK_INFVLR,'|',6)
//				PRODUTOS[06,06]:=val(token(WORK->WK_INFVLR,'|',4)) // valor unitário
				end
				beepaler()
				I_TRANS[10]:=1						// Quantidade   = de Embagagens
				I_TRANS[13]:=PRODUTOS[01,04]	// Peso Bruto   = É a quantidade de leite
				I_TRANS[14]:=PRODUTOS[01,04]	// Peso Liquido = É a quantidade de leite

				CONTINUAR :=CFEP441I({	WORK->WK_CARAC,;
												alltrim  (PRODUTOS[02,03])+;
												alltrim  (PRODUTOS[03,03])+;
												alltrim  (PRODUTOS[04,03])+;
												alltrim  (PRODUTOS[05,03])+;
												alltrim	(PRODUTOS[06,03])+;
												alltrim	(PRODUTOS[07,03])+;
												alltrim	(PRODUTOS[08,03]);
												}) // Impressao NF Entrada
				if CONTINUAR[1]
					// Alert('Marcar como impresso...')
					PRODUTOS[02,02]:=0
					PRODUTOS[03,02]:=0
					PRODUTOS[04,02]:=0
					PRODUTOS[05,02]:=0
					PRODUTOS[06,02]:=0
					PRODUTOS[07,02]:=0
					PRODUTOS[08,02]:=0
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
fileDelete (ARQ + '.*')
select ENTCAB
set relation to str(EC_CODFO,5) into CLIENTE
return NIL
//--------------------------------------------------------------------EOF---------------
