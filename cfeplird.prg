*-----------------------------------------------------------------------------*
function CFEPLIRD()	// Livro Registro de Duplicata												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
private VM_DATA:={boy(date()),eoy(date())}

VM_REL='REGISTRO DE DUPLICATA'
pb_lin4(VM_REL,ProcName())

if !abre({'C->PARAMETRO','R->PARAMCTB','R->DPCLI','R->HISCLI','R->CLIENTE','R->PEDCAB'})
	return NIL
end

select('DPCLI');dbsetorder(6)		// NF+SERIE
select('HISCLI');dbsetorder(2)	// NF+SERIE
select('PEDCAB');dbsetorder(5)	// Entrada Cabec, ORDEM DATA+DOCTO
set relation to str(PC_CODCL,5) into CLIENTE

pb_box(18,30)
	PAG :=PARAMETRO->PA_PAGRD+1
	SEQ :=PARAMETRO->PA_SEQRD+1
	LAR :=132
@19,32 say 'Selecione Periodo.:' get VM_DATA[1] pict masc(7)
@19,63 say 'ate '                get VM_DATA[2] pict masc(7) valid VM_DATA[2]>=VM_DATA[1]
@20,32 say 'Folha Inicial.....:' get PAG     pict masc(12)
@21,32 say 'Sequencia Lctos...:' get SEQ     pict masc(04)
read
if if(lastkey()#K_ESC,pb_ligaimp(I20CPP),.F.)
	VM_CPO:=array(2)
	LAR:=250
	FLAG:=.T.
	VM_CPO[1]:=VM_DATA[1]
	VM_CPO[2]:=VM_DATA[2]
	TOTAL :={0,0,0}
	DbGoTop()
	paginard(VM_REL,@PAG,LAR)
	dbeval({||CFEPLIRD1()},;
			 {||PC_DTEMI<=VM_DATA[2].and.PC_FATUR>0},;
			 {||pb_brake(.T.)})
	?replicate('-',LAR)
	? padr('Totais',20,'.')
	??transform(TOTAL[1],masc(2))
	??space(161)+transform(TOTAL[3],masc(5))
	?replicate('-',LAR)
	eject
	pb_deslimp(C20CPP)
	select('PARAMETRO')
	if reclock()
		replace PA_PAGEN with PAG-1
		replace PA_SEQEN with SEQ-1
		dbrunlock()
	end
end
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function CFEPLIRD1()
//-----------------------------------------------------------------------------*
local DPLS:=bus_dpls(PC_NRNF,PC_SERIE),X:=(PC_DTEMI>=VM_DATA[1])

// imprimir as dpls pendentes mesmo sendo de emissao de periodo anterior
// falta verificar estas impressoes
// aeval(DPLS,{|DET|DET[3]>=
//

if X
	paginard(VM_REL,@PAG,LAR)
	X:=1
	TOTAL[1]+=PC_TOTAL-PC_DESC
	? transform(PC_NRNF,masc(19))+space(1)+PC_SERIE+space(1)
	??transform(PC_DTEMI,masc(7))+space(1)
	??transform(PC_TOTAL-PC_DESC,masc(2))+space(1)
	??pb_zer(PC_CODCL,5)+'-'+CLIENTE->CL_RAZAO+space(1)
	??CLIENTE->CL_ENDER+space(1)
	??CLIENTE->CL_CIDAD+space(1)
	if len(DPLS)=0
		?? '*** Nao foi encontrado a duplicada desta Nota Fiscal ***'
	end
	for X:=1 to len(DPLS)
		if X>1
			? space(163)
		end
		??transform(DPLS[X,1],masc(16))+' ' // nr dpls
		??transform(DPLS[X,2],masc(07))+' '	// dt venci
		if !empty(DPLS[X,3])
			??transform(DPLS[X,3],masc(07))+' '	// dt pgto
		else
			??space(11)
		end
		if DPLS[X,4]>0
			??transform(DPLS[X,4],masc(05))+' '	// vlr dpls
		else
			??space(13)
		end
		if DPLS[X,5]>0
			??transform(DPLS[X,5],masc(05))+' '	// vlr pgto 
		else
			??space(13)
		end
		??transform(DPLS[X,6],masc(07))+' '	// dt prot
		??padr(transform(DPLS[X,7],masc(23)),23)	// oficio prot
		TOTAL[2]+=DPLS[X,4]
		TOTAL[3]+=DPLS[X,5]
	next
end	
return NIL

*-----------------------------------------------------------------------------*
function PAGINARD(P1,P2,P3)
if prow()>60.or.FLAG
	if prow()>60
		eject
	end
	?replicate('-',P3)
	?INEGR+padc(P1,P3)+CNEGR
	?replicate('-',P3)
	?padr('Empresa.......: '+VM_EMPR,78)           
	?padr('Inscr Estadual: '+PARAMETRO->PA_INSCR,78)
	?padr('C.G.C.........: '+transform(PARAMETRO->PA_CGC,masc(18))  ,78)
	?padr('Folha.........: '+pb_zer(P2,3)      ,78)
	?padr('Datas Limites.: '+dtoc(VM_DATA[1])+' ate '+dtoc(VM_DATA[2]),78)
	?replicate('-',P3)
	? 'N.Fisc Ser Data Emiss Vlr Nota Fiscal Codig '+padr('Nome do Cliente',46)
	??padr('Endereco',46)
	??padr('Cidade',21)
	??'  Nr Dupls Data Vcto  Data Pgto  Vlr Duplicata Valor Pagto Data Prot. '
	??'Oficio Protesto'
	?replicate('-',P3)
	P2++
	FLAG:=.F.
end
return NIL

*-----------------------------------------------------------------------------------*
function BUS_DPLS(pNRNF,pSerie)
*-----------------------------------------------------------------------------------*
local DPLS:={}
local X
salvabd(SALVA)
select('DPCLI')
dbseek(str(pNRNF,9)+pSerie,.T.)
dbeval({||aadd(DPLS,{DR_DUPLI,DR_DTVEN,ctod(''),DR_VLRDP,0,DR_DTPROT,DR_OFICIO})},,;
       {||str(pNRNF,9)+pSerie==str(DR_NRNF,9)+DR_SERIE})

select('HISCLI')
dbseek(str(pNRNF,6)+pSerie,.T.)
dbeval({||aadd(DPLS,{HC_DUPLI,HC_DTVEN,HC_DTPGT,HC_VLRDP,HC_VLRPG,ctod(''),space(30)})},,;
		 {||str(pNRNF,9)+pSerie==str(HC_NRNF,9)+HC_SERIE})

if len(DPLS)>0
	DPLS:=asort(DPLS,,,{|X,Z|str(X[1],9)+dtos(X[2])+dtos(X[3])<str(Z[1],9)+dtos(Z[2])+dtos(Z[3])})
	for X:=1 to len(DPLS)
		if X>1.and.DPLS[X,1]==DPLS[X-1,1]
			DPLS[X,4]:=0
		end
	next
end

salvabd(RESTAURA)
return(DPLS)
//---------------------------------------------EOF
