static aVariav := {0,"","","","",0,"",0,0,"","", 0,{}}
//.................1..2..3..4..5.6..7.8.9.10.11,12,13
*-----------------------------------------------------------------------------*
#xtranslate nF    	=> aVariav\[  1 \]
#xtranslate cNome 	=> aVariav\[  2 \]
#xtranslate cFone 	=> aVariav\[  3 \]
#xtranslate cEstCiv 	=> aVariav\[  4 \]
#xtranslate cTP 		=> aVariav\[  5 \]
#xtranslate nCPFCNPJ	=> aVariav\[  6 \]
#xtranslate nImov		=> aVariav\[  7 \]
#xtranslate nDuplic	=> aVariav\[  8 \]
#xtranslate nCodCli	=> aVariav\[  9 \]
#xtranslate nDpl		=> aVariav\[ 10 \]
#xtranslate nParc		=> aVariav\[ 11 \]
#xtranslate nLin		=> aVariav\[ 12 \]
#xtranslate aMasc		=> aVariav\[ 13 \]

//-----------------------------------------------------------------------------
   function CFEP3100()	//	Cadastro de Clientes
//-----------------------------------------------------------------------------
#include 'RCB.CH'
local nX

pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->PARALINH',;
				'C->VENDEDOR',;
				'C->DPCLI',;
				'C->CTRNF',;
				'C->CLIENTE',;
				'C->MOVCLIX',;// Movimento cadastro de cliente para SPED
				'R->CTADET',;
				'C->CLIOBS'})
	return NIL
end
select('DPCLI');dbsetorder(5);DbGoTop() // ord COD CLIENTE
select('CLIENTE');dbsetorder(2) // Ord Alfabetica
set relation to str(CL_VENDED,3) into VENDEDOR
DbGoTop()

pb_dbedit1('CFEP310','IncluiAlteraProcurExcluiLista Baixar')  // tela
private VM_CAMPO:=array(fcount())
private VM_CABE :=array(fCount())
afields(VM_CAMPO)
VM_CABE[01]:='Codigo'
VM_CABE[02]:='Nome'
VM_CABE[03]:='Endereco'
VM_CABE[04]:='Bairro'
VM_CABE[05]:='C.E.P.'
VM_CABE[06]:='Cidade'
VM_CABE[07]:='UF'
VM_CABE[08]:='CPF/CGC'
VM_CABE[09]:='RG/InscEst'
VM_CABE[10]:='DtNascim'
VM_CABE[11]:='Fone'
VM_CABE[12]:='Fax'
VM_CABE[13]:='DtUltVenda'
VM_CABE[14]:='OBS'
VM_CABE[15]:='Vendedor'
VM_CABE[16]:='TpCadast'
VM_CABE[17]:='DtCadastro'
VM_CABE[18]:='CodAtivid'
VM_CABE[19]:='Remunerac(SM)'
VM_CABE[20]:='Filiacao'
VM_CABE[21]:='LocTrabalho'
VM_CABE[22]:='Cargo'
VM_CABE[23]:='Dt.Admiss'
VM_CABE[24]:='Est.Civil'
VM_CABE[25]:='Conjuge'
VM_CABE[26]:='Doc.Conj'
VM_CABE[27]:='LocTrabConj'
VM_CABE[28]:='DtTrabConj'
VM_CABE[29]:='DtNascConj'
VM_CABE[30]:='CargoConj'
VM_CABE[31]:='RendaConj'
VM_CABE[32]:='FiliacConj'
VM_CABE[33]:='Referencia'
VM_CABE[34]:='Bens'
VM_CABE[35]:='DtRegSPC'
VM_CABE[36]:='DtConsSPC'
VM_CABE[37]:='LocalNascimento'
VM_CABE[38]:='VlrRegSPC'
VM_CABE[39]:='LimiteCredito'
VM_CABE[40]:='NrCartSPC'
VM_CABE[41]:='TpPessoa'
VM_CABE[42]:='DtBaixaCad'
VM_CABE[43]:='CodForneced'
VM_CABE[44]:='DtUltComp'
VM_CABE[45]:='NomeContato'
VM_CABE[46]:='CdMatriz'
VM_CABE[47]:='Status'
VM_CABE[48]:='RotaLeite'

VM_CAMPO[15]:='pb_zer(CL_VENDED,3)+chr(45)+VENDEDOR->VE_NOME'

set key K_ALT_A to CORRIGEDTULTCOM()

set key K_ALT_B to Importar() // importar clientes e duplicatas 

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',,VM_CABE)
// dbcommit()
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim
function CFEP3101() // Rotina de Inclusão
*-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEP3100T(.T.)
end
return NIL
*-------------------------------------------------------------------* 

function CFEP3102() // Rotina de Alteração
*-------------------------------------------------------------------*
local VM_ORD:=1
if PARAMETRO->PA_CONTAB==USOMODULO
	VM_ORD:=alert('Alterar ..',{'Cadastro','Transferencia (Conta Contabil)'})
	if VM_ORD==2
		dbrunlock(recno())
		CFEP3100T1(.F.)
	end
end
if VM_ORD#2
	if RecLock()
		CFEP3100T(.F.)
	end
end
return NIL

*-------------------------------------------------------------------* 
function CFEP3103() // Rotina de Pesquisa
*-------------------------------------------------------------------* 
local VM_ORD:=indexord(),VM_CHAVE
aMasc:={mI5,mUUU,masc(38),mI5,mDT}
//........1....2.......3....4...5
nLin:=15
pb_box(nLin++,20,,,,'Ordem Pesquisa')			//
@nLin++,21 prompt padc('C¢digo',25)				// 1-
@nLin++,21 prompt padc('Alfabetica',25)		// 2-
@nLin++,21 prompt padc('CGC/CPF',25)			// 3-
@nLin++,21 prompt padc('Vendedores',25)		// 4-
@nLin++,21 prompt padc('Dt Nascimento',25)	// 5-

menu to VM_ORD
if VM_ORD>0
	VM_CHAVE:= if(VM_ORD==1,CL_CODCL,if(VM_ORD==2,CL_RAZAO,if(VM_ORD==3,CL_CGC,if(VM_ORD==4,CL_VENDED,CL_DTNAS))))
	@21,21 say 'Pesquisar.:' get VM_CHAVE picture aMasc[VM_ORD]
	read
	if VM_ORD<6
		dbsetorder(VM_ORD)
	else
		ORDEM DTNASC
	end
	VM_CHAVE:=if(VM_ORD==1,str(VM_CHAVE,5),if(VM_ORD==2,VM_CHAVE,if(VM_ORD==3,VM_CHAVE,if(VM_ORD==4,str(VM_CHAVE,3),DtoS(VM_CHAVE)))))
	dbseek(VM_CHAVE,.T.)
end
setcolor(VM_CORPAD)
return NIL

*-------------------------------------------------------------------* 
function CFEP3104() // Rotina de Exclusão
*-------------------------------------------------------------------* 
if reclock().and.pb_sn('Eliminar ( '+str(CL_CODCL,5)+'-'+trim(CL_RAZAO)+' ) ?')
	fn_elimi()
end
dbrunlock()
return NIL

*-------------------------------------------------------------------* 
function CFEP3106() // Rotina de Baixa
*-------------------------------------------------------------------* 
if CLIENTE->CL_DTBAIX#ctod('')
	if pb_sn(trim(CLIENTE->CL_RAZAO)+';Cliente INATIVO desde '+dtoc(CLIENTE->CL_DTBAIX)+';Reativar???')
		if reclock()
			replace CLIENTE->CL_DTBAIX with ctod('')
		end
	end
else
	if pb_sn(trim(CLIENTE->CL_RAZAO)+';Cliente ATIVO;Baixar ?')
		if reclock()
			replace CLIENTE->CL_DTBAIX with date()
		end
	end
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
 static function CORRIGEDTULTCOM()
*-----------------------------------------------------------------------------*
alert('*** Corrige ***;Data Ultima Compra Branco;Para 12 meses antes;Cliente Cadastrado ate 6 meses Dt Cadastro')
DbGoTop()
While !eof()
	pb_msg('Atualizado Cliente '+CL_RAZAO)
	if empty(CLIENTE->CL_DTUCOM) // Cliente com Data Ult Compra Branco
		if reclock()
			if CLIENTE->CL_DTCAD>AddMonth(Date(),-6) // Cad.Feito nos últimos 6 meses = Data Cadastro
				replace CLIENTE->CL_DTUCOM with CLIENTE->CL_DTCAD // Gravar Dt Cadastro
			else
				replace CLIENTE->CL_DTUCOM with AddMonth(Date(),-12) // Gravar Data 1 ano Antes
			end
		end
	end
	dbrunlock()
	dbskip()
END
KEYBOARD CHR(27)
return nil

*-----------------------------------------------------------------------------*
 function MovCliSped(aP1)
*-----------------------------------------------------------------------------*
SALVABANCO
select MOVCLIX
if !dbseek(str(aP1[1],5)+dtos(aP1[2])+str(aP1[3],2))
	AddRec(,aP1)
else
	if reclock()
		for nF:=4 to len(aP1)
			FieldPut(nF,aP1[nF])
		end
	end
end
RESTAURABANCO
return NIL

*------------------------------------------------Atualiza Dt Ultima Compra
function GraUltCom(pCodCli,pDtCompra)
*------------------------------------------------Atualiza Dt Ultima Compra
SALVABANCO
select CLIENTE
if dbseek(str(pCodCli,5))
	if CLIENTE->CL_DTUCOM<pDtCompra.and.reclock()
		replace CLIENTE->CL_DTUCOM with pDtCompra
		DbRUnlock() // libera o registro do Cliente
	end
else
	alert('Avisar Roberto;Gravacao de Dt Ult Mov Compra;Cliente nao encontrado!;Codigo:'+str(pCodCli,5))
end
RESTAURABANCO
return NIL

*------------------------------------------------Atualiza Dt Ultima Compra (alt+B)
function Importar()
*------------------------------------------------Atualiza Dt Ultima Compra
local nFileHandle,cFile:="C:\TEMP\CLIENTES.CSV"
local cLinha, nCont:=0, aDados:=array(53)
Txt:=""
SALVABANCO
select CLIENTE
if file(cFile)
	nFileHandle:= FOpen(cFile)
	// cLinha:=fRead
	// cTXT:=MemoRead(cFile)
	// MemoEdit(cTXT)
	// clear
	if pb_sn("Importando dados dos Clientes.;Limpar arquivo atual")
		if !Flock()
			Alert("Arquivos de uso Exclusivo;Ha um CFE sendo executado...;ROTINA CANCELADA")
			return NIL
		end
		dbgotop()
		nCont :=1
		while !eof()
			pb_msg("Eliminando dados dos Clientes "+Str(nCont,6))
			dbdelete()
			dbskip()
			nCont ++
		end
		// Limpar
		cLinha:=""
		nCont :=1
		while HB_FReadLine( nFileHandle, @cLinha ) == 0
			pb_msg("Importando Clientes do Arquivo. Linha:"+Str(nCont,6))
			if len(cLinha)>0.and.nCont>0
				cLinha:=StrTran(cLinha,";;","; ; ") // colocar espaço entre campos
				nX:=NumToken(cLinha,";")
				for nY:=1 to 53
					aDados[nY]:=alltrim(Token(cLinha,";",nY)) // Guardar Valores dos Campos
//					?str(nX,2)+'-'+str(nY,2)+'-'+aDados[nY]
				next
				if Val(aDados[01])=0
					Loop
				end
				cFone:=""
				if !Empty(aDados[18]).or.!Empty(aDados[19])
					cFone:=aDados[18]+" "+aDados[19]+"/"	// Fone + DD+Residencial
				end
				if !empty(aDados[22]).or.!empty(aDados[23])
					cFone+=aDados[22]+" "+aDados[23]	// Fone - DD+Celular
				end
				if !empty(aDados[20]).or.!empty(aDados[21])
					cFone+=aDados[20]+" "+aDados[21] // Fone - DD+Comercial
				end
				aDados[10]:=if(Empty(aDados[10]),"Correia Pinto",aDados[10]) // Cidade em Branco?
				aDados[10]:=if(Empty(aDados[04]),"88535000",     aDados[04]) // CEP em Branco?
				cEstCiv:=""
				aDados[44]:=Upper(aDados[44])
				if aDados[44]=="DIVORCIADO"
					cEstCiv:="D"
				elseif aDados[44]=="VIUVA"
					cEstCiv:="V"
				elseif aDados[44]=="SOLTEIRA".or.aDados[44]=="SOLTEIRO".or.aDados[44]=="SOLT."
					cEstCiv:="S"
				end
				if !empty(cEstCiv)	// tem estado Civil definido no Conjuge
					aDados[44]:="" // eliminar dados do campo conjuge quando for estado civil
				end
				cTP		:="F"
				nCPFCNPJ:="00000000000" // caso CNPJ e CPF Vazios
				if !Empty(CharOnly("0123456789",aDados[35])) // CPF não Vazio
					nCPFCNPJ:=CharOnly("0123456789",aDados[35])
				elseif !Empty(CharOnly("0123456789",aDados[30]))	// CNPJ não Vazio
					nCPFCNPJ:=CharOnly("0123456789",aDados[30])	
					cTP:="J"
				end
				nImov		:="S/N"
				aDados[07]	:=CharOnly("0123456789",aDados[07])
				if !Empty(aDados[07])	// Tem Números
					nImov:=aDados[07] // Só Pegar Números
				end
				
				if !Empty(CharOnly("0123456789",Upper(aDados[06]))) // Rua (tem números)
					if nImov=="S/N"
						nImov:=CharOnly("0123456789",Upper(aDados[06]))
					end
				end
				AddRec(,;
				{											Val(aDados[01])	,;	// 01-CodCli
					CharOnly(" ABCDEFGHIJKLMNOPQRSTUVWYZ",upper(aDados[03])),;	// 02-Nome
					CharOnly(" ABCDEFGHIJKLMNOPQRSTUVWYZ",upper(aDados[06])),;	// 03-Logradouro
					CharOnly(" ABCDEFGHIJKLMNOPQRSTUVWYZ",upper(aDados[09])),;	// 04-Bairro
					CharOnly("0123456789",						aDados[04])	,;	// 05-CEP
					CharOnly(" ABCDEFGHIJKLMNOPQRSTUVWYZ",upper(aDados[10])),;	// 06-Cidade
					CharOnly(" ABCDEFGHIJKLMNOPQRSTUVWYZ",upper(aDados[11])),;	// 07-UF
																	nCPFCNPJ,;	// 08-CPF/CNPJ
																aDados[36]	,;	// 09-RG/Insc Estad
														   CtoD(aDados[40])	,;	// 10-Dt Nasc
																cFone		,;	// 11-Fone
					CharOnly(" 0123456789",		aDados[25]+" "+aDados[26])	,;	// 12-Fax
														   CtoD(aDados[14])	,;	// 13-Dt Ult Compra
																aDados[15]	,;	// 14-Observação=Contato
																		0	,;	// 15-Cod Vendedor
																		0	,;	// 16-Tipo Cadastro(CCTB)
															CtoD(aDados[02]),;	// 17-Dt Cadastro
																		1	,;	// 18-Cod Atividade
											Ceiling(Val(aDados[53])/950,0)	,;	// 19-Remuneração (SM)
										Upper(aDados[37]+" / "+aDados[38])	,;	// 20-Filiacao (Pai/Mae)
																aDados[42]	,;	// 21-LocTrabalho
																aDados[39]	,;	// 22-Cargo
															CtoD(aDados[43]),;	// 23-Dt Admissão
																	cEstCiv	,;	// 24-Estado Civil
																aDados[44]	,;	// 25-Conjuge
																aDados[46]	,;	// 26-Doc.Conjuge
																		""	,;	// 27-LocTrabConj
																	CtoD(""),;	// 28-DtTrabConj
															CtoD(aDados[45]),;	// 29-DtNascConj
																		""	,;	// 30-CargoConj
																		 0	,;	// 31-RendaConj
																		""	,;	// 32-FiliacConj
																		""	,;	// 33-Referencia
																		""	,;	// 34-Bens	 
																	CtoD(""),;	// 35-DtRegSPC	 
																	CtoD(""),;	// 36-DtConsSPC
																		""	,;	// 37-LocalNascimento
																		0	,;	// 38-VlrRegSPC
																		100	,;	// 39-LimiteCredito
																		0	,;	// 40-NrCartSPC
																		cTP	,;	// 41-Tipo Pessoa (F/J)
																	CtoD(""),;	// 42-DtBaixaCad
																		0	,;	// 43-CodForneced
															CtoD(aDados[14]),;	// 44-DtUltComp
														   Upper(aDados[50]),;	// 45-NomeContato
																		0	,;	// 46-CdMatriz
																		""	,;	// 47-Status
																		0	,;	// 48-RotaLeite
														   Upper(aDados[31]),;	// 49-Nome Fantasia
																		""	,;	// 50-InscMunicipal
																		0	,;	// 51-CCTB
																		0	,;	// 52-Tp Empresa
																	4204558	,;	// 53-CodMunicipioIBGE
																		""	,;	// 54-CodSuframa
																	1058	,;	// 55-CodPaís
																	nImov	,;	// 56-Nur Imóvel (Casa)
														Upper(aDados[08])	,;	// 57-Complemento Endereco
														Lower(aDados[27])	,;	// 58-e-Mail
																		""	;	// 59-NF Prod Rural
				})
			end
			nCont++
//			if nCont>10
//				exit
//			end
		end
	end
	FClose(nFileHandle)
	Alert("Importacao de Clientes;"+Str(nCont,6)+" registos finalizado.")
else
	Alert("Arquivo "+cFile+";Nao Encontrado")
end
/*

	Duplicatas dos Clientes

*/
cFile:="C:\TEMP\DUPLICATAS.CSV"
TXT  :="Conversao de Nr do documento de Contas a Receber"+CRLF+"Registro / Nr Antigo    ->      Nr Novo"+CRLF
select CLIENTE
ORDEM CODIGO // Chave de acesso - Ordem
DbGoTop()

select DPCLI
if file(cFile)
	nFileHandle:= FOpen(cFile)

	if pb_sn("Importando dados das Duplicatas.;Limpar arquivo atual")
		if !Flock()
			Alert("Arquivos de uso Exclusivo;Ha um CFE sendo executado...;ROTINA CANCELADA")
			return NIL
		end
		dbgotop()
		nCont:=1
		while !eof()
			pb_msg("Eliminando dados das Duplicatas existentes "+Str(nCont,6))
			dbdelete()
			dbskip()
			nCont++
		end
		// Limpar
		cLinha:=""
		nCont :=1
		while HB_FReadLine( nFileHandle, @cLinha ) == 0
			pb_msg("Importando Contas a Receber do Arquivo. Linha:"+Str(nCont,6))
			if len(cLinha)>0.and.nCont>0
				cLinha:=StrTran(cLinha,";;","; ; ") // colocar espaço entre campos
				nX:=NumToken(cLinha,";")
				for nY:=1 to 17
					aDados[nY]:=alltrim(Token(cLinha,";",nY)) // Guardar Valores dos Campos
				next
//				if Val(aDados[01])=0
//					Loop
//				end
				nCodCli:=Val(aDados[06])
				if CLIENTE->(DbSeek(Str(nCodCli,5)))
					aDados[07]:=CLIENTE->CL_RAZAO
				else
					aDados[07]:=Str(nCodCli,5)+"-CLIENTE NAO ENCONTRADO"
				end
				
				nDuplic:=aDados[01]
				nDuplic:=StrTran(nDuplic,"0A","10")	// Mudar 0A ==> 10
				nDuplic:=StrTran(nDuplic,"0B","11")	// Mudar 0A ==> 11
				nDuplic:=StrTran(nDuplic,"0C","12")	// Mudar 0A ==> 12
				nDuplic:=StrTran(nDuplic,"0D","13")	// Mudar 0A ==> 13
				nDuplic:=StrTran(nDuplic,"/" ,"-" )	// Mudar / ==> -
				nDuplic:=StrTran(nDuplic,"." ,"-" )	// Mudar . ==> -
				nDuplic:=CharOnly("-0123456789",nDuplic)	// Só Números e "-" "."
				aDados[12]:=StrTran(aDados[12],"." ,"" )
				aDados[12]:=StrTran(aDados[12],"," ,"." )
				aDados[13]:=StrTran(aDados[13],"." ,"" )
				aDados[13]:=StrTran(aDados[13],"," ,"." )

				if !Empty(nDuplic)	// Tem nr ?
					nDpl :=""
					nParc:=""
					nY		:=NumAt("-",nDuplic) // quantos "-" tem na DUPL
//					?aDados[01]+" ==> "+nDuplic+"[Nr:"+str(nY,3)+"] "
					if nY>1 // se tem mais de 1 "-" só deixar o último
						nDuplic:=StrTran(nDuplic,"-","",1,nY-1) // retirando "-" a mais
					end
					nY  :=RAt   ("-",nDuplic) // onde está o "-" na DUPL
					if nY>0 // tem Separador DPL - Parcela
						nDpl :=SubStr(nDuplic,1,nY-1) // parte da DUPL
						nParc:=SubStr(nDuplic,nY+1)	// parte da Parcela
					else
						nDpl :=nDuplic
					end
//					??" |"+Str(nY,3)+"| {"+nDpl+"} (Parcela:"+nParc+")"
					
					nDpl:=Val(nDpl) // Transformar em Nr
					if nDpl>999999
						nDpl:=Right(AllTrim(Str(nDpl,12)),6)
					elseif nDpl==0
						nDpl:=AllTrim(Str(fn_psnf('IMP'),6))
					else
						nDpl:=AllTrim(Str(nDpl,6))
					end
//					?? " ==> "+nDpl
					// inkey(0)
					// exit
					
					if Len(nParc)==0	// Não tem digits DPL 
						nParc:="99"
					elseif Len(nParc) = 1 // Só 1 digits na Parcela
						nParc:="9"+nParc
					elseif Len(nParc) > 2 // Mais de 2 digits DPL 
						nParc:=Right(nParc,2)
					end
					nDuplic:=nDpl+"-"+nParc
				else
					nDuplic:=AllTrim(Str(fn_psnf('IMP'),6))+"-99"
				end
				
				TXT    +=Str(nCont,6)+" - "+PadR(aDados[01],12)+" -> "+PadL(nDuplic,12)+CRLF
				nDuplic:=StrTran(nDuplic,"-" ,"" )	// Mudar - ==> ""
				if Val( aDados[12]) - Val( aDados[13]) >= 0	// 06-Vlr.Duplicata MENOS Valor Pago MENOR que ZERO 
					AddRec(,;
					{											Val(nDuplic),;		// 01-Duplicata
																	nCodCli	,;		// 02-Cod.Cliente
														CtoD(aDados[03])	,;		// 03-Dt.Emissao
														CtoD(aDados[04])	,;		// 04-Dt.Vencimento
														CtoD(aDados[04])	,;		// 05-Dt.Pagto.
														Val( aDados[12])	,;		// 06-Vlr.Duplicata
														Val( aDados[13])	,;		// 07-Vlr.Pago
																			1	,;		// 08-Cod.Banco
																			1	,;		// 09-Moeda(0=CRZ,1=URV....
																		nCont	,;		// 10-Numero da NF
																		"IMP"	,;		// 11-Serie da NF
																aDados[07]	,;		// 12-Nome Cliente
																	CtoD("")	,;		// 13-Data Protesto
										aDados[01]+" / "+aDados[02]	,;		// 14-Ofico Protesto
																			0	,;		// 15-Juros Financiamento
																			"N",;		// 16-N->Normal P-PREVISAO X->PROTESTO
																			0	,;		// 17-Nr do Boleto
																			"R",;		// 18-<P>agar  <R>eceber <<<<NAO USADO>>>>
																			1	;		// 19-Tipo Cliente (Associado/Não Associado)
					})
				end
			end
			nCont++
//			if nCont>10
//				exit
//			end
		end
	end
	FClose(nFileHandle)
	Alert("Importacao de Contas a Receber;"+Str(nCont,6)+" Registros finalizado.")
	MemoWrit("C:\temp\_ImpDPL.txt",TXT)
else
	Alert("Arquivo "+cFile+";Nao Encontrado")
end

RESTAURABANCO
dbgotop()
keyboard chr(27)
RETURN NIL


//-----------------------------------EOF
