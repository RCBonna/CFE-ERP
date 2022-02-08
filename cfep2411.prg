*-----------------------------------------------------------------------------*
 static aVariav := {0}
*...................1..2..3.4..5..6..7,8...9...10
*---------------------------------------------------------------------------------------*
#xtranslate nX       => aVariav\[  1 \]

*-----------------------------------------------------------------------------*
function CFEP2411(VM_P1)	// Consulta Historico Cliente/Fornecedores			*
*									// 1=FORNECEDOR												*
*									// 2=CLIENTES													*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({	'R->PARAMETRO',;
				'R->CTRNF'})
	return NIL
end
VM_REL:='Consulta Hist¢rico de '
if VM_P1==1
	if !abre({	'R->CLIENTE',;
					'C->HISFOR'})
		dbcloseall()
		return NIL
	end
	set relation to str(HF_CODFO,5) into CLIENTE
	VM_REL+='FORNECEDOR'
else
	if !abre({	'R->CLIENTE',;
					'C->HISCLI'})
		dbcloseall()
		return NIL
	end
	set relation to str(HC_CODCL,5) into CLIENTE
	VM_REL+='CLIENTE   '
end
DbGoTop()
pb_tela()
pb_lin4(VM_REL,ProcName())

pb_dbedit1('CFEP2410','PesquiExcluiAlteraInclui')
VM_CAMPO:=array(13)
afields(VM_CAMPO)
ains(VM_CAMPO,2)
VM_CAMPO[2]:= 'fn_hist('+str(VM_P1,1)+')'

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
			{   mI5 ,  mUUU,       mDPL,         mDT,      mDT,      mDT,   masc(2),masc(2),masc(2),masc(19),masc(1)},;
			{'C¢dig','Nome','Duplicata','Dt Emiss„o','Dt.Vcto','Dt.Pgto','Vlr.Dupl','Vlr.Pago','Vlr Juros','Descontos','Vlr.'+trim(PARAMETRO->PA_MOEDA),'Nr NF','Serie'})

set relation to
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function CFEP24101() && Rotina de Pesquisa
*-----------------------------------------------------------------------------*
VM_CHAVE:=&(fieldname(1))
pb_box(20,26,,,,'Pesquisar Cod.Cliente')
@21,30 get VM_CHAVE picture masc(4)
read
setcolor(VM_CORPAD)
dbseek(str(VM_CHAVE,5),.T.)
return NIL

*-----------------------------------------------------------------------------*
function CFEP24102() && Rotina de Exclusao
*-----------------------------------------------------------------------------*
local ORD:=alert('Selecione tipo Exclus„o :',{'S¢ uma Duplicata','Todas do '+right(VM_REL,10)})
if ORD=1
	if reclock().and.pb_sn('Excluir duplicata '+transform(&(fieldname(2)),masc(16)))
		fn_elimi()
	end
	dbrunlock()
elseif ORD=2
	VM_X:=if(alias()='HISCLI',2,1)
	if pb_sn('Excluir todas duplicata de '+fn_hist(VM_X)+' ?')
		VM_OPC=str(fieldget(1),5)
		while !eof().and.VM_OPC==str(fieldget(1),5)
			if reclock()
				fn_elimi()
			end
			dbrunlock()
		end
	end
end
return NIL

*-----------------------------------------------------------------------------*
function CFEP24103() && Rotina de Alteracao
*-----------------------------------------------------------------------------*
if reclock()
	VM_CHAVE:=&(fieldname(02))
	VM_DTEMI:=&(fieldname(03))
	VM_NRNF :=&(fieldname(11))
	VM_SERIE:=&(fieldname(12))
	pb_box(17,46,,,,'Alterar DPLS')
	@18,47 say 'N§Duplicata..:'  get VM_CHAVE picture masc(16)
	@19,47 say 'Data Emiss„o.: ' get VM_DTEMI picture masc(07)
	@20,47 say 'N§ Nota Fisc.:'  get VM_NRNF  picture mI9
	@21,47 say 'Serie NF.....:'  get VM_SERIE picture masc(01) valid VM_SERIE==SCOLD.or.fn_codigo(@VM_SERIE,{'CTRNF',{||CTRNF->(dbseek(VM_SERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}})
	read
	if pb_sn()
		replace  &(fieldname( 2)) with VM_CHAVE,;
					&(fieldname( 3)) with VM_DTEMI,;
					&(fieldname(11)) with VM_NRNF,;
					&(fieldname(12)) with VM_SERIE
	end
	setcolor(VM_CORPAD)
	dbrunlock()
end
return NIL

*-----------------------------------------------------------------------------*
	function CFEP24104() && Rotina de Inclusao
*-----------------------------------------------------------------------------*
alert('Inclusao deve ser feita somente;com absoluta certeza dos dados;NAO SERA VALIDADO OS DADOS')

private VM_CAMPO:=array(fCount())
private VM_CABE :=array(fCount())

afields(VM_CAMPO)
afields(VM_CABE)

setcolor(VM_CORPAD)
nX:=9
pb_box(nX++,25,,,,'Incluir Pgtos DPLS')
for nX :=1 to fCount()
	X1 :="VM"+substr(fieldname(nX),3)
	&X1:=&(fieldname(nX))
next
nX:=10

/* 				{{'HC_CODCL' ,'N',  5,  0},;	//  1 Cod.Cliente
				 {'HC_DUPLI' ,'N',  9,  0},;	//  2 Duplicata
				 {'HC_DTEMI' ,'D',  8,  0},;	//  3 Dt.Emissao
				 {'HC_DTVEN' ,'D',  8,  0},;	//  4 Dt.Vencimento
				 {'HC_DTPGT' ,'D',  8,  0},;	//  5 Dt.Pagamento
				 {'HC_VLRDP' ,'N', 15,  2},;	//  6 Vlr.Duplicata
				 {'HC_VLRPG' ,'N', 15,  2},;	//  7 Vlr.Pago
				 {'HC_VLRJU' ,'N', 15,  2},;	//  8 Vlr.JUROS
				 {'HC_VLRDE' ,'N', 15,  2},;	//  9 Vlr.DESCONTOS
				 {'HC_VLRMO' ,'N', 15,  2},;	// 10 Vlr.Pago em (MOEDA)
				 {'HC_NRNF'  ,'N',  9,  0},;	// 11 Numero da NF
				 {'HC_SERIE' ,'C',  3,  0},;	// 12 Serie da NF
				 {'HC_CXACG', 'N',  3,  0},;	// 13 Codigo Caixa
				 {'HC_FLCXA' ,'L',  1,  0},;	// 14 Caixa Integrado ?
				 {'HC_FLBCO' ,'L',  1,  0},;	// 15 Bancos Integrado ?
				 {'HC_VLRET' ,'N', 15,  2},;	// 16 Vlr Retido
				 {'HC_VLBON' ,'N', 15,  2},;	// 17 Vlr Bonificado
				 {'HC_CDCXA' ,'N',  2,  0}},;	// 18 Codigo do Caixa
 */
	@nX++,27 say 'Cli/For....:' get VM_CODCL  pict mI5
	@nX++,27 say 'Nr.Dupl....:' get VM_DUPLI  pict mDPL
	@nX++,27 say 'Dt.Emissao.:' get VM_DTEMI  pict mDT
	@nX++,27 say 'Dt.Pgto....:' get VM_DTVEN  pict mDT
	@nX++,27 say 'Vlr Duplic.:' get VM_VLRDP  pict mI122
	@nX++,27 say 'Vlr Pago...:' get VM_VLRPG  pict mI122
	@nX++,27 say 'Vlr Juros..:' get VM_VLRJU  pict mI122
	@nX++,27 say 'Vlr Descont:' get VM_VLRDE  pict mI122
	@nX  ,27 say 'Nr Nota Fisc' get VM_NRNF   pict mI9
	@nX++,55 say 'Serie......:' get VM_SERIE  pict mUUU
	@nX  ,27 say 'Cod.Caixa..:' get VM_CXACG  pict mI3
	@nX++,55 say 'Grupo.Conta:' get VM_CDCXA  pict mI2
	@nX++,27 say 'Vlr Retido.:' get VM_VLRET  pict mI122
	@nX++,27 say 'Vlr Bonifica' get VM_VLBON  pict mI122
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		VM_FLCXA:=.T.
		VM_FLBCO:=.T.
		VM_VLRMO:=VM_VLRPG/1.9
		while !addrec();end
		for nX :=1 to FCount()
			X1:="VM"+substr(fieldname(nX),3)
			fieldput(nX,&X1)
		next
	end
	setcolor(VM_CORPAD)
	dbrunlock()
return NIL
*-----------------------------------EOF---------------------------------------*
