//-----------------------------------------------------------------------------*
  static aVariav := {0,{},{},0,''}
//...................1,2..3..4..5
//-----------------------------------------------------------------------------*
#xtranslate nX      => aVariav\[  1 \]
#xtranslate aUsers  => aVariav\[  2 \]
#xtranslate aUsersX => aVariav\[  3 \]
#xtranslate nY      => aVariav\[  4 \]
#xtranslate cUser   => aVariav\[  5 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
	function CFEP1500() // Cadastro de Bancos													*
*-----------------------------------------------------------------------------*
pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'C->PARAMETRO',;
				'C->CTATIT',;
				'C->CTADET',;
				'C->BANCO'})
	return NIL
end
DbGoTop()

pb_dbedit1('CFEP150','IncluiAlteraPesqu.ExcluiLista Usuar ')  // tela
VM_CAMPO:=array(fcount())
afields(VM_CAMPO)

VM_MUSC     :={masc(11),     masc(1),  masc(1),   masc(1),masc(10), masc(1), masc(1),masc(3)  ,masc(5)      , masc(1),   mXXX,   mI6 ,   mI1,  mI2  ,  mI2,        mI16,      mUUU }
VM_CABE     :={   'C¢d','Nome Banco','Agencia','Endere‡o',   'CEP','Cidade',    'UF','Ct Cont','Sld Inicial','Ct Cxa','ImpCh','NrChe','Porta','Linha','Lpp','Nr Boleto','Seguranca'}
VM_CAMPO[10]:='if(BC_CAIXA, "SIM","nao")'
VM_CAMPO[11]:='if(BC_IMPCHE,"SIM","nao")'
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MUSC,VM_CABE)
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim
	function CFEP1501() // Rotina de Inclus„o
*-------------------------------------------------------------------* 
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEP1500T(.T.)
end
return NIL

*-------------------------------------------------------------------* 
	function CFEP1502() // Rotina de Altera‡„o
*-------------------------------------------------------------------* 
if RecLock()
	CFEP1500T(.F.)
end
return NIL

*-------------------------------------------------------------------* 
	function CFEP1500T(VM_FL)
*-------------------------------------------------------------------* 
local GETLIST := {},VM_X,VM_Y,VM_CTCLP:='',LCONT:=.T.
for VM_X:=1 to fcount()
	VM_Y :="VM"+substr(fieldname(VM_X),3)
	&VM_Y:=&(fieldname(VM_X))
next
if VM_FL
	dbgobottom()
	VM_CODBC:=BC_CODBC + 1
	if VM_CODBC> 99
		VM_CODBC:=1
	end
	VM_CIDAD :=PARAMETRO->PA_CIDAD
	VM_CEP   :=PARAMETRO->PA_CEP
	VM_UF    :=PARAMETRO->PA_UF
end
VM_IMPCHE:=if(VM_IMPCHE,'S','N')
VM_PORCHE:=if(empty(VM_PORCHE),1,VM_PORCHE)

pb_box(12,20,,,,'Cadastro de Bancos')
@13,22 say 'C¢digo.........:' get VM_CODBC  pict mI2  valid VM_CODBC>0.and.VM_CODBC<100.and.pb_ifcod2(str(VM_CODBC,2),NIL,.F.) when VM_FL
@14,22 say 'BCO/Agencia....:' get VM_AGENC  pict mXXX
@15,22 say 'Nome Banco.....:' get VM_DESCR  pict mXXX valid !empty(VM_DESCR)
@16,22 say 'Endere‡o.......:' get VM_ENDER  pict mXXX+'S37'
@17,22 say 'Cidade/CEP/UF..:' get VM_CIDAD  pict mXXX
@17,63    	                  get VM_CEP    pict mXXX
@17,75      	               get VM_UF     pict mXXX  valid pb_uf(@VM_UF)
@18,22 say 'Conta Contabil.:' get VM_CONTA  pict mI4   valid if(VM_CONTA==0,.T.,fn_ifconta(@VM_CTCLP,@VM_CONTA)) when PARAMETRO->PA_CONTAB==USOMODULO
@19,22 say 'Saldo Inicial..:' get VM_SLDINI pict mI122                                     when pb_msg('O saldo incial do Banco pode ser Negativo (-300,00)')
@20,22 say 'Imprimir Cheque:' get VM_IMPCHE pict mUUU  valid VM_IMPCHE$'SN'                when pb_msg('Imprimir cheque no contas a Pagar ? <S/N>')
@21,22 say 'Ult.Cheque Impr:' get VM_ULTCHE pict mI6   valid VM_ULTCHE>=0                  when VM_IMPCHE=='S'.and.pb_msg('Informe o numero do ultimo cheque impresso')
@21,55 say 'Porta Impress..:' get VM_PORCHE pict mI1   valid VM_PORCHE>=1.and.VM_PORCHE<=4 when pb_msg('Porta da impressora para este banco (1-3)').and.VM_IMPCHE=='S'
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.f.)
	if VM_FL
		LCONT:=AddRec()
	end
	VM_IMPCHE:=(VM_IMPCHE=='S')
	for VM_X:=1 to fcount()
		VM_Y:="VM"+substr(fieldname(VM_X),3)
		replace &(fieldname(VM_X)) with &VM_Y
	next
	if left(VM_AGENC,5)=='CAIXA'
		REGISTROCX:=recno()
		dbcommitall()
		dbeval({||BANCO->BC_CAIXA:=.F.},{||reclock()})
		DbGoTo(REGISTROCX)
		replace BANCO->BC_CAIXA with .T.
	end
	// dbcommit()
end
DbrunLock(RecNo())
return NIL

*-------------------------------------------------------------------* 
	function CFEP1503() // Rotina de Pesquisa
*-------------------------------------------------------------------* 
local VM_CHAVE:= &(fieldname(indexord()))
pb_box(20,60,,,,'Pesquisar Banco')
@21,61 get VM_CHAVE picture masc(indexord())
read
setcolor(VM_CORPAD)
dbseek(if(indexord()=1,str(VM_CHAVE,2),trim(VM_CHAVE)),.T.)
return NIL

*-------------------------------------------------------------------* 
	function CFEP1504() // Rotina de Exclus„o
*-------------------------------------------------------------------* 
if pb_sn('Eliminar '+str(BC_CODBC,2)+'-'+trim(BC_DESCR)+'?').and.RecLock()
	fn_elimi()
end
dbrunlock()
return NIL

*-------------------------------------------------------------------* 
	function CFEP1505() // Rotina de Impress„o
*-------------------------------------------------------------------* 
if pb_ligaimp(I15CPP)
	DbGoTop()
	VM_PAG = 0
	VM_REL = 'Cadastro de Bancos'
	VM_LAR = 132
	while !eof()
		VM_PAG = pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP1505A',VM_LAR)
		?  str(BC_CODBC,3)+'-'+BC_DESCR+space(1)+BC_AGENC
		?? space(1)+BC_ENDER+space(1)+transform(BC_CEP,masc(10))
		?? space(1)+BC_CIDAD+space(1)+BC_UF
		pb_brake()
 	end
	?replicate('-',VM_LAR)
	?'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
	DbGoTop()
end
return NIL

*-------------------------------------------------------------------* 
	function CFEP1505A
*-------------------------------------------------------------------* 
? 'Cod-Banco'+space(26)+'Agencia'+space(4)
??'Endereco'+space(33)+'C.E.P.'+space(4)+'Cidade'+space(15)+'UF'
?replicate('-',VM_LAR)
return NIL

*-------------------------------------------------------------------* 
	function CFEP1506() // Seguran‡a
*-------------------------------------------------------------------* 
pb_tela()
fn_retusu()
VM_FL   :=.T.
VM_CAMPO:={"str(BC_CODBC,3)+'-'+BC_DESCR",'fn_visusu()'}
while VM_FL
	dbedit(06,01,21,38,VM_CAMPO,,,{'Banco','X'})
	if lastkey()==K_ESC
		VM_FL   :=.F.
	else
		nY:=7
		for nX:=1 to len(aUsers)
			@nY++,73 get aUsers[nX][3] pict mUUU valid GetActive():VarGet()$'SIM*---*   ' when pb_msg('Informe <SIM> ou <---> para NAO - para este usu rio acessar este banco')
		next
		read
		if if(lastkey()#K_ESC,pb_sn(),.F.)
			if reclock()
				cUser:=''
				for nX:=1 to len(aUsers)
					cUser+=if(aUsers[nX][3]=='SIM',trim(aUsers[nX][2])+'@','')
				next
				replace BC_USER with cUser
				dbrunlock(recno())
			end
		end
	end
end
return NIL

*-------------------------------------------------------------------* 
	function fn_visusu()
*-------------------------------------------------------------------* 
nY:=6
pb_box(05,40,22,78)
@nY++,41 say 'Usuario                       Acesso ' color 'W/R+'
for nX:=1 to len(aUsers)
	aUsers[nX][3]:=if(trim(aUsers[nX][2])+'@'$BC_USER,'SIM','---')
	@nY++,41 say aUsers[nX][2]+' ['+aUsers[nX][3]+']'
next
setcolor(VM_CORPAD)
return '.'

*-------------------------------------------------------------------* 
	function fn_retusu()
*-------------------------------------------------------------------* 
aUsersX:=RT_aUSERS()
for nX:=1 to len(aUsersX)
	aadd(aUsers,{aUsersX[nX][1],aUsersX[nX][2],'nao'})
next
return Nil
//--------------------------------------------------------------------EOF------------------
