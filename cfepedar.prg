*-----------------------------------------------------------------------------*
function CFEPEDAR()	// Editor de tabelas de array										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

private VM_OPC,OPC:=X:=1,Y,CABEC:=MASC1:=TAMAN:=ARQUIVOS:={}
private VETOR
pb_lin4(_MSG_,ProcName())
aeval(directory('*.ARR','D'),{|ELEM|aadd(ARQUIVOS,{ELEM[1],X++})})
if len(ARQUIVOS)>0
	@12,59 say '[Arquivos Dispon¡veis]' color 'R/W'
	pb_msg('Selecione um arquivo.',NIL,.F.)
	ARQUIVOS:=aeval(ARQUIVOS,{|DET|DET[1]:=Upper(DET[1])})
	ARQUIVOS:=asort(ARQUIVOS,,,{|DET,OPC|DET[1]<OPC[1]})
	OPC:=0
	while OPC==0
		OPC:=abrowse(13,59,22,79,ARQUIVOS,{'Nome Arquivo','Sq'},{12,2},{masc(1),masc(11)})
	end

	VETOR:=restarray(ARQUIVOS[OPC,1])

	TAMAN:={0,0}
	if ARQUIVOS[OPC,1]='ESTOQUE.ARR'
		CABEC:={'Cd',    'Descricao','Sped'}
		MASC1:={masc(11),masc(01),     mI2 }
		TAMAN:={2       ,25            ,4  }
		
		if len(VETOR[1])=2
			for X:=1 to len(VETOR)
				aadd(VETOR[X],1)
			next
		end

	elseif ARQUIVOS[OPC,1]='TP_SERIE.ARR'
		CABEC:={'Cod.NF','Descri‡„o','NrLIN','Transp','Fatura','MODELO'}
		MASC1:={masc(1) ,masc(1)    , masc(11),masc(1),masc(1), masc(1)}
		TAMAN:={10      ,12         , 5,      6 ,        7,     6}
	
	elseif ARQUIVOS[OPC,1]='TP_DOCTO.ARR'
		CABEC:={'TP'   ,'Descricao'}
		MASC1:={masc(1),mXXX   }
		TAMAN:={3      ,     22   }
		AADD(VETOR,{Space(3),Space(20)})
	
	elseif ARQUIVOS[OPC,1]='TIPOCLI.ARR'.or.ARQUIVOS[OPC,1]='TIPOFOR.ARR'
		CABEC:={'Cd',    'Descricao'}
		MASC1:={masc(11),masc(01)}
		TAMAN:={2       ,25      }
	
	elseif ARQUIVOS[OPC,1]='CODIGOS.ARR'
		CABEC:={'MSimbolo', 'Macro Substitui‡„o'}
		MASC1:={masc(01),masc(01)+'S55'}
		TAMAN:={10      ,55}
	
	end
else
	pb_msg('Nenhum arquivo encontrado.',5,.T.)
	return NIL
end
if saepedare(CABEC,TAMAN,MASC1,ARQUIVOS[OPC,1])
	savearray(VETOR,ARQUIVOS[OPC,1])
end
return NIL

*-----------------------------------------------------------------------------*
function SAEPEDARE(CABEC,TAMAN,MASC1,NOME)
*-----------------------------------------------------------------------------*
local VM_FLAG:=.F.,VM_OPC,Y,X,getlist:={}

while lastkey()#K_ESC.and.TAMAN[1]>0

	pb_msg('Selecione um item e press <Enter> ou <ESC> para sair.',NIL,.F.)
	salvacor(SALVA)
	setcolor('W+/R')
	Y:=len(TAMAN)*2
	aeval(TAMAN,{|DET|Y+=DET})
	@8,79-Y say padc(NOME,Y+1) color 'W+*/R'
	VM_OPC:=abrowse(9,79-Y,22,79,VETOR,CABEC,TAMAN,MASC1)
	if VM_OPC>0
		pb_box(21-len(TAMAN),8)
		for X=1 to len(TAMAN)
			Y='VETOR['+pb_zer(VM_OPC,3)+','+pb_zer(X,3)+']'
 			@21-len(TAMAN)+X,10 say padr(CABEC[X],15,'.')
			if if(valtype(&Y)='C',left(&Y,1)#'#',.T.)
 				@21-len(TAMAN)+X,25 get &Y picture MASC1[X]
			else
 				@21-len(TAMAN)+X,25 say &Y picture MASC1[X]
			end
		next
		read
		VM_FLAG:=.T.
	end
	salvacor(RESTAURA)
end
return VM_FLAG
//----------------------------------------------------------EOF-------------------------
