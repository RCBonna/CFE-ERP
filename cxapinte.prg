*-----------------------------------------------------------------------------*
 static aVariav := {0,{},0,0,0}
 //.................1,.2.3.4.5
*-----------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate Flag       => aVariav\[  2 \]
#xtranslate nCtaCLiFor => aVariav\[  3 \]
#xtranslate nCtaAdto   => aVariav\[  4 \]
#xtranslate nCtaBco    => aVariav\[  5 \]

*-----------------------------------------------------------------------------*
function CXAPINTE(DATA,nLinha)	//	Integra Caixa
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if DATA==NIL
	alert('Chamada do programa incorreta;'+ProcName())
	return NIL
end
if !abre({	'C->PARAMETRO',;
				'C->DIARIO',;
				'C->CTACTB',;
				'C->CLIENTE',;
				'C->ADTOSC',;
				'C->BANCO'})
	return .F.
end

select ADTOSC	// CABEÇALHO
ORDEM NUMERO
GO TOP
//------------------------------------------------------VALORES
pb_msg(ProcName()+'.Processando Integracao Caixa/Adiantamentos....')
while !eof()
	if !ADTOSC->C2_FLCTB.and.ADTOSC->C2_DTEMI>=DATA[1].and.ADTOSC->C2_DTEMI<=DATA[2]
		@nLinha,23 say 'Adiantamentos: '+str(ADTOSC->C2_CODCL,5)
		//................................................................Contabilizar
		CLIENTE->(dbseek(str(ADTOSC->C2_CODCL,5)))
		BANCO->(dbseek(str(ADTOSC->C2_CODBCO,2)))
		nCtaBco:=BANCO->BC_CONTA

		if ADTOSC->C2_TIPO=='C' //........................................Cliente
			nCtaAdto  :=fn_lecc('S',max(CLIENTE->CL_ATIVID,1),0, 4)
			fn_atdiario(ADTOSC->C2_DTEMI,;
							nCtaBco,;
							DEB*ADTOSC->C2_VLRADT,;
							'Adiantamento a '+CLIENTE->CL_RAZAO,;
							'ADTO/'+str(ADTOSC->C2_CODCL,5)+str(ADTOSC->C2_NRO,7))
		
			fn_atdiario(ADTOSC->C2_DTEMI,;
							nCtaAdto,;
							CRE*ADTOSC->C2_VLRADT,;
							'Adiantamento de '+CLIENTE->CL_RAZAO,;
							'ADTO/'+str(ADTOSC->C2_CODCL,5)+str(ADTOSC->C2_NRO,7))

		elseif ADTOSC->C2_TIPO=='F' //.......................................Fornecedores
			nCtaAdto  :=fn_lecc('E',max(CLIENTE->CL_ATIVID,1),0, 4)
			if ADTOSC->C2_PARC>0
				nCtaBco:=fn_lecc('E',max(CLIENTE->CL_ATIVID,1),0, 0) // se for pacelado laçar em fornecedor
			end
			fn_atdiario(ADTOSC->C2_DTEMI,;
							nCtaBco,;
							CRE*ADTOSC->C2_VLRADT,;
							'Adiantamento a '+CLIENTE->CL_RAZAO,;
							'ADTO/'+str(ADTOSC->C2_CODCL,5)+str(ADTOSC->C2_NRO,7))
		
			fn_atdiario(ADTOSC->C2_DTEMI,;
							nCtaAdto,;
							DEB*ADTOSC->C2_VLRADT,;
							'Adiantamento de '+CLIENTE->CL_RAZAO,;
							'ADTO/'+str(ADTOSC->C2_CODCL,5)+str(ADTOSC->C2_NRO,7))
		end
		while !reclock()
		end
		replace ADTOSC->C2_FLCTB with .T.
	end
	dbskip()
end
dbcloseall()
return .T.
//-------------------------------------EOF----------------------------------------------
