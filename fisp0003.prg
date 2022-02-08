*-----------------------------------------------------------------------------*
function FISP0003()	// Lista Registro de Apuracao
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local X
if !abre({	'C->PARAMETRO',;
				'R->NATOP',;
				'R->PARAMCTB',;
				'E->FISPARA',;
				'E->FISRAPU'})
	return NIL
end

pb_lin4(_MSG_,ProcName())
PERIOD:=FISPARA->PA_PERINT
LIVRO :=FISPARA->PA_NRLIVR
PAG   :=FISPARA->PA_NRPAG
DADOS :={0,0,0,0,0,0,0}
		// 1,2,3,4,5,6,7
X:=10
pb_box(X++,2,,,,'Informe')
@X++,4 say 'Periodo...:' get PERIOD pict mPER valid fn_period(PERIOD)
@X++,4 say 'Livro N§..:' get LIVRO  pict mI3  valid LIVRO>0
@X++,4 say 'Folha N§..:' get PAG    pict mI3  valid PAG>0
@X++,4 say 'SAIDAS  -Outros Debitos...:' get DADOS[1]  pict mI122  valid DADOS[1]>=0
@X++,4 say 'SAIDAS  -Estorno Creditos.:' get DADOS[2]  pict mI122  valid DADOS[2]>=0
@X++,4 say 'ENTRADAS-Outros Creditos..:' get DADOS[3]  pict mI122  valid DADOS[3]>=0
@X++,4 say 'ENTRADAS-Estorno Debitos..:' get DADOS[4]  pict mI122  valid DADOS[4]>=0
@X++,4 say 'ENTRADAS-Cred.Ativo Imobil:' get DADOS[7]  pict mI122  valid DADOS[7]>=0

@X++,4 say 'ENTRADAS-Saldo Anterior...:' get DADOS[5]  pict mI122  valid DADOS[5]>=0
@X++,4 say 'APURACAO-Deducoes.........:' get DADOS[6]  pict mI122  valid DADOS[6]>=0
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	FLAG :=.T.
	FLAG2:=.T.
	REL :='R E G I S T R O   D E   A P U R A C A O   D O   I C M S '
	LAR :=132
	dbseek(PERIOD,.T.)
	TIPO1:=''
	TIPO2:=left(RA_CODOPE,1)
	TOTAL:={{0,0,0,0,0},{0,0,0,0,0}}
	IMPOSTO:={0,0}
	while !eof().and.RA_PERIOD==PERIOD
		if RA_CODOPE<'50000'
			TIPO1:='E N T R A D A S'
		else
			TIPO1:='S A I D A S'
		end
		if TIPO2#left(RA_CODOPE,1)
			imprstot()
			// finalizar Entradas Imprimir
			if TIPO2<'5'.and.left(RA_CODOPE,1)>'4'
				IMPOSTO[1]:=TOTAL[2,3] // total do imposto
				imprttot()
				FLAG:=.T.
			end
			TIPO2:=left(RA_CODOPE,1)
		end
		paginaa(REL,@PAG,LAR,TIPO1)
		NATOP->(dbseek(str(val((FISRAPU->RA_CODOPE+'00')),7),.T.))
		? '|      |'
		??padc(RA_CODOPE,6)+'|'
		??padr(NATOP->NO_DESCR,36)+'|'
		??transform(RA_VLRCTB,mD132)+'|'
		??transform(RA_VLRBAS,mD132)+'|'
		??transform(RA_VLRIMP,mD132)+'|'
		??transform(RA_VLRISE,mD132)+'|'
		??transform(RA_VLROUT,mD132)+'|'
		TOTAL[1,1]+=RA_VLRCTB
		TOTAL[1,2]+=RA_VLRBAS
		TOTAL[1,3]+=RA_VLRIMP
		TOTAL[1,4]+=RA_VLRISE
		TOTAL[1,5]+=RA_VLROUT
		dbskip()
	end
	imprstot()
	IMPOSTO[2]:=TOTAL[2,3] // total do imposto
	imprttot()
	for X:=prow() to 60
		?'|      |      |                                    |               |               |               |               |               |'
	end
	?replicate('-',LAR)
	eject
	paginab()
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

static function IMPRSTOT()
	? '|      |      |'
	??padr('Sub-Totais',36,'.')+'|'
	for X:=1 to 5
		??transform(TOTAL[1,X],mD132)+'|'
		TOTAL[2,X]+=TOTAL[1,X]
		TOTAL[1,X]:=0
	next
return NIL

static function IMPRTTOT()
	? '|      |      |'
	??padr('TOTAIS',36,'.')+'|'
	for X:=1 to 5
		??transform(TOTAL[2,X],mD132)+'|'
		TOTAL[2,X]:=0
	next
return NIL

*-----------------------------------------------------------------------------*
static function PAGINAA(P1,P2,P3,P4)
if prow()>60.or.FLAG
	if prow()>60
		eject
	end
	if FLAG2
		?replicate('-',P3)
		?INEGR+padc(P1,P3)+CNEGR
		?replicate('-',P3)
		?padr('Empresa.......: '+VM_EMPR+space(60)+'Folha...: '+pb_zer(P2,3),P3)
		?padr('Inscr Estadual: '+PARAMETRO->PA_INSCR+space(62)+'Mes/Ano.: '+right(PERIOD,2)+'/'+left(PERIOD,4),P3)
		?padr('C.N.P.J.......: '+transform(PARAMETRO->PA_CGC,masc(18))  ,P3)
		P2++
		FLAG2:=.F.
	end
	?replicate('-',P3)
	?padc(P4,P3)// TIPO LIVRO
	?replicate('-',P3)
	if P4=='E N T R A D A S'
		?'|             |                                    |               |           I C M S  -  V A L O R E S   F I S C A I S           |'
		?'|             |           N A T U R E Z A          |               | OPERACOES COM CREDITO IMPOSTO | OPERACOES SEM CREDITO IMPOSTO |'
		?'| Codificacao |                                    |    Valores    |     Base do   |     Imposto   | Isentas ou Nao|               |'
		?'|Contab|Fiscal|                                    |   Contabeis   |     Calculo   |    Creditado  |   Tributadas  |     Outros    |'
	else
		?'|             |                                    |               |           I C M S  -  V A L O R E S   F I S C A I S           |'
		?'|             |           N A T U R E Z A          |               |  OPERACOES COM DEBITO IMPOSTO |  OPERACOES SEM DEBITO IMPOSTO |'
		?'| Codificacao |                                    |    Valores    |     Base do   |     Imposto   | Isentas ou Nao|               |'
		?'|Contab|Fiscal|                                    |   Contabeis   |     Calculo   |     Debitado  |   Tributadas  |     Outros    |'
	end
	?replicate('-',P3)
	FLAG:=.F.
end
return NIL

*-----------------------------------------------------------------------------*
static function PAGINAB()
?replicate('-',LAR)
?INEGR+padc(REL,LAR)+CNEGR
?replicate('-',LAR)
?padr('Empresa.......: '+VM_EMPR+space(60)+'Folha...: '+pb_zer(PAG++,3),LAR)
?padr('Inscr Estadual: '+PARAMETRO->PA_INSCR+space(62)+'Mes/Ano.: '+right(PERIOD,2)+'/'+left(PERIOD,4),LAR)
?padr('C.G.C.........: '+transform(PARAMETRO->PA_CGC,masc(18))  ,LAR)
?replicate('-',LAR)
?
?'     DEBITO DO IMPOSTO'
?
?padr('01 - Por Saidas/Prestacao c/Debito do Imposto',50,'.')+transform(IMPOSTO[2],mD132)
?padr('02 - Outros Debitos'                          ,50,'.')+transform(DADOS[1],mD132)
?padr('03 - Estorno de Creditos'                     ,50,'.')+transform(DADOS[2],mD132)
?padr('04 - T O T A L '                              ,50,'.')+transform(IMPOSTO[2]+DADOS[1]-DADOS[2],mD132)
?
?replicate('-',LAR)
?
?'     CREDITOS DO IMPOSTO'
?
?padr('05 - Por Entradas/Aquisicao c/Credito do Imposto',50,'.')+transform(IMPOSTO[1],mD132)
?padr('06 - Outros Creditos'                            ,50,'.')+transform(DADOS[3],mD132)
?padr('07 - Estorno de Debitos'                         ,50,'.')+transform(DADOS[4],mD132)
?padr('08 - Cred.Ativo Imobilizado'                     ,50,'.')+transform(DADOS[7],mD132)
?padr('09 - Saldo Credor do Periodo Anterior'           ,50,'.')+transform(DADOS[5],mD132)
?padr('10 - T O T A L '                                 ,50,'.')+transform(IMPOSTO[1]+DADOS[3]-DADOS[4]+DADOS[5]+DADOS[7],mD132)
?
?replicate('-',LAR)
?
?'     APURACAO DO SALDO'
?
SALDO:=(IMPOSTO[2]+DADOS[1]-DADOS[2]) - (IMPOSTO[1]+DADOS[3]-DADOS[4]+DADOS[5]+DADOS[7])
?padr('11 - Saldo Devedor (Debito menos Credito)'    ,50,'.')
if SALDO>0
	??transform(SALDO,mD132)
else
	??'---------------'
end
?padr('12 - Deducoes'                                ,50,'.')+transform(DADOS[6],mD132)
?padr('13 - Imposta a Recolher'                      ,50,'.')
SALDO-=DADOS[6]
if SALDO>0
	??transform(SALDO,mD132)
else
	??'---------------'
end
?padr('14 - Saldo Credor p/Periodo Seguinte'         ,50,'.')
if SALDO<=0
	??transform(-SALDO,mD132)
else
	??'---------------'
end
?
?replicate('-',LAR)
?'     INFORMACOES COMPLEMENTARES'
?
?
?
?
?replicate('-',LAR)

return NIL
//-----------------------------------------------------------------EOF------------*
