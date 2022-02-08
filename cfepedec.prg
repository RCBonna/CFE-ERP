 static aVariav := {.T.,0,{},0, 'N',{}, 0, 0, 0, 0, 0, 0}
 //..................1..2..3..4..5...6..7..8..9.10.11.12
*-----------------------------------------------------------------------------*
#xtranslate lRT      	=> aVariav\[  1 \]
#xtranslate nX	      	=> aVariav\[  2 \]
#xtranslate aReg      	=> aVariav\[  3 \]
#xtranslate nY	      	=> aVariav\[  4 \]
#xtranslate cEdTrans  	=> aVariav\[  5 \]
#xtranslate aNFEnt	  	=> aVariav\[  6 \]
#xtranslate vDesconto	=> aVariav\[  7 \]
#xtranslate vTotalNF		=> aVariav\[  8 \]
#xtranslate vICMSBase	=> aVariav\[  9 \]
#xtranslate vICMSVlr		=> aVariav\[ 10 \]
#xtranslate vIPIBase		=> aVariav\[ 11 \]
#xtranslate vIPIVlr		=> aVariav\[ 12 \]

*-----------------------------------------------------------------------------*
 function CFEPEDEC()	//	Edita Entrada de NF												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
private F_SERIE:='   '
private F_FORNEC:=0
private F_FORNEX:=99999
private F_DOCTO :=0
private F_DATA  :={CtoD(''),CtoD('31/12/2100')}
private Filtro:=''
cEdTrans:='N'
if !abre({	'C->PARAMETRO',;
				'C->PARALINH',;
				'C->TABICMS',;
				'C->BANCO',;
				'C->ENTDET',;
				'R->CODTR',;
				'R->FISACOF',;
				'R->UNIDADE',;
				'C->CTRNF',;
				'C->ENTCAB',;
				'C->PROD',;
				'C->NATOP',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'C->DIARIO',;
				'C->CLIENTE'})
	return NIL
end
pb_tela()
pb_lin4(_MSG_,ProcName())

select PROD
ORDEM CODIGO // Dt+Docto

select('ENTCAB')
ORDEM DTEDOC // Dt+Docto

set relation to str(EC_CODFO,5) into CLIENTE
DbGoTop()
set key K_ALT_X   to AjustSerie()
pb_dbedit1('CFEPEDE','IncluiAlteraPesqu.ExcluiACERTOImprE.')  // TELA
dbedit(06,01,maxrow()-3,maxcol()-1,;
		{'EC_DOCTO','EC_SERIE','pb_zer(EC_CODFO,5)+chr(45)+left(CLIENTE->CL_RAZAO,20)','EC_TPDOC','EC_CODOP','EC_DTENT','EC_CODTR','EC_TOTAL',    'EC_DESC', 'EC_IPI', 'EC_ICMSB',     'EC_ICMSP','EC_ICMSV' },;
		 'PB_DBEDIT2'                                                                                                                                                                 ,;
		{  masc(09),     mUUU,   mUUU,                                                   mUUU,      mNAT,       mDT,  masc(01),  masc(02),      masc(02),  masc(02),   masc(02),       masc(20),  masc(02)    },;
		{'Docto',     'Serie', 'Fornecedor',                                            'TPD',    'Nat.OP',  'Entrada',  'ClFis','Valor Total','Vlr Desc','Vlr IPI','Vlr BaseICMS','% ICMS',  'Valor ICMS'})
dbcloseall()
set key K_ALT_X   to
return NIL

*-----------------------------------------------------------------------------*
function CFEPEDE1() // Inclusao
	dbgobottom()
	dbskip()
	CFEPEDECT(.T.)
return NIL

*-----------------------------------------------------------------------------*
function CFEPEDE2()	// Alteracao
if if(EC_GERAC$' G',pb_sn('Deseja alterar um Docto Gerado pelo Sistema de Entrada ?'),.T.)
	if reclock()
		CFEPEDECT(.F.)
	end
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
function CFEPEDECT(VM_FL)
*-----------------------------------------------------------------------------*
local X
local LCONT :=.T.
local REGANT:=recno()
for X:=1 to fcount()
	X1:="VM"+substr(fieldname(X),3)
	&X1:=&(fieldname(X))
next
if VM_FL
	VM_DTEMI:=date()
	VM_DTENT:=date()
	VM_DOCTO:=0
	VM_TPDOC:='NF '
	VM_CODTR:='000'
end
VM_CODFOA:=VM_CODFO
VM_DOCTOA:=VM_DOCTO
VM_SERIEA:=VM_SERIE
VM_FLCTB :=if(EC_FLCTB,'S','N')
VM_DTEMI :=if(empty(VM_DTEMI),PARAMETRO->PA_DATA,VM_DTEMI)
VM_NFEKEY:=if(empty(VM_NFEKEY),padr('0',44,'0'),VM_NFEKEY)
pb_box(,,,,,'Editar Nota Fiscal de Entrada')
@06,01 say 'Dt Emiss„o..:'     get VM_DTEMI  pict mDT
@06,41 say 'Dt Entrada..:'     get VM_DTENT  pict mDT
@07,01 say 'Tipo Docto..:'     get VM_TPDOC  pict mUUU     valid fn_codar(@VM_TPDOC,'TP_DOCTO.ARR')
@08,01 say 'Emitente....:'     get VM_CODFO  pict masc(04) valid fn_codigo(@VM_CODFO,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODFO,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@09,01 say 'Documento...:'     get VM_DOCTO  pict masc(09) 
@09,40 say 'Serie.......:'     get VM_SERIE  pict masc(01) valid VM_SERIE==SCOLD.or.fn_codigo(@VM_SERIE,{'CTRNF',{||CTRNF->(dbseek(VM_SERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}}).and.pb_ifcod2(str(VM_DOCTO,8)+VM_SERIE+str(VM_CODFO,5),nil,!VM_FL,1)
@10,01 say 'Nat.Operacao:'     get VM_CODOP  pict mNAT     valid fn_codigo(@VM_CODOP,{'NATOP',{||NATOP->(dbseek(str(VM_CODOP,7)))},{||CFEPNATT(.T.)},{2,1}}).and.NATOP->NO_TIPO$'EO'                        //when VM_TPDOC#'AJU'
@12,01 say 'Total Docto.:'     get VM_TOTAL  pict masc(05) valid VM_TOTAL>0                                                                                                                                  //when NATOP->NO_CDVLFI#4.and.VM_TPDOC#'AJU' // so especiais
@12,40 say 'Nr Parcelas.:'     get VM_FATUR  pict mI2      valid VM_FATUR>=0                                     when pb_msg('Nr Parcelas:  Zero = Vista, 1,2,3... Parcelamento')
@13,01 say 'Vlr Desconto:'     get VM_DESC   pict masc(05) valid VM_DESC>=0  .and. VM_DESC<VM_TOTAL                                                                                                          //when NATOP->NO_CDVLFI#4.and.VM_TPDOC#'AJU' // so especiais
@13,40 say 'Vlr Funrural:'     get VM_FUNRU  pict masc(05) valid VM_FUNRU>=0 .and. VM_FUNRU<VM_TOTAL-VM_DESC                                                                                                 //when NATOP->NO_CDVLFI#4.and.VM_TPDOC#'AJU'.and.PARAMETRO->PA_FUNRUR>0 // so especiais
@14,01 say 'Vlr BaseICMS:'     get VM_ICMSB  pict masc(05) valid VM_ICMSB>=0 .and. VM_ICMSB<=VM_TOTAL-VM_DESC                                                                                                //when if(VM_ICMSB>0,.T.,(VM_ICMSB:=VM_TOTAL-VM_DESC)>=0).and.NATOP->NO_CDVLFI#4.and.VM_TPDOC#'AJU' // so especiais
@14,40 say 'Vlr I.P.I...:'     get VM_IPI    pict masc(05) valid VM_IPI>=0   .and. VM_IPI<=VM_TOTAL-VM_DESC                                                                                                  //when NATOP->NO_CDVLFI#4 .and.VM_TPDOC#'AJU'	// so especiais
@15,01 say '% ICMS......:'     get VM_ICMSP  pict masc(14) valid VM_ICMSP>=0                                                                                                                                 //when NATOP->NO_CDVLFI#4 .and.VM_TPDOC#'AJU'	// so especiais
@15,40 say 'Vlr I.C.M.S.:'     get VM_ICMSV  pict masc(05) valid VM_ICMSV>=0.and.VM_ICMSB<=VM_TOTAL-VM_DESC                                                                                                  //when NATOP->NO_CDVLFI==4.and.VM_TPDOC#'AJU'	// so especiais
@16,01 say 'C¢d.Tribut r:'     get VM_CODTR  pict mI3      valid fn_codigo(@VM_CODTR,{'CODTR',{||CODTR->(dbseek(VM_CODTR))},{||NIL},{2,1,3}})                                                                //when NATOP->NO_CDVLFI#4 .and.VM_TPDOC#'AJU'	// so especiais
@18,01 say 'Vlr OBSERV..:'     get VM_VLROBS pict masc(05) valid VM_VLROBS>=0                                                                                                                                //when VM_TPDOC=='AJU'	// so especiais
@18,50 say 'Contabilizado?'    get VM_FLCTB  pict mUUU     valid VM_FLCTB$'SN'
@19,01 say 'OBS G:'            get VM_PARCE  pict mXXX+'S70'                                                                                                                                                 //when NATOP->NO_CDVLFI==4.or. VM_TPDOC=='AJU'	// so especiais
@20,01 say 'OBS Livro Fiscal:' get VM_OBSLIV pict mUUU
@20,50 say 'Edita Transp ?'    get cEdTrans  pict mUUU 	valid cEdTrans$'SN';
																			when 	pb_msg('Editar Informacoes do Transporador?').and.;
																					if(Left(VM_NFEKEY,3)#'000',.T.,(VM_NFEKEY:=IniNFeKey(VM_CODFO, VM_DTEMI, VM_SERIE, VM_DOCTO, VM_TPDOC))>'')
@21,01 say 'Chave Eletonica.:' get VM_NFEKEY pict '@R 99.9999.99999999999999.99.999.999999999.999999999.9';
																			valid ChkNFeKey(VM_NFEKEY);
																			when pb_msg('Codigo NFE = UF+AAMM+CNPJ/CPF+55+SER+NR.NFE+NR.ESP+DV').and.VM_TPDOC$"NF #CT #"
//....................................................12 3456 78901234567890 12 345 678901234 567890123 4
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	select ENTCAB
	if VM_FL
		LCONT:=AddRec()
		VM_GERAC:='M'
	end
	if LCONT
		if VM_GERAC$' G'
			VM_GERAC:='A'
		end
	end
	if !VM_FL.and.(VM_CODFOA#VM_CODFO.or.;		// TROCOU DE FORNECEDOR
						VM_DOCTOA#VM_DOCTO.or.;		// TROCOU DE NR DOCUMENTO
						VM_SERIEA#VM_SERIE) 			// TROCOU DE SERIE
		select ENTDET
		dbseek(str(VM_DOCTOA,8),.T.)
		while !eof().and.VM_DOCTOA==ENTDET->ED_DOCTO
			pb_msg('Trocou Nr Documento ou Serie ou Cod Fornecedor...')
			if ED_CODFO==VM_CODFOA.and.ENTDET->ED_SERIE==VM_SERIEA
				while !reclock();end
				replace  ENTDET->ED_DOCTO with VM_DOCTO,; 	//	Alterar Documento
							ENTDET->ED_CODFO with VM_CODFO,;		// Alterar Fornecedor
							ENTDET->ED_SERIE with VM_SERIE		// Alterar Serie
			end
			dbskip()
		end
		select ENTCAB
	end
	if !VM_FL.and.recno()#REGANT
		DbGoTo(REGANT)
	end
	
	VM_FLCTB :=(VM_FLCTB=='S')
	if EC_FLCTB.and.!VM_FLCTB
		RemoveCTB('ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE)
	end
	for X:=1 to fcount()
		X1:="VM"+substr(fieldname(X),3)
		replace &(fieldname(X)) with &X1
	next
	if cEdTrans=='S'
		I_TRANS:=CFEPTRANR('E') // ler dados da Entrada
		I_TRANS:=CFEPTRANE(I_TRANS,.T.,'E',.F.)
		CFEPTRANG('E',I_TRANS)
	end
	EditaNFE(VM_CODOP,VM_DOCTO,VM_SERIE,VM_CODFO)
	
end
return NIL

*--------------------------------------------------------------------------
 function EditaNFE(pCFOP,pNrDoc,pSerie,pCodFo)
*--------------------------------------------------------------------------
local Dados:={}
local X:=1
local Y:=0
select ENTDET
dbseek(str(pNrDoc,8),.T.)
while !eof().and.      str(ENTDET->ED_DOCTO,10)==       str(pNrDoc,10)
	if ENTDET->ED_SERIE+str(ENTDET->ED_CODFO,05)==pSerie+str(pCodFo,05)
		aadd(Dados,{	ED_ORDEM,;//......01-Sequencia
							ED_CODPR,;//......02-Cod.Produto
							ED_QTDE,;//.......03-Quantidade
							ED_VALOR,;//......04-Vlr Total
							ED_PCICM,;//......05-%ICMS
							ED_VLICM,;//......06-Vlr ICMS
							ED_PIPI,;//.......07-%IPI
							ED_IPI,;//........08-Vlr IPI
							ED_BICMS,;//......09-BASE.ICMS
							ED_ISENT,;//......10-Vlr.ISENTAS
							ED_OUTRA,;//......11-Vlr.OUTROS
							ED_CODOP,;//......12-Nat.Operacao
							ED_CODTR,;//......13-Cod.Tributario
							ED_CTACTB,;//.....14-Conta Contabil
							recno(),;//.......15-Registro do Banco
							.F.,;//...........16-Status - Alterado ?
							0,;//.............17-Desc Unit
							Round(pb_divzero(ENTCAB->EC_DESC,ENTCAB->EC_TOTAL)*ENTDET->ED_VALOR,2),; // 18-Desconto Geral
		})
	end
	skip
end
if len(Dados)==0
	X:=0
	if pb_sn('NF sem itens para editar;Abrir e Editar Itens?')
		for X:=1 to 199
			aadd(Dados,{X,;//..............01-Sequencia
							0,;//..............02-Cod.Produto
							0,;//..............03-Quantidade
							0,;//..............04-Vlr Total
							0,;//..............05-%ICMS
							0,;//..............06-Vlr ICMS
							0,;//..............07-%IPI
							0,;//..............08-Vlr IPI
							0,;//..............09-BASE.ICMS
							0,;//..............10-Vlr.ISENTAS
							0,;//..............11-Vlr.OUTROS
							pCFOP,;//..........12-Nat.Operacao
							'000',;//..........13-Cod.Tributario
							0,;//..............14-Conta Contabil
							0,;//..............15-Registro do Banco
							.F.,;//............16-Status - Alterado ?
							0,;//..............17-Desconto Unit
							0;//...............18-Desconto Geral
					})
		next
	end
end
aadd(Dados,{200,;//........01-Sequencia
				'Total...',;//.02-Cod.Produto
				0,;//..........03-Quantidade
				0,;//..........04-Vlr Total
				0,;//..........05-%ICMS
				0,;//..........06-Vlr ICMS
				0,;//..........07-%IPI
				0,;//..........08-Vlr IPI
				0,;//..........09-BASE.ICMS
				0,;//..........10-Vlr.ISENTAS
				0,;//..........11-Vlr.OUTROS
				0,;//..........12-Nat.Operacao
				'000',;//......13-Cod.Tributario
				0,;//..........14-Conta Contabil
				0,;//..........15-Registro do Banco
				.F.,;//........16-Status - Alterado ?
				0,;//..........17-Desconto Unit
				0;//...........18-Desconto Geral
   			})
while X>0
	//................................Total
	X                   :=0
	Dados[len(Dados),04]:=0
	aeval(Dados,{|DET|X+=DET[04]})
	Dados[len(Dados),04]:=X
	//.................................vICMS
	X                   :=0
	Dados[len(Dados),06]:=0
	aeval(Dados,{|DET|X+=DET[06]})
	Dados[len(Dados),06]:=X
	//.................................vIPI
	X                   :=0
	Dados[len(Dados),08]:=0
	aeval(Dados,{|DET|X+=DET[08]})
	Dados[len(Dados),08]:=X
	//.................................BaseICMS
	X                   :=0
	Dados[len(Dados),09]:=0
	aeval(Dados,{|DET|X+=DET[09]})
	Dados[len(Dados),09]:=X
	//.................................VIsento
	X                   :=0
	Dados[len(Dados),10]:=0
	aeval(Dados,{|DET|X+=DET[10]})
	Dados[len(Dados),10]:=X
	//.................................VOutros
	X                   :=0
	Dados[len(Dados),11]:=0
	aeval(Dados,{|DET|X+=DET[11]})
	Dados[len(Dados),11]:=X

	X                   :=0
	Dados[len(Dados),18]:=0
	aeval(Dados,{|DET|X+=DET[18]})
	Dados[len(Dados),18]:=X

	
	pb_msg('Selecione o item ou <ESC> para sair')
	X:=abrowse(8,0,22,79,Dados,;
				{'Sq','Produto','Qtdade','VlrTotal','%ICMS','VlrICMS','%IPI','VlrIPI','BaseICMS','VlrIsento','VlrOutro','Nat.Op','CodTr','Ctb','RegBD', 'St','DescItem','DescGer'},;
				{  3 ,     L_P ,     12 ,       12 ,     6 ,      12 ,    6 ,     12 ,       12 ,        12 ,       12 ,      8,       5,    4,      6,    1,        12,       12},;
				{mI3,  masc(21),   mD112,     mD112,   mI62,    mD112,  mI62,   mD112,     mD112,      mD112,     mD112,   mNAT,    mUUU,  mI4,    mI6, mUUU,     mD112,    mD112},,;
				'Itens da NF/'+trim(str(pNrDoc,8))+'/'+pSerie+' Forn:'+trim(str(pCodFo,5)))
				// 1         2         3          4       5        6        7       8          9        10           11      12      13     14       15   16         17        18
	if X>0.and.X<len(Dados)
		PROD1:=Dados[X,02]
		QTD  :=Dados[X,03]
		VLRT :=Dados[X,04]
		PICM :=Dados[X,05]
		VICM :=Dados[X,06]
		PIPI :=Dados[X,07]
		VIPI :=Dados[X,08]
		BICM :=Dados[X,09]
		ISEN :=Dados[X,10]
		OUTR :=Dados[X,11]
		CFOP :=Dados[X,12]
		CODTR:=Dados[X,13]
		Y:=10
		pb_box(Y++,20,,,,"Acerto Seq:"+pb_zer(X,2))
		@Y++,22 say 'Item.........:' get PROD1 pict masc(21) valid fn_codpr(@PROD1,78)
		@Y++,22 say 'Cod.Trib.....:' get CODTR pict mI3      valid fn_codigo(@CODTR,{'CODTR',{||CODTR->(dbseek(CODTR))},{||NIL},{2,1,3}}) when pb_msg('Codigo Tribut rio para este produto')
		@Y++,22 say 'Nat.Operac...:' get CFOP  pict mNAT     valid fn_codigo(@CFOP, {'NATOP',{||NATOP->(dbseek(str(CFOP,7)))},{||CFEPNATT(.T.)},{2,1}})

		@Y++,22 say 'Qtd Total....:' get QTD   pict mD112    valid QTD>=0
		@Y  ,55 say 'Vlr Desc: '+transform(Dados[X,18],mD112)
		@Y++,22 say 'Vlr Total....:' get VLRT  pict mD112    valid VLRT>=0

		@Y  ,22 say '% ICMS.......:' get PICM  pict mD112    valid PICM>=0
		@Y++,55 say '% IPI...:'      get PIPI  pict mD112    valid PIPI>=0

		@Y  ,22 say 'Vlr. ICMS....:' get VICM  pict mD112    valid str(VICM,15,2)<=str(VLRT,15,2)
		@Y++,55 say 'Vlr.IPI.:'      get VIPI  pict mD112    valid str(VIPI,15,2)<=str(VLRT,15,2)

		Y++
		@Y++,22 say 'Base ICMS....:' get BICM  pict mD112    valid str(BICM,15,2)<=str(VLRT,     15,2).and.pb_msg('Vlr Contabil'+Str(VLRT+VIPI-Dados[X,18],15,2)+'  Vlr Bases:'+Str(BICM+OUTR+ISEN,15,2))
		@Y++,22 say 'Outros.......:' get OUTR  pict mD112    valid str(OUTR,15,2)<=str(VLRT+VIPI,15,2).and.pb_msg('Vlr Contabil'+Str(VLRT+VIPI-Dados[X,18],15,2)+'  Vlr Bases:'+Str(BICM+OUTR+ISEN,15,2))
		@Y++,22 say 'Isentos......:' get ISEN  pict mD112    valid ;
												pb_msg('Vlr Contabil'+Str(VLRT+VIPI-Dados[X,18],15,2)+'  Vlr Bases:'+Str(BICM+OUTR+ISEN,15,2)).and.;
												str(ISEN,15,2)<=str(VLRT+VIPI,15,2).and.;
												Str(VLRT+VIPI-Dados[X,18],15,2)==Str(BICM+OUTR+ISEN,15,2)
		read
		if lastkey()#K_ESC
			Dados[X,02]:=PROD1
			Dados[X,03]:=QTD
			Dados[X,04]:=VLRT
			Dados[X,05]:=PICM
			Dados[X,06]:=VICM
			Dados[X,09]:=BICM
			Dados[X,10]:=ISEN
			Dados[X,11]:=OUTR
			Dados[X,13]:=CODTR
			Dados[X,12]:=CFOP
			Dados[X,16]:=.T.
			keyboard replicate(chr(K_DOWN),X++)
		end
	else
		if pb_sn()
			for X:=1 to len(Dados)
				if Dados[X,16] // Registro Alterado
					if Dados[X,15]>0
						DbGoTo(Dados[X,15])
					else
						if AddRec()
							replace ;
										ED_DOCTO with pNrDoc,;
										ED_SERIE with pSerie,;
										ED_CODFO with pCodFo,;
										ED_ORDEM with X
						end
					end
					if reclock()
						replace ;
								  	ED_CODPR with Dados[X,02],;	// Cod.Produto
									ED_QTDE  with Dados[X,03],;	// Quantidade
									ED_VALOR with Dados[X,04],;	// Valor Total
									ED_PCICM with Dados[X,05],;	// 05-%ICMS
									ED_VLICM with Dados[X,06],;	// Vlr Icms
				      			ED_BICMS with Dados[X,09],;	// 13-Base ICMS
									ED_ISENT with Dados[X,10],;	// 14-Valor Isentas
									ED_OUTRA with Dados[X,11],;	// 15-Valor Outras
									ED_CODOP with Dados[X,12],;	// 12-CFOP
									ED_CODTR with Dados[X,13]		// 13-Cod Trib
						if empty(ED_CODCOF)
							PROD->(dbseek(str(ENTDET->ED_CODPR,L_P))) // Pegar CFOP
							replace ENTDET->ED_CODCOF with PROD->PR_CODCOE	// Cod.Produto
						end
					end
				end
			next
		end
		X:=0
	end
end
select('ENTCAB')
return NIL

*-----------------------------------------------------------------------------*
function CFEPEDE3() // Pesquisa 
*-----------------------------------------------------------------------------*
local VM_DOCTO:=EC_DOCTO
local VM_DATA :=EC_DTENT
local OPC:=alert("Pesquisar ?",{"Documento","Entrada-Data"})
pb_box(19,40)
@20,42 say 'Informe Documento:' get VM_DOCTO pict mI8 when OPC==1
@21,42 say 'Informe Data.....:' get VM_DATA  pict mDT when OPC==2
read
if lastkey()#K_ESC
	if OPC==1
		ORDEM DOCSER
		dbseek(str(VM_DOCTO,8),.T.)
	else
		ORDEM DTEDOC
		dbseek(dtos(VM_DATA),.T.)
	end
end
return NIL

*-----------------------------------------------------------------------------*
function CFEPEDE4() // Exclusao
*-----------------------------------------------------------------------------*
if reclock().and.pb_sn('Excluir NF : '+dtoc(EC_DTENT)+' Docto '+pb_zer(EC_DOCTO,8)+' ?')
	if pb_sn('Este documento foi gerado na entrada de produtos. Remover tudos os registros ?')
		select ENTDET
		dbseek(str(ENTCAB->EC_DOCTO,8),.T.)
		while !eof().and.str(ENTCAB->EC_DOCTO,10)==str(ENTDET->ED_DOCTO,10)
			lRT=.T.
			if ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5)==ENTDET->ED_SERIE+str(ENTDET->ED_CODFO,5)
				if reclock()
					fn_elimi()
					lRT:=.F.
				end
			end
			if lRT
				skip
			end
		end
		select ENTCAB
		fn_elimi()
	end
end
dbrunlock()
return NIL

*------Continua em --> CFEPEDED --> CFEPEDE5

function CFEPEDE6() // Imprimir Espelho NF
local VM_DOCTO	:=EC_DOCTO
local VM_SERIE	:=EC_SERIE
local aNFs		:={}
local OPC		:=0
pb_box(18,30,,,,'Informe Nr NF')
@19,32 say 'Nr Fiscal.:' get VM_DOCTO pict mI8  valid VM_DOCTO>0 
@20,32 say 'Serie.....:' get VM_SERIE pict mUUU
read
if lastkey()#K_ESC
	ORDEM DOCSER
	aNFs    :={} // Zerar
	dbseek(str(VM_DOCTO,8)+VM_SERIE,.T.)
	while !eof().and.str(VM_DOCTO,8)+VM_SERIE==str(EC_DOCTO,8)+EC_SERIE
		aadd(aNFs,{;
						pb_zer(	EC_CODFO,5)+chr(45)+left(CLIENTE->CL_RAZAO,20),;	// 1
									DtoC(EC_DTEMI),; 					// 2-Data Emissão
									transform(EC_TOTAL,mD112),;	// 3-Valor
									RecNo()})							// 4-Registro de Entrada
		skip
		
	end
	if len(aNFs)==0
		Alert('Nao Encontrado NF de Entrada informada.')
	elseif len(aNFs)=1 // Só uma NF
		OPC:=1
		@21,32 say 'Fornecedor: '+pb_zer(EC_CODFO,5)+chr(45)+left(CLIENTE->CL_RAZAO,20)
	elseif len(aNFs)>1 // Só Mais que uma NF
		OPC:=Abrowse(08,10,18,58,aNFs,{	'Fornecedor','Data'	,'Valor'},;
												{				26	,	10		,		15	},;
												{			mUUU	, mDT		,	mD112	},,;
													'Lista de NF Entrada')
	end
	if OPC>0
		dbgoto(aNFs[OPC,4]) // Ir para registro de entrada
		ImprimirNFE()
	end
	select('ENTCAB')
	ORDEM DTEDOC // Dt+Docto
end
return NIL

*-------------------------------------------------------------------------------*
	function ImprimirNFE() // Imprimir nota fical entrada espelho 
*-------------------------------------------------------------------------------*
cArqGer	:='C:\TEMP\NF_'+pb_zer(ENTCAB->EC_DOCTO,8)+'.TXT'
if pb_ligaimp(I15CPP,cArqGer)
	aNFEnt	:=RtEntrada() // Busca Entradas -> SPEDC00F.PRG
	NATOP->	(dbseek(str(ENTCAB->EC_CODOP,7)))	// Buscar CFOP
	CLIENTE->(dbseek(str(ENTCAB->EC_CODFO,5)))	// Buscar Fornecedor
	cNomeCli	:=CLIENTE->CL_RAZAO
	
	??padc('NOTA FISCAL - ENTRADA - ESPELHO',132,'-')
	?
	?
	? padc('Dados da Nota Fiscal',132,'-')
	?

	? 'Nr Nota Fiscal...: '	+pb_zer(aNFEnt[04],8)+space(5)
	??'Serie.: '				+aNFEnt[05]+space(10)
	??'Modelo Documento: '	+aNFEnt[06]+space(10)
	??'Tipo NF: '+			if( aNFEnt[02]=='1','Terceiros','Propria')
	
	? 'Natureza Operacao: '	+left(str(aNFEnt[34],7),4)+'-'+upper(NATOP->NO_DESCR)+space(4)
	??				'Data Emissao....: '	+DtoC(	 aNFEnt[08])+space(24)
	? space(53)+'Data Saida......: '	+DtoC(	 aNFEnt[09])
	?
	? padc('Emitente',132,'-')
	?
	? 'Nome/Razao Social: '+CLIENTE->CL_RAZAO+space(3)+' Fone: '+CLIENTE->CL_FONE
	if CLIENTE->CL_TIPOFJ=='J'
		? 'CNPJ.............: '+transform(CLIENTE->CL_CGC,mCGC)+space(30)+' I.E.: '+CLIENTE->CL_INSCR
	else
		? 'CPF..............: '+transform(CLIENTE->CL_CGC,mCPF)+space(34)+' ID..: '+CLIENTE->CL_INSCR
	end
	? 'Endereco.........: '+trim(CLIENTE->CL_ENDER)+','+trim(CLIENTE->CL_ENDNRO)+space(26)
	??' Bairro: '+trim(CLIENTE->CL_BAIRRO)
	? 'CEP/Cidade/UF....: '+CLIENTE->CL_CEP+' - '+CLIENTE->CL_CIDAD+' - '+CLIENTE->CL_UF
	?
	? padc('Destinatario',132,'-')
	?
	? 'Razao Social.....: '+VM_EMPR+space(10)+' Fone: '+PARAMETRO->PA_FONE
	? 'CNPJ.............: '+transform(PARAMETRO->PA_CGC,mCGC)+space(30)+' I.E.: '+PARAMETRO->PA_INSCR
	? 'Endereco.........: '+trim(PARAMETRO->PA_ENDER)+','+trim(PARAMETRO->PA_ENDNRO)+space(26)
	??' Bairro: '+trim(PARAMETRO->PA_BAIRRO)
	? 'CEP/Cidade/UF....: '+PARAMETRO->PA_CEP+' - '+PARAMETRO->PA_CIDAD+' - '+PARAMETRO->PA_UF
	?
	vDesconto:=0 // Soma Valor Desconto
	vTotalNF	:=0 // Soma Valor Total
	vICMSBase:=0 // Soma Base ICMS
	vICMSVlr :=0 // Valor ICMS
	vIPIBase :=0 // Base IPI
	vIPIVlr  :=0 // Vlr IPI
	? padc('Dados do Produto',132,'-')
	?
	?'-Item--*-Descricao-------------------------*-Und-*CST*---Qtdade--*---Vlr Unit--*--Vlr Total--*-%IPI*%ICMS*---Vlr ICMS--*'
	for nX:=1 to len(aNFEnt[42])
		? pb_zer(	 aNFEnt[42,nX,02],L_P)+'-'			// Cod Produto
		??	 left(	 aNFEnt[42,nX,35],35)+'|'			// Desc Produto
		??				 aNFEnt[42,nX,04]+'|'				// Unidade
		??				 aNFEnt[42,nX,08]+'|'				// CST
		?? transform(aNFEnt[42,nX,03],mI113)+'|'		// Quantidade
		?? transform(aNFEnt[42,nX,53],mI135)+'|'		// Vlr Unit
		?? transform(aNFEnt[42,nX,06],mI132)+'|'		// Vlr Total
		?? transform(aNFEnt[42,nX,20],mI52) +'|'		// % IPI
		?? transform(aNFEnt[42,nX,11],mI52) +'|'		// % ICMS
		?? transform(aNFEnt[42,nX,12],mI132)+'|'		// Vlr ICMS
		
		vDesconto+=aNFEnt[42,nX,05] // Soma Valor Desconto
		vTotalNF	+=aNFEnt[42,nX,06] // Soma Valor Total
		vICMSBase+=aNFEnt[42,nX,10] // Soma Base ICMS
		vICMSVlr +=aNFEnt[42,nX,12] // Valor ICMS
		vIPIBase +=pb_divzero(aNFEnt[42,nX,21],aNFEnt[42,nX,20]/100) // Base IPI
		vIPIVlr  +=aNFEnt[42,nX,21] // Valor IPI
		
	next nX
	?
	? padc('Calculo dos Impostos',132,'-')
	?
	? 'B.Calc.ICMS:'		+transform(vICMSBase	,mI132)+space(2)
	??'Vlr ICMS..:'		+transform(vICMSVlr	,mI102)+space(2)
	??'B.Calc.ICMS-ST:'	+transform(0			,mI102)+space(2)
	??'Vlr ICMS-ST:'		+transform(0			,mI102)+space(2)
	??'Tot Produtos:'		+transform(vTotalNF	,mI132)

	? 'Valor Frete:'		+transform(aNFEnt[16],mI132)+space(2)
	??'Vlr Seguro:'		+transform(aNFEnt[17],mI102)+space(2)
	??'Desp.Assessoc.:'	+transform(aNFEnt[18],mI102)+space(2)
	??'Vlr IPI..:  '		+transform(vIPIBase	,mI102)+space(2)
	??'Tot Mercador:'		+transform(vTotalNF-vDesconto	,mI132)
	?
	? padc('Transportador',132,'-')
	?
	? 'Transportador : '+aNFEnt[40,02]			+space(2)
	??'CNPJ.....: '+		aNFEnt[40,09]			+space(2)
	??'E.I.: '+				aNFEnt[40,10]
	? 'Endereco......: '+aNFEnt[40,03]+space(2)+'Municipio: '+aNFEnt[40,04]+'  UF: '+aNFEnt[40,05]
	? 'Tipo Frete....: '+str(aNFEnt[40,06],1)+'-'+if(aNFEnt[40,06]>1,'Destinatario','Emitente    ')+space(23)
	??'Placa Veiculo.: '+    aNFEnt[40,20]   +space(7)+'UF Veiculo: '	+aNFEnt[40,21]
	? 'Qtde Embalagem: '+str(aNFEnt[40,15],4)+space(6)+'Especie: '		+aNFEnt[40,16]+space(2)
	??'Peso Bruto: '+		str(aNFEnt[40,17],6)+space(6)
	??'Peso Liquido: '+str(aNFEnt[40,18],6)
	?
	? padc('Dados Adicionais',132,'-')
	?
	? 'Observacao : '+aNFEnt[33]
	?
	? padc('-',132,'-')
	
	pb_deslimp(C15CPP,,.F.) // Não mostrar arquivo no final
	Alert('Gerado Arquivo '+cArqGer)
	if pb_sn('Gerar PDF ou Impressora ?')
		LinhaComando:='DOSPRINT.EXE /SEL '+cArqGer
		Run(LinhaComando)
	end
end
return NIL

*-----------------------------------------------------------------------------*
static function AjustSerie() // Ajusta série do detalhe conforme cabeçalho
*-----------------------------------------------------------------------------*
nX:=0
if pb_sn('Ajustar Serie dos registros Detalhes;conforme registro Cabecalho?')
	select ENTCAB
	go top
	while !eof()
		pb_msg('Ajustando Serie Reg. Detalhes '+dtoc(ENTCAB->EC_DTENT)+' Docto '+pb_zer(ENTCAB->EC_DOCTO,8)+' Alterados:'+str(nX,5))
		select ENTDET
		dbseek(str(ENTCAB->EC_DOCTO,8),.T.)
		aReg:={}
		while !eof().and.str(ENTCAB->EC_DOCTO,10)==str(ENTDET->ED_DOCTO,10)
			if str(ENTDET->ED_CODFO,5)==str(ENTCAB->EC_CODFO,5)
				if  ENTDET->ED_SERIE   <>    ENTCAB->EC_SERIE
					aadd(aReg,RecNo())
					nX++
				end
			end
			skip
		end
		for nY:=1 to len(aReg)
			DbGoTo(aReg[nY]) // acessar registro diferente ou último registro
			if RecLock()
				alert('Erro Serie:'+ ENTCAB->EC_SERIE+   '<>'+       ENTDET->ED_SERIE+;
						';Doc:'+pb_zer(ENTCAB->EC_DOCTO,8)+'=='+pb_zer(ENTDET->ED_DOCTO,8)+;
						';For:'+pb_zer(ENTCAB->EC_CODFO,8)+'=='+pb_zer(ENTDET->ED_CODFO,8)+;
						';Ordem:'+ str(ENTDET->ED_ORDEM,3))
				replace ENTDET->ED_SERIE with ENTCAB->EC_SERIE
			end
		end
		DbrUnlock()
		select ENTCAB
		skip
	end
	dbrunlock()
	go top
	alert('Ajuste das Series concluido;Alterados '+str(nX,5)+' registros.')
	pb_msg('')
end
return NIL
*--------------------------------------------------EOF---------------------------------*
