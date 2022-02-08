*-----------------------------------------------------------------------------*
* Atualizacao da estrutura de banco de dados												*
*-----------------------------------------------------------------------------*

function DBATUAL(P1,P2) // P1=nome do arquivo P2=estrutura
local VM_STRU,X0,X1,RT:=.F.
if P1=NIL.or.P2=NIL
	pb_msg('Nome do ARQUIVO/ESTRUTURA n„o informado...',3,.t.)
	return NIL
end
if file(P1+'.DBF')
	while !net_use(P1,.F.,20,,.T.)
		if alert('N„o posso Abrir '+P1+'. Tentar novamente?',{'SIM','n„o'})==2
			quit
		end
	end
	VM_STRU:=dbstruct()
	if len(VM_STRU)==len(P2)
		for X0=1 to len(VM_STRU)
			for X1=1 to 4
				if P2[X0,X1]#VM_STRU[X0,X1]
					RT:=.T.
					X0=len(VM_STRU)+1
					X1=10
				end
			next
		next
	else
		RT:=.T.
	end
	dbclosearea()
	if RT
		pb_msg(P1+': Mudando estrutura... Aguarde...',NIL,.F.)
		fn_appendstr(P1,P2)
	end
else
	dbcreate(P1,P2)		// Arquivo nao existe -> s¢ criar
	RT=.T.
end
return(RT) //atualizou a estrutura

*-----------------------------------------------------------------------------*
function FN_APPENDSTR(P1,P2)
frename(P1+'.DBF',P1+'$.DBF')
frename(P1+'.DBT',P1+'$.DBT')
dbcreate(P1,P2)		// Recriar arquivo com nova estrutura
use (P1) new exclusive
append from (P1+'$')
ferase(P1+'$.DBF')
ferase(P1+'$.DBT')
dbclosearea()
*-------------------------------------------------------------EOF---------------*