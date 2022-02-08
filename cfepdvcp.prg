*-----------------------------------------------------------------------------*
 function CFEPDVCP()	//	calcula/divide/edita cota Cota parte
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'R->PARAMETRO',;
				'C->CLIENTE',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'R->PROD',;
				'R->NATOP',;
				'E->COTASSO',;
				'E->COTASCV'})
	return NIL
end
pb_tela()
pb_lin4(_MSG_,ProcName())
select('COTASSO')
dbgobottom()
if CP_DISTRI
	alert('SOBRAS do Ano : '+str(CP_ANO,4)+';JA DISTRIBUIDA')
else
	alert('SOBRAS do Ano : '+str(CP_ANO,4)+';NAO DISTRIBUIDA')
end
private ANO:=CP_ANO
select('COTASCV')
set relation to str(COTASCV->CP_CODCL,5) into CLIENTE
pb_dbedit1('CFEPDVCP','SomatoAlteraCalculBaixarEntradExcluiLista ')
VM_CAMPO   := array(7)
afields(VM_CAMPO)
VM_CAMPO[1]:='CP_TIPOMV+chr(32)+pb_zer(CP_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,25)'

VM_MUSC:={       mXXX,  mI4,         mD132,          mD132,"@E 99.9999999",    mD132,     mD132,             mD132 }
VM_CABE:={"Associado","Ano","Valor Vendas","Valor Compras","% Particip", "Vlr Capit", "Vlr Distr",'Vlr BAIXA/INTEG'}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",VM_MUSC,VM_CABE)
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
  function CFEPDVCP1() // Somatorio de Entradas/Saidas
*-----------------------------------------------------------------------------*
local TOTAL
if pb_sn('Limpar Dados Calcular Valores;Compra/Venda dos associados ?')
	select('COTASCV')
	zap
	if !abre({	'R->PEDCAB',;
					'R->PEDDET',;
					'R->ENTCAB',;
					'R->ENTDET'})
		keyboard '0' // sair do programa
		return NIL
	end
	cArq:=ArqTemp(,,'')
	dbatual(cArq,;
				{{'XX_CHAVE',  'C', 30,  0},; // chave
				 {'XX_ALIAS',  'C', 20,  0},; // nome arquivo
				 {'XX_RECNO',  'N',  8,  0}}) // nr do registro
	if !net_use(cArq,.T.,20,'TEMP',.T.,.F.,RDDSETDEFAULT())
		dbcloseall()
		keyboard '0'
		return NIL
	end
	TIPOREL:='A'
	VM_CPO :={1,2,3,ctod('01/01/'+str(ANO,4)),ctod('31/12/'+str(ANO)),'N','N','S','N','N','L'}
	//........1.2.3.4.........................5........................6...7...8...9..10..11...TEM RELAÇÃO COM CFEPEXTR1.PRG
	select('CLIENTE')
	DbGoTop()
	while !eof()
		if CLIENTE->CL_ATIVID==1 // Somente Clientes Associados
			@24,00 say padr('Associado:'+CL_RAZAO,79) color 'GR+/B'
			VM_CLI:=fieldget(1)
			CFEPEXTR1(VM_CLI)	// Gera arquivo TEMP
			TOTAL:=CFEPEXTR3(VM_CLI)	// Somatório dos Valores de Entrada[1] e Saida[1]
			select('COTASCV')
			AddRec()
			replace 	CP_CODCL  with VM_CLI,;
						CP_ANO    with ANO,;
						CP_VALORE with TOTAL[1],;
						CP_VALORS with TOTAL[2],;
						CP_TIPOMV with 'S' // SOBRAS
			select('CLIENTE')
		end
		dbskip()
	end

	dbcloseall()
	ferase(cArq+'.DBF')
	ferase(cArq+OrdBagExt())
	FileDelete (cArq+'.*') // Eliminar arquivo temporário de indice...

	if !abre({	'R->PARAMETRO',;
					'C->CLIENTE',;
					'E->COTASSO',;
					'E->COTASCV'})
		return NIL
	end
	set relation to str(COTASCV->CP_CODCL,5) into CLIENTE
end
return NIL

*-----------------------------------------------------------------------------*
function CFEPDVCP2() // altera valores
*-----------------------------------------------------------------------------*
local GETLIST:= {}
local LCONT  :=.T.
local VM_X
local VM_Y
if CP_TIPOMV=='S'
	for VM_X:=1 to fcount()
		VM_Y :='VM'+substr(fieldname(VM_X),3)
		&VM_Y:=&(fieldname(VM_X))
	next
	pb_box(17,18,,,,'Edita Valores')
	@18,20 say 'Cod.Associado:' get VM_CODCL  pict mI5   valid fn_codigo(@VM_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
	@19,20 say 'Valor Vendas.:' get VM_VALORE pict mI122 valid VM_VALORE>=0
	@20,20 say 'Valor Compras:' get VM_VALORS pict mI122 valid VM_VALORS>=0
	read
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		for VM_X:=1 to fcount()
			VM_Y:="VM"+substr(fieldname(VM_X),3)
			replace &(fieldname(VM_X)) with &VM_Y
		next
		dbskip(0)
	end
else
	alert('Valor nao Editavel')
end
return NIL

*-----------------------------------------------------------------------------*
	function CFEPDVCP3() // Calcula %
*-----------------------------------------------------------------------------*
local TOTAL :={0,0}
local PERC  := 0.00
local TOTSOB:={0,0}
local DIFER :=0.00
if pb_sn('Fazer a Divisao das Sobras de '+str(ANO,4)+'?')
	set decim to 6
	pb_msg('Acumulando valores Entrada e Saida ja processados')
	select('COTASCV')
	set filter to CP_TIPOMV=='S'
	DbGoTop()
	while !eof()
		TOTAL[1]+=CP_VALORE	// soma entradas
		TOTAL[2]+=CP_VALORS	// soma saidas
		dbskip()
	end
	DbGoTop()

	select('COTASSO')
	if dbseek(str(ANO,4))
		pb_msg('Sobras: Calculando divisao dos Valores')
		replace 	CP_VALORE with TOTAL[1],;
					CP_VALORS with TOTAL[2]
		select('COTASCV')
		while !eof()
			@24,60 say 'Assocado:'+str(CP_CODCL,5)
			PERC:=pb_divzero(COTASCV->CP_VALORE+COTASCV->CP_VALORS,(TOTAL[1]+TOTAL[2]))
			replace 	COTASCV->CP_PERCENT with PERC,;
						COTASCV->CP_VLRSOBR with Trunca(PERC*COTASSO->CP_VALORD,2),;//Pagamento de Sobras -> Capitalização
						COTASCV->CP_VLRDIST with Trunca(PERC*COTASSO->CP_VALORP,2),;//Pagamento de Sobras -> Distribuição
						COTASCV->CP_HISTOR  with COTASSO->CP_HISTOR,;
						COTASCV->CP_HISTOR  with COTASSO->CP_HISTDS
			TOTSOB[1]+=COTASCV->CP_VLRSOBR
			TOTSOB[2]+=COTASCV->CP_VLRDIST
			dbskip()
		end
		DbGoTop()
		*--------------------------------------------------------------CAPITALZACAO
		if str(COTASSO->CP_VALORD - TOTSOB[1],15,2) # str(0,15,2) // Ha Diferenca na Distribuiçao Capitalzacao?
			ALERT('Diferenca Capitalizacao;Valor:'+str(TOTSOB[1],15,2)+'  --> '+STR(COTASSO->CP_VALORD,15,2))
		end
		if str(TOTSOB[1],15,2) # str(COTASSO->CP_VALORD,15,2)
			DIFER:=COTASSO->CP_VALORD - TOTSOB[1] // Diferenca valor da diferenca capitalizacao
			while str(DIFER,15,2)#str(0,15,2)
				DbGoTop()
				while !eof().and.str(DIFER,15,2)#str(0,15,2)
					if COTASCV->CP_VLRSOBR>0.00
						replace COTASCV->CP_VLRSOBR with COTASCV->CP_VLRSOBR+0.01
						DIFER-=0.01
						@24,00 say 'Ajustando diferenca Capitalizacao:'+str(DIFER,6,2)
					end
					dbskip()
				end
			end
		end
		DbGoTop()
		*--------------------------------------------------------------DISTRIBUICAO
		if str(COTASSO->CP_VALORP - TOTSOB[2],15,2) # str(0,15,2) // Ha Diferenca na Distribuiçao Capitalzacao?
			ALERT('Diferenca Capitalizacao;Valor:'+str(TOTSOB[2],15,2)+'  --> '+STR(COTASSO->CP_VALORP,15,2))
		end
		if str(TOTSOB[2],15,2) # str(COTASSO->CP_VALORP,15,2)
			DIFER:=COTASSO->CP_VALORP - TOTSOB[2] // Diferenca valor da diferenca Distribuiçao
			while str(DIFER,15,2)#str(0,15,2)
				DbGoTop()
				while !eof().and.str(DIFER,15,2)#str(0,15,2)
					if CP_VLRDIST>0.00
						replace CP_VLRDIST with CP_VLRDIST+0.01
						DIFER-=0.01
						@24,00 say 'Ajustando diferenca Distribuicao:'+str(DIFER,6,2)
					end
					dbskip()
				end
			end
		end
		DbGoTop()
	else
		alert('Falta informar Sobras de '+str(ANO,4))
	end
	set decim to 2
	set filter to
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEPDVCP4() // Baixa ASSICIADOS
*-----------------------------------------------------------------------------*
Alert('Funcao unificada em CLIENTE=> 6-Conta Parte/Movimento/DesAssociar')
return NIL

*-----------------------------------------------------------------------------*
 function ZZZZB() // Baixa ASSICIADOS
*-----------------------------------------------------------------------------*
local GETLIST  := {}
local LCONT:=.T.
local VM_X,VM_Y
set relation to
dbgobottom()
dbskip()
for VM_X:=1 to fcount()
	VM_Y :='VM'+substr(fieldname(VM_X),3)
	&VM_Y:=&(fieldname(VM_X))
next
pb_box(17,18,,,,'Baixa de Associados')
@18,20 say 'Cod.Associado.:' get VM_CODCL   pict mI5   valid fn_codigo(@VM_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@19,20 say 'Data Baixa....:' get VM_DTENBA  pict mDT   when (VM_DTENBA:=CLIENTE->CL_DTBAIX)>=ctod('')
read
if lastkey()#K_ESC
	VM_VLRENBA:=0.00
	VM_HISTOR :=space(60)
	FLAG      :=.T.
	dbseek(str(VM_CODCL,5)+str(ANO,4),.T.)
	while !eof().and.VM_CODCL==CP_CODCL.and.FLAG
		if CP_TIPOMV=='B'
			VM_VLRENBA:=CP_VLRENBA
			VM_HISTOR :=CP_HISTOR
			FLAG      :=.F.
		else
			dbskip()
		end
	end
	@20,20 say 'Valor Retirado:' get VM_VLRENBA pict mI122 valid VM_VLRENBA>=0
	@21,20 say 'Historico.....:' get VM_HISTOR  pict mXXX
	read
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		if FLAG
			if CLIENTE->(reclock())
				replace CLIENTE->CL_DTBAIX with VM_DTENBA
			end
			AddRec()
			VM_TIPOMV:='B'
			VM_ANO   :=ANO
		end
		if reclock()
			for VM_X:=1 to fcount()
				VM_Y :="VM"+substr(fieldname(VM_X),3)
				replace &(fieldname(VM_X)) with &VM_Y
			next
		end
		dbskip(0)
	end
	dbrunlock()
end
set relation to str(COTASCV->CP_CODCL,5) into CLIENTE
return NIL

*-----------------------------------------------------------------------------*
	function CFEPDVCP5() // Entrada ASSOCIADOS
*-----------------------------------------------------------------------------*
Alert('Funcao unificada em CLIENTE=> 6-Conta Parte/Movimento/DesAssociar')


*-----------------------------------------------------------------------------*
 function ZZZZE() // ENTRADA ASSICIADOS
*-----------------------------------------------------------------------------*
local GETLIST  := {}
local LCONT:=.T.
local VM_X,VM_Y
set relation to
dbgobottom()
dbskip()
for VM_X:=1 to fcount()
	VM_Y :='VM'+substr(fieldname(VM_X),3)
	&VM_Y:=&(fieldname(VM_X))
next
pb_box(17,18,,,,'Entrada Associados')
@18,20 say 'Cod.Associado.:' get VM_CODCL   pict mI5   valid fn_codigo(@VM_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}).and.empty(CLIENTE->CL_DTBAIX)
@19,20 say 'Data Entrada..:' get VM_DTENBA  pict mDT   when (VM_DTENBA:=CLIENTE->CL_DTCAD)>=ctod('')
read
if lastkey()#K_ESC
	VM_VLRENBA:=0.00
	VM_HISTOR :=space(60)
	FLAG      :=.T.
	dbseek(str(VM_CODCL,5)+str(ANO,4),.T.)
	while !eof().and.VM_CODCL==CP_CODCL.and.FLAG
		if CP_TIPOMV=='E'
			VM_VLRENBA:=CP_VLRENBA
			VM_HISTOR :=CP_HISTOR
			FLAG      :=.F.
		else
			dbskip()
		end
	end
	@20,20 say 'Vlr Integrado.:' get VM_VLRENBA pict mI122 valid VM_VLRENBA>=0
	@21,20 say 'Historico.....:' get VM_HISTOR  pict mXXX
	read
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		if FLAG
			AddRec()
			VM_TIPOMV:='E'
			VM_ANO   :=ANO
		end
		if reclock()
			for VM_X:=1 to fcount()
				VM_Y :="VM"+substr(fieldname(VM_X),3)
				replace &(fieldname(VM_X)) with &VM_Y
			next
		end
		dbskip(0)
	end
	dbrunlock()
end
set relation to str(COTASCV->CP_CODCL,5) into CLIENTE
return NIL

*-----------------------------------------------------------------------------*
	static function CFEPEXTR3(P1)
*-----------------------------------------------------------------------------*
local TOTAL:={0,0}
salvabd(SALVA)
select('TEMP')
DbGoTop()
while !eof()
	if trim(XX_ALIAS)=='ENTCAB'
		ENTCAB->(DbGoTo(TEMP->XX_RECNO))
		select('ENTDET')
		dbseek(str(ENTCAB->EC_DOCTO,8),.T.)
		while !eof().and.ENTCAB->EC_DOCTO==ED_DOCTO
			if ED_CODFO==ENTCAB->EC_CODFO
				TOTAL[1]+=ED_VALOR
			end
			dbskip()
		end
	else
		PEDCAB->(DbGoTo(TEMP->XX_RECNO))
		select('PEDDET')
		dbseek(str(PEDCAB->PC_PEDID,6),.T.)
		while !eof().and.PEDCAB->PC_PEDID==PD_PEDID
			TOTAL[2]+=round(PD_VALOR*PD_QTDE,2)-PD_DESCV-PD_DESCG
			dbskip()
		end
	end
	select('TEMP')
	dbskip()
end
zap
salvabd(RESTAURA)
return TOTAL

*------------------------------------------------------------
  function CFEPDVCP6() // altera valores
*------------------------------------------------------------
if pb_sn('Exluir esta Movimentacao de '+&(VM_CAMPO[1]))
	dbdelete()
	dbskip()
end
return NIL

*------------------------------------------------------------
  function CFEPDVCP7() // Listar
*------------------------------------------------------------
	VM_LAR:=132
	VM_PAG:=0
	VM_REL:= ' Lista das Distribuicao Conta Parte em '+str(ANO,4)
	aSoma:={0,0,0,0}
	if pb_ligaimp(I15CPP)
		go top
		while !eof()
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPDVCPC',VM_LAR)
			? pb_zer(CP_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,25)
			??transform(CP_VALORE,mD132)
			??transform(CP_VALORS,mD132)
			??transform(CP_PERCENT,"@E 99.9999999")
			??transform(CP_VLRSOBR,mD132)
			??transform(CP_VLRDIST,mD132)
			aSoma[1]+=CP_VALORE
			aSoma[2]+=CP_VALORS
			aSoma[3]+=CP_VLRSOBR
			aSoma[4]+=CP_VLRDIST
			skip
		end		
		?replicate('-',VM_LAR)
		?padr('Totais',31)
		??transform(aSoma[1],mD132)
		??transform(aSoma[2],mD132)+space(10)
		??transform(aSoma[3],mD132)
		??transform(aSoma[4],mD132)
		?replicate('-',VM_LAR)
		?'Time '+time()
		eject
		pb_deslimp(C15CPP)
	end

*------------------------------------------------------------
  function CFEPDVCPC() // Cabecalho
*------------------------------------------------------------
	?"Associado"+space(25)+"Valor Vendas"+space(2)+"Valor Compras"+space(1)+"% Particip"+space(3)+ "Vlr Capitaliz"+space(3)+'Vlr Distr'
	?replicate('-',VM_LAR)

return NIL