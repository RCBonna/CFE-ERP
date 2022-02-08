//-----------------------------------------------------------------------------*
  function CFEPIMNF() // IMPRESSAO NF
//-----------------------------------------------------------------------------*
#include 'RCB.CH'
local ORD      :=0
local VM_VETOR
local VM_VARAMB:=upper(getenv('CFE'))
local SERIE    :=VM_SERIE
if empty(SERIE)
	SERIE:='PADRAO'
else
	SERIE:=trim(SERIE)
end
SERIE+='.NFS'
VM_VETOR:=restarray(SERIE) // Modelo
if len(VM_VETOR)==0.or.!file(SERIE)
	beeperro()
	alert('M scara da Nota Fiscal ('+SERIE+') n„o encontrado')
	return(.F.)
end

if !file('CODIGOS.ARR')
	beeperro()
	alert('Falta Arquivo CODIGOS.ARR.;Nota Fiscal n„o pode ser Impressa.')
	return(.F.)
end

while !pb_ligaimp(RST+CHR(27)+CHR(67)+chr(VM_VETOR[1,4]),,'Nota Fiscal')
	if pb_sn('Voce quer abandonar a impress„o?')
		pb_deslimp(chr(27)+chr(67)+chr(66)+C20CPP+C15CPP)
		return(.F.)
	end
end
	if left(VM_VETOR[1,8],1)=='N'
		??C15CPP
	elseif left(VM_VETOR[1,8],1)=='C'
		??I15CPP
	elseif left(VM_VETOR[1,8],1)=='S'
		??I20CPP
	end
	if right(VM_VETOR[1,8],1)=='6'
		??I6LPP
	elseif right(VM_VETOR[1,8],1)=='8'
		??I8LPP
	end

	XENT    :=' '
	XSAI    :='X'
	VM_LINHA:=array(VM_VETOR[1,4],VM_VETOR[1,3])
	DT1     :=time()
	for X:=1 to VM_VETOR[1,4]
		if 'CLINOME'$VM_VETOR[2,X,1].and.'CLIENTE NOMINAL'$CLIENTE->CL_RAZAO
			VM_VETOR[2,X,1]:=strtran(VM_VETOR[2,X,1],'CLINOME',VM_NOMEC)
		end
		VM_LINHA[X,1]:=padr(CFEPCODI(VM_VETOR[2,X,1]),VM_VETOR[1,7])
	next
	FN_IMPETI(VM_LINHA,VM_VETOR[1,6],VM_VETOR[1,5])
	pb_deslimp(chr(27)+chr(67)+chr(66)+C15CPP+I6LPP)
	setprc(1,1)
return(.T.)
//-------------------------------------------------------------EOF
