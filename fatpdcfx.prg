*---------------------------------------------------------------------------------------*
 static aVariav := {0,'',{},0,'',.T.,0,0,'CF ',{},5,'N',{},.F.,''}
*...................1..2..3.4..5..6..7,8...9...10,11,12,13.14..15
*---------------------------------------------------------------------------------------*
#xtranslate nX       => aVariav\[  1 \]
#xtranslate cArq     => aVariav\[  2 \]
#xtranslate aDig     => aVariav\[  3 \]
#xtranslate nOpc     => aVariav\[  4 \]
#xtranslate cTF      => aVariav\[  5 \]
#xtranslate lContNF  => aVariav\[  6 \]
#xtranslate FreteTot => aVariav\[  7 \]
#xtranslate PesoTot  => aVariav\[  8 \]
#xtranslate SerieCF  => aVariav\[  9 \]
#xtranslate aEnvolv  => aVariav\[ 10 \]
#xtranslate nLinICF  => aVariav\[ 11 \]
#xtranslate cTeste   => aVariav\[ 12 \]
#xtranslate aFAT     => aVariav\[ 13 \]
#xtranslate lRT      => aVariav\[ 14 \]
#xtranslate cTXTPARC => aVariav\[ 15 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
 function FATPDCF1()	// INCLUI
*-----------------------------------------------------------------------------*
	dbgobottom()
	dbskip()
	FATPDCFT(.T.)
return NIL

*-----------------------------------------------------------------------------*
 function FATPDCF2() // ALTERAR
*-----------------------------------------------------------------------------*
	if str(CFC_NUMCF,6)==str(0,6)
		if reclock()
			FATPDCFT(.F.)
		end
	else
		alert('Conhecimento de Frete já impresso;nao é passivel de modificacoes')
	end
return NIL

*-----------------------------------------------------------------------------*
 function FATPDCF3() // Pesquisar
*-----------------------------------------------------------------------------*
if pb_sn('Nao disponivel;Mudar tela para mostrar;todos os Conhecimentos de Frete?')
	ORDEM CODIGO
	go top
end
return NIL

*-----------------------------------------------------------------------------*
 function FATPDCF4() // Exclusão
*-----------------------------------------------------------------------------*
if RecLock().and.pb_sn('Excluir Conhecimento Frete - Chave:'+pb_zer(FieldGet(1),6)+';de '+dtoc(FieldGet(5)))
	VM_CHAVE:=FieldGet(1)
	select CFEACFD
	DbSeek(str(VM_CHAVE,6)+str(1,2),.T.)
	while CFD_CHAVE==VM_CHAVE
		if RecLock()
			delete
			skip
		end
	end
	select CFEACFC
end
delete
return NIL

*-----------------------------------------------------------------------------*
 function FATPDCF5() // Imprimir Conhecimento Frete
*-----------------------------------------------------------------------------*
if CFC_NUMCF>0
	alert('NOTA DE CONHECIMENTO JA IMPRESSA;NAO E POSSIVEL FAZER NOVA IMPRESSAO')
	return NIL
end
if !RecLock() // Travar registro
	return NIL
end

pb_box(14,01,22,78,,'Selecao de impressao')
CLIENTE->(dbseek(str(CFEACFC->CFC_CODDE,5)))
VM_CHAVE:=CFC_CHAVE
VM_NUMCF:=fn_psnf(SerieCF)
@15,02 say 'Chave..............: '+pb_zer(VM_CHAVE,6)
@16,02 say 'Data Emissao.......: '+dtoc(CFC_DTEMI)
@17,02 say 'Destinatário.......: '+pb_zer(CFC_CODDE,5)+'-'+CLIENTE->CL_RAZAO
@18,02 say 'Número Conhecimento: '+pb_zer(VM_NUMCF,6)+space(5)+'Serie.: '+CFC_SERCF
@20,02 say 'Nro Linhas Iniciais:' get nLinICF            valid nLinICF>=0             when pb_msg('Nro de linha a ser pulada no inicio da impressao-será fixo depois que formulario OK')
read
if pb_sn('Dados corretos para impressao?')
	if pb_ligaimp(I6LPP+I36LPP+I15CPP)
		NATOP->(dbseek(str(CFEACFC->CFC_CODOP,7)))
		CLIENTE->(dbseek(str(CFEACFC->CFC_CODRE,5)))
		aEnvolv:={'','',''}
		aEnvolv[1]:={	padr(trim(CLIENTE->CL_RAZAO)+' ('+pb_zer(CFC_CODRE,5)+')',73),;
							padr(padr(trim(CLIENTE->CL_ENDER)+' '+trim(CLIENTE->CL_ENDNRO),50)+transform(CLIENTE->CL_CEP,mCEP),73),;
							padr(padr(CLIENTE->CL_CIDAD,56)+CLIENTE->CL_UF,73),;	
							padr(padr(transform(CLIENTE->CL_CGC,if(CLIENTE->CL_TIPOFJ='F',mCPF,mCGC)),43)+CLIENTE->CL_INSCR,73)}
		CLIENTE->(dbseek(str(CFEACFC->CFC_CODDE,5)))
		aEnvolv[2]:={	trim(CLIENTE->CL_RAZAO)+' ('+pb_zer(CFC_CODDE,5)+')',;
							padr(trim(CLIENTE->CL_ENDER)+' '+trim(CLIENTE->CL_ENDNRO),51)+transform(CLIENTE->CL_CEP,mCEP),;
							padr(CLIENTE->CL_CIDAD,51)+CLIENTE->CL_UF,;
							padr(transform(CLIENTE->CL_CGC,if(CLIENTE->CL_TIPOFJ='F',mCPF,mCGC)),41)+trim(CLIENTE->CL_INSCR)}
		if str(CFC_CODRC,5)>str(0,5)
		CLIENTE->(dbseek(str(CFEACFC->CFC_CODRC,5)))
		aEnvolv[3]:={	trim(CLIENTE->CL_RAZAO)+'('+pb_zer(CFC_CODRC,5)+')',;
							padr(trim(CLIENTE->CL_ENDER)+' '+trim(CLIENTE->CL_ENDNRO),50)+transform(CLIENTE->CL_CEP,mCEP),;
							padr(CLIENTE->CL_CIDAD,60)+CLIENTE->CL_UF,;
							padr(transform(CLIENTE->CL_CGC,if(CLIENTE->CL_TIPOFJ='F',mCPF,mCGC)),40)+CLIENTE->CL_INSCR}
		end
		*----------------------inicio da impressão	
		for nX:=1 to nLinICF
			?
		next
		//VM_TPFRE1$'12'  when pb_msg('Tipo de Frete <1>-Pago  <2>-A pagar')
		if CFC_TPFRE1=='1'
			?space(135)+'X'
		else
			?
		end
		? padr(space(73)+dtoc(CFC_DTEMI)+space(2)+transform(CFC_CODOP,mNAT)+'-'+NATOP->NO_DESCR,135)+if(CFC_TPFRE1=='2','X','')
		?
		*---- remetente + destinatário
		?space(01)+aEnvolv[1,1]+aEnvolv[2,1]
		?space(04)+aEnvolv[1,2]+aEnvolv[2,2]
		?space(04)+aEnvolv[1,3]+aEnvolv[2,3]
		?space(04)+aEnvolv[1,4]+aEnvolv[2,4]
		? space(09)+if(CFC_TPFRE1=='1','X',' ')+space(31)+if(CFC_TPFRE1=='2','X',' ')
		??space(47)+if(CFC_TPFRE2=='1','X',' ')+space(35)+if(CFC_TPFRE2=='2','X',' ')
		
		?space(13)+CFC_COLETA
		?space(13)+CFC_ENTREG
		?space(13)+CFC_VEICPL+space(12)+CFC_VEICLO+' ('+CFC_VEICUF+')'
		?space(13)+CFC_VEICMO
		?
		*---Impressao das NFs do conhecimento de frete
		LoadNF(.F.) // É necessario .F.para simular entrada carregamento das NF (como se fosse alterar)
		PesoTot:=0
		for nX:=1 to (len(aDig))
			if aDig[nX,1]>0
				? padr(transform(aDig[nX,3],mNAT),17)+space(12) // natureza operacao
				??padc(pb_zer(aDig[nX,1],6)+'-'+aDig[nX,2],30)+space(15) // nr NF + Serie
				??transform(aDig[nX,4],mD132)+space(11)	// Valor
				??transform(aDig[nX,5],mI6)+space(08)		// Peso Real
				??transform(aDig[nX,6],mI6)+space(02)		// Quantidade
				??trim(aDig[nX,7])								// Especie
				PesoTot+=aDig[nX,5]
			else
				?
			end
		next
		?
		FreteTot:=CFC_TARIFA+CFC_VLFRET+CFC_VLSEC+CFC_VLDESP+CFC_VLITR+CFC_VLOUTR+CFC_VLSEG+CFC_VLPED
		? padr(CFC_VEICPL+' '+CFC_VEICMA+' '+trim(CFC_VEICLO)+' ('+CFC_VEICUF+')',45)
		??transform(CFC_TARIFA,mI102)+space(15)
		??transform(PesoTot,   mI6)  +space(12)
		??transform(CFC_VLFRET,mI102)+space(10)
		??transform(CFC_VLSEC, mI102)+space(05)
		??transform(CFC_VLDESP,mI102)
		?
		?space(10)
		??transform(CFC_VLITR, mI102)+space(10)
		??transform(CFC_VLOUTR,mI102)+space(12)
		??transform(FreteTot-(CFC_VLSEG+CFC_VLPED),mI102)+space(13)
		??transform(CFC_VLSEG,mI102)+space(06)
		??transform(CFC_VLPED,mI102)+space(22)
		??transform(FreteTot,mI102)
		?
		? substr(CFC_OBS,01,40)
		? substr(CFC_OBS,41,40)+space(83)
		??transform(CFC_VLBASE,mI102)
		?
		?
		? space(113)+transform(CFC_VLALIQ,mI52)+space(05)+transform(CFC_VLICMS,mI102)
		eject
		pb_deslimp(I6LPP+I66LPP+C15CPP)
 	end
	fieldput(2,VM_NUMCF)
	SALVABANCO
	CLIENTE->(dbseek(str(CFEACFC->CFC_CODDE,5)))

	if CFEACFC->CFC_PARCE>0 // Pagamento a Prazo (Pendentes)
		if CFC_TPFRE1=='1' // Frete Pago = Entrada = Fornecedores
			select DPFOR		
		else // Freta A Pagar = Saída = Clientes
			select DPCLI
		end
		alert('codigo do cliente deve ser revisto para duplicatas a pagar+receber')
		for nX:=1 to CFEACFC->CFC_PARCE
			aFAT:={	VM_NUMCF*100+nX,;
						ctod(substr(CFEACFC->CFC_DESPAR,nX*22-21,10)),;
						val( substr(CFEACFC->CFC_DESPAR,nX*22-11,11))/100}
			while !AddRec(30,{;
									aFAT[1],;					//	1-Duplicata
									if(empty(CLIENTE->CL_MATRIZ),CFEACFC->CFC_CODDE,CLIENTE->CL_MATRIZ),;//  2-Cod.Cliente
									CFEACFC->CFC_DTEMI,;		//	3 Dt.Emissao
									aFAT[2],;					//	4-Dt.Vencimento
									ctod(''),;					//	5-Dt.Pagto.
									aFAT[3],;					//	6-Vlr.Duplicata
									0,;							//	7-Vlr.Pago
									CFEACFC->CFC_BCO,;		//	8 Codigo do Caixa
									1,;							//	9-Moeda(0=CRZ,1=URV....)
									VM_NUMCF,;					//	10 Numero da NF
									CFEACFC->CFC_SERCF,;		// 11 Serie da NF
									CLIENTE->CL_RAZAO})		// 12-Parte do Nome
			end
		next
	else // Pagamento a Vista
		if CFC_TPFRE1=='1' // Frete Pago = Entrada = Fornecedores
			select HISFOR
		else // Freta A Pagar = Saída = Clientes
			select HISCLI
		end
		while !AddRec(30,{;
								if(empty(CLIENTE->CL_MATRIZ),CFEACFC->CFC_CODDE,CLIENTE->CL_MATRIZ),;//  1 Cod.Cliente
								VM_NUMCF*100,;				//	2 Duplicata
								CFEACFC->CFC_DTEMI,;		//	3 Dt.Emissao
								CFEACFC->CFC_DTEMI,;		//	4 Dt.Vencimento
								CFEACFC->CFC_DTEMI,;		//	5 Dt.Pagamento
								FreteTot,;					//	6 Vlr.Duplicata
								FreteTot,;					//	7 Vlr.Pago
								0,;							//	8 Vlr.JUROS
								0,;							//	9 Vlr.DESCONTOS
								pb_divzero(FreteTot,PARAMETRO->PA_VALOR),;// 10 Vlr.Pago em (MOEDA)
								VM_NUMCF,;					// 11 Numero da NF
								CFEACFC->CFC_SERCF,;		// 12 Serie da NF
								CFEACFC->CFC_CODCG,;		// 13 Codigo Caixa
								.F.,;							// 14 Caixa Integrado ?
								.F.,;							// 15 Bancos Integrado ?
								0,;							// 16 Vlr Retido
								0,;							// 17 Vlr Bonificado
								CFEACFC->CFC_BCO;			// 18 Codigo do Caixa
								})
		end
	end
	dbrunlock(recno())
	RESTAURABANCO
	go top
else
	fn_backnf(SerieCF,VM_NUMCF)
end
return NIL
*
*--------------------------------------------------EOF-----------------------------------------------
