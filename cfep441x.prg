#include 'ACHOICE.CH'
#include 'RCB.CH'

#define POSPROD  1
#define POSQTDE 33
#define POSIPI  42
#define POSVLRM 54
#define POSVLRV 66

*------------------------------------------ACHOICE REF.FRETE PARCELADO
function CFEP4411A(VM_MODO,VM_ELEM,VM_POS)

local VM_RT:=AC_CONT // Resposta default do include achoice
local VM_TECLA:=lastkey(),VM_TF
if VM_MODO==AC_HITTOP        // Tentativa de subir alem do top
	tone(200,3)
elseif VM_MODO==AC_HITBOTTOM // Tentativa de decer alem do fim
	tone(100,3)
elseif VM_MODO==AC_EXCEPT    // Teclado algo

	if VM_TECLA==K_ENTER.and.VM_ELEM=len(VM_FRETE)
		VM_RT=AC_SELECT

	elseif VM_TECLA==K_ENTER.and.VM_ELEM<len(VM_FRETE)
		VM_DPF   = val (substr(VM_FRETE[VM_ELEM],01,08))
		VM_DTF   = ctod(substr(VM_FRETE[VM_ELEM],14,08))
		VM_VLF   = val (substr(VM_FRETE[VM_ELEM],26,12))
		@row(),01 get VM_DPF picture masc(9) valid VM_DPF>0
		@row(),14 get VM_DTF picture masc(7) valid VM_DTF>=PARAMETRO->PA_DATA
		@row(),26 get VM_VLF picture masc(5) valid VM_VLF>0
		read
		if lastkey()#K_ESC
			VM_FECHA-=val(substr(VM_FRETE[VM_ELEM],26,12))
			VM_FRETE[VM_ELEM]=str(VM_DPF,8)+space(5)+dtoc(VM_DTF)+space(4)+str(VM_VLF,12,2)
			VM_FECHA+=VM_VLF
		end

	elseif VM_TECLA==K_INS
		VM_TF=savescreen()
		scroll(row(),02,21,38,-1)
		VM_DPF = 0
		VM_DTF = ctod('')
		VM_VLF = 0
		@row(),01 get VM_DPF picture masc(9) valid VM_DPF>0
		@row(),14 get VM_DTF picture masc(7) valid VM_DTF>=PARAMETRO->PA_DATA
		@row(),26 get VM_VLF picture masc(5) valid VM_VLF>0
		read
		if lastkey()#K_ESC		
			asize(VM_FRETE,len(VM_FRETE)+1)
			ains(VM_FRETE,VM_ELEM)
			VM_FRETE[VM_ELEM]=pb_zer(VM_DPF,8)+space(5)+dtoc(VM_DTF)+space(4)+str(VM_VLF,12,2)
			VM_FECHA+=VM_VLF
			VM_RT=AC_SELECT
		else
			restscreen(,,,,VM_TF)
		end
		
	elseif VM_TECLA==K_DEL
		VM_VLFRE-=val (substr(VM_FRETE[VM_ELEM],26,12))
		adel(VM_FRETE,VM_ELEM)
		asize(VM_FRETE,len(VM_FRETE)-1)
		VM_RT=AC_SELECT
	end
	@22,14 say 'Restante...:'+transform(VM_VLRFAT[1]-VM_FECHA,masc(5))
end
return VM_RT

*--------------------------------------------------------NF PARCELADO
function CFEP4411B(VM_MODO,VM_ELEM,VM_POS)

local VM_RT:=AC_CONT // Resposta default do include achoice
local VM_TECLA:=lastkey(),VM_TF

if VM_MODO==AC_HITTOP        // Tentativa de subir alem do top
	tone(200,3)
elseif VM_MODO==AC_HITBOTTOM // Tentativa de decer alem do fim
	tone(100,3)
elseif VM_MODO==AC_EXCEPT    // Teclado algo
	if VM_TECLA==K_ENTER.and.VM_ELEM=len(VM_DUPLI)
		VM_RT=AC_SELECT // finaliza

	elseif (VM_TECLA==K_ENTER.and.VM_ELEM<len(VM_DUPLI)).or.VM_TECLA==K_INS
		VM_TF=savescreen(17,41,21,78)
		if VM_TECLA==K_INS
			scroll(row(),41,21,78,-1)
			VM_DPD = 0
			VM_DTD = ctod('')
			VM_VLD = 0
		else
			VM_DPD   = val (substr(VM_DUPLI[VM_ELEM],01,08))
			VM_DTD   = ctod(substr(VM_DUPLI[VM_ELEM],14,08))
			VM_VLD   = val (substr(VM_DUPLI[VM_ELEM],26,12))
		end
		@row(),41 get VM_DPD picture masc(9) valid VM_DPD>0
		@row(),54 get VM_DTD picture masc(7) valid VM_DTD>=PARAMETRO->PA_DATA
		@row(),66 get VM_VLD picture masc(5) valid VM_VLD>0
		read
		if lastkey()#K_ESC
			if VM_TECLA==K_INS
				asize(VM_DUPLI,len(VM_DUPLI)+1)
				ains(VM_DUPLI,VM_ELEM)
				VM_RT=AC_SELECT
			else
				VM_FECHA-=val(substr(VM_DUPLI[VM_ELEM],26,12))
			end
			VM_DUPLI[VM_ELEM]=pb_zer(VM_DPD,8)+space(5)+dtoc(VM_DTD)+space(4)+str(VM_VLD,12,2)
			VM_FECHA+=VM_VLD
		else
			restscreen(17,41,21,78,VM_TF)
		end

	elseif VM_TECLA==K_DEL
		VM_FECHA-=val (substr(VM_DUPLI[VM_ELEM],26,12))
		adel(VM_DUPLI,VM_ELEM)
		asize(VM_DUPLI,len(VM_DUPLI)-1)
		VM_RT=AC_SELECT
	end
	@22,54 say 'Restante...:'+transform(VM_VLRFAT[2]-VM_FECHA,masc(5))
end
return VM_RT


*-----------------------------------------------------------ACHOICE REF.ESTOQUE
function CFEP4411C(VM_MODO,VM_ELEM,VM_POS)

local VM_RT:=AC_CONT // Resposta default do include achoice
local VM_TECLA:=lastkey(),VM_TF

if VM_MODO==AC_HITTOP        // Tentativa de subir alem do top
	tone(200,3)
elseif VM_MODO==AC_HITBOTTOM // Tentativa de decer alem do fim
	tone(100,3)
elseif VM_MODO==AC_EXCEPT    // Teclado algo
	if VM_TECLA==K_ENTER.and.VM_ELEM=len(VM_MATER)
		VM_RT=AC_SELECT
	elseif (VM_TECLA==K_ENTER.and.VM_ELEM<len(VM_MATER)).or.VM_TECLA==K_INS
		VM_TF=savescreen(16,1,21,78)
		if VM_TECLA==K_INS
			scroll(row(),01,21,78,-1)
			VM_CODPR = 0
			VM_QTDE  = 0
			VM_IPI   = 0
			VM_VLCOM = 0
			VM_VLVEN = 0
		else
			VM_CODPR = val(substr(VM_MATER[VM_ELEM],POSPROD,L_P))
			VM_QTDE  = val(substr(VM_MATER[VM_ELEM],POSQTDE,09))
			VM_IPI   = val(substr(VM_MATER[VM_ELEM],POSIPI ,12))
			VM_VLCOM = val(substr(VM_MATER[VM_ELEM],POSVLRM,12))
			VM_VLVEN = val(substr(VM_MATER[VM_ELEM],POSVLRV,12))
		end
		@row(),POSPROD get VM_CODPR picture masc(21) valid fn_codpr(@VM_CODPR,30)
		@row(),POSQTDE get VM_QTDE  picture masc(06) valid VM_QTDE >0
		@row(),POSIPI  get VM_IPI   picture masc(05) valid VM_IPI  >=0 when VM_VIPI>0
		@row(),POSVLRM get VM_VLCOM picture masc(05) valid VM_VLCOM>0.and.fn_vlven(@VM_VLVEN,(VM_VLCOM/VM_QTDE),VM_CODPR,(VM_PCFRE*VM_VLCOM)/VM_QTDE,VM_ICMSP,VM_IPI/VM_QTDE)
		@row(),POSVLRV get VM_VLVEN picture masc(05) valid VM_VLVEN>0
		read
		if lastkey()#K_ESC
			if VM_TECLA==K_INS
				asize(VM_MATER,len(VM_MATER)+1)
				ains(VM_MATER,VM_ELEM)
				VM_RT=AC_SELECT
			else
				VM_FECHA -=val(substr(VM_MATER[VM_ELEM],POSVLRM,12))
				VM_FECHAI-=val(substr(VM_MATER[VM_ELEM],POSIPI, 12))
			end
			VM_MATER[VM_ELEM]=padr(str(VM_CODPR,L_P)+'-'+PROD->PR_DESCR,32)+;
									str(VM_QTDE , 9,2)+;
									str(VM_IPI  ,12,2)+;
			                  str(VM_VLCOM,12,2)+;
									str(VM_VLVEN,12,2)
			VM_FECHA +=VM_VLCOM
			VM_FECHAI+=VM_IPI
		else
			restscreen(16,1,21,78,VM_TF)
		end

	elseif VM_TECLA==K_DEL
		VM_FECHA -=val(substr(VM_MATER[VM_ELEM],POSVLRM,12))
		VM_FECHAI-=val(substr(VM_MATER[VM_ELEM],POSIPI, 12))
		adel(VM_MATER,VM_ELEM)
		asize(VM_MATER,len(VM_MATER)-1)
		VM_RT=AC_SELECT
	end
	@22,28 say 'Vlr Lan‡ado : '+transform(VM_FECHAI,masc(5))+transform(VM_FECHA,masc(5))
end
return VM_RT
*------------------------------------------------------------------------*
