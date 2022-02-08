*---------------------------------------------------* PARAMETROS GERAIS
	function CRIA_PA()
*---------------------------------------------------* PARAMETROS GERAIS
#include 'RCB.CH'

local ARQ:='CFEAPA'
if dbatual(ARQ,;
				{{'PA_ENDER',   'C', 45,  0},;	// 01 Endere‡o Empresa
				 {'PA_CEP'  ,   'C',  8,  0},;	// 02 CEP
				 {'PA_CIDAD',   'C', 20,  0},;	// 03 Cidade
				 {'PA_UF'   ,   'C',  2,  0},;	// 04 UF
				 {'PA_FONE' ,   'C', 15,  0},;	// 05 FONE
				 {'PA_FAX'   ,  'C', 15,  0},;	// 06 FAX
				 {'PA_DATA' ,   'D',  8,  0},;	// 07 Data do Sistema
				 {'PA_MOEDA',   'C', 10,  0},;	// 08 Nome Moeda Estavel
				 {'PA_VALOR',   'N', 10,  3},;	// 09 Valor da Moeda
				 {'PA_HTFOR',   'N',  5,  0},;	// 10 Tempo Hist.Fornecedor
				 {'PA_HTCLI',   'N',  5,  0},;	// 11 Tempo Hist.Cliente
				 {'PA_PEDCAB',  'C',  1,  0},;	// 14 Imprime Cabec no Pedido ?
				 {'PA_ARRED',   'N',  2,  0},;	// 15 Codigo de Arredondamento
				 {'PA_DESCV',   'N',  7,  2},;	// 16 % Desconto a vista
				 {'PA_VZIPD',   'N',  2,  0},;	// 17 Numero IMPRESSÃO DO Pedido
				 {'PA_TIPPD',   'N',  2,  0},;	// 17 Tipo de IMPRESSÃO DO Pedido (1,2)
				 {'PA_COFIN',   'N',  7,  2},;	// 18 % COFINS DA EMPRESA
				 {'PA_PRPIS',   'N',  7,  2},;	// 19 % PIS DA EMPRESA
				 {'PA_ENCAR',   'N',  7,  2},;	// 20 % Encargos Sociais
				 {'PA_SALAR',   'N',  7,  2},;	// 21 % Salarios
				 {'PA_DESPE',   'N',  7,  2},;	// 22 % Desp.Diversas
				 {'PA_ICMSS',   'N',  7,  2},;	// 23 % ICMS Saida - Previsao
				 {'PA_IMPOU',   'N',  7,  2},;	// 24 % Outros Impostos
				 {'PA_LUCRO',   'N',  7,  2},;	// 25 % Margen de Lucro (9999,99)
				 {'PA_1PGTO',   'N',  3,  0},;	// 26 1§ Pagamento / Parcelamento
				 {'PA_OPGTO',   'N',  3,  0},;	// 27 Outros Pagamentos/ Parcelamento
				 {'PA_TPPRZ',   'C',  1,  0},;	// 28 Tipo de Prazo DD PM
				 {'PA_LIVEN',   'N',  3,  0},;	// 29 NUMERO LIVRO ENTRADA
				 {'PA_LIVSA',   'N',  3,  0},;	// 30 NUMERO LIVRO SAIDA
				 {'PA_LIVIV',   'N',  3,  0},;	// 31 NUMERO LIVRO INVENTARIO
				 {'PA_LIVRD',   'N',  3,  0},;	// 32 NUMERO LIVRO DUPLICATAS
				 {'PA_PAGEN',   'N',  3,  0},;	// 33 PAGINA LIVRO ENTRADA
				 {'PA_PAGSA',   'N',  3,  0},;	// 34 PAGINA LIVRO SAIDA
				 {'PA_PAGIV',   'N',  3,  0},;	// 35 PAGINA LIVRO INVENTARIO
				 {'PA_PAGRD',   'N',  3,  0},;	// 36 PAGINA LIVRO DUPLICATAS
				 {'PA_SEQEN',   'N',  5,  0},;	// 37 Sequencia ENTRADA
				 {'PA_SEQSA',   'N',  5,  0},;	// 38 Sequencia SAIDA
				 {'PA_SEQRD',   'N',  5,  0},;	// 39 Sequencia Livro Reg DUPLICATAS
				 {'PA_VENDED',  'C',  2,  0},; 	// 40 Modulo de Vendedor (255)(25)
				 {'PA_CONTAB',  'C',  2,  0},; 	// 41 Modulo de CONTABIL (255)(25)
				 {'PA_CHKVEN',  'C',  2,  0},; 	// 42 Modulo de CHK VENDA(255)(25)
				 {'PA_NRASPC',  'N',  5,  0},; 	// 43 Nr Associado SPC
				 {'PA_AVALIS',  'L',  1,  0},; 	// 44 Necessita Avalista ? (CLIENTE)
				 {'PA_PJUROS',  'N',  6,  3},; 	// 45 % Juros Max Recebimento em Atrso
				 {'PA_SERFF1',  'L',  1,  0},; 	// 46 xxx
				 {'PA_CGC',     'C', 14,  0},; 	// 47 xxx
				 {'PA_INSCR',   'C', 10,  0},; 	// 48 xxx
				 {'PA_L_P',     'N',  2,  0},;	// 49 Tamanho de Codigo Produto
				 {'PA_NRLCUP',  'N',  2,  0},;	// 50 NR DE LINHA PARA PULAR
				 {'PA_EDVCUP',  'L',  1,  0},;	// 51 EDITAR VALOR VENDA ?
				 {'PA_EDQCUP',  'L',  1,  0},;	// 52 EDITAR QTDADE VENDA ?
				 {'PA_EMCUFI',  'L',  1,  0},;	// 53 EMITE CUPOM FISCAL ?
				 {'PA_CONVEN',  'L',  1,  0},;	// 54 TEM CONVENIO ?
				 {'PA_VBPEAT',  'L',  1,  0},;	// 55 Venda Balcao Pede atualizacao no pedido
				 {'PA_OBSCUP',  'C', 80,  0},; 	// 56 obs PARA cupom 40 + 40
				 {'PA_TIPOCUP', 'N',  2,  0},; 	// 57 Tipo de Impressora
				 {'PA_EFINCUP', 'L',  1,  0},; 	// 58 Dig Vlr Financiamento p/Venda Cupom ?
				 {'PA_EDESCUP', 'L',  1,  0},; 	// 59 Dig Vlr Desconto p/Venda Cupom ?
				 {'PA_RECICR',  'C',  1,  0},; 	// 60 Recibo no contas a receber
				 {'PA_RECICP',  'C',  1,  0},; 	// 61 Recibo no contas a pagar
				 {'PA_BOLETO',  'C',  1,  0},; 	// 62 Controle de Boleto
				 {'PA_FUNRUR',  'N',  6,  2},;	// 63 % Funrural
				 {'PA_LIMEST',  'L',  1,  0},;	// 64 Limpa Movto Estoque
				 {'PA_PORCHE',  'N',  1,  0},;	// 65 Porta de Cheque
				 {'PA_CTBRET',  'N',  4,  0},;	// 66 Conta Retencao    Terminador
				 {'PA_CTBBON',  'N',  4,  0},;	// 67 Conta Bonificacao Iniciador
				 {'PA_VERSAO',  'C', 10,  0},;	// 68 Versao
				 {'PA_CFTIPOF', 'N',  1,  0},;	// 69 Tp Fechamento Cupom Fiscal 0/1/2
				 {'PA_TIPOCAR', 'N',  1,  0},;	// 70 Tp Carne Prestacao
				 {'PA_TIPODPL', 'N',  1,  0},;	// 71 Tp NR DA DUPLICATA
				 {'PA_PARCINT', 'N',  1,  0},;	// 72 Tp PARCELAMENTO INICIAL
				 {'PA_ZOOMPRD', 'N',  2,  0},;	// 73 Tp Zoom para Produto <0,1>
				 {'PA_CFFORMA', 'C',  1,  0},;	// 74 Programado Forma ? <S>
				 {'PA_NRDECVE', 'N',  1,  0},;	// 75 Número de casas decimais para valor de venda
				 {'PA_NRJC',    'C', 15,  0},; 	// 76 Inscricao Junta Comecial
				 {'PA_DTJC',    'D',  8,  0},; 	// 77 Data Inscricao J Coml
				 {'PA_CONVCF',  'L',  1,  0},; 	// 78 Data Inscricao J Coml
				 {'PA_CADCLI',  'C',  1,  0},; 	// 78 Tipo de Cadastro de Clientes < >Basico/Resumido <C>Completo <R>Resumido
				 {'PA_DIRETO',  'C', 50,  0},;	// 79 Diretorio Copia
				 {'PA_FICHCLI', 'C',  1,  0},;	// 80 Imprime ficha cliente completa.
				 {'PA_CDIBGE',  'N',  7,  0},;	// 81 Codigo Municipio IBGE.
				 {'PA_CDSUFRA', 'C',  9,  0},;	// 82 Codigo SUFRAMA.
				 {'PA_CDMUNIC', 'C', 30,  0},;	// 83 Codigo Inscr Municipal
				 {'PA_ENDNRO',  'C', 10,  0},;	// 84 Número Imóvel
				 {'PA_ENDCOMP', 'C', 20,  0},;	// 85 Complemento
				 {'PA_BAIRRO',  'C', 30,  0},;	// 86 Bairro
				 {'PA_EMAIL',   'C', 30,  0},;	// 87 E-mail
				 {'PA_LIVIPI',  'N',  4,  0},;	// 88 Nro Livro IPI - Registro de Apuração
				 {'PA_PAGIPI',  'N',  4,  0},;	// 89 Nr página IPI - Registro de Apuração
				 {'PA_SEQIPI',  'N',  4,  0},;	// 90 Sequencia IPI - Registro de Apuração
				 {'PA_NFEAMB',  'C',  1,  0},;	// 91 Ambiente de trabalho 1=Produção 2=Homologação
				 {'PA_MODNFE',  'C',  2,  0},;	// 92 Modelo e Imprime NFe = 55
				 {'PA_CNAE', 	 'C',  7,  0},;	// 93 Codigo CNAE
				 {'PA_LIMANUA', 'C',  1,  0},;	// 94 Executar Limpeza Anual
				 {'PA_CARENCR', 'N',  3,  0},;	// 95 Número de dias de carência para cobrar Juros
				 {'PA_VBCHKMO', 'N',  1,  0},;	// 96 Venda Balcão-Valida Cadastro 0=Não 1=Sim 30DD 2=Sim 60DD
				 {'PA_PJUROSM', 'N',  6,  3}},; 	// 97 % Juros Min Recebimento em Atrso
				 RDDSETDEFAULT())

	use (ARQ) new EXCLUSIVE
	if lastrec()=0
		dbappend(.T.)
		replace  PA_CEP     with '00000000',;
					PA_CIDAD   with '',;
					PA_UF      with 'SC',;
					PA_MOEDA   with 'US$ Dolar',;
					PA_VALOR   with 1,;
					PA_ARRED   with 1,;
					PA_DATA    with date()-10,;
					PA_HTFOR   with 365*5,;
					PA_HTCLI   with 365*5,;
					PA_ENCAR   with 5,;
					PA_SALAR   with 5,;
					PA_DESPE   with 5,;
					PA_LUCRO   with 25,;
					PA_1PGTO   with  0,;
					PA_OPGTO   with 30,;
					PA_CFFORMA with 'N',;
					PA_CONVCF  with .T.,;
					PA_TPPRZ   with ''
	end
	if PA_L_P < 6 .or. PA_L_P > 20
		replace PA_L_P with 7
	end
	if PA_PORCHE<1
		replace PA_PORCHE with 2
	end
	if empty(PA_DIRETO)
		replace PA_DIRETO with 'C:\TEMP'
	end
	if PA_VZIPD = 0
		replace PA_VZIPD with 1
	end
	if PA_NRDECVE < 1
		replace PA_NRDECVE with 2
	end
	if empty(PA_LIMANUA)
		replace PA_LIMANUA with 'N'
	end
	dbcloseall()
	alert('O programa precisou ajustar parametros internos;Entre Novamente')
	quit
end
while !abre({'R->PARAMETRO'});end
L_P  :=if(PA_L_P<5,7,if(PA_L_P>15,15,PA_L_P))
MPROD:=replicate('9',L_P)
dbcloseall()

return NIL
*--------------------------------------------------------------------eof----------------------
