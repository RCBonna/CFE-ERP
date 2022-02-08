*-----------------------------------------------------------------------------*
function CFEPCFAF()	//	Cupom Fiscal - Aliquotas Fiscais
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
#define GRV 'GRAVADA'
#define NOV 'NOVA   '

local X,ALIQUO,VM_ALIQUO
if !abre({'R->PARAMETRO','E->ALIQUOTAS'})
	return NIL
end

pb_lin4(_MSG_,ProcName())
if CUPOMFISCAL()
	if xxsenha(ProcName(),'Inclusao de Aliq-Cupom Fiscal')
		AAA   :=CF_RetAliquota()
		ALIQUO:={}
		pb_lin4('Inclusao de Aliquotas-Cupom Fiscal',ProcName())
		select('ALIQUOTAS')
		DbGoTop()

		while !eof()
			if val(ALIQUOTAS->AF_CODIGO)>0
				delete
			end
			dbskip()
		end
		*--------------------------------Criar Aliquotas Conforme Impressora
		for X:=1 to len(AAA)
			if AAA[X]>0
				dbappend()
				replace 	AF_CODIGO with pb_zer(X,2),;
							AF_DESCR  with "Trib."+str(AAA[X],6,2),;
							AF_ALIQUO with AAA[X]
			end
		next

		DbGoTop()
		while !eof()
			aadd(ALIQUO,{	ALIQUOTAS->AF_CODIGO,;
								ALIQUOTAS->AF_DESCR,;
								ALIQUOTAS->AF_ALIQUO,;
								ALIQUOTAS->(recno())})
			dbskip()
		end


		aadd(ALIQUO,{'  ','Aliquota Nova',0.00,0})
		while lastkey()#K_ESC
			X:=abrowse(7,42,21,78,;
					ALIQUO,;
					{'Cod',   'Descricao','Aliquota'},;
					{    3,            20,        8 },;
					{masc(01),   masc(23),    masc(20)})
			if X>0.and.empty(ALIQUO[X,1])
				VM_CODIGO:=ALIQUO[X,1]
				VM_DESCR :=ALIQUO[X,2]
				VM_ALIQUO:=ALIQUO[X,3]
				
				@row(),44 get VM_CODIGO pict masc(01)
				@row(),48 get VM_DESCR  pict masc(23)
				@row(),69 get VM_ALIQUO pict masc(20)
				read
				if lastkey()#K_ESC
					ALIQUO[X,1]:=VM_CODIGO
					ALIQUO[X,2]:=VM_DESCR
					ALIQUO[X,3]:=VM_ALIQUO
					aadd(ALIQUO,{'  ','Aliquota Nova',0.00,0})
					keyboard replicate(chr(K_DOWN),X)
				end
			elseif X==0
				for X:=1 to len(ALIQUO)
					if ALIQUO[X,4]==0
						if !empty(ALIQUO[X,1])
							if substr(ALIQUO[X,1],1,1)>='0'.and.substr(ALIQUO[X,1],1,1)<='9'.and.;
								substr(ALIQUO[X,1],2,1)>='0'.and.substr(ALIQUO[X,1],2,1)<='9'
								imprfisc(CHR(27)+CHR(251)+"07|"+pb_zer(VM_ALIQUO*100,4)+"|"+CHR(27))
							end
							dbappend()
							replace 	AF_CODIGO with ALIQUO[X,1],;
										AF_DESCR  with ALIQUO[X,2],;
										AF_ALIQUO with ALIQUO[X,3]
						end
					end
				next
			end
		end
	end
end
dbcloseall()
return NIL
