*-----------------------------------------------------------------------------*
static TIPOREL:='A'
function CFEPEXT1(P1) // Listagem de VendaS												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
P1:='F'

TIPOREL:=P1 // TIPOS A=AMBOS F=FORNECEDORES C=CLIENTES

VM_CPO:={'A','N','N','D','D','N','N'}
//        1   2   3   4   5   6   7

VM_REL:='Compras de Fornecedores'
pb_lin4(VM_REL,ProcName())

if !abre({	'R->GRUPOS',;
				'R->PROD',;
				'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->ENTCAB',;
				'R->ENTDET'})
	return NIL
end
select('GRUPOS')
set filter to GE_CODGR % 10000 # 0
ARQ:=1
while file('TEMP'+pb_zer(ARQ,3)+'.DBF')
	ARQ++
end
ARQ:='TEMP'+pb_zer(ARQ,3)
dbatual(ARQ,;
			{{'XX_CHAVE',  'C', 30,  0},; // chave
			 {'XX_ALIAS',  'C', 20,  0},; // nome arquivo
			 {'XX_RECNO',  'N',  8,  0}}) // nr do registro

if !net_use(ARQ,.T.,20,'TEMP',.T.,.F.,RDDSETDEFAULT())
	dbcloseall()
	return NIL
end
select('PROD');dbsetorder(2)	// Cadastro de Produtos

VM_CPO[4]:=boy(PARAMETRO->PA_DATA)
VM_CPO[5]:=eoy(PARAMETRO->PA_DATA)
VM_CLII  :=0
VM_CLIF  :=99999
VM_SELGRU:=array(10,2)
aeval(VM_SELGRU,{|DET|DET:=afill(DET,0)})
VM_SELPRO:=array(20,2)
aeval(VM_SELPRO,{|DET|DET:=afill(DET,0)})
pb_box(14,20,,,,'Selecao ('+TIPOREL+')' )
@15,22 say '[A]nal¡tico [S]int‚tico:' get VM_CPO[1] pict masc(1)  valid VM_CPO[1]$'AS'
@16,22 say 'Selecionar Grupos    ?  ' get VM_CPO[6] pict masc(1)  valid VM_CPO[6]$'SN'.and.fn_selgru(VM_CPO[6],VM_SELGRU)
@17,22 say 'Selecionar Produtos  ?  ' get VM_CPO[7] pict masc(1)  valid VM_CPO[7]$'SN'.and.fn_selpro(VM_CPO[7],VM_SELPRO) when VM_CPO[6]=='N'
if TIPOREL='A'
	@19,22 say 'Associado..............:' get VM_CLII   pict masc(4) valid fn_codigo(@VM_CLII,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CLII,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
elseif TIPOREL$'CF'
	@18,22 say 'Fornecedor Inicial.....:' get VM_CLII   pict masc(4) valid VM_CLII=0.or.fn_codigo(@VM_CLII,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CLII,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}) when pb_msg('Zero para todos')
	@19,22 say 'Fornecedor Final.......:' get VM_CLIF   pict masc(4) valid VM_CLIF=99999.or.fn_codigo(@VM_CLIF,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CLIF,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}) when pb_msg('99999 para todos')
end
@20,22 say 'Data EmissÆo Inicial...:' get VM_CPO[4] pict masc(7)
@21,22 say 'Data EmissÆo Final.....:' get VM_CPO[5] pict masc(7)  valid VM_CPO[5]>=VM_CPO[4]
read
if if(lastkey()#K_ESC,pb_ligaimp(C15CPP+I12CPP),.F.)
	VM_LAR:=96
	VM_PAG:=0
	VM_REL+= ' entre '+dtoc(VM_CPO[4])+' a '+dtoc(VM_CPO[5])
	TOTALG:={0,0} // 
	CFEPEXT12(VM_CLII,VM_CLIF)
	eject
	pb_deslimp(C12CPP)
end
dbcloseall()
ferase(ARQ+'.DBF')
ferase(ARQ+OrdBagExt())
return NIL

*----------------------------------------------------------------------------*
 function CFEPEXT12(P1,P2)
*----------------------------------------------------------------------------*
local TOTAL :=array(2,2)
local QUEBRA:=''
local RT
select('PEDCAB');dbsetorder(7) // cli + dt emi
select('ENTCAB');dbsetorder(3) // for + dt emi
pb_msg('Gerando arquivo....')
if TIPOREL$'FA'
	select('ENTCAB')
	dbseek(str(P1,5),.T.) // FOR+Data Inicial
	while !eof().and.EC_CODFO<=P2
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPEXT1C',VM_LAR)
		QFOR:=EC_CODFO
		dbseek(str(QFOR,5)+dtos(VM_CPO[4]),.T.) // FOR+Data Inicial
		while !eof().and.EC_CODFO==QFOR.and.EC_DTENT<=VM_CPO[5]
			if ENTCAB->EC_GERAC$' GA' // nao deve entrar tipo M (includio manualmente)
				RT:=.F.
				salvabd(SALVA)
				select('ENTDET')
				dbseek(str(ENTCAB->EC_DOCTO,8),.T.)
				while !eof().and.str(ENTDET->ED_DOCTO,10)+ENTDET->ED_SERIE==str(ENTCAB->EC_DOCTO,10)+ENTCAB->EC_SERIE
					if ENTDET->ED_CODFO==ENTCAB->EC_CODFO
						if fn_vergrpr(ENTDET->ED_CODPR) // preciso deste produto
							addtemp(str(QFOR,5)+str(ED_CODPR,L_P)+dtos(ENTCAB->EC_DTENT)+'E',alias(),recno())
						end
					end
					dbskip()
				end
				salvabd(RESTAURA)
			end
			dbskip()
		end
		dbseek(str(QFOR,5)+'99999999',.T.) // passar para o pb_brake()
	end
end
pb_msg('Gerando arquivo indice ....')

select('TEMP')
Index on XX_CHAVE tag CHAVE to (ARQ)
DbGoTop()

pb_msg('Imprimindo. ESC cancela  ....')
TOTAL[1,1]:=0.00
while !eof()
	VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPEXT1C',VM_LAR)
	QFOR  :=left(XX_CHAVE,5)
	CLIENTE->(dbseek(QFOR))
	?QFOR+' '+CLIENTE->CL_RAZAO
	TOTAL[1,2]:=0.00
	while !eof().and.QFOR==left(XX_CHAVE,5)
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPEXT1C',VM_LAR)
		QPRO:=substr(XX_CHAVE,6,L_P)
		PROD->(dbseek(QPRO))
		?space(6)+padr(QPRO+' '+PROD->PR_DESCR,45)
		TOTAL[2]:={0,0}
		FLCONT:=0
		while !eof().and.QFOR==left(XX_CHAVE,5).and.QPRO==substr(XX_CHAVE,6,L_P)
			if trim(XX_ALIAS)=='ENTDET'
				select('ENTDET')
				DbGoTo(TEMP->XX_RECNO)
				if VM_CPO[1]=='A'
					if FLCONT>0
						?space(51)
					end
					??substr(TEMP->XX_CHAVE,6+L_P+6,2)+'/'
					??substr(TEMP->XX_CHAVE,6+L_P+4,2)+'/'
					??substr(TEMP->XX_CHAVE,6+L_P,4)
					??transform(ED_DOCTO,mI8)
					??transform(ED_QTDE,masc(25))
					??transform(ED_VALOR,masc(02))
					FLCONT++
				end
				TOTAL[2,1]+=ED_QTDE
				TOTAL[2,2]+=ED_VALOR
				select('TEMP')
			end
			pb_brake()
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPEXT1C',VM_LAR)
		end
		if TOTAL[2,1]+TOTAL[2,2]>0.00
			if VM_CPO[1]=='A'
				if FLCONT>1
					?space(14)+padr('Total do produto',55,'.')
					??transform(TOTAL[2,1],masc(25))
					??transform(TOTAL[2,2],masc(02))
				end
			else
				??space(18)
				??transform(TOTAL[2,1],masc(25))
				??transform(TOTAL[2,2],masc(02))
			end
			if VM_CPO[1]=='A'.and.FLCONT>0
				?
			end
		end
		TOTAL[1,2]+=TOTAL[2,2] // total fornecedor
	end
	if TOTAL[1,2]>0.00
		?space(6)+padr('Total do fornecedor',75,'.')
		??transform(TOTAL[1,2],masc(2))
		?
		TOTAL[1,1]+=TOTAL[1,2]
	end
end
	if TOTAL[1,1]>0.00
		?padr('T O T A L   D O   G E R A L',81,'.')
		??transform(TOTAL[1,1],masc(2))
		?
	end

return NIL

*-----------------------------------------------------------------------------*
 function CFEPEXT1C()
*-----------------------------------------------------------------------------*
//if TIPOREL=='A'
//	? 'Associado.: '
//	?pb_zer(VM_CLI,5)+'-'+CLIENTE->CL_RAZAO
//elseif TIPOREL=='C'
//	? 'Cliente...: '
//	??pb_zer(VM_CLI,5)+'-'+CLIENTE->CL_RAZAO
//elseif TIPOREL=='F'
//	? 'Fornecedor: '
//	??pb_zer(VM_CLI,5)+'-'+CLIENTE->CL_RAZAO
//end
//?
?'Fornecedor/Produto                                     Data     Docto  Quantidade          Valor'
?replicate('-',VM_LAR)
return NIL
*----------------------------------------------------------------------------------------*EOF----*
