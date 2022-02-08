//-----------------------------------------------------------------------------*
  static aVariav := {{},'',0,160,0,{},0,'', 0,.F.,"",{}}
//....................1..2.3...4..5..6.7.8..9.10..11.12
//-----------------------------------------------------------------------------*
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
#xtranslate aLotes       => aVariav\[ 12 \]

//-----------------------------------------------------------------------------*
  function LOTEALOJ(P1) // Impressao
//-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_CPO:={'S','N','N',,,0,0,0,0,3,2}
//        1   2   3  456 7 8 9 0,1

cArqTmp   :="C:\TEMP\LOTEALOJ.XLS"

pb_lin4(VM_REL,ProcName())

if file( cArqTmp )
	nZ:=fOpen(cArqTmp,2)//leitura + Gravação
	if (nX:=fError())>0
		fClose(nZ)
		alert('Planilha em USO;Codigo Erro='+str(nX))
		return NIL
	end
	fClose(nZ)
end

aPISCOFINS:=AddMatCof()

if !abre({	'R->PROD',;
				'R->GRUPOS',;
				'R->FISACOF',;
				'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->PEDSVC',;
				'R->NATOP',;
				'R->ATIVIDAD',;
				'R->DPCLI',;
				'R->LOTEPAR',;
				'R->HISCLI'})
	return NIL
end

select('DPCLI');dbsetorder(5)	// Dpls Receber
select('PROD');dbsetorder(2)	// Cadastro de Produtos

VM_CPO[4]:=bom(PARAMETRO->PA_DATA)
VM_CPO[5]:=PARAMETRO->PA_DATA
pb_box(17,20,,,,'Selecione')
@18,22 say '[A]bertos  [S]o Fechados ?' get VM_CPO[1] pict mUUU  valid VM_CPO[1]$'AS'
@20,22 say 'Data Emissao Inicial.....:' get VM_CPO[4] pict mDT
@21,22 say 'Data Emissao Final.......:' get VM_CPO[5] pict mDT  valid VM_CPO[5]>=VM_CPO[4]
read
if if(lastkey()#K_ESC,pb_ligaimp(,cArqTmp),.F.)

	?? "Data"			+CHR(9)
	?? "Nr Nota"		+CHR(9)
	?? "Ser"				+CHR(9)
	?? "Lote"         +CHR(9)
	?? "Cliente"		+CHR(9)
	?? "Grupo Estoque"+CHR(9)
	?? "Produto"		+CHR(9)
	?? "Qtdade"			+CHR(9)
	?? "Vlr NF"			+CHR(9)
	?? "Dt Fecham"    +CHR(9)
	?? "Tipo Mov"		+CHR(9)
	?? "Sit Lote"		+CHR(9)
	
	select('PEDCAB')
	ordem DTENNF
	dbseek(dtos(VM_CPO[4]),.T.) // Data Inicial
	if VM_CPO[1]=='A'//......................................Só Abertos
		while !eof().and.PC_DTEMI<=VM_CPO[5]
			if PC_FLAG.and.PC_LOTE>0.and.!PC_FLCAN
				LOTEPAR->(dbseek(str(PEDCAB->PC_CODCL,5)+str(PEDCAB->PC_LOTE,4)))
				if empty(LOTEPAR->LP_DTFECH) //.................Só Abertos
					CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
					NATOP->(dbseek(str(PEDCAB->PC_CODOP,7)))
					pb_msg('Gerando Todos lotes abertos '+dtoc(PC_DTEMI))
					LOTEALOJ1(VM_CPO[1])
				end
			end
			pb_brake()
		end
	else
		//.....................................calcular lotes Fechados
		aLotes   :={{-1,-1}}
		dbseek(dtos(VM_CPO[4]),.T.) // Data Inicial
		while !eof().and.PC_DTEMI<=VM_CPO[5]
			if PC_FLAG.and.PC_LOTE>0.and.!PC_FLCAN
				LOTEPAR->(dbseek(str(PEDCAB->PC_CODCL,5)+str(PEDCAB->PC_LOTE,4)))
				if !empty(LOTEPAR->LP_DTFECH)//...........................Fechado ?
					aadd(aLotes,{PEDCAB->PC_CODCL,PEDCAB->PC_LOTE})//......Numero de Lote Fechado
					pb_msg('Calculando Lotes Fechados'+dtoc(PC_DTEMI))
				end
			end
			pb_brake()
		end
		//.....................................Iniciar Impressao
		dbseek(dtos(VM_CPO[4]-200),.T.) // Data Inicial - 200 dias para ter certeza que fecha
		while !eof().and.PC_DTEMI<=VM_CPO[5]
			if PC_FLAG.and.PC_LOTE>0.and.!PC_FLCAN
				nX:=ascan(aLotes,{|DET|DET[1]==PEDCAB->PC_CODCL.and.DET[2]==PEDCAB->PC_LOTE})
				if nX>0 //................................Já esta fechado para estes produtor
					CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
					NATOP->(dbseek(str(PEDCAB->PC_CODOP,7)))
					pb_msg('Gerando NF dos Lotes Fechados '+dtoc(PC_DTEMI))
					LOTEALOJ1(VM_CPO[1])
				end
			end
			pb_brake()
		end	
	end

	pb_deslimp(,.F.,.F.)
	setprc(01,01)
	alert('Foi criado um arquivo Excel em C:\TEMP;com nome LOTEALOJ.XLS')
end
dbcloseall()
return NIL

*----------------------------------------------------------------------------*
  static function LOTEALOJ1(pTipoGeracao)
*----------------------------------------------------------------------------*
VM_PEDID:=PC_PEDID
select('PEDDET')
dbseek(str(VM_PEDID,6),.T.)
while !eof().and.VM_PEDID==PD_PEDID
	PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
	nX:=(PD_QTDE*PD_VALOR-PD_DESCV+PD_ENCFI)
	?  transform(PEDCAB->PC_DTEMI,masc(7))			 					+CHR(9)
	?? pb_zer(PEDCAB->PC_NRNF,6)										 	+CHR(9)
	?? PEDCAB->PC_SERIE					 									+CHR(9)
	?? str(PEDCAB->PC_LOTE,4)												+CHR(9)
	?? str(PEDCAB->PC_CODCL,5)+'-'+CLIENTE->CL_RAZAO				+CHR(9)
	?? RetGrupo(PROD->PR_CODGR)											+CHR(9)
	?? str(PEDDET->PD_CODPR,L_P)+'-'+PROD->PR_DESCR					+CHR(9)
	?? str(PD_QTDE,15,3)														+CHR(9)
	?? transform(nX,mD82)				 									+CHR(9)
	?? transform(LOTEPAR->LP_DTFECH,masc(7))							+CHR(9)
	?? 'Saida'                                                  +CHR(9)
	if pTipoGeracao == 'A'
		?? 'Lotes Abertos'                                       +CHR(9)
	else
		?? 'Lotes Fechados'                                      +CHR(9)	
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
