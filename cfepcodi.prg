*-----------------------------------------------------------------------------------*
* INICIALIZACAO DOS CODIGOS PARA SUBSTITUICAO NF/BOLETOS/ETIQUETAS						*
*-----------------------------------------------------------------------------------*
static CPO :={}
static CPOE:={}
#include 'RCB.CH'

*-----------------------------------------------------------------------------------*
 INIT PROCEDURE ARRAY_CO		//																		*
*-----------------------------------------------------------------------------------*
if !file('CODIGOS.ARR')
	alert('Arquivo CODIGOS.ARR n„o encontrado. < Impress„o N.F.=S >') 
else
	CPO :=restarray('CODIGOS.ARR')
end
if !file('CODIGOE.ARR')
	alert('Arquivo CODIGOS.ARR n„o encontrado. < Impress„o N.F.=E >') 
else
	CPOE:=restarray('CODIGOE.ARR')
end
return NIL

*-----------------------------------------------------------------------------------*
 function CFEPCODI(P1) // Transformacao de codigos												*
*-----------------------------------------------------------------------------------*
if !empty(P1)
	aeval(CPO,{|ELEM|P1:=if(at(ELEM[1],P1)>0,strtran(P1,ELEM[1],XXX(ELEM[2])),P1)})
end
return(P1)

*-----------------------------------------------------------------------------------*
 function CFEPCODE(P1) // Transformacao de codigos												*
*-----------------------------------------------------------------------------------*
if !empty(P1)
	aeval(CPOE,{|ELEM|P1:=if(at(ELEM[1],P1)>0,strtran(P1,ELEM[1],XXX(ELEM[2])),P1)})
end
return(P1)

*-----------------------------------------------------------------------------------*
 static function XXX(P1)	//																			*
*-----------------------------------------------------------------------------------*
gxxx(allTRIM(P1)+chr(10)+chr(13),'\temp\CtrlNF.txt',.t.)
return(&P1)

*-----------------------------------------------------------------------------------*
static function gXXX(P1,P2)	//																		*
*-----------------------------------------------------------------------------------*
local hd:=0
if !file(P2)
	hd:=fcreate(P2)
	fclose(hd)
end
hd:=fopen(P2,2)
FSEEK(hd,0,2)
fwrite(hd,P1,len(p1))
fclose(hd)
return nil
*-------------------------------------------EOF-------------------------------------*
