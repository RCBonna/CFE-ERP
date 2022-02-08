*----------------------------------------------------------------------------
  function FISP0001()	// integra dados para REGISTRO DE APURACAO
*----------------------------------------------------------------------------
#include 'RCB.CH'
pb_lin4(_MSG_,ProcName())
	if !abre({	'C->PARAMETRO',;
					'R->NATOP',;
					'R->PARAMCTB',;
					'R->PROD',;
					'R->ENTCAB',;
					'R->CLIENTE',;
					'R->PEDCAB',;
					'R->PEDDET',;
					'R->ENTDET',;
					'E->FISPARA',;
					'E->FISRAPU'})
		return NIL
	end
PERIODO:=left(dtos(bom(PARAMETRO->PA_DATA)-1),6)

//if !empty(FISPARA->PA_PERINT)
//	PERIODO:=FISPARA->PA_PERINT
//end

pb_box(18,30,,,,'Selecione')
@20,32 say 'Periodo a Integrar.:' get PERIODO pict mPER valid fn_period(PERIODO)
read
if lastkey()#K_ESC
	if FISPARA->(lastrec())<1
		FISPARA->(AddRec())
		replace FISPARA->PA_PERINT with PERIODO
	end
*----------------------------------------------------------------------------*
	pb_msg('1/5-Preparando ...')
*----------------------------------------------------------------------------*
	select('FISRAPU')
	DbGoTop()
	dbeval({||dbdelete()},{||FISRAPU->RA_PERIOD==PERIODO})
	DbGoTop()
	
		select('PROD')
		ordem CODIGO
*----------------------------------------------------------------------------*
		pb_msg('2/5-Processando entradas...')
*----------------------------------------------------------------------------*
		select('ENTCAB')
		ordem DTEDOC	//DATA+DOCTO
		set relation to str(EC_CODOP,7) into NATOP
		DbGoTop()
		dbseek(PERIODO,.T.)
		dbeval({||FISP0001A()},	{||NATOP->NO_ILIVRO},;
										{||left(dtos(EC_DTENT),6)==PERIODO.and.;
									 	 pb_brake(.T.)})
		set relation to
*----------------------------------------------------------------------------*
		pb_msg('3/5-Processando saidas...')
*----------------------------------------------------------------------------*
		select('PEDCAB')
		ordem DTENNF	// DATA+NR NF
		set relation to str(PC_CODOP,7) into NATOP
		DbGoTop()
		dbseek(PERIODO,.T.)
		dbeval({||FISP0001B()},	{||NATOP->NO_ILIVRO.AND.PC_FLAG.AND.!PC_FLCAN},;
										{||left(dtos(PEDCAB->PC_DTEMI),6)==PERIODO.and.;
		                       	pb_brake(.T.)})
		set relation to

*----------------------------------------------------------------------------*
		pb_msg('4/5-Processando Dados do SAG..')
*----------------------------------------------------------------------------*
		if file('..\SAG\SAGANFC.DBF').and.file('..\SAG\SAGANFD.DBF').and.!file('CFE.PRG')
			if !abre({	;
							'R->NFD',;
							'R->NFC';
							})
				alert('Deve ser executado novamente....')
				dbcloseall()
				return NIL
			else
				select NFD
				ORDEM CODIGO
				select NFC
				ORDEM DATA
//				set relation to str(NF_CODOP,7) into NATOP // não é necessário há um dbseek abaixo
				DbGoTop()
				dbseek(PERIODO,.T.)
				while !eof().and.left(dtos(NF_DTEMI),6)==PERIODO
					FISP0001C()
					skip
				end
				set relation to
			end
		end
*----------------------------------------------------------------------------*
		pb_msg('5/5-Finalizando..')
*----------------------------------------------------------------------------*
	// Finaliza compactando o arquivo
	select('FISRAPU')
	pack
	DbGoTop()
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function FISP0001A()	// ENTRADAS
*-----------------------------------------------------------------------------*
local CODOPE:=str(ENTCAB->EC_CODOP,7)
@24,60 say dtoc(EC_DTENT)
NATOP->(dbseek(CODOPE))
salvabd(SALVA)
select('FISRAPU')
if !dbseek(PERIODO+left(CODOPE,5))
	AddRec()
	replace  RA_PERIOD with PERIODO,;
				RA_CODOPE with left(CODOPE,5)
end

replace 	RA_VLRCTB with RA_VLRCTB+(ENTCAB->EC_TOTAL-ENTCAB->EC_DESC+ENTCAB->EC_ACESS),;
			RA_VLRBAS with RA_VLRBAS+(ENTCAB->EC_ICMSB),;
			RA_VLRIMP with RA_VLRIMP+(ENTCAB->EC_ICMSV),;
			RA_VLRISE with RA_VLRISE+(ENTCAB->EC_TOTAL-ENTCAB->EC_DESC-ENTCAB->EC_ICMSB)
salvabd(RESTAURA)
return NIL

*-----------------------------------------------------------------------------*
function FISP0001B()	// SAIDAS
*-----------------------------------------------------------------------------*
local VICMS :=fn_nfsoma(PEDCAB->PC_PEDID,{PC_TOTAL,PC_DESC,NATOP->NO_CDVLFI})
local CODOPE:=str(PEDCAB->PC_CODOP,7)
local X
@24,60 say dtoc(PEDCAB->PC_DTEMI)
SALVABANCO
select('FISRAPU')
if !dbseek(PERIODO+left(CODOPE,5))
	AddRec()
	replace  RA_PERIOD with PERIODO,;
				RA_CODOPE with left(CODOPE,5)
end
for X:=1 to len(VICMS)
	if Str(VICMS[X,2]+VICMS[X,3]+VICMS[X,4],15,2)#Str(0,15,2)
		replace 	RA_VLRCTB with RA_VLRCTB+abs(VICMS[X,2]),;
					RA_VLRBAS with RA_VLRBAS+abs(VICMS[X,3]),;
					RA_VLRIMP with RA_VLRIMP+abs(VICMS[X,4]),;
					RA_VLRISE with RA_VLRISE+abs(VICMS[X,2]-VICMS[X,3])
	end
next
RESTAURABANCO
return NIL

*-----------------------------------------------------------------------------*
function FISP0001C()	// SAG-ENTRADAS/SAIDAS
*-----------------------------------------------------------------------------*
local Linha :=fn_lenfd(NFC->NF_TIPO+NFC->NF_SERIE+str(NFC->NF_NRNF,6))
local CODOPE:=str(NFC->NF_CODOP,7)
local X
@24,60 say NFC->NF_TIPO+NFC->NF_SERIE+str(NFC->NF_NRNF,6)
SALVABANCO
select('FISRAPU')
if !dbseek(PERIODO+left(CODOPE,5))
	AddRec()
	replace  RA_PERIOD with PERIODO,;
				RA_CODOPE with left(CODOPE,5)
end

for X:=1 to len(Linha)
	if Str(Linha[X,3]+Linha[X,4]+Linha[X,5]+Linha[X,6]+Linha[X,6]+Linha[X,7],15,2)#Str(0,15,2)
		replace 	RA_VLRCTB with RA_VLRCTB+abs(Linha[X,3]),;
					RA_VLRBAS with RA_VLRBAS+abs(Linha[X,4]),;
					RA_VLRIMP with RA_VLRIMP+abs(Linha[X,5]),;
					RA_VLRISE with RA_VLRISE+abs(Linha[X,6]),;
					RA_VLROUT with RA_VLROUT+abs(Linha[X,7])
	end
next
RESTAURABANCO
return NIL


*-------------------------------------------------------------
	function FN_LENFD(P1)
*-------------------------------------------------------------
local RT:={}
local X
local Y
SALVABANCO
select NFD
dbseek(P1,.T.)
while !eof().and.P1==ND_TIPO+ND_SERIE+str(ND_NRNF,6)
	if NATOP->(dbseek(str(NFD->ND_CODOP,7))).and.NATOP->NO_ILIVRO // CONSIDERAR NO LIVRO
		Y:=0
		for X:=1 to len(RT)
			if RT[X,1]          == Left(str(NFD->ND_CODOP,7),5) .and.;
				Str(RT[X,2],7,2) == Str(NFD->ND_PERICMS,7,2)
				Y:=X
				X:=len(RT)+1
			end
		next
		if Y==0
			aadd(RT,{Left(str(ND_CODOP,7),5),;	// 1-Natureza só com 5 digitos -> Caractere
						ND_PERICMS,;//	2-% Icms
						0,;			// 3-Vlr Total
						0,;			//	4-Base Icms
						0,;			//	5-Vlr Icms
						0,;			// 6-Isentas
						0; 			//	7-Outras
						})
			Y:=len(RT)
		end
		RT[Y,3]+=ND_VLRTOT
		if NATOP->NO_CDVLFI == 1		// com credito imposto
			RT[Y,4]+=ND_BASICMS
			RT[Y,5]+=ND_VLRICMS
			RT[Y,6]+=max(ND_VLRTOT - ND_BASICMS, 0) // parte isenta com imposto
			RT[Y,7]+=0
		elseif NATOP->NO_CDVLFI == 2	// sem credito - isentas ou não tributadas
			RT[Y,4]+=0
			RT[Y,5]+=0
			RT[Y,6]+=ND_VLRTOT
			RT[Y,7]+=0
		elseif NATOP->NO_CDVLFI == 3	// sem credito - outras
			RT[Y,4]+=0
			RT[Y,5]+=0
			RT[Y,6]+=0
			RT[Y,7]+=ND_VLRTOT
		end
	else
		alert('Natureza : '+str(NFD->ND_CODOP,7)+' NF Detalha;Nao encontrada :'+str(ND_NRNF,6))
	end
	pb_brake()
end
RESTAURABANCO
return RT
//------------------------------------------------------------EOF
