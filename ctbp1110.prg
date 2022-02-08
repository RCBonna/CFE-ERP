#include 'RCB.CH'

*-----------------------------------------------------------------------------*
function CTBP1110()	//	Atualizacao de dados da empresa / parametros				*
*-----------------------------------------------------------------------------*
local X
local VM_P1
local aMeses:={"Nenhum",;
					"Janeiro",;
					"Fevereiro",;
					"Marco",;
					"Abril",;
					"Maio",;
					"Junho",;
					"Julho",;
					"Agosto",;
					"Setembro",;
					"Outubro",;
					"Novembro",;
					"Dezembro"}
pb_tela()
pb_lin4(_MSG_,ProcName())
if !abre({'E->PARAMCTB'})
	return NIL
end
for X:=1 to fcount()
	VM_P1:="VM"+substr(fieldname(X),3)
	&VM_P1:=&(fieldname(X))
end

VM_NRDIAR:=max(VM_NRDIAR,1)
//VM_MES   :=aMeses[VM_MES+1]
scroll(6,1,21,78,0,,'Informe')
@08,12 say "Raz„o Social : "+VM_EMPR
//@12,12 say "C.N.P.J.(MF).:" get VM_CGC     picture mCGC valid pb_chkdgt(VM_CGC,1).and.!empty(VM_CGC)
//@13,12 say "Inscr.Estad..:" get VM_INSCR   picture mUUU
@10,12 say "Mascara Cont.: "+MASC_CTB
@11,12 say "Numero Diario:" get VM_NRDIAR  pict mI4 valid VM_NRDIAR>0
@13,12 say "Ano Contabil.:" get VM_ANO     pict mI4 valid VM_ANO>2010 ;
										when pb_msg('Informe o Ano Corrente para contabilizacao. CUIDADO ao alterar estes valor para virada anual')
@14,12 say "Mes Fechado..:  " get VM_MES     pict mI2 valid VM_MES>=0.and.VM_MES<13 ;
										when pb_msg('Informe o mes fechado da contabilidade. ZERO para nenhum mes fechado.')
//@13,27,19,70 get VM_MES     listBox aMeses Caption "Selecione Mes Fechado" color "N/BG,W+/BG,W+/BG,W+/R,GR+/BG,N/BG,GR+/BG,N/R"
@18,12 say "Numero Ult. Pagina Impressa:" get VM_PGDIAR  pict masc(03) valid VM_PGDIAR>=1
@19,12 say "Limite Folhas do Diario....:" get VM_LMDIAR  pict masc(03)
read
if if(lastkey()#27,pb_sn(),.F.)
	for X:=1 to fcount()
		VM_P1:="VM"+substr(fieldname(X),3)
		replace &(fieldname(X)) with &VM_P1
	next
	MESCTBFECHADO:=VM_MES // Atualizar se alterado
end
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*
