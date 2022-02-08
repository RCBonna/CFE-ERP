*-----------------------------------------------------------------------------*
*   ARQUIVOS BASICOS DE CONTROLE DE MODELOS												*

 static aVariav := {0,0,0,'',''}
 //.................1.2.3,.4..5
*---------------------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate nY         => aVariav\[  2 \]
#xtranslate nZ         => aVariav\[  3 \]
#xtranslate _TF        => aVariav\[  4 \]
#xtranslate _DESCR     => aVariav\[  5 \]

*-----------------------------------------------------------------------------*
#include 'RCB.CH'

*-----------------------------------------------------------------------------*
function FN_ARQS(P1)
*-----------------------------------------------------------------------------*

local OPC
private X:=1
private ARQUIVOS:={}
aeval(directory('*.'+P1,'D'),{|ELEM|aadd(ARQUIVOS,{ELEM[1],X++})})
aadd(ARQUIVOS,{'Novo Arquivo',0})
	@14,59 say '[Modelos Dispon¡veis]' color 'R/W'
	OPC:=0
	while OPC==0
		OPC  :=abrowse(15,59,22,79,ARQUIVOS,{'Nome Modelo','Sq'},{12,2},{masc(1),masc(11)})
		if OPC==len(ARQUIVOS)
			fn_edita(P1,OPC)
		end
	end
	if OPC>0.and.ARQUIVOS[OPC,2]>0
		public VM_VETOR:={}
		VM_VETOR:=restarray(ARQUIVOS[OPC,1])
	elseif OPC>0.and.ARQUIVOS[OPC,2]=0
	end
	VM_VETOR[1,1]:=ARQUIVOS[OPC,1]

if pb_sn('Mudar parametros ('+VM_VETOR[1,1]+') do Lay-Out')
*-----------------------------------------------------------------------------*
	pb_box()
	pb_msg('Preencha os campos de '+VM_VETOR[1,1],NIL,.F.)
	VM_LIN       :=VM_VETOR[1,4]
	VM_VETOR[1,8]:=padr(VM_VETOR[1,8],2)
	@06,02 say 'Informe NOME do modelo...:' get VM_VETOR[1,2] pict masc(01) valid !empty(VM_VETOR[1,2])
	@07,02 say 'N§ Fileiras de...........:' get VM_VETOR[1,3] pict masc(11) valid VM_VETOR[1,3]>0
	@08,02 say 'N§ Linhas................:' get VM_VETOR[1,4] pict masc(11) valid VM_VETOR[1,4]>0
	@09,02 say 'N§ Col.separa‡„o (Horiz).:' get VM_VETOR[1,5] pict masc(11) valid VM_VETOR[1,5]>=0
	@10,02 say 'N§ Lin.separa‡„o (Vertic):' get VM_VETOR[1,6] pict masc(11) valid VM_VETOR[1,6]>=0
	@11,02 say 'N§ Colunas...............:' get VM_VETOR[1,7] pict masc(04) valid VM_VETOR[1,7]>=5
	@11,36                                  get VM_VETOR[1,8] pict masc(01) valid VM_VETOR[1,8]+'ú'$'C úC6úC8úN úN6úN8úS úS6úS8úS?ú'
	@11,38 say ':.[C]ondensado(15) [N]ormal [S]SuperCond'
	read
	setcolor(VM_CORPAD)
	if lastkey()#K_ESC
		for X:=1 to VM_VETOR[1,4]
			if len(VM_VETOR[2])<X
				aadd(VM_VETOR[2],{' ',0})
			end
			VM_VETOR[2,X,1]:=padr(VM_VETOR[2,X,1],VM_VETOR[1,7])
			VM_VETOR[2,X,2]:=pb_zer(X,2)
		next
		asize(VM_VETOR[2],VM_VETOR[1,4])
		pb_msg('[Informe LayOut use F1]',NIL,.F.)
		while lastkey()#27
			X:=abrowse(12,0,22,79,VM_VETOR[2],;
										{'Campos','Li'},;
										{     75,   2},;
										{masc(1),masc(1)})
			if X>0
				VM_LIN:=VM_VETOR[2,X,1]
				set key K_ALT_W to fn_copial()
				@row(),1 get VM_LIN pict masc(1)+'S75'
				read
				set key K_ALT_W to
				if lastkey()#27
					VM_VETOR[2,X,1]:=VM_LIN
					keyboard replicate(chr(K_DOWN),X)
				end
			end
		end
		savearray(VM_VETOR,VM_VETOR[1,1])
	else
		OPC:=0
	end
end
return OPC

*-----------------------------------------------------------------------------*
 function FN_COPIAL() // Inclusao
*-----------------------------------------------------------------------------*
local I,I1,I2
if X>1
	VM_LIN:=VM_VETOR[2,X-1,1]
	for I:=1 to len(VM_LIN)
		I1:=substr(VM_LIN,I,2)
		if I1$'01.02.03.04.05.06.07.08.09.10.11.12.13.14.15.16.17.18.19'
			I1:=pb_zer(val(I1)+1,2)
		end
		VM_LIN:=posrepl(VM_LIN,I1,I)
	next
	aeval(GETLIST,{|DET|DET:display()})
end
return NIL

*-----------------------------------------------------------------------------*
 function FN_EDITA(P1,P2) // Inclusao
*-----------------------------------------------------------------------------*
_DESCR:=space(8)
_TF   :=savescreen(22,0,24,79)
pb_msg('Use ate 8 caracteres para nome do documento.',NIL,.F.)
@22,69 say '.'+P1
@22,61 get _DESCR valid len(_DESCR)>0
read
if lastkey()#K_ESC
	ARQUIVOS[P2,1]:=trim(_DESCR)+'.'+P1
end
restscreen(22,0,24,79,_TF)
return NIL

*-----------------------------------------------------------------------------*
 function FN_IMPETI(VM_P2,VM_P5,VM_P6) // IMPRESSAO DA ETIQUETA
*-----------------------------------------------------------------------------*
for nX:=1 to len(VM_P2)	//	VM_P3
	nZ:=''
	for nY:=1 to if(valtype(VM_P2[nX])='A',len(VM_P2[nX]),1)		//	VM_P4
		nZ+=VM_P2[nX,nY]+space(VM_P5)
	next
	?trim(nZ)
next
for nY:=1 to VM_P6
	?
next
return NIL
//---------------------end of file