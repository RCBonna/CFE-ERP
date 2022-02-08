 Static _aVariav := {0, 0, 5,''}
 //..................1..2..3
*-----------------------------------------------------------------------------*
#xtranslate nX         => _aVariav\[  1 \]
#xtranslate nY         => _aVariav\[  2 \]
#xtranslate nLinha     => _aVariav\[  3 \]
#xtranslate cTela      => _aVariav\[  4 \]

*-----------------------------------------------------------------------------*
 Function CONV_FC()	//	Conversao Fornecedores-->Clientes
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'E->PARAMETRO',;
				'E->CLIENTE',;
				'E->CAIXACG',;
				'E->CAIXAMB',;
				'E->CONDPGTO',;
				'E->MOVEST',;
				'E->PEDDET',;
				'E->PEDSVC',;
				'E->PEDCAB',;
				'E->ENTCAB',;
				'E->ENTDET',;
				'E->FORNEC',;
				'E->HISFOR',;
				'E->PROFOR',;
				'E->DPFOR'})
	return NIL
end
//pb_tela()
//pb_lin4(_MSG_,procname())
if PARAMETRO->PA_CONVCF
	alert('Fornecedores já convertidos para Clientes')
	dbcloseall()
	return NIL
end
pb_box(20,30)
@21,32 say 'Informe senha :'
if !senhas('CUIDADO',21,50)
	beeperro()
	pb_msg('Senha Incorreta, Tente novamente....',10,.T.)
	dbcloseall()
	return NIL
end

if !pb_sn('F A C A     B A C K U P     A N T E S;CONVERSAO DOS FORNECEDORES PARA CLIENTES;;VOCE VAI PARA  ???')
	if pb_sn('FEZ BACKUP ???;;Converter  ???')
		cTela:=SaveScreen()
		if CONV1()
			RestScreen(,,,,cTela)
			if pb_sn('Verificacao OK;E possivel converter;Continuar?')
				if pb_ligaimp(I15CPP)
					PB_MSG('Trocar Codigo Fornecedor')
					CONV2()	// Trocar número de Fornecedor
					PB_MSG('Trocar - Duplicata dos fornecedores')
					CONVDF() // Duplicatas de Fornecedore
					PB_MSG('Trocar - Movimentacao Leite')
					CONVME() // Movimentacao estoque
					PB_MSG('Trocar - Entrada 1')
					CONVEC() // Entrada Cabec
					PB_MSG('Trocar - Entrada 2')
					CONVHF() // Historico Fornecedor
					PB_MSG('Trocar - Entrada 2')
					CONVPF() // Hist compra dos fornec
					pb_deslimp()
					select PARAMETRO
					replace PA_CONVCF with .T.
				end
			end
		else
			ALERT('Impossivel Continuar a Converter;Exitem fornecedores com codigo CNPJ/CPF Zerados;AVALIAR LISTAGEM')
			if pb_sn('Entrar no cadastro de Fornecedor para corrigir ?')
				dbcloseall()
				cfep2100()
			end
		end
	end
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 Static function CONV1()
*-----------------------------------------------------------------------------*
Local RT:=.T.
if pb_ligaimp(I15CPP)
	Select CLIENTE
	ORDEM CGC
	Select FORNEC
	ORDEM ALFA
	dbgotop()
	? 'Conversao ' +dtoc(date())+' hora:'+time()
	?
	? padr('FORNECEDOR',65,'.')+'------> Situacao no Cadastro Clientes'
	? replicate('-',132)
	While !EOF()
		? str(FORNEC->FO_CODFO,5)+'-'
		??    FORNEC->FO_RAZAO+' '
		??    FORNEC->FO_CGC
		??' ---> '
		if val(FORNEC->FO_CGC) > 0
			select CLIENTE
			if dbseek(FORNEC->FO_CGC)
				?? 'OK => Cliente : '+str(CLIENTE->CL_CODCL,5)
				skip
				if FORNEC->FO_CGC == CLIENTE->CL_CGC
					RT:=.F.
					??"<ERRO+CPF Cli:"+str(CLIENTE->CL_CODCL,5)
				end
				skip
				if FORNEC->FO_CGC == CLIENTE->CL_CGC
					RT:=.F.
					??"<ERRO+CPF Cli:"+str(CLIENTE->CL_CODCL,5)
				end
			else
				?? 'SERA CRIADO NOVO CLIENTE'
			end
			Select FORNEC
		else
			RT:=.F.
			?? 'ERRO ** CNPJ/CNPF (ZERADO)'
		end
		skip
	end

	Select FORNEC
	ORDEM CGC
	go top
	cCGC:=''
	while !eof()
		if FORNEC->FO_CGC == cCGC
			RT:=.F.
			?'Fornecedor com CGC/CPF duplicado * ERRO * '+cCGC+'  Codigo :'+str(FORNEC->FO_CODFO,5)
		end
		cCGC:=FORNEC->FO_CGC
		skip
	end
	
	if !RT
		?padc(' EXISTEM FORNECEDORES QUE NAO PODEM SER CONVERTIDOS ',132,'*')
		?padc(' OU ZERADOS OU EXISTEM MAIS DE UM CGC/CPF ',132,'*')
		?padc(' CONVERSAO PARALIZADA ATE OS AJUSTES ',132,'*')
	else
		?padc(' OK ',132,'*')
	end
	pb_deslimp(C15CPP)
else
	RT:=.F.
end
return RT

*-----------------------------------------------------------------------------*
 Static function CONV2() // transfere cadastro de Fornecedores para Clientes
*-----------------------------------------------------------------------------*
Local NrCli:=0
	pb_msg('Convertendo Codigos Fornecedores....')
	? 'Conversao ' +dtoc(date())+' hora:'+time()
	?padc('CONVERTENDO CADASTRO FORNECEDORES',132,'-')
	?
	Select CLIENTE
	ORDEM CGC
	Select FORNEC
	ORDEM ALFA
	dbgotop()
	While !eof()
		@24,60 say FORNEC->FO_RAZAO
		?'Converte Fornecedor : '+FORNEC->FO_CGC+'-'+left(FORNEC->FO_RAZAO,30)+' '
		if val(FORNEC->FO_CGC) > 0
			select CLIENTE
			??'OK = Codigo '+str(FORNEC->FO_CODFO,5)
			if dbseek(FORNEC->FO_CGC)	// Só alterar codigo 
				Replace 	CL_CODFOR with FORNEC->FO_CODFO,;
							CL_DTUCOM with FORNEC->FO_DTCOM,;
							CL_CONTAT with FORNEC->FO_CONTA,;
							CL_OBS    with 'Alt. Conv. de Fornecedor',;
							CL_ATIVID with FORNEC->FO_TIPO,;
							CL_DTBAIX with FORNEC->FO_DTBAIX,;
							CL_MATRIZ with FORNEC->FO_MATRIZ,;
							CL_STATUS with FORNEC->FO_STATUS,;
							CL_LEITSQ with FORNEC->FO_LEITSQ
			else
				NrCli:=FindNewCli()
				??' -> NOVO CODIGO :'+str(NrCli,5)
				addrec()
				Replace ;
						CL_CODCL  with NrCli,;
						CL_RAZAO  with FORNEC->FO_RAZAO,;
						CL_ENDER  with FORNEC->FO_ENDER,;
						CL_BAIRRO with FORNEC->FO_BAIRRO,;
						CL_CEP    with FORNEC->FO_CEP,;
						CL_CIDAD  with FORNEC->FO_CIDAD,;
						CL_UF     with FORNEC->FO_UF,;
						CL_CGC    with FORNEC->FO_CGC,;
						CL_INSCR  with FORNEC->FO_INSCR,;
						CL_FONE   with FORNEC->FO_FONE,;
						CL_FAX    with FORNEC->FO_FAX,;
						CL_DTUCOM with FORNEC->FO_DTCOM,;
						CL_CONTAT with FORNEC->FO_CONTA,;
						CL_OBS    with 'Novo Conv. de Fornecedor',;
						CL_ATIVID with FORNEC->FO_TIPO,; // -> MUDOU A VARIÁVEL NO CADASTRO DO CLIENTE
						CL_TIPOFJ with FORNEC->FO_TIPOFJ,;
						CL_DTBAIX with FORNEC->FO_DTBAIX,;
						CL_CODFOR with FORNEC->FO_CODFO,;
						CL_MATRIZ with FORNEC->FO_MATRIZ,;
						CL_STATUS with FORNEC->FO_STATUS,;
						CL_LEITSQ with FORNEC->FO_LEITSQ
			end
		else
			??" *** ERRO -- NAO CONVERTIDO"
		end
		Select FORNEC
//		delete
		skip
	end
	ZAP
Return

*-----------------------------------------------------------------------------*
Static Function FindNewCli()
*-----------------------------------------------------------------------------*
Local Reg   :=Cliente->(recno())
Local NroNew:=0
Local NroSeq:=0
ORDEM CODIGO
DbGoTop()
dbseek(str(1000,5),.T.)
NroSeq:=CL_CODCL
while !eof().and.NroNew==0
	if NroSeq==CL_CODCL
		NroSeq++
	else
		NroNew:=NroSeq
	end
	skip
end
if NroNew==0
	NroNew:=NroSeq
end
ORDEM CGC
DbGoTo(Reg)
return(NroNew)

*-----------------------------------------------------------------------------*
 Static function CONVDF()
*-----------------------------------------------------------------------------*
pb_msg('Convertendo CONTAS A PAGAR....')
?
? 'Conversao ' +dtoc(date())+' hora:'+time()
?padc('CONVERTENDO CONTAS A PAGAR',132,'-')
?
select CLIENTE
ORDEM ANTIGO
select DPFOR
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),5)
	if CLIENTE->(dbseek(str(DPFOR->DP_CODFO,5)))
		replace DPFOR->DP_CODFO with CLIENTE->CL_CODCL // Novo Número
	else
		? '**Erro FORNEC = '+str(DPFOR->DP_CODFO,6) + " nao encontrado no cadastro DP->"+str(DP_DUPLI)
//		replace DPFOR->DP_CODFO with DPFOR->DP_CODFO * (-1) // Número Antigo por Problema
	end
	skip
end
return

*-----------------------------------------------------------------------------*
 Static function CONVME()
*-----------------------------------------------------------------------------*
pb_msg('Convertendo MOVIMENTACAO ESTOQUE - LEITE....')
?
? 'Conversao ' +dtoc(date())+' hora:'+time()
?padc('Convertendo MOVIMENTACAO ESTOQUE - LEITE',132,'-')
?
select CLIENTE
ORDEM ANTIGO
select MOVEST
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),5)
	if CLIENTE->(dbseek(str(MOVEST->ME_CODFO,5)))
		replace MOVEST->ME_CODFO with CLIENTE->CL_CODCL // Novo Número
	else
		? '** Erro FORNEC = '+str(MOVEST->ME_CODFO,6) + " nao encontrado no cadastro dia: "+dtoc(MOVEST->ME_DATA)
//		replace MOVEST->ME_CODFO with MOVEST->ME_CODFO * (-1) // Número Antigo por Problema
	end
	skip
end
return

*-----------------------------------------------------------------------------*
 Static function CONVEC() // ENTRADA CABECALHO
*-----------------------------------------------------------------------------*
pb_msg('Convertendo ENTRADA NF CABECALHO....')
?
? 'Conversao ' +dtoc(date())+' hora:'+time()
?padc('Convertendo ENTRADA NF CABECALHO',132,'-')
?
select CLIENTE
ORDEM ANTIGO
select ENTCAB
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),5)
	if CLIENTE->(dbseek(str(ENTCAB->EC_CODFO,5)))
		replace ENTCAB->EC_CODFO with CLIENTE->CL_CODCL // Novo Número
	else
		? '** Erro FORNEC = '+str(ENTCAB->EC_CODFO,6) + " nao encontrado no cadastro dia:"+dtoc(ENTCAB->EC_DTEMI)+' Doc:'+str(ENTCAB->EC_DOCTO,8)+' SERIE:'+ENTCAB->EC_SERIE
//		replace ENTCAB->EC_CODFO with ENTCAB->EC_CODFO * (-1) // Número Antigo por Problema
	end
	skip
end
return

*-----------------------------------------------------------------------------*
 Static function CONVED() // ENTRADA DETALHE
*-----------------------------------------------------------------------------*
pb_msg('Convertendo ENTRADA NF DETALHE....')
?
? 'Conversao ' +dtoc(date())+' hora:'+time()
?padc('Convertendo ENTRADA NF DETALHE',132,'-')
?
select CLIENTE
ORDEM ANTIGO
select ENTDET
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),5)
	if CLIENTE->(dbseek(str(ENTDET->ED_CODFO,5)))
		replace ENTDET->ED_CODFO with CLIENTE->CL_CODCL // Novo Número
	else
		? '** Erro FORNEC = '+str(ENTDET->ED_CODFO,5) + ' nao encontrado no cadastro Doc:'+str(ENTDET->ED_DOCTO,8)+' SERIE:'+ENTDET->ED_SERIE+' SEQ:'+str(ENTDET->ED_ORDEM,3)
//		replace ENTDET->ED_CODFO with ENTDET->ED_CODFO * (-1) // Número Antigo por Problema
	end
	skip
end
return

*-----------------------------------------------------------------------------*
 Static function CONVHF() // HISTORICO DE PAGAMENTO DE FORNECEDOR
*-----------------------------------------------------------------------------*
pb_msg('Convertendo HISTORICO PAGAMENTO FORNECEDORES....')
?
? 'Conversao ' +dtoc(date())+' hora:'+time()
?padc('Convertendo HISTORICO PAGAMENTO FORNECEDORES',132,'-')
?
select CLIENTE
ORDEM ANTIGO
select HISFOR
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),5)
	if CLIENTE->(dbseek(str(HISFOR->HF_CODFO,5)))
		replace HISFOR->HF_CODFO with CLIENTE->CL_CODCL // Novo Número
	else
		? '** Erro FORNEC = '+str(HISFOR->HF_CODFO,6) + ' nao encontrado no cadastro Doc:'+str(HISFOR->HF_DUPLI,9)
//		replace HISFOR->HF_CODFO with HISFOR->HF_CODFO * (-1) // Número Antigo por Problema
	end
	skip
end
return

*-----------------------------------------------------------------------------*
 Static function CONVPF() // HISTORICO DE COMPRAS DE FORNECEDOR
*-----------------------------------------------------------------------------*
pb_msg('Convertendo HISTORICO COMPRAS DE PRODUTOS....')
?
? 'Conversao ' +dtoc(date())+' hora:'+time()
?padc('Convertendo HISTORICO COMPRAS DE PRODUTOS',132,'-')
?
select CLIENTE
ORDEM ANTIGO
select PROFOR
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),5)
	if CLIENTE->(dbseek(str(PROFOR->PF_CODFO,5)))
		replace PROFOR->PF_CODFO with CLIENTE->CL_CODCL // Novo Número
	else
		? '** Erro FORNEC = '+str(PROFOR->PF_CODFO,6) + ' nao encontrado no cadastro  Produto :'+str(PROFOR->PF_CODPR) + " * Excluido"
//		replace PROFOR->PF_CODFO with PROFOR->PF_CODFO * (-1) // Número Antigo por Problema
		delete
	end
	skip
end
return

// end-file //

