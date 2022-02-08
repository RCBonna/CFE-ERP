*-----------------------------------------------------------------------------*
 static aVariav := {0,0,0,'',''}
 //.................1.2.3,4
*---------------------------------------------------------------------------------------*
#xtranslate nTotal    => aVariav\[  1 \]
#xtranslate dDt       => aVariav\[  2 \]
#xtranslate nX        => aVariav\[  3 \]
#xtranslate _CMDOS    => aVariav\[  4 \]

*-----------------------------------------------------------------------------*
function CTBP1240()	//	Visualizar Movimentacao de Contas							*
*								Roberto Carlos Bonanomi - Jul/93								*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
pb_tela()
pb_lin4("Movimenta‡„o - Rever Raz„o",ProcName())
if !abre({	'R->PARAMCTB',;
				'R->CTADET',;
				'C->RAZAO'})
	return NIL
end
select('CTADET')
dbsetorder(2)
select('RAZAO')
set relation to RZ_CONTA into CTADET
DbGoTop()

pb_dbedit1('CTBP124','Pesqu.ListaMListaDImLoteExclui')  && tela
declare VM_CAMPO[fcount()+1]
afields(VM_CAMPO)
ains(VM_CAMPO,2)
VM_CAMPO[2]:="left(CTADET->CD_DESCR,23)"
VM_CAMPO[5]:="FN_DBCR(RZ_VALOR)"

VM_MUSC:={MASC_CTB,               mXXX,      mDT, mI8,      mXXX,   mXXX,mXXX}
VM_CABE:={"Conta","Descri‡„o da Conta","D a t a","Nr.Lote","Valor","Hist¢rico","Docum.Orig"}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",VM_MUSC,VM_CABE)
set relation to
dbcloseall()
return NIL
*-------------------------------------------------------------------------* Fim
function CTBP1241() && Seleciona Conta Contabil
*-----------------------------------------------------------------------------*
local VM_CTA:=0
local VM_CONTA:=RZ_CONTA
pb_box(20,18)
@21,20 say "Conta..:" get VM_CONTA picture MASC_CTB
read
setcolor(VM_CORPAD)
if lastkey()#27
	dbseek(VM_CONTA,.T.)
end
return NIL

*-----------------------------------------------------------------------------*
function CTBP1242() && Rotina de Impress„o
*-----------------------------------------------------------------------------*
local VM_CONTA:=RZ_CONTA,VM_CONTAF:=RZ_CONTA,VM_CTA,VM_CTAF,VM_MESI:=1,VM_MESF:=12,VM_NLPP:=66
select('CTADET')
dbseek(VM_CONTA)
VM_CTA :=CD_CTA
VM_CTAF:=CD_CTA
nTotal:={0,0}
select('RAZAO')
pb_box(16,15,,,,'Sele‡Æo')
@17,16 say "Conta Inicial:" get VM_CONTA  picture VM_MUSC[1] valid fn_ifcont1(@VM_CONTA,@VM_CTA)
@18,16 say "Conta Final..:" get VM_CONTAF picture VM_MUSC[1] valid fn_ifcont1(@VM_CONTAF,@VM_CTAF).and.VM_CONTAF>=VM_CONTA
@19,16 say "Mes Inicial..:" get VM_MESI   picture mI2 valid fn_mes(VM_MESI,"C")
@20,16 say "Mes Final....:" get VM_MESF   picture mI2 valid fn_mes(VM_MESF,"C").and.VM_MESF>=VM_MESI
@21,16 say "Linhas.p/Pag.:" get VM_NLPP   picture mI2 valid VM_NLPP==66.or.VM_NLPP==33
read
setcolor(VM_CORPAD)
if if(lastkey()#27,pb_ligaimp(chr(15)+chr(27)+"C"+chr(VM_NLPP)),.f.)
	VM_LAR := 132
	DbGoTop()
	dbseek(VM_CONTA,.T.)
	while !eof().and.RZ_CONTA<=VM_CONTAF
		VM_CONTA := RZ_CONTA
		dbseek(VM_CONTA+dtos(ctod("01/"+pb_zer(VM_MESI,2)+"/"+substr(str(PARAMCTB->PA_ANO,4),3,2))),.T.)
		VM_REL   := "Razao Conferencia Conta ("+transform(VM_CONTA, VM_MUSC[1])+"-"+trim(CTADET->CD_DESCR)+")"
		VM_PAG   := 0
		VM_VALOR :={fn_SaldoConta(VM_MESI-1),fn_SaldoConta(VM_MESF),0, 0}
		//................................................TC TC
		VM_F     := .F. && ----> Movimentacao
		
		while !eof().and.VM_CONTA==RZ_CONTA.and.month(RZ_DATA)<=VM_MESF
			VM_PAG := pb_pagina(VM_SISTEMA, VM_EMPR, ProcName(), VM_REL, VM_PAG, "CTBP1242A", VM_LAR, VM_NLPP)
			? transform(RZ_DATA,mDT)+space(1)+pb_zer(RZ_NRLOTE,8)+space(1)
			??RZ_HISTOR
			??space(if(RZ_VALOR>0,9,33))+transform(abs(RZ_VALOR),masc(22))
			VM_VALOR[if(RZ_VALOR>0,3,4)]=VM_VALOR[if(RZ_VALOR>0,3,4)]+abs(RZ_VALOR)
			VM_F :=.T.
			pb_brake()
		end
		if VM_F
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,"CTBP1242A",VM_LAR,VM_NLPP)
			? replicate("-",VM_LAR)
			? space(20)+"T o t a l    d a    C o n t a"
			??space(40)+transform(VM_VALOR[3],masc(22))
			??space(06)+transform(VM_VALOR[4],masc(22))
			? replicate("-",VM_LAR)
			? space(80)+"Saldo Anterior ......:"+fn_dbcr(VM_VALOR[1])
			? space(80)+"Valor Movimentado....:"+fn_dbcr(VM_VALOR[3]-VM_VALOR[4])
			? space(80)+"Saldo Atual  "+pb_mesext(VM_MESF)+"/"+str(PARAMCTB->PA_ANO,4)+":"
			nTotal[1]+=VM_VALOR[3]//Debito geral
			nTotal[2]+=VM_VALOR[4]//Credito geral
			??fn_dbcr(VM_VALOR[2])
			?replicate("-",VM_LAR)
			?"Impresso as "+time()
			eject
		end
 	end
		if str(nTotal[1]+nTotal[2],15,2)#str(0,15,2)
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,"CTBP1242A",VM_LAR,VM_NLPP)
			? replicate("-",VM_LAR)
			? space(20)+"T o t a l    G E R A L"
			??space(47)+transform(nTotal[1],masc(22))
			??space(06)+transform(nTotal[2],masc(22))
			? replicate("-",VM_LAR)
			?replicate("-",VM_LAR)
			?"Impresso as "+time()
			eject
		end
	pb_deslimp(chr(18)+chr(27)+"C"+chr(66))
end
DbGoTop()
return NIL

*-----------------------------------------------------------------------------*
function CTBP1242A()
*-----------------------------------------------------------------------------*
?padr(VM_CABE[3],12)+padr(VM_CABE[4],7)+' '+padr(VM_CABE[6],70)+"Valor Lcto Debito"+space(6)+"Valor Lcto Credito"
?replicate("-",VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
function CTBP1243() && Rotina de Impress„o Razao Di rio
*-----------------------------------------------------------------------------*
local VM_CONTA:=RZ_CONTA,VM_CONTAF:=RZ_CONTA,VM_CTA,VM_CTAF,VM_MESI:=1,VM_MESF:=12,VM_NLPP:=66
local VM_DATA :={bom(date()),eom(date())}
select('CTADET')
dbseek(VM_CONTA)
VM_CTA :=CD_CTA
VM_CTAF:=CD_CTA
nTotal :={0,0}
select('RAZAO')
pb_box(16,15,,,,'Sele‡Æo')
@17,16 say "Conta Inicial:" get VM_CONTA   pict VM_MUSC[1] valid fn_ifcont1(@VM_CONTA,@VM_CTA)
@18,16 say "Conta Final..:" get VM_CONTAF  pict VM_MUSC[1] valid fn_ifcont1(@VM_CONTAF,@VM_CTAF).and.VM_CONTAF>=VM_CONTA
@19,16 say "Data Inicial.:" get VM_DATA[1] pict mDT
@20,16 say "Data Final...:" get VM_DATA[2] pict mDT valid VM_DATA[1]<=VM_DATA[2]
@21,16 say "Linhas.p/Pag.:" get VM_NLPP    pict mI2 valid VM_NLPP==66.or.VM_NLPP==33
@21,45 say "33/66"
read
setcolor(VM_CORPAD)
if if(lastkey()#27,pb_ligaimp(chr(15)+chr(27)+"C"+chr(VM_NLPP)),.f.)
	VM_LAR := 132
	nTotal:={0,0}
	DbGoTop()
	dbseek(VM_CONTA,.T.)
	while !eof().and.RZ_CONTA<=VM_CONTAF
		VM_CONTA:= RZ_CONTA
		VM_MESI := month(VM_DATA[1])
		VM_MESF := month(VM_DATA[2])
		VM_REL  := "Razao Conferencia Conta ("+transform(VM_CONTA, VM_MUSC[1])+"-"+trim(CTADET->CD_DESCR)+")"
		VM_PAG  := 0
		VM_VALOR:={fn_SaldoConta(VM_MESI-1),fn_SaldoConta(VM_MESF),0,0}
		VM_F    := .F. //----> Movimentacao
		dbseek(VM_CONTA+dtos(ctod("01/"+pb_zer(VM_MESI,2)+"/"+substr(str(PARAMCTB->PA_ANO,4),3,2))),.T.)
		
		while !eof().and.VM_CONTA==RZ_CONTA.and.RZ_DATA<=VM_DATA[2]
			VM_VALOR[if(RZ_VALOR>0,3,4)]=VM_VALOR[if(RZ_VALOR>0,3,4)]+abs(RZ_VALOR)
			if RZ_DATA>=VM_DATA[1].and.RZ_DATA<=VM_DATA[2]
				VM_PAG:= pb_pagina(VM_SISTEMA, VM_EMPR, ProcName(), VM_REL, VM_PAG, "CTBP1243A", VM_LAR, VM_NLPP)
				? transform(RZ_DATA,mDT)+space(1)
				??pb_zer(RZ_NRLOTE,8)+space(1)
				??RZ_HISTOR
				??space(if(RZ_VALOR>0,9,33))+transform(abs(RZ_VALOR),masc(22))
				VM_F:=.T.
			end
			pb_brake()
		end
		if VM_F
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,"CTBP1243A",VM_LAR,VM_NLPP)
			? replicate("-",VM_LAR)
			? space(20)+"T o t a l    d a    C o n t a"
			??space(40)+transform(VM_VALOR[3],masc(22))
			??space(06)+transform(VM_VALOR[4],masc(22))
			? replicate("-",VM_LAR)
			? space(80)+"Saldo Anterior ......:"+fn_dbcr(VM_VALOR[1])
			? space(80)+"Valor Movimentado....:"+fn_dbcr(VM_VALOR[3]-VM_VALOR[4])
			? space(80)+"Saldo Atual  "+pb_mesext(VM_MESF)+"/"+str(PARAMCTB->PA_ANO,4)+":"
			??fn_dbcr(VM_VALOR[2])
			nTotal[1]+=VM_VALOR[3]//Debito geral
			nTotal[2]+=VM_VALOR[4]//Credito geral
			?replicate("-",VM_LAR)
			?"Impresso as "+time()
			eject
		end
		if !eof()
			dbseek(VM_CONTA+'9999',.T.)
		end
 	end
		if str(nTotal[1]+nTotal[2],15,2)#str(0,15,2)
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,"CTBP1242A",VM_LAR,VM_NLPP)
			? replicate("-",VM_LAR)
			? space(20)+"T o t a l    G E R A L"
			??space(47)+transform(nTotal[1],masc(22))
			??space(06)+transform(nTotal[2],masc(22))
			? replicate("-",VM_LAR)
			?replicate("-",VM_LAR)
			?"Impresso as "+time()
			eject
		end
	pb_deslimp(chr(18)+chr(27)+"C"+chr(66))
end
DbGoTop()
return NIL

*-----------------------------------------------------------------------------*
function CTBP1243A()
*-----------------------------------------------------------------------------*
?padr(VM_CABE[3],12)+padr(VM_CABE[4],7)+' '+padr(VM_CABE[6],70)+"Valor Lcto Debito"+space(6)+"Valor Lcto Credito"
?replicate("-",VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
function CTBP1244() // Lista totais dos Lotes
*-----------------------------------------------------------------------------*
dDt:={bom(date()),eom(date())}
nX :=17
pb_box(nX++,15,,,,'Sele‡Æo Gerar-Arquivo')
nX++
@nX++,16 say "Data Inicial.:" get dDt[1] pict mDT
@nX++,16 say "Data Final...:" get dDt[2] pict mDT valid dDt[1]<=dDt[2]
read
_CMDOS:="C:\TEMP\LOTE.XLS"
if if(lastkey()#K_ESC,pb_ligaimp(,_CMDOS),.F.)
	?? "Conta"			+CHR(9)
	?? "Seq"				+CHR(9)
	?? "Data"			+CHR(9)
	?? "Nr Lote"		+CHR(9)
	?? "Valor"			+CHR(9)
	?? "D/C"				+CHR(9)
	?? "Historico"    +CHR(9)
	?? "DesDoct"		+CHR(9)

	select('RAZAO')
	ordem DTLOTE
	dbseek(dtos(dDt[1]),.T.) // Data Inicial
	nX:=1
	while !eof().and.dtos(RZ_DATA)<=dtos(dDt[2])
		? "'"+RZ_CONTA                             + CHR(9)
		??str(nX++,5)                              + CHR(9)
		??dtoc(RZ_DATA)                            + CHR(9)
		??str(RZ_NRLOTE,8)                         + CHR(9)
		??strtran(str(RZ_VALOR,15,2),'.',',')		 + CHR(9)
		??if(RZ_VALOR>0,'D','C')                   + CHR(9)
		??strtran(RZ_HISTOR,CHR(9),'')             + CHR(9)
		??strtran(RZ_DOCTO,CHR(9),'')              + CHR(9)
		@24,70 SAY dtoc(RZ_DATA)
		skip
	end
	pb_deslimp(,.F.,.F.)
	setprc(01,01)
	alert('Foi criado um arquivo Exel em C:\TEMP;com nome LOTE.XLS')
//	_CMDOS:="EXC1.BAT "+_CMDOS
//	ALERT(_CMDOS)
//	swpruncmd(_CMDOS,0,'','')
//	RUN &_CMDOS
end
return NIL

*-----------------------------------------------------------------------------*
function CTBP1245() // Excluir Lancamentos
*-----------------------------------------------------------------------------*
local VM_DATA :={ctod(''),ctod('')}
pb_box(17,15,,,,'Sele‡Æo para Exclusao')
@19,16 say "Data Inicial.:" get VM_DATA[1] pict mDT
@20,16 say "Data Final...:" get VM_DATA[2] pict mDT valid VM_DATA[1]<=VM_DATA[2]
read
setcolor(VM_CORPAD)
if if(lastkey()#27,pb_sn('Excluir Periodo Citado'),.f.)
	ORDEM DTLOTE
	DbGoTop()
	dbseek(dtos(VM_DATA[1]),.T.)
	while !eof().and.RZ_DATA<=VM_DATA[2]
		pb_msg('Excluindo... Data '+dtoc(RZ_DATA))
		if reclock()
			delete
			dbrunlock(recno())
		end
		skip
	end
	ORDEM CONTADT
end
return NIL
