//-----------------------------------------------------------------------------*
  static aVariav := {0,'','',''}
//....................1.2..3..4
//-----------------------------------------------------------------------------*
#xtranslate nX		   => aVariav\[  1 \]
#xtranslate CHAVE1   => aVariav\[  2 \]
#xtranslate CHAVE2   => aVariav\[  3 \]
#xtranslate CHAVE3   => aVariav\[  4 \]

*-----------------------------------------------------------------------------*
 function CFEP4200()	// Cadastro de Itens no Estoque									*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->CODTR',;
				'R->ALIQUOTAS',;
				'C->XOBS',;
				'C->GRUPOS',;
				'C->MOVEST',;
				'C->FISACOF',;
				'C->SALDOS',;
				'C->UNIDADE',;
				'R->NCM',;
				'C->PROD'})
	return NIL
end
select GRUPOS
set filter to GRUPOS->GE_CODGR%10000>0

select FISACOF
ORDEM CODUNI
GO TOP

select PROD
ORDEM CODIGO
DbGoTop()
pb_tela()
pb_lin4(_MSG_,ProcName())

pb_dbedit1('CFEP420','IncluiAlteraPesquiExcluiOrdem Atualz')
VM_CAMPO :=array(fcount())
VM_CABE  :=array(fcount())
VM_MUSC  :=array(fcount())
afields(VM_CAMPO)

VM_CABE[01]:='Grupo'       ;VM_MUSC[01]:=masc(13)
VM_CABE[02]:='Codigo'      ;VM_MUSC[02]:=masc(21)
VM_CABE[03]:='Descricao'   ;VM_MUSC[03]:=mXXX
VM_CABE[04]:='Complemento' ;VM_MUSC[04]:=mXXX
VM_CABE[05]:='Und'         ;VM_MUSC[05]:=mUUU
VM_CABE[06]:='local'       ;VM_MUSC[06]:=mXXX
VM_CABE[07]:='QtdMinima'   ;VM_MUSC[07]:=mI122
VM_CABE[08]:='Qtd Atual'   ;VM_MUSC[08]:=mI122
VM_CABE[09]:='Vlr Atual'   ;VM_MUSC[09]:=mI122
VM_CABE[10]:='Vlr Venda'   ;VM_MUSC[10]:=mD83
VM_CABE[11]:='Dt Movto'    ;VM_MUSC[11]:=mDT
VM_CABE[12]:='Dt Compra'   ;VM_MUSC[12]:=mDT
VM_CABE[13]:='Vlr Compra'  ;VM_MUSC[13]:=masc(05)
VM_CABE[14]:='Qtd-Anterior';VM_MUSC[14]:=mI122
VM_CABE[15]:='Vlr-Anterior';VM_MUSC[15]:=mI122
VM_CABE[16]:='ABC-Vl Venda';VM_MUSC[16]:=mUUU
VM_CABE[17]:='ABC-Vl Est'  ;VM_MUSC[17]:=mUUU
VM_CABE[18]:='Tipo'        ;VM_MUSC[18]:=mI2
VM_CABE[19]:='Qtd-Reserv'  ;VM_MUSC[19]:=mI122
VM_CABE[20]:='%Lucro'      ;VM_MUSC[20]:=masc(20)
VM_CABE[21]:='%Vendedor'   ;VM_MUSC[21]:=masc(20)
VM_CABE[22]:='%I.P.I.'     ;VM_MUSC[22]:=masc(20)
VM_CABE[23]:='CodTrib'     ;VM_MUSC[23]:=mUUU
VM_CABE[24]:='CTrib-CF'    ;VM_MUSC[24]:=mUUU //?
VM_CABE[25]:='%I.C.M.S.'   ;VM_MUSC[25]:=masc(20)
VM_CABE[26]:='%Tribut'     ;VM_MUSC[26]:=masc(20)
VM_CABE[27]:='ImpEtiq'     ;VM_MUSC[27]:=mUUU

set key K_ALT_A to CorrigePISOFINS()
set key K_ALT_B to ExpRegMCN_PH()
set key K_ALT_C to Verif_RegMCN()

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MUSC,VM_CABE)

set key K_ALT_A to
set key K_ALT_B to
set key K_ALT_C to

// dbcommit()
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function ExpRegMCN_PH()
*-----------------------------------------------------------------------------*
go top
	pb_ligaimp(,'C:\TEMP\PRODNCM.CSV')
	ORDEM CODIGO
	while !eof()
		?'*'+pb_zer(PR_CODPR,14)+';'
		??'0;'// TABELA PIS
		??'0;'// ITEM TABALA PIS
		??PR_CODNCM+'000;'
		??'0;'// Genero
		??'0;'// Tabela Bebidas
		??'0;'// Marca Registrada
		??'0'// Codigo do Grupo
		SKIP
	end
	pb_deslimp()
go top
return NIL

*-----------------------------------------------------------------------------*
function Verif_RegMCN()
*-----------------------------------------------------------------------------*
if pb_msg("Validar NCM contra Tabela IBPTax?")
	ORDEM CODIGO
	go top
	if pb_ligaimp()
		?padc("CODIGOS NCM ERRADOS NO CADASTRO DE PRODUTOS-ARRUMAR",80)
		?
		?padr("Produto",40)+padc("COD NCM",10)
		while !eof()
			if !NCM->(dbseek(PROD->PR_CODNCM))
				?pb_zer(PR_CODPR,L_P)+'-'+left(PR_DESCR,30)+" - "
				??PR_CODNCM
			end
			SKIP
		end
		?replicate("-",80)
		?time()
		pb_deslimp()
		go top
	end
end

return NIL


*-----------------------------------------------------------------------------*
function CFEP4201() // Rotina de Inclus„o
*-----------------------------------------------------------------------------*
private VM_CODGR:=PR_CODGR
while lastkey()#27
	dbgobottom()
	dbskip()
	CFEP4200T(.T.)
	dbrunlock(recno())
	VM_CODGR:=PR_CODGR
	if lastkey()#K_ESC
		keyboard chr(K_ENTER)
	end
end
return NIL
*-----------------------------------------------------------------------------*
 function CFEP4202() // Rotina de Alteracao
*-----------------------------------------------------------------------------*
if reclock()
	CFEP4200T(.F.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
  function CFEP4200T(VM_FL)
*-----------------------------------------------------------------------------*
local GETLIST := {}
local LCONT:=.T.
local VM_X
local ORDANT:=indexord()

if type('VM_CODGR')#'N'
	private VM_CODGR
	default VM_CODGR to PR_CODGR
end
for VM_X:=2 to fcount()
	VM_Y :='VM'+substr(fieldname(VM_X),3)
	&VM_Y:=&(fieldname(VM_X))
next
if VM_FL
	VM_PTRIB:=100
	VM_CTB  :=  4
	VM_PICMS:= 17
	dbsetorder(2)
	dbgobottom()
	VM_CODPR:=PR_CODPR + 1
end
VM_CODTR  :=if(empty(VM_CODTR ) ,'000',		VM_CODTR )
VM_CODTRE :=if(empty(VM_CODTRE) ,'000',		VM_CODTRE)
VM_IMPET  :=if(empty(VM_IMPET ) ,'S',			VM_IMPET )
VM_MODO   :=if(empty(VM_MODO  ) ,'N',			VM_MODO  )
VM_CTRL   :=if(empty(VM_CTRL  ) ,'S',			VM_CTRL  )
VM_PISCOF :=if(empty(VM_PISCOF) ,'N',			VM_PISCOF)
VM_ITEMTAB:=if(empty(VM_ITEMTAB),'000',		VM_ITEMTAB)
VM_CODNCM :=if(empty(VM_CODNCM), '00000000',	VM_CODNCM)
VM_CODGEN :=if(empty(VM_CODGEN), '000',		VM_CODGEN)

pb_box(05,00,,,,'Cadastro de Produtos')
@06,01 say 'Grupo.......:' get VM_CODGR   pict masc(13) valid fn_codigo(@VM_CODGR,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_CODGR,6)))},{||CFEP4100T(.T.)},{2,1}}).and.VM_CODGR%10000#0
@07,01 say 'C¢d Produto.:' get VM_CODPR   pict masc(21) valid !empty(VM_CODPR).and.pb_ifcod2(str(VM_CODPR,L_P),'PROD',.F.,2) when VM_FL
@08,01 say 'Descricao...:' get VM_DESCR   pict mUUU     valid !empty(VM_DESCR)	when pb_msg('Descricao do Produto')
@07,30 say 'Compl:'        get VM_COMPL   pict mUUU 										when pb_msg('Complemento da Descricao do Produto')

@09,01 say 'Unid.Armaz..:' get VM_UND     pict mUUU     valid !empty(VM_UND)    .and.fn_codigo(@VM_UND,    {'UNIDADE',{||UNIDADE->(dbseek(VM_UND))},    {||CFEPUNT(.T.)},{2,1}})
@10,01 say 'Unid.Tribut.:' get VM_UNDTRIB pict mUUU     valid !empty(VM_UNDTRIB).and.fn_codigo(@VM_UNDTRIB,{'UNIDADE',{||UNIDADE->(dbseek(VM_UNDTRIB))},{||CFEPUNT(.T.)},{2,1}}) when pb_msg('NFe-Codigo da Unidade Tributável').and.(VM_UNDTRIB:=if(empty(VM_UNDTRIB),VM_UND,VM_UNDTRIB))>=''
@11,01 say 'Tipo Estoque:' get VM_CTB     pict masc(11) valid fn_codar(@VM_CTB,'ESTOQUE.ARR')	when pb_msg('Tipo de Conta de Estoque')
@12,01 say 'Local.......:' get VM_LOCAL   pict mUUU															when pb_msg('local de Armazenamento')

@18,01 say 'CST Entrada.:' get VM_CODTRE  pict mI3      valid fn_codigo(@VM_CODTRE,{'CODTR',{||CODTR->(dbseek(VM_CODTRE))},{||NIL},{2,1,3}})
@19,01 say 'CST Saida...:' get VM_CODTR   pict mI3      valid fn_codigo(@VM_CODTR, {'CODTR',{||CODTR->(dbseek(VM_CODTR ))},{||NIL},{2,1,3}})

@13,01 say 'TIPI........:' get VM_TIPI    pict mI2      valid VM_TIPI  >=0    when pb_msg('TIPI-Tabela Incidencia Imposto sobre Produtos Industrializado')
@14,01 say '% I.P.I.....:' get VM_PIPI    pict masc(20) valid VM_PIPI  >=0    when pb_msg('% Padrao de IPI para a compra (Entrada Completa)')
@15,01 say '% I.C.M.S...:' get VM_PICMS   pict masc(20) valid VM_PICMS >=0    when pb_msg('% Padrao de ICMS para a venda (SAIDAS)')                              .and.(if(VM_CODTR$'000#020',.T.,(VM_PICMS:=0)<0))
@16,01 say '% Trib Base.:' get VM_PTRIB   pict masc(20) valid VM_PTRIB > 0.AND.VM_PTRIB <=100 when pb_msg('% Tributacao sobre o % de ICMS para a venda (SAIDAS)').and.(if(VM_CODTR#'020',(VM_PTRIB:=100)<0,.T.))

@09,34 say 'PesoKg:'       get VM_PESOKG  pict mI102    valid VM_PESOKG>=0		when pb_msg('Peso por Unidade de Armazenamento')
@10,34 say 'Origem:'       get VM_ORIGEM  pict mI1      valid VM_ORIGEM<=2		when pb_msg('0-Nacional 1-Estrang Importacao Direta 2-Estrang Importacao Mercado Interno')
@13,34 say 'ClFiscal:'     get VM_CFISIPI pict mUUU                           when pb_msg('Classificacao fiscal IPI - NFs (9999.99.99)').and.PARAMETRO->PA_CONTAB==USOMODULO

@15,34 say 'PisCofins(E):' get VM_CODCOE  pict mUUU     valid ChkPisCofins(@VM_CODCOE) when pb_msg('Tabela de Pis/Cofins para Entrada').and.PARAMETRO->PA_CONTAB==USOMODULO
@16,34 say 'PisCofins(S):' get VM_CODCOS  pict mUUU     valid ChkPisCofins(@VM_CODCOS) when pb_msg('Tabela de Pis/Cofins para Saida')  .and.PARAMETRO->PA_CONTAB==USOMODULO
@17,34 say 'Item-Tabela.:' get VM_ITEMTAB pict mI3                                     when pb_msg('Tabelas do Pis/Cofins - 4.3.10 ate 4.3.16 - PARA itens Saidas Diferete S01').and.VM_CODCOS#'S01'.and.PARAMETRO->PA_CONTAB==USOMODULO

*----------------------------------------------------------------------------------------------------//
// @08,55 say 'Codigo NCM..:' get VM_CODNCM  pict mI10     valid fn_codigo(@VM_CODNCM, {'NCM',{||NCM->(dbseek(VM_CODNCM))},{||NIL},{4,1,3}})  when pb_msg('Nro Codigo - Nomenclatura Comum Mercosul')
@09,55 say 'Genero......:' get VM_CODGEN  pict mI3      valid !Empty(VM_CODGEN) when pb_msg('Nro Genero - SPED-Fiscal (Tabela 4.2.1)').and.PARAMETRO->PA_CONTAB==USOMODULO

@11,55 say 'Imp.Etiqueta:' get VM_IMPET   pict mUUU     valid VM_IMPET  $'SN' when pb_msg('Imprimir etique para este produto ?   <S>im <N>ao')
@12,55 say 'CTB Estoque.:' get VM_MODO    pict mUUU     valid VM_MODO   $'ND' when pb_msg('Forma de Contabilizacao do Estoque  <N>ormal   <D>ebito Direto').and.PARAMETRO->PA_CONTAB==USOMODULO

@13,55 say 'Ctrl Estoque:' get VM_CTRL    pict mUUU     valid VM_CTRL   $'SN' when pb_msg('Controlar Estoque <S>IM  <N>NAO')                               .and.PARAMETRO->PA_CONTAB==USOMODULO
@15,55 say '%Acres.Compr:' get VM_LUCRO   pict masc(06)                       when pb_msg('%Acrescimo/Dimunuicao p/compor valor unitario de venda no momento da compra')
@16,55 say '%Acres.Venda:' get VM_PERVEN  pict masc(06)                       when pb_msg('%Acrescimo/Dimunuicao para compor venda a Prazo (30 dd)')
@17,55 say '%Comis.Venda:' get VM_PRVEN   pict masc(06) valid VM_PRVEN>=0     when pb_msg('% de comissao expecifica deste produto para todos os vendedores')

@20,01 say 'Obs Pad Prod:' get VM_CODOBS  pict mXXX     valid empty(VM_CODOBS).or.fn_codigo(@VM_CODOBS, {'XOBS',{||XOBS->(dbseek(VM_CODOBS))},{||FISPOBST(.T.)},{2,1}}) color 'GR+/G,R+/W'

if PARAMETRO->PA_CONTAB==USOMODULO
	@21,01 say 'Energia/Comun/Agua:' color 'GB+/G'
	@21,23 say 'Classe:'    get VM_CLCONS       pict mI4 when pb_msg('Classe de Consumo para SPED - PH-REG45')
	@21,37 say 'TpLigacao:' get VM_TPLIGA       pict mI1 when pb_msg('Tipo de Ligacao para SPED - PH-REG45')
	@21,51 say 'GrTensao:'  get VM_GRTENS       pict mI2 when pb_msg('Grupo de Tensao para SPED - PH-REG45')
	@21,65 say 'TpAssinat:' get VM_TPASSI       pict mI2 when pb_msg('Tipo de Assinatura para SPED - PH-REG45')
end

//@11,35 say 'C¢d.NBM:'      get VM_CODNBM  pict mUUU+'S10'                     when pb_msg('Codigo - Nomenclatura Brasileira de Mercadorias')
//@12,01 say 'Est.Minimo..:' get VM_ETMIN   pict masc(06) valid VM_ETMIN >= 0
//@13,55 say 'Pis/Cofins..:' get VM_PISCOF  pict mUUU     valid VM_PISCOF $'SN' when pb_msg('Produto com Recolhimento de Pis/Cofins ?   <Sim>   <Nao>').and.PARAMETRO->PA_CONTAB==USOMODULO
//@17,01 say 'C¢d.Aliquota:' get VM_CFTRIB  pict mUUU     valid VM_CFTRIB=='II'.or.fn_codigo(@VM_CFTRIB,{'ALIQUOTAS',{||ALIQUOTAS->(dbseek(VM_CFTRIB))},{||NIL},{2,1,3}}).and.if(VM_FL,(VM_PICMS:=ALIQUOTAS->AF_ALIQUO)>=0,.T.) when pb_msg('Código da aliquota para impressora fiscal').and.PARAMETRO->PA_EMCUFI

read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL	// Item Novo
		while !pb_ifcod2(str(VM_CODPR,L_P),'PROD',.F.,2)
			beeperro()
			beeperro()
			VM_CODPR++
			alert('*** ALERTA ***;Codigo do produto esta sendo cadastrado;Alterado para '+str(VM_CODPR,L_P))
		end
		LCONT:=AddRec()
		replace 	PR_CODPR with VM_CODPR,;
					PR_DTCAD with PARAMETRO->PA_DATA
		dbcommit()
	end
	if LCONT
		if !VM_FL.and.VM_CTB#PR_CTB.and.(VM_CTB==98.or.PR_CTB==98.or.VM_CTB==97.or.PR_CTB==97)
			salvabd(SALVA)
			select('MOVEST')
			dbseek(str(VM_CODPR,L_P),.T.)
			while !eof().and.VM_CODPR==ME_CODPR
				if reclock()
					replace ME_CTB with VM_CTB
					dbrunlock(recno())
				end
				dbskip()
			end
			salvabd(RESTAURA)
		end
		for VM_X:=1 to fcount()
			VM_Y:="VM"+substr(fieldname(VM_X),3)
			replace &(fieldname(VM_X)) with &VM_Y
		next
		dbcommit()
		dbskip(0)
	end
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEP4203() // Rotina de Pesquisa
*-----------------------------------------------------------------------------*
CHAVE2:={'Grupo','C¢digo','Descri‡„o'}
CHAVE3:={masc(13),masc(21),'@K!S20'}
CFEP4205()
CHAVE1:=if(indexord()=1,PR_CODGR,if(indexord()=2,PR_CODPR,PR_DESCR))
pb_box(20,28)
@21,30 say 'Pesquisar '+padr(CHAVE2[indexord()],12,'.') get CHAVE1 picture CHAVE3[indexord()]
read
setcolor(VM_CORPAD)
dbseek(transform(CHAVE1,CHAVE3[indexord()]),.T.)
return NIL

*-----------------------------------------------------------------------------*
 function CFEP4204() // Rotina de Exclusao
*-----------------------------------------------------------------------------*
if reclock().and.pb_sn('Excluir PRODUTO..:'+pb_zer(PR_CODPR,L_P)+chr(45)+trim(PR_DESCR))
	if str(PR_QTATU+PR_VLATU,15,3)==str(0,15,3)
		MOVEST->(dbseek(str(PROD->PR_CODPR,L_P),.T.))
		if MOVEST->ME_CODPR#PROD->PR_CODPR
			fn_elimi()
		else
			beeperro()
			pb_msg('Produto com Movimento Estoque;Impossivel excluir.',3,.T.)
		end
	else
		beeperro()
		pb_msg('Produto com saldo;Impossivel excluir;',3,.T.)
	end
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
 function CFEP4205() // Mudanca de Ordem
*-----------------------------------------------------------------------------*
nX:=indexord()
pb_box(18,64)
@19,66 prompt padc('Grupo',11)
@20,66 prompt padc('C¢digo',11)
@21,66 prompt padc('Descri‡„o',11)
menu to nX
if lastkey() # K_ESC
	dbsetorder(nX)
	DbGoTop()
end
return NIL

*-------------------------------------------------------------------------
static function CorrigePISOFINS()
*-------------------------------------------------------------------------
nX:=1
if !pb_sn('Esta rotina muda o Codigo de PIS/COFINS;conforme tabela enviada em 13/05/2011')
	return NIL
end
go top
while !eof()
	pb_msg('Convertendo codigo PIS/COFINS - Produto:'+str(PR_CODPR,10)+'-'+PR_DESCR)
	nX++
	if reclock()
		if PR_CODCOE=='AZE'
			replace PR_CODCOE with 'E73'
		elseif PR_CODCOE=='IMO'
			replace PR_CODCOE with 'E70'
		elseif PR_CODCOE=='ISE'
			replace PR_CODCOE with 'E71'
		elseif PR_CODCOE=='ISP'
			replace PR_CODCOE with 'E71'
		elseif PR_CODCOE=='IST'
			replace PR_CODCOE with 'E71'
		elseif PR_CODCOE=='SJT'
			replace PR_CODCOE with 'E72'
		elseif PR_CODCOE=='SUB'
			replace PR_CODCOE with 'E75'
		elseif PR_CODCOE=='SUP'
			replace PR_CODCOE with 'E75'
		elseif PR_CODCOE=='TIS'
			replace PR_CODCOE with 'E50'
		elseif PR_CODCOE=='TRI'
			replace PR_CODCOE with 'E50'
		else
			if !PR_CODCOE+'|'$'E50|E70|E71|E72|E73|E75|'
				alert('Produto:'+str(pr_codpr)+'-'+pr_descr+';Com codigo PIS/COFINS de entrada='+PR_CODCOE+';Nao corresponde a tabela enviada. Alterar manualmente.')
			end
			replace PR_CODCOE with 'E71'
		end
		if PR_CODCOS=='AZE'
			replace PR_CODCOS with 'S06'
		elseif PR_CODCOS=='IMO'
			replace PR_CODCOS with 'S04'
		elseif PR_CODCOS=='ISE'
			replace PR_CODCOS with 'S07'
		elseif PR_CODCOS=='ISP'
			replace PR_CODCOS with 'S07'
		elseif PR_CODCOS=='IST'
			replace PR_CODCOS with 'S07'
		elseif PR_CODCOS=='SJT'
			replace PR_CODCOS with 'S09'
		elseif PR_CODCOS=='SUB'
			replace PR_CODCOS with 'S05'
		elseif PR_CODCOS=='SUP'
			replace PR_CODCOS with 'S09'
		elseif PR_CODCOS=='TIS'
			replace PR_CODCOS with 'S01'
		elseif PR_CODCOS=='TRI'
			replace PR_CODCOS with 'S01'
		else
			if !PR_CODCOS+'|'$'S01|S04|S05|S06|S07|S09|'
				alert('Produto:'+str(pr_codpr)+''+pr_descr+';Com codigo PIS/COFINS de saida='+PR_CODCOS+';Nao corresponde a tabela enviada. Alterar manualmente.')
			end
			replace PR_CODCOS with 'S07'
		end
	end
	
	if empty(PR_CODTRE)
		PR_CODTRE:='040'
	end
	if empty(PR_CODTR )
		PR_CODTR	:='040'
	end
	dbrunlock(recno())
	skip
end
go top
pb_msg('')
alert('Alteracao PIS/COFINS Finalizada')

return NIL
*-------------------------------------------EOF------------------------------
