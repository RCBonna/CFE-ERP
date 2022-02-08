#include 'RCB.CH'

//-----------------------------------------------------------------------------*
	function CFEPVEBB()	//	Atualizacao															*
//-----------------------------------------------------------------------------*
local TF
local ORDANT

if !abre({	'C->PARAMETRO',;
				'C->DIARIO',;
				'C->CTRNF',;
				'C->GRUPOS',;
				'R->NCM',;
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
				'R->ENTCAB',; // Buscar NFE-Devolução
				'R->ENTDET',; // Buscar NFE-Devolução - itens da NF
				'C->PEDCAB',;
				'C->PEDDET',;
				'C->PEDSVC',;
				'C->CTADET',;
				'C->CTACTB',;
				'R->LOTEPAR',;
				'C->PARALINH',;
				'C->FISACOF',;
				'C->ADTOSD',;	//ADIANTAMENTO A CLIENTE - DETALHE
				'C->ADTOSC',;	//ADIANTAMENTO A CLIENTE - CABEÇALHO
				'C->NATOP'})
	return NIL
end
pb_tela()
pb_lin4('Atualiza de Pedidos',ProcName())

select('PROD');dbsetorder(2) // Produtos
select('PEDCAB');dbsetorder(2) // Pedido  Cabec
set relation to str(PC_CODCL,5) into CLIENTE
DbGoTop()

private VM_OPC	   :=VM_TOT:=VM_CLI:=VM_VEND:=VM_ICMSPG:=VM_PARCE:=VM_DESCG:=VM_DESCIT:=VM_ULTPD:=VM_ULTDP:=VM_NSU:=0
private VM_OBS  	:=space(132)
private VM_SVC  	:=space(80)
private VM_DTEMI	:=PC_DTEMI
private VM_BCO  	:=1
private VM_CODCG	:=1
private VM_FLADTO	:='N'
private VM_RT   	:=.T.
private VM_ICMT	:={0,0}	// Valor total ICMS, Base Total ICMS
private VM_DET  	:=VM_FAT:=VM_ICMS:={}

salvacor(SALVA)
setcolor('GR+/BG,R/W,,,GR+/BG')
scroll(01,01,03,50,0)
@01,01 say 'Nr.Pedido.:' get VM_ULTPD pict masc(19) valid fn_pedped(@VM_ULTPD,.F.).and.(VM_DTEMI:=PC_DTEMI)>=ctod('') when pb_msg('Infome N§ Pedido a ser Autorizado')
@01,23 say 'Dt.Emissao:' get VM_DTEMI pict masc(07) valid VM_DTEMI>PARAMETRO->PA_DATA-10                              when pb_msg('Infome Data de EmissÆo do Pedido/NF')
read
if lastkey()==K_ESC
	dbcloseall()
	return NIL
elseif !reclock() // Travar Registro
	dbcloseall()
	return NIL
end

private VM_SERIE :=PC_SERIE
private VM_CODOP :=PC_CODOP
*-------------------------------------------------------Devolução
private VM_DEVNFE:=PC_NFEDEV //.Nr Chave NFE
private VM_DEVNNF:=0 //................Nr NF
private VM_DEVSER:=space(003) //.......Serie
private VM_DEVDTE:=ctod('')//..........DT Emissão
*------------------------------------------------------
VM_PARCE :=PC_FATUR
VM_CLI   :=PC_CODCL
VM_VEND  :=PC_VEND
VM_TOT   :=PC_TOTAL
VM_DESCIT:=PC_DESCIT
VM_ULTDP :=VM_ULTPD
VM_OBS   :=PC_OBSER


@01,47 say 'N§Parcelas '+transform(VM_PARCE,masc(11))
@02,01 say 'Cliente...: '+transform(VM_CLI,masc(4))+'-'+CLIENTE->CL_RAZAO
if PARAMETRO->PA_VENDED==USOMODULO
	VENDEDOR->(dbseek(str(VM_VEND,3)))
	@03,01 say 'Vendedor..:   '+transform(VM_VEND,masc(12))+'-'+VENDEDOR->VE_NOME
end
salvacor(RESTAURA)

if !fn_libcli(VM_PARCE>0)
	dbcloseall()
	return NIL
end

	VM_DET :=fn_rtprdped(VM_ULTPD)
	VM_ICMS:=FN_ICMSC(VM_DET)

	aeval(VM_DET,{|DET|DET[6]:=round(DET[4] * DET[5],2)}) // Calcular Total

setcolor('W+/B,N/W,,,W+/B')
scroll(5,0,23,79,0)

@22,01 say 'TOTAL do Pedido.: '+transform(PC_TOTAL,masc(2))
@23,01 say 'Desconto Geral..: '+transform(PC_DESC, masc(2))
VM_OBS:=PC_OBSER
@22,35 say 'Observa‡”es'
@23,35 say left(VM_OBS,45)
pb_msg('Press <Enter> para Continuar.',NIL,.F.)
abrowse(5,1,21,78,;
			VM_DET,;
			{'Sq',     'Prod.','Descricao','Qtdade','Vlr Venda','Vlr Total','Enc Financ',   'CT',   '%ICMS', 'Unid','%Tribut'},;
			{ 2,           L_P,         20,      10,         15,        15,          15,      2,         5,      6,       6  },;
			{masc(11),masc(21),    masc(1), masc(6),    masc(2),   masc(2),      masc(2),masc(11), masc(14),masc(1),masc(20)  })

*---------------------------------------------------------------Roda pe da NOTA
pb_msg('F10 para arq OBS',NIL,.F.)
set function 10 to '+'+chr(13)
@23,35 get VM_OBS pict masc(1)+'S45' valid fn_obs(@VM_OBS)
read
set function 10 to
if lastkey()#K_ESC
	VM_FAT:={}
	if VM_PARCE>0
		VM_FAT:=fn_retparc(VM_ULTPD,VM_PARCE,VM_ULTPD)
	end
	if PEDCAB->PC_FATUR # len(VM_FAT)
		beeperro()
		Alert('Nao encontrado registros no arquivo;de parcelamento o Pedido:'+str(PEDCAB->PC_PEDID,6)+';RECOMENDADO EXCLUIR E INCLUIR NOVAMENTE ESTE PEDIDO')
		replace PEDCAB->PC_FATUR with len(VM_FAT)
	end
	replace  PC_DTEMI with VM_DTEMI,;
				PC_OBSER with VM_OBS
	// dbcommitall()
	VM_DTSAI:=VM_DTEMI
	pb_msg('Selecione uma Op‡Æo',NIL,.F.)
	VM_OPC:=	{' 1-Atualizar Cadastro Cliente'     ,;
				 ' 2-Consultar Duplicatas Pendentes' ,;
				 ' 3-Atualizar Dados Consultados SPC',;
				 ' 4-Reimprimir Pedido de Venda'     ,;
				 ' ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ',;
				 ' 5-Imprimir Carne de Pagamento'    ,;
				 ' 6-Concluir Venda/Atualizar'       ,;
				 ' 0-Sair desta Tela'                 }
	VM_SEL:=1
	while VM_SEL>0
		pb_box(13,0,22,36,'R+/W*','Selecione')
		VM_SEL:=achoice(14,01,21,35,VM_OPC)
		if VM_SEL>0
			TF:=savescreen()
			if VM_SEL==1	// CADASTRO CLIENTE
				salvabd(SALVA)
				select('CLIENTE')
				if reclock()
					CFEP3100T(.F.)
				end
				salvabd(RESTAURA)
			elseif VM_SEL==2	// CONSULTA DPL PENDENTES
				salvabd(SALVA)
				select('DPCLI')
				ORDANT:=indexord()
				dbsetorder(5)
				fn_consdpl(VM_CLI)
				dbsetorder(ORDANT)
				salvabd(RESTAURA)
			elseif VM_SEL==3	// ATUALIZA CONSULTA SPC
				salvabd(SALVA)
				select('CLIENTE')
				fn_conspc()
				salvabd(RESTAURA)
			elseif VM_SEL==4	// Reimprimir
				CFEPVEBC(VM_FAT) // vendas balcao impressao do pedido
			elseif VM_SEL==5
				tone(1000,1)
			elseif VM_SEL==6	// 5-Carne
				if len(VM_FAT)>0
					fn_impcarne(VM_CLI,CLIENTE->CL_RAZAO,VM_FAT,VM_DTEMI) // no arquivo FN_IMPCA.PRG
				else
					alert('Faturamento a vista')
				end
			elseif VM_SEL==7	// 6-Atualizar
				CFEPVEBD(VM_FAT)
				VM_SEL:=0
			elseif VM_SEL==8	// Sair
				VM_SEL:=0
			end
			restscreen(,,,,TF)
		end
	end
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function FN_PEDPED(P1,P2) //----------BROWSE PEDIDO
*-----------------------------------------------------------------------------*
local RT:=.T.,TF:=savescreen(6,0,21,79),OPC:=1
if !P2
	dbsetorder(2) // so os nao atualizados
elseif P1==0
	OPC:=alert('Quais os pedidos a ser mostrados',{'Abertos','Todos'})
	if OPC==1
		dbsetorder(2) // so os nao atualizados
	else
		dbsetorder(1) // Todos
	end
end
if !dbseek(str(P1,6))
	DbGoTop()
	salvacor(.T.)
	setcolor('W+/B,B/W,,,,W+/B')
	dbedit(06,01,maxrow()-3,maxcol()-1,;
			{'str(PC_PEDID,6)+if(PC_FLAG,"-F","-a")','str(PC_CODCL,5)+"-"+CLIENTE->CL_RAZAO','PC_DTEMI', 'PC_TOTAL',	'PC_DESC'	},,;
			{                               masc(23), 	mUUU+'S30' ,  									  mDT   ,		mD82,			mD82	},;
			{                             'N§Pedido',		'Cliente',									 'Emiss„o',	'Vlr Total','Desconto'	})
	SalvaCor(.F.)
	P1:=PC_PEDID
	if lastkey()#K_ESC
		keyboard chr(13)
	end
	RT:=.F.
	restscreen(6,0,21,79,TF)
end
return(RT)
//------------------------------------[EOF]-----------------------------------------*
