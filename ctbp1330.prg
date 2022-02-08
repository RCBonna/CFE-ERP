//-----------------------------------------------------------------------------*
  static aVariav := {{},"","",  0, 0}
//....................1...2..3...4..5..6...7...8...9, 10, 11, 12,13,14,15
//-----------------------------------------------------------------------------*
#xtranslate dIniFim =>	aVariav\[  1 \]
#xtranslate TF =>			aVariav\[  2 \]
#xtranslate cX =>			aVariav\[  3 \]
#xtranslate nX =>			aVariav\[  4 \]
#xtranslate nSaldo =>	aVariav\[  5 \]

*-----------------------------------------------------------------------------*
function CTBP1330()	//	Razao																	*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_lin4('Impress„o do Raz„o Contabil',ProcName())
private VM_MESL:={1,12,0}
private VM_NLPP:=66
private VM_ISPP:='S'
private VM_ATPR:='N'
if !abre({	'R->PARAMCTB',;
				'R->PARAMETRO',;
				'R->RAZAO',;
				'R->CTADET'})
	return NIL
end

dIniFim:={BoM(PARAMETRO->PA_DATA),EoM(PARAMETRO->PA_DATA)} // data de inicio e fim 

dbsetorder(2)
dbgobottom();VM_CONTAF:= CD_CONTA
DbGoTop();   VM_CONTA := CD_CONTA
pb_box(13,15,,,,'Selecione')
@14,16 say 'Formulario 80 Colunas (Compact)'
@15,16 say 'Imprime Saldo por Periodo ? ' get VM_ISPP     picture masc(1)		valid (VM_ISPP$'SN')
//@16,16 say 'Atualizar P ginas Raz„o   ? ' get VM_ATPR     picture masc(1)		valid (VM_ATPR$'SN')
@17,16 say 'Conta Inicial:'               get VM_CONTA    picture MASC_CTB		valid fn_ifcont1(@VM_CONTA)
@18,16 say 'Conta Final..:'               get VM_CONTAF   picture MASC_CTB		valid fn_ifcont1(@VM_CONTAF).and.VM_CONTAF>=VM_CONTA
@20,16 say 'Dt Inicial...:'               get dIniFim[1]  picture mDT
@20,46 say 'Dt Final.....:'               get dIniFim[2]  picture mDT			valid dIniFim[2]>=dIniFim[1]
@21,16 say 'Linhas P/Pag.:'               get VM_NLPP     picture masc(11)		valid VM_NLPP==66.or.VM_NLPP==33 when pb_msg('<66>-Pagina Normal <33>-Meia Pagina')
read
setcolor(VM_CORPAD)
if if(lastkey()#27,pb_ligaimp(chr(15)+chr(27)+'C'+chr(VM_NLPP)),.F.)
	select('RAZAO')
	DbGoTop()
	VM_LAR:=132
	dbseek(VM_CONTA,.T.)
	while !eof().and.RZ_CONTA<=VM_CONTAF
		VM_CONTA  := RZ_CONTA
		dbseek(VM_CONTA+DtoS(dIniFim[1]),.T.) 						// Pegar próximo Registro
		CTADET->(dbseek(VM_CONTA)) 									// Saldo da Conta Contabil
		VM_REL		:= 'Razao da Conta ('+trim(transform(VM_CONTA,MASC_CTB))+'['+pb_zer(CTADET->CD_CTA,4)+']-'+trim(CTADET->CD_DESCR)+')'
		VM_PAG		:= CTADET->CD_PGRAZ 								// Pegar número da última página impressa
		VM_VALOR		:= {0,0}
		VM_SALDO		:= {fn_SaldoConta(month(dIniFim[1])-1),0} // Buscar Saldo da Conta Detalhe (mes anterior)
		VM_SALDO[1]	+=	 fn_SomaMovRazao(VM_CONTA,dIniFim[1])	// Somar valores do Razão até Data
		VM_FLAG		:= {.F.,.F.,.T.} 									// Movimentacao
		VM_MESL[3]	:= month(RZ_DATA)
		if VM_PAG>0
			setprc(VM_NLPP-2,1)
		end
		while !eof().and.RZ_CONTA==VM_CONTA.and.RZ_DATA<=dIniFim[2]
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CTBP1330A',VM_LAR,VM_NLPP)
			if VM_FLAG[3]
				? space(20)+padr('Saldo Incial',95,'.')
				??fn_dbcr(VM_SALDO[1])
				VM_FLAG[3]:=.F.
			end
			if month(RZ_DATA)#VM_MESL[3].and.VM_ISPP=='S'
				CTBP1332() // Imprime saldo por período
			end
			if str(abs(RZ_VALOR),15,2)>str(0,15,2) //..................Existe Valores
				VM_VALOR[if(RZ_VALOR>0,1,2)]+=abs(RZ_VALOR) //..........1-Débito(>0) 2-Crédito(<0)
				VM_SALDO[2]:=VM_SALDO[1]+VM_VALOR[1]*DEB+VM_VALOR[2]*CRE
				? transform(RZ_DATA,mDT)+space(1)
				??pb_zer(RZ_NRLOTE,8)   +space(1)
				??RZ_HISTOR
				??space(if(RZ_VALOR>0,0,15))
				??transform(abs(RZ_VALOR),masc(02))
				??space(if(RZ_VALOR>=0,20,5))
				??fn_dbcr(VM_SALDO[2])
				VM_FLAG[1]:=.T. //.......................................Impresso Lancamentos
			end
			pb_brake()
		end

		if VM_FLAG[1]
			VM_PAG		:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CTBP1330A',VM_LAR,VM_NLPP)
			VM_SALDO[2]	:=VM_SALDO[1]+VM_VALOR[1]*DEB+VM_VALOR[2]*CRE
			? replicate('-',VM_LAR)
			? padr('Saldo Atual em '+DtoC(dIniFim[2]),80,'.')
			??transform(VM_VALOR[1],masc(02))
			??transform(VM_VALOR[2],masc(02))+space(5)
			??fn_dbcr(VM_SALDO[2])
			?replicate('-',VM_LAR)
			?'Impresso as '+Time()
			eject
//			if VM_ATPR=='S'
//				replace CTADET->CD_PGRAZ with VM_PAG
//			end
		end
		dbseek(VM_CONTA+DtoS(dIniFim[2]+1000),.T.) // pegar próxima conta
 	end
	pb_deslimp(chr(18)+chr(27)+'C'+chr(66)+chr(27)+'@')
	set relation to
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
	function CTBP1330A()
*-----------------------------------------------------------------------------*
? padc('Periodo de Relatorio de '+DtoC(dIniFim[1])+' ate '+DtoC(dIniFim[2]),VM_LAR )
? padc('Data',11)+'Nro.Lote'+space(1)
??'Historico'+space(54)
??'Valor Debito'+space(2)+'Valor Credito'+space(11)+'Saldo Atual'
?replicate('-',VM_LAR)
//if VM_FLAG[2]
//	CTBP1331()
//end
//VM_FLAG[2]:=.T.
return NIL

*-----------------------------------------------------------------------------*
//function CTBP1331()
//VM_SALDO[2]:=VM_SALDO[1]+VM_VALOR[1]*DEB+VM_VALOR[2]*CRE
//?space(18)+padr('De Transporte',93)
//??fn_dbcr(VM_SALDO[2])
//?
//VM_FLAG[2]=.F.
//return NIL

*-----------------------------------------------------------------------------*
	function CTBP1332() // Saldo do Período
*-----------------------------------------------------------------------------*
VM_SALDO[2]:=VM_SALDO[1]+VM_VALOR[1]*DEB+VM_VALOR[2]*CRE
?replicate('-',VM_LAR)
? space(18)+padr('S a l d o   d o   P e r i o d o',97)
??fn_dbcr(VM_SALDO[2])
?
VM_MESL[3]:=month(RZ_DATA)
return NIL
//------------------------------------------------EOF-------------------------//
