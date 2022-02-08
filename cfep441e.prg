*---------------------------------------------------------------------------------------*
static aVariav := {.F.,'N','Argox OS-214 plus series PPLA',{},'S'}
 //..................1..2...3...............................4..5
*---------------------------------------------------------------------------------------*
#xtranslate lContinua		=> aVariav\[  1 \]
#xtranslate cImprCodeBar	=> aVariav\[  2 \]
#xtranslate cNomeImp			=> aVariav\[  3 \]
#xtranslate aPrinter			=> aVariav\[  4 \]
#xtranslate cImprEtiq		=> aVariav\[  5 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
 function CFEP441E()	//	Movimentacoes do estoque - ENTRADA							*
*-----------------------------------------------------------------------------*
pb_tela()
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'R->CODTR',;
				'R->ALIQUOTAS',;
				'C->XOBS',;
				'C->CLIOBS',;
				'C->GRUPOS',;
				'C->MOVEST',;
				'C->FISACOF',;
				'C->SALDOS',;
				'C->UNIDADE',;
				'C->VENDEDOR',;
				'C->CLIENTE',;
				'C->PROD'})
	return NIL
end

if PARAMETRO->PA_CONTAB#chr(255)+chr(25)
	pb_dbedit1('CFEP44E','Entrad')
else
	pb_dbedit1('CFEP44E','EntradLeite ExcluiLista Cadast')
end

select('GRUPOS')
set filter to GRUPOS->GE_CODGR%10000>0 // Mostrar só Grupos Detalhes
select('PROD')
ORDEM CODIGO
select('MOVEST')
ORDEM DTCOD
DbGoTop()
set relation to str(ME_CODPR,L_P) into PROD

VM_CAMPO:={ fieldname(07),;//		Tipo
				fieldname(02),;//		Data
				'str(MOVEST->ME_CODPR,L_P)+chr(45)+left(PROD->PR_DESCR,22)',;
				fieldname(03),;//		Docto
				fieldname(04),;//		Qtde
				fieldname(05),;//		Vlr Mov Médio
				fieldname(15);	//		Forma
				}
VM_CABE    :={'T','Dt Movto','Produto','Dcto','Qtde.','Vlr.Est.','F'}
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',,VM_CABE)

set relation to
dbcommitall()
dbunlockall()
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
	function CFEP44E1() // Rotina de Inclus„o
*-----------------------------------------------------------------------------*
local GETLIST   := {}
private VM_CODPR:= 0
private VM_DOCTO:= 1000

cImprCodeBar:='N' // Imprime Código de Barras
aPrinter		:= GetPrinters() // Busca todas as Impressoras do Windows
if !empty(aPrinter)
	if Ascan(aPrinter,cNomeImp)>0 // tem impressora de código de barra
		cImprCodeBar:='S'	 // Imprime Código de Barras
	end
end

while lastkey()#K_ESC
	cImprEtiq:=if(cImprCodeBar=='S','S','N')
	VM_DATA  := PARAMETRO->PA_DATA
	VM_DOCTO++
	VM_QTDE  := 0
	VM_VLRE  := 0
	VM_VLRV  := 0
	VM_VLCOM := 0
	nX       :=14
	pb_box(nX++,20,,,,'Entrada Simples')
	@nX++,22 say 'C¢d.Produto....:' get VM_CODPR pict masc(21) valid fn_codpr(@VM_CODPR,78).and.fn_rtunid(VM_CODPR) when pb_msg('Informe o Produto')
	if cImprCodeBar=='S'
		@nX++,22 say 'Etiqueta Cod Barras:' color 'GR+/G' get cImprEtiq pict mUUU valid cImprEtiq$'SN' 	when pb_msg('Imprime etiqueta deste Produto').and.PROD->PR_IMPET=='S'
	end
	@nX++,22 say 'Data...........:' get VM_DATA  pict mDT      valid left(dtos(VM_DATA),6)==left(dtos(PARAMETRO->PA_DATA),6) when pb_msg('Informe data da movimentacao -> do Mes em processo')
	@nX++,22 say 'Documento......:' get VM_DOCTO pict masc(8)  										when pb_msg('Informe numero do documento')
	@nX++,22 say 'Qtde.Moviment..:' get VM_QTDE  pict masc(6)  valid VM_QTDE >0.00			when pb_msg('Informe Quantidade Entrada')
	@nX  ,22 say 'Vlr Custo(Unit):' get VM_VLCOM pict masc(5)  valid VM_VLCOM>0.00   		when pb_msg('Valor Unitario de Custo - Anterior:'+transform(pb_divzero(PROD->PR_VLATU,PROD->PR_QTATU),mD82))
	@nX++,57 say 'Total.:'          get VM_VLRE  pict masc(5)  valid VM_VLRE >0.00			when (VM_VLRE:=(VM_VLCOM*VM_QTDE))>=0.and.pb_msg('Valor Total Entrada')
	@nX++,22 say 'Vlr Venda(Unit):' get VM_VLRV  pict masc(5)  valid VM_VLRV >0.00 			when fn_vlven(@VM_VLRV,(VM_VLRE/VM_QTDE),VM_CODPR,0,0,0).and.pb_msg('Valor Unitario de Venda - Anterior:'+transform(PROD->PR_VLVEN,mD82))
	read
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		select('PROD')
		PROD->(dbseek(str(VM_CODPR,L_P)))
		if RecLock()
			replace 	PR_VLATU with PR_VLATU+VM_VLRE,;
						PR_QTATU with PR_QTATU+VM_QTDE,;
						PR_DTCOM with VM_DATA,;
						PR_VLVEN with VM_VLRV,;
						PR_VLCOM with VM_VLCOM
			
			select('MOVEST')
			GrMovEst({	VM_CODPR,;		//	1 Cod Produto
							VM_DATA,;		//	2 Data Movto
							VM_DOCTO,;		//	3 Nr Docto
							VM_QTDE,;		//	4 Qtde
							VM_VLRE,;		//	5 Vlr Medio
							VM_VLRV*abs(VM_QTDE),;//	6 Vlr Venda
							'E',;				//	7 Tipo Entrada Simples
							PROD->PR_CTB,;	//	8 Tipo Produto
							'',;				// 9 Serie - despesas
							0,;				//10 Cod Fornec
							0,;				//11 D-Conta contábil Despesa
							0,;				//12 D-Conta contábil Icms
							0,;				//13 Vlr Icms
							.F.,;				//14 Contabilizado ?
							'N'})				//15 P=Producao  //  D=Despesas // N=Normal
			if cImprEtiq=='S' //..........Será Impresso Código de Barras ?
				ImprimeEtiq(VM_QTDE)	//....Imprimir Código de Barras
			end
			go bottom
		else
			Alert('Produto nao travado;Movimentacao nao efetuada.')
			select('MOVEST')
		end
	end
	DbCommitAll()
	DbunLockAll()
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEP44E2() // Entrada Leite
*-----------------------------------------------------------------------------*
local GETLIST  := {}
local ProdLeite:= {}
local Opc      := 0
private CODPR  := 30910 // código leite
private DATA   := PARAMETRO->PA_DATA
Alert(ProcName()+';Programa nao deve ser mais usado;conversado com Edna')
pb_box(19,20,,,,'ENTRADA DE LEITE')
@20,22 say 'C¢d.Produto....:' get CODPR pict masc(21) valid fn_codpr(@CODPR,77)
@21,22 say 'Data Movto.....:' get DATA  pict mDT      valid DATA<=PARAMETRO->PA_DATA
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	
	ProdLeite:=GetProdLeite()
	
	select MOVEST
	ORDEM DTPROE
	dbseek(dtos(DATA)+str(CODPR,L_P),.T.)
	while !eof().and.MOVEST->ME_DATA==DATA.and.MOVEST->ME_CODPR==CODPR
		if MOVEST->ME_CODFO > 0 .and. MOVEST->ME_FORMA =='L' // Lançamento de Leite
			OPC:=ASCAN(ProdLeite,{|DET|DET[2]==MOVEST->ME_CODFO})
			if OPC>0
				ProdLeite[OPC,4]:=MOVEST->ME_QTD
				ProdLeite[OPC,5]:=MOVEST->(RecNo())
			else
				ALERT('Codigo do Produtor : '+str(MOVEST->ME_CODFO,6)+' Nao esta cadastrado no leite;Codigo Ignorado')
			end
		end
		skip
	end
	if len(ProdLeite)>0
		OPC:=1
		while OPC > 0
			OPC:=Abrowse(5,1,22,78,ProdLeite,{'Rota','Codig','Produtor','Qtdade'},;
														{	10,	5,			40,			10},;
														{mROTA,mI5,			mXXX,			mI6},,;
														'Rotas x Produtores Leite')
			if OPC>0
				lContinua:=.T.
				while lContinua
					pb_box(16,10,,,,'ENTRADA DE LEITE')
					Qtd:=ProdLeite[OPC,4]
					@17,12 say 'C¢d.Produto....:'+str(CODPR,L_P)+'-'+PROD->PR_DESCR
					@18,12 say 'Data Movto.....:'+dtoc(DATA)
					@19,12 say 'Rota...........:'+transform(ProdLeite[OPC][1],mROTA)+space(9)+if(OPC==len(ProdLeite),'ULTIMO PRODUTOR','Faltam '+str(len(ProdLeite)-OPC,5))
					@20,12 say 'Produtor.......:'+str(ProdLeite[OPC][2],5)+'-'+ProdLeite[OPC][3]
					@21,12 say 'Quantidade.....:' get Qtd pict mI6 valid Qtd>=0.and.Qtd<10000 color 'R+/W,W/R' when pb_msg('Digite quantidade ou <ESC> para Sair')
					read
					setcolor(VM_CORPAD)
					if lastkey()#K_ESC
						ProdLeite[OPC,4]:=Qtd // Quantidade do Dia
						OPC++
						if OPC > len(ProdLeite)
							lContinua:=.F.
						end
					else
						lContinua:=.F.
					end
				end
			elseif pb_sn('Gravar Dados ?')
				for OPC:=1 to len(ProdLeite)
					if ProdLeite[OPC,5]==0.and.ProdLeite[OPC,4]>0
						GrMovEst({	CODPR,;//...............1 Cod Produto
										DATA,;//................2 Data Movto
										ProdLeite[OPC,2],;//....3 Nr Docto
										ProdLeite[OPC,4],;//....4 Qtde
										0,;//...................5 Vlr Medio
										0,;//...................6 Vlr Venda
										'E',;//.................7 Tipo Entrada
										PROD->PR_CTB,;//........8 Tipo Produto
										'NFP',;//...............9 Serie - Nota Fiscal de Produtor
										ProdLeite[OPC,2],;//...10 Cod Fornec
										0,;//..................11 D-Conta contábil Despesa
										0,;//..................12 D-Conta contábil Icms
										0,;//..................13 Vlr Icms
										.F.,;//................14 Contabilizado ?
										'L'})//................15 FORMA = <L>eite
					elseif ProdLeite[OPC,5]>0
						DbGoTo(ProdLeite[OPC,5])
						if ProdLeite[OPC,4]==0
							ELIMINA_REG('Mov.Leite Produtor : '+trim(ProdLeite[OPC,3]))
						elseif reclock()
							replace ME_QTD with ProdLeite[OPC,4]
						end
					end
				next
				OPC:=0
			end
		end
	else
		alert('Nao tem Produtores Cadastrado')
	end
	select('MOVEST')
	ORDEM DTCOD
	DbGoTop()
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEP44E3() // Exclusão
*-----------------------------------------------------------------------------*
Alert(ProcName()+';Programa nao deve ser mais usado;conversado com Edna')
if MOVEST->ME_TIPO=='E'.and.MOVEST->ME_FORMA=='L'
	ELIMINA_REG('Transf. Entrada Leite')
else
	alert('So excluir movimentacao do tipo <E> Entrada - Forma = <L>')
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEP44E4() // Rotina de Impressao
*-----------------------------------------------------------------------------*
local CLI    := {1,99999}
local MES    := month(PARAMETRO->PA_DATA)
local ANO    := year(PARAMETRO->PA_DATA)
local ARQ    := ArqTemp(,,'')
local TOT    := array(32)
local X      := 0
local OPC    := 2
local TotGer := array(32)
private DATA := array(2)
private CODPR:= 30910 // código leite
Alert(ProcName()+';Programa nao deve ser mais usado;conversado com Edna')

if !CriaTmpLeite(ARQ)
	return NIL
end

	pb_box(14,0,,,,'Informe Dados')
	@15,02 say 'Produtor/Inicial:' get CLI[1] Pict mI5
	@15,42 say 'Produtor/Final..:' get CLI[2] Pict mI5 valid CLI[1]<=CLI[2]
	@16,02 say 'Mes/Ano.........:' Get MES    Pict mI2 valid MES>0.and.MES<13
	@16,23                         Get ANO    Pict mI4 valid ANO>2006.and.ANO<=year(PARAMETRO->PA_DATA)
	@18,02 say 'C¢d.Produto.....:' Get CODPR  Pict masc(21) valid fn_codpr(@CODPR,77)
	@19,02 say 'Ordem Listagem..:' Get OPC    pict mI1  valid OPC>0.and.OPC<3 when pb_msg('1=Codigo 2=Rota/Seq')
	read
	if if(lastkey()#27,pb_ligaimp(I20CPP),.F.)
		VM_REL :='Extrato Mensal Entrada Ref. '+pb_zer(MES,2)+'/'+str(ANO,4)
		Lar    :=160
		Pag    :=0
		
		DATA[1]:=    ctod('01/'+str(MES,2)+'/'+str(ANO,4))
		DATA[2]:=eom(ctod('01/'+str(MES,2)+'/'+str(ANO,4)))
		
		GeraLeite(DATA,CLI,CODPR) // Montar Arquivo
		
		pb_msg('Imprimindo Lista...')
		afill(TotGer,0)
		PROD->(dbseek(str(CODPR,L_P)))
		Select WORK
		if OPC==2
			OrdSetFocus('CHAVE_CLI')
		else
			OrdSetFocus('CODIGO_CLI')
		end
		DbGoTop()
		While !Eof()
			CLI[1]:=WK_CODCL
			afill(TOT,0)
			while !eof().and.CLI[1]==WK_CODCL
				if WK_DIA < 32
					TOT[WK_DIA]+=WK_QTDE
				else
					TOT[32]+=WK_QTDE
				end
				pb_brake()
			end
			Pag := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,PAG,'CFEP44E4A',LAR)
			CLIENTE->(dbseek(str(CLI[1],5)))
			?pb_zer(CLI[1],5)
			if CLIENTE->CL_LEITSQ > 0
				??'-'+left(CLIENTE->CL_RAZAO,20)
			else
				??'='+padr('*Sem rota definida*',20)
			end
			TotProdutor:=0
			??str(TOT[32],4)
			TotProdutor	+=TOT[32]
			TotGer[32]	+=TOT[32]
			for X:=1 to day(DATA[2]-1)
				??str(TOT[X],4)
				TotProdutor	+=TOT[X]
				TotGer[X]	+=TOT[X]
			next
			??str(TotProdutor,9)
		end
		? replicate('-',LAR)
		? padr('Totais Dias Impares',29,'.')
		TotProdutor:=0
		for X:=1 to day(DATA[2]-1) step 2
			??str(TotGer[X],5)+space(3)
			TotProdutor+=TotGer[X]
		next
		? padr('Totais Dias Pares',25,'.')+str(TotGer[32],5)
		for X:=2 to day(DATA[2]-1) step 2
			??space(3)+str(TotGer[X],5)
			TotProdutor+=TotGer[X]
		next
		??' ='+str(TotProdutor,7)
		? replicate('-',LAR)
		? 'Impresso as '+time()
		eject
		pb_deslimp(C20CPP)
	end
	select WORK
	Close
	FileDelete (Arq + '.*')
	select('MOVEST')
	ORDEM DTCOD
	DbGoTop()
return NIL

*-----------------------------------------------------------------------------*
 function CFEP44E4A()
*-----------------------------------------------------------------------------*
local X
?
? 'Produto : '+pb_zer(CODPR,L_P)+'-'+PROD->PR_DESCR
?
?  padr('Produtor',27)+'Ant|'
For X:=1 to day(DATA[2]-1)
	??padl(pb_zer(X,2),3,'.')+'|'
next
??'   Total'
?  replicate('-',LAR)
return NIL

*-----------------------------------------------------------------------------*
 function GeraLeite(DATA,CLI,CODPR)
*-----------------------------------------------------------------------------*
local Dia  :=0
local Chave:=''
SALVABANCO
select MOVEST
ORDEM DTPROE
DbGoTop()
dbseek(dtos(DATA[1]-1),.T.)
while !eof().and.MOVEST->ME_DATA<=(DATA[2]-1)
	pb_msg('Gerando Dados...'+dtoc(MOVEST->ME_DATA))
	if MOVEST->ME_CODPR== CODPR	.and.;
		MOVEST->ME_CODFO>= CLI[1]	.and.;
		MOVEST->ME_CODFO<= CLI[2]	.and.;
		MOVEST->ME_FORMA =='L'
		if  month(MOVEST->ME_DATA)==month(DATA[2])
			Dia := day(MOVEST->ME_DATA)
		else
			Dia :=98
		end
		CLIENTE->(dbseek(str(MOVEST->ME_CODFO,5)))
		Chave:=str(CLIENTE->CL_LEITSQ,5)+':'+str(MOVEST->ME_CODFO,5)+':'+str(day(MOVEST->ME_DATA))
		if len(DATA)>2
			Dia  :=99
			Chave:='Imprimir'
		end
		if !WORK->(dbseek(str(MOVEST->ME_CODFO,5)+str(Dia,2)))
			Grava_Work({MOVEST->ME_CODFO,;// 1
							Dia,;					// 2
							MOVEST->ME_QTD,;	//	3
							Chave,; 				//	4 Recebe Leite
							0,;
							''})
		else
			replace WORK->WK_QTDE with WORK->WK_QTDE + MOVEST->ME_QTD
		end
	end
	dbskip()
end
RESTAURABANCO
return NIL

*-----------------------------------------------------------------------------*
 function CriaTmpLeite(ARQ)
*-----------------------------------------------------------------------------*
local RT:=.T.
SALVABANCO
dbcreate(ARQ,{ {'WK_CODCL', 'N',  5,0},;//-1
					{'WK_DIA',   'N',  2,0},;//-2
					{'WK_QTDE',  'N', 15,2},;//-3
					{'WK_CHAVE', 'C', 20,0},;//-4
					{'WK_VLR1',  'N', 15,4},;//-5-Valor Total ou Valor Unitário
					{'WK_CARAC', 'C',132,0},;//-6
					{'WK_INFVLR','C',132,0}; //-7-Informaçoes de Valor
					})
if !net_use(ARQ,.T., ,'WORK', ,.F.,RDDSETDEFAULT())
	RT:=.F.
else
	Index on str(WK_CODCL,5)+str(WK_DIA,2) tag CODIGO_CLI to (ARQ)
	Index on WK_CHAVE+str(WK_DIA,2)        tag CHAVE_CLI  to (ARQ)
	OrdSetFocus('CODIGO_CLI')
end
RESTAURABANCO
return RT

*-----------------------------------------------------------------*
 function CFEP44E5() // CADASTRO DE FORNECEDORES DE LEITE
*-----------------------------------------------------------------*
setcolor(VM_CORPAD)
LEIT001()
setcolor(VM_CORPAD)
pb_dbedit1('CFEP44E','EntradLeite ExcluiLista Cadast')
return NIL

*-----------------------------------------------------------------*
 function GetProdLeite()
*-----------------------------------------------------------------*
local DET:={}
SALVABANCO
select CLIENTE
ORDEM LEITE
DbGoTop()
while !eof()
	aadd(DET,{CLIENTE->CL_LEITSQ,CLIENTE->CL_CODCL,CLIENTE->CL_RAZAO,0,0})
	skip
end
RESTAURABANCO
return DET
*------------------------------------------EOF-----------------------*