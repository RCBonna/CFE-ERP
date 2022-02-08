*-----------------------------------------------------------------------------*
  static aVariav := {{},'',0,160,0,{},0,'', 0,.F.,'',{},'C:\TEMP\PISCOFIS.XLS'}
*.....................1..2.3...4.5..6.7..8..9..10.11.12.............13
*-----------------------------------------------------------------------------*
#xtranslate aPISCOFINS   => aVariav\[  1 \]
#xtranslate VM_REL       => aVariav\[  2 \]
#xtranslate VM_PAG       => aVariav\[  3 \]
#xtranslate VM_LAR       => aVariav\[  4 \]
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
  function FISPCOFR(P1) // Impressao - pis/cofins
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_CPO:={'S','N','N',,,0,0,0,0,3,2}
//        1   2   3  456 7 8 9 0,1

aPISCOFINS:=AddMatCof()

aGruCli   :=restarray('TIPOCLI.ARR')

pb_lin4(VM_REL,ProcName())

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
cArqVend :='C:\TEMP\PISCOFIS.XLS'

pb_box(17,20,,,,'Selecione Periodo a Exportar')
@18,22 say 'Data Emissao Inicial...:' get VM_CPO[4] pict masc(7)
@19,22 say 'Data Emissao Final.....:' get VM_CPO[5] pict masc(7)  valid VM_CPO[5]>=VM_CPO[4]
@21,22 say 'Nome Arquivo a Exportar: '+cArqVend
read
if if(lastkey()#K_ESC,pb_ligaimp(,cArqVend),.F.)

	?? "TIPO NF"			+CHR(9)
	?? "Data"				+CHR(9)
	?? "Nr Nota"			+CHR(9)
	?? "Ser"					+CHR(9)
	?? "Nat.Operacao"		+CHR(9)
	?? "Grupo Cliente"	+CHR(9)
	?? "Cliente"			+CHR(9)
	?? "Grupo Estoque"	+CHR(9)
	?? "Produto"			+CHR(9)
	?? "Tipo Venda"		+CHR(9)
	?? "Vlr NF"				+CHR(9)
	?? "CodPis/Cofins"	+CHR(9)
	?? "Vlr PIS"			+CHR(9)
	?? "Vlr COFINS"		+CHR(9)
	
	Exec_Entrada()
	Exec_Saida()
	
	pb_deslimp(,.F.,.F.)
	setprc(01,01)
	alert('Foi criado um arquivo Exel em C:\TEMP;com nome '+cArqVend)
end
dbcloseall()
return NIL

*----------------------------------------------------------------------------*
  static function Exec_Entrada(P1)
*----------------------------------------------------------------------------*
select('ENTCAB')
dbsetorder(2)	// Entrada Cabec
dbseek(dtos(VM_CPO[4]),.T.)
while !eof().and.ENTCAB->EC_DTENT<=VM_CPO[5]
	CLIENTE->(dbseek(str(ENTCAB->EC_CODFO,5)))
	NATOP->(dbseek(str(ENTCAB->EC_CODOP,7)))
	@24,60 SAY EC_DTEMI
	if NATOP->NO_FLPISC=='S' // Considerar PIS+CONFIS
		FISPCOFR0(P1)
	end
	pb_brake()
end
return NIL 
//----------------------------------------------------------------------------*
  static function FISPCOFR0(P1) // entradas
//----------------------------------------------------------------------------*
VM_PEDID:=ENTCAB->EC_DOCTO
VM_CODFO:=ENTCAB->EC_CODFO
select ENTDET
dbseek(str(VM_PEDID,8),.T.)
while !eof().and.VM_PEDID==ED_DOCTO
	if ED_CODFO==VM_CODFO
		PROD->(dbseek(str(ENTDET->ED_CODPR,L_P)))
		//nX:=ENTCAB->EC_TOTAL-ENTCAB->EC_DESC+ENTCAB->EC_ACESS
		nX:=ED_VALOR
		?  "Entrada"											 					+CHR(9)
		?? transform(ENTCAB->EC_DTENT,masc(7))			 					+CHR(9)
		?? pb_zer(ENTDET->ED_DOCTO,8)										 	+CHR(9)
		?? ENTCAB->EC_SERIE					 									+CHR(9)
		?? left(transform(ENTCAB->EC_CODOP,mNAT),5)+;
		"-"+NATOP->NO_DESCR														+CHR(9)
		?? aGruCli[max(CLIENTE->CL_ATIVID,1)][2]							+CHR(9)
		?? pb_zer(ENTCAB->EC_CODFO,5)+'-'+CLIENTE->CL_RAZAO			+CHR(9)
		?? RetGrupo(PROD->PR_CODGR)											+CHR(9)
		?? pb_zer(ENTDET->ED_CODPR,L_P)+'-'+PROD->PR_DESCR				+CHR(9)
		?? "Produtos"																+CHR(9)
		?? transform(nX,mD82)				 									+CHR(9)
		if FISACOF->(dbseek(PROD->PR_CODCOS+CLIENTE->CL_TIPOFJ))
//		alert("Codigo Pis/Cof"+str(FISACOF->CO_TIPOIN,2))
			?? aPISCOFINS[2][val(FISACOF->CO_TIPOIN)]						+CHR(9)	// Tipo PisCofins
			?? transform(trunca(nX*FISACOF->CO_PERC1/100,2), mD112)	+CHR(9)	// Pis
			?? transform(trunca(nX*FISACOF->CO_PERC2/100,2), mD112)				// Cofins
		else
			?? "*** PRODUTO NAO CONSTA CADASTRO PIS/COFINS ***"+CHR(9)+'0'+CHR(9)
		end
	end
	pb_brake()
end
select ENTCAB
return NIL


//----------------------------------------------------------------------------*
  static function Exec_Saida(P1)
//----------------------------------------------------------------------------*
select('PEDCAB')
ordem DTENNF
dbseek(dtos(VM_CPO[4]),.T.) // Data Inicial
TOTALG:={0,0,0} // total geral
while !eof().and.PC_DTEMI<=VM_CPO[5]
	if PC_FLAG
		if !PC_FLCAN
			CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
			NATOP->(dbseek(str(PEDCAB->PC_CODOP,7)))
			@24,60 SAY PC_DTEMI
			if NATOP->NO_FLPISC=='S' // Considerar PIS+CONFIS
				if !PC_FLSVC
					FISPCOFR1(P1)
				else
					FISPCOFR2(P1)
				end
			end
		end
	end
	pb_brake()
end
return NIL

//----------------------------------------------------------------------------*
  static function FISPCOFR1(P1)
//----------------------------------------------------------------------------*
VM_PEDID:=PC_PEDID
select('PEDDET')
dbseek(str(VM_PEDID,6),.T.)
while !eof().and.VM_PEDID==PD_PEDID
	PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
	nX:=(PD_QTDE*PD_VALOR-PD_DESCV+PD_ENCFI)
	?  "Saida  "											 					+CHR(9)
	?? transform(PEDCAB->PC_DTEMI,masc(7))			 					+CHR(9)
	?? pb_zer(PEDCAB->PC_NRNF,6)										 	+CHR(9)
	?? PEDCAB->PC_SERIE					 									+CHR(9)
	?? left(transform(PEDCAB->PC_CODOP,mNAT),5)+;
		"-"+NATOP->NO_DESCR													+CHR(9)
	?? aGruCli[max(CLIENTE->CL_ATIVID,1)][2]							+CHR(9)
	?? str(PEDCAB->PC_CODCL,5)+'-'+CLIENTE->CL_RAZAO				+CHR(9)
	?? RetGrupo(PROD->PR_CODGR)											+CHR(9)
	?? str(PEDDET->PD_CODPR,L_P)+'-'+PROD->PR_DESCR					+CHR(9)
	?? "Produtos"																+CHR(9)
	?? transform(nX,mD82)				 									+CHR(9)
	if FISACOF->(dbseek(PROD->PR_CODCOS+CLIENTE->CL_TIPOFJ))
//		alert("Codigo Pis/Cof"+str(FISACOF->CO_TIPOIN,2))
		?? aPISCOFINS[2][val(FISACOF->CO_TIPOIN)]						+CHR(9)	// Tipo PisCofins
		?? transform(trunca(nX*FISACOF->CO_PERC1/100,2), mD112)	+CHR(9)	// Vlr Pis
		?? transform(trunca(nX*FISACOF->CO_PERC2/100,2), mD112)				// Vlr Cofins
	else
		?? "*** PRODUTO NAO CONSTA CADASTRO PIS/COFINS ***"+CHR(9)+'0'+CHR(9)
	end
	dbskip()
end
select('PEDCAB')
return NIL

//----------------------------------------------------------------------------*
  static function FISPCOFR2(P1) // Servico
//----------------------------------------------------------------------------*
VM_PEDID:=PEDCAB->PC_PEDID
select('PEDSVC')
dbseek(str(VM_PEDID,6),.T.)
while !eof().and.VM_PEDID=PS_PEDID
	ATIVIDAD->(dbseek(str(PEDSVC->PS_CODSVC,2)))
	nX:=(PS_QTDE*PS_VALOR-PS_DESCV+PS_ENCFI)
	?  "Saida  "											 		+CHR(9)
	?? transform(PEDCAB->PC_DTEMI,masc(7))				 	+CHR(9)
	?? pb_zer(PEDCAB->PC_NRNF,6)							 	+CHR(9)
	?? PEDCAB->PC_SERIE											+CHR(9)
	?? aGruCli[max(CLIENTE->CL_ATIVID,1),2]				+CHR(9)
	?? str(PEDCAB->PC_CODCL,5)+'-'+CLIENTE->CL_RAZAO	+CHR(9)
	?? "X.XXX-SERVICOS"										+CHR(9)
	?? str(PEDDET->PD_CODPR,L_P)+'-'+ATIVIDAD->AT_DESCR+CHR(9)
	?? "Servico"													+CHR(9)
	?? transform(nX,mD82)				 						+CHR(9)

	if FISACOF->(dbseek(ATIVIDAD->AT_CODCOS+CLIENTE->CL_TIPOFJ))
		?? aPISCOFINS[2][val(FISACOF->CO_TIPOIN)]						+CHR(9) // Tipo PisCofins
		?? transform(trunca(nX*FISACOF->CO_PERC1/100,2), mD112)	+CHR(9) // pis
		?? transform(trunca(nX*FISACOF->CO_PERC2/100,2), mD112)			  // Cofins
	else
		?? "<*** PRODUTO NAO CONSTA DA LISTA DE PIS/COFINS ***>"+CHR(9)+'0'+CHR(9)+"0"
	end
	dbskip()
end
select('PEDCAB')
return NIL

//----------------------------------------------------------------------------*
  static function RetGrupo(pGrupo) // Retorno Cod+Descricao Grupo
//----------------------------------------------------------------------------*
RT:=""
SALVABANCO
select GRUPOS
if dbseek(str(pGrupo,6))
	RT:=transform(pGrupo,mGRU)+'-'+GRUPOS->GE_DESCR
end
RESTAURABANCO
Return RT
*------------------------------------------------------------------EOF-----------*
