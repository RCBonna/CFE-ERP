*-----------------------------------------------------------------------------*
function CFEPVEBX()	//	Excluir Pedidos/NF Atualizados								*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({	'C->PARAMETRO',;
				'C->DIARIO',;
				'C->CTRNF',;
				'C->GRUPOS',;
				'C->PROD',;
				'C->MOVEST',;
				'C->TABICMS',;
				'C->CLIENTE',;
				'C->CLIOBS',;
				'C->DPCLI',;
				'C->HISCLI',;
				'C->BANCO',;
				'C->VENDEDOR',;
				'C->OBS',;
				'C->CAIXACG',;
				'C->CAIXAMB',;
				'C->CONDPGTO',;
				'C->PEDPARC',;
				'C->XOBS',;
				'R->CODTR',;
				'C->PEDCAB',;
				'C->PEDDET',;
				'C->PEDSVC',;
				'C->CTADET',;
				'C->CTACTB',;
				'C->PARALINH',;
				'C->NATOP'})
	return NIL
end
pb_tela()
pb_lin4('Alterar Pedidos',ProcName())
select('PROD');dbsetorder(2) // Produtos
select('PEDCAB');dbsetorder(1) // Todos os Pedido incl atualizados
set relation to str(PC_CODCL,5) into CLIENTE
DbGoTop()

VM_CODOP:=0
VM_OPC  :=VM_TOT:=VM_ICMSPG:=VM_PARCE:=VM_DESCG:=VM_VEND:=VM_ULTPD:=VM_ULTDP:=VM_BCO:=0
VM_RT   :=.T.
VM_OBS  :=space(132)
VM_SVC  :=space(80)
VM_DET  :=VM_FAT:={}
VM_ICMS :={} // %ICMS,BASE
VM_ICMT :={0,0}	// Valor total ICMS, Base Total ICMS

salvacor(SALVA)
setcolor('GR+/BG,R/W,,,GR+/BG')
scroll(01,01,03,50,0)
@01,01 say 'Nr.Pedido.:' get VM_ULTPD pict masc(19) valid fn_pedped(@VM_ULTPD,.T.) when pb_msg('Infome N§ Pedido')
read
if lastkey()==K_ESC
	dbcloseall()
	return NIL
elseif !reclock() // Travar Registro
	dbcloseall()
	return NIL
end
VM_DTEMI:=PC_DTEMI
VM_PARCE:=PC_FATUR
VM_CLI  :=PC_CODCL
VM_VEND :=PC_VEND
VM_ULTDP:=VM_ULTPD
VM_OBS  :=PC_OBSER
@01,23 say 'Dt.EmissÆo: '+transform(VM_DTEMI,masc(07))
@01,47 say 'N§Parcelas ' +transform(VM_PARCE,masc(11))
@02,01 say 'Cliente...: '+transform(VM_CLI,masc(4))+'-'+CLIENTE->CL_RAZAO
if PARAMETRO->PA_VENDED==USOMODULO
	VENDEDOR->(dbseek(str(VM_VEND,3)))
	@03,01 say 'Vendedor..:   '+transform(VM_VEND,masc(12))+'-'+VENDEDOR->VE_NOME
end
salvacor(RESTAURA)

	VM_OPC:=0
	select('PEDDET')
	dbseek(str(VM_ULTPD,6),.T.)
	while !eof().and.VM_ULTPD=PD_PEDID
		PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
		aadd(VM_DET,{++VM_OPC, PD_CODPR,;
								PROD->PR_DESCR,;
								PD_QTDE,;
								PD_VALOR,;
								PD_DESCV,;
								PD_ENCFI,;
								PD_CODTR,;
								PD_ICMSP,;
								PROD->PR_UND,;
								PD_PTRIB,;
								PD_QTDE})	// VLR ORIGINAL
		dbskip()
	end
	select('PEDCAB')

setcolor('W+/B,N/W,,,W+/B')
scroll(5,0,23,79,0)
@22,01 say 'TOTAL do Pedido.: '+transform(PC_TOTAL,masc(2))
@23,01 say 'Desconto Geral..: '+transform(PC_DESC, masc(2))
@22,35 say 'Observa‡”es'
@23,35 say left(VM_OBS,45)
pb_msg('Press <ENTER> para continuar',nil,.f.)
abrowse(5,1,21,78,;
				VM_DET,;
				{'Sq',     'Prod.','Descricao','Qtdade','Vlr Venda','Desconto','Enc Financ',   'CT',   '%ICMS', 'Unid','%Tribut'},;
				{ 2,           L_P,         20,      10,         15,        15,          15,      2,         5,      6,       6 },;
				{masc(11),masc(21),    masc(1), masc(6),    masc(2),   masc(2),     masc(2),masc(11), masc(14),masc(1),masc(20)})
*---------------------------------------------------------------Roda pe da NOTA
if if(lastkey()#K_ESC,pb_sn('Deseja Excluir este Pedido ?'),.F.)
	if PC_FLAG // ja atualizado ?
//		if pb_sn('Este pedido j  foi atualizado.;Exluir tamb‚m os lancamentos de Duplicatas ?')
//			CFEP5102E(.F.)
//		else
//			beepaler()
//			alert('Pedido nÆo Excluido')
//		end
	else
		CFEP5103E(.F.)
	end		
	// dbcommitall()
end
dbcloseall()
return NIL
