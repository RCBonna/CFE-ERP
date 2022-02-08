*-----------------------------------------------------------------------------*
 static aVariav := {0, 0,  0, 0,'', 0, '','','','', 0,'','','',''}
*...................1..2...3..4..5..6...7..8..9,10,11,12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate nY         => aVariav\[  2 \]
#xtranslate nSoma      => aVariav\[  3 \]
#xtranslate cDigId     => aVariav\[  4 \]
#xtranslate nId        => aVariav\[  5 \]
#xtranslate nXit       => aVariav\[  6 \]
#xtranslate cFRCNPJCPF => aVariav\[  7 \]
#xtranslate cFRPESSOA  => aVariav\[  8 \]
#xtranslate cFRIE      => aVariav\[  9 \]
#xtranslate cArqGer    => aVariav\[ 10 \]
#xtranslate nConta     => aVariav\[ 11 \]
#xtranslate nNFEZ      => aVariav\[ 12 \]
#xtranslate cArqGerT   => aVariav\[ 13 \]
#xtranslate cKeyNFE    => aVariav\[ 14 \]
#xtranslate cLeitura   => aVariav\[ 15 \]

*-------------------------------------------------------------------
	function FISPNFEG(pNFe,pSist) //....pag 133
*-------------------------------------------------------------------
#include 'RCB.CH'
nNFEZ  :=strtran(pNFe[1,07],' ','0')
SetKeyNFE()
*-------------------------BUSCAR DNFE-SE NÃO FOR DEFINIDO USAR PADRÃO "\CFEWEB\NFE"
cArqGer:='\CFEWEB'
DirMake(cArqGer)
cArqGer+='\NFE'
cArqGer+=RtVarAmb('CFE','DNFE:') //.......Muda o Diretório dependendo da variável DNFE
DirMake(cArqGer)
cArqGer+='\'+Right(nNFEZ,7)+pSist+ '.tmp' // Criar inicialmente como temporário

if pNFe[1,15]=='2'
	alert('AMBIENTE HOMOLOGACAO SOMENTE PARA TESES;Gerando NF='+cArqGer)
end

pNFe[4,05]:=pNFe[4,05]-1 //....................Internamente é 1=Emit e 2=Dest... Para NF-e é 0 ou 1
if pNFe[1,37]==SONUMEROS(trim(pNFe[4,08])) //..CNPJ Destinatário = CNPJ Transportador
	pNFe[4,05]:=1 //............................Por conta do Destinatário
end
if pNFe[4,05]<0 //.............................Não pode ser Negativo
	pNFe[4,05]:=1
end
if pNFe[4,05]==2 //............................Sem Transporte
	pNFe[4,05]:=9
end

if pb_ligaimp(,cArqGer)
	nID       :=pNFe[1,01]+;//..............................01-Cod Estado
					SONUMEROS(Substr(pNFe[1,08],3,5))+;//.......02-AAMM
					pNFe[1,14]+;//..............................03-CNPJ DO EMINTENTE
					pNFe[1,05]+;//..............................04-Modelo = 55
					'00'+pNFe[1,06]+;//.........................05-Serie
					nNFEZ+;//...................................06-Nr NF-e (9 Bytes=NR.NF[9])
					pNFe[1,13]+;//..............................07-Tipo Emissão (1 Bytes) 
					pNFe[1,02]//................................08-Nr Interno (E=NF   S=Pedido) (8 Bytes)
	cDigId    :=CalcDg(nID) // Digito verificador
	nID       +=cDigId		// Acrescenta na Chave
	cKeyNFE   :=nID //.........Guardar número da nfe eletrônica

	cFRCNPJCPF:=SONUMEROS(trim(pNFe[4,08]))
	cFRPESSOA :=if(len(cFRCNPJCPF)>12,'J','F')
	cFRIE     :=alltrim(pNFe[4,09]) // IE TRANSPORTADOR
	if cFRPESSOA=='J'
		if cFRIE#'ISENTO'
			cFRIE:=SONUMEROS(pNFe[4,09])
		end
	else //....................pessoa fisica deve ser ISENTO
		cFRIE:='ISENTO'
	end
//	??'<?xml version="1.0" encoding="utf-8"?>'
	??'<NFe xmlns="http://www.portalfiscal.inf.br/nfe">'
		??'<infNFe versao="2.00" Id="NFe'+nID+'">'
			??'<ide>'
				??XMLTag('<cUF>',			pNFe[1,01])
				??XMLTag('<cNF>',			pNFe[1,02]) // número interno de acesso = pedido + digito
				??XMLTag('<natOp>',		pNFe[1,03])
				??XMLTag('<indPag>',		pNFe[1,04])
				??XMLTag('<mod>',			pNFe[1,05]) // modelo = 55
			   ??XMLTag('<serie>',		pNFe[1,06])
				??XMLTag('<nNF>',			alltrim(pNFe[1,07]))
			   ??XMLTag('<dEmi>',   	pNFe[1,08])
				??XMLTag('<dSaiEnt>',	pNFe[1,09])
				??XMLTag('<hSaiEnt>',	Time())		// Não gravado no CFE/SAG

				//<dhEmi>   2014-06-10T10:45:44-03:00</dhEmi>
				//<dhSaiEnt>2014-06-10T00:00:00-03:00</dhSaiEnt>
				//				??XMLTag('<dhEmi>',  	pNFe[1,08])	// Data+Hora+TZ Emissão AAAA-MM-DDTHH:MM:SS-03:00
				//				??XMLTag('<dhSaiEnt>',  pNFe[1,09])	// Data+Hora+TZ Saída ou Entrada

				??XMLTag('<tpNF>',		pNFe[1,10])	// tipo 0=Entrada 1=Saida
				??XMLTag('<cMunFG>',		pNFe[1,11])
																// tem um bloco de NF referenciada - 
																// quando usar NF de devolução ou NF de produtor
				if pNFe[1,16]=='4' // É uma Nota Fiscal de Devolução
					??'<NFref>'
						??XMLTag('<refNFe>',pNFe[1,56]) // Nota Fiscal de Devolução
					??'</NFref>'
				end
				??XMLTag('<tpImp>',		pNFe[1,12])	// tipo de impressão DANFE 1-Retrado 2-Paisagem
				??XMLTag('<tpEmis>',		pNFe[1,13])
				??XMLTag('<cDV>',			cDigId)
				??XMLTag('<tpAmb>',		pNFe[1,15])	// Tipo de ambiente 1-Produção/ 2-Homologação
				??XMLTag('<finNFe>',		pNFe[1,16])	// Finalidade da NFe =  <1-Normal>  <2-Complementar>  <3–Ajuste> <4-Devolução>
				??XMLTag('<procEmi>',	pNFe[1,17])	// Processo de Emissão <0=Aplicativo do Emitente> <1=Avulsa pelo Fisco> <2=Avulsa Fisco c/Certf.Dig> <3-Pelo Contrib com progr Fisco>
				??XMLTag('<verProc>','CFE '+ProgVersao())
			??'</ide>'

			??'<emit>'
				??	XMLTag(if(pNFe[1,19]=='J','<CNPJ>','<CPF>'),pNFe[1,20]) // depende se pessoa F/J -- CNPG ou CPF (pode ser NF entrada)
				??	XMLTag('<xNome>',pNFe[1,21])
				if !empty(pNFe[1,22])
					??	XMLTag('<xFant>',pNFe[1,22])
				end
				?? '<enderEmit>'
					??	XMLTag('<xLgr>',   pNFe[1,23])
					??	XMLTag('<nro>',    pNFe[1,24])
					if !empty(pNFe[1,25])
						??	XMLTag('<xCpl>',   pNFe[1,25])
					end
					??	XMLTag('<xBairro>',pNFe[1,26])
					??	XMLTag('<cMun>',   pNFe[1,27])
					??	XMLTag('<xMun>',   pNFe[1,28])
					??	XMLTag('<UF>',     pNFe[1,29])
					??	XMLTag('<CEP>',    pNFe[1,30])
					??	XMLTag('<cPais>',  pNFe[1,31])
					??	XMLTag('<xPais>',  pNFe[1,32])
					??	XMLTag('<fone>',   chkFone(pNFe[1,33]))
				?? '</enderEmit>'
				?? XMLTag('<IE>',        if(pNFe[1,19]=='J',pNFe[1,34],'ISENTO')) // se pessoa física = ''
				if !empty(pNFe[1,54])
					XMLTag('<IM>',pNFe[1,54])
				end
				if !empty(pNFe[1,55])
					XMLTag('<CNAE>',pNFe[1,55])
				end
				?? XMLTag('<CRT>',       '3') // <1–Simples Nacional> <2–Simples Nacional – excesso de sublimite de receita bruta <3 – Regime Normal. (v2.0)>
			??'</emit>'

			??'<dest>'
				??	XMLTag(if(pNFe[1,36]=='J','<CNPJ>','<CPF>'),pNFe[1,37]) // depende se pessoa F/J -- CNPG ou CPF
				??	XMLTag('<xNome>',pNFe[1,38])
				?? '<enderDest>'
					??	XMLTag('<xLgr>',   pNFe[1,39])
					??	XMLTag('<nro>',    pNFe[1,40])
					if !empty(pNFe[1,41])
						??	XMLTag('<xCpl>',   pNFe[1,41])
					end
					??	XMLTag('<xBairro>',pNFe[1,42])
					??	XMLTag('<cMun>',   pNFe[1,43])
					??	XMLTag('<xMun>',   pNFe[1,44])
					??	XMLTag('<UF>',     pNFe[1,45])
					??	XMLTag('<CEP>',    pNFe[1,46])
					??	XMLTag('<cPais>',  pNFe[1,47])
					??	XMLTag('<xPais>',  pNFe[1,48])
					if val(pNFe[1,49])>0
						??	XMLTag('<fone>',   chkFone(pNFe[1,49]))
					end
				?? '</enderDest>'
				?? XMLTag('<IE>',        if(pNFe[1,36]=='J',pNFe[1,50],'ISENTO')) // se pessoa física = ''
//				if !empty(pNFe[1,51])
//					?? XMLTag('<ISUF>',      pNFe[1,51]) // Codigo Inscricao Suframa
//				end
//				?? XMLTag('<email>',     if(pNFe[1,52]) // e-mail 
			??'</dest>'

			for nXit:=1 to len(pNFe[2]) // Até número de itens da NF
				??'<det nItem='+'"'+alltrim(str(nXIt,2))+'">'
					if empty(pNFe[2,nXit,12])
						pNFe[2,nXit,12]:=pNFe[2,nXit,08] // tornar a unid venda = unid tributação
					end
					??'<prod>'
						??	XMLTag('<cProd>',  pNFe[2,nXit,01])
						??	XMLTag('<cEAN>',   pNFe[2,nXit,02])
						??	XMLTag('<xProd>',  pNFe[2,nXit,03])
						if !empty(pNFe[2,nXit,04])
							??	XMLTag('<NCM>', pNFe[2,nXit,04])
						end
						??	XMLTag('<CFOP>',   pNFe[2,nXit,07])
						?? XMLTag('<uCom>',   pNFe[2,nXit,08])
						?? XMLTag('<qCom>',   pNFe[2,nXit,09])
						?? XMLTag('<vUnCom>', pNFe[2,nXit,10])
						?? XMLTag('<vProd>',  pNFe[2,nXit,11])
						?? '<cEANTrib />'
						?? XMLTag('<uTrib>',  pNFe[2,nXit,12])
						?? XMLTag('<qTrib>',  pNFe[2,nXit,13])
						?? XMLTag('<vUnTrib>',pNFe[2,nXit,14])
						if pNFe[2,nXit,20]<>'0.00'
							?? XMLTag('<vDesc>',  pNFe[2,nXit,20])
						end
						?? XMLTag('<indTot>'	,'1')	// <0=Valor do item (vProd) não compõe o valor total da NF-e> <1=Valor do item (vProd) compõe o valor total da NF-e
					??'</prod>'
					??'<imposto>'
						??'<ICMS>'
							??'<ICMS'+if(pNFe[2,nXit,16,1]$'40 41 50','40',pNFe[2,nXit,16,1])+'>' // 00,10...(40)
								??XMLTag('<orig>',pNFe[2,nXit,15])
								??XMLTag('<CST>', pNFe[2,nXit,16,1])
								if pNFe[2,nXit,16,1]=='00'
									??XMLTag('<modBC>',pNFe[2,nXit,16,2])
									??XMLTag('<vBC>',  pNFe[2,nXit,16,3])
									??XMLTag('<pICMS>',pNFe[2,nXit,16,4])
									??XMLTag('<vICMS>',pNFe[2,nXit,16,5])
								elseif pNFe[2,nXit,16,1]=='10' // colocado os valores base abaixo -> mas faltam outras TAGS --> LACERDÓPOLIS não usa
									??XMLTag('<modBC>',pNFe[2,nXit,16,2])
									??XMLTag('<vBC>',  pNFe[2,nXit,16,3])
									??XMLTag('<pICMS>',pNFe[2,nXit,16,4])
									??XMLTag('<vICMS>',pNFe[2,nXit,16,5])
								elseif pNFe[2,nXit,16,1]=='20'
									??XMLTag('<modBC>', pNFe[2,nXit,16,2])
									??XMLTag('<pRedBC>',pNFe[2,nXit,16,6])
									??XMLTag('<vBC>',   pNFe[2,nXit,16,3])
									??XMLTag('<pICMS>', pNFe[2,nXit,16,4])
									??XMLTag('<vICMS>', pNFe[2,nXit,16,5])
								elseif pNFe[2,nXit,16,1]=='30' // colocado os valores base abaixo -> mas faltam outras TAGS --> LACERDÓPOLIS não usa
									??XMLTag('<modBC>', pNFe[2,nXit,16,2])
								elseif pNFe[2,nXit,16,1]=='40'.or.pNFe[2,nXit,16,1]=='41'.or.pNFe[2,nXit,16,1]=='42'
									// não colocar nada já foi colocado os valores padrões acima
								elseif pNFe[2,nXit,16,1]=='51'
									??XMLTag('<modBC>', pNFe[2,nXit,16,2])
									??XMLTag('<pRedBC>',pNFe[2,nXit,16,6])
									??XMLTag('<vBC>',   pNFe[2,nXit,16,3])
									??XMLTag('<pICMS>', pNFe[2,nXit,16,4])
									??XMLTag('<vICMS>', pNFe[2,nXit,16,5])
								elseif pNFe[2,nXit,16,1]=='60' // ICMS cobrado anteriormente por substituição (Lacerdópolis não usa)
									??XMLTag('<vBCSTRet>',  pNFe[2,nXit,16,3])
									??XMLTag('<vICMSSTRet>',pNFe[2,nXit,16,5])
								elseif pNFe[2,nXit,16,1]=='70' // ICMS cobrado anteriormente por substituição (Lacerdópolis não usa)
									??XMLTag('<modBC>', pNFe[2,nXit,16,2])
									??XMLTag('<pRedBC>',pNFe[2,nXit,16,6])
									??XMLTag('<vBC>',   pNFe[2,nXit,16,3])
									??XMLTag('<pICMS>', pNFe[2,nXit,16,4])
									??XMLTag('<vICMS>', pNFe[2,nXit,16,5])
								elseif pNFe[2,nXit,16,1]=='90' // ICMS cobrado anteriormente por substituição (Lacerdópolis não usa)
									??XMLTag('<modBC>', pNFe[2,nXit,16,2])
									??XMLTag('<pRedBC>',pNFe[2,nXit,16,6])
									??XMLTag('<vBC>',   pNFe[2,nXit,16,3])
									??XMLTag('<pICMS>', pNFe[2,nXit,16,4])
									??XMLTag('<vICMS>', pNFe[2,nXit,16,5])
								end
							??'</ICMS'+if(pNFe[2,nXit,16,1]$'40 41 50','40',pNFe[2,nXit,16,1])+'>' // 00,10...(40)
						??'</ICMS>'
//						??'<IPI>'
//						??'</IPI>'
						??'<PIS>' // pagina 118 manual de integração
						if pNFe[2,nXit,18,1]$'01.02'
							??'<PISAliq>'
								??XMLTag('<CST>', 		pNFe[2,nXit,18,1])
								??XMLTag('<vBC>', 		pNFe[2,nXit,18,2])
								??XMLTag('<pPIS>',		pNFe[2,nXit,18,3])
								??XMLTag('<vPIS>',		pNFe[2,nXit,18,4])
							??'</PISAliq>'
						elseif pNFe[2,nXit,18,1]=='03'
							??'<PISQtde>'
								??XMLTag('<CST>', 		pNFe[2,nXit,18,1])
								??XMLTag('<qBCProd>', 	pNFe[2,nXit,09])
								??XMLTag('<vAliqProd>',	pNFe[2,nXit,18,3])
								??XMLTag('<vPIS>',		pNFe[2,nXit,18,4])
							??'</PISQtde>'
						elseif pNFe[2,nXit,18,1]$'04.06.07.08.09'
							??'<PISNT>'
								??XMLTag('<CST>', 		pNFe[2,nXit,18,1])
							??'</PISNT>'
						elseif pNFe[2,nXit,18,1]$'49.50.51.52.53.54.55.56.60.61.62.63.64.65.66.67.70.71.72.73.74.75.98.99'
							??'<PISOutr>'
								??XMLTag('<CST>', 		pNFe[2,nXit,18,1])
								??XMLTag('<vBC>', 		pNFe[2,nXit,18,2])
								??XMLTag('<pPIS>',		pNFe[2,nXit,18,3])
								??XMLTag('<vPIS>',		pNFe[2,nXit,18,4])
							??'</PISOutr>'
						end
						??'</PIS>'
						??'<COFINS>'
						if pNFe[2,nXit,19,1]$'01.02'
							??'<COFINSAliq>'
								??XMLTag('<CST>', 		pNFe[2,nXit,19,1])
								??XMLTag('<vBC>', 		pNFe[2,nXit,19,2])
								??XMLTag('<pCOFINS>',	pNFe[2,nXit,19,3])
								??XMLTag('<vCOFINS>',	pNFe[2,nXit,19,4])
							??'</COFINSAliq>'
						elseif pNFe[2,nXit,19,1]=='03'
							??'<COFINSQtde>'
								??XMLTag('<CST>', 		pNFe[2,nXit,19,1])
								??XMLTag('<qBCProd>', 	pNFe[2,nXit,09])
								??XMLTag('<vAliqProd>',	pNFe[2,nXit,19,3])
								??XMLTag('<vCOFINS>',	pNFe[2,nXit,19,4])
							??'</COFINSQtde>'
						elseif pNFe[2,nXit,19,1]$'04.06.07.08.09'
							??'<COFINSNT>'
								??XMLTag('<CST>', 		pNFe[2,nXit,19,1])							
							??'</COFINSNT>'
						elseif pNFe[2,nXit,19,1]$'49.50.51.52.53.54.55.56.60.61.62.63.64.65.66.67.70.71.72.73.74.75.98.99'
							??'<COFINSOutr>'
								??XMLTag('<CST>', 		pNFe[2,nXit,19,1])
								??XMLTag('<vBC>', 		pNFe[2,nXit,19,2])
								??XMLTag('<pCOFINS>',	pNFe[2,nXit,19,3])
								??XMLTag('<vCOFINS>',	pNFe[2,nXit,19,4])
							??'</COFINSOutr>'
						end
						??'</COFINS>'
					??'</imposto>'
				??'</det>'
			next
			??'<total>'
				??'<ICMSTot>' // MANUAL PAG 123
					??XMLTag('<vBC>',    pNFe[5,01])
					??XMLTag('<vICMS>',  pNFe[5,02])
					??XMLTag('<vBCST>',  pNFe[5,03])
					??XMLTag('<vST>',    pNFe[5,04])
					??XMLTag('<vProd>',  pNFe[5,05])
					??XMLTag('<vFrete>', pNFe[5,10])
					??XMLTag('<vSeg>',   pNFe[5,11])
					??XMLTag('<vDesc>',  pNFe[5,12])
					??XMLTag('<vII>',    pNFe[5,09])
					??XMLTag('<vIPI>',   pNFe[5,06])
					??XMLTag('<vPIS>',   pNFe[5,07])
					??XMLTag('<vCOFINS>',pNFe[5,08])
					??XMLTag('<vOutro>', pNFe[5,13])
					??XMLTag('<vNF>',    pNFe[5,14])
				??'</ICMSTot>'
			??'</total>'
			??'<transp>'
				??XMLTag('<modFrete>', str(pNFe[4,05],1)) // 0-    1-    9-Sem Frete
				if pNFe[4,05]<9
					??'<transporta>'
						if !empty(cFRCNPJCPF)
							??XMLTag(if(cFRPESSOA=='J','<CNPJ>','<CPF>'),cFRCNPJCPF) // Depende Tipo Pessoa F/J -- CNPG ou CPF
						end
						??XMLTag('<xNome>', trim(pNFe[4,01]))
						??XMLTag('<IE>',    cFRIE)
						??XMLTag('<xEnder>',trim(pNFe[4,02]))
						??XMLTag('<xMun>',  trim(pNFe[4,03]))
						??XMLTag('<UF>',    trim(pNFe[4,04]))
						??'</transporta>'
					??'<veicTransp>'
						if empty(pNFe[4,06])
							pNFe[4,06]:='AAA3578'
							pNFe[4,07]:='SC'
						end
						??XMLTag('<placa>', trim(pNFe[4,06]))
						??XMLTag('<UF>',    trim(pNFe[4,07]))
					??'</veicTransp>'
				end
				??'<vol>'
					if pNFe[4,10]<1
						pNFe[4,10]:=1
					end
					??XMLTag('<qVol>', alltrim(str(pNFe[4,10],15,0)))
					if empty(pNFe[4,11])
						pNFe[4,11]:='CAIXA'
					end
					??XMLTag('<esp>',  alltrim(pNFe[4,11]))
					if empty(pNFe[4,12])
						pNFe[4,12]:='DIVERSAS'
					end
					??XMLTag('<marca>',alltrim(pNFe[4,12]))
//				??XMLTag('<nVol>', alltrim(pNFe[4,13]))
					??XMLTag('<pesoL>',alltrim(str(pNFe[4,14],15,3)))
					??XMLTag('<pesoB>',alltrim(str(pNFe[4,13],15,3)))
				??'</vol>'
			??'</transp>'
			if len(pNFe[3])>1 // Parcelamento
				??'<cobr>'
					??'<fat>'
						??XMLTag('<nFat>', pNFe[3,1,2])
						??XMLTag('<vOrig>',pNFe[3,1,3])
						if pNFe[3,1,4]<>'0.00'
							??XMLTag('<vDesc>',pNFe[3,1,4])
						end
						??XMLTag('<vLiq>', pNFe[3,1,5])						
					??'</fat>'
					for nX:=2 to len(pNFe[3])
						??'<dup>'
						??XMLTag('<nDup>', pNFe[3,nX,1])
						??XMLTag('<dVenc>',pNFe[3,nX,2])
						??XMLTag('<vDup>', pNFe[3,nX,3])
						??'</dup>'
					next
				??'</cobr>'
			end
			??'<infAdic>'
				if empty(pNFe[1,52])
					pNFe[1,52]:='NF-e da Coolacer'
				end
				??XMLTag('<infAdFisco>',left('XML Disponivel em no site https://www.cofrenfe.com.br  - '+pNFe[1,52]+'-'+pNFe[1,53],2000))
//				if len(pNFe[1])>52.and.!empty(pNFe[1,53])
//					??XMLTag('<infCpl>',		pNFe[1,53])
//				end
				??'<obsCont xCampo="Cod.Emitente">'
					??XMLTag('<xTexto>',pNFe[1,35])
				??'</obsCont>'
			??'</infAdic>'
		??'</infNFe>'
	??'</NFe>'
	pb_deslimp(,,.F.) // Não mostrar arquivo no final
//	cArqGer+='\'+Right(nNFEZ,7)+pSist+'.tmp'
	cArqGerT:=strtran(cArqGer,'.tmp','.xml')
//	alert('renomear;'+cArqGerT+';'+cArqGer)
	if fRename(cArqGer,cArqGerT) == -1
		alert('Erro no renomeacao do arquivo gerado;De TMP para XML;Deve ser feito manualmente em:'+cArqGer+';Fazer manualmente...')
	end
end
return NIL

**---------------------------------------------------------------------------
function CalcDg(pNumeros)
**---------------------------------------------------------------------------
nY   :=2
nSoma:=0
for nX:=len(pNumeros) to 1 step -1
	nSoma+=val(substr(pNumeros,nX,1))*nY
	nY++
	if nY>9
		nY:=2
	end
next
return(str(if(nSoma%11<2,0,11-nSoma%11),1))

**---------------------------------------------------------------------------
static function XMLTag(pTag,pDado)
**---------------------------------------------------------------------------
return(pTag+carcEsp(pDado)+left(pTag,1)+'/'+substr(pTag,2))

*-------------------------------------------------------------------
 static function carcEsp(pDado)
*-------------------------------------------------------------------
	pDado:=strtran(pDado,chr(167),'.')	// º=primeiro
	pDado:=strtran(pDado,chr(166),'.')	// ª=primeira
//	pDado:=strtran(pDado,chr(037),'perc.')	// %
	pDado:=strtran(pDado,chr(044),'.')// '
	pDado:=strtran(pDado,chr(034),'.')// "
//	pDado:=strtran(pDado,chr(036),'.')// $
	pDado:=strtran(pDado,chr(038),'E')	// &
	pDado:=strtran(pDado,chr(060),'(')	// <
	pDado:=strtran(pDado,chr(062),')')	// >
	pDado:=strtran(pDado,chr(063),'.')	// ?
	pDado:=strtran(pDado,chr(128),'C')	// Ç
	pDado:=strtran(pDado,chr(135),'c')	// ç
	pDado:=strtran(pDado,chr(130),'e')	// é
	pDado:=strtran(pDado,chr(160),'a')	// a
	pDado:=strtran(pDado,chr(161),'i')	// í
	pDado:=strtran(pDado,chr(198),'a')	// ã
	pDado:=strtran(pDado,chr(199),'A')	// Ã
	pDado:=strtran(pDado,chr(000), '')	// NUL -> não deveria existir
	
	for nY:=1 to len(pDado)
		if asc(substr(pDado,nY,1))>122
			pDado:=strtran(pDado,substr(pDado,nY,1),'.')	// #
		end
	next
 return pDado

*-------------------------------------------------------------------
static function chkFone(pDado)
return alltrim(str(val(pDado),20))

*-------------------------------------------------------------------
function GetKeyNFE()
return(cKeyNFE)
 
*-------------------------------------------------------------------
function SetKeyNFE()
 cKeyNFE:=padr('0',44,'0')
 return NIL
*--------------------------------------------------EOF-------------

