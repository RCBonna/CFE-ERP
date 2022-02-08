*-----------------------------------------------------------------------------*
 function CFEPCFIM(VM_FAT,XIMPR)	//	Impressao/Atualizacao de Cupom Fiscal
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local OPC     :=.F.
local RT      :=.F.
local X       := 1
local VM_REGIS:=recno()

if !XIMPR.or.CUPOMFISCAL()
	VM_AVALIS:=0
	VM_BCO   :=0
	VM_AVAL  :={0,space(45),space(45),space(18)}
	I_TRANS  :={}
	VM_ULTNF :=VM_ULTPD
	VM_BCO   :=1
	setcolor(VM_CORPAD)
	DbGoTo(VM_REGIS)
	aeval(VM_FAT,{|DET|DET[1]:=VM_ULTNF*100+X++})
	pb_msg('Atualizando Base de dados. Aguarde...',NIL,.F.)
	if XIMPR // atualizar com impressao total
		if CF_ImprGeral(VM_TOT,VM_ENCFI,VM_DESCG,VM_NOMNF,VM_FAT,VM_VLRENT,1,VM_DET) //...Rot Impressao Cupom
			aeval(VM_DET,{|DET|DET[6]:=0.00}) // limpar desconto indiv
			FATPGRPE('Novo','Produto')	// Atualizar Pedidos
			CFEP520G(                )	// Atualiza
			RT:=.T.
		end
	else
		aeval(VM_DET,{|DET|DET[6]:=0.00}) // limpar desconto indiv
		FATPGRPE('Novo','Produto')	// Atualizar Pedidos
		CFEP520G(   )	// Atualiza
		RT:=.T.
	end
end
select('PEDCAB')
DbGoTop()
return RT
//-------------------------------------EOF---------------------------------------

