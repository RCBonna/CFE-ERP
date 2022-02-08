*-----------------------------------------------------------------------------*
* FAZ O CONTROLE DE PARCELAMENTO DE DUPLICATAS											*
*-----------------------------------------------------------------------------*
 static aVariavP := { 0,'',.F.,0 ,'',.T.}
 //...................1..2..3...4..5..6...7..
*-----------------------------------------------------------------------------*
#xtranslate nX         => aVariavP\[  1 \]
#xtranslate nTela      => aVariavP\[  2 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
* nParc=NR PARCELAS
* P2=VALOR TOTAL LIQUIDO
* P3=NR BASICO DPL
* P4=DATA INICIAL
* P5=INICIO SEQUENCIA
* <retorna> MATRIZ COM - DOCUMENTO,DATA VENC,VALOR PARC
* <retorna> VAZIO - SE ABANDONAR

*-----------------------------------------------------------------------------*
	function FN_PARC(nParc,P2,P3,P4,P5)
*-----------------------------------------------------------------------------*
local VM_VLRT:={}
local VM_VLRP:=0
local VM_FAT :={}
local DTINI  :=P4
local GetList:={}

cTela :=savescreen(12,40)
nX    :=1

P5:=if(P5==NIL,0,P5)
aadd(VM_VLRT,P2)
VM_VLRP :=round(VM_VLRT[1]/nParc+0.001,2)
aadd(VM_VLRT,VM_VLRT[1])
for nX:=1 to nParc
	if nX==nParc
		VM_VLRP:=VM_VLRT[1]
	end
	VM_VLRT[1]-=VM_VLRP
	if PARAMETRO->PA_TPPRZ=='M' // tipo de data a prazo (M-Mes ou dias)
		P4:=addmonth(P4,1)
	else
		if nX == 1
			P4+=PARAMETRO->PA_1PGTO
		else
			P4+=PARAMETRO->PA_OPGTO
		end
	end
	aadd(VM_FAT,{P3*100+if(P5>0,P5,nX),;
					 P4,;
					 VM_VLRP})
next
salvacor(SALVA)
setcolor('B/W,W/B,,,B/W')
while .T..and.len(VM_FAT)>0
	VM_VLRT[1]:=0
	aeval(VM_FAT,{|DET|VM_VLRT[1]+=DET[3]})
	@23,42 say space(38) color 'W+/R'
	@23,56 say 'Saldo....:'+transform(VM_VLRT[1]-VM_VLRT[2],masc(5)) color 'W+/R'
	pb_msg('Press <ENTER> para alterar ou <ESC> para encerrar <DUP>',NIL,.F.)
	nX:=abrowse(12,40,22,79,VM_FAT,;
									{'Duplic','Dt. Vcto','Valor  Parcela'},;
									{      10,        10,              15},;
									{    mDPL,       mDT,         masc(2)},,'Vlr Tot:'+str(P2,9,2))
	if nX>0
		VM_DAT:= VM_FAT[nX,2]
		VM_VLR:= VM_FAT[nX,3]
		@row(),52 get VM_DAT picture masc(7) valid VM_DAT>=DTINI
		if Len(VM_FAT)>1
			@row(),66 get VM_VLR picture masc(5) valid VM_VLR>=0
		end
		read
		if lastkey()#K_ESC
			VM_FAT[nX,2]:=VM_DAT
			VM_FAT[nX,3]:=VM_VLR
			keyboard replicate(chr(K_DOWN),nX)
		end
	else
		if str(round(VM_VLRT[1]-VM_VLRT[2],2),15,2)#str(0.00,15,2)
			if pb_sn('Valor das Parcelas n„o Fechado, Abandonar ?')
				VM_FAT:={}
				exit
			end
		else
			if pb_sn('Parcelamento OK. Sair ?')
				exit
			else
				VM_FAT:={}
				exit
			end
		end
	end
end
salvacor(RESTAURA)
restscreen(12,40,,,cTela)
set cursor ON
return (VM_FAT)
*-------------------EOF-------------------------------------------*
