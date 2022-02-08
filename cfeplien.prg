*-----------------------------------------------------------------------------*
function CFEPLIEN()	// Registro de Entrada												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_REL:='R E G I S T R O   D E   E N T R A D A'
pb_lin4(VM_REL,ProcName())

if !abre({	'C->PARAMETRO',;
				'R->NATOP',;
				'R->PARAMCTB',;
				'R->CLIENTE',;
				'R->PROD',;
				'R->ENTCAB',;
				'R->ENTDET'})
	return NIL
end

select('PROD');dbsetorder(2)
select('ENTCAB')
ORDEM DTEDOC // Entrada Cabec, ORDEM DATA+DOCTO

set relation to str(EC_CODFO,5) into CLIENTE,;
             to str(EC_CODOP,7) into NATOP

PERIODO:=left(dtos(bom(PARAMETRO->PA_DATA)-1),6)
	PAG :=PARAMETRO->PA_PAGEN+1
	SEQ :=PARAMETRO->PA_SEQEN+1
	LAR :=132
ATUALIZ:='N'
pb_box(16,30,,,,'Selecione')
@18,32 say 'Selecione Periodo.:' get PERIODO pict mPER valid fn_period(PERIODO)
@19,32 say 'Atualizar Folhas  ?' get ATUALIZ pict mUUU valid ATUALIZ$'SN' when pb_msg('Atualiza o Nr da Folha nos Parametros ?')
@20,32 say 'Folha Inicial.....:' get PAG     pict mI5  valid PAG>=0
@21,32 say 'Sequencia Lctos...:' get SEQ     pict mI5  valid SEQ>=0
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	FLAG     :=.T.
	VM_TOTAL :={{0,0,0,0},;
					{0,0,0,0}}
	dbseek(PERIODO,.T.)
	paginae(VM_REL,@PAG,LAR)
	DataQueb:=EC_DTENT
	dbeval({||CFEPLIEN1()},{||(NATOP->NO_ILIVRO.or.NATOP->NO_CODIG==0)},;
	                       {||left(dtos(EC_DTENT),6)==PERIODO.and.pb_brake(.T.)})
	?replicate('-',LAR)
	? padc('Totais...',47)+transform(VM_TOTAL[1,1],masc(25))
	??space(21)+transform(VM_TOTAL[1,2],masc(25))
	??space(08)+transform(VM_TOTAL[1,3],masc(25))
	??space(00)+transform(VM_TOTAL[1,4],masc(25))
	?replicate('-',LAR)
	eject
	pb_deslimp(C15CPP)
	if ATUALIZ=='S'
		select('PARAMETRO')
		if reclock()
			replace 	PA_PAGEN with PAG-1,;
						PA_SEQEN with SEQ-1
			dbrunlock()
		end
	end
end
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function CFEPLIEN1()
//-----------------------------------------------------------------------------*
local FlImp:=.F.

//if DataQueb#EC_DTENT
//	?'--> quebra:VlTotal'+transform(VM_TOTAL[1,1],masc(25))
//	?'--> quebra:VlBase.'+transform(VM_TOTAL[1,2],masc(25))
//	?'--> quebra:VlIcms.'+transform(VM_TOTAL[1,3],masc(25))
//	DataQueb:=EC_DTENT
//end

	paginae(VM_REL,@PAG,LAR)
	NATOP->(dbseek(str(ENTCAB->EC_CODOP,7)))
	? transform(EC_DTENT,masc(7))+space(1)
	??EC_TPDOC+space(1)
	??EC_SERIE+space(3 )
	??pb_zer(EC_DOCTO,8)+space(1)
	??transform(EC_DTEMI,masc(7))+space(1)
	??pb_zer(EC_CODFO,5)+space(1)
	??transform(ENTCAB->EC_TOTAL-ENTCAB->EC_DESC+ENTCAB->EC_ACESS,masc(25))+space(1)
	??space(5)+'0 '
	??left(str(EC_CODOP,7),5)
	??' ICMS '
	if NATOP->NO_CDVLFI==4
		??'3 '
		FlImp:=.T.
	else
		if EC_ICMSB+EC_ICMSP+EC_ICMSV+EC_VLROBS>0
			??str(NATOP->NO_CDVLFI,1)+space(1)
			FlImp:=.T.
		else
			if EC_ICMSB > 0
				??str(NATOP->NO_CDVLFI,1)+space(1)
			else
				??'2 '
			end
		end
	end
	if FlImp
		??transform(EC_ICMSB, masc(25))+space(1)
		??transform(EC_ICMSP, masc(20))+space(1)
		??transform(EC_ICMSV, masc(25))
		??transform(EC_VLROBS,masc(25))
		??str(SEQ,5)
	end
	if NATOP->NO_CDVLFI==4.or.EC_TPDOC=='AJU'
		? space(28)+left(EC_PARCE,88)
	end

	SEQ++
	VM_TOTAL[1,1]+=ENTCAB->EC_TOTAL-ENTCAB->EC_DESC+ENTCAB->EC_ACESS
	VM_TOTAL[1,2]+=EC_ICMSB
	VM_TOTAL[1,3]+=EC_ICMSV
	VM_TOTAL[1,4]+=EC_VLROBS
	if NATOP->NO_CDVLFI==1.and.EC_TOTAL-EC_DESC-EC_ICMSB>0
		if arred(EC_TOTAL-EC_DESC,2)>arred(EC_ICMSB,2)
			if FlImp
				? space(73)+'ICMS 2 '
			end
			??transform(arred(EC_TOTAL-EC_DESC-EC_ICMSB,2),masc(25))+space(32)
			??str(SEQ,5)
			SEQ++
			VM_TOTAL[1,2]+=arred(EC_TOTAL-EC_DESC-EC_ICMSB,2)
		end
	elseif NATOP->NO_CDVLFI==2
		??transform(arred(EC_TOTAL-EC_DESC-EC_ICMSB,2),masc(25))+space(32)
		??str(SEQ,5)
		SEQ++
		VM_TOTAL[1,2]+=arred(EC_TOTAL-EC_DESC-EC_ICMSB,2)
	end
	
return NIL

*-----------------------------------------------------------------------------*
static function PAGINAE(P1,P2,P3)
*-----------------------------------------------------------------------------*
if prow()>60.or.FLAG
	if prow()>60
		eject
	end
	?replicate('-',P3)
	?INEGR+padc(P1,P3)+CNEGR
	?replicate('-',P3)
	?padr('Empresa.......: '+VM_EMPR,78)											+'| [*] - Codigo de Valores Fiscais'
	?padr('Inscr Estadual: '+PARAMETRO->PA_INSCR,78)							+'| [1] - Operacao com Cred.Imposto'
	?padr('C.G.C.........: '+transform(PARAMETRO->PA_CGC,masc(18))  ,78)	+'| [2] - Operacao sem Cred.Imposto Isentas ou nao Trib.'
	?padr('Folha.........: '+pb_zer(P2,3)      ,78)								+'| [3] - Operacao sem Credito do Imposto - Outras'
	?padr('Mes/Ano.......: '+right(PERIODO,2)+'/'+left(PERIODO,4)  ,78)	+'| [4] - Operacao Especial com Cred.Imposto'
	?replicate('-',P3)
	?space(10)+'|'     +padc('Documentos Fiscais',36,'-')+'|'+space(14)+'|Classific.|'+padc('Valores Fiscais',48,'-')+'|'
	?padc('Data'   ,11)+'    Serie             Data    Codig        Valor    Cod Cla   ICMS   Base de Calculo          Imposto       Valor Nro'
	?padc('Entrada',11)+'ESP SubSe   Numero  Document  Fornec    Contabil Contab Fis   IPI (*) Vlr Operacao  ALIQ     Creditos      Observ Lcto'
	?replicate('-',P3)
	P2++
	FLAG:=.F.
end
return NIL
//-------------------------------------------------------EOF-------------------------------------------------
