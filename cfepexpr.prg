*-----------------------------------------------------------------------------*
function CFEPEXPR()	// Forçar Excluir Produto											*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
*-----------------------------------------------------------------------------*

if !abre({	'E->PARAMETRO',;
				'E->MOVEST',;
				'E->PROD'})
	return NIL
end

if alert('Esta rotina tem como objetivo excluir um produto;Independente de sua situacao',{'Sair','Aceito'})==2
	while .T.
		select PROD
		ORDEM CODIGO
		pb_box(16,20,,,,'Excluir Produto Definitivamente')
		CodProduto := 0
		@19,22 say "Produto a Excluir:" get CodProduto pict masc(21) valid fn_codpr(@CodProduto,78)
		read
		if if(lastkey()#K_ESC,pb_sn("Tenho certeza da EXCLUSAO"),.F.)
			if dbseek(str(CodProduto,L_P))
				fn_elimi()
				select MOVEST
				ORDEM CODDT
				DbGoTop()
				dbseek(str(CodProduto,L_P),.T.)
				dbedit()
				While !eof().AND.CodProduto == MOVEST->ME_CODPR
					fn_elimi()
				end
			end
		else
			exit
		end
	end
end
dbcloseall()
return NIL
*----------------------------------------------EOF------------------------------
