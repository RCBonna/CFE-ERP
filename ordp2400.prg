//-----------------------------------------------------------------------------*
  static aVariav := {'','',0,'',0,0,{}}
//.....................................................1.......2....3.....4....5...6
//-----------------------------------------------------------------------------*
#xtranslate aCab     => aVariav\[  1 \]
#xtranslate aDet     => aVariav\[  2 \]
#xtranslate X		   => aVariav\[  3 \]
#xtranslate TXTPARC  => aVariav\[  4 \]
#xtranslate nProd    => aVariav\[  5 \]
#xtranslate nCodTrib => aVariav\[  6 \]
#xtranslate aTOT     => aVariav\[  7 \]


*-----------------------------------------------------------------------------*
function ORDP2400()	//	Fecha OS/OP..														*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
pb_tela()
pb_lin4(_MSG_,ProcName())
if !abre({	'C->PARAMETRO',;
				'C->DIARIO',;
				'C->GRUPOS',;
				'C->PROD',;
				'C->MOVEST',;
				'C->TABICMS',;
				'C->CLIENTE',;
				'C->CLIOBS',;
				'C->DPCLI',;
				'C->HISCLI',;
				'C->BANCO',;
				'C->VENDEDOR',;
				'C->OBS',;
				'C->CAIXACG',;
				'C->CAIXAMB',;
				'C->CONDPGTO',;
				'C->XOBS',;
				'R->CODTR',;
				'C->PEDCAB',;
				'C->PEDDET',;
				'C->PEDSVC',;
				'C->CTRNF',;
				'C->PEDPARC',;
				'C->NATOP',;
				'C->CTADET',;
				'C->CTACTB',;
				'R->LOTEPAR',;
				'C->PARALINH',;
				'C->ADTOSD',;	//ADIANTAMENTO A CLIENTE - DETALHE
				'C->ADTOSC',;	//ADIANTAMENTO A CLIENTE - CABEÇALHO
				'E->PARAMORD',;
				'E->ATIVIDAD',;
				'E->MECMAQ',;
				'E->EQUIDES',;
				'E->ORCACAB',;
				'E->MOVORDEM',;
				'E->ORDEM'})
	return NIL
end

PROD->(dbsetorder(2))

if pb_sn('Deseja ver somente '+PARAMORD->PA_DESCR3+' Abertas ?')
	set filter to !OR_FLAG
	DbGoTop()
end

MOVORDEM->(dbsetorder(3))
ORCACAB->(dbsetorder(5))
set relation   to str(OR_CODCL,5) into CLIENTE,;
					to OR_CODED into EQUIDES

VM_CAMPO:={};aeval(dbstruct(),{|DET|aadd(VM_CAMPO,DET[1])})
VM_CAMPO[2]='pb_zer(OR_CODCL,5)+chr(45)+CLIENTE->CL_RAZAO'
VM_CAMPO[3]='OR_CODED+chr(45)+EQUIDES->ED_DESCR'
VM_CAMPO[7]='if(OR_FLAG,"Fechada","Aberta ")'

VM_MARKDEL = .F.

pb_dbedit1('ORDP240','FecharPesqui')
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
						{masc(19),  masc(1),                  masc(1),masc(1), masc(7), masc(7),   masc(1)},;
						{ 'Ordem','Cliente',trim(PARAMORD->PA_DESCR2),  'OBS','DtEntr','DtSaid','Situacao'})
pb_compac(VM_MARKDEL)
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function ORDP2401()	//	Fechar
*-----------------------------------------------------------------------------*
local OBS:={},;
		VM_BCO     :=1,;
		VM_DTSAI   :=OR_DTSAI,;
		VM_DPL     :=OR_CODOR,;
		VM_VACRE   :=OR_VACRE,;
		VM_VIPI    :=OR_VIPI ,;
		VM_LIMPR   :='S'

private VM_VDESC :=OR_VDESC
private VM_PARC  :=0
private VM_VICMS :=OR_VICMS

if !OR_FLAG
	EQUIDES->(dbseek(ORDEM->OR_CODED))
	ORCACAB->(dbseek(str(ORDEM->OR_CODOR,6)))
	aDet   :={}
	fn_OrdCal(aDet) // retorna   aToT
	VM_FAT:={}
	for X:=1 to 5
		aadd(OBS,substr(OR_OBS,X*60-59,60))
	end
	TOTAL:=aTot[1]+aTot[2]
	pb_box(5,0,,,,trim(PARAMORD->PA_DESCR3)+'-'+pb_zer(OR_CODOR,6)+;
						'Cliente',15,+&(VM_CAMPO[2]))
	@06,1 say padr(trim(PARAMORD->PA_DESCR2),15,'.')+&(VM_CAMPO[3])
	@07,1 say padr('OBS/1',15,'.')        +OBS[1]
	@08,1 say padr('OBS/2',15,'.')        +OBS[2]
	@09,1 say padr('OBS/3',15,'.')        +OBS[3]
	@10,1 say padr('OBS/4',15,'.')        +OBS[4]
	@11,1 say padr('OBS/5',15,'.')        +OBS[5]
	@12,1 say padr('Dt.Entrada',15,'.')   +dtoc(OR_DTENT)
	if ORCACAB->(found())
		@12,50 say 'Valores Or‡ados' color 'R/W'
		@13,50 say transform(ORCACAB->OC_VPROD*ORDEM->OR_QUANT,masc(2))
		@14,50 say transform(ORCACAB->OC_VMDO*ORDEM->OR_QUANT,masc(2))
		@15,50 say transform((ORCACAB->OC_VMDO+ORCACAB->OC_VPROD)*ORDEM->OR_QUANT,masc(2))
//		TOTAL:=(ORCACAB->OC_VMDO+ORCACAB->OC_VPROD)*ORDEM->OR_QUANT
	end
	@13,01 say padr('Vlr Produtos',20,'.')+transform(aTot[1],mI102)
	@14,01 say padr('Vlr Mao-Obra',20,'.')+transform(aTot[2],mI102)
	@15,01 say padr('Vlr Total-Cobrar',20,'.')+transform(TOTAL,mI102) color 'R/B'
	@16,01 say padr('Vlr Descontos',19,'.')    get VM_VDESC pict mI102  valid VM_VDESC>=0.and.fn_imprv(transform(TOTAL-VM_VDESC+VM_VACRE+VM_VIPI+VM_VICMS,masc(2)),{18,21}).and.VM_VDESC<=TOTAL
	@17,01 say padr('Vlr Acrescimos',19,'.')   get VM_VACRE pict mI102  valid VM_VACRE>=0.and.fn_imprv(transform(TOTAL-VM_VDESC+VM_VACRE+VM_VIPI+VM_VICMS,masc(2)),{18,21})
	@16,40 say padr('Vlr ICMS',10,'.')         get VM_VICMS pict mI102  valid VM_VICMS>=0.and.fn_imprv(transform(TOTAL-VM_VDESC+VM_VACRE+VM_VIPI+VM_VICMS,masc(2)),{18,21})
	@17,40 say padr('Vlr IPI' ,10,'.')         get VM_VIPI  pict mI102  valid VM_VIPI >=0.and.fn_imprv(transform(TOTAL-VM_VDESC+VM_VACRE+VM_VIPI+VM_VICMS,masc(2)),{18,21})
	@18,01 say padr('Valor Liquido',20,'.')+transform(TOTAL,mI102)
	@19,01 say padr('Dt.Saida Efetiva',20,'.')  get VM_DTSAI pict mDT valid VM_DTSAI>=OR_DTENT.and.VM_DTSAI<=date()+15
	@18,40 say padr('0-Vista/1,2..Parc',20,'.') get VM_PARC  pict masc(11) valid VM_PARC==0.or.(len(VM_FAT:=fn_parc(VM_PARC,TOTAL-VM_VDESC+VM_VACRE+VM_VIPI+VM_VICMS,VM_DPL,VM_DTSAI)))>=0
	@19,40 say padr('Nr DPL Basico',20,'.')     get VM_DPL   pict masc(19) valid VM_DPL>0
	@20,40 say padr('C¢digo Banco',20,'.')      get VM_BCO   pict masc(11) valid fn_codigo(@VM_BCO,{'BANCO',{||BANCO->(dbseek(str(VM_BCO,2)))},{||CFEP1500T(.T.)},{2,1}})
	@21,40 say padr('Imprimir OS/OP?',20,'.')   get VM_LIMPR pict mUUU     valid VM_LIMPR$'SN' when pb_msg('Imprimir ?     <S>im    <N>ao')
	read
	setcolor(VM_CORPAD)
	if lastkey()#K_ESC
		TOTAL:=TOTAL-VM_VDESC+VM_VACRE+VM_VIPI+VM_VICMS
		FLAG :=pb_sn('Ordem '+trim(PARAMORD->PA_DESCR3)+'. Fechar ?')
		VM_CODOR:=ORDEM->OR_CODOR
		if FLAG
			replace 	;
						ORDEM->OR_VDESC with VM_VDESC,;
						ORDEM->OR_VPROD with aTot[1],;
						ORDEM->OR_VMDO  with aTot[2],;
						ORDEM->OR_PARC  with VM_PARC,;
						ORDEM->OR_DPL   with VM_DPL,; 
						ORDEM->OR_DTSAI with VM_DTSAI,;
						ORDEM->OR_VIPI  with VM_VIPI,;
						ORDEM->OR_VICMS with VM_VICMS,;
						ORDEM->OR_VACRE with VM_VACRE,;
						ORDEM->OR_SERIE with 'ORD'
			dbskip(0)
			FLAG:=.F.
			if if(VM_LIMPR=='S',pb_ligaimp(C15CPP),.F.)
				FLAG:=.T.
				VM_FLNOME:='A'
				CLIENTE->(dbseek(str(ORDEM->OR_CODCL,5)))
				EQUIDES->(dbseek(ORDEM->OR_CODED))
				VM_REL:='Lista '+trim(PARAMORD->PA_DESCR3)+' N.'+pb_zer(VM_CODOR,6)
				VM_LAR:=78
				VM_PAG:= 0
				ORDP310I(VM_CODOR)
				pb_deslimp()
				
			end
			if FLAG
				if PARAMORD->PA_INTFAT
					pb_msg('Atualizando Pedido...')
					ORDP2401X()
					replace 	ORDEM->OR_FLAG  with .T.
					replace EQUIDES->ED_DTULM with VM_DTSAI
				end
				// dbcommitall()
			end
		end
	end
else
	pb_msg('Ordem '+trim(PARAMORD->PA_DESCR3)+' j  Fechada.',15,.T.)
end
return NIL

*-----------------------------------------------------------------------------*
 function ORDP2401X()	//	Rotina de Pesquisa
*-----------------------------------------------------------------------------*
private VM_CODOP :=5101000
private VM_ULTPD :=fn_psnf('PED')
private VM_CLI   :=ORDEM->OR_CODCL
private VM_DESCG :=0
private VM_TOT   :=TOTAL
private VM_VLRENT:=0
private VM_ENCFI :=0
private VM_PARCE :=VM_PARC
private VM_VEND  :=1
private VM_SERIE :='ORD'
private VM_OBS   :='Venda via OP'
private VM_CODFC :=''
private VM_SVC   :='Venda via OP'
private NUM_CXA  :=0
private VM_LOTE  :=0
private VM_TPTRAN:=0
private VM_FLADTO:='N'
private VM_DET   :={}

salvabd(SALVA)
select MOVORDEM
ordem ORDEMG
dbseek(str(VM_CODOR,6),.T.)
for X:=1 to len(aDet)
	aadd(VM_DET,{	0,;	//................................................01.Desconto Geral
						aDet[X][1],;//..........................................02.Cod.Produto ou servico
						'',;//..................................................03.descricao
						aDet[X][2],;//..........................................04.Qtdade
						pb_divzero(aDet[X][16],aDet[X][2]),;//..................05-Vlr Unit.Venda
						trunca(pb_divzero(aDet[X][16],(aTOT[1]+aTOT[2])*ORDEM->OR_VDESC),2),;//.........06-Vlr Desconto proporcional item
						0,;//...................................................07
						aDet[X][8],;//..........................................08.Cod.Trib
						0,;//...................................................09-%ICMS
						0,;//...................................................10
						100,;//.................................................11-% Tributação
						,;//....................................................12
						,;//....................................................13
						pb_divzero(aDet[X][16],aDet[X][2]),;//..................14-Preco Venda
						,;//....................................................15
						,;//....................................................16
						VM_CODOP,;//............................................17-Nat Operacao
						,;//....................................................18
						0,;//...................................................19-Nro adiantamento
						'',;//..................................................20-Clas IPI
						0,;//...................................................21 -Grupo-Dest-Transf-DEBITO
						0,;//...................................................22 -Grupo-Dest-Transf-CREDITO
						'   ',;//...............................................23 -Código PIS (interno)
						0,;//...................................................24 -% PIS
						0,;//...................................................25 -Base PIS
						0,;//...................................................26 -Valor PIS
						0,;//...................................................27 -% Cofins
						0,;//...................................................28 -Base Cofins
						0})//...................................................29 -Valor Cofins
end

aeval(VM_DET,{|DET|VM_DESCG+=DET[6]}) // somar valor total desconto
if str(VM_DESCG,15,2)#str(ORDEM->OR_VDESC,15,2)
	VM_DET[1,6]+=(ORDEM->OR_VDESC-VM_DESCG) // Ajustar diferença
end
VM_DESCG :=0 // usado acima para calculo de arredondamento
SELECT PEDCAB
ORDEM GPEDIDO
while dbseek(str(VM_ULTPD,6))
	VM_ULTPD:=fn_psnf('PED')
end
ORDEM FPEDIDO
salvabd(RESTAURA)
FATPGRPE('Novo','Produto') //........................................Atualizar Pedidos
if VM_PARCE>0
	TXTPARC:=''
	for X:=1 to VM_PARCE
		TXTPARC+=dtoc(VM_FAT[X,2])				 // 01-09(data)
		TXTPARC+=str( VM_FAT[X,3]*100,11)+'*'// 11-21+1 (valor-inteiro)
	next
	fn_grparc(VM_ULTPD,TXTPARC) //.........................Gravar Parcelamento
end
Alert('Pedido '+pb_zer(VM_ULTPD,6)+';Gravado e pronto para faturamento')

return NIL

*-----------------------------------------------------------------------------*
 function ORDP2402()	//	Rotina de Pesquisa
*-----------------------------------------------------------------------------*
local ORD:=alert('Selecione Ordem...',{'C¢digo','Cliente'},'R/W')
if ORD>0
	dbsetorder(ORD)
	PESQ(indexord())
end
return NIL

*-----------------------------------------------------------------------------*
 function FN_ORDCAL()	//	
*-----------------------------------------------------------------------------*
aTOT:={0,0}
aDet:={}
salvabd(SALVA)
select('MOVORDEM')
dbseek(str(ORDEM->OR_CODOR,6),.T.)
while !eof().and.ORDEM->OR_CODOR==MOVORDEM->IT_CODOR
	aTOT[MOVORDEM->IT_TIPO]+=MOVORDEM->IT_VLRRE
	nProd   :=MOVORDEM->IT_CODPR
	nCodTrib:='000'
	if MOVORDEM->IT_TIPO#1//................................se for servico pegar codigo do produto para movimentação estoque.
		if MECMAQ->(dbseek(str(MOVORDEM->IT_CODPR,2)))
			nCodTrib:='999'
			nProd   :=MECMAQ->MM_CODPR
		end
	end
	aadd(aDet,{	nProd,;//.............................................................................1.Cod Prod
					MOVORDEM->IT_QTD,;//................................................2.Qtdade
					trunca(pb_divZero(MOVORDEM->IT_VLRRE,MOVORDEM->IT_QTD),2),;//...... 3.Unit Venda
					trunca(pb_divZero(MOVORDEM->IT_VLRRE,MOVORDEM->IT_QTD),2),;//.......4.Unit Medio
					0,;//...............................................................5.Vlr Desconto Geral
					0,;//...............................................................6.Vlr Desconto Prop
					0,;//...............................................................7.% ICMS
					if(MOVORDEM->IT_TIPO==1,'000','999'),;//............................8.Se For servico Cod.Trib=999
					100,;//...........................................................9.%Tributacao
					0,;//..............................................................10.Base Icms
					0,;//..............................................................11.Base Outr Icms
					0,;//..............................................................12.Base Isento Icms
					0,;//..............................................................13.Base Isento Icms
					0,;//..............................................................14.Vlr Icms
					0,;//.............................................................15.Nr Adto
					MOVORDEM->IT_VLRRE})//..................16 valor total
	skip
end
salvabd(RESTAURA)
return ({aTOT[1],aTOT[2]})
*------------------------------------EOF---------------------------------------*
