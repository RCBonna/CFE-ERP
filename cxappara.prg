*-----------------------------------------------------------------------------*
static CodLib:="M0N8$"
static PWord :=CHR(249)+'CX'+chr(250)
*-----------------------------------------------------------------------------*
 function CXAPPARA()	//	Parametro do Caixa
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local X
local P1
if !abre({	'C->CAIXACG',;
				'C->CAIXASA',;
				'E->CAIXAPA',;
				'R->PARAMETRO',;
				'C->PARALINH'})
	return NIL
end
select CAIXACG
if LastRec()<1
	AddRec(,	{1,'Recebimentos',	.T.,'R'})
	AddRec(,	{2,'Pagamentos',		.T.,'D'})
	AddRec(,	{3,'Transferencias',	.F.,' '})
end
select CAIXAPA
DbGoTop()
if lastrec()<1
	AddRec()
	Replace 		CAIXAPA->PA_MODCX with .T.
	USACAIXA:=	CAIXAPA->PA_MODCX
end

pb_lin4(_MSG_,ProcName())
for X :=1 to fcount()
	P1 :="VM"+substr(fieldname(X),3)
	&P1:=&(fieldname(X))
next

VM_DTFECC:=if(empty(VM_DTFECC),PARAMETRO->PA_DATA,VM_DTFECC)
VM_DTFECB:=if(empty(VM_DTFECB),PARAMETRO->PA_DATA,VM_DTFECB)

VM_VALOR:=0
pb_box(16,20,,,,'Parametro do Caixa')
@17,22 say 'Empresa.......: '+VM_EMPR
@18,22 say 'Dt Fech Caixa.:' get VM_DTFECC  pict mDT valid VM_DTFECC==eom(VM_DTFECC)
@19,22 say 'Dt Fech Bancos:' get VM_DTFECB  pict mDT valid VM_DTFECB==eom(VM_DTFECB)
@19,50 say 'Saldo:'          get VM_VALOR   pict masc(05) valid VM_VALOR>=0
@20,22 say 'Nr.Livro......:' get VM_LIVRO   pict masc(12) valid VM_LIVRO >0
@21,22 say 'Folha do Livro:' get VM_PAGINA  pict masc(12) valid VM_PAGINA>0
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if empty(PA_DTFECC)
		salvabd(SALVA)
		select('CAIXASA')
		if AddRec()
			replace 	SA_PERIOD 	with dtos(VM_DTFECC),;
						SA_SALDO 	with VM_VALOR
		end
		salvabd(RESTAURA)
	end
	for X:=1 to fcount()
		P1:="VM"+substr(fieldname(X),3)
		replace &(fieldname(X)) with &P1
	next
end
dbcloseall()
return NIL

*----------------------------------------------------------------------------
 function CXA_CONT()
*----------------------------------------------------------------------------
local RT:=.T.
if !USACAIXA
	alert('Modulo de Caixa Nao implantado')
	RT:=.F.
end
return RT

*-----------------------------------------------------------------------------*
function CXAPFECH()	//	Digitacao de Depositos/Entradas								*
*-----------------------------------------------------------------------------*
local SALDO
local VM_BANCO
local VM_DATA
local VM_FLAG:='S'
local Contador:=0
if !abre({	'R->PARAMETRO','E->BANCO',		'E->CAIXAPA',	'E->CAIXAMB'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
if !cxa_cont()
	dbcloseall()
	return NIL
end
pb_box(18,20,,,,'Fechamento de Periodo/Bancos')
VM_DATA:=bom(PARAMETRO->PA_DATA)-1

@20,22 say 'Fechar Lctos Bancos ate.......: ' get VM_DATA pict mDT  valid VM_DATA<bom(PARAMETRO->PA_DATA)
@21,22 say 'Limpar Lctos com mais de 1 ano ?' get VM_FLAG pict mUUU valid VM_FLAG$'SN'
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	pb_msg()
	select('CAIXAMB')
	ordem GDATA
	DbGoTop()
	while !eof()
		VM_BANCO:=MB_CODBC
		BANCO->(dbseek(str(VM_BANCO,2)))
		SALDO:=BANCO->BC_SLDINI
		while !eof().and.VM_BANCO==MB_CODBC
			if !MB_FECHADO.and.MB_DATA<=VM_DATA
				SALDO+=MB_VALOR*if(MB_TIPO=='+',1,-1)
				replace MB_FECHADO with .T.
			end

			if if(VM_FLAG=='S',MB_DATA< (VM_DATA - 365),.F.)
				dbdelete()
				Contador++
			end
			dbskip()
		end
		replace BANCO->BC_SLDINI with SALDO
	end
	replace CAIXAPA->PA_DTFECB with VM_DATA
end
if VM_FLAG=='S'
	pb_msg('Limpando lancamentos anteriores a '+dtoc(VM_DATA - 365)+'. '+str(Contador,5)+' registros')
	select('CAIXAMB')
	pack
end
dbcloseall()
return NIL
//-----------------------------------------------------------------EOF------------*
