*-----------------------------------------------------------------------------*
  static aVariav := {{},0,''}
*.....................1.2..3
*---------------------------------------------------------------------------------------*
#xtranslate aSelecao	=> aVariav\[  1 \]
#xtranslate nX			=> aVariav\[  2 \]
#xtranslate cArq		=> aVariav\[  3 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
	function LEITEP11() // Listagem Distribuicao de Valor Adicionado				*
*-----------------------------------------------------------------------------*
VM_REL:='Listagem Distribuicao de Valor Adicionado '
pb_lin4(VM_REL,ProcName())

if !abre({	'R->GRUPOS'			,;
				'R->PROD'			,;
				'R->PARAMETRO'		,;
				'R->PEDCAB'			,;
				'R->PEDDET'			,;
				'R->ENTCAB'			,;
				'R->CLIENTE'		,;
				'R->LEIPARAM'		,;		// Criado arquivo no LEITEP00.PRG
				'R->ENTDET';
			})
	return NIL
end

cArq:=ArqTemp(,,'')
dbatual(cArq,;
			{{'XX_CHAVE',  'C', 60,  0},; // chave
			 {'XX_ALIAS',  'C', 20,  0},; // nome arquivo
			 {'XX_RECNO',  'N',  8,  0}}) // nr do registro

if !net_use(cArq,.T.,20,'TEMP',.T.,.F.,RDDSETDEFAULT())
	dbcloseall()
	fileDelete (cArq + '.*')	// Eliminar Arquivos
	return NIL
end
select('PROD')
ORDEM CODIGO	// Cadastro de Produtos

aSelecao	:={boy(PARAMETRO->PA_DATA), eoy(PARAMETRO->PA_DATA),'T'}
VM_PROD	:=30910
if LEIPARAM->LP_PROD>0 // Código Leite
	VM_PROD  	:=LEIPARAM->LP_PROD // Código Leite - dos parâmetros
else 
	alert('Cadastro de Codigo do Leite deve ser alerado;Ir no cadastro de Leite.')
	dbcloseall()
	return NIL
end

nX     	:=16
pb_box(nX++,20,,,,'Sele‡Æo')
@nX++,22 say 'Produto................:' get VM_PROD		pict masc(21)	valid fn_codpr(@VM_PROD,77)
@nX++,22 say 'Tipo de Lista..........:' get aSelecao[3]	pict mUUU		valid aSelecao[3]$'TFJ' when pb_msg('Selecione tipos a ser Listado: T-Todos  F-Pessos Fisica  J-Pessoa Juridica')
@nX++,22 say 'Data EmissÆo Inicial...:' get aSelecao[1]	pict mDT
@nX++,22 say 'Data EmissÆo Final.....:' get aSelecao[2]	pict mDT			valid aSelecao[2]>=aSelecao[1]

read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_LAR:=132
	VM_PAG:=0
	VM_REL+=str(year(aSelecao[2]),4)
	TOTALG:={0,0} // 
	LEITEP11A()
	?replicate('-',VM_LAR)
	?'Impresso:'+Time()
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
fileDelete (cArq + '.*')	// Eliminar Arquivos
return NIL

*----------------------------------------------------------------------------*
	static function LEITEP11A()
*----------------------------------------------------------------------------*
local TOTAL :=array(3,2)
local QUEBRA:=''
local RT
select('PEDCAB');dbsetorder(7) // cli + dt emi
select('ENTCAB')
ORDEM DTEDOC // DATA EMISSAO
pb_msg('Gerando Arquivo....')
select('ENTCAB')
dbseek(dtos(aSelecao[1]),.T.) // Data Inicial
while !eof().and.EC_DTENT<=aSelecao[2] // Até Data Fim
	pb_msg('Gerando Arquivo: '+dtoc(EC_DTENT))
	CLIENTE->(dbseek(str(ENTCAB->EC_CODFO,5))) // Selecionar Cliente
	if CLIENTE->CL_TIPOFJ==aSelecao[3].or.aSelecao[3]=='T'
		salvabd(SALVA)
		select ENTDET
		dbseek(str(ENTCAB->EC_DOCTO,8),.T.)
		while !eof().and.ENTCAB->EC_DOCTO==ENTDET->ED_DOCTO
			if ENTDET->ED_CODFO==ENTCAB->EC_CODFO
				if ENTDET->ED_CODPR==VM_PROD // Preciso Deste Produto
					//addtemp(str(ENTDET->ED_CODPR,L_P)+str(ENTDET->ED_CODFO,5)+dtos(ENTCAB->EC_DTENT),alias(),recno())
					addtemp(left(dtos(ENTCAB->EC_DTENT),6)+CLIENTE->CL_CIDAD+str(ENTDET->ED_CODFO,5)+str(ENTDET->ED_DOCTO,8)+dtos(ENTCAB->EC_DTENT),alias(),recno())
					//...................................6+7.....(20).....26+27........(5)........31+32........(8).......39.+40.....(8).........47
				end
			end
			dbskip()
		end
		salvabd(RESTAURA)
	end
	dbskip()
end

pb_msg('Gerando Arquivo Indice ....')
select('TEMP')
Index on XX_CHAVE tag CHAVE to (cArq)
DbGoTop()
pb_msg('Imprimindo. ESC cancela  ....')
TOTAL[1]:={0.00,0.00}
while !eof()
	VM_PAG	:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'LEITEP11C',VM_LAR)
	qPeriodo	:=left(XX_CHAVE,6)
	TOTAL[2]	:={0.00,0.00}
	while !eof().and.qPeriodo==left(XX_CHAVE,6)
		VM_PAG  :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'LEITEP11C',VM_LAR)
		VM_CODFO:=substr(XX_CHAVE,27,5) // Código do Fornecedor
		CLIENTE->(dbseek(VM_CODFO))
		ENTDET->(DbGoTo(TEMP->XX_RECNO))
		? right(qPeriodo,2)+space(2)
		??left(CLIENTE->CL_RAZAO,37)+space(2)
		??CLIENTE->CL_CIDAD+space(2)
		??transform(alltrim(CLIENTE->CL_CGC),mCPF)+space(2)
		??substr(XX_CHAVE,46,2)+'/'+substr(XX_CHAVE,44,2)+'/'+substr(XX_CHAVE,40,4)+space(2)
		??transform(ENTDET->ED_DOCTO,mI6)+space(2)
		??transform(ENTDET->ED_QTDE,masc(25))
		??transform(ENTDET->ED_VALOR,masc(02))
		TOTAL[2,1]+=ENTDET->ED_QTDE
		TOTAL[2,2]+=ENTDET->ED_VALOR

		pb_brake()
		VM_PAG  :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'LEITEP11C',VM_LAR)
	end
	if TOTAL[2,1]+TOTAL[2,2]>0.00
		?space(14)+padr('Total do Mes',87,'.')
		??transform(TOTAL[2,1],masc(25))
		??transform(TOTAL[2,2],masc(02))
	end
	TOTAL[1,1]+=TOTAL[2,1] // QTD Produto
	TOTAL[1,2]+=TOTAL[2,2] // VALOR Produto
end
	if TOTAL[1,1]+TOTAL[1,2]>0.00
		?
		?padr('T O T A L   D O   G E R A L',101,'.')
		??transform(TOTAL[1,1],masc(25))
		??transform(TOTAL[1,2],masc(02))
		?
	end
return NIL

*-----------------------------------------------------------------------------*
	function LEITEP11C()
*-----------------------------------------------------------------------------*
?'Mes Produtor'+space(31)+'Municipio'+space(17)+'CPF'+space(10)+'Emissao'+space(8)+'NF    Quantidade          Valor'
?replicate('-',VM_LAR)
return NIL
*-----------------------------------------------------------------------------*EOF------------*
