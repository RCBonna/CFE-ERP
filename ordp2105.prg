*-----------------------------------------------------------------------------*
#include 'RCB.CH'
*-----------------------------------------------------------------------------*
function ORDP2105()	//	Impressao Ordem de SVC/PRD
local X:=alert('Selecione tipo de listagem ... ',{'Comprovante 1','Comprovante 2','Lista '+trim(PARAMORD->PA_DESCR3)})
if X=1
	ORDP2105C()
elseif X=2
	ORDP2105E()
elseif X=3
	ORDP2105L()
end
return NIL

*-----------------------------------------------------------------------------*
function ORDP2105C()	//	Impressao Comprovante de Entrega==CARROS
local OBS:={},X,Y
if pb_ligaimp(C15CPP)
	LAR:=78
	for X=1 to 5
		aadd(OBS,substr(ORDEM->OR_OBS,X*60-59,60))
	end
	? replicate('-',LAR)
	? INEGR+padc(VM_EMPR,LAR)+CNEGR
	? padc(trim(PARAMETRO->PA_ENDER)+'-'+trim(PARAMETRO->PA_CIDAD)+'/'+PARAMETRO->PA_UF,LAR)
	? padc('Fone : '+trim(PARAMETRO->PA_FONE)+' Fax : '+trim(PARAMETRO->PA_FAX),LAR)
	? replicate('-',LAR)
	? INEGR+padc('ORDEM DE SERVICO-'+pb_zer(ORDEM->OR_CODOR,5),LAR)
	? replicate('-',LAR)
	? 'Cliente : '+pb_zer(OR_CODCL,5)+'-'+CLIENTE->CL_RAZAO
	? '        : '+CLIENTE->CL_ENDER
	? '        : '+CLIENTE->CL_BAIRRO+' Fone: '+CLIENTE->CL_FONE
	? space(LAR)
	? trim(PARAMORD->PA_DESCR2)+':'+trim(ORDEM->OR_CODED)+' - '+EQUIDES->ED_DESCR
	? EQUIDES->ED_OBS
	? padr('Dt.Entrada',15,'.')+transform(ORDEM->OR_DTENT,masc(7))+space(10)+padr('Dt.Saida Prev',15,'.')+transform(ORDEM->OR_DTSAI,masc(7))
	? padc('Reclamacao ou Solicitacao',LAR,'-')
	for X=1 to len(OBS)
		if !empty(OBS[X])
			? space(5)+OBS[X]
		end
	next
	? replicate('-',LAR)
	? INEGR+padc('Lista de Pecas',LAR)
	? 'D A T A      Codig         Descricao                                     Qtdade'+CNEGR
	for X=1 to 15
	? '___________  ____________  _________________________________________   __________'
	next
	?
	? INEGR+padc('Lista de Pecas Hr Gastas',LAR)
	? 'D A T A      Operador/Mecanico                                Hora Inicio Hora Fim'+CNEGR
	for X=1 to 15
		? '___________  ________________________________________________ ___________ __________'
	next
	?
	? padl(trim(PARAMETRO->PA_CIDAD)+', '+pb_zer(day(ORDEM->OR_DTENT),2)+' '+trim(pb_mesext(ORDEM->OR_DTENT,'C'))+' '+pb_zer(year(ORDEM->OR_DTENT),4),LAR)
	eject
	pb_deslimp(C15CPP)
end
return NIL

*-----------------------------------------------------------------------------*
function ORDP2105E()	//	Impressao Comprovante de Entrega==ELETRODOMESTICO
local OBS:={},OBSA:={},X,Y,VM_DTANT:=ctod('')
local LINHA:=array(4,42)
local POS:={{1,2},{3,4},{0,0},{0,0}}
if file('COMPROV.ARR')
	POS:=restarray('COMPROV.ARR')
end

pb_box(17,10)
@18,12 say '1-Comprovante de Entrega'
@19,12 say '2-Comprovante da Equipamento'
@20,12 say '3-Comprovante de Conserto'
@21,12 say '4-Lista de Pecas/Horas'

pb_box(15,44,,,'W+/RB+,W+/R,,,W+/RB+')
@16,45 say 'Posicao de cada Listagem na Folha' color 'W+/R'
@18,50 get POS[1,1] pict masc(11) valid POS[1,1]> 0.and.POS[1,1]<5
@18,60 get POS[1,2] pict masc(11) valid POS[1,2]>=0.and.POS[1,2]<5
@19,50 get POS[2,1] pict masc(11) valid POS[2,1]>=0.and.POS[2,1]<5
@19,60 get POS[2,2] pict masc(11) valid POS[2,2]>=0.and.POS[2,2]<5 when POS[2,1]>0
@20,50 get POS[3,1] pict masc(11) valid POS[3,1]>=0.and.POS[3,1]<5
@20,60 get POS[3,2] pict masc(11) valid POS[3,2]>=0.and.POS[3,2]<5 when POS[3,1]>0
@21,50 get POS[4,1] pict masc(11) valid POS[4,1]>=0.and.POS[4,1]<5
@21,60 get POS[4,2] pict masc(11) valid POS[4,2]>=0.and.POS[4,2]<5 when POS[4,1]>0
read

if pb_ligaimp(I8LPP+I44LPP+I15CPP)
	savearray(POS,'COMPROV.ARR')
	LAR:=64
	aeval(LINHA,{|DET|DET:=afill(DET,space(LAR))})
	for X=1 to 5
		aadd(OBS,substr(ORDEM->OR_OBS,X*60-59,60))
	end

	*-----------------------------------------------------------------------------------------------------------*
	LINHA[1, 1]:=INEGR+padc(VM_EMPR,LAR)+CNEGR
	LINHA[1, 2]:=padc(trim(PARAMETRO->PA_ENDER)+'-'+trim(PARAMETRO->PA_CIDAD)+'/'+PARAMETRO->PA_UF,LAR)
	LINHA[1, 3]:=padc('Fone : '+trim(PARAMETRO->PA_FONE)+' Fax : '+trim(PARAMETRO->PA_FAX),LAR)
	LINHA[1, 4]:=replicate('-',LAR)
	LINHA[1, 5]:=INEGR+padc('COMPROVANTE DE ENTREGA-'+pb_zer(ORDEM->OR_CODOR,5),LAR)+CNEGR
	LINHA[1, 7]:=padr('Cliente : '+pb_zer(OR_CODCL,5)+'-'+CLIENTE->CL_RAZAO,LAR)
	LINHA[1, 8]:=padr('        : '+CLIENTE->CL_ENDER,LAR)
	LINHA[1, 9]:=padr('        : '+CLIENTE->CL_BAIRRO+' Fone: '+CLIENTE->CL_FONE,LAR)
	LINHA[1,11]:=padr(trim(PARAMORD->PA_DESCR2)+':'+trim(ORDEM->OR_CODED)+' - '+EQUIDES->ED_DESCR,LAR)
	LINHA[1,12]:=padr(EQUIDES->ED_OBS,LAR)
	
	OBSA:=fn_ordemant(ORDEM->OR_CODED,@VM_DTANT,ORDEM->OR_CODOR)
	Y:=14
	if len(OBSA)>0
		LINHA[1,Y++]:=padc('HISTORICO - Ultima Manutencao em '+dtoc(VM_DTANT),LAR,'-')
		for X=1 to len(OBSA)
			LINHA[1,Y++]:=padr(space(5)+OBSA[X],LAR)
		next
		LINHA[1,Y++]:=replicate('-',LAR)
		Y++
	end
	LINHA[1,Y++]:=padc(padr('Dt.Entrada',15,'.')+transform(ORDEM->OR_DTENT,masc(7))+space(10)+padr('Dt.Saida Prev',15,'.')+transform(ORDEM->OR_DTSAI,masc(7)),LAR)
	Y++
	LINHA[1,Y++]:=padc('Reclamacao ou Solicitacao',LAR,'-')
	for X=1 to len(OBS)
		LINHA[1,Y++]:=padr(space(5)+OBS[X],LAR)
		LINHA[3,15+X]:=padr(space(5)+OBS[X],LAR)
	next
	LINHA[1,Y++]:=replicate('-',LAR)
	Y++
	LINHA[1,Y++]:=padl(trim(PARAMETRO->PA_CIDAD)+', '+pb_zer(day(ORDEM->OR_DTENT),2)+' '+trim(pb_mesext(ORDEM->OR_DTENT,'C'))+' '+pb_zer(year(ORDEM->OR_DTENT),4),LAR)
	Y++
	LINHA[1,Y++]:=padl(replicate('_',30),LAR)
	LINHA[1,Y++]:=padl('Assinatura Cliente',LAR)

	*-----------------------------------------------------------------------------------------------------------*
	for X=1 to 42
		LINHA[2,X]:=LINHA[1,X]
	next
	LINHA[2,5]:=INEGR+padc('COMPROVANTE '+trim(PARAMORD->PA_DESCR2)+'-'+pb_zer(ORDEM->OR_CODOR,5),LAR)+CNEGR

	*-----------------------------------------------------------------------------------------------------------*
	LINHA[3, 1]:=LINHA[1, 1]
	LINHA[3, 2]:=LINHA[1, 2]
	LINHA[3, 3]:=LINHA[1, 3]
	LINHA[3, 4]:=LINHA[1, 4]
	LINHA[3, 5]:=INEGR+padc('COMPROVANTE DE CONSERTO-'+pb_zer(ORDEM->OR_CODOR,5),LAR)+CNEGR
	LINHA[3, 7]:=padr('Cliente : '+pb_zer(OR_CODCL,5)+'-'+CLIENTE->CL_RAZAO,LAR)
	LINHA[3, 8]:=padr('        : '+CLIENTE->CL_ENDER,LAR)
	LINHA[3, 9]:=padr('        : '+CLIENTE->CL_BAIRRO+' Fone: '+CLIENTE->CL_FONE,LAR)
	LINHA[3,10]:=padr(trim(PARAMORD->PA_DESCR2)+':'+trim(ORDEM->OR_CODED)+' - '+EQUIDES->ED_DESCR,LAR)
	LINHA[3,11]:=padr(EQUIDES->ED_OBS,LAR)
	LINHA[3,12]:=replicate('-',LAR)
	LINHA[3,13]:=padc(padr('Dt.Entrada',15,'.')+transform(ORDEM->OR_DTENT,masc(7))+space(10)+padr('Dt.Saida Prev',15,'.')+transform(ORDEM->OR_DTSAI,masc(7)),LAR)
	LINHA[3,15]:=padc('Reclamacao ou Solicitacao',LAR,'-')

	LINHA[3,21]:=LINHA[1,22]
	LINHA[3,24]:=padl(trim(PARAMETRO->PA_CIDAD)+', '+pb_zer(day(ORDEM->OR_DTENT),2)+' '+trim(pb_mesext(ORDEM->OR_DTENT,'C'))+' '+pb_zer(year(ORDEM->OR_DTENT),4),LAR)
	LINHA[3,26]:=padr('   Declaro que o produto acima identificado, devidamente',LAR)
	LINHA[3,27]:=padr('   consertado, foi testado na minha presenca, estando em',LAR)
	LINHA[3,28]:=padr('   perfeitas condicoes de funcionamento.',LAR)
	LINHA[3,32]:=padl(replicate('_',30),LAR)
	LINHA[3,33]:=padl('Assinatura Cliente',LAR)

	*-----------------------------------------------------------------------------------------------------------*
	LINHA[4, 1]:=padc(trim(PARAMORD->PA_DESCR3)+' Nr : '+pb_zer(ORDEM->OR_CODOR,5),LAR)
	LINHA[4, 2]:=padc(pb_zer(OR_CODCL,5)+'-'+trim(CLIENTE->CL_RAZAO),LAR)
	LINHA[4, 3]:=INEGR+padc('Lista de Pecas/Hr Gastas',LAR)+CNEGR
	LINHA[4, 4]:=replicate('-',LAR)
	LINHA[4, 5]:=padc('Codig   Descricao                                  Qtdade',LAR)
	for X:=1 to 35
		LINHA[4, 5+X]:=replicate('_',LAR)
	next

	for X:=1 to 4
		if !empty(POS[X,1])
			for Y:=1 to 42
				? LINHA[POS[X,1],Y]
				if !empty(POS[X,2])
					??space(2)+LINHA[POS[X,2],Y]
				end
			next
			eject
		end
	next
	pb_deslimp(I6LPP+I66LPP+C15CPP)
end
return NIL

*----------------------------------------------------------------------------*
function ORDP2105L()	//	Impressao Lista
if pb_ligaimp(I20CPP)
	DbGoTop()
	VM_PAG=0
	VM_LAR=160
	VM_REL='Cadastro de '+trim(PARAMORD->PA_DESCR3)
	while !eof()
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'ORDP2105A',VM_LAR)
		? pb_zer(&(fieldname(1)),6)+' '
		??pb_zer(&(fieldname(2)),5)+'-'+left(CLIENTE->CL_RAZAO,25)+' '
		??&(fieldname(3))+'-'+left(EQUIDES->ED_DESCR,38)+' '
		??left(&(fieldname(4)),50)+' ' 
		??transform(&(fieldname(5)),masc(7))+' '
		??transform(&(fieldname(6)),masc(7))
		pb_brake()
	end
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C20CPP+C15CPP)
end
return NIL

*-----------------------------------------------------------------------------*
function ORDP2105A()	//	Cabe‡alho
? 'Ordem  Cliente                         Desenho                                             Obs                                                 Dt Entr Dt Saida'
? replicate('-',VM_LAR)
return NIL


function fn_ordemant(P1,P2,P3) // Equipamento
local OBS:={},ORDANT,REGATU,X
salvabd(SALVA)
select('ORDEM')
REGATU:=recno()
ORDANT:=indexord()
dbsetorder(3)
dbseek(P1,.T.)
while !eof().and.P1==OR_CODED
	if P3#OR_CODOR
		P2:=OR_DTSAI
		OBS:={}
		for X=1 to 5
			aadd(OBS,substr(ORDEM->OR_OBS,X*60-59,60))
		end
	end
	dbskip()
end
DbGoTo(REGATU)
dbsetorder(ORDANT)
salvabd(RESTAURA)
return(OBS)
