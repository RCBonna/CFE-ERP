*-----------------------------------------------------------------------------*
function CTBPIMLO()	//	Importar Lotes														*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local LEITURA,VM_DIRET,VM_DATA,VM_NRLOTE,VM_CN,VM_VLRC,VM_CTA,VM_CTRA,VM_CONTA,VM_CONTRA
pb_lin4(_MSG_,ProcName())
if !abre({'C->PARAMCTB','C->CTADET','C->RAZAO','C->CTRLOTE'})
	return NIL
end
select('RAZAO')
dbsetorder(2)
select('CTADET')
dbsetorder(1)
VM_DIRET:=space(50)
VM_DATA :=ctod('')
pb_box(20,0)
@21,02 say 'Importar Lote de :' get VM_DIRET pict masc(01) valid fn_verifar(VM_DIRET)
read
if if(lastkey()#K_ESC,pb_sn('Importar...;'+VM_DIRET),.F.)
	TAM      :=64
	VM_CN    :=fopen(VM_DIRET)
	LEITURA  :=space(TAM)
	fread(VM_CN,@LEITURA,TAM)
	VM_DATA  :=ctod(substr(LEITURA,2,10))
	VM_NRLOTE:=NovoLote()
	if pb_sn('Importar dados de '+dtoc(VM_DATA)+';Como Lote Numero '+pb_zer(VM_NRLOTE,8))
		select('CTRLOTE')
		while !AddRec();end
		replace  CL_NRLOTE with VM_NRLOTE,;
					CL_VLRLT  with 0,;
					CL_FECHAD with .F.,;
					CL_DATA   with VM_DATA,;
					CL_DIGIT  with 'Import/Lote'
		if !fn_alote(VM_NRLOTE,.T.) // Criar arquivo de lotes
			dbcloseall()
			return NIL
		end
		VLRTOT:=0
		TAM:=64
		fseek(VM_CN,0) // VOLTAR AO INICIO DO ARQUIVO
		while fread(VM_CN,@LEITURA,TAM)>0
			if left(LEITURA,1)=='L'
				VM_CTA   :=val(substr(LEITURA,12,6))
				VM_VLRC  :=val(substr(LEITURA,25,17))
				if substr(LEITURA,14,4)='0000'
					VM_CTA:=val(substr(LEITURA,18,6))
					VM_VLRC  :=-VM_VLRC // CONTA A CREDITO
				end
				CTADET->(dbseek(str(VM_CTA,4)))
				VM_CONTA :=CTADET->CD_CONTA
				VM_CONTRA:=""
				VM_CTRA  :=0
				TAM:=62
			elseif left(LEITURA,1)=='H'
				VM_HISTOR:=substr(LEITURA,2,59)
				while !AddRec();end
				replace  LO_CONTA  with VM_CONTA,;
							LO_CONTRA with VM_CONTRA,;
							LO_CTA    with VM_CTA,;
							LO_CTRA   with VM_CTRA,;
							LO_VALOR  with VM_VLRC,;
							LO_HISTOR with VM_HISTOR
				VLRTOT+=abs(VM_VLRC)
				TAM:=64
			end
			LEITURA  :=space(TAM)
		end
	end
	select('CTRLOTE')
	replace  CL_VLRLT  with VLRTOT
	fclose(VM_CN)
end
dbcloseall()
return NIL

/*
L31/01/97000000000271D00000000002037.84                     CREDITO
H(-)DEPRECIACAO ACU. VEICULOS                               
..\
*/	

*-----------------------------------------------------------------------* Fim
static function FN_VERIFAR(P1)
local RT:=.T.
if !file(P1)
	alert('Arquivo informado;'+P1+';NAO ENCONTRADO')
	RT:=.F.
end
return RT
