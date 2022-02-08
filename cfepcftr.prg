*-----------------------------------------------------------------------------*
function CFEPCFTR()	//	TROCA CODIGO DA ALIQUITA PARA IMPRESSORA FISCAL
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

private VM_AFINI:='01'
private VM_AFFIM:='  '

pb_lin4(_MSG_,ProcName())
if xxsenha(ProcName(),'TROCAR CODIGO ALIQUOTA FISCAL-ECF')
	pb_box(18,10,,,'W+/R','Trocar Aliquota Fiscal-ECF=Todos os Produtos')
   @19,12 say 'Trocar de Aliquota.:' get VM_AFINI  pict mUUU
	@20,12 say 'Para Aliquota......:' get VM_AFFIM  pict mUUU
	@21,12 say 'Processando.........'
	read
	if lastkey()#K_ESC.and.abre({'E->PROD'})
		ORDEM CODIGO
		pb_msg(,NIL,.F.)
		if pb_sn('Trocar todas as Aliquotas de ECF para;a selecao ?')
			DbGoTop()
			VALOR:=[0,0]
			while !eof()
				@21,33 say str(PR_CODPR,13)
				if PR_CFTRIB==VM_AFINI
					replace PR_CFTRIB with VM_AFFIM
					VALOR[1]++
				end
				VALOR[2]++
				dbskip()
				@24,70 say str(VALOR[1],4)+'/'+str(VALOR[2],4)
			end			
		end
		dbcloseall()
		alert('Arquivos foram acertados'+str(VALOR[1],4)+' produtos do estoque')
	end
end
return NIL
