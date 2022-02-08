*-----------------------------------------------------------------------------*
 static aVariav := {0,{},{}}
 //.................1..2...3...4...5..6...7...8...9, 10, 11, 12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate aOPC       => aVariav\[  2 \]
#xtranslate aFAT       => aVariav\[  3 \]

*-----------------------------------------------------------------------------*
	function CFEPRVFI() // Listagem de Vendas										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_CPO:={0,'dt1','dt2',0, 0, 0, ,'T',0,3,2}
//       1   2      3  4  5  6  7 8  9 0,1

VM_REL:='Vendas por Produto/Periodo/Financeiro'

pb_lin4(VM_REL,ProcName())

if !abre({	'R->PROD',;
				'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->HISCLI',;
				'R->NATOP',;
				'R->DPCLI',;
				'R->PEDPARC',;
				'R->GRUPOS'})
	return NIL
end
select('PROD')
dbsetorder(2)	// Cadastro de Produtos

select('PEDCAB')
ordsetfocus('DTEPED')
DbGoTop()

ARQ:=ArqTemp(,,'')
dbcreate(ARQ,{ {'RV_CODPR','N',L_P,0},;	// 1
					{'RV_DTEMI','D',  8,0},;	// 2
					{'RV_EMIT' ,'N',  5,0},;	// 3
					{'RV_NRNF' ,'N',  9,0},;	// 4
					{'RV_SERIE','C',  3,0},;	// 5
					{'RV_QTVEN','N', 12,2},;	// 6
					{'RV_VLVEN','N', 15,2},;	// 7
					{'RV_NRPAR','N',  2,0},;	// 8
					{'RV_DTPAR','D',  8,0}})	// 9-Data ultima parcela

if !net_use(ARQ, .T. , ,'RELVENDAS', ,.F.,RDDSETDEFAULT())
	dbcloseall()
	return NIL
end
select('RELVENDAS')
Index on str(RV_CODPR,L_P)+dtos(RV_DTEMI)+str(RV_NRNF,9)+RV_SERIE  tag COD_PROD to (ARQ)	//....1

VM_CPO[2]:=bom(PARAMETRO->PA_DATA)
VM_CPO[3]:=PARAMETRO->PA_DATA
VM_CODPR :=0
pb_box(16,20,,,,'Selecione Faixa')
@17,22 say 'Produto a Listar.......:' get VM_CODPR  pict masc(21) valid fn_codpr(@VM_CODPR,77)
@19,22 say 'Data Emissao Incial....:' get VM_CPO[2] pict masc(07)
@20,22 say 'Data Emissao Final.....:' get VM_CPO[3] pict masc(07) valid VM_CPO[3]>=VM_CPO[2]
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_REL+=' Ref.'+dtoc(VM_CPO[2])+' a '+dtoc(VM_CPO[3])
	pb_msg('Calculando valores... Aguarde...')
	ordsetfocus('COD_PROD')
	CFEPRVFI0()	//..........................Gerando arquivo temporário
	pb_msg('Imprimindo ESC cancela...')
	select('RELVENDAS')
	ordsetfocus('COD_PROD')
	DbGoTop()
	VM_LAR   :=132
	VM_PAG   := 0
	VM_CPO[1]:=0
	dbseek(str(VM_CODPR,L_P),.T.)
	while !eof().and.RV_CODPR<=VM_CODPR
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRVFIC',VM_LAR)
		if VM_CPO[1]#RV_CODPR
			VM_CPO[1]:=RV_CODPR
			PROD->(dbseek(str(VM_CPO[1],L_P)))
			?'Produto: '+pb_zer(VM_CPO[1],L_P)+'-'+PROD->PR_DESCR+' ('+PROD->PR_UND+')'
			?
		end
		CFEPRVFI1() // Impressao da linha
		dbskip()
	end
	?replicate('-',VM_LAR)
	?padc('TOTAIS DO PRODUTO',79)
	??transform(VM_CPO[4],mI113)+space(1)
	??transform(VM_CPO[5],mD82)
	?replicate('-',VM_LAR)
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
FileDelete (Arq + '.*')
return NIL

*----------------------------------------------------------------------------*
	static function CFEPRVFI0() // Acumular registros do produto
*----------------------------------------------------------------------------*
local VM_PROD
local VM_PCOMP
salvabd(SALVA)
select('PEDCAB')
ORDEM DTEPED
DbGoTop()
dbseek(dtos(VM_CPO[2]),.T.)
while !eof().and.PC_DTEMI<=VM_CPO[3]
	if !PC_FLCAN.and.PC_FLAG
		@24,69 say dtoc(PC_DTEMI)
		if PC_FLAG.and.!PC_FLCAN.and.!Dev_Saida(PEDCAB->PC_CODOP).and.!Nat_Transf(PEDCAB->PC_CODOP)	// Verificar se NF é devoluçao (Não processar) e pedidos não confirmados e NF transferencias
			VM_PEDID:=PC_PEDID
			select('PEDDET')
			dbseek(str(VM_PEDID,6),.T.)
			if PEDCAB->PC_FATUR>0
				aFAT      :=fn_RetParc(VM_PEDID,PEDCAB->PC_FATUR,PEDCAB->PC_NRNF)
				if len(aFAT)>0
					dDTVencUlt:=aFAT[PEDCAB->PC_FATUR][2]
				else
//					Alert('Pedido '+Str(VM_PEDID,6)+' A prazo='+str(PEDCAB->PC_FATUR,2)+';mas encontrado parcelas em Arq')
				end
			else
				dDTVencUlt:=ctod('')
			end
			while !eof().and.PEDDET->PD_PEDID==VM_PEDID
				if str(PEDDET->PD_CODPR,L_P)==str(VM_CODPR,L_P) // Produto procurado
					select('RELVENDAS')
					AddRec(,{PEDDET->PD_CODPR,;
								PEDCAB->PC_DTEMI,;
								PEDCAB->PC_CODCL,;
								PEDCAB->PC_NRNF,;
								PEDCAB->PC_SERIE,;
								PEDDET->PD_QTDE,;
								Trunca(PEDDET->PD_QTDE*PEDDET->PD_VALOR-PEDDET->PD_DESCV,2),;
								PEDCAB->PC_FATUR,;
								dDTVencUlt})			//DT última Parcela
					select('PEDDET')
				end
				dbskip()
			end
			select('PEDCAB')
		end
	end
	dbskip()
end
salvabd(RESTAURA)
return NIL

*-----------------------------------------------------------------------------*
 function CFEPRVFI1()
*-----------------------------------------------------------------------------*
PROD->   (dbseek(str(RELVENDAS->RV_CODPR,L_P)))
CLIENTE->(dbseek(str(RELVENDAS->RV_EMIT ,5)))

? transform(RELVENDAS->RV_DTEMI,mDT)	+space(2)
??transform(RELVENDAS->RV_EMIT ,mI5)+'-'+Left(CLIENTE->CL_RAZAO,30)+space(1)
??if(CLIENTE->CL_TIPOFJ=='F',transform(CLIENTE->CL_CGC,mCPF)+space(4),transform(CLIENTE->CL_CGC,mCGC))+space(1)
??transform(RELVENDAS->RV_NRNF ,mI6)	+space(1)
??RELVENDAS->RV_SERIE						+space(1)
??transform(RELVENDAS->RV_QTVEN,mI113)+space(1)
??transform(RELVENDAS->RV_VLVEN,mD82)	+space(4)
??str(RELVENDAS->RV_NRPAR,3)				+space(2)
??transform(RELVENDAS->RV_DTPAR,mDT)
VM_CPO[4]+=RELVENDAS->RV_QTVEN
VM_CPO[5]+=RELVENDAS->RV_VLVEN

nX++
return NIL

*-----------------------------------------------------------------------------*
 function CFEPRVFIC()
*-----------------------------------------------------------------------------*
? padr('Produto/Descricao',  41)
?'Dt Emissao  Cliente'+space(30)
??padc('CNPJ/CPF',19)
??'Nr.NF. Ser'        +space(03)
??'Qtd Venda    Vlr Venda Nr Parc Dt Ult Parc'
?replicate('-',VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
