#include 'SIXNSX.CH'
#include 'MACHSIX.CH'

function DUMPS()

local ARQ:={},LOCAL:='TEMPNEW',X
clear
ARQ :=directory('*.DB?')
filedelete('*.NSX')
filedelete('*.NTX')
dirmake(LOCAL)
for X:=1 to len(ARQ)
	?'Copiando arquivo '+ARQ[X,1]
	??filecopy(ARQ[X,1],LOCAL+'\'+ARQ[X,1])
	ferase(ARQ[X,1])
next
for X:=1 to len(ARQ)
	if .NOT. '.DBT'$upper(ARQ[X,1])
		?'processando arquivo '+ARQ[X,1]
		dbusearea(.T.,RDDSETDEFAULT(),LOCAL+'\'+ARQ[X,1],'TEMPO',.T.,.F.)
		??lastrec()
	 	COPY TO (ARQ[X,1]) VIA RDDSETDEFAULT()
		close
	end
next
return NIL
