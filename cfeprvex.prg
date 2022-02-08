*-----------------------------------------------------------------------------*
  static aVariav := {{},'',0,160,0,{},0,'', 0,.F.,'',{},'VEND_EXP.XLS'}
*.....................1..2.3...4.5..6.7..8..9..10.11.12............13
*-----------------------------------------------------------------------------*
#xtranslate nX           => aVariav\[  5 \]
#xtranslate aTotal       => aVariav\[  6 \]
#xtranslate nY           => aVariav\[  7 \]
#xtranslate cArqTmp      => aVariav\[  8 \]
#xtranslate nZ           => aVariav\[  9 \]
#xtranslate lCont        => aVariav\[ 10 \]
#xtranslate RT           => aVariav\[ 11 \]
#xtranslate aGruCli      => aVariav\[ 12 \]
#xtranslate cArqVend     => aVariav\[ 13 \]

*-----------------------------------------------------------------------------*
  function CFEPRVEX() // Gara XLS dos dados de Vendas
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_CPO:={'S','N','N',,,0,0,0,0,3,2}
//        1   2   3  456 7 8 9 0,1
aGruCli   :=restarray('TIPOCLI.ARR')
aPISCOFINS:=AddMatCof()

pb_lin4(_MSG_,ProcName())

if !abre({	'R->PROD',;
				'R->GRUPOS',;
				'R->FISACOF',;
				'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->PEDSVC',;
				'R->ENTCAB',;
				'R->ENTDET',;
				'R->NATOP',;
				'R->ATIVIDAD',;
				'R->DPCLI',;
				'R->HISCLI'})
	return NIL
end

select('DPCLI');dbsetorder(5)	// Dpls Receber
select('PROD');dbsetorder(2)	// Cadastro de Produtos- ORDEM CÓDIGO

VM_CPO[4]:=bom(PARAMETRO->PA_DATA)
VM_CPO[5]:=PARAMETRO->PA_DATA
nArqVend :='C:\TEMP\VEND_EXP.XLS'

pb_box(17,20,,,,'Selecione periodo para Exportar')
@18,22 say 'Data Emissao Inicial.....:' get VM_CPO[4] pict masc(7)
@19,22 say 'Data Emissao Final.......:' get VM_CPO[5] pict masc(7)  valid VM_CPO[5]>=VM_CPO[4]
@21,22 say 'Nome Arq a ser Exportado.: '+nArqVend
read
if if(lastkey()#K_ESC,pb_ligaimp(,nArqVend),.F.)

	?? 'TIPO NF'			+CHR(9)
	?? 'Data'				+CHR(9)
	?? 'Nr Nota'			+CHR(9)
	?? 'Ser'					+CHR(9)
	?? 'Nat.Operacao'		+CHR(9)
	?? 'Grupo Cliente'	+CHR(9)
	?? 'Cliente'			+CHR(9)
	?? 'Grupo Estoque'	+CHR(9)
	?? 'Descr.Produto'	+CHR(9)
	?? 'Unid'				+CHR(9)
	?? 'Tipo Venda'		+CHR(9)
	?? 'Qdade'				+CHR(9)
	?? 'Vlr Medio Unit'	+CHR(9)
	?? 'Vlr Tot Medio'	+CHR(9)
	?? 'Vlr Venda Unit'	+CHR(9)
	?? 'Vlr Tot Venda'	+CHR(9)
	?? 'CodPis/Cofins'	+CHR(9)
	?? 'Vlr PIS'			+CHR(9)
	?? 'Vlr COFINS'
	
//	Exec_Entrada()
	Exec_Saida()
	
	pb_deslimp(,.F.,.F.)
	setprc(01,01)
	alert('Foi criado um arquivo Exel em C:\TEMP;com nome'+nArqVend)
end
dbcloseall()
return NIL

*----------------------------------------------------------------------------*
  static function Exec_Saida(P1)
*----------------------------------------------------------------------------*
select('PEDCAB')
ordem DTENNF
dbseek(dtos(VM_CPO[4]),.T.) // Data Inicial
TOTALG:={0,0,0} // total geral
while !eof().and.PC_DTEMI<=VM_CPO[5]
	if PC_FLAG.and.!PC_FLCAN
		CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
		NATOP->(dbseek(str(PEDCAB->PC_CODOP,7)))
		@24,60 SAY PC_DTEMI
		Exec_Saida_Det()
	end
	pb_brake()
end
return NIL

*----------------------------------------------------------------------------*
  static function Exec_Saida_Det()
*----------------------------------------------------------------------------*
VM_PEDID:=PC_PEDID
select('PEDDET')
dbseek(str(VM_PEDID,6),.T.)
while !eof().and.VM_PEDID==PD_PEDID
	PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
	nX:=trunca(PD_QTDE*PD_VALOR   -PD_DESCV+PD_ENCFI,2)
	?  "Saida  "											 					+CHR(9)
	?? transform(PEDCAB->PC_DTEMI,masc(7))			 					+CHR(9)
	?? pb_zer(PEDCAB->PC_NRNF,6)										 	+CHR(9)
	?? PEDCAB->PC_SERIE					 									+CHR(9)
	?? left(transform(PEDCAB->PC_CODOP,mNAT),5)+;
		"-"+NATOP->NO_DESCR													+CHR(9)
	?? aGruCli[max(CLIENTE->CL_ATIVID,1)][2]							+CHR(9)
	?? pb_zer(PEDCAB->PC_CODCL,5)+'-'+CLIENTE->CL_RAZAO			+CHR(9)
	?? RetGrupo(PROD->PR_CODGR)											+CHR(9)
	?? pb_zer(PEDDET->PD_CODPR,L_P)+'-'+PROD->PR_DESCR				+CHR(9)
	?? PROD->PR_UND															+CHR(9)
	?? "Produtos"																+CHR(9)
	?? transform(PD_QTDE, mD133)											+CHR(9)
	?? transform(pb_divzero(PD_VLRMD,PD_QTDE),mD133)				+CHR(9)
	?? transform(PD_VLRMD,mD82)		 									+CHR(9)	// total do item a valor médio
	?? transform(PD_VALOR,mD133)											+CHR(9)
	?? transform(nX,mD82)				 									+CHR(9)	// total do item a valor de venda
	if NATOP->NO_FLPISC=='S'
		if FISACOF->(dbseek(PROD->PR_CODCOS+CLIENTE->CL_TIPOFJ))
			?? aPISCOFINS[2][val(FISACOF->CO_TIPOIN)]						+CHR(9)	// Tipo PisCofins
			?? transform(trunca(nX*FISACOF->CO_PERC1/100,2), mD112)	+CHR(9)	// Vlr Pis
			?? transform(trunca(nX*FISACOF->CO_PERC2/100,2), mD112)				// Vlr Cofins
		else
			?? "*** PRODUTO NAO CONSTA CADASTRO PIS/COFINS ***"+CHR(9)+'0'+CHR(9)
		end
	else // não calcula PIS x Cofins
		?? ' '	+CHR(9)	// Tipo PisCofins
		?? '0'	+CHR(9)	// Vlr Pis
		?? '0'				// Vlr Cofins		
	end
	dbskip()
end
select('PEDCAB')
return NIL

*----------------------------------------------------------------------------*
  static function RetGrupo(pGrupo) // Retorno Cod+Descricao Grupo
*----------------------------------------------------------------------------*
RT:=''
SALVABANCO
select GRUPOS
if dbseek(str(pGrupo,6))
	RT:=transform(pGrupo,mGRU)+'-'+GRUPOS->GE_DESCR
end
RESTAURABANCO
return RT
*------------------------------------------------------------------EOF-----------*
