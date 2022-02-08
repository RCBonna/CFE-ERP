static _X:=1,_Y:={'|','/','-','\'}

*-----------------------------------------------------------------------------*
function CFEPVANO() // Virada Anual															*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

DIRETORIO:='C:\Temp\'+pb_zer(year(PARAMETRO->PA_DATA)-1,4)
dbcloseall()
ARQS:=directory('*.db?')
if len(ARQS)>0
	dirmake(DIRETORIO)
	for X:=1 to len(ARQS)
		fn_transf(DIRETORIO,ARQS[X,1],ARQS[X,2])
	next
	while !abre({	'E->ENTDET',;
						'E->ENTCAB'});end
	pb_msg('Limpando arquivo de Notas Fiscais - Entradas',NIL,.F.)
	dbsetorder(2)
	DbGoTop()
	INI:=ctod('01/01/'+DIRETORIO)
	while !eof().and.EC_DTENT<INI
		TT()
		salvabd(SALVA)
		select('ENTDET')
		dbseek(str(ENTCAB->EC_DOCTO,8),.T.)
		while !eof().and.ENTCAB->EC_DOCTO==ED_DOCTO
			dbdelete()
			dbskip()
		end
		salvabd(RESTAURA)
		dbdelete()
		dbskip()
	end
	pb_compac(.T.)
	select('ENTDET')
	pb_compac(.T.)
	dbcloseall()

	while !abre({	'E->PEDDET',;
						'E->PEDCAB'});end
	pb_msg('Limpando arquivo de Notas Fiscais - Saidas',NIL,.F.)
	dbsetorder(4)
	DbGoTop()
	while !eof().and.PC_DTEMI<INI
		TT()
		salvabd(SALVA)
		select('PEDDET')
		dbseek(str(PEDCAB->PC_PEDID,6),.T.)
		while !eof().and.str(PEDCAB->PC_PEDID,6)==str(PD_PEDID,6)
			dbdelete()
			dbskip()
		end
		salvabd(RESTAURA)
		dbdelete()
		dbskip()
	end
	pb_compac(.T.)
	select('PEDDET')
	pb_compac(.T.)
	dbcloseall()
	CTBPFANO(DIRETORIO) // Zerar Contabilidade
else
	Alert('Arquivos do ano anterior encontrados.;Verificar Situacao')
end
return NIL

*-----------------------------------------------------------------------------*
 function FN_TRANSF(P1,P2,TAM)
*-----------------------------------------------------------------------------*
local KBLIVRE:=diskfree()
local ARQ    :=P1+'\'+P2
if file(ARQ)
	beeperro()
	if !pb_sn('Arquivo j  se encontra no Drive '+P1+'. Substituir ?')
		return NIL
	end
	ferase(ARQ)
end
if KBLIVRE<TAM+512
	beeperro()
	alert('Disco n„o tem espa‡o suficiente ('+alltrim(str(KBLIVRE))+') para gravar este arquivo')
	return NIL
end
pb_msg('Copiando arquivo '+P2+' para diretorio '+P1+'. Aguarde....',NIL,.F.)
if filecopy(P2,ARQ)#TAM
	beeperro()
	alert('Problemas na c¢pia do arquivo...')
	ferase(ARQ)
end
return NIL

*-----------------------------------------------------------------------------*
 static function CTBPFANO(P1)
*-----------------------------------------------------------------------------*
local VM_SLD,VM_P1,VM_X,VM_SLD_IN
while !abre({	'E->PARAMCTB',;
					'E->RAZAO',;
					'E->CTADET'});end
DbGoTop()
while !eof()
	VM_SLD_IN:=CD_SLD_IN
	for VM_X:=1 to 12
		VM_P1    :="CD_DEB_"+pb_zer(VM_X,2)
		VM_SLD_IN:=VM_SLD_IN-&VM_P1
		VM_P1    :="CD_CRE_"+pb_zer(VM_X,2)
		VM_SLD_IN:=VM_SLD_IN+&VM_P1
	next
	replace CD_SLD_IN with VM_SLD_IN
	for VM_X:=5 to 28
		replace &(fieldname(VM_X)) with 0
	next
	dbskip()
end
select('RAZAO')
zap

select('PARAMCTB')
replace  PA_NRLOTE with replicate('0',60),;
			PA_ANO    with val(P1)+1,;
			PA_SEQLOT with 1

dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 static function TT()
*-----------------------------------------------------------------------------*
@24,75 say _Y[_X]
_X++
_X:=if(_X==5,1,_X)
return NIL

*----------------------------------------[EOF]---------------------------------
