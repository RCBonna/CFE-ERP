*-----------------------------------------------------------------------------*
 static aVariav := {0,'',{},0,'',.T.,0,0,'CF ',{},5,'N',{},.F.,''}
*...................1..2..3.4..5..6..7,8...9...10,11,12,13.14..15
*---------------------------------------------------------------------------------------*
#xtranslate nX       => aVariav\[  1 \]
#xtranslate cArq     => aVariav\[  2 \]
#xtranslate aDig     => aVariav\[  3 \]
#xtranslate nOpc     => aVariav\[  4 \]
#xtranslate cTF      => aVariav\[  5 \]
#xtranslate lContNF  => aVariav\[  6 \]
#xtranslate FreteTot => aVariav\[  7 \]
#xtranslate PesoTot  => aVariav\[  8 \]
#xtranslate SerieCF  => aVariav\[  9 \]
#xtranslate aEnvolv  => aVariav\[ 10 \]
#xtranslate nLinICF  => aVariav\[ 11 \]
#xtranslate cTeste   => aVariav\[ 12 \]
#xtranslate aFAT     => aVariav\[ 13 \]
#xtranslate lRT      => aVariav\[ 14 \]
#xtranslate cTXTPARC => aVariav\[ 15 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
 function FATPDCF()	//	Digitacao de Conhecimento de Frete											*
*-----------------------------------------------------------------------------*
if !abre({	'C->PARAMETRO',;
				'C->CTRNF',;
				'C->TABICMS',;
				'C->CLIENTE',;
				'C->DPCLI',;
          	'C->DPFOR',;
				'C->HISFOR',;
				'C->HISCLI',;
				'C->CLIOBS',;
				'C->BANCO',;
				'C->CAIXACG',;
				'C->OBS',;
				'C->CONDPGTO',;
				'C->PEDPARC',;
				'C->XOBS',;
				'R->CODTR',;
				'C->PEDCAB',;
				'C->PEDDET',;
				'C->CFEACFC',;
				'C->CFEACFD',;
				'C->NATOP'})
	return NIL
end

pb_tela()
pb_lin4(_MSG_,ProcName())
select CFEACFC
dbsetorder(2) // Conhecimento Frete- Cabec - não impresso
set relation to str(CFC_CODCD,5) into CLIENTE
DbGoTop()
private VM_CAMPO:=array(fCount())
private VM_CABE :=array(fCount())

afields(VM_CAMPO)
afields(VM_CABE)
for nX:=1 to len(VM_CABE)
	VM_CABE[nX]:=SubStr(VM_CABE[nX],5)
end
pb_dbedit1('FATPDCF','IncluiAlteraPesqu.ExcluiImprim')  // tela
dbedit(06,01,maxrow()-3,maxcol()-1,;
		VM_CAMPO,;
		'PB_DBEDIT2',;
		,;// Mascara
		VM_CABE)
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function FATPDCFT(pInclui)
*-----------------------------------------------------------------------------*
local GETLIST	:= {}
FreteTot			:= 0
PesoTot			:= 0
lContNF			:=.F.

setcolor(VM_CORPAD)
scroll(6,1,21,78,0)
setcolor('W+/B,N/W,,,W+/B')
for nX :=1 to fCount()
	X1 :="VM"+substr(fieldname(nX),4)
	&X1:=&(fieldname(nX))
next

if pInclui
	VM_SERCF :='CF '
	VM_CODOP :=5353000
	VM_CODRE :=1000
	VM_TPFRE1:='1'
	VM_TPFRE2:=' '
	VM_VEICLO:=PARAMETRO->PA_CIDAD
	VM_VEICUF:=PARAMETRO->PA_UF
	VM_DTEMI :=PARAMETRO->PA_DATA
end
NATOP->(dbseek(str(VM_CODOP,7)))

*-------------------------------------------->
@06,01 say 'Data........:' get VM_DTEMI    pict mDT    valid VM_DTEMI<=PARAMETRO->PA_DATA
@06,27 say 'Serie:'        get VM_SERCF    pict mUUU   valid VM_SERCF==SCOLD.or.(fn_codigo(@VM_SERCF,{'CTRNF',{||CTRNF->(dbseek(VM_SERCF))},{||CFEPATNFT(.T.)},{2,1,3,4}})) color 'R/W'
@06,55 say 'Chave:'      + if(pInclui,pb_zer(VM_CHAVE,6),'Inclui')

@07,66 say 'Tipo Frete:'   get VM_TPFRE1   pict mI1    valid VM_TPFRE1$'12'  when pb_msg('Tipo de Frete <1>-Pago  <2>-A pagar')
@08,66 say 'Modo Frete:'   get VM_TPFRE2   pict mUUU   valid VM_TPFRE2$'12 ' when pb_msg('Modo de Frete <1>-Redespacho <2>-Cosignado  < >-Nenhum')
@07,01 say 'Remetente...:' get VM_CODRE    pict mI5    valid fn_codigo(@VM_CODRE,  {'CLIENTE', {||CLIENTE-> (dbseek(str(VM_CODRE,5)))},         {||CFEP3100T(.T.)},{2,1,8,7}})
@08,01 say 'Destinatario:' get VM_CODDE    pict mI5    valid fn_codigo(@VM_CODDE,  {'CLIENTE', {||CLIENTE-> (dbseek(str(VM_CODDE,5)))},         {||CFEP3100T(.T.)},{2,1,8,7}})  when pb_msg('Codigo do Destinatario')
@09,01 say 'Nat.Operacao:' get VM_CODOP    pict mNAT   valid fn_codigo(@VM_CODOP,{'NATOP',   {||NATOP->   (dbseek(str(VM_CODOP,7)))},       {||CFEPNATT(.T.)},{1,2,3}}).and.NATOP->NO_TIPO$'S'
@10,01 say 'local Coleta:' get VM_COLETA   pict mUUU   valid !empty(VM_COLETA) when pb_msg('local de Coleta')
@11,01 say 'local Entreg:' get VM_ENTREG   pict mUUU   valid !empty(VM_ENTREG) when pb_msg('local de Entrega')
@12,01 say 'Veiculo:Tipo:' get VM_VEICTP   pict mUUU   valid !empty(VM_VEICTP) when pb_msg('Tipo de Veiculo')
@12,28 say 'Marca:'        get VM_VEICMA   pict mUUU   valid !empty(VM_VEICMA) when pb_msg('Marca do Veiculo')
@12,50 say 'Placa:'        get VM_VEICPL   pict mPLACA valid !empty(VM_VEICPL) when pb_msg('Placa do Veiculo')
@12,70 say 'UF:'           get VM_VEICUF   pict mUUU   valid pb_uf(@VM_VEICUF) when pb_msg('UF Placa do Veiculo')
@13,08 say 'Local:'        get VM_VEICLO   pict mUUU   valid !empty(VM_VEICLO) when pb_msg('Cidade do Veiculo')
@13,43 say 'Motorista:'    get VM_VEICMO   pict mUUU   valid !empty(VM_VEICMO) when pb_msg('Motorista do Veiculo')
@14,01 to 14,78 color 'b+/w'
@14,25 say 'Valores do Conhecimento de Frete' color 'b+/w'

@15,01 say 'Vl Tarifa...:' get VM_TARIFA   pict mI102 valid VM_TARIFA>=0 when aDigNF(pInclui)
@16,01 say 'Vl Frete....:' get VM_VLFRET   pict mI102 valid VM_VLFRET>=0 when lContNF
@17,01 say 'Vl SEC/CAT..:' get VM_VLSEC    pict mI102 valid VM_VLSEC >=0 when lContNF
@18,01 say 'Vl Despacho.:' get VM_VLDESP   pict mI102 valid VM_VLDESP>=0 when lContNF

@15,28 say 'Vl ITR....:'   get VM_VLITR    pict mI102 valid VM_VLITR >=0 when lContNF
@16,28 say 'Vl Outros.:'   get VM_VLOUTR   pict mI102 valid VM_VLOUTR>=0 when lContNF
@17,28 say 'Vl Seguro.:'   get VM_VLSEG    pict mI102 valid VM_VLSEG >=0 when lContNF
@18,28 say 'Vl Pedagio:'   get VM_VLPED    pict mI102 valid VM_VLPED >=0 when lContNF

@15,52 say 'TOTAL FRETE.:' get FreteTot   pict mI102  when (FreteTot:=VM_TARIFA+VM_VLFRET+VM_VLSEC+VM_VLDESP+VM_VLITR+VM_VLOUTR+VM_VLSEG+VM_VLPED)>=0.and..F.
@16,52 say '% Aliq ICMS.:' get VM_VLALIQ  pict mI52   valid VM_VLALIQ >=0 when lContNF
@17,52 say 'Vl Base ICMS:' get VM_VLBASE  pict mI102  when (VM_VLBASE:=FreteTot)>=0.and..F.
@18,52 say 'Vl ICMS.....:' get VM_VLICMS  pict mI102  when (VM_VLICMS:=VM_VLBASE*VM_VLALIQ/100)>=0.and..F.

@19,01 say 'OBSERVACAO'
@19,52 say 'Peso Total..: ' get PesoTot    pict mI6    when .F.
@20,01 get VM_OBS pict mXXX+'S50'
@21,01 say 'Parcel.Frete:' get VM_PARCE pict mI2 valid VM_PARCE>=0.and.GetParcelas(VM_PARCE,VM_TPFRE1,FreteTot,VM_DTEMI) when pb_msg('Nro parcelas 0=Vista maior que Zero Prazo')
read
if lContNF.and.if(lastkey()#K_ESC,pb_sn(),.F.)
	VM_DESPAR:=''
	for nX:=1 to VM_PARCE
		VM_DESPAR+=dtoc(aFAT[nX,2])					// 01-10 dd/mm/aaaa
		VM_DESPAR+=str( aFAT[nX,3]*100,11)+'*'	// 11-21+1
	next
	if pInclui
		select CFEACFC
		ORDEM CODIGO // Conhecimento Frete- Cabec
		go bottom
		while !reclock();end
		VM_CHAVE:=CFC_CHAVE+1
		
		
		while !addrec();end
		for nX :=1 to FCount()
			X1:="VM"+substr(fieldname(nX),4)
			fieldput(nX,&X1)
		next
		select CFEACFD
		nOpc:=1 // controla sequencial (não usar nX - pode ter nf sem dados e ficar falha na sequencia)
		for nX:=1 to len(aDig)
			if aDig[nX,1]>0
				while !addrec(,{	VM_CHAVE,;	// Chave
										nOpc,;		// Sequencial
										aDig[nX,1],;// Nr Nota Fiscal
										aDig[nX,2],;// Serie NF
										aDig[nX,3],;// Nat Operação
										aDig[nX,4],;// Valor NF
										aDig[nX,5],;// Peso NF
										aDig[nX,6],;// Quantidade 
										aDig[nX,7];	// Especie
										});end
				nOpc++
			end
		next
		select CFEACFC
		ORDEM NAOIMP
		go top
	else // Alteração
		for nX :=1 to fcount()
			X1 :="VM"+substr(fieldname(nX),4)
			fieldput(nX,&X1)
		next
		select CFEACFD
		DbSeek(str(VM_CHAVE,6)+str(1,2),.T.)
		while !eof().and.CFD_CHAVE==VM_CHAVE
			while !reclock();end
			delete
			skip
		end
		nOpc:=1 // controla sequencial (não usar nX - pode ter nf sem dados e ficar falha na sequencia)
		for nX:=1 to len(aDig)
			if aDig[nX,1]>0
				while !addrec(,{	VM_CHAVE,;	// Chave
										nOpc,;		// Sequencial
										aDig[nX,1],;// Nr Nota Fiscal
										aDig[nX,2],;// Serie NF
										aDig[nX,3],;// Nat Operação
										aDig[nX,4],;// Valor NF
										aDig[nX,5],;// Peso NF
										aDig[nX,6],;// Quantidade 
										aDig[nX,7];	// Especie
										});end
				nOpc++
			end
		next
		select CFEACFC
	end
elseif !lContNF
	alert('Nenhuma nota fiscal informada;Digitacao Cancelada')
end
dbunlockall()
return NIL

*------------------------------------------------------------
static function GetParcelas(pParcelas,pTipo,pValor)
*------------------------------------------------------------
local GETLIST := {} //
lRT     :=.F.
cTXTPARC:=''
VM_CODCG:=if(empty(VM_CODCG),if(pTipo=='1',2,1),VM_CODCG)
pb_box(16,20,,,,if(pTipo=='1','Despesa','Receita'))
@17,21 say 'Cod.Banco........:' get VM_BCO   pict mI2   valid fn_codigo(@VM_BCO,  {'BANCO',  {||BANCO->(dbseek(str(VM_BCO,2)))},    {||CFEP1500T(.T.)},{2,1}}) when pb_msg('Codigo Conta Banco ou Caixa-para valores a vista').and.NATOP->NO_FLTRAN#'S'.and.pParcelas==0
@18,21 say 'Cod.Receita Caixa:' get VM_CODCG pict mI3   valid fn_codigo(@VM_CODCG,{'CAIXACG',{||CAIXACG->(dbseek(str(VM_CODCG,3)))},{||CXAPCDGRT(.T.)},{2,1}}) when USACAIXA.and.pb_msg('Codigo de lancamento no Caixa').and.NATOP->NO_FLTRAN#'S'.and.PEDCAB->PC_FATUR==0
@19,21 say 'Valor............:' get pValor   pict mI102 when .F.
read
if pParcelas>0
	aFAT:=fn_parc(VM_PARCE,pValor,1,PARAMETRO->PA_DATA)
	if len(aFAT)==pParcelas
		lRT:=.T.
//		fn_grparc(VM_ULTPD,TXTPARC) //.........................Gravar Parcelamento
	else
		lRT:=.F.
	end
else
	pb_msg('Valor a vista...',0.3)
	lRT:=.T.
end
return lRT

*--------------------------------------------------
	function LoadNF(pInclui)
*--------------------------------------------------
aDig:={}
for nX:=1 to 5
	*----------NF SER  NatOp-Vlr-Peso-Qtd---Especie
	aadd(aDig,{0,'   ',    0,  0,   0,  0, space(15)})
next
if !pInclui // É Alteração
	select CFEACFD
	DbSeek(str(VM_CHAVE,6)+str(1,2),.T.)
	while !eof().and.CFD_CHAVE==VM_CHAVE
		for nX:=3 to fCount()
			aDig[CFD_SEQ,nX-2]:=FieldGet(nX)
		next
		skip
	end
	select CFEACFC
end
return NIL

*--------------------------------------------------
static function aDigNF(pInclui)
*--------------------------------------------------
local GETLIST := {}

LoadNF(pInclui)

nOpc   := 1
cTF :=savescreen(11,00,20,79)
setcolor('W+/BG,R/W,,,W+/BG')
while nOpc>0
	pb_msg('Esc para sair da digitacao de notas')
	nOpc:=abrowse(	11,08,20,74,;
						aDig,;
						{'NrNFis','Serie','Nat.Oper','Valor NF','Peso','Qtdad','Especie'},;
						{       6,      3,        10,        13,     6,      6,       15},;
						{     mI6,   mUUU,      mNAT,     mI122,   mI6,    mI6,     mXXX},,;
						'Informacoes NF do Conhec.Frete')

	if nOpc>0
		vNrNF :=aDig[nOpc,1]
		vSerie:=aDig[nOpc,2]
		vNatOp:=aDig[nOpc,3]
		vVlrNF:=aDig[nOpc,4]
		vPeso :=aDig[nOpc,5]
		vQtde :=aDig[nOpc,6]
		vEspec:=aDig[nOpc,7]
		@row(),09 get vNrNF  pict mI6   when pb_msg('Digite ZERO para eliminar esta nota fiscal da digitacao')
		@row(),16 get vSerie pict mUUU  valid fn_codigo(@vSerie,{'CTRNF',{||CTRNF->(dbseek(vSerie))},{||CFEPATNFT(.T.)},{2,1,3,4}}).and.!empty(CTRNF->NF_MODELO).and.CTRNF->NF_MODELO#"00"     when vNrNF>0.AND.pb_msg('Serie tem que ser cadastrada e modelo deve ser diferente de 00 ou brancos')
		@row(),20 get vNatOp pict mNAT  valid fn_codigo(@vNatOp,{'NATOP',{||NATOP->(dbseek(str(vNatOp,7)))},{||CFEPNATT(.T.)},{1,2,3}}) when vNrNF>0
		@row(),31 get vVlrNF pict mI122 valid vVlrNF>=0 when vNrNF>0
		@row(),45 get vPeso  pict mI6   valid vPeso>=0  when vNrNF>0
		@row(),52 get vQtde  pict mI6   valid vQtde>=0  when vNrNF>0
		@row(),59 get vEspec pict mXXX  when vNrNF>0
		read
		if lastkey()#K_ESC
			if  vNrNF>0
				aDig[nOpc,1]:=vNrNF
				aDig[nOpc,2]:=vSerie
				aDig[nOpc,3]:=vNatOp
				aDig[nOpc,4]:=vVlrNF
				aDig[nOpc,5]:=vPeso
				aDig[nOpc,6]:=vQtde
				aDig[nOpc,7]:=vEspec
				keyboard replicate(chr(K_DOWN),nOpc)
			else
				aDig[nOpc]:={0,'   ',    0,  0,   0,  0, space(15)}
			end
		end
	else
		lContNF:=.F.
		AEval(aDig,{|DET|lContNF:=if(DET[1]>0,.T.,lContNF)})
		PesoTot:= 0
		AEval(aDig,{|DET|PesoTot+=DET[5]})
		if !lContNF
			if !pb_sn('Nao ha notas fiscais informadas;para este conhecimento de frete;Deseja sair e cancelar digitacao?')
				nOpc:=0
			end
		end
	end
end
restscreen(11,00,20,79,cTF)
setcolor(VM_CORPAD)
set cursor ON
return lContNF

*------------------------------------------------> Arquivos do DBF
 function CRIA_CFRETE(P1,P2)	//	Criacao dos arquivos
*------------------------------------------------* CONHECIMENTO DE FRETE - CABEÇALHO
cArq:='CFEACFC'
if P2=='VER ARQUIVOS'.and.;
	dbatual(cArq,;
				{{'CFC_CHAVE', 'N',  6,  0},;	// 01-Sequencial (PI)
				 {'CFC_NUMCF', 'N',  6,  0},;	// 02-Codigo Conhecimento Frete
				 {'CFC_SERCF', 'C',  3,  0},;	// 03-Serie CT (única)
				 {'CFC_CODOP', 'N',  7,  0},;	// 04-Natureza Operção
				 {'CFC_DTEMI', 'D',  8,  0},;	// 05-Data Emissão
				 {'CFC_CODRE', 'N',  5,  0},;	// 06-Codigo Remetente
				 {'CFC_CODDE', 'N',  5,  0},;	// 07-Código Destinatario
				 {'CFC_CODRC', 'N',  5,  0},;	// 08-Código Redespacho/Consignado
				 {'CFC_TPFRE1','C',  1,  0},;	// 09-TipoFrete1 (1-Pago/2-A Pagar)
				 {'CFC_TPFRE2','C',  1,  0},;	// 10-TipoFrete2 (1-Redespacho/2-Consignado/" "-Nenhum)
				 {'CFC_COLETA','C', 50,  0},;	// 11-local Coleta
				 {'CFC_ENTREG','C', 50,  0},;	// 12-local Entrega
				 {'CFC_VEICTP','C', 12,  0},;	// 13-Veículo-Tipo
				 {'CFC_VEICMA','C', 12,  0},;	// 14-Veículo-Marca
				 {'CFC_VEICPL','C',  7,  0},;	// 15-Veículo-Placa
				 {'CFC_VEICLO','C', 20,  0},;	// 16-Veículo-Local
				 {'CFC_VEICUF','C',  2,  0},;	// 17-Veículo-UF
				 {'CFC_VEICMO','C', 25,  0},;	// 17-Veículo-Motorista
				 {'CFC_TARIFA','N', 10,  2},;	// 18-Valor Tarifa
				 {'CFC_VLFRET','N', 10,  2},;	// 19-Valor Frete
				 {'CFC_VLSEC', 'N', 10,  2},;	// 20-Valor SEC/CAT
				 {'CFC_VLDESP','N', 10,  2},;	// 21-Valor Depacho
				 {'CFC_VLITR', 'N', 10,  2},;	// 22-Valor ITR
				 {'CFC_VLOUTR','N', 10,  2},;	// 23-Valor OUTROS
				 {'CFC_VLSEG', 'N', 10,  2},;	// 24-Valor Seguros
				 {'CFC_VLPED', 'N', 10,  2},;	// 25-Valor Pedágio
				 {'CFC_VLBASE','N', 10,  2},;	// 26-Valor Base ICMS
				 {'CFC_VLALIQ','N',  5,  2},;	// 27-% Aliquota
				 {'CFC_VLICMS','N', 10,  2},;	// 28 Vlr ICMS
				 {'CFC_PARCE', 'N',  2,  0},;	// 29 Nro Parcelas 0=Vista >1 a prazo
				 {'CFC_CODCG', 'N',  3,  0},;	// 30-Cod Grupo Caixa
				 {'CFC_BCO',   'N',  2,  0},;	// 31-Numero do Caixa de Venda/Compra
				 {'CFC_CONTAB','L',  1,  0},;	// 32 Contabizado ?
				 {'CFC_CAIXA', 'L',  1,  0},;	// 33 Integração Caixa?
				 {'CFC_DESPAR','C',211,  0},;	// 34 Descricao Parcelas
				 {'CFC_OBS',   'C', 80,  0}},;// 35 OBS
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

if !file(cARQ+OrdBagExt()).or.P1
	pb_msg('Reorg. FRETE-CABEC',NIL,.F.)
	if net_use(cARQ,.T.,20,cARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		Index on str(CFC_CHAVE,6)                 tag CODIGO to (cARQ) eval ODOMETRO(cARQ,'CODIGO')
		Index on str(CFC_CHAVE,6)                 tag NAOIMP to (cARQ) eval ODOMETRO(cARQ,'NAOIMP') for  empty(CFC_NUMCF)
		Index on dtos(CFC_DTEMI)+str(CFC_NUMCF,6) tag DTCFRE to (cARQ) eval ODOMETRO(cARQ,'DTCFRE') for !empty(CFC_NUMCF)
		close
	end
end

*--------------------------CONHECIMENTO DE FRETE (DETALHE)-------------------------------------
cArq:='CFEACFD'
if dbatual(cArq,;
				{{'CFD_CHAVE', 'N',  6,  0},;	// 01-Sequencial (PI)
				 {'CFD_SEQ',   'N',  2,  0},;	// 02-Codigo Conhecimento Frete
				 {'CFD_NRNF',  'N',  9,  0},;	// 03-Nr Nota Fiscal
				 {'CFD_SERCF', 'C',  3,  0},;	// 03-Serie Nota Fiscal
				 {'CFD_NATOP', 'N',  7,  0},;	// 04-Natureza Operação
				 {'CFD_VLNF',  'N', 12,  2},;	// 05-Valor NF
				 {'CFD_PESO',  'N',  6,  0},;	// 06-Peso Mercadorias
				 {'CFD_QTDAD', 'N',  6,  0},;	// 07-Quantidade
				 {'CFD_ESPECI','C', 15,  0}},;// 08-Código Redespacho/Consignado
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end
if !file(cARQ+OrdBagExt()).or.P1
	pb_msg('Reorg. FRETE-DETELHE',NIL,.F.)
	if net_use(cARQ,.T.,20,cARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		Index on str(CFD_CHAVE,6)+str(CFD_SEQ,2) tag CODIGO to (cARQ) eval ODOMETRO(cARQ,'CODIGO')
		close
	end
end
return NIL
*
*--------------------------------------------------EOF---------------------------------------------
