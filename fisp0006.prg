*-----------------------------------------------------------------------------*
 static aVariav := {'',0, '','',132,0,'',{}}
 //..................1.2..3...4...5.6..7..8
*-----------------------------------------------------------------------------*
#xtranslate aDT     => aVariav\[  1 \]
#xtranslate nX      => aVariav\[  2 \]
#xtranslate aTipoC  => aVariav\[  3 \]
#xtranslate VM_REL  => aVariav\[  4 \]
#xtranslate VM_LAR  => aVariav\[  5 \]
#xtranslate VM_PAG  => aVariav\[  6 \]
#xtranslate dContr  => aVariav\[  7 \]
#xtranslate TOT     => aVariav\[  8 \]

*-----------------------------------------------------------------------------*
function FISP0006() // Lista Conhecimento Frete-Credito PIS/COFINS
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_REL:='CREDITO PIS/COFINS SOBRE FRETE'

pb_lin4(VM_REL,ProcName())

if !abre({	'R->PROD',;
				'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->ENTCAB',;
				'R->ENTDET',;
				'C->NATOP'})
	return NIL
end

select('PROD');ORDEM CODIGO	// Cadastro de Produtos

aDT   :={bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA)}
aTipoC:='AZE/ISE/SFJ/             '

nX:=16
pb_box(nX++,20,,,,'Selecione')
@nX++,22 say 'Data Emissao Inicial......:' get aDT[1] pict masc(7)
@nX++,22 say 'Data Emissao Final........:' get aDT[2] pict masc(7)  valid aDT[2]>=aDT[1]
nX++
@nX++,22 say 'Tipo Tributacao Pis/Cofins:' get aTipoC pict mUUU valid !empty(aTipoC)
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_PAG:=  0
	VM_LAR:=132
	dContr:=ctod('')
	TOT   :={0,0}
	VM_REL+=' - Periodo '+dtoc(aDT[1])+' ate '+dtoc(aDT[2])
	select ENTCAB
	ordem DTEDOC
	dbseek(dtos(aDT[1]),.T.) // Data Inicial
	while !eof().and.ENTCAB->EC_DTENT<=aDT[2]
		@maxrow(),65 say dtoc(ENTCAB->EC_DTENT)
		if !ENTCAB->EC_NFCAN.and.ENTCAB->EC_FRDOC>0 // NF nao cancelada e que tenha FRETE
			FISP00061()
		end
		pb_brake()
	end
	?replicate('-',VM_LAR)
	? space(39)+padr('TOTAL DO GERAL',53,'.')
	??transform(TOT[1],mI102)+space(2)
	??transform(TOT[2],mI102)
	?replicate('-',VM_LAR)
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

*----------------------------------------------------------------------------*
static function FISP00061()
*----------------------------------------------------------------------------*
SALVABANCO
select ENTDET
dbseek(str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE,.T.)
while !eof().and.	str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5)==;
						str(ENTDET->ED_DOCTO,8)+ENTDET->ED_SERIE+str(ENTDET->ED_CODFO,5)
	if ENTDET->ED_CODCOF$aTipoC.and.; // pertence ao Grupo
		str(ED_FVLPIS+ED_FVLCOFI,15,2)>str(0,15,2)
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,'FISP0006',VM_REL,VM_PAG,'FISP00061A',VM_LAR)
		PROD->(dbseek(str(ENTDET->ED_CODPR,L_P)))
		if dContr#ENTCAB->EC_DTENT
			? dtoc(ENTCAB->EC_DTENT)+space(2)
			dContr:=ENTCAB->EC_DTENT
		else
			? space(12)
		end
		??str(ENTCAB->EC_FRDOC,8)+'/'+ENTCAB->EC_FRSER+space(2)
		??str(ENTCAB->EC_DOCTO,8)+'/'+ENTCAB->EC_SERIE+space(1)
		??str(ED_ORDEM,3)+space(1)
		??str(ENTDET->ED_CODPR,L_P)+'-'+PROD->PR_DESCR+space(1)
		
		??transform(ED_FVLPIS, mI102)+space(2)
		??transform(ED_FVLCOFI,mI102)
		
		TOT[1]+=ED_FVLPIS
		TOT[2]+=ED_FVLCOFI
	end
	skip
end
RESTAURABANCO
return NIL

*-----------------------------------------------------------------------------*
 function FISP00061A()
*-----------------------------------------------------------------------------*
?padc('Considerado somente Codigos de Tributacao = Isento, Suspenso e Aliquita Zero',VM_LAR)
?padc('Selecao = '+alltrim(aTipoC),132)
?
?'Dt Entrada Nr.Conh.Frete Nr NF Entrada Seq Produto                                             Vlr PIS  Vlr Cofins'
?replicate('-',VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
