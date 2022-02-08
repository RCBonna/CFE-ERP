*-----------------------------------------------------------------------------*
 static aVariav := {0,{},'',0}
 //.................1..2..3.4...5..6...7...8...9, 10, 11, 12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate nX				=> aVariav\[  1 \]
#xtranslate aOPC			=> aVariav\[  2 \]
#xtranslate cArq			=> aVariav\[  3 \]
#xtranslate VM_PEDID		=> aVariav\[  4 \]

*-----------------------------------------------------------------------------*
	function CFEPRCUS() // Listagem de Vendas	A Preço de Custos						*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

aOPC:={{},'dt1','dt2',"   " , ,0, ,'T',0,3,2}
//     1   2     3      4    5 6 7  8  9 0,1

VM_REL:='Venda x Custo'

pb_lin4(VM_REL,ProcName())

if !abre({	'R->PROD',;
				'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->HISCLI',;
				'R->NATOP',;
				'R->DPCLI',;
				'R->GRUPOS'})
	return NIL
end
select('PROD')
dbsetorder(2)	// Cadastro de Produtos
DbGoTop()
VM_CPRINI:=PROD->PR_CODPR
DbGoBottom()
VM_CPRFIM:=PROD->PR_CODPR
DbGoTop()

select('PEDCAB')
ORDEM DTEPED
DbGoTop()

VM_TIPO  :=restarray('ESTOQUE.ARR')
aOPC[2]:=bom(PARAMETRO->PA_DATA)
aOPC[3]:=eom(PARAMETRO->PA_DATA)

nX			:=12
pb_box(nX++,20,,,,'Selecione')

@nX++,22 say 'Dt Emissao Incial:' get aOPC[2]		pict mDT
@nX++,22 say 'Dt Emissao Final.:' get aOPC[3]		pict mDT valid aOPC[3]>=aOPC[2]
nX++
@nX++,22 say 'Produto Inicial...:' get VM_CPRINI	pict masc(21) valid fn_codpr(@VM_CPRINI,77)
@nX++,22 say 'Produto Final.....:' get VM_CPRFIM	pict masc(21) valid fn_codpr(@VM_CPRFIM,77).and.VM_CPRFIM>=VM_CPRINI
nX++
@nX++,22 say 'CST-ICMS..........:' get aOPC[4]	pict mUUU when pb_msg('Informe um CST para Filtro ou BRANCO para Todos')

read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	pb_msg('Calculando Notas Fiscais...')
	aOPC[1]	:={0,0,0} // Total Venda * Desconto * Total Custo
	VM_REL	+=' de '+DtoC(aOPC[2])+' ate '+DtoC(aOPC[3])
	cArq		:=ArqTemp(,,'')
	nX			:=0
	dbcreate(cArq,{ ;
						{'RV_DTEMI' ,'D',  8,0},;
						{'RV_NRNF'  ,'N',  9,0},;
						{'RV_SERIE' ,'C',  3,0},;
						{'RV_CODPR' ,'N',L_P,0},;
						{'RV_DESCR' ,'C', 40,0},;
						{'RV_CSTICM','C',  3,0},;
						{'RV_CFOP'  ,'N',  7,0},;
						{'RV_QTVEN' ,'N', 14,3},;
						{'RV_VLVEN' ,'N', 15,2},;	// Total
						{'RV_VLDES' ,'N', 15,2},;	// Total Desconto Item
						{'RV_VLCUS' ,'N', 15,2}})	// Total
	if !net_use(cArq, .T. , ,'RELVENDAS', ,.F.,RDDSETDEFAULT())
		dbcloseall()
		return NIL
	end
	select('RELVENDAS')
	Index on DtoS(RV_DTEMI)+str(RV_NRNF,9)+RV_SERIE tag CODIGO_PROD to (cArq)	//....1

	pb_msg('Imprimindo ESC cancela...')
	CFEPRCUS0() // Acumular Valores
	VM_LAR:=132
	VM_PAG:=0
	DbGoTop()
	while !eof()
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRCUST',VM_LAR)
		CFEPRCUS1()
		dbskip()
	end
	? replicate('-',VM_LAR)
	? Padc('Total',96)
	??transform(aOPC[1][1],masc(02))+Space(1)
//	??transform(aOPC[1][2],masc(02)) // Desconto - Não necessário
	??transform(aOPC[1][3],masc(02))
	?replicate('-',VM_LAR)
	?time()
	eject
	pb_deslimp(C15CPP)
end

dbcloseall()
FileDelete (cArq + '.*')
return NIL

*----------------------------------------------------------------------------*
	static function CFEPRCUS0()
*----------------------------------------------------------------------------*
salvabd(SALVA)
select('PEDCAB')
ORDEM DTEPED
DbGoTop()
dbseek(dtos(aOPC[2]),.T.) // Data Inicial
while !eof().and.PEDCAB->PC_DTEMI<=aOPC[3] // até data final
	if !PEDCAB->PC_FLCAN.and.PEDCAB->PC_FLAG // Não Cancelado e Impressa
		@24,69 say dtoc(PEDCAB->PC_DTEMI)
		VM_PEDID		:=PEDCAB->PC_PEDID
//		aOPC[1][3]	+=PEDCAB->PC_DESC // Soma Desconto
		select('PEDDET')
		dbseek(str(VM_PEDID,6),.T.)
		while !eof().and.PEDDET->PD_PEDID==VM_PEDID
			if PEDDET->PD_CODPR>=VM_CPRINI.and.;//...Valida Produto INI
				PEDDET->PD_CODPR<=VM_CPRFIM.and.;//...Valida Produto FIM
				if(empty(aOPC[4]),.T.,aOPC[4]==PEDDET->PD_CODTR)//....Valida CST da Venda
				PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
				select('RELVENDAS')
				AddRec()
				replace 	;
							RV_DTEMI		with PEDCAB->PC_DTEMI,;
							RV_NRNF		with PEDCAB->PC_NRNF,;
							RV_SERIE		with PEDCAB->PC_SERIE,;
							RV_CODPR		with PEDDET->PD_CODPR,;
							RV_DESCR		with PROD->PR_DESCR,;
							RV_CSTICM	with PEDDET->PD_CODTR,;
							RV_CFOP		with PEDDET->PD_CODOP,;
							RV_QTVEN 	with PEDDET->PD_QTDE,;
							RV_VLVEN 	with Round((PEDDET->PD_QTDE*PEDDET->PD_VALOR)-PEDDET->PD_DESCV,2),;
							RV_VLDES 	with PEDDET->PD_DESCV,;
							RV_VLCUS		with PEDDET->PD_VLRMD
			end
			select('PEDDET')
			dbskip()
		end
		select('PEDCAB')
	end
	dbskip()
end
salvabd(RESTAURA)
return NIL

*-----------------------------------------------------------------------------*
 static function CFEPRCUS1(P1)
*-----------------------------------------------------------------------------*
? DtoC(RV_DTEMI)+Space(1)
?? str(RV_NRNF)+'/'
?? RV_SERIE+Space(1)
?? padl(transform(RV_CODPR,masc(21))+'-'+RV_DESCR,48)+Space(1)
?? RV_CSTICM+Space(1)
?? left(str(RV_CFOP,7),4)+Space(1)
?? transform(RV_QTVEN,masc(05))+Space(1)
?? transform(RV_VLVEN,masc(02))+Space(1)
//?? transform(RV_VLDES,masc(02)) // Desconto não necessário
?? transform(RV_VLCUS,masc(02))
aOPC[1][1]	+=RV_VLVEN
aOPC[1][2]	+=RV_VLDES
aOPC[1][3]	+=RV_VLCUS
nX++
return NIL

*-----------------------------------------------------------------------------*
 function CFEPRCUST()
*-----------------------------------------------------------------------------*
?'Dt Emissao   Nro NFe Ser   Produto'+Space(40)+'CST CFOP    Quantidad     Total Venda     Total Custo'
?replicate('-',VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
