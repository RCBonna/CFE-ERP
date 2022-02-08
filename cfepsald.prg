*-----------------------------------------------------------------------------*
	static              aVariav := {'',.T.,0,0,.F.}
*-----------------------------------------------------------------------------*
#xtranslate cArq		=> aVariav\[  1 \]
#xtranslate lCont		=> aVariav\[  2 \]
#xtranslate nX			=> aVariav\[  3 \]
#xtranslate nY			=> aVariav\[  4 \]
#xtranslate lFiltro	=> aVariav\[  5 \]

*-----------------------------------------------------------------------------*
function CFEPSALD()	//	Movimetacoes de saldo de estoque / acertos
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
#include 'hbsix.ch'

cArq          :=''
lFiltro       :=.F.
cFiltroPeriodo:=''
pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'R->PARAMETRO',;
				'C->GRUPOS',;
				'C->CODTR',;
				'C->PROD',;
				'E->SALDOS'})
	return NIL
end

select('PROD')
ordem CODIGO
select('SALDOS')
ordem CODIGO
DbGoTop()

set relation to str(SALDOS->SA_CODPR,L_P) into PROD

pb_dbedit1('CFEPSAL','IncluiAlteraExluirFiltroAcerto')
VM_CAMPO:={'SA_PERIOD','SA_CODPR','SA_QTD','SA_VLR'}
VM_CAMPO[2]='str(SA_CODPR,L_P)+chr(45)+left(PROD->PR_DESCR,25)'

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
				{     mPER,            mXXX,  mD133,     mD132},;
				{'Periodo','C¢digo Produto', 'Qtde','Vlr.Est.'})
set relation to
dbcommit()
dbcloseall()
//FileDelete(cArq+'.*')
return NIL

*-----------------------------------------------------------------------------*
	function CFEPSAL1() && Rotina de InclusÃ¢â‚¬Å¾o
*-------------------------------------------------------------------------
if !lFiltro
	while lastkey()#K_ESC
		dbgobottom()
		dbskip()
		CFEPSALT(.T.)
	end
else
	Alert('Para incluir ou modificar nao use filtro.')
end
return NIL

*-------------------------------------------------------------------------
	function CFEPSAL2() && Rotina de Alterar
*-------------------------------------------------------------------------
	if RecLock()
		CFEPSALT(.F.)
	end
return NIL

*-------------------------------------------------------------------------
	function CFEPSAL3() && Excluir
*-------------------------------------------------------------------------
if pb_sn('Excluir Periodo '+transform(SA_PERIOD,mPER)+';Produto '+&(VM_CAMPO[2]))
	if reclock()
		dbdelete()
		dbskip()
		if eof()
			DbGoTop()
		end
	end
end
return NIL

*-------------------------------------------------------------------------
	function CFEPSALT(P1) && Rotina de InclusÃ¢â‚¬Å¾o
*-------------------------------------------------------------------------
local GETLIST  := {}
local X
local VM_Y
lCont:=.F.
while .T.
	for X:=1 to fcount()
		VM_Y :='VM'+substr(fieldname(X),3)
		&VM_Y:=fieldget(X)
	next
	if P1
		VM_EMPRESA:=1
	end
	pb_box(15,20,,,,'Informe Dados')
	@16,22 say 'Periodo.........:' get VM_PERIOD pict mPER     valid VM_PERIOD>'200000'
	@17,22 say 'C¢d.Produto.....:' get VM_CODPR  pict masc(21) valid fn_codpr(@VM_CODPR,78)
	@19,22 say 'Saldo Total Qtde:' get VM_QTD    pict mD133    valid VM_QTD>=0.000          when RT_TRUE(dbseek(str(VM_EMPRESA,2)+VM_PERIOD+str(VM_CODPR,L_P)))
	@20,22 say 'Saldo Total Vlr.:' get VM_VLR    pict mD132    valid VM_VLR>=0.00
	read
	if if(lastkey()#27,pb_sn(),.F.)
		if P1.and.!dbseek(str(VM_EMPRESA,2)+VM_PERIOD+str(VM_CODPR,L_P))
			AddRec()
		end
		for X:=1 to fcount()
			VM_Y:="VM"+substr(fieldname(X),3)
			fieldput(X, &VM_Y)
		next
		skip
		if eof()
			go top
		end
		if P1
			exit
		end
	else
		exit
	end
end
NetCommitAll()
return NIL

*-----------------------------------------------------------------------------*
	function CFEPSAL4(P1) // Rotina de Filtro
*-----------------------------------------------------------------------------*
cFiltroPeriodo:=SA_PERIOD
pb_box(20,20,,,,'Filtrar um periodo')
@21,22 say 'Periodo.:' get cFiltroPeriodo pict mPER
read
if lastkey()#K_ESC
	cArq:=ArqTemp(,,'')
	pb_msg('Aguarde... filtrando periodo '+cFiltroPeriodo+' ==>'+cArq)
	Index on str(SA_EMPRESA,2)+SA_PERIOD+str(SA_CODPR,L_P) tag COMFILTRO to (cArq) for SA_PERIOD==cFiltroPeriodo TEMPORARY
	DbGoTop()
	lFiltro:=.T.
else

end
DbGoTop()
return NIL

*-----------------------------------------------------------------------------*
	function CFEPSAL5(P1) // Rotina de Importação
*-----------------------------------------------------------------------------*
local VM_PERIOD:='201112'
if !lFiltro
	nX             :=1
	nY             :=0
	cArq           :='C:\TEMP\SALD2011.DBF'
	if pb_sn('Ajuste de saldo de Estoque 31/12/2011;arquio base '+cArq+';Prosseguir?')
		if file(cArq)
			if Flock()
				DbGoTop()
				dbseek(str(1,2)+VM_PERIOD,.F.)
				pb_msg('Eliminando registros de '+VM_PERIOD)
				while !eof().and.str(1,2)+VM_PERIOD==str(SA_EMPRESA,2)+SA_PERIOD
					delete
					skip
					@24,57 say padr('Reg.Eliminados:'+str(nX++,6),25)
				end
				Alert('Inicio da Importacao dos dados;Aguarde')
				pb_msg('Importando registros de '+cArq+'. Aguarde...')
				if NetDbUse(cArq,'SALDO2011',30,RddSetDefault(),.T.,.F.,.T.)
					SELECT SALDO2011
					go top
					while !eof()
						if str(1,2)+VM_PERIOD==str(SA_EMPRESA,2)+SA_PERIOD
							SELECT SALDOS
							AddRec()
							for nX:=1 to FCount()
								FieldPut(nX, SALDO2011->(FieldGet(nX)))
							next
							SELECT SALDO2011
							@24,57 say padr('Reg.Importados:'+str(++nY,6),25)
						end
						skip
					end
					close
					SELECT SALDOS
					pb_msg('Validando Registros 1/3. Aguarde.')
					NetCommitAll()
					pb_msg('Validando Registros 2/3. Aguarde.')
					pack
					pb_msg('Validando Registros 3/3. Aguarde.')
					DbReindex()
				else
					Alert('Aquivo '+cArq+' existe, mas nao foi possivel ser aberto em rede.;Avalie se mais alguem possa estar usando.')
				end
			else
				Alert('Arquivos de saldo nao pode ser bloqueado;tente mais tarde.')
			end
		else
			Alert('Arquivo '+cArq+' nao encontrado;rever diretorio')
		end
	end
else
	Alert('Filtro Ativado, nao deve ser usado para importacao dos dados.')
end
DbGoTop()
return NIL
*-----------------------------------------------------------------------------*
	static function RT_TRUE(pArg) // Rotina de Filtro
*-----------------------------------------------------------------------------*
VM_QTD:=SA_QTD
VM_VLR:=SA_VLR
return .T.
*--------------------------------------------------------------------------EOF
