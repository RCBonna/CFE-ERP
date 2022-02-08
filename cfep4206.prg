*-----------------------------------------------------------------------------*
 function CFEP4206() // Exportar
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local OPC:=alert('Selecione atualizacao Produto:',{'1-Exportar','2-Importar(P)','3-Importar(C)','4-Export-Tudo' } )
if OPC==1
	EXPORTAR1()
elseif OPC==2
	IMPORTAR2()
elseif OPC==3
	IMPORTAR3()
elseif OPC==4
	EXPORTAR2()
end
return NIL

*-----------------------------------------------------------------------------*
 static function EXPORTAR1()
*---------------------------------------------------------------------------*
if pb_sn('Exporta de arquivo de Produtos;Arquivo->..\ENVIO\EXPO_PRD.TXT')
	pb_msg()
	ARQUIVO:='..\ENVIA'
	dirmake(ARQUIVO)
	ARQUIVO+='\EXPO_PRD.TXT'
	set print to (ARQUIVO)
	set print on
	set console off
	ordem CODIGO
	DbGoTop()
	while !eof()
		pb_msg("Exportanto Item "+str(PROD->PR_CODPR,13))
		??'CFE|PRODUTOS'                   +'|'	// 01+02
		??left(pb_zer(PROD->PR_CODGR,6),2) +'|'	// 03-Grupo
		??right(pb_zer(PROD->PR_CODGR,6),4)+'|'	// 04-Sub-Grupo + Sub-Sub-Grupo
		??pb_zer(PROD->PR_CODPR,13)        +'|'	// 05-Codigo Item
		??PROD->PR_DESCR                   +'|'	// 06-Descrição
		??PROD->PR_COMPL                   +'|'	// 07-Complemento Descrição
		??PROD->PR_UND                     +'|'	// 08-Unidade
		??PR_LOCAL						        +'|'	// 09-Local de Armazenagem
		??str(PR_ETMIN*100)			        +'|'	// 10-Estoque Minimo
		??str(PR_QTATU*100)                +'|'	// 11-Qtde.Atual Estoque
		??str(PR_VLATU*100)                +'|'	// 12-Vlr.Estoque (Total) Medio
		??str(PR_VLVEN*1000)               +'|'	// 13-Vlr.Venda   (Unit.)
		??dtoc(PR_DTMOV)                   +'|'   // 14-Dt.Ultima Movim.
		??dtoc(PR_DTCOM)                   +'|'	// 15-Dt.Ultima Compra
		??str(PR_VLCOM*10000)              +'|'	// 16-Vlr.Unitario Ult.Compra-CUSTO
		??str(PR_SLDQT*100)                +'|'	// 17-Qtde.Inicial Periodo
		??str(PR_SLDVL*100)                +'|'	// 18-Valor Inicial Periodo
		??PR_ABCVE                         +'|'	// 19-Classificacao ABC - PCO VENDA
		??PR_ABCET                         +'|'	// 20-Classificacao ABC - VLR.ESTOQUE
		??str(PR_CTB)                      +'|'	// 21-Codigo TIPO PRODUTO
		??str(PR_RESER*100)                +'|'	// 22-Qtdade Reservada (não usado)
		??str(PR_LUCRO*100)                +'|'	// 23-% Lucro adicional do produto p/calculo entrada
		??str(PR_PRVEN*100)                +'|'	// 24-% Comissao para o Vendedor deste produto
		??str(PR_PIPI*100)                 +'|'	// 25-% IPI padrao na entrada
		??PR_CODTR                         +'|'	// 26-Codigo Trib Padrao - sf
		??PR_CFTRIB                        +'|'	// 27-Cupom Fiscal -Aliquota - tabela
		??str(PR_PICMS*100)                +'|'	// 28-% ICMS 
		??str(PR_PTRIB*100)                +'|'	// 29-% TRIB DA BASE ICMS
		??PR_IMPET                         +'|'	// 30-Impressao de Etiqueta
		??PR_CODNBM                        +'|'	// 31-Codigo NBM
		??PR_MODO                          +'|'	// 32-Modo <N>ormal <D>ebito Direto
		??PR_CTRL                          +'|'	// 33-Controla Saldo <S>Sim <N>Nao < >Nao
		??str(PR_PERVEN*100)               +'|'	// 34-% Acrescimo na venda por produto
		??PR_CODTRE                        +'|'	// 35-Codigo Trib Padrao - ENTRADA
		??PR_CODOBS                        +'|'	// 36-Codigo Observacao Padrao Produto
		??PR_PISCOF                        +'|'	// 37-Recolhido Pis/Cofins ?
		??str(PR_PESOKG*100)               +'|'	// 38-Peso KG
		??PR_CODNCM                        +'|'	// 39-Nomemclatura Comercio Mercosul
		??PR_CODCOE                        +'|'	// 40-Codigo PIS/Cofins (Entrada)
		??PR_CODCOS                        +'|'	// 41-Codigo PIS/Cofins (Saida)
		?
		dbskip()
	end
	DbGoTop()
	set console on
	set print off
	set print to

end
return NIL

*-----------------------------------------------------------------------------*
 static function EXPORTAR2()
*-----------------------------------------------------------------------------*
if pb_sn('EXPORTAR TUDO;Exporta de arquivo de Produtos;Arquivo->C:\ENVIO\EXPO_PRD_GERAL.TXT')
	pb_msg()
	ARQUIVO:='C:\TEMP\ENVIA'
	dirmake(ARQUIVO)
	ARQUIVO+='\EXPO_PRD_GERAL.TXT'
	set print to (ARQUIVO)
	set print on
	set console off
	ordem CODIGO
	DbGoTop()

		/*	
		#define DBS_NAME        1
		#define DBS_TYPE        2
		#define DBS_LEN         3
		#define DBS_DEC         4
		#define DBS_FLAG        5
		#define DBS_STEP        6
		*/
		/*
		clear
		*/
	for X:=1 to FCount()
		??Substr(DbFieldInfo( 1, X ),4)+'|'
	next
	?
	while !eof()
		pb_msg("Exportanto Item "+str(PROD->PR_CODPR,13))
		for X:=1 to FCount()
			if FieldType(X)=='D'
				??DtoC(FieldGet(X))
			elseif FieldType(X)=='N'
				??AllTrim(strTran(Str(FieldGet(X),FieldSize(X),FieldDec(X)),'.',','))
			elseif FieldType(X)=='L'
				??if(FieldGet(X),'T','F')
			elseif FieldType(X)=='C'
				??Trim(FieldGet(X))
			end
			??'|' // Token
		next
			? // abre próximo produto
		skip
	end
	DbGoTop()
	set console on
	set print off
	set print to
end
return NIL

*---------------------------------------------------------------------------*
 static function IMPORTAR2()
*---------------------------------------------------------------------------*
local ARQUIVO:='..\RECEBE\EXPO_PRD.TXT'
local LINHA  
local NRLINHAS:=0
if pb_sn('Importacao Tipo 2 (Sem Qtdade);Importar arquivo de Produtos;Arquivo->'+ARQUIVO)
	pb_ligaimp(,'ErrosImp.txt')
	pb_msg('Importando... Ver arquivo de erros - "ErrosImp.Txt"')
	select PROD
	ordem CODIGO
	VM_CAMPO:=array(fcount())
	if (HANDLE:=fopen(ARQUIVO))>0
		LINHA:=''
		CONTINUA:=.T.
		PRIMEIRO:=.T.
		WHILE CONTINUA.and.lerlinha(HANDLE,@LINHA)
			NRLINHAS++
			@24,70 SAY NRLINHAS
			if token(LINHA,'|',02) == 'PRODUTOS'
				VM_CAMPO[01]:=val(token(LINHA,'|',03))*10000		// 1-GRUPO
				VM_CAMPO[01]+=val(token(LINHA,'|',04))*if(val(token(LINHA,'|',04))<100,100,1)	// 1-SGrupo
				VM_CAMPO[02]:=val(token(LINHA,'|',05))				// 2-Cod-PRODUTO
				VM_CAMPO[03]:=    token(LINHA,'|',06)				// 3-Descricao
				VM_CAMPO[04]:=    token(LINHA,'|',07)				// 4-Complemento
				VM_CAMPO[05]:=    token(LINHA,'|',08)				// 5-Unidade
				VM_CAMPO[06]:=val(token(LINHA,'|',13))/1000		//10-Vlr Venda
				VM_CAMPO[07]:=val(token(LINHA,'|',16))/10000		//13-Vlr Custo
				if PRIMEIRO
					? padc('Lista de mensagens de importacao',78)
					? replicate('-',78)
					PRIMEIRO=.F.
				end
				if !dbseek(str(VM_CAMPO[02],L_P))
					?'001 - Item Novo-'+str(VM_CAMPO[02],L_P)+'='+VM_CAMPO[03]
					AddRec()
				else //item existe
					if reclock();end
					if VM_CAMPO[03]#PR_DESCR
						?'002 - Alterado Descricao '+str(VM_CAMPO[02],L_P)+'='+VM_CAMPO[03]
					end
					if VM_CAMPO[10]#PR_VLVEN
						?'003 - Alterado Vlr Venda '+str(VM_CAMPO[02],L_P)+'='+VM_CAMPO[03]
						?'      de:'+str(PR_VLVEN,8,2)+' para '+str(VM_CAMPO[6],8,2)
					end
				end
				fieldput(01,VM_CAMPO[01]) //grupo
				fieldput(02,VM_CAMPO[02]) //cod
				fieldput(03,VM_CAMPO[03]) //descr
				fieldput(04,VM_CAMPO[04]) //compl
				fieldput(05,VM_CAMPO[05]) //unid
				fieldput(10,VM_CAMPO[06]) //vlr venda
				fieldput(13,VM_CAMPO[07]) //vlr comp
				dbrunlock()
			else
				alert('Arquivo nao reconhecido por esta importacao;'+LINHA)
				CONTINUA:=.F.
				loop
			end
		end	
		pb_deslimp()
	else
		alert('Arquivo nao encontrado;'+ARQUIVO)
	end
	*----------------------------------------------------------
end
return NIL


*---------------------------------------------------------------------------*
 static function IMPORTAR3()
*---------------------------------------------------------------------------*
local ARQUIVO:='..\RECEBE\EXPO_PRD.TXT'
local LINHA  
local NRLINHAS:=0
if pb_sn('Importacao Tipo 3 (Completo);Importar arquivo de Produtos;Arquivo->'+ARQUIVO)
	pb_ligaimp(,'ErrosImp.txt')
	pb_msg('Importando... Ver arquivo de erros - "ErrosImp.Txt"')
	select PROD
	ordem CODIGO
	VM_CAMPO  :=array(fcount())
	if (HANDLE:=fopen(ARQUIVO))>0
		LINHA:=''
		CONTINUA:=.T.
		PRIMEIRO:=.T.
		WHILE CONTINUA.and.lerlinha(HANDLE,@LINHA)
			NRLINHAS++
			@24,70 SAY NRLINHAS
			if token(LINHA,'|',02) == 'PRODUTOS'
				VM_CAMPO[01]:=val(token(LINHA,'|',03))*10000		// 1-GRUPO
				VM_CAMPO[01]+=val(token(LINHA,'|',04))*if(val(token(LINHA,'|',04))<100,100,1)	// 1-SGrupo
				VM_CAMPO[02]:=val(token(LINHA,'|',05))				// 2-Cod-PRODUTO
				VM_CAMPO[03]:=    token(LINHA,'|',06)				// 3-Descricao
				VM_CAMPO[04]:=    token(LINHA,'|',07)				// 4-Complemento
				VM_CAMPO[05]:=    token(LINHA,'|',08)				// 5-Unidade
				VM_CAMPO[06]:=    token(LINHA,'|',09)				// 6-Local
				VM_CAMPO[07]:=val(token(LINHA,'|',10))/100		// 7-Est-Minimo
				VM_CAMPO[08]:=val(token(LINHA,'|',11))/100		// 8-Qtd Atual
				VM_CAMPO[09]:=val(token(LINHA,'|',12))/100		// 9-Vlr Estoque
				VM_CAMPO[10]:=val(token(LINHA,'|',13))/1000		//10-Vlr Venda
				VM_CAMPO[11]:=ctod(token(LINHA,'|',14))			//11-dt ult movto
				VM_CAMPO[12]:=ctod(token(LINHA,'|',15))			//12-dt ult compra
				VM_CAMPO[13]:=val(token(LINHA,'|',16))/10000		//13-Vlr Custo
				VM_CAMPO[14]:=val(token(LINHA,'|',17))/100		//14-Qtd Inicial-Per
				VM_CAMPO[15]:=val(token(LINHA,'|',18))/100		//15-Vlr Inicial-Per
				VM_CAMPO[16]:=		token(LINHA,'|',19)				//16-Class ABC-Pco Vend
				VM_CAMPO[17]:=		token(LINHA,'|',20)				//17-Class ABC-Vlr Estoq
				VM_CAMPO[18]:=val(token(LINHA,'|',21))				//18-Cod Tipo Estoq
				VM_CAMPO[19]:=val(token(LINHA,'|',22))/100		//19-Qtd reserv
				VM_CAMPO[20]:=val(token(LINHA,'|',23))/100		//20-%Lucro no item
				VM_CAMPO[21]:=val(token(LINHA,'|',24))/100		//21-%Comiss Vendedor
				VM_CAMPO[22]:=val(token(LINHA,'|',25))/100		//22-%IPI
				VM_CAMPO[23]:=    token(LINHA,'|',26)     		//23-Cod Trib Padr=SF
				VM_CAMPO[24]:=    token(LINHA,'|',27)     		//24-Tab Aliq-Cup Fisc
				VM_CAMPO[25]:=val(token(LINHA,'|',28))/100		//25-%ICMS
				VM_CAMPO[26]:=val(token(LINHA,'|',29))/100		//26-%Trib da Base
				VM_CAMPO[27]:=    token(LINHA,'|',30)				//27-Impres Etiqueta
				VM_CAMPO[28]:=val(token(LINHA,'|',31))/100		//28-Cod NBM
				VM_CAMPO[29]:=    token(LINHA,'|',32)				//29-Tipo Prod
				VM_CAMPO[30]:=    token(LINHA,'|',33)      		//30-Controla
				VM_CAMPO[31]:=val(token(LINHA,'|',34))/100		//31-% Acresc Prod venda
				VM_CAMPO[32]:=    token(LINHA,'|',35)      		//32-Codigo Trib Padrao - ENTRADA
				VM_CAMPO[33]:=    token(LINHA,'|',36)      		//33-Codigo Observacao Padrao Produto
				VM_CAMPO[34]:=    token(LINHA,'|',37)      		//34-Recolhido Pis/Cofins ?
				VM_CAMPO[35]:=val(token(LINHA,'|',38))      		//35-Peso em KG
				VM_CAMPO[37]:=    token(LINHA,'|',39)      		//36-NCM

//		??PR_CODCOE                        +'|'	// 40-Codigo PIS/Cofins (Entrada)
//		??PR_CODCOS                        +'|'	// 41-Codigo PIS/Cofins (Saida)
//		{'PR_CODCOE', 'C',  3,  0},;	//	35-Codigo Tabela-Pis/Cofins(Entrada)
//		{'PR_CODCOS', 'C',  3,  0},;	// 36-Codigo Tabela-Pis/Cofins(Saida)


				if PRIMEIRO
					?padc('Lista de mensagens de importacao',78)
					?replicate('-',78)
					PRIMEIRO=.F.
				end
				if !dbseek(str(VM_CAMPO[02],L_P))
					?'001 - Item Novo-'+str(VM_CAMPO[02],L_P)+'='+VM_CAMPO[03]
					AddRec()
				else //item existe
					if reclock();end
					if VM_CAMPO[03]#PR_DESCR
						?'002 - Alterado Descricao '+str(VM_CAMPO[02],L_P)+'='+VM_CAMPO[03]
					end
					if VM_CAMPO[10]#PR_VLVEN
						?'003 - Alterado Vlr Venda '+str(VM_CAMPO[02],L_P)+'='+VM_CAMPO[03]
						?'      de:'+str(PR_VLVEN,8,2)+' para '+str(VM_CAMPO[10],8,2)
					end
				end
				for X:=1 to fcount()
//						?'NRLINHA'
//						??str(NRLINHAS,4)
//						??' campo <'
//						??X
//						??'><'
//						??VM_CAMPO[X]
//						??'>'
					if !empty(VM_CAMPO[X]).and.VM_CAMPO[X]#fieldget(X)
						fieldput(X,VM_CAMPO[X])
					end
				next		
				dbrunlock()
			else
				alert('Arquivo nao reconhecido por esta importacao;'+LINHA)
				CONTINUA:=.F.
				loop
			end
		end	
		pb_deslimp()
	else
		alert('Arquivo nao encontrado;'+ARQUIVO)
	end
	*----------------------------------------------------------
end
return NIL

*----------------------------------------------------------
	static function LERLINHA(HANDARQ,LINHA)
*----------------------------------------------------------
local LER
local RT:=.T.
LINHA:=''
while RT
   LER:=' '
   TAM:=fread(HANDARQ,@LER,1)
// alert('LER:<'+LER+'>/'+LINHA+if(RT,'<SIM>','<NAO>')+str(TAM,3))
   RT:=(TAM==1)
   if RT
      if LER==chr(10)
         return RT
      end
      if LER#chr(13)
         LINHA+=LER
      end
   end
	@23,0 SAY LINHA
end
return RT
