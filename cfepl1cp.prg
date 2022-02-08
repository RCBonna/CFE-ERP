*-----------------------------------------------------------------------------*
function CFEPL1CP()	//	Lista da Movimentacao Anual
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({	'R->PARAMETRO',;
				'C->CLIENTE',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'E->COTASSO',;
				'E->COTASCV'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
select('COTASSO')
dbgobottom()
if !CP_DISTRI
	alert('SOBRAS do Ano : '+str(CP_ANO,4)+';NAO DISTRIBUIDA')
//	dbcloseall()
//	return NIL
end
select('COTASCV')
set relation to str(COTASCV->CP_CODCL,5) into CLIENTE
ANO :=COTASSO->CP_ANO
TIPO:='T'
pb_box(18,20,,,,'Lista sobras ano')
@20,22 say 'Ano para Impressao: '+str(ANO,4)
@21,22 say 'Tipo Listagem.....:' get TIPO pict mUUU valid TIPO$'TSEB' when pb_msg('Listar  T=Todos S=Sobras E=Entradas B=Baixas')
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	if TIPO$'T'
		REL:='Movimentacao/Distribuicao das Sobras :'+str(ANO,4)
	elseif TIPO='S'
		REL:='Distribuicao das Sobras :'+str(ANO,4)
		set filter to CP_TIPOMV=='S'
	elseif TIPO='E'
		REL:='Entradas durante :'+str(ANO,4)
		set filter to CP_TIPOMV=='E'
	elseif TIPO='B'
		REL:='Baixas durante :'+str(ANO,4)
		set filter to CP_TIPOMV=='B'
	end
	PAG:=   0
	LAR:= 132
	TOT:={0,0,0,0,0}
	DbGoTop()
	while !eof()
		VM_CODCL:=CP_CODCL
		PAG     :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,'CFEPL1CPA',LAR)
		FLAG    :=.F.
		? pb_zer(CP_CODCL,5)+'-'
		??padr(CLIENTE->CL_RAZAO,30)+' '
		while !eof().and.CP_CODCL==VM_CODCL
			if CP_TIPOMV='S'
				if FLAG
					?space(42)
				end
				??padr('Sobra',10)
				??transform(CP_PERCENT*100,mI63)
				??transform(CP_VLRSOBR,    mD82)
				??transform(CP_VALORE,     mD82)
				??transform(CP_VALORS,     mD82)
				TOT[1]+=CP_VLRSOBR
				TOT[4]+=CP_VALORE
				TOT[5]+=CP_VALORS
				FLAG  :=.T.
			end
			if CP_TIPOMV='E'
				if FLAG
					?space(37)
				end
				??padr('Entrada',53)
				??dtoc(CP_DTENBA)
				??space(13)
				??transform(CP_VLRENBA,mD132)
				TOT[2]+=CP_VLRENBA
				FLAG  :=.T.
			end
			if CP_TIPOMV='B'
				if FLAG
					?space(37)
				end
				??padr('Baixa',53)
				??dtoc(CP_DTENBA)
				??transform(-CP_VLRENBA,mD132)
				TOT[3]+=CP_VLRENBA
				FLAG  :=.T.
			end
			pb_brake()
		end
	end
	?replicate('-',LAR)
	?'T O T A I S'
	? space(90)+padr('Vlr Sobras',21)
	??transform(TOT[1],mD132)

	? space(90)+padr('Entradas Socios',21)
	??transform(TOT[2],mD132)

	? space(90)+padr('Retiradas Socios',21)
	??transform(-TOT[3],mD132)

	? space(90)+padr('Mov.Saidas Prod',21)
	??transform(TOT[4],mD132)

	? space(90)+padr('Mov.Entradas Prod',21)
	??transform(TOT[5],mD132)

	?replicate('-',LAR)
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CFEPL1CPA() // Cabecalho
?padr('Associado',37)+'Tipo Movto  %      Vlr Movto  Mov.Entrad   Mov.Saida   Dt Mov         Vlr Baixa  Vlr Entrada'
?replicate('-',LAR)
return NIL
