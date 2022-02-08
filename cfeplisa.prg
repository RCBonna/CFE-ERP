*-----------------------------------------------------------------------------*
	function CFEPLISA()	//	Livro Fiscal de Saida										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
*-----------------------------------------------------------------------------*
VM_REL:='R E G I S T R O   D E   S A I D A'
pb_lin4(VM_REL,ProcName())

if !abre({	'C->PARAMETRO',;
				'R->NATOP',;
				'R->PARAMCTB',;
				'R->CLIENTE',;
				'R->PROD',;
				'R->PEDCAB',;
				'R->PEDDET'})
	return NIL
end

select('PROD');dbsetorder(2)
select('PEDCAB');dbsetorder(6)	// Entrada Cabec, ORDEM DATA+NR NF

set relation to str(PC_CODCL,5) into CLIENTE,;
             to str(PC_CODOP,7) into NATOP

PERIODO:=left(dtos(bom(PARAMETRO->PA_DATA)-1),6)
	PAG :=PARAMETRO->PA_PAGSA+1
	SEQ :=PARAMETRO->PA_SEQSA+1
	LAR :=132
ATUALIZ:='N'

pb_box(16,30,,,,'Selecione')
@18,32 say 'Selecione Periodo.:' get PERIODO pict mPER valid fn_period(PERIODO)
@19,32 say 'Atualizar Folha   ?' get ATUALIZ pict mUUU valid ATUALIZ$'SN' when pb_msg('Atualiza Nr da Folha nos Parametros ?')
@20,32 say 'Folha Inicial.....:' get PAG     pict mI5  valid PAG>=0
@21,32 say 'Sequencia Lctos...:' get SEQ     pict mI5  valid SEQ>=0
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	FLAG     :=.T.
	VM_TOTAL :={{0,0,0,0,0,0},;
					{0,0,0,0,0,0}}
	dbseek(PERIODO,.T.)
	paginas(VM_REL,@PAG,LAR)

	dbeval({||CFEPLISA1()},{||PEDCAB->PC_FLAG.AND.!PEDCAB->PC_FLCAN},;
	                       {||left(dtos(PEDCAB->PC_DTEMI),6)==PERIODO.and.pb_brake(.T.)})

//	dbeval({||CFEPLISA1()},{||(NATOP->NO_ILIVRO.or.NATOP->NO_CODIG==0).AND.PEDCAB->PC_FLAG.AND.!PEDCAB->PC_FLCAN},;
//	                       {||left(dtos(PEDCAB->PC_DTEMI),6)==PERIODO.and.pb_brake(.T.)})

	?replicate('-',LAR)
	? padc('Totais...',23)+	transform(VM_TOTAL[1,1],masc(25))
	??space(12)+'ICMS '+		transform(VM_TOTAL[1,2],masc(25))
	??space(07)+				transform(VM_TOTAL[1,3],masc(25))
	??          				transform(VM_TOTAL[1,4],masc(25))
	??								transform(VM_TOTAL[1,5],masc(25))
	??								transform(VM_TOTAL[1,6],masc(25))
	?replicate('-',LAR)
	eject
	pb_deslimp(C15CPP)
	if ATUALIZ=='S'
		select('PARAMETRO')
		if reclock()
			replace 	PA_PAGSA with PAG-1,;
						PA_SEQSA with SEQ-1
			dbrunlock()
		end
	end
end
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function CFEPLISA1()
//-----------------------------------------------------------------------------*
local FLAG1  :=.F.
local TOTALNF:=0
local X
local VM_TP
local VICMS

	paginas(VM_REL,@PAG,LAR)
	VICMS:=fn_nfsoma(PEDCAB->PC_PEDID,{PEDCAB->PC_TOTAL,PEDCAB->PC_DESC,NATOP->NO_CDVLFI})
	VM_TP:=if(empty(PEDCAB->PC_TPDOC),'NF ',PEDCAB->PC_TPDOC)
	aeval(VICMS,{|DET|TOTALNF+=DET[2]})
	? VM_TP								+space(1)
	??PC_SERIE							+space(3)
	??pb_zer(PC_NRNF,6)				+space(1)
	??pb_zer(day(PC_DTEMI),2)		+space(1)
	??transform(TOTALNF,masc(2))	+space(1) // CONTABIL
	??space(5)
	??left(str(PC_CODOP,7),5)
	VM_TOTAL[1,1]+=TOTALNF
	for X:=1 to len(VICMS)
		if (VICMS[X,2]+VICMS[X,3]+VICMS[X,4]+VICMS[X,5]+VICMS[X,6])>0
			if FLAG1
				?space(46)
			end
			??' ICMS '
			??transform(VICMS[X,3],				 masc(25))			// V.BASE
			??transform(VICMS[X,1],masc(20))+space(01)			// % ICMS
			??transform(VICMS[X,4],				 masc(25))			// V.ICMS
			??transform(abs(VICMS[X,2]-VICMS[X,3]),masc(25))	// V.ISENTAS
			??transform(VICMS[X,5],           masc(25))			// OUTRAS
			??transform(VICMS[X,6],           masc(25))			// VLR OBS
			??str(SEQ,6)
			if NATOP->NO_CDVLFI==4.or.VM_TP=='AJU'
				? space(28)+left(PC_OBSER,104)
			end
			VM_TOTAL[1,2]+=VICMS[X,3]
			VM_TOTAL[1,3]+=VICMS[X,4]
			VM_TOTAL[1,4]+=VICMS[X,2]-VICMS[X,3]
			VM_TOTAL[1,5]+=VICMS[X,5]
			VM_TOTAL[1,6]+=VICMS[X,6]
			SEQ++
			FLAG1:=.T.
		end
	next
	
return NIL

//-----------------------------------------------------------------------------*
  function FN_NFSOMA(P1,P4)
//-----------------------------------------------------------------------------*
local P2:= {{ 0,0,0,0,0,0}}
local P3
local P5
if P4[3]#4 // TIPO DE NATUREZA
	SALVABANCO
	select('PEDDET')
	dbseek(str(P1,6),.T.)
	P5:=.T.
	while !eof().and.P1==PEDDET->PD_PEDID
		P5:=.F.
		P3:=ascan(P2,{|DET|DET[1]==PEDDET->PD_ICMSP})
		if P3==0
			aadd(P2,{PEDDET->PD_ICMSP,0,0,0,0,0})
			P3:=len(P2)
		end
		
		if P4[3]#3 // TODOS OS VALORES SÃO BASE OUTROS?
			P2[P3,2]+=round((PEDDET->PD_QTDE*PEDDET->PD_VALOR)-PEDDET->PD_DESCV-PEDDET->PD_DESCG+PEDDET->PD_ENCFI,2)// VLR TOTAL
			P2[P3,3]+=PEDDET->PD_BAICM	// BASE CALCULO
			P2[P3,4]+=PEDDET->PD_VLICM	// VLR ICMS
		else // TODOS OS VALORES SÃO OUTROS
			P2[P3,2]+=round((PEDDET->PD_QTDE*PEDDET->PD_VALOR)-PEDDET->PD_DESCV-PEDDET->PD_DESCG+PEDDET->PD_ENCFI,2)// VLR TOTAL
			P2[P3,3]+=PEDDET->PD_BAICM	// BASE CALCULO
			P2[P3,5]+=abs(P2[P3,2]-P2[P3,3])
			P2[P3,2]:=0	//.. VLR TOTAL
			P2[P3,3]:=0	//.. BASE CALCULO
		end
		dbskip()
	end
	if P5 // VERIFICAR 
		P2[1,1]:=0.00					// % ICMS
		P2[1,2]:=P4[1]-P4[2]			// TOTAL DA NOTA
		P2[1,3]:=PEDCAB->TR_BICMS	// BASE  ICMS
		P2[1,4]:=PEDCAB->TR_VICMS	// VALOR ICMS
		P2[1,5]:=0						// VALOR ICMS - PARA OUTROS
	end
	RESTAURABANCO
else // P4[3] == 4 ESPECIAL COM CREDITO DE ICMS => PEGAR DA PEDIDOS CABEC
	P2[1,1]:=0.00			// % ICMS
	P2[1,2]:=P4[1]-P4[2]	// TOTAL DA NOTA
	P2[1,3]:=PEDCAB->TR_BICMS		// BASE  ICMS
	P2[1,4]:=PEDCAB->TR_VICMS		// VALOR ICMS
	P2[1,5]:=0				// VALOR ICMS - PARA OUTROS
end
P2[1,6]:=PEDCAB->PC_VLROBS	// VALOR OBS
return P2

//-----------------------------------------------------------------------------*
  function PAGINAS(P1,P2,P3)
//-----------------------------------------------------------------------------*
if prow()>60.or.FLAG
	if prow()>60
		eject
	end
	?replicate('-'                                                 ,P3)
	?INEGR+padc(P1                                                 ,P3)+CNEGR
	?replicate('-'                                                 ,P3)
	?padr('Empresa.......: '+VM_EMPR                               ,78)
	?padr('Inscr Estadual: '+PARAMETRO->PA_INSCR                   ,78)
	?padr('C.G.C.........: '+transform(PARAMETRO->PA_CGC,masc(18)) ,78)
	?padr('Folha.........: '+pb_zer(P2,3)                          ,78)
	?padr('Mes/Ano.......: '+right(PERIODO,2)+'/'+left(PERIODO,4)  ,78)
	?replicate('-'                                                 ,P3)
	?'|'+padc('Documentos Fiscais',25,'-')+'|'+space(8)+'|Classificao |'+padc('Valores Fiscais',72,'-')+'|'
	?'    Serie                     Valor    Cod       ICMS Base de Calculo         Imposto       Valor       Valor       Valor   Nro'
	?'ESP SubSe Numero Dia       Contabil Contab Fiscal IPI  Vlr Operacao  ALIQ     Debitado     Isentas      Outras      Observ  Lcto'
	?replicate('-',P3)
	P2++
	FLAG:=.F.
end
return NIL
//------------------------------------------EOF-----------------------------------*
