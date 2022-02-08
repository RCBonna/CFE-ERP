  static aVariav := {{}, 0,{},.F.,'','',.T.}
//......................................................1..2..3..4..5..6...7...8...9, 10, 11, 12,13,14,15
//-----------------------------------------------------------------------------*
#xtranslate VM_REL    => aVariav\[  1 \]
#xtranslate nX        => aVariav\[  2 \]
#xtranslate VM_CPO    => aVariav\[  3 \]
#xtranslate VM_TOTAL  => aVariav\[  4 \]
#xtranslate cArqTemp  => aVariav\[  5 \]

*-----------------------------------------------------------------------------*
function CFEP5640() // Comissão D															*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_CPO:={'B','NF','N','','',0,0,0,0,3,2}
//        1   2    3  4  5  6 7 8 9 0,1

VM_REL   :='Comissoes das Vendas'
VM_SELPRO:=array(20,2)
VM_SELGRU:=array(20,2)
AEval(VM_SELPRO,{|DET|DET:=afill(DET,0)})

cArqTemp:='C:\TEMP\VENDEDOR.XLS'

pb_lin4(VM_REL,ProcName())
if !abre({	'R->PROD',;
				'R->GRUPOS',;
				'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->HISCLI',;
				'R->VENDEDOR',;
				'C->NATOP'})
	return NIL
end

select('PROD');dbsetorder(2)	// Cadastro de Produtos
select('VENDEDOR')
VM_CPO[01]:='B'
VM_CPO[10]:=VE_PERC
VM_CPO[11]:=VE_PERCV

VM_CPO[4]:=bom(PARAMETRO->PA_DATA)
VM_CPO[5]:=eom(PARAMETRO->PA_DATA)
nX:=18
pb_box(nX++,40,,,,'Informe Selecao')
@nX++,42 say '[B]uscar [C]alcular.:' get VM_CPO[1] pict mUUU valid VM_CPO[1]$'BC' when pb_msg('Seleciona [B]uscar (ja calculado) ou fazer o [C]alculo durante a listagem')

@nX++,42 say 'Data Inicial.:' get VM_CPO[4] pict masc(7)
@nX++,42 say 'Data Final...:' get VM_CPO[5] pict masc(7)  valid VM_CPO[5]>=VM_CPO[4]
read
if if(lastkey()#K_ESC,pb_ligaimp(,cArqTemp,'Geracao de Arquivo para Excel'),.F.)
	nX:=1
	??'Vendedor'+chr(K_TAB)
	??'Cliente'+chr(K_TAB)
	??'Produto'+chr(K_TAB)
	??'Grupo Estoque'+chr(K_TAB)
	??'Dt Emissao'+chr(K_TAB)
	??'NrPedido'+chr(K_TAB)
	??'NrNF'+chr(K_TAB)
	??'Serie'+chr(K_TAB)
	??'Seq'+chr(K_TAB)
	??'Qtd'+chr(K_TAB)
	??'VlrNF'+chr(K_TAB)
	??'PercComis'+chr(K_TAB)
	??'VlrComissao'
	?
	select('PEDCAB')
	ordem DTEPED
	dbseek(dtos(VM_CPO[4]),.T.) // Data Inicial
	while !eof().and.PC_DTEMI<=VM_CPO[5]
		CFEP5641()
	end
	pb_deslimp(,,.F.)
	Alert('Arquivo gerado para Excel '+cArqTemp+' ;;Nr Linhas geradas='+str(nX,4))
end
dbcloseall()
return NIL

*----------------------------------------------------------------------------*
function CFEP5641()
*----------------------------------------------------------------------------*
local VM_VLCDET :=0
local VM_PERCTO :=0
local VM_VLCOMIS:=0
pb_msg('Gerando arquivo: '+dtoc(PC_DTEMI)+' Linhas Geradas:'+str(nX,4))
if PC_FLAG.and.!PC_FLCAN.and.!Dev_Saida(PEDCAB->PC_CODOP).and.!Nat_Transf(PEDCAB->PC_CODOP)	// Verificar se NF é devoluçao (Não processar) e pedidos não confirmados e NF transferencias
	CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
	VM_VEND:=PC_VEND
	VENDEDOR->(dbseek(str(VM_VEND,3)))
	VM_PRVEN:=VENDEDOR->VE_PERC
	VM_PEDID:=PC_PEDID
	select('PEDDET')
	dbseek(str(VM_PEDID,6),.T.)
	while !eof().and.VM_PEDID==PEDDET->PD_PEDID
		PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
		GRUPOS->(dbseek(str(PROD->PR_CODGR,6)))
		VM_VLCDET:=trunca(PD_QTDE*PD_VALOR-PD_DESCV+PD_ENCFI,2)
		VM_PERCTO:=PROD->PR_PRVEN + GRUPOS->GE_PERVEN // SOMA PERCENTUAL TOTAL
		if VM_CPO[1]=='C'
			VM_VLCOMIS:=trunca(VM_VLCDET*VM_PERCTO/100,2)
		else
			VM_VLCOMIS:=PD_VLCOMIS
			VM_PERCTO := pb_divzero(VM_VLCOMIS,VM_VLCDET)*100 // PERCENTUAL 
		end
		if str(VM_VLCOMIS,15,2)>str(0,15,2) // Tem comissao
			??pb_zer(VM_VEND,3)+chr(45)+VENDEDOR->VE_NOME+chr(K_TAB)
			??pb_zer(PEDCAB->PC_CODCL,5)+'-'+left(CLIENTE->CL_RAZAO,35)+chr(K_TAB)
			??pb_zer(PD_CODPR,L_P)+'-'+trim(PROD->PR_DESCR)+chr(K_TAB)
			??transform(PROD->PR_CODGR,mGRU)+'-'+GRUPOS->GE_DESCR+chr(K_TAB)
			??transform(PEDCAB->PC_DTEMI,masc(7))+chr(K_TAB)
			??pb_zer(PEDCAB->PC_PEDID,6)+chr(K_TAB)
			??pb_zer(PEDCAB->PC_NRNF,6)+chr(K_TAB)
			??PEDCAB->PC_SERIE+chr(K_TAB)
			??pb_zer(PD_ORDEM,2)+chr(K_TAB)
			??transform(PD_QTDE,masc(6))+chr(K_TAB)
			??transform(VM_VLCDET,masc(2))+chr(K_TAB)
			??transform(VM_PERCTO,masc(14))+chr(K_TAB)
			??transform(VM_VLCOMIS,mI92)
			?
			nX++
		end
		dbskip()
	end
end
select('PEDCAB')
pb_brake()
return NIL

//---------------------------------------------------------------EOF-------------------
