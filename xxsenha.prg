#include 'RCB.CH'

*------------------------------------------------* SENHAS
	function CRSENHA(P1,P2)
*------------------------------------------------* SENHAS
local ARQ:='SENHAINT'
if dbatual(ARQ,;
				{{'PW_PROGR', 'C', 20, 0},;
				 {'PW_DESCR', 'C', 30, 0},;
				 {'PW_SENHA', 'C', 30, 0}},;
				 RDDSETDEFAULT()) // 
	ferase(ARQ+OrdBagExt())
	close
end
return NIL

*------------------------------------------------*
	function XXSENHA(P1,P2)
*------------------------------------------------*
local V_SENHA:=space(30)
local RT     :=.F.
local XX     :=.F.
local TF     :=SaveScreen()
default P2 to "Alterar"

if Used() // Tem alguma área aberta?
	SALVABANCO
	XX:=.T.
end
if abre({'C->SENHAS'})
	SALVACOR
	pb_box(21,00,23,60,'R/W',P2)
	V_SENHA:=Upper(GetSecret(V_SENHA,22,02,.T.,' Informe Senha.:'))
	RESTAURACOR
	locate for trim(PW_PROGR)==P1
	if Found()
		if PW_SENHA==CRI(V_SENHA)
			RT:=.T.
		else
			Alert('Senha Incorreta')
		end$
	elseif trim(V_SENHA)=='PAD'+'RAO'
		if AddRec()
			replace  PW_PROGR with upper(P1),;
						PW_DESCR with P2,;
						PW_SENHA with cri(padr('PADRAO',30))
			RT:=.T.
		end
	end
	close
end
if XX
	RESTAURABANCO
end
RestScreen(,,,,TF)
return RT

*-----------------------------------------------------------------------------*
	static function CRI(P1)
//-----------------------------------------------------------------------------*
local X
local LETRA
local SENHA:=''

for X:=1 to len(P1)
	LETRA:=charadd(substr(P1,X,1),substr('XXROBERTOCARLOSBONANOMINFFHOXX',X,1))
	SENHA:=LETRA+SENHA
next
return(SENHA)

*-----------------------------------------------------------------------------*
	function EDSENHA()
*-----------------------------------------------------------------------------*
local V_SENHA
local V_SENHB
local V_PROGR
local RT
local TemAreas:=.F.

if xxsenha(ProcName(),_MSG_)
	if Used()
		SALVABANCO
		TemAreas:=.T.
	end
	if abre({'E->SENHAS'})
		salvacor(SALVA)
		pb_box(17,0,22,60,,'Alterar Senhas Internas')
		while .T.
			V_SENHA:=V_SENHB:=V_DESCR:=space(30)
			V_PROGR:='-1'
			pb_msg('Pressione <ESC> para Sair')
			if fn_PesProg(@V_PROGR,@V_DESCR)
				@18,02 say 'Programa.: '+V_PROGR
				@19,02 say 'Descricao:' get V_DESCR pict mXXX
				read
			end
			if lastkey()#K_ESC
				locate for trim(PW_PROGR)==trim(V_PROGR)
				RT:=.F.
				if !found()
					if pb_sn('Programa nao cadastrado, faze-lo agora?')
						if AddRec()
							replace PW_PROGR with V_PROG
							RT:=.T.
						end
					end
				else
					RT:=.T.
				end
				if RT
					V_SENHA:=upper(getsecret(V_SENHA,20,02,.T.,'Informe Nova Senha.:'))
					V_SENHB:=upper(getsecret(V_SENHB,21,02,.T.,'Favor Repita Senha.:'))
					if lastkey()#K_ESC
						if V_SENHA==V_SENHB
							replace	PW_DESCR with V_DESCR,;
										PW_SENHA with CRI(V_SENHA)
						else
							Alert('Senhas não Conferem.')
						end
					end
				end
			else
				exit
			end
		end
		close
		salvacor(RESTAURA)
	end
	if TemAreas
		RESTAURABANCO
	end
end
return NIL

*-----------------------------------------------------------------------------*
	static function fn_PesProg(P1,P2)
*-----------------------------------------------------------------------------*
local TF:=savescreen()
local RT:=.T.
if trim(P1)=='-1'
	pb_box(05,00,18,54,,'Programas')
	dbedit(06,01,17,53,{fieldname(2),fieldname(1)},,'','','',' ¯ ')
	if lastkey()==K_ENTER
		P1:=fieldget(1)
		P2:=fieldget(2)
	else
		RT:=.F.
	end
else
	locate for trim(PW_PROGR)==P1
	if Found()
		P1:=fieldget(1)
		P2:=fieldget(2)
	end
end
restscreen(,,,,TF)
return RT
*------------------------------EOF-----------------------------------------------*
