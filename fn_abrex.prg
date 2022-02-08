#include 'RCB.CH'

static FILTRO:=.F.

function ABREX()
	FILTRO:=.F.
if select('PARAMETRO')>0.and.;
	PARAMETRO->PA_SERFF1 .and.;
	RT_NIVEL()==2 // senha normal
	FILTRO:=.T.
	salvabd(SALVA)
	pb_msg()
	if select('DPCLI') > 0
		select('DPCLI')
		set filter to DPCLI->DR_SERIE#SCOLD
		DbGoTop()
	end
	if select('HISCLI') > 0
		select('HISCLI')
		set filter to HISCLI->HC_SERIE#SCOLD
		DbGoTop()
	end
	if select('DPFOR') > 0
		select('DPFOR')
		set filter to DPFOR->DP_SERIE#SCOLD
		DbGoTop()
	end
	if select('HISFOR') > 0
		select('HISFOR')
		set filter to HISFOR->HF_SERIE#SCOLD
		DbGoTop()
	end
	if select('PEDCAB') > 0
		select('PEDCAB')
		set filter to PEDCAB->PC_SERIE#SCOLD
		DbGoTop()
	end
	if select('ENTCAB') > 0
		select('ENTCAB')
		set filter to ENTCAB->EC_SERIE#SCOLD
		DbGoTop()
	end
	if select('PROD') > 0
		select('PROD')
		set filter to (PROD->PR_CTB#98.and.PROD->PR_CTB#97)
		DbGoTop()
	end
	if select('MOVEST') > 0
		select('MOVEST')
		set filter to MOVEST->ME_CTB#98.and.MOVEST->ME_CTB#97
		DbGoTop()
	end
	salvabd(RESTAURA)
end
return NIL

function FILMOVEST()
if FILTRO
	return(MOVEST->ME_CTB#98)
else
	return(.T.)
end

function FILPROD()
if FILTRO
	return(PROD->PR_CTB#98)
else
	return(.T.)
end

function FILDPFOR()
if FILTRO
	return(DPFOR->DP_SERIE#SCOLD)
else
	return(.T.)
end

function FILDPCLI()
if FILTRO
	return(DPCLI->DR_SERIE#SCOLD)
else
	return(.T.)
end

function FILPEDCAB()
if FILTRO
	return(PEDCAB->PC_SERIE#SCOLD)
else
	return(.T.)
end
*-----------------------------------------------------EOF-------------------------------
