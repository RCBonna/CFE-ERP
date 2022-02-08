//-----------------------------------------------------------------------------*
  static aVariav := {'',0,.T.,.T.,{},0,0,'C:\TEMP','\ANALISE.HTML','', 0, 0,''}
//....................1.2..3...4...5.6.7........8...............9..10.11.12.13
//-----------------------------------------------------------------------------*
#xtranslate cArq				=> aVariav\[  1 \]
#xtranslate nX					=> aVariav\[  2 \]
#xtranslate lCONT				=> aVariav\[  3 \]
#xtranslate lRT				=> aVariav\[  4 \]
#xtranslate aDados			=> aVariav\[  5 \]
#xtranslate CodCliQuebra	=> aVariav\[  6 \]
#xtranslate PerInicial		=> aVariav\[  7 \]
#xtranslate PerInicial		=> aVariav\[  7 \]
#xtranslate cDir				=> aVariav\[  8 \]
#xtranslate cArq				=> aVariav\[  9 \]
#xtranslate NomCliente		=> aVariav\[ 10 \]
#xtranslate nY					=> aVariav\[ 11 \]
#xtranslate nZ					=> aVariav\[ 12 \]
#xtranslate cHtml				=> aVariav\[ 13 \]

#include 'RCB.CH'
//-----------------------------------------------------------------------------*
	function LeiteP19()	//	Dados da Análise de Leite
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO'		,;
				'R->LEIPARAM'		,;		// Parametros do Leite
				'R->PROD'			,;
				'R->CLIENTE'		,;
				'R->LEITRANS'		,;
				'R->LEIMOTIV'		,;
				'R->LEIVEIC'		,;
				'R->LEIROTA'		,;		// criado arquivo no LEITEP00.PRG
				'R->LEICPROD'		,;		// Criado arquivo no LEITEP00.PRG
				'C->LEILABOR'		;		// Dados do Laboratorio
			})
	return NIL
end
select LEILABOR
ORDEM CLIDT

CodCliIni	:=0
CodCliFim	:=0
PerInicial	:='000000'
nX				:=17

pb_box(nX++,20,,,,'LEITE-Selecao Impressao Analise Produtores Leite')
@nX++,22 say 'Cliente Inicial:'	get CodCliIni pict mI5		valid fn_codigo(@CodCliIni,  {'CLIENTE', {||CLIENTE-> (dbseek(str(CodCliIni,5)))},{||CFEP3100T(.T.)},{2,1,8,7}});
											when pb_msg('Informar Cliente Inicial')
@nX++,22 say 'Cliente Final..:'	get CodCliFim pict mI5		valid fn_codigo(@CodCliFim,  {'CLIENTE', {||CLIENTE-> (dbseek(str(CodCliFim,5)))},{||CFEP3100T(.T.)},{2,1,8,7}});
											when pb_msg('Informar Cliente Inicial')
@nX++,22 say 'Periodo Inicial:'	get PerInicial pict mPER;
											when pb_msg('Periodo em 0000/00 lista todas as informacaoes de Analise')
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	cHtml:='<html	>'+'<meta charset="UTF-8">'
	cHtml+='<head>'
	cHtml+='<title>Analise Leite Produtor</title>'
	cHtml+='</head>'
	cHtml+='<body>'
	dbseek(Str(CodCliIni,5),.T.)
	nZ:=1
	while !eof().and.LEILABOR->LA_CDCLI<=CodCliFim
		aDados		:={}
		CodCliQuebra:=LEILABOR->LA_CDCLI
		CLIENTE->(DbSeek(str(CodCliQuebra,5)))
		NomCliente	:=CLIENTE->CL_RAZAO
		lRT			:=.F.
//		alert('Produtor:'+str(LEILABOR->LA_CDCLI,5))
		while !eof().and.LEILABOR->LA_CDCLI==CodCliQuebra
			if substr(DtoS(LEILABOR->LA_DTCOLE),1,6)>=PerInicial
				aadd(aDados,{	pb_zer(CodCliQuebra,5)+'-'+NomCliente,; // 01-Codigo+Nome
									LA_DTCOLE,;	//	02-PERIODO
									LA_GORDUR,;	//	03-PERC_GORDURA
									LA_PROTEI,;	//	04-PROTEINA
									LA_ESD,;		// 05-EDS-Extrato Seco Desengurdurado
									LA_NRCCS,;	// 06-CCS_1000
									LA_NRCBT})	// 07-CBT_1000
				lRT:=.T.
			end
			skip
		end
		if lRT
			ImpressHtml19()
			nZ++
		end
	end
end
dbcloseall()

if nZ > 0
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
		CallDll( pApi, 0, "open", cDir+cArq, NIL, "", 1 )
		DllUnload( nDll )
end
return NIL

*-----------------------------------------------------------------------------*
	static function ImpressHtml19()
*-----------------------------------------------------------------------------*
//------Tabela 1 Cabeçalho-----------------------------------------
cHtml+='<table width=800px; border=0>'
cHtml+='<tr align="center">'
cHtml+='<td align="center"; width="30%"> <img src="logo.png"/></td>'
cHtml+='<td width="70%"><font face ="verdana" size="4"><b>'+VM_EMPR+'</b><br>'
cHtml+=trim(PARAMETRO->PA_ENDER)+','+trim(PARAMETRO->PA_ENDNRO)+'<br>'
cHtml+=transform(PARAMETRO->PA_CEP,mCEP)+' - '+trim(PARAMETRO->PA_CIDAD)+' - '+PARAMETRO->PA_UF
cHtml+='</td>'
cHtml+='</tr>'
cHtml+='<tr height=70>'
cHtml+='<td colspan="2"; align="center"><font face ="verdana" size="4"><b>Laudo de Analise de Leite dos Produtores</b></td>'
cHtml+='<tr>'
cHtml+='<td colspan="2"; align="left"><font face ="verdana" size="4">'+trim(aDados[01][01])+'</td>'
cHtml+='</tr>'
cHtml+='</table>'
//------Tabela 2 Nro Fatura-----------------------------------------
cHtml+='<table width=800px border=1>'
cHtml+='<colgroup align=center>'
cHtml+='<colgroup align=center>'
cHtml+='<tr align="center"; bgcolor=gray>'
cHtml+='<th width="16%"><font face ="verdana" size="2">Mês</th>'
cHtml+='<th width="16%"><font face ="verdana" size="2">%Gordura</th>'
cHtml+='<th width="16%"><font face ="verdana" size="2">%Proteina</th>'
cHtml+='<th width="16%"><font face ="verdana" size="2">%ESD</th>'
cHtml+='<th width="16%"><font face ="verdana" size="2">CCS*1000</th>'
cHtml+='<th width="16%"><font face ="verdana" size="2">CBT/CPP*1000</th>'
cHtml+='</tr>'
//------Tabela 3 Dados de Análise---------------------------------------
for nX:=1 to len(aDados)
	cHtml+='<tr align="center">'
	cHtml+='<td width="16%"><font face ="verdana" size="2">'+ DtoC(     aDados[nX][02])+'</td>'
	cHtml+='<td width="16%"><font face ="verdana" size="2">'+ Transform(aDados[nX][03],mI52)+'</td>'
	cHtml+='<td width="16%"><font face ="verdana" size="2">'+ Transform(aDados[nX][04],mI52)+'</td>'
	cHtml+='<td width="16%"><font face ="verdana" size="2">'+ Transform(aDados[nX][05],mI52)+'</td>'
	cHtml+='<td width="16%"><font face ="verdana" size="2">'+ Transform(aDados[nX][06],mI6 )+'</td>'
	cHtml+='<td width="16%"><font face ="verdana" size="2">'+ Transform(aDados[nX][07],mI6 )+'</td>'
	cHtml+='</tr>'
next
for nX:=len(aDados) to 9
	cHtml+='<tr align="center">'
	cHtml+='<td width="16%"><font face ="verdana" size="2">'+'&nbsp-'+'</td>'
	cHtml+='<td width="16%"><font face ="verdana" size="2">'+'&nbsp-'+'</td>'
	cHtml+='<td width="16%"><font face ="verdana" size="2">'+'&nbsp-'+'</td>'
	cHtml+='<td width="16%"><font face ="verdana" size="2">'+'&nbsp-'+'</td>'
	cHtml+='<td width="16%"><font face ="verdana" size="2">'+'&nbsp-'+'</td>'
	cHtml+='<td width="16%"><font face ="verdana" size="2">'+'&nbsp-'+'</td>'
	cHtml+='</tr>'
next

//------Tabela 4 Finalizar---------------------------------------
cHtml+='<tr align="left">'
cHtml+='<td colspan="6"; width="100%><font face ="verdana" size="2"><b>OBS: </b>'+;
			trim(LEIPARAM->LP_MSGLEIT)+'</td>'
cHtml+='</tr>'
cHtml+='</table>'

//------Tabela 5 Quebra de Página--------------------------------
if (nZ % 2) > 0
	cHtml+='<hr align="left" width=800px>'
	cHtml+='<br><br>'
else
	cHtml+='<p style="page-break-before: always"></p>'
end

return NIL

//---------------------------------EOF-----------------------------------------*
