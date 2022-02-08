*-----------------------------------------------------------------------------*
	function CotaPara() //Parametro Para cota parte
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local X
private VM_P1
private VM_CTCLP:=''
pb_lin4(_MSG_,ProcName())
if !abre({	'C->CTATIT',;
				'C->CTADET',;
				'E->COTAPA'})
	return NIL
end
if lastrec()==0
	AddRec()
end
for X:=1 to fcount()
	VM_P1 :="VM"+substr(fieldname(X),3)
	&VM_P1:=fieldget(X)
end
X:=08
pb_box(X++,4,,,,'Informe parametros de contabilizacao')
@X++,06 say '--------ENTRADA SOCIOS-(INT)----------------------------------------' color 'GR+/G'
@X++,06 say 'Subscricao......(D):' get VM_CTA01 pict mI4  valid if(VM_CTA01==0,.T.,fn_ifconta(@VM_CTCLP,@VM_CTA01))
@X++,06 say 'Subscricao......(C):' get VM_CTA02 pict mI4  valid if(VM_CTA02==0,.T.,fn_ifconta(@VM_CTCLP,@VM_CTA02))
@X++,06 say 'Historico Padrao...:' get VM_HIST1 pict mXXX

@X++,06 say '--------SAIDA SOCIOS---(QUO)---------------------------------------' color 'GR+/G'
@X++,06 say 'Baixa...........(D):' get VM_CTA03 pict mI4 valid if(VM_CTA03==0,.T.,fn_ifconta(@VM_CTCLP,@VM_CTA03))
@X++,06 say 'Baixa...........(C):' get VM_CTA04 pict mI4 valid if(VM_CTA04==0,.T.,fn_ifconta(@VM_CTCLP,@VM_CTA04))
@X++,06 say 'Historico Padrao...:' get VM_HIST2 pict mXXX

@X++,06 say '--------SOBRAS---------(SOB)---------------------------------------' color 'GR+/G'
@X++,06 say 'Distribuicao AGO(D):' get VM_CTA05 pict mI4 valid if(VM_CTA05==0,.T.,fn_ifconta(@VM_CTCLP,@VM_CTA05))
@X++,06 say 'Sobra Distrib.. (C):' get VM_CTA06 pict mI4 valid if(VM_CTA06==0,.T.,fn_ifconta(@VM_CTCLP,@VM_CTA06))
@X++,06 say 'Historico Padrao...:' get VM_HIST3 pict mXXX

read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	for X:=1 to fcount()
		VM_P1:="VM"+substr(fieldname(X),3)
		replace &(fieldname(X)) with &VM_P1
	end
end
dbcloseall()
return NIL
*-------------------------------------[EOF]----------------------------------------*
