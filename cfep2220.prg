*-----------------------------------------------------------------------------*
#include 'RCB.CH'
 
*-----------------------------------------------------------------------------*
 function CFEP2220(VM_P1) // Digitacao das Duplicatas									*
*-----------------------------------------------------------------------------*
local CPO
ARQUIVO:=if(VM_P1==1,'FORNEC','CLIENTE')

pb_tela()
pb_lin4(_MSG_+'('+if(VM_P1=1,'Pagar','Receber')+')',ProcName())

if VM_P1==1
	CPO:={'C->PARAMETRO',;
			'C->CTRNF',;
			'C->BANCO',;
			'C->CLIENTE',;
			'C->DPFOR',;
			'C->CLIOBS',;
			'C->CTRLOTE',;
			'C->HISPAD',;
			'C->CTATIT',;
			'C->CTADET',;
			'C->PARAMCTB'}
else
	CPO:={'C->PARAMETRO',;
			'C->CTRNF',;
			'C->BANCO',;
			'C->CLIENTE',;
			'C->DPCLI',;
			'C->CLIOBS',;
			'C->CTRLOTE',;
			'C->HISPAD',;
			'C->CTATIT',;
			'C->CTADET',;
			'C->PARAMCTB'}
end

if !abre(CPO)
	dbcloseall()
	return NIL
end

if VM_P1==1
	select DPFOR
else
	select DPCLI
end

dbsetorder(2)
DbGoTop()

pb_dbedit1('CFEP222','IncluiAlteraProcurExcluiOrdem Protes')
VM_CAMPO:=array(15)
afields(VM_CAMPO)
VM_CAMPO[02]:='pb_zer('+fieldname(2)+',5)+chr(45)+left('+fieldname(12)+',25)'    //&ARQUIVO->'+left(ARQUIVO,2)+'_RAZAO'
VM_CAMPO[03]:=fieldname(6)
VM_CAMPO[06]:=fieldname(3)
VM_CAMPO[09]:='if('+fieldname(9)+'=0,"US$","R$.")'
set key K_ALT_A to _CorrigeNome() // ALT + A --> Corrige NOMES
// set key K_ALT_B to AT_NUMERO() // Atualiza NUMEROS
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
	{			mDPLN,   mXXX,             mD82,		   mDT,  	 mDT, 	  mDT,   masc(2),masc(1),masc(1),masc(19),masc(1),masc(23),masc(7), masc(23),         masc(26)},;
	{'Nr.Duplicata',	'Nome', 'Vlr.Duplicat','Vencimen','Dt Pgto','Emiss„o','Vlr.Pago','Banco','Moeda','Nr NF','Serie', 'ALFA','Dt Prot','Cart Oficio Prot','JurosMes'})

set key K_ALT_A to // Corrige NOMES
set relation to
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function CFEP2221() // Rotina de Inclus„o
*-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEP2220T(.T.)
end
return NIL
*-----------------------------------------------------------------------------*

function CFEP2222() // Rotina de Alteracao
if &(fieldname(7))==0
	if reclock()
		CFEP2220T(.F.)
	end
else
	beepaler()
	pb_msg('Duplicata j  foi paga parcilamente ... NAO E POSSIVEL ALTERAR !!',2)
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEP2220T(VM_FL)
*-----------------------------------------------------------------------------*
local GETLIST:={}
local VM_DPLS:={}
local VM_NOME
local FLAG
local X
VM_DUPLI := &(fieldname(1))
VM_CODFO := &(fieldname(2))
VM_DTEMI := &(fieldname(3))
VM_DTVEN := &(fieldname(4))
VM_VLRDP := &(fieldname(6))
VM_CODBC := &(fieldname(8))
VM_MOEDA := if(VM_FL,1,&(fieldname(9)))
VM_DTEMI := if(empty(VM_DTEMI),PARAMETRO->PA_DATA,VM_DTEMI)
VM_DTVEN := if(empty(VM_DTVEN),PARAMETRO->PA_DATA+30,VM_DTVEN)
VM_NRNF  := &(fieldname(10))
VM_SERIE := &(fieldname(11))
VM_JUROS := if(VM_FL,PARAMETRO->PA_DESCV,&(fieldname(15)))
VM_OBS   := fieldget(14)
VM_PARC  := 1
VM_SEQUEN:= 0
VM_CTBL  := 'S'
pb_box(14,0)
@15,02 say padr('Nr.Parcelas',14,'.')   get VM_PARC  picture masc(11) valid VM_PARC>0 when VM_FL
if VM_FL
	dbsetorder(1)
	dbgobottom()
	VM_DUPLI:=int(&(fieldname(1))/100)+1
	dbsetorder(2)
	@16,02 say padr('Duplicata',14,'.')     get VM_DUPLI picture masc(19) valid VM_DUPLI>0
	@16,23 say '/'
	@16,24 get VM_SEQUEN pict mI2 valid VM_SEQUEN>0 when VM_PARC==1
else
	@16,02 say padr('Duplicata',14,'.')     get VM_DUPLI picture masc(16) valid VM_DUPLI>0 when .F.
end
@16,30 say 'N§Nota Fiscal:'            get VM_NRNF  picture masc(19)
@16,55 say 'Serie:'                    get VM_SERIE picture masc(01) valid VM_SERIE==SCOLD.or.fn_codigo(@VM_SERIE,{'CTRNF',{||CTRNF->(dbseek(VM_SERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}})
@17,02 say padr('Emitente',  14,'.')   get VM_CODFO picture masc(04) valid fn_codigo(@VM_CODFO,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODFO,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@18,02 say padr('Dt.Entrada',14,'.')   get VM_DTEMI picture masc(07) valid VM_DTEMI<=PARAMETRO->PA_DATA when pb_msg('Data de Entrada no Sistema de Faturamento')
if !VM_FL
	@18,40 say padr('Dt.Vencim',14,'.')  get VM_DTVEN picture masc(07) valid VM_DTVEN>=VM_DTEMI
end
@19,02 say padr(if(VM_FL,'Valor Total','Valor Duplicata'),14,'.')   get VM_VLRDP picture masc(05) valid VM_VLRDP>0 .and. if(VM_FL,len(VM_DPLS:=fn_parc(VM_PARC,VM_VLRDP,VM_DUPLI,VM_DTEMI,VM_SEQUEN))>0,.T.)
@19,40 say '%Juros Financ.:'            get VM_JUROS pict masc(26) valid VM_JUROS>=0
@20,02 say padr('Banco',14,'.')         get VM_CODBC pict masc(11) valid fn_codigo(@VM_CODBC,{'BANCO',{||BANCO->(dbseek(str(VM_CODBC,2)))},{||CFEP1500T(.T.)},{2,1}})
@21,02 say 'OBS:'                       get VM_OBS   pict mXXX
if VM_FL
	@21,60 say 'Contabilizar:'           get VM_CTBL  pict mUUU valid VM_CTBL$'SN' when pb_msg('Entrar para contabilizar lancamento?')
end
read
setcolor(VM_CORPAD)
if lastkey()#K_ESC
	VM_NOME:=CLIENTE->(fieldget(2))
	if VM_FL // inclusao
		if pb_sn()
			for X:=1 to len(VM_DPLS)
				while !AddRec();end
				replace &(fieldname(01)) with VM_DPLS[X,1],;
						  &(fieldname(02)) with VM_CODFO,;
						  &(fieldname(03)) with VM_DTEMI,;
						  &(fieldname(04)) with VM_DPLS[X,2],;
						  &(fieldname(06)) with VM_DPLS[X,3],;
						  &(fieldname(08)) with VM_CODBC,;
						  &(fieldname(09)) with 1,; //............ Moeda R$
						  &(fieldname(10)) with VM_NRNF,;//....... Nr Nf
						  &(fieldname(11)) with VM_SERIE,; //..... Serie
						  &(fieldname(12)) with VM_NOME,;
						  &(fieldname(14)) with VM_OBS,;
						  &(fieldname(15)) with VM_JUROS
			next
			if ARQUIVO#'FORNEC'
				X:=alert('Selecione ..... ',{'Terminar','Imprimir Carne'},'R/W')
				if X==2
					fn_impcarne(VM_CODFO,VM_NOME,VM_DPLS,VM_DTEMI)
				end
			end
			ContabLote(VM_DTEMI,VM_VLRDP,'DPL-'+pb_zer(VM_DUPLI,9))
		end
	else
		replace &(fieldname( 1)) with VM_DUPLI,;
				  &(fieldname( 2)) with VM_CODFO,;
				  &(fieldname( 3)) with VM_DTEMI,;
				  &(fieldname( 4)) with VM_DTVEN,;
				  &(fieldname( 6)) with VM_VLRDP,;
				  &(fieldname( 8)) with VM_CODBC,;
				  &(fieldname( 9)) with VM_MOEDA,;
				  &(fieldname(10)) with VM_NRNF,;//....... Nr Nf
				  &(fieldname(11)) with VM_SERIE,; //..... Serie
				  &(fieldname(12)) with VM_NOME,;
				  &(fieldname(15)) with VM_JUROS
	end
	// dbcommitall()
end
dbrunlock()
return NIL
*-----------------------------------------------------------------------------*
 function CFEP2223() // Rotina de Pesquisa
*-----------------------------------------------------------------------------*
local VM_X
local VM_CHAVE1
local VM_CHAVE2
local VM_CHAVE3
VM_CHAVE1 = {&(fieldname(1)),&(fieldname(12))+SPACE(20),&(fieldname(8)),&(fieldname(4))}
VM_CHAVE2 = {'DUPLICATA',   'NOME',          'BANCO',        'DATA'}
VM_CHAVE3 = {masc(9),        masc(1),         masc(11),       masc(7)}
pb_box(20,22)
@21,23 say 'Pesquisar '+VM_CHAVE2[indexord()]+'..:' get VM_CHAVE1[indexord()] picture VM_CHAVE3[indexord()]
read
setcolor(VM_CORPAD)
if indexord()<3
	dbseek(transform(VM_CHAVE1[indexord()],VM_CHAVE3[indexord()]),.T.)
else
	dbseek(dtos(VM_CHAVE1[indexord()]),.T.)
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEP2224() // Rotina de Exclusao
*-----------------------------------------------------------------------------*
if reclock().and.pb_sn('Excluir DUPLICATA.:'+transform(&(fieldname(1)),masc(16)))
	if (&(fieldname(1))==0.and.&(fieldname(2))==0).or.(&(fieldname(7))==0)	
		fn_elimi()
	else
		beeperro()
		pb_msg('Duplicata paga parcilamente . N„o EXCLUIDA !',2)
	end
end
dbrunlock(recno())
return NIL

*-----------------------------------------------------------------------------*
 function CFEP2225() // Mudanca de Ordem
*-----------------------------------------------------------------------------*
local X
X:=dbsetorder()
pb_box(17,64)
@18,66 prompt padc('Duplicata',11)
@19,66 prompt padc('Nome',     11)
@20,66 prompt padc('Banco',    11)
@21,66 prompt padc('Data Venc',11)
menu to X
if lastkey() # K_ESC
	dbsetorder(X)
	DbGoTop()
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEP2226() // Protestar
*-----------------------------------------------------------------------------*
local VM_DUPLI  := &(fieldname( 1))
local VM_DTPROT := &(fieldname(13))
local VM_OFICIO := &(fieldname(14))
local VM_DTVEN :=  &(fieldname(04))
if reclock()
	pb_box(16,0)
	@17,02 say padc('Protestar Duplicata  : '+transform(VM_DUPLI,masc(16)),76) color 'W+/R'
	@19,02 say 'Nova data de Vencimento...:' get VM_DTVEN  pict masc(07)
	@20,02 say 'Data de Protesto Duplicata:' get VM_DTPROT pict masc(07)
	@21,02 say 'Cart¢rio Oficio Protesto..:' get VM_OFICIO pict masc(01)
	read
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		replace 	&(fieldname(04)) with VM_DTVEN,;
					&(fieldname(13)) with VM_DTPROT,;
				  	&(fieldname(14)) with VM_OFICIO
	end
	dbrunlock(recno())
end	
return NIL

*-----------------------------------------------------------------------------*
static function _CorrigeNome() // Atualiza
*-----------------------------------------------------------------------------*
if pb_sn('Atualizar dados dos nomes nas duplicatas ?')
	salvabd(SALVA)
	if ARQUIVO='CLIENTE'
		select DPCLI
	else
		select DPFOR 
	end
	dbsetorder(5)
	set relation to str(&(fieldname(2)),5) into CLIENTE
	DbGoTop()
	pb_msg()
	if fillock()
		while !eof()
			replace &(fieldname(12)) with CLIENTE->CL_RAZAO
			dbskip()
		end
	end
	keyboard chr(27)
	salvabd(RESTAURA)
end
return NIL

*-----------------------------------------------------------------------------*
static function AT_NUMERO() // Atualiza
*-----------------------------------------------------------------------------*
local NUMERO:=1
local SEQ
local NRDPL
if pb_sn('Renumerar todas as duplicatas ?').and.abre({'E->HISCLI'})
	salvabd(SALVA)
	if ARQUIVO#'CLIENTE'
		return NIL
	end
	select DPCLI
	dbsetorder(1)
	DbGoTop()
	pb_msg()
	if fillock()
		while !eof()
			NRDPL:=DR_DUPLI
			SEQ  :=1
			while !eof().and.left(str(NRDPL,12),10)==left(str(DR_DUPLI,12),10)
				//movimentos
				select HISCLI
				dbseek(				str(DPCLI->DR_CODCLI,5),.T.)
				while !eof().and.	str(DPCLI->DR_CODCLI,5)==str(HC_CODCLI,5)
					if str(NR_DPL,12)==str(HC_DUPLI,12)
						replace HC_DUPLI with NUMERO*100+SEQ
					end
					dbskip()
				end
				//corrigir numero
				select DPCLI
				replace DR_DUPLI with NUMERO*100+SEQ
				SEQ++
				dbskip()
			end
			NUMERO++
		end
	end
	keyboard chr(27)
	salvabd(RESTAURA)
end
return NIL

*-------------------------------------------------------------------------*
static function ContabLote(pDtEmi,pVlrLo,pDescr)
*-------------------------------------------------------------------------*
local NrLote:=NovoLote()// buscar novo número de lote
alert('Criado lote novo na contabilidade;para estes lancamentos;Lote Numero '+str(NrLote,8))
SALVABANCO
select('CTRLOTE')
while !addrec();end
replace  CL_NRLOTE with NrLote,;
			CL_VLRLT  with pVlrLo,;
			CL_FECHAD with .F.,;
			CL_DATA   with pDtEmi,;
			CL_DIGIT  with pDescr
CTBP122D()
select('LOTE')
close
RESTAURABANCO
pb_dbedit1('CFEP222','IncluiAlteraProcurExcluiOrdem Protes') // é necessário por causa da digitação do lote

return NIL
*------------------------------EOF-----------------------------------------*
