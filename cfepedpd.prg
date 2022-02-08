#include 'RCB.CH'
*-----------------------------------------------------------------------------*
 static aVariav := {.T.,0,0,'',.F.,0,''}
 //..................1..2.3..4..5..6..7
*-----------------------------------------------------------------------------*
#xtranslate lRT      	=> aVariav\[  1 \]
#xtranslate nRegFrete 	=> aVariav\[  2 \]
#xtranslate nX 			=> aVariav\[  3 \]
#xtranslate cEdTrans 	=> aVariav\[  4 \]
#xtranslate lEdItens		=> aVariav\[  5 \]
#xtranslate nTotProd		=> aVariav\[  6 \]
#xtranslate VM_FLCTBD	=> aVariav\[  7 \]

*-------------------------------------------------------------------------------*
  function CFEPEDPCT(VM_FL)
*-------------------------------------------------------------------------------*
local LCONT			:=.T.
local REGANT		:=RecNo()
local lChMontada  :=.F.
private I_TRANS   := {}

cEdTrans				:='N'
nX:=0
for nX:=1 to fcount()
	X1:="VM"+substr(fieldname(nX),3)
	&X1:=&(fieldname(nX))
next
pModXNF  :='01'
cModDNF  :=RtModelo('S',PEDCAB->PC_SERIE,@pModXNF) // Tabela D e pMod=Modelo tabela interna
VM_FLCAND:=if(VM_FLCAN,'S','N')
VM_FLCTBD:=if(VM_FLCTB,'S','N')

if empty(PEDCAB->PC_NFEKEY)
	if pModXNF=='55' // é nota fiscal NF-e
		cNFEKey:='42'
		cNFEKey+=pb_zer(year(PEDCAB->PC_DTEMI)-2000,2)+;
					pb_zer(month(PEDCAB->PC_DTEMI)    ,2)//........................AAMM
		cNFEKey+=pb_zer(val(SONUMEROS(PARAMETRO->PA_CGC)),14)//.................CNPJ
		cNFEKey+=PARAMETRO->PA_MODNFE//.........................................Modelo NFE=55
		cNFEKey+='001'//........................................................Serie
		cNFEKey+=              pb_zer(PEDCAB->PC_NRNF ,9)//.....................Nr Documento
		cNFEKey+=              pb_zer(PEDCAB->PC_PEDID,8)//.....................Controle parte 1
		cNFEKey+=str(pb_chkdgt(pb_zer(PEDCAB->PC_PEDID,8),3),1)//...............Controle parte 2
		cNFEKey+=CalcDg(cNFEKey)//..............................................Novo Digito Verificador
		VM_NFEKEY :=cNFEKey
		lChMontada:=.T.
	end
end

pb_box()
VM_DTEMI:=if(empty(VM_DTEMI),PARAMETRO->PA_DATA,VM_DTEMI)
nTotProd:=VM_TOTAL+VM_DESC+VM_DESCIT
@06,01 say 'Pedido......:'		get VM_PEDID  pict mI6      // valid pb_ifcod2(str(VM_PEDID,6),NIL,.F.,1) when VM_FL
@06,32 say 'Dt Emiss„o:' 		get VM_DTEMI  pict masc(08) when VM_FL
@08,01 say 'Tipo Docto..:' 	get VM_TPDOC  pict masc(01) valid fn_codar (@VM_TPDOC,'TP_DOCTO.ARR')
@07,01 say 'NR.NF.......:' 	get VM_NRNF   pict masc(19)	color 'W/G'																																							when VM_FL.and.VM_TPDOC#'AJU'
@07,36 say 'Serie.:'       	get VM_SERIE  pict mUUU			valid VM_SERIE==SCOLD.or.fn_codigo(@VM_SERIE,{'CTRNF',{||CTRNF->(dbseek(VM_SERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}})				when VM_TPDOC#'AJU'
@09,01 say 'Cliente.....:' 	get VM_CODCL  pict masc(04) valid fn_codigo(@VM_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})							when VM_TPDOC#'AJU'
@10,01 say 'Banco.......:'		get VM_CODBC  pict masc(11) 																																										when VM_TPDOC#'AJU'
@10,30 say 'Nat.Operacao:'		get VM_CODOP  pict mNAT     valid fn_codigo(@VM_CODOP,{'NATOP',{||NATOP->(dbseek(str(VM_CODOP,7)))},{||CFEPNATT(.T.)},{2,1}}).and.NATOP->NO_TIPO$'SO'		when VM_TPDOC#'AJU'
@11,36 say 'Lote..:'				get VM_LOTE   pict mI4      																																										when NATOP->NO_FLTRAN=='S'
@11,50 SAY 'TP.Transf:'			get VM_TPTRAN pict mI1      																																										when NATOP->NO_FLTRAN=='S'

@12,01 say 'Chave NFE...:'		get VM_NFEKEY pict mUUU			color if(lChMontada,'B/W','W/G')      when .F.
@12,60 say 'Parcelas:'+str(VM_FATUR,3)							color 'W/G'

@13,01 say 'Total Produt: '	get nTotProd	pict masc(05)  color 'W/G'										when .F.
@14,01 say 'VlDescGeral:  '	get VM_DESC		pict masc(05)	valid VM_DESC  >=0							when NATOP->NO_CDVLFI#4.and.VM_TPDOC#'AJU' // so especiais
@15,01 say 'VlDescItem.:  '	get VM_DESCIT	pict masc(05)	valid VM_DESCIT>=0							when NATOP->NO_CDVLFI#4.and.VM_TPDOC#'AJU' // so especiais
@16,01 say 'VlEntrada..:  '	get VM_VLRENT	pict masc(05)	valid VM_VLRENT>=0							when NATOP->NO_CDVLFI#4.and.VM_TPDOC#'AJU' // so especiais
@17,01 say 'Total NF....: '	get VM_TOTAL	pict masc(05)	valid VM_TOTAL  >0							when NATOP->NO_CDVLFI#4.and.VM_TPDOC#'AJU' // so especiais
@18,01 say 'NF.Cancelada?' 	get VM_FLCAND	pict mUUU		valid VM_FLCAND$'SN' 						when pb_msg('Nota Fiscal Cancelada? <S>SIM ou <N>NAO.')

pb_box(13,30,18,78,,'FRETE/TIPO = CT e NAT OPER #4')
@14,32 say '% Icms......:' 	get VM_PICMS  pict masc(14) valid VM_PICMS >=0.and.VM_PICMS<=25   when VM_TPDOC=="CT ".and.VM_TPDOC#'AJU'
@15,32 say 'Base Icms...:' 	get VM_BICMS  pict masc(25)                                       when VM_TPDOC=="CT ".and.VM_TPDOC#'AJU'
@16,32 say 'Valor Icms..:' 	get VM_VICMS  pict masc(25)                                       when VM_TPDOC=="CT ".or.NATOP->NO_CDVLFI==4.or.VM_TPDOC#'AJU' // so especiais
@17,32 say 'Edita Transp?' 	get cEdTrans  pict mUUU			valid cEdTrans$'SN' 						when pb_msg('Editar Informacoes do Transporador?')
@19,01 say 'Dt Cancelam.:'		get VM_DTCAN 	pict mDT			valid VM_DTCAN>=VM_DTEMI					when VM_FLCAND=="S"
@19,36 say 'Contabilizado:'	get VM_FLCTBD 	pict mUUU		valid VM_FLCTBD$'SN'

@20,01 say 'Valor OBS...:' 	get VM_VLROBS pict masc(25)
@21,01 say 'OBS.:'         	get VM_OBSER  pict mXXX+'S70'
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if !VM_FL.and.VerSerie(VM_SERIE,VM_NRNF)=='08'			//Alterar + Nota de Frete ?
		VM_NRNFT  :=Val(  Substr(	VM_CFRETE, 6, 6))			// Nr nf acoberta frete
		VM_SERIET :=Substr(			VM_CFRETE,12, 3)			// Serie nf acoberta frete
		VM_CODCLT :=Val   (Substr(	VM_CFRETE, 1, 5))			// Cliente NF acoberta frete
		VM_VLRTOTT:=Val   (Substr(	VM_CFRETE,15,14))/100	// Valor NF acoberta frete
		pb_box(17,0,,,,'INFORME NF QUE ACOBERTA O FRETE')
		@18,01 say 'NR NF Origem do Frete:' get VM_NRNFT  pict mI6  valid VM_NRNFT>0
		@18,50 say 'Serie NF:'              get VM_SERIET pict mUUU valid fn_NfFrete(VM_NRNFT,VM_SERIET,@VM_CODCLT,@VM_VLRTOTT)
		read
		if lastkey()#K_ESC
			@20,01 say 'Cliente da NF........: '+str(VM_CODCLT,5)+'-'+trim(CLIENTE->CL_RAZAO)
			@21,01 say 'Valor da NF Origem...: '+transform(VM_VLRTOTT,mD132)
			if pb_sn('Confirma NF que acoberta este Frete?')
				VM_CFRETE:=str(VM_CODCLT,5)+str(VM_NRNFT,6)+VM_SERIET+str(VM_VLRTOTT*100,14)
			else
				alert('SINTEGRA;Nota fiscal que acoberta este frete nao foi alterada;REVISE A SERIE')
				dbunlockall()
				return NIL
			end
		else
			alert('SINTEGRA;Nota fiscal que acoberta este frete nao foi alterada;REVISE A SERIE')
			dbunlockall()
			return NIL
		end
	end
	if VM_FL
		LCONT   :=AddRec()
		VM_FLAG :=.T.
		VM_FLCAN:=.F.
	elseif VM_TPDOC=='NF '
		if NATOP->NO_TIPO$'SO'
			DbGoTo(REGANT)
			//...............1........2........3.......4..............5
			cfepedpcd(PC_PEDID,VM_PEDID,VM_TOTAL,VM_DESC,NATOP->NO_TIPO) // alterar detalhe
		end
	end
	if LCONT
		if !VM_FL
			DbGoTo(REGANT)
			VM_GERAC:='M'//...Incluido manualmente
		else
			if VM_GERAC$' G'
				VM_GERAC:='A' // alterado um documento gerado de forma manual - manualmente
			end
		end
		VM_FLCAN:=VM_FLCAND=='S'
		if !VM_FLCAN
			VM_DTCAN:=ctod('')
		end
		VM_FLCTB:=if(VM_FLCTBD=='S',.T.,.F.)
		for X:=1 to fcount()
			X1:="VM"+substr(fieldname(X),3)
			replace &(fieldname(X)) with &X1
		next
		if cEdTrans=='S'
			I_TRANS:=CFEPTRANR('S')
			I_TRANS:=CFEPTRANE(I_TRANS,.T.,'S',.F.)
			CFEPTRANG('S',I_TRANS)
		end
	end
	dbunlockall()
end
select('PEDCAB')
return NIL

*-------------------------------------------------------------------------------
 static function CFEPEDPCD(P1,P2,P3,P4,P5) // Edita detalhes
*-------------------------------------------------------------------------------
local DADOS:={}
local Z    :=1
local FLAG :=.T.
local TOTAL
local SOMA
local cTela:=SaveScreen()
setcolor('W+/B,N/W,,,W+/B')
salvabd(SALVA)
select('PEDDET')
dbseek(str(P2,6),.T.)
while !eof().and.P2==PD_PEDID
	PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
	if RecLock()
		aadd(DADOS,{PD_CODPR,;			//-01
						PROD->PR_DESCR,;	//-02
						PD_QTDE,;			//-03
						PD_VALOR,;			//-04
						PD_CODTR,;			//-05
						PD_ICMSP,;			//-06
						PD_PTRIB,;			//-07
						PD_VLICM,;			//-08
						RecNo(),;			//-09
						PD_DESCV,;			//-10-Desconto Item
						PD_BAICM,;			//-11-Base ICMS
						PD_VLROU,;			//-12-Outras
						PD_VLRIS,;			//-13-Isentas
						PD_CODOP,;			//-14-CFOP
						PD_DESCG,;			//-15-Desconto Geral
						PD_CODCOF;			//-16-Cod Pis/Cofins
						})
	else
		FLAG:=.F.
	end
	dbskip()
end
for Z:=len(DADOS)+1 to 30
	aadd(DADOS,{0,;			//-01
					space(30),;	//-02
					0.00,;		//-03
					0.00,;		//-04
					'000',;		//-05
					0.00,;		//-06
					100,;			//-07
					0.00,;		//-08
					0,;			//-09
					0,;			//-10
					0,;			//-11
					0,;			//-12
					0,;			//-13
					0,;			//-14
					0,;			//-15
					'   ';		//-16
					})
next
lEdItens:=.F.
DADOS[30][02]:='Somatorio'
while Z > 0
	DADOS[30][10]:=0.00
	DADOS[30][15]:=0.00
	TOTAL:=0.00
	aeval(DADOS,{|DET|TOTAL+=Trunca((DET[3]*DET[4])-DET[15],2)}) // soma valores mas truca 2 casa decimal

	SOMA:=0.00
	aeval(DADOS,{|DET|SOMA+=DET[08]}) // soma Vlr ICMS
	DADOS[30][08]:=SOMA
	SOMA:=0.00
	aeval(DADOS,{|DET|SOMA+=DET[10]}) // soma Desconto Individual
	DADOS[30][10]:=SOMA
	SOMA:=0.00
	aeval(DADOS,{|DET|SOMA+=DET[15]}) // Soma Desconto Proporcional Geral
	DADOS[30][15]:=SOMA
	
	pb_msg('Zero no Cod.Produto -> Excluir. ESC Sai. Total dos itens R$'+transform(TOTAL,mD112))
	Z:=Abrowse(10,0,22,79,;
					DADOS,;
					{ 'Prod.','Descricao','Qtdade','VlrUnVenda', 'CT',  '%ICMS','%Trib','VlrIcms','Reg','DescI','B.ICMS','B.OUTRAS','B.ISENTA','CFOP','V.DescGeral','Pis/Cof'},;
					{     L_P,     21-L_P,      11,          10,    3,        5,      6,      12,    6 ,  12,      12   ,    12,           12,    10,        12,        7},;
					{masc(21),       mXXX,masc(42),        mD83, mUUU, masc(14),masc(1), masc(25),  mI6, mD83, masc(25) , masc(25),  masc(25)  ,mNAT,   masc(25),     mUUU})
					//.....1...........2........3.............4......5........6........7.........8...9....10......11.......12............13.......14.......15...........16
	if Z>0.and.Z<29
		VM_CODPR:=DADOS[Z,01] //7+15=6
		VM_QTDDE:=DADOS[Z,03]
		VM_VALOR:=DADOS[Z,04]
		VM_CODTR:=DADOS[Z,05]
		VM_PICMS:=DADOS[Z,06]
		VM_PTRIB:=DADOS[Z,07]
		VM_VICMS:=DADOS[Z,08]
		vDescI  :=DADOS[Z,10]
		BICMS   :=DADOS[Z,11]
		BOUTR   :=DADOS[Z,12]
		BISEN   :=DADOS[Z,13]
		CFOP    :=DADOS[Z,14]
		vDescG  :=DADOS[Z,15]
		PISCOF  :=DADOS[Z,16]
		VlrContabil:=0
		salvacor(SALVA)

		pb_box(12,20,,,'W+/GR,B/W+*,,,W/GR','Aterar Item '+str(Z,2))
		@13,22 say 'Item.......'  get VM_CODPR pict masc(21) valid VM_CODPR==0.or.fn_codpr(@VM_CODPR,77).and.(VM_CODTR:=PROD->PR_CODTR)>=''
		@14,22 say 'Quantidade.'  get VM_QTDDE pict masc(42) valid VM_QTDDE>=0 																																			when VM_CODPR#0
		@14,52 say 'Vlr Unitar.'  get VM_VALOR pict mI144    valid VM_VALOR>=0                                   																							when VM_CODPR#0
		@15,22 say 'Nat.Operac.:' get CFOP     pict mNAT     valid fn_codigo(@CFOP,    {'NATOP',{||NATOP->(dbseek(str(CFOP,7)))},{||CFEPNATT(.T.)},{2,1}}).and.NATOP->NO_TIPO$'OS' 			when VM_CODPR#0
		@16,22 say 'CodTribut..:' get VM_CODTR pict mI3      valid fn_codigo(@VM_CODTR,{'CODTR',{||CODTR->(dbseek(VM_CODTR))},{||NIL},{2,1,3}}) 													when VM_CODPR#0
		@17,22 say '% Tributado:' get VM_PTRIB pict mI62     valid VM_PTRIB>=0.AND.VM_PTRIB<=100 																													when VM_CODPR#0
		@18,22 say '%ICMS......'  get VM_PICMS pict masc(05) valid VM_PICMS>=0.and.VM_PICMS<=30                   when VM_CODPR#0.and.(VlrContabil:=Trunca(VM_QTDDE*VM_VALOR,2))>=0.and.pb_msg('Valor Contabil='+transform(VlrContabil,mD132)+' Bases='+transform((BICMS+BOUTR+BISEN),mD132))
		@19,22 say 'VlrICMS....'  get VM_VICMS pict masc(05) valid VM_VICMS>=0                                    																							when VM_CODPR#0
		@20,22 say 'VlrDesc.Ind'  get vDescI   pict masc(05) valid vDescI>=0.and.vDescI<Trunca(VM_QTDDE*VM_VALOR,2).and.((VlrContabil:=Trunca(VM_QTDDE*VM_VALOR-vDescI       ,2))>=0) when VM_CODPR#0.and.pb_msg('Valor Contabil='+transform(VlrContabil,mD132)+' Bases='+transform((BICMS+BOUTR+BISEN),mD132))
		@21,22 say 'VlrDesc.Ger'  get vDescG   pict masc(05) valid vDescG>=0.and.vDescG<Trunca(VM_QTDDE*VM_VALOR,2).and.((VlrContabil:=Trunca(VM_QTDDE*VM_VALOR-vDescI-vDescG,2))>=0) when VM_CODPR#0.and.pb_msg('Valor Contabil='+transform(VlrContabil,mD132)+' Bases='+transform((BICMS+BOUTR+BISEN),mD132))
		@17,52 say 'Pis/Cofins:'  get PISCOF   pict mUUU     valid ChkPisCofins(@PISCOF) 																															when VM_CODPR#0
		pb_box(18,50,22,78,'W+/GR,B/W+*,,,W/GR','Bases ICMS')
		@19,52 say 'Vlr Tribut.'  get BICMS    pict masc(05) valid BICMS>=0.and.VlrContabil>=(BICMS)              when VM_CODPR#0.and.pb_msg('Valor Contabil='+transform(VlrContabil,mD132)+' Bases='+transform((BICMS+BOUTR+BISEN),mD132))
		@20,52 say 'Vlr Outros.'  get BOUTR    pict masc(05) valid BOUTR>=0.and.VlrContabil>=(BICMS+BOUTR)        when VM_CODPR#0.and.pb_msg('Valor Contabil='+transform(VlrContabil,mD132)+' Bases='+transform((BICMS+BOUTR+BISEN),mD132))
		@21,52 say 'Vlr Isento.'  get BISEN    pict masc(05) ;
				valid BISEN>=0   .and.pb_msg('Valor Contabil='+transform(VlrContabil,mD132)+' Bases='+transform((BICMS+BOUTR+BISEN),mD132)).and.str(VlrContabil,15,2)==str(BICMS+BOUTR+BISEN,15,2) ;
				when  VM_CODPR#0 .and.pb_msg('Valor Contabil='+transform(VlrContabil,mD132)+' Bases='+transform((BICMS+BOUTR+BISEN),mD132))
		read
		salvacor(RESTAURA)
		if lastkey()#K_ESC
			if VM_CODPR#0
				DADOS[Z,01]:=VM_CODPR
				DADOS[Z,02]:=PROD->PR_DESCR
				DADOS[Z,03]:=VM_QTDDE
				DADOS[Z,04]:=VM_VALOR
				DADOS[Z,05]:=VM_CODTR
				DADOS[Z,06]:=VM_PICMS
				DADOS[Z,07]:=VM_PTRIB
				DADOS[Z,08]:=VM_VICMS
				DADOS[Z,10]:=vDescI
				DADOS[Z,11]:=BICMS
				DADOS[Z,12]:=BOUTR
				DADOS[Z,13]:=BISEN
				DADOS[Z,14]:=CFOP
				DADOS[Z,15]:=vDescG
				DADOS[Z,16]:=PISCOF
				lEdItens   :=.T.

				keyboard replicate(chr(K_DOWN),Z++)
			elseif pb_sn('Voce esta zerando os dados deste PRODUTO nesta NF; Tem certeza?')
				DADOS[Z,01]:=0
				DADOS[Z,02]:=' '
				DADOS[Z,03]:=0
				DADOS[Z,04]:=0
				DADOS[Z,05]:='000'
				DADOS[Z,06]:=0
				DADOS[Z,07]:=100
				DADOS[Z,08]:=0
				DADOS[Z,10]:=0
				DADOS[Z,11]:=0
				DADOS[Z,12]:=0
				DADOS[Z,13]:=0
				DADOS[Z,14]:=0
				DADOS[Z,15]:=0
				DADOS[Z,16]:='  '
				lEdItens   :=.T.
			end
		end
	else
		if str(TOTAL,15,2)==str(P3,15,2)
			if lEdItens.and.pb_sn('Gravar dados dos itens?')
				for Z:=1 to len(DADOS)
					if DADOS[Z,09]>0 // já tem registro gravado
						DbGoTo(DADOS[Z,09])
						if reclock()
							if DADOS[Z,01]#0
								replace 	PD_PEDID  with P2,;
											PD_ORDEM  with Z,;
											PD_CODPR  with DADOS[Z,01],;
											PD_QTDE   with DADOS[Z,03],;
											PD_VALOR  with DADOS[Z,04],;
											PD_VLRMD  with 0,;
											PD_DESCV  with DADOS[Z,10],;
											PD_DESCG  with DADOS[Z,15],;
											PD_CODTR  with DADOS[Z,05],;
											PD_ICMSP  with DADOS[Z,06],;
											PD_BAICM  with DADOS[Z,11],; // Base Icms
											PD_PTRIB  with DADOS[Z,07],;
											PD_VLICM  with DADOS[Z,08],;
											PD_VLROU  with DADOS[Z,12],;
											PD_VLRIS  with DADOS[Z,13],;
											PD_CODOP  with DADOS[Z,14],;
											PD_CODCOF with DADOS[Z,16]
								if PD_BAICM>DADOS[Z,3]*DADOS[Z,4]
									replace PD_BAICM with trunca(DADOS[Z,3]*DADOS[Z,4],2) // truncar base depois da 3 casa
								end
							else
								dbdelete()
							end
						end
					else //...................Sem registro de itens
						if DADOS[Z,1]#0 //.....Produto digitado
							if AddRec()
								replace 	PD_PEDID  with P2,;
											PD_ORDEM  with Z,;
											PD_CODPR  with DADOS[Z,01],;
											PD_QTDE   with DADOS[Z,03],;
											PD_VALOR  with DADOS[Z,04],;
											PD_VLRMD  with 0,;
											PD_DESCV  with DADOS[Z,10],;
											PD_DESCG  with DADOS[Z,15],;
											PD_ENCFI  with 0,;
											PD_CODTR  with DADOS[Z,05],;
											PD_ICMSP  with DADOS[Z,06],;
											PD_VLICM  with DADOS[Z,08],;
											PD_BAICM  with DADOS[Z,11],;
											PD_PTRIB  with DADOS[Z,07],;
											PD_VLROU  with DADOS[Z,12],;
											PD_VLRIS  with DADOS[Z,13],;
											PD_CODOP  with DADOS[Z,14],;
											PD_CODCOF with DADOS[Z,16]
								if PD_BAICM>DADOS[Z,3]*DADOS[Z,4]
									replace PD_BAICM with trunca(DADOS[Z,3]*DADOS[Z,4],2) // trucar numeros depois da 3a casa
								end
							end
						end
					end
				next
				Z:=0
			else
				pb_msg('Nenhum dado de item foi gravado....',1)
				Z:=0
			end
		else
			Z:=10
			if pb_sn('Total NF -NAO FECHADO.;Total NF:'+str(P3,15,2)+';Total soma'+str(TOTAL,15,2)+';CANCELAR?')
				Z:=0
			end
		end
	end
end
DbRUnLock()
salvabd(RESTAURA)
RestScreen(,,,,cTela)
return NIL

*-------------------------------------------------------------------------------
 static function fn_NfFrete(pNrNF,pSerie,pCli,pVlr) // 
*-------------------------------------------------------------------------------
lRT      :=.F.
nRegFrete:=recno()
ORDEM NNFSER
go top
if dbseek(str(pNrNF,6)+pSerie)
	lRT :=.T.
	pCli:=PEDCAB->PC_CODCL
	pVlr:=PEDCAB->PC_TOTAL
	CLIENTE->(dbseek(str(pCli,5)))
else
	pb_msg('SINTEGRA = Nota Fiscal :'+str(pNrNF,6)+' Serie :'+pSerie+';Nao encontrada - VERIFIQUE')
end
ORDEM DTENNF
DbGoTo(nRegFrete)
return lRT
*---------------------------------------------EOF-----------------------------------
