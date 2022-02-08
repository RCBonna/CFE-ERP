*-----------------------------------------------------------------------------*
 static aVariav := {0,{},.T.}
 //.................1...2...3...4..5..6...7...8...9, 10, 11, 12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate aSag		=> aVariav\[  1 \]
#xtranslate aFAT		=> aVariav\[  2 \]
#xtranslate lAltQUO	=> aVariav\[  3 \]
*-----------------------------------------------------------------------------*
function CotaAsso()	//	Associar Clientes já existente
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'R->PARAMETRO',;
				'C->CTRNF',;
				'C->DIARIO',;
				'E->COTAS',;
				'E->COTAPA',;
				'E->COTADV',;
				'E->COTAMV',;
				'E->COTASSO',;
				'E->COTASCV',;
				'E->CLIENTE',;
				'E->MOVCLIX',;
				'E->CLIOBS',;
				'E->MOVEST',;
				'E->PEDDET',;
				'E->PEDSVC',;
				'E->PEDCAB',;
				'E->HISCLI',;
				'E->ENTCAB',;
				'E->ENTDET',;
				'E->HISFOR',;
				'E->PROFOR',;
				'E->DPFOR',;
				'E->DPCLI'})
	return NIL
end
select CLIENTE
ORDEM CODIGO
pb_lin4(_MSG_,ProcName())
VM_CODCLi   :=0
VM_CODCLf   :=1
VM_DTASSO   :=date()
VM_NRPARC   :=1
VM_DTEntr	:=date()
VM_ULTPD		:=fn_psnf('INT')
VM_VLRENBA	:=0
VM_DTVCTO	:=eom(VM_DTEntr+3)
VM_HISTOR	:=COTAPA->PA_HIST1
aFAT			:={}
lAltINT		:=.F.

pb_box(14,18,,,,'Associar um Cliente')
@15,20 say 'Cod. Cliente.....:' get VM_CODCLi  pict mI5 valid fn_codigo(@VM_CODCLi,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCLi,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}).and.VM_CODCLi>1000 when pb_msg('Informe um Cliente que nao e associado...> 1000')
@16,20 say 'Novo Cod.Assoc...:' get VM_CODCLf  pict mI5 valid pb_ifcod2(str(VM_CODCLf,5),'CLIENTE',.F.,1).or.VM_CODCLf<1000  when pb_msg('Informe um numero para o associado...< 1000')
@17,20 say 'Data Associacao..:' get VM_DTEntr  pict mDT												when pb_msg('Data de Entrada e de Contabilizacao')
@18,20 say 'Data 1.Vencimento:' get VM_DTVCTO  pict mDT   valid VM_DTVCTO>=VM_DTEntr
@19,20 say 'Nr.Parcelas......:' get VM_NRPARC  pict mI2   valid VM_NRPARC>=1					when pb_msg('Nr parcelas para receber valor para associado')
@20,20 say 'Valor Recebido...:' get VM_VLRENBA pict mI122 valid VM_VLRENBA>0					when pb_msg('Valor a ser recebido')
@21,20 say 'Historico........:' get VM_HISTOR  pict mXXX  when len(aFAT:=fn_parc(VM_NRPARC,VM_VLRENBA,VM_ULTPD,VM_DTVCTO))>0

read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if pb_sn('Processar Conversao;Cliente....:'+str(VM_CODCLi,6)+';para;Associado..:'+str(VM_CODCLf,6)+';Confirma ?')
		CV_ROTINAS(VM_CODCLf,VM_CODCLi)
		select CLIENTE
		if CLIENTE->(dbseek(str(VM_CODCLi,5))).and.CLIENTE->(reclock())

			replace  CLIENTE->CL_CODCL  with VM_CODCLf,;
						CLIENTE->CL_DTCAD  with VM_DTEntr,;
						CLIENTE->CL_ATIVID with 1 // Associado
		
		end
		DbCommitAll()
		lAltINT		:=.T.
		CLIENTE->(dbseek(str(VM_CODCLf,5)))
		select DPCLI
		for nX:=1 to len(aFAT)
			AddRec(,{aFAT[nX][1],;//........................................01-Cod.DPL
						VM_CODCLf,;//..........................................02-Fornecedor
						VM_DTEntr,;//..........................................03-Data Emissao
						aFAT[nX][2],;//........................................04-Data Vencimento
						ctod(''),;//...........................................05-Data Pagamento
						aFAT[nX][3],;//........................................06-Valor DPL
						0.00,;//...............................................07-Valor Pago
						1,;//..................................................08-Cod Banco
						1,;//..................................................09-Moeda
						VM_ULTPD,;//...........................................10-Nr NF
						'INT',;//..............................................11-Serie (SOB+INT=Integraliza)
						CLIENTE->CL_RAZAO,;//..................................12-Alfa-DP
						ctod(''),;//...........................................13-Data Protesto
						'',;//.................................................14-Ofico Protesto
						0.00,;//...............................................15-Juros ao Mes
						'N',;//................................................16-N->Normal P-PREVISAO X->PROTESTO
						0,;//..................................................17-Nr do Boleto
						'R';//.................................................18-Tipo Dado <P=Pagar> <R=Receber>
						})
		next

		*----------------------------------------------------------CONTABILIZACAO
		CODIGO:='CP:ENT:'+pb_zer(VM_ULTPD,8)+'/INT'
		fn_atdiario(VM_DTEntr,;
						COTAPA->PA_CTA01,;	// D=Capital
						DEB*VM_VLRENBA,;
						VM_HISTOR,;
						CODIGO;
						)
		fn_atdiario(VM_DTEntr,;
						COTAPA->PA_CTA02,;	// C=Redistribuiçao Cotas
						CRE*VM_VLRENBA,;
						VM_HISTOR,;
						CODIGO;
						)
		*----------------------------------------------------------FECHA BAIXA DE ASSOCIADO
	end
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CotaDesA()	//	DesAssociar 
*-----------------------------------------------------------------------------*

if !abre({	'R->PARAMETRO',;
				'C->CTRNF',;
				'C->DIARIO',;
				'E->COTAS',;
				'E->COTAPA',;
				'E->COTADV',;
				'E->COTAMV',;
				'E->COTASSO',;
				'E->COTASCV',;
				'E->CLIENTE',;
				'E->MOVCLIX',;
				'E->CLIOBS',;
				'E->MOVEST',;
				'E->PEDDET',;
				'E->PEDSVC',;
				'E->PEDCAB',;
				'E->HISCLI',;
				'E->DPCLI',;
				'E->ENTCAB',;
				'E->ENTDET',;
				'E->HISFOR',;
				'E->PROFOR',;
				'E->DPFOR'})
	return NIL
end
select CLIENTE
ORDEM CODIGO
pb_lin4(_MSG_,ProcName())
VM_CODCLi   :=0
VM_CODCLf   :=1
VM_NRPARC   :=1
VM_DTSAID	:=ctod('31/12/'+str(year(date())-1,4))
VM_ULTPD		:=fn_psnf('QUO')
VM_VLRENBA	:=0
VM_DTVCTO	:=eom(VM_DTSAID+3)
VM_HISTOR	:=COTAPA->PA_HIST2
aFAT			:={}
lAltQUO		:=.F.
pb_box(14,18,,,,'DesAssociar -> Tornar Nao Associado')
@15,20 say 'Codigo Associado.:' get VM_CODCLi  pict mI5   valid fn_codigo(   @VM_CODCLi,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCLi,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}).and.VM_CODCLi<1000.and.reclock() when pb_msg('Informe um codigo de Associado...< 1000')
@16,20 say 'Novo Cod.Cliente.:' get VM_CODCLf  pict mI5   valid pb_ifcod2(str(VM_CODCLf,5),'CLIENTE',.F.,1).or.VM_CODCLf>1000                                                                              when pb_msg('Informe um numero para o associado...> 1000')
@17,20 say 'Data Saida.......:' get VM_DTSAID  pict mDT   when pb_msg('Data de Saida e de Contabilizacao')
@18,20 say 'Data 1.Vencimento:' get VM_DTVCTO  pict mDT   valid VM_DTVCTO>=VM_DTSAID
@19,20 say 'Nr.Parcelas......:' get VM_NRPARC  pict mI2   valid VM_NRPARC>=1
@20,20 say 'Valor Retirado...:' get VM_VLRENBA pict mI122 valid VM_VLRENBA>0
@21,20 say 'Historico........:' get VM_HISTOR  pict mXXX  when len(aFAT:=fn_parc(VM_NRPARC,VM_VLRENBA,VM_ULTPD,VM_DTVCTO))>0
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if pb_sn('Processar Conversao;Associado..:'+str(VM_CODCLi,6)+';para;Cliente....:'+str(VM_CODCLf,6)+';Confirma ?')
		CV_ROTINAS(VM_CODCLi,VM_CODCLf)
		select CLIENTE
		if CLIENTE->(dbseek(str(VM_CODCLi,5))).and.CLIENTE->(reclock())
			replace  CLIENTE->CL_CODCL  with VM_CODCLf,;
						CLIENTE->CL_ATIVID with 2,; // Nao Associado
						CLIENTE->CL_DTBAIX with VM_DTSAID
		end
		lAltQUO		:=.T.
		CLIENTE->(dbseek(str(VM_CODCLf,5)))
		select DPFOR
		for nX:=1 to len(aFAT)
			AddRec(,{aFAT[nX][1],;//.......................................01-Cod.DPL
						VM_CODCLf,;//..........................................02-Fornecedor
						VM_DTSAID,;//..........................................03-Data Emissao
						aFAT[nX][2],;//........................................04-Data Vencimento
						ctod(''),;//...........................................05-Data Pagamento
						aFAT[nX][3],;//........................................06-Valor DPL
						0.00,;//...............................................07-Valor Pago
						1,;//..................................................08-Cod Banco
						1,;//..................................................09-Moeda
						VM_ULTPD,;//...........................................10-Nr NF
						'QUO',;//..............................................11-Serie (QUO=Retirada)
						CLIENTE->CL_RAZAO,;//..................................12-Alfa-DP
						ctod(''),;//...........................................13-Data Protesto
						'',;//.................................................14-Ofico Protesto
						0.00,;//...............................................15-Juros ao Mes
						'N',;//................................................16-N->Normal P-PREVISAO X->PROTESTO
						'SAIDA.SOCIO';//.......................................17-Nr do Boleto
						})
		next

		*----------------------------------------------------------CONTABILIZACAO
		CODIGO:='CP:DES:'+pb_zer(VM_ULTPD,8)+'/QUO'
		fn_atdiario(VM_DTSAID,;
						COTAPA->PA_CTA03,;	// D=Capital
						DEB*VM_VLRENBA,;
						VM_HISTOR,;
						CODIGO;
						)
		fn_atdiario(VM_DTSAID,;
						COTAPA->PA_CTA04,;	// C=Redistribuiçao Cotas
						CRE*VM_VLRENBA,;
						VM_HISTOR,;
						CODIGO;
						)
		*----------------------------------------------------------FECHA BAIXA DE ASSOCIADO
	end
end
if !lAltQUO // não foi efetivado
	fn_backnf('QUO',VM_ULTPD)
end
dbcloseall()
return NIL


*-----------------------------------------------------------------------------*
 static function CV_ROTINAS(pOrig,pDest) // Conv.NF Saida
*-----------------------------------------------------------------------------*
		aSag:={'..\SAG\SAGANFC','..\SAG\BOLENTR'}
		CV_PEDCAB (VM_CODCLi,VM_CODCLf)
		CV_ENTCAB (VM_CODCLi,VM_CODCLf)
		CV_ENTDET (VM_CODCLi,VM_CODCLf)
		CV_PROFOR (VM_CODCLi,VM_CODCLf)
		CV_MOVEST (VM_CODCLi,VM_CODCLf)
		CV_DPFOR  (VM_CODCLi,VM_CODCLf)
		CV_HISFOR (VM_CODCLi,VM_CODCLf)
		CV_DPCLI  (VM_CODCLi,VM_CODCLf)
		CV_HISCLI (VM_CODCLi,VM_CODCLf)
		CV_CLIOBS (VM_CODCLi,VM_CODCLf) // HISTORICO DE PAGAMENTO DE FORNECEDOR
		CV_COTAS  (VM_CODCLi,VM_CODCLf) // HISTORICO DE PAGAMENTO DE FORNECEDOR
		CV_COTADV (VM_CODCLi,VM_CODCLf) // COTAS - DUPLICATAS-PAGAR/RECEBER
		CV_COTAMV (VM_CODCLi,VM_CODCLf) // COTAS - DUPLICATAS-PAGAR/RECEBER
		CV_COTASCV(VM_CODCLi,VM_CODCLf) // HISTORICO DE PAGAMENTO DE FORNECEDOR
		CV_CFEACLX(VM_CODCLi,VM_CODCLf) // HISTORICO MOVIMENTACAO CADASTRO CLIENTES
		if file(aSag[1]+'.DBF').and.file(aSag[2]+'.DBF')
			CV_SAGS(VM_CODCLi,VM_CODCLf)
		end
		
return

*-----------------------------------------------------------------------------*
 static function CV_PEDCAB(pOrig,pDest) // Conv.NF Saida
*-----------------------------------------------------------------------------*
pb_msg('Convertendo Notas Fiscais de Saida...')
select PEDCAB
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(PC_CODCL,5)==str(pOrig,5)
		replace PC_CODCL with pDest
	end
	skip
end
return NIL

*-----------------------------------------------------------------------------*
 static function CV_ENTCAB(pOrig,pDest) // ENTRADA CABECALHO
*-----------------------------------------------------------------------------*
pb_msg('Convertendo ENTRADA NF CABECALHO....')
select ENTCAB
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(ENTCAB->EC_CODFO,5)==str(pOrig,5)
		replace ENTCAB->EC_CODFO with pDest // Novo Número
	end
	skip
end
return

*-----------------------------------------------------------------------------*
 static function CV_ENTDET(pOrig,pDest) // ENTRADA DETALHE
*-----------------------------------------------------------------------------*
pb_msg('Convertendo ENTRADA NF DETALHE....')
select ENTDET
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(ENTDET->ED_CODFO,5)==str(pOrig,5)
		replace ENTDET->ED_CODFO with pDest // Novo Número
	end
	skip
end
return

*-----------------------------------------------------------------------------*
 static function CV_PROFOR(pOrig,pDest) // Conv.NF Saida
*-----------------------------------------------------------------------------*
pb_msg('Convertendo Produto x Fornecedor...')
select PROFOR
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(PF_CODFO,5)==str(pOrig,5)
		replace PROFOR->PF_CODFO with pDest // Novo Número
	end
	skip
end
return

*-----------------------------------------------------------------------------*
 static function CV_MOVEST(pOrig,pDest)
*-----------------------------------------------------------------------------*
pb_msg('Convertendo MOVIMENTACAO ESTOQUE/Leite...')
select MOVEST
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(MOVEST->ME_CODFO,5)==str(pOrig,5)
		replace MOVEST->ME_CODFO with pDest // Novo Número
	end
	skip
end
return

*-----------------------------------------------------------------------------*
 static function CV_DPFOR(pOrig,pDest) // Duplicata abertas dos fornecedores
*-----------------------------------------------------------------------------*
pb_msg('Convertendo CONTAS A PAGAR....')
select DPFOR
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(DPFOR->DP_CODFO,5)==str(pOrig,5)
		replace DPFOR->DP_CODFO with pDest // Novo Número
	end
	skip
end
return

*-------------------------------------------------------------------------------*
 static function CV_HISFOR(pOrig,pDest) // HISTORICO DE PAGAMENTO DE FORNECEDOR
*-------------------------------------------------------------------------------*
pb_msg('Convertendo HISTORICO PAGAMENTO FORNECEDORES....')
select HISFOR
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(HISFOR->HF_CODFO,5)==str(pOrig,5)
		replace HISFOR->HF_CODFO with pDest // Novo Número
	end
	skip
end
return

*-----------------------------------------------------------------------------*
 static function CV_DPCLI(pOrig,pDest) // Duplicata abertas dos Clientes
*-----------------------------------------------------------------------------*
pb_msg('Convertendo CONTAS A RECEBER....')
select DPCLI
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(DPCLI->DR_CODCL,5)==str(pOrig,5)
		replace DPCLI->DR_CODCL with pDest // Novo Número
	end
	skip
end
return

*-------------------------------------------------------------------------------*
 static function CV_HISCLI(pOrig,pDest) // HISTORICO DE PAGAMENTO DE FORNECEDOR
*-------------------------------------------------------------------------------*
pb_msg('Convertendo HISTORICO PAGAMENTO FORNECEDORES....')
select HISCLI
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(HISCLI->HC_CODCL,5)==str(pOrig,5)
		replace HISCLI->HC_CODCL with pDest // Novo Número
	end
	skip
end
return

*-------------------------------------------------------------------------------*
 static function CV_CLIOBS(pOrig,pDest) // HISTORICO DE PAGAMENTO DE FORNECEDOR
*-------------------------------------------------------------------------------*
pb_msg('Convertendo HISTORICO PAGAMENTO FORNECEDORES....')
select CLIOBS
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(CLIOBS->CO_CODCL,5)==str(pOrig,5)
		replace CLIOBS->CO_CODCL with pDest // Novo Número
	end
	skip
end
return

*-------------------------------------------------------------------------------*
 static function CV_COTAS(pOrig,pDest) // HISTORICO DE PAGAMENTO DE FORNECEDOR
*-------------------------------------------------------------------------------*
pb_msg('Convertendo COTAS PARTE/Vlr.Atual....')
select COTAS
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(COTAS->CP_CODCL,5)==str(pOrig,5)
		replace COTAS->CP_CODCL with pDest // Novo Número
	end
	skip
end
return

*-------------------------------------------------------------------------------*
 static function CV_COTADV(pOrig,pDest) // COTAS - DUPLICATAS-PAGAR/RECEBER
*-------------------------------------------------------------------------------*
pb_msg('Convertendo COTAS PARTE/DUPLICATAS....')
select COTADV
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(COTADV->DV_CODCL,5)==str(pOrig,5)
		replace COTADV->DV_CODCL with pDest // Novo Número
	end
	skip
end
return

*-------------------------------------------------------------------------------*
 static function CV_COTAMV(pOrig,pDest) // COTAS - DUPLICATAS-PAGAR/RECEBER
*-------------------------------------------------------------------------------*
pb_msg('Convertendo COTAS PARTE/Mov.DUPLICATAS....')
select COTAMV
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(COTAMV->MV_CODCL,5)==str(pOrig,5)
		replace COTAMV->MV_CODCL with pDest // Novo Número
	end
	skip
end
return

*-------------------------------------------------------------------------------*
 static function CV_COTASCV(pOrig,pDest) // HISTORICO DE PAGAMENTO DE FORNECEDOR
*-------------------------------------------------------------------------------*
pb_msg('Convertendo COTAS PARTE/Calc.Valores....')
select COTASCV
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(COTASCV->CP_CODCL,5)==str(pOrig,5)
		replace COTASCV->CP_CODCL with pDest // Novo Número
	end
	skip
end
return

*-------------------------------------------------------------------------------*
 static function CV_CFEACLX(pOrig,pDest) // HISTORICO DE PAGAMENTO DE FORNECEDOR
*-------------------------------------------------------------------------------*
pb_msg('Convertendo Hist. Mov. Alteracao Cad. Cliente..')
select MOVCLIX
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say str(lastrec(),6)+'/'+str(recno(),6)
	if str(MOVCLIX->CLX_CODCL,5)==str(pOrig,5)
		replace MOVCLIX->CLX_CODCL with pDest // Novo Número
	end
	skip
end
return

*-------------------------------------------------------------------------------*
 static function CV_SAGS(pOrig,pDest) // HISTORICO DE PAGAMENTO DE FORNECEDOR
*-------------------------------------------------------------------------------*
pb_msg('Convertendo SAG-Boletins....')
if !abre({	'E->NFC',;
				'E->BOL'})
	return NIL
end

select NFC
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say '1/'+str(lastrec(),6)+'/'+str(recno(),6)
	if str(NFC->NF_EMIT,5)==str(pOrig,5)
		replace NFC->NF_EMIT with pDest // Novo Número
	end
	skip
end
close

select BOL
set order to 0 // Sem Ordenacao
go top
while !eof()
	@24,60 say '2/'+str(lastrec(),6)+'/'+str(recno(),6)
	if str(BOL->BE_CODCL,5)==str(pOrig,5)
		replace BOL->BE_CODCL with pDest // Novo Número
	end
	skip
end
close
return

*------------------------------------------------EOF----------------------------*
