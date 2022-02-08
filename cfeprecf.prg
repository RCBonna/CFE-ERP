*-----------------------------------------------------------------------------*
function CFEPRECF() // Exportar
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_CPO:={'S','N','N',,,0,0,0,0,3,2}
//        1   2   3  456 7 8 9 0,1

pb_lin4(_MSG_,ProcName())

if !abre({	'R->PROD',	'R->PARAMETRO','R->CLIENTE',;
				'E->MOVEST',;
				'E->PEDCAB','R->DPCLI',	'E->PEDDET',	'R->HISCLI'})
	return NIL
end
if empty(PARAMETRO->PA_INSCR).or.val(PARAMETRO->PA_INSCR)>10
	alert('C¢digo da empresa nao configurado.;Use INSCR.EST')
	dbcloseall()
	return NIL
end

select('DPCLI');dbsetorder(5)	// Dpls Receber
select('PROD');dbsetorder(2)	// Cadastro de Produtos

VM_CPO[4]:=PARAMETRO->PA_DATA
VM_CPO[5]:=PARAMETRO->PA_DATA
pb_box(19,20,,,,'Selecione')
@20,22 say 'Data Emissao Inicial...:' get VM_CPO[4] pict masc(7)
@21,22 say 'Data Emissao Final.....:' get VM_CPO[5] pict masc(7)  valid VM_CPO[5]>=VM_CPO[4]
read
ARQUIVO:=dtos(VM_CPO[4])+'.'+left(PARAMETRO->PA_INSCR,3)
if if(lastkey()#K_ESC,pb_sn('Exportar arquivo '+ARQUIVO),.F.)
	dirmake('..\ENVIA')
//......recebe
	pb_msg()
	set print to ('..\ENVIA\'+ARQUIVO)
	set print on
	set console off

	select('PEDCAB')
	ordem DTENNF
	dbseek(dtos(VM_CPO[4]),.T.) // Data Inicial
	while !eof().and.PC_DTEMI<=VM_CPO[5]
		CFEPRECF1()
	end
	set console on
	set print off
	set print to
	if file("FLAGXXX.CFG").and.file('..\ENVIA\'+ARQUIVO)
		select('PEDCAB')
		zap
		pack
		select('PEDDET')
		zap
		pack
		select('MOVEST')
		zap
		pack
		select('PEDCAB')
	end
end
dbcloseall()
return NIL

*----------------------------------------------------------------------------*
function CFEPRECF1()
local VM_DTEMI:=PC_DTEMI
local VM_PEDID
while !eof().and.PC_DTEMI==VM_DTEMI
	@24,70 say str(PC_PEDID,6)
	if PC_FLAG
		if !PC_FLCAN
			VM_PEDID:=PC_PEDID
			select('PEDDET')
			dbseek(str(VM_PEDID,6),.T.)
			while !eof().and.VM_PEDID==PD_PEDID
				??'exporta1|'
				??left(PARAMETRO->PA_INSCR,3)+'|'
				??dtos(PEDCAB->PC_DTEMI)      +'|'
				
				if PD_CODPR>0 
					??pb_zer(PD_CODPR,13)         +'|'
				else
					??pb_zer(0,13)         +'|'
				end
				??pb_zer(PEDCAB->PC_NRNF,6)   +'|'
				??PEDCAB->PC_SERIE            +'|'
				??pb_zer(PEDDET->PD_ORDEM,3)  +'|'
				// quantidade 1
				if PEDCAB->PC_SERIE==SCOLD
					??pb_zer(0,10)             +'|'
				else
					??pb_zer(PD_QTDE,10)       +'|'
				end

				// quantidade 2
				if PEDCAB->PC_SERIE==SCOLD
					??pb_zer(PD_QTDE,10)       +'|'
				else
					??pb_zer(0,10)             +'|'
				end

				// valor 1
				if PEDCAB->PC_SERIE==SCOLD
					??pb_zer(0,15) +'|'
				else
					??pb_zer((PD_QTDE*PD_VALOR-PD_DESCV+PD_ENCFI)*100,15) +'|'
				end

				// valor 2
				if PEDCAB->PC_SERIE==SCOLD
					??pb_zer((PD_QTDE*PD_VALOR-PD_DESCV+PD_ENCFI)*100,15) +'|'
				else
					??pb_zer(0,15) +'|'
				end
				??dtos(date())+'|'
				??time()
				?
				dbskip()
			end
			select('PEDCAB')
		end
	end
	dbskip()
end
return NIL

*-----------------------------------------------------------------------------*
