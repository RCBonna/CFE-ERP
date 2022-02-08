*-----------------------------------------------------------------------------*
 static aVariav1:= {'',0, 0, 0,'','DPL.HTML'}
 //.................1..2..3..4..5..6........7...8...9
*-----------------------------------------------------------------------------*
#xtranslate cHtml 	=> aVariav1\[  1 \]
#xtranslate nSomaVlr => aVariav1\[  2 \]
#xtranslate nX			=> aVariav1\[  3 \]
#xtranslate nY			=> aVariav1\[  4 \]
#xtranslate nExtenso	=> aVariav1\[  5 \]
#xtranslate cArq		=> aVariav1\[  6 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
	function ImpressHtml(aDATA,pSERIE,pNRNF,pNRVIAS)
*-----------------------------------------------------------------------------*
select('PEDCAB')
dbseek(dtos(aDATA[1])+str(pNRNF,6),.T.)
while !eof().and.PEDCAB->PC_DTEMI<=aDATA[2].and.if(empty(pNRNF),.T.,pNRNF==PEDCAB->PC_NRNF)
	if PEDCAB->PC_FLAG.and.pSERIE==PEDCAB->PC_SERIE
		CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
		@20,22 say 'Nr da Duplicata...: '+transform(PEDCAB->PC_NRDPL,masc(16))
		@21,22 say 'Cliente...........: '+transform(PEDCAB->PC_CODCL,masc(04))+'-'+left(CLIENTE->CL_RAZAO,20)
		DPLS:={}
		salvabd(SALVA)
		select('DPCLI')
		dbseek(str(PEDCAB->PC_NRNF,9)+PEDCAB->PC_SERIE,.T.)
		while !eof().and.PEDCAB->PC_NRNF==DPCLI->DR_NRNF.and.PEDCAB->PC_SERIE==DPCLI->DR_SERIE
			aadd(DPLS,{DPCLI->DR_DUPLI,DPCLI->DR_DTVEN,DPCLI->DR_VLRDP,DPCLI->DR_VLRPG})
			//.......................1...............2...............3...............4
			dbskip()
		end
		salvabd(RESTAURA)
		if len(DPLS)>0
			ImpressHtml1(	PEDCAB->PC_CODCL,;//............................1
								CLIENTE->CL_RAZAO,;//...........................2
								DPLS,;//........................................3
								PEDCAB->PC_DTEMI,;//............................4
								transform(CLIENTE->CL_CGC,if(CLIENTE->CL_TIPOFJ=='F',mCPF,mCGC)),;//........................5
								if(CLIENTE->CL_TIPOFJ=='F','Ced.Identidade:','Inscr.Estadual:')+trim(CLIENTE->CL_INSCR),;//.6
								trim(CLIENTE->CL_ENDER)+','+trim(CLIENTE->CL_ENDNRO),;//....................................7
								transform(CLIENTE->CL_CEP,mCEP)+' - '+trim(CLIENTE->CL_CIDAD)+' - '+CLIENTE->CL_UF)//.......8
								// Impr. Duplicata
			//..........................1.................2....3......4.........5
		else
			Alert('Nao foram encontradas Duplicatas pendentes para a;'+;
					'Nota Fiscal:'+str(PEDCAB->PC_NRNF,9))
		end
	end
	DbGoBottom()
	pb_brake()
end

return NIL

*-----------------------------------------------------------------------------*
	function ImpressHtml1(pCodCli,pNomeCli,aDupl,pDtEmi,pCNPJ,pID,pEnd,pCidad)
*-----------------------------------------------------------------------------*

nSomaVlr:=0
AEval(aDupl,{|DET|nSomaVlr+=DET[3]})

cHtml:='<html>'
cHtml+='<head>'
cHtml+='<title>Duplicata Mercantil-'+left(pb_zer(aDupl[1,1],9),7)+'</title>'
cHtml+='</head>'
cHtml+='<body>'
for nX:=1 to len(aDupl)
	nExtenso:=padr('('+pb_extenso(aDupl[nX,3])+') '+replicate('-x',250),150)
	for nY:=1 to 2
		//------tabela 1 cabeçalho-----------------------------------------
		cHtml+='<table width=800px; border=0>'
		cHtml+='<tr align="center">'
		cHtml+='<td align="center"; width="30%"> <img src="logo.png"/></td>'
		cHtml+='<td width="70%"><font face ="verdana" size="4"><b>'+VM_EMPR+'</b><br>'
		cHtml+=trim(PARAMETRO->PA_ENDER)+','+trim(PARAMETRO->PA_ENDNRO)+'<br>'
		cHtml+=transform(PARAMETRO->PA_CEP,mCEP)+' - '+trim(PARAMETRO->PA_CIDAD)+' - '+PARAMETRO->PA_UF
		cHtml+='</td>'
		cHtml+='</tr>'
		cHtml+='<tr>'
		cHtml+='<td colspan="2"; align="center"><font face ="verdana" size="4">DUPLICATA</td>'
		cHtml+='</tr>'
		cHtml+='</table>'

		//------Tabela 2 Nro Fatura-----------------------------------------
		cHtml+='<table width=800px; border=0>'
		cHtml+='<tr align="center">'
		cHtml+='<td width="33%"><font face ="verdana" size="2">Nro Fatura: '  +left(pb_zer(aDupl[nX,1],9),7)+'</td>'
		cHtml+='<td width="34%"><font face ="verdana" size="2">Data Emissão: '+dtoc(pDtEmi)+'</td>'
		cHtml+='<td width="33%"><font face ="verdana" size="2">Valor Fatura: '+transform(nSomaVlr,mD82)+'</td>'
		cHtml+='</tr>'
		cHtml+='</table>'
		cHtml+='<br>'

		//------Tabela 3 Nro Fatura-----------------------------------------
		cHtml+='<table width=800px; border=1>'
		cHtml+='<tr align="center">'
		cHtml+='<td width="33%"><font face ="verdana" size="2">Duplicata: '+transform(aDupl[nX,1],mDPLN)+'</td>'
		cHtml+='<td width="34%"><font face ="verdana" size="2">Dt Vencimento: '+ dtoc(aDupl[nX,2])+'</td>'
		cHtml+='<td width="33%"><font face ="verdana" size="2"><b>Valor: '+ transform(aDupl[nX,3],mD82)+'</b></td>'
		cHtml+='</tr>'
		cHtml+='</table>'

		//------Tabela 3 Informações do Sacado-----------------------------------------
		cHtml+='<table width=800px; border=0>'
		cHtml+='<tr align="left">'
		cHtml+='<td width="20%"><font face ="verdana" size="2">Nome Sacado:</td>'
		cHtml+='<td width="80%"><font face ="verdana" size="2">'+trim(pNomeCli)+'&nbsp('+pb_zer(pCodCli,5)+')</td>'
		cHtml+='</tr>'
		cHtml+='<tr align="left">'
		cHtml+='<td width="20%"><font face ="verdana" size="2">CNPJ/CPF:</td>'
		cHtml+='<td width="80%"><font face ="verdana" size="2">'+pCNPJ+'&nbsp;&nbsp;&nbsp'+pID+'</td>'
		cHtml+='</tr>'
		cHtml+='<tr align="left">'
		cHtml+='<td width="20%"><font face ="verdana" size="2">Endereço:</td>'
		cHtml+='<td width="80%"><font face ="verdana" size="2">'+pEnd+'</td>'
		cHtml+='</tr>'
		cHtml+='<tr align="left">'
		cHtml+='<td width="20%"><font face ="verdana" size="2">CEP/Cidade/UF:</td>'
		cHtml+='<td width="80%"><font face ="verdana" size="2">'+pCidad+'</td>'
		cHtml+='</tr>'
		cHtml+='</table>'
		//------Tabela 3 Nro Fatura-----------------------------------------
		cHtml+='<table width=800px border=1  bgcolor="#D0D0D0">'
		cHtml+='<tr>'
		cHtml+='<td align="center"><font face ="verdana" size="2">Valor por Extenso</td>'
		cHtml+='</tr>'
		cHtml+='<tr align="center">'
		cHtml+='<td align="center"><font face ="verdana" size="1">'+nExtenso+'</td>'
		cHtml+='</tr>'
		cHtml+='</table>'
		cHtml+='<br>'

		//------Tabela 4 Declarações-----------------------------------------
		cHtml+='<table width=800px border=0>'
		cHtml+='<tr align="center">'
		cHtml+='<td><font face ="verdana" size="2">Reconheco (mos) a exatidão desta Duplicata de Venda Mercantil na importância acima mencionada, que pagarei (emos) a <b>'+VM_EMPR+'</b> ou a sua ordem.</td>'
		cHtml+='</tr>'
		cHtml+='<tr align="center">'
		cHtml+='<td><font face ="verdana" size="2">Na falta de pagamento serão cobrados juros de'+transform(PARAMETRO->PA_PJUROS,masc(20))+'% ao mes, mais despesas bancárias.</td>'
		cHtml+='</tr>'
		cHtml+='</table>'
		cHtml+='<br><br><br>'

		//------Tabela 4 Assinaturas-----------------------------------------
		cHtml+='<table width=800px border=0>'
		cHtml+='<tr align="center">'
		cHtml+='<td width="40%"><font face ="verdana" size="2">____/____/____</td>'
		cHtml+='<td width="20%"><font face ="verdana" size="2"></td>'
		cHtml+='<td width="40%"><font face ="verdana" size="2">________________________________</td>'
		cHtml+='</tr>'
		cHtml+='<tr align="center">'
		cHtml+='<td width="30%"><font face ="verdana" size="2">Data do Aceite</td>'
		cHtml+='<td width="40%"><font face ="verdana" size="2"></td>'
		cHtml+='<td width="30%"><font face ="verdana" size="2">Nome do Sacado</td>'
		cHtml+='</tr>'
		cHtml+='</table>'
		if nY<2
			cHtml+='<hr align="left" width=800px>'
			cHtml+='<br><br>'
		else
			if nX<len(aDupl)
				cHtml+='<p style="page-break-before: always"></p>'
			end
		end
	next
next
cHtml+='</body>'
cHtml+='</html>'

cLogo:='logo.png'
cDir :='C:\TEMP\'
if !file(cDir+cLogo)
	if file(cLogo)
		fileCopy(cLogo,cDir+cLogo)
	else
		alert('Nao encontrado arquivo de "logo.png" no diretorio de dados')
	end
end

DeleteFile(cDir+cArq)
MemoWrit(cDir+cArq,cHtml)

	nDll := DllLoad( "Shell32.dll" )
	pApi := GetProcAddress( nDll, "ShellExecute" )
//	CallDll( pApi, 0, "open", cDir+cArq, NIL, "", 1 )
	CallDll( pApi, 0, "print", cDir+cArq, NIL, "", 1 )
	DllUnload( nDll )

return NIL
//---------------------------------------eof---------------------------------