*-----------------------------------------------------------------------------*
function CTBP1220()	//	Digitacao de Lotes                                    *
*								Roberto Carlos Bonanomi - Jun/93								*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'C->PARAMCTB',;
				'C->HISPAD',;
				'C->CTATIT',;
				'C->CTADET',;
				'C->CTRLOTE'})
	return NIL
end

if eof()
	DbGoTop()
end
if lastrec()==0
	beeperro()
	pb_msg("Nenhum Lote Criado. Use op‡„o 1 de crica‡„o de lotes.",1)
else
	select('CTRLOTE')
	DbGoTop()
	VM_CAMPO:=array(fcount())
	afields(VM_CAMPO)
	VM_MUSC:={      mI8,   mDT,       mUUU,         mD132,        mD132,         mD132,"Y"}
	VM_CABE:={"Nr.Lote","Data","Digitador","Vlr Tot Lote","Lcto Debito","Lcto Credito","F"}
	dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,,VM_MUSC,VM_CABE)
	if lastkey()#K_ESC
		CTBP122D() // Digitaçao
	end
end
dbcloseall()
return NIL

*---------------------------------------------------------------------*
function CTBP122D() // Digitaçao
*---------------------------------------------------------------------*
select('CTRLOTE')
pb_lin4("DIGITACAO lote "+pb_zer(CTRLOTE->CL_NRLOTE,8)+" de "+dtoc(CTRLOTE->CL_DATA),ProcName())
if reclock().and.!fn_alote(CL_NRLOTE,.F.) // Abre/criar arquivo de lotes
	return NIL
end
pb_dbedit1('CTBP122','IncluiAlteraCriticExcluiLista ')  // tela
VM_CAMPOL:=array(fcount())
afields(VM_CAMPOL)
VM_CAMPOL[5]:="FN_DBCR(LO_VALOR)"
VM_MUSC    :={   MASC_CTB,   mI4,   MASC_CTB,   mI4,              mUUU,       mUUU,mUUU,mXXX}
VM_CABE    :={    "Conta","Redz",    "Contr","Redz","Valor Lancamento","Historico","T","Docto"}
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPOL,"PB_DBEDIT2",VM_MUSC,VM_CABE)
dbcommitall()
return NIL

*---------------------------------------------------------------------* Fim
function CTBP1221() && Rotina de Inclus„o
while lastkey()#27
	dbgobottom()
	dbskip()
	CTBP1220T(.T.)
end
return NIL
*---------------------------------------------------------------------* Fim

function CTBP1222() && Rotina de Altera‡„o
CTBP1220T(.F.)
return NIL
*---------------------------------------------------------------------* Fim

function CTBP1223() && Critica
local VM_VLRD:=0,VM_VLRC:=0
DbGoTop()
while !eof()
	if LO_CONTRA==space(VM_MASTAM)    // Nao Tem Contrapartida
		VM_VLRC += if(LO_VALOR<0,abs(LO_VALOR),0)
		VM_VLRD += if(LO_VALOR>0,abs(LO_VALOR),0)
	else
		VM_VLRC += abs(LO_VALOR)
		VM_VLRD += abs(LO_VALOR)
	end
	dbskip()
end
replace 	CTRLOTE->CL_DEBITO  with VM_VLRD,;
			CTRLOTE->CL_CREDITO with VM_VLRC,;
			CTRLOTE->CL_FECHAD  with .F.

if str(VM_VLRD,15,2)==str(VM_VLRC,15,2)
	VM_VLRL:=CTRLOTE->CL_VLRLT
	if str(VM_VLRD,15,2)==str(VM_VLRL,15,2)
		pb_msg("Ok !  Lote Fechado.",2)
		replace CTRLOTE->CL_FECHAD with .T.
	else
		beeperro()
		pb_msg("Total do Lote diferente soma Lctos.",2)
	end
else
	beeperro()
	pb_msg("Total DEBITO diferente Total CREDITO.",2)
end
CTBP1220A()
pb_msg("Pressione <ENTER> para continuar.",0,.f.)
DbGoTop()
return NIL
*---------------------------------------------------------------------* Fim

function CTBP1224() && Rotina de Exclus„o
if pb_sn("Eliminar LANCTO ("+transform(LO_CONTA,VM_MUSC[1])+" Vlr $ "+alltrim(fn_dbcr(LO_VALOR))+") ?")
	fn_elimi()
	replace CTRLOTE->CL_FECHAD with .F.
end
return NIL
*---------------------------------------------------------------------* Fim

function CTBP1225 // Rotina de Impress„o
if pb_ligaimp(chr(15))
	DbGoTop()
	VM_PAG := 0
	VM_REL := "Conferencia - Lote : "+pb_zer(CTRLOTE->CL_NRLOTE,8)
	VM_LAR := 132
	VM_VLRD:=0
	VM_VLRC:=0
	VM_VLRX:=len(transform(LO_CONTA, VM_MUSC[1]))
	while !eof()
		VM_PAG:= pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,"CTBP1225A",VM_LAR,66)
		? transform(LO_CONTA, VM_MUSC[1])+space(2)
		??transform(LO_CTA,   VM_MUSC[2])+space(2)
		if LO_CONTRA # space(VM_MASTAM)
			??transform(LO_CONTRA,VM_MUSC[3])+space(2)
			??transform(LO_CTRA,  VM_MUSC[4])+space(2)
		else
			??space(VM_VLRX+8)
		end
		??fn_dbcr  (LO_VALOR)+space(2)
		??LO_HISTOR
		if LO_CONTRA==space(VM_MASTAM) && Nao Tem Contrapartida
			VM_VLRD += if(LO_VALOR>0,abs(LO_VALOR),0)
			VM_VLRC += if(LO_VALOR<0,abs(LO_VALOR),0)
		else
			VM_VLRD += abs(LO_VALOR)
			VM_VLRC += abs(LO_VALOR)
		end
		pb_brake()
 	end
	?replicate("-",VM_LAR)
	?space(24)+"Debito... "+fn_dbcr(+VM_VLRD)
	?space(24)+"Credito.. "+fn_dbcr(-VM_VLRC)
	?space(24)+"Diferenca "+fn_dbcr(VM_VLRD-VM_VLRC)
	?space(24)+"Vlr Lote  "+fn_dbcr(CTRLOTE->CL_VLRLT)
	?replicate("-",VM_LAR)
	?"Impresso as "+time()
	eject
	pb_deslimp(chr(18))
	DbGoTop()
end
return NIL

*---------------------------------------------------------------------* Fim
function CTBP1225A()
? space(45)+"DATA : "+dtoc(CTRLOTE->CL_DATA)+"   Digitador "+CTRLOTE->CL_DIGIT
??" >> Lote"+if(!CTRLOTE->CL_FECHAD," Nao","")+" Fechado."
? replicate("-",VM_LAR)
? VM_CABE[1]+space(VM_VLRX-3)+VM_CABE[2]+space(2)+VM_CABE[3]
??space(VM_VLRX-3)+VM_CABE[4]+space(4)+VM_CABE[5]+" ."+space(2)+VM_CABE[6]
? replicate("-",VM_LAR)
return NIL

*---------------------------------------------------------------------* Fim
function CTBP1220A()
pb_box(8,20,19,60)
@09,22 say "N§ Lote.....: "+pb_zer(CTRLOTE->CL_NRLOTE,8)
@10,22 say "Data Lcto...: "+dtoc(CTRLOTE->CL_DATA)
@11,22 say "Vlr do Lote.: "+transform(CTRLOTE->CL_VLRLT,masc(22))
@12,22 say "Soma Debito.: "+transform(CTRLOTE->CL_DEBITO,masc(22))
@13,22 say "Soma Credito: "+transform(CTRLOTE->CL_CREDITO,masc(22))
@14,22 say "Diferen‡a...: "+fn_dbcr(CTRLOTE->CL_CREDITO-CTRLOTE->CL_DEBITO)
@15,22 say "Digitador...: "+CTRLOTE->CL_DIGIT
@17,22 say "Status......: Lote"+if(!CTRLOTE->CL_FECHAD," N„o","")+" Fechado." color 'W+*/R'
setcolor(VM_CORPAD)
return NIL

*---------------------------------------------------------------------* Fim
function CTBP1220T (VM_FL)  && ------> TELA INC/ALT
private  VM_CONTA:=LO_CONTA,VM_CONTRA:=LO_CONTRA,VM_CTA:=LO_CTA,;
			VM_CTRA :=LO_CTRA, VM_NRHIST:=0,VM_HISTOR:=LO_HISTOR,;
			VM_VLRD :=if(VM_FL,0,if(LO_VALOR>0,+LO_VALOR,0)),;
			VM_VLRC :=if(VM_FL,0,if(LO_VALOR<0,-LO_VALOR,0))

pb_box(15,18)
@16,20 say "Conta Contabil.:" get VM_CTA    picture VM_MUSC[2] valid                  fn_ifconta(@VM_CONTA,@VM_CTA)
@17,20 say "Contrapartida..:" get VM_CTRA   picture VM_MUSC[4] valid if(VM_CTRA=0,.T.,fn_ifconta(@VM_CONTRA,@VM_CTRA).and.VM_CONTRA#VM_CONTA)
//@18,20 say "N§ Hist¢rico...:" get VM_NRHIST picture masc(12) valid if(VM_NRHIST=0,.T.,fn_ifhisto(@VM_NRHIST,@VM_HISTOR)) when VM_FL
@18,20 say "N§ Hist¢rico...:" get VM_NRHIST picture masc(12)   valid fn_codigo(@VM_NRHIST,{'HISPAD',{||HISPAD->(dbseek(str(VM_NRHIST,3)))},{||CTBP1140T(.T.)},{2,1}}).and.eval({||VM_HISTOR:=HISPAD->HP_DESCR})>='' when VM_FL
@19,20 say "Hist¢rico......:" get VM_HISTOR picture "@KXS42"   valid !empty(VM_HISTOR) when TECLAR(chr(K_END))
@20,20 say "Vlr a DEBITO...:" get VM_VLRD   picture "@E 999999999999.99" valid VM_VLRD>=0
@21,20 say "Vlr a CREDITO..:" get VM_VLRC   picture "@E 999999999999.99" valid VM_VLRC>0 when VM_VLRD=0
read
setcolor(VM_CORPAD)
if if(lastkey()#27,pb_sn(),.F.)
	VM_VLRC=if(VM_VLRD>0,+VM_VLRD,-VM_VLRC)
	if VM_FL
		dbappend(.T.)
	end
	if VM_CTRA==0
		VM_CONTRA:=space(VM_MASTAM)
	end
	replace  LO_CONTA  with VM_CONTA,;
				LO_CONTRA with VM_CONTRA,;
				LO_CTA    with VM_CTA,;
				LO_CTRA   with VM_CTRA,;
				LO_VALOR  with VM_VLRC,;
				LO_HISTOR with VM_HISTOR
	if CTRLOTE->CL_FECHAD
		replace CTRLOTE->CL_FECHAD with .F.
	end
	// dbcommitall()
end
return NIL
*---------------------------------------------------------------------* 
function TECLAR(P1)
keyboard P1
RETURN .T.
*---------------------------------------------------------------------* 
