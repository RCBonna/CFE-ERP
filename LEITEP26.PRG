//-----------------------------------------------------------------------------*
  static aVariav := {'N',0,'','',.F.,''}
//....................1..2..3..4...5..6..7...8..9.10.11.12.13.14.15.16.17
//-----------------------------------------------------------------------------*
#xtranslate cTipo			=> aVariav\[  1 \]
#xtranslate nNRNF			=> aVariav\[  2 \]
#xtranslate cTexto		=> aVariav\[  3 \]
#xtranslate VM_PERIODO	=> aVariav\[  4 \]
#xtranslate lRT			=> aVariav\[  5 \]
#xtranslate cNomeArq		=> aVariav\[  6 \]

#include 'RCB.CH'

//-----------------------------------------------------------------------------*
	function LeiteP26()	//	Informar Nota Fiscal de Produtor Para NFe/Aurora
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO'		,;
				'R->CLIENTE'		,;		//
				'R->LEIPARAM'		,;		// Parametros do Leite (LEITEP00.PRG)
				'C->LEILABOR'		,;		// Dados de Analise Leite Laboratório (LEITEP00.PRG)
				'R->LEIROTA'		,;		// criado arquivo no LEITEP00.PRG
				'R->LEICPROD'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIGORD'		,;		// Faixa de Gordura (LEITEP12.PRG)
				'R->LEIPROT'		,;		// Faixa de Proteina (LEITEP13.PRG)
				'R->LEIESD'			,;		// Faixa de ESD (LEITEP14.PRG)
				'R->LEICCS'			,;		// Faixa de CCS (LEITEP15.PRG)
				'R->LEICPP'			,;		// Faixa de CPP (LEITEP16.PRG)
				'C->LEIDADOS'		,;		// Dados dos Cliente (LEITEP00.PRG)
				'C->LEIBON'			;		// Calculo Valores Qualidade Leite (LEITEP00.PRG)
			})
	return NIL
end
select LEIBON
ORDEM CLIPER

VM_PERIODO	:=LEIPARAM->LP_PERIODO
cTipo			:='NF'
cTexto		:=''
pb_box(15,20,,,,'LEITE-Nota Fiscal de Produtor - Validar Cliente sem NF')
@17,21 say 'Periodo........:' get VM_PERIODO	pict mPER when pb_msg('Periodo de calculo da Qualidade de Leite')
@18,21 say 'Tipo Processo..:' get cTipo			pict mUUU valid cTipo$'NF|VA' when pb_msg('NF-Entrar com NF Produtor VA-Validar Clientes Sem NF informada.')
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if cTipo=='NF'
		LeiteP26NF()
	elseif cTipo=='VA'
		LeiteP26VA()
	end
end
setcolor(VM_CORPAD)
DbCloseAll()
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP26NF()	//	Informar Nota Fiscal de Produtor Para NFe/Aurora
//-----------------------------------------------------------------------------*
VM_CDCLI	:=0
while .T.
	nNRNF:=0
	@20,21 say 'Produtor.......:' 	get VM_CDCLI	pict mI5 valid fn_codigo(@VM_CDCLI,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CDCLI,5)))},NIL,{2,1}}).and.ChkCliLeite(@VM_CDCLI);
												when pb_msg('Informe o Codigo do Produtor')
	@21,21 say 'Nr NF Produtor.:' 	get nNRNF		pict mI6 valid VM_CDCLI>0;
												when pb_msg('Informe o Nr Nota Fiscal do Produtor')
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		if RecLock()
			replace CB_NRNFPR with nNRNF
			
			DbrunLock(RecNo())
		end
		DbSkip()
		VM_CDCLI:=LEIBON->CB_CDCLI
	else
		exit
	end
end
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP26VA()	//	Informar Nota Fiscal de Produtor Para NFe/Aurora
//-----------------------------------------------------------------------------*
cNomeArq	:=StrTran(AllTrim(PARAMETRO->PA_DIRETO)+'\Clientes_Sem_NF_Prod.log', '\\', '\' )
cTexto	:=padC('Relatorio de Clientes com Analise de Leite sem Nr Nota Fical Produto',78)+CRLF
cTexto	+=Space(60)+'Prog:'+ProcName()+CRLF
cTexto	+='Periodo..:'+Transform(VM_PERIODO,mPER)+CRLF
cTexto	+='Gerado em:'+DtoC(Date())+' as '+Time()+CRLF+CRLF
cTexto	+='Codig-Nome Cliente'+CRLF
cTexto	+=Replicate('-',78)+CRLF
nNRNF		:=0	// Contar Registro
select LEIBON
ORDEM PERCLI
DbSeek(VM_PERIODO,.T.)
while !eof()
	if CB_NRNFPR<1
		CLIENTE->(DbSeek(Str(LEIBON->CB_CDCLI,5)))
		cTexto+=Str(LEIBON->CB_CDCLI,5)+'-'+CLIENTE->CL_RAZAO+CRLF
		nNRNF++
	end
	DbSkip()
end
select LEIBON
ORDEM CLIPER

	cTexto	+=CRLF
	cTexto	+=replicate('-',78)+CRLF
	cTexto	+='Total de registros listados......:'+Str(nNRNF,5)+CRLF
	cTexto	+=replicate('-',78)+CRLF
	pb_msg(cNomeArq+' - Pressione <ALT+P> para Imprimir e <Esc> Sair>')
	MemoWrit(cNomeArq,cTexto)
	set key K_ALT_P to Log_Print(cTexto)
	SetCursor(1)
	MemoEdit(cTexto,06,01,21,78,.F.)
	SetCursor(0)
	set key K_ALT_P to

return NIL

//-----------------------------------------------------------------------------*
	function ChkCliLeite(pCDCLI)	//	Valida Cliente no Calc Qualidade Leite
//-----------------------------------------------------------------------------*
lRT:=.T.
if dbseek(Str(pCDCLI,5)+VM_PERIODO)
	// Exite Cliente e Período no cadastro
	nNRNF:=CB_NRNFPR // Pegar Nr da Nota se Exitir
else
	if pb_sn('Este Cliente nao tem analise de qualidade de leite no periodo;Criar Registro mesmo assim?')
		if AddRec()
			replace 	CB_CDCLI 	with pCDCLI,;		// 01-Codigo Cliente
						CB_PERIOD 	with VM_PERIODO,;	// 02-Período (AAAAMM)
						CB_ERFXCL 	with 'XXX|XXX'		// 03-Erros (XXX=Incluido)
		end
	else
		lRT:=.F.
	end
end
return lRT
//------------------------------------------------------------------EOF
