*---------------------------------------------------* PARAMETROS GERAIS
 function ParaLinh(P1)
*---------------------------------------------------* PARAMETROS GERAIS
#include 'RCB.CH'

local ARQ:='PARALINH'
if dbatual(ARQ,;
				{{'PL_CODIGO', 'C', 20,  0},;	// 01 Codigo
				 {'PL_INFO',   'C',200,  0},;	// 02 Informação
				 {'PL_TIPO',   'C',  1,  0}},;// 03 Numero/Caracter
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
ParaLinhX(P1)
return NIL

*---------------------------------------------------* PARAMETROS Gerais-cria indice
 function ParaLinhX(P1)
*---------------------------------------------------* PARAMETROS GERAIS
local ARQ:='PARALINH'
if !file(ARQ+OrdBagExt()).or.P1
	pb_msg('Reorg. Parametro/Linha',NIL,.F.)
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		index on PL_CODIGO tag ID to (Arq) eval {||ODOMETRO('ParamLin')}
		close
	end
end
return NIL

//-----------------------------------------------------------------------
  function PLinha(P1,P2,P3)
//-----------------------------------------------------------------------
local RT
SALVABANCO
select PARALINH
if dbseek(upper(padr(P1,20)))
	RT:=if(PL_TIPO=='N',val(PL_INFO),PL_INFO)
else
	if P3==NIL
		P3:='C'
		if ValType(P2)=='N'
			P3:='N'
		end
	end
	if P3=='N'
		P2:=str(P2)
	end
	AddRec(,{upper(P1),P2,P3})
	RT:=P2
	if P3=='N'
		RT:=val(P2)
	end
end
RESTAURABANCO
return RT

*-----------------------------------------------------------------------
  function RLinha(P1)
*-----------------------------------------------------------------------
local RT:=''
SALVABANCO
select PARALINH
if dbseek(upper(padr(P1,20)))
	RT:=if(PL_TIPO=='N',val(PL_INFO),trim(PL_INFO))
end
RESTAURABANCO
return RT

*-----------------------------------------------------------------------
  function SLinha(P1,P2)
*-----------------------------------------------------------------------
local RT:=''
SALVABANCO
select PARALINH
if dbseek(upper(padr(P1,20)))
	if RecLock()
		replace PL_INFO with if(PL_TIPO=='N',str(P2),P2)
	end
else
	alert('Nao Encontrado  :'+P1)
end
RESTAURABANCO
return RT
*-----------------------------------------EOF-----------------------------