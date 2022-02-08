*-----------------------------------------------------------------------------*
function CTBPLIMP()	//	limpa movimentacao da contabilidade							*
*-----------------------------------------------------------------------------*
#include 'rcb.ch'

local X:=5,X1:=array(25)
private VM_RAZAO :='S'
private VM_SLDINI:='S'
private VM_SLDMES:='S'

pb_lin4(_MSG_,ProcName())
if xxsenha(ProcName(),'Limpar Mvto da Contabilidade')
	pb_box(18,20,,,'W+/R')
   @19,22 say 'Apagar Lanctos Razao/Diario ? ' get VM_RAZAO  pict mUUU valid VM_RAZAO$'SN'
	@20,22 say 'Saldos Iniciais das Contas ?  ' get VM_SLDINI pict mUUU valid VM_SLDINI$'SN'
	@21,22 say 'Saldos Mensais das Contas ?   ' get VM_SLDMES pict mUUU valid VM_SLDMES$'SN'
	read
	if lastkey()#K_ESC.and.abre({'E->CTADET','E->RAZAO'})
		pb_msg(,NIL,.F.)
		if pb_sn('Limpar arquivos RAZAO e SALDOS CONTAS')
			if VM_RAZAO == 'S'
				select('RAZAO')
				zap
			end
			select('CTADET')
			if VM_SLDINI == 'S'
				DbGoTop()
				while !eof()
					fieldput(4,0) // saldo incial
					dbskip()
				end
			end			
			if VM_SLDMES == 'S'
				aeval(X1,{|DET,DET1|X1[DET1]:=X++})	// 5,6,7...
				dbeval({||aeval(X1,{|DET|fieldput(DET,0)})})
			end
		end
		dbcloseall()
		alert('Arquivos foram acertados')
	end
end
return NIL
