#include 'RCB.CH'
#include 'ENTRADA.CH'

static VM_SNSU  :=0
static VM_KEYNFE:=0
*-----------------------------------------------------------------------------*
function CFEP441I(OBS) // Impressao Nota Fiscal
*-----------------------------------------------------------------------------*
local RT       :=.F.
default OBS to {space(300),''}
VM_NSU         := 0
setKeyNFE() 		// VM_KEYNFE      :=padr('0',44,'0')
VM_OBS			:=padr(OBS[1],300)

CLIENTE->(dbseek(str(DADOC[NFOR],5)))
if pb_sn('ATENCAO;Voce vai imprimir a NOTA FISCAL ENTRADA?;Fornecedor:'+str(DADOC[NFOR],5)+'-'+trim(CLIENTE->CL_RAZAO))
	VM_OBS :=padr(OBS[1],300)
	VM_OBSP:=padr(OBS[2],250)
	if empty(VM_OBS)
		pb_box(20,0,,,,'Observacao')
		set function 10 to '+'+chr(13)
		pb_msg('Preencha o rodapé do PEDIDO, ou <ESC> para cancelar. F10 para OBS',NIL,.F.)
		@21,01 get VM_OBS   pict masc(1)+'S78' valid fn_obs(@VM_OBS)
		read
		set function 10 to
	end
	if lastkey()#K_ESC
		VM_NSU :=fn_psnf("NSU")//............................Busca um número
		if DADOC[SERIE]=='NFE'
			RT:=FISPNFEP()	//.................................GERAR XML
		else
			I_TRANS:=CFEPTRANE(I_TRANS,.F.,'E')	// Edita Transportador da NF de entrada sem editar Peso/Marca/Qtd L/B/Especie
			RT     :=CFEPIMNFE(DADOC[SERIE])		// Rot Impressao ENTRADAS PAPEL
		end
		if !RT
			fn_backnf("NSU",VM_NSU)//.........................Retorna se não deu certo
		end
	end
end
VM_SNSU :=VM_NSU
return ({RT,VM_OBS})

*-----------------------------------------------------------------------------*
function RT_NSU() // RETORNA - NSU															*
*-----------------------------------------------------------------------------*
return(VM_SNSU)

*-----------------------------------------------------------------------------*
 static function CFEPIMNFE(pSerie) // IMPRESSAO NF											*
*-----------------------------------------------------------------------------*
local ORD:=0
local X
local VM_VETOR
local VSERIE:=pSerie
if empty(VSERIE)
	VSERIE:='PADRAO'
else
	VSERIE:=trim(VSERIE)
end
VSERIE  +='.NFS'
VM_VETOR:=restarray(VSERIE)

if len(VM_VETOR)=0
	beeperro()
	alert('Máscara da Nota Fiscal ('+VSERIE+') näo encontrado')
	return(.F.)
end
if !file('CODIGOE.ARR')
	beeperro()
	alert('Falta Arquivo CODIGOE.ARR.;Nota Fiscal näo pode ser Impressa.')
	return(.F.)
end

while !pb_ligaimp(RST+CHR(27)+CHR(67)+chr(VM_VETOR[1,4])+C15CPP)
	if pb_sn('Voce quer abandonar a impressäo?')
		pb_deslimp(chr(27)+chr(67)+chr(66)+C15CPP)
		return(.F.)
	end
end

	VM_LINHA:=array(VM_VETOR[1,4],VM_VETOR[1,3])
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

	aeval(VM_LINHA,{|ELEM|afill(ELEM,replicate('*',VM_VETOR[1,7]))})
	DT1  :=time()
	XENT :='X'
	XSAI :=' '
	for X:=1 to VM_VETOR[1,4]
		VM_LINHA[X,1]:=padr(CFEPCODE(VM_VETOR[2,X,1]),VM_VETOR[1,7])
	next
	FN_IMPETI(VM_LINHA,VM_VETOR[1,6],VM_VETOR[1,5])
	pb_deslimp(chr(27)+chr(67)+chr(66)+C15CPP+I6LPP)

return(.T.)
