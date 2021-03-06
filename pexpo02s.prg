*-------------------------------------------------------------------------------------------*
static aVariav:= { 0,0,1,2002,'','',0,'','', 0,{},.F.,0, 0,'','','',{},{},0, '',0,  0,''}
 //................1.2.3....4..5..6.7..8..9.10,11.12.13.14.15,16,17,18,19,20,21,22 23.24
*-------------------------------------------------------------------------------------------*
#xtranslate nX        => aVariav\[  1 \]
#xtranslate nY        => aVariav\[  2 \]
#xtranslate nMES      => aVariav\[  3 \]
#xtranslate nANO      => aVariav\[  4 \]
#xtranslate cArqE     => aVariav\[  5 \]
#xtranslate cArqS     => aVariav\[  6 \]
#xtranslate nNrReg    => aVariav\[  7 \]
#xtranslate dInic     => aVariav\[  8 \]
#xtranslate dFinal    => aVariav\[  9 \]
#xtranslate nVlrCtb   => aVariav\[ 10 \]
#xtranslate vIcms     => aVariav\[ 11 \]
#xtranslate lFlag     => aVariav\[ 12 \]
#xtranslate nModFrete => aVariav\[ 13 \]
#xtranslate VlFrete   => aVariav\[ 14 \]
#xtranslate cNFEKey   => aVariav\[ 15 \]
#xtranslate cModDNF 	 => aVariav\[ 16 \]
#xtranslate cNFProp 	 => aVariav\[ 17 \]
#xtranslate aNFSai 	 => aVariav\[ 18 \]
#xtranslate aFAT 		 => aVariav\[ 19 \]
#xtranslate nContReg	 => aVariav\[ 20 \]
#xtranslate cSerie	 => aVariav\[ 21 \]
#xtranslate nVlrSVC	 => aVariav\[ 22 \]
#xtranslate nCodlNF   => aVariav\[ 23 \]
#xtranslate cNomeCli	 => aVariav\[ 24 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
 function ProSaidSAG(dPeriodo)
*-----------------------------------------------------------------------------*

private pModXNF:='' // s? para parametro em RtModelo
nContReg:=0
select CLIENTE
ORDEM CODIGO

select NFC
ORDEM DATA
DbGoTop()
dbseek(dtos(dPeriodo[1]),.T.)
while !eof().and.NFC->NF_DTEMI<=dPeriodo[2]
	if NFC->NF_TIPO=='S' // Somente Saidas
		pb_msg('SAG-NF Saidas:'+dtoc(NFC->NF_DTEMI)+'-'+NFC->NF_TIPO+'-'+NFC->NF_SERIE+'-'+str(NFC->NF_NRNF,6))
		NATOP->(dbseek(str(NFC->NF_CODOP,7)))
		CLIENTE->(dbseek(str(NFC->NF_EMIT,5)))
		cNomeCli	:=CLIENTE->CL_RAZAO
		cCodInt  :=if(CLIENTE->CL_ATIVID==1, NATOP->NO_CODINA,NATOP->NO_CODIN)
		oNF		:=RtSAG() //.........................Busca dados da NF e seus detalhes
		nVlrSVC  :=0
//		if NATOP->NO_TIPO == '0' //...........Servi?os
//			SomarISS(str(PEDCAB->PC_PEDID,6))
//		end
		cModDNF	:=RtModelo('S',NFC->NF_SERIE,@pModXNF) // Tabela D e pMod=Modelo tabela interna
		nVlrCtb  :=oNF[10]	//.......................................Valor Cont?bil

		cNFProp:='S' // impressa na empresa (pr?pria?)
		cSerie :=if(NFC->NF_SERIE=='NFE','1',NFC->NF_SERIE)
		*-----------------------------------------------------------------------------------------------NRO NFE
		cNFEKey:=NFC->NF_NFEKEY
		if empty(cNFEKey)
			if pModXNF=='55' // ? nota fiscal NF-e
				if cNFProp$'SN' // NF-e Pr?prias
					cNFEKey:='42'
					cNFEKey+=pb_zer(year(NFC->NF_DTEMI)-2000,2)+;
								pb_zer(month(NFC->NF_DTEMI),2)//...............................AAMM
					cNFEKey+=pb_zer(val(SONUMEROS(PARAMETRO->PA_CGC)),14)//.................CNPJ
					cNFEKey+='55'//.........................................................Modelo NFE=55
					cNFEKey+='001'//........................................................Serie
					cNFEKey+=pb_zer(NFC->NF_NRNF,9)//.......................................Nr Documento
					cNFEKey+=pb_zer(NFC->NF_NRNF,8)//.......................................Controle parte 1
					cNFEKey+=str(pb_chkdgt(pb_zer(NFC->NF_NRNF,8),3),1)//...................Controle parte 2
					cNFEKey+=CalcDg(cNFEKey)//..............................................Novo Digito Verificador
				end
			end
		end
		nCodlNF:=substr(cNFEKey,26,09) // novo n?mero documento
		nModFrete:=max(oNF[15],1) //..................................Tipo de frete  <1>CIF   <2>FOB   <3>Outros
		if nModFrete == 3 .or. nModFrete == 9 .or. PEDCAB->PC_CODCL == 34929 // se for sem frete (3) colocar ZERO para PH
			nModFrete:=0	//.......................Cliente CONAB
		end

		GravaTXT(20,;//........................................1.Cod.Registro
					pb_zer(day(oNF[08])					,02)+;	//..2.Dia Movimento
					padr(      oNF[31]					,05)+;	//..3.Especie Docto
					padr(      cSerie           		,05)+;	//..4.Serie/Sub-Serie
					pb_zer(    oNF[04]					,06)+;	//..5.Nr.NF
					pb_zer(0									,06)+;	//..6.N?mero Sequ?ncia
					padr(CLIENTE->CL_UF					,02)+;	//..7.Sigla UF Destinatario
					left( pb_zer(NFC->NF_CODOP,7)		,04)+;	//..8.Os 4 Primeiros digitos da NATUREZA 
					padr(cCodInt							,04)+;	//..9.Codigo Integracao
					padr(PARAMETRO->PA_CIDAD			,25)+;	//.10.Cidade Origem
					padr(''									,24)+;	//.11.Obs para livros fiscais
					padr(cModDNF							,01)+;	//.12.Modelo NF - Tabela A
					str(nModFrete							,01)+;	//.13.Modalidade Frete 0=n?o ? frete ???? => str(TR_TIPO,1)
					'0'											 +;	//.14.Sa?da p/Empresa Exportadora = TABELA B
					if(NFC->NF_FLCAN,'1','0')				 +;	//.15.CANCELADA ?
					'00'											 +;	//.16.Dois digitos da NATUREZA do meio S? SC
					'0'											 +;	//.17.Lancamentos desmembrados de um mesmo documento ??
					if(pModXNF$'5557','S','N')				 +;	//.18-? documento Eletronico?
	 				cNFEKey										 +;	//.19-Chave Eletr?nica
					SONUMEROS(dtoc(oNF[08]))				 +;	//.20-Data Documento
					padr(NFC->NF_OBS1,76)					 +;	//.21-Complemento OBS NF <saida>
					space(20)									 +;	//.22-Eliminar documentocos (cancelamentos)
					if(	NFC->NF_FATUR>0,'2','1'		)	 +;	//.23-1=Vista   2=Prazo   3=Sem pagamento
					pb_zer(nCodlNF,09)						 +;	//.24-Novo N?mero do Documento
					'')
				//	
		GravaTXT(21,;//..................................1.Registro
					pb_zer(nVlrCtb*100			,12)+;//.....2.vlr Contabil (menos desconto geral)
					pb_zer(0,                    9)+;//.....3.vlr FRETE --> ?????????????????
					pb_zer(0,                    9)+;//.....4.vlr Seguro--> ?????????????????
					pb_zer(0,                    9)+;//.....5.vlr Desp.Acess--> ?????????????????
					pb_zer(0,						  9)+;//.....6.vlr DESC GERAL ---> PC_DESC*100
					pb_zer(0,                    9)+;//.....7.vlr Base IRPF/1
					pb_zer(0,                    4)+;//.....8.Aliq     IRPF/1
					pb_zer(0,                    9)+;//.....9.vlr Base IRPF/2
					pb_zer(0,                    4)+;//....10.Aliq     IRPF/2
					pb_zer(0,                    9)+;//....11.vlr Base IRPF/3
					pb_zer(0,                    4)+;//....12.Aliq     IRPF/3
					pb_zer(0,                    9)+;//....13.vlr Base IRPF/4
					pb_zer(0,                    4)+;//....14.Aliq     IRPF/4
					pb_zer(0,                    9)+;//....15.vlr Base IRPF/5
					pb_zer(0,                    4)+;//....16.Aliq     IRPF/5
					pb_zer(0,                    9)+;//....17.vlr deducoes simples-UF
					pb_zer(0,                    9)+;//....18.vlr desmemb contabil 1
					pb_zer(0,                    9)+;//....19.vlr desmemb contabil 2
					pb_zer(0,                    9)+;//....20.vlr desmemb contabil 3
					pb_zer(0,                    9)+;//....21.vlr desmemb contabil 4
					pb_zer(0,                    9)+;//....22.vlr desmemb contabil 5
					pb_zer(0,                    9)+;//....23.PIS/COFINS
					pb_zer(0,                    9)+;//....24.Aprop.Cred.Ativo Imob
					pb_zer(0,                    9)+;//....25.Ressarc Sub.Trib
					pb_zer(0,                    9)+;//....26.Transf Credito
					pb_zer(0,                    9)+;//....27.Compl.Vlr NF/ICMS
					pb_zer(0,                    9)+;//....28.Serv.N?o Trib
					pb_zer(0,                    3)+;//....29.Serv.N?o Trib
					pb_zer(0,                    3)+;//....30.Serv.N?o Trib
					pb_zer(0,                    9)+;//....31.Abatimento NT
					pb_zer(0,                    4)+;//....32.Centro de Custos D?bito
					pb_zer(0,                    4)+;//....32.Centro de Custos D?bito
					'')

		*---------------------------------------------------------------pagina 10 layout PH
		Gera22(NFC->NF_EMIT) // Registro de Entrada e Saida
		*---------------------------------------------------------------pagina 10 layout PH
		
		vIcms:=array(6,3)
		// if str(PEDCAB->PC_NRNF,6)=='  6585'
			// alert('0-Chave='+str(PEDCAB->PC_PEDID,6)+'/'+str(PEDCAB->PC_NRNF,6))
		// end
		//XBuscaIcmsS(str(PEDCAB->PC_PEDID,6))
		// if str(PEDCAB->PC_NRNF,6)=='  6585'
			// alert('1-Chave='+str(PEDCAB->PC_PEDID,6)+'/'+str(PEDCAB->PC_NRNF,6)+';Vlr Isentas Memoria='+str(vIcms[6,1]))
		// end
		aeval(vIcms,{|DET|afill(DET,0)})
		vIcms[6,1]:=nVlrCtb //............SAG S? TEM PRODUTOS ISENTOS

		GravaTXT(23,;//................................. 1
					pb_zer(vIcms[1,1]*100,12)+;//.......... 2..ICMS 1 - BASE
					pb_zer(vIcms[1,2]*100,04)+;//.......... 3..ICMS 1 - ALIQ
					pb_zer(vIcms[1,3]*100,12)+;//.......... 4..ICMS 1 - VALOR
					pb_zer(vIcms[2,1]*100,12)+;//.......... 5..ICMS 2 - BASE
					pb_zer(vIcms[2,2]*100,04)+;//.......... 6..ICMS 2 - ALIQ
					pb_zer(vIcms[2,3]*100,12)+;//.......... 7..ICMS 2 - VALOR
					pb_zer(vIcms[3,1]*100,12)+;//.......... 8..ICMS 3 - BASE
					pb_zer(vIcms[3,2]*100,04)+;//.......... 9..ICMS 3 - ALIQ
					pb_zer(vIcms[3,3]*100,12)+;//..........10..ICMS 3 - VALOR
					pb_zer(vIcms[4,1]*100,12)+;//..........11..ICMS 4 - BASE
					pb_zer(vIcms[4,2]*100,04)+;//..........12..ICMS 4 - ALIQ
					pb_zer(vIcms[4,3]*100,12)+;//..........13..ICMS 4 - VALOR
					pb_zer(vIcms[5,1]*100,12)+;//..........14..ICMS 5 - BASE
					pb_zer(vIcms[5,2]*100,04)+;//..........15..ICMS 5 - ALIQ
					pb_zer(vIcms[5,3]*100,12)+;//..........16..ICMS 5 - VALOR
					pb_zer(vIcms[6,1]*100,12)+;//..........17..ISENTAS
					pb_zer(vIcms[6,2]*100,12)+;//..........18..OUTRAS
					pb_zer(0,07)+;//.......................19..Redu??o da Base de ICMS
					'')

//------------> 24 Cupom Fiscal (s? saidas - N?O TEM NA COLACER)
//------------> 25 IPI --> somente para o silo (QUANDO IMPLANTAR)
		if NATOP->NO_TIPO == '0' //....................Servi?os
			GravaTXT(26,;//................................1-VALORES DE ISS ---> LACERD?POLIS NAO TEM
						pb_zer(0							,12)+;//............2-ISS - BASE
						pb_zer(0							,04)+;//............3-ISS - ALIQ
						pb_zer(0							,12)+;//............4-ISS - VALOR
						pb_zer(0							,12)+;//............5-ISS - Retido ????????????????
						pb_zer(nVlrCtb*100			,12)+;//............6-ISS - Isent/Outr
						pb_zer(0							,12)+;//............7-ISS - SubTrib
						pb_zer(0							,12)+;//............8-ISS - Materiais Aplicados
						pb_zer(0							,12)+;//............9-ISS - SubEmpreitadas
						space(                      30)+;//...........10-OBS (Nao tem)
						'N'+;//.......................................11-Exec.SvcFora Municip
						'N'+;//.......................................12-Bens de Terceiros
						' '+;//.......................................13-Reten??o n?o inclu?da no Art.III LC116/2003
						pb_zer(0							,07)+;//...........14-C?digo IBGE Munic?pio
						pb_zer(0							,01)+;//...........15-Situa??o da Nota Fiscal
						pb_zer(0							,04)+;//...........16-Al?quota de ISS Substituto
						'')
		end
//------------> 27 ICMS-SUBSTITUICAO - nao necessario
//------------> 28 EXCLUS?O DIEF/DIME-SC - nao necessario
//------------> 29 Quando ? SPED n?o gera
		//...............................................TEM QUE BUSCAR INFORMA??ES NA NF DE TRANSPORTE ?
		Gera30(cModDNF,NFC->NF_FATUR,NFC->NF_EMIT)//-> 30 Registro tanto de Entrada e Sa?da
		if NATOP->NO_FLPISC=='S' // NATUREZA NAO DEVE CONSIDERAR PIS/COFINS
			Gera31('S',oNF)//---------------> 31 Ajustes PIS/COFINS
		end
//----> 32 Detalhamento de Transporte de Carga
//----> 33 Detalhamento de Servi?o
//----> 34 Detalhamento de Base CSLL
//----> 35 Reten??o
//----> 36 Valores de PIS/COFINS n?o cumulativos
//----> 37 Desmembramento de Valores do SIMPLES NACIONAL
//...............................................FATURAMENTO (foi solicitado pelo Ademir retirar)
//	aFAT   :=fn_RetParc(PEDCAB->PC_PEDID,PEDCAB->PC_FATUR,PEDCAB->PC_PEDID)
//	Gera38(PEDCAB->PC_FATUR, '', aFAT) // Entrada e saida (PAGINA 14) - Faturamento (E/S)

		if !NFC->NF_FLCAN // Somente NF normal -> excluir gera??o Reg 60 a 69 de NF cancelada
			Gera60('S',oNF,cModDNF,nCodlNF,cNomeCli)
		end
	end
	skip
end
return NIL

*-----------------------------------------------------------------------------*
 static function xBuscaIcmsS(pChave)
*-----------------------------------------------------------------------------*
aeval(vIcms,{|DET|afill(DET,0)})
SALVABANCO
SELECT PEDDET
dbseek(pChave,.T.)
while !eof().and.str(PEDDET->PD_PEDID,6)==pChave
	lFlag:=.T.
	nY   :=0
	for nX:=1 to 5
		if vIcms[nX,2]==PD_ICMSP.and.PD_ICMSP>0 // % ICMS
			vIcms[nX,1]+=PD_BAICM
			vIcms[nX,3]+=PD_VLICM
			lFlag:=.F.
		end
		if vIcms[nX,2]==0.and.nY==0.and.PD_ICMSP>0
			nY:=nX
		end
	next
	if lFlag.and.str(PD_ICMSP+PD_BAICM+PD_VLICM,15,2)>str(0,15,2).and.nY>0
		vIcms[nY,1]:=PD_BAICM
		vIcms[nY,2]:=PD_ICMSP
		vIcms[nY,3]:=PD_VLICM
	end
	vIcms[6,1]+=PD_VLRIS
	vIcms[6,2]+=PD_VLROU
	// if pChave=='175621'
		// alert('Chave='+pChave+'/'+str(PEDCAB->PC_NRNF,6)+';Valor Isentas arq='+str(PD_VLRIS)+';Vlr Isentas Memoria='+str(vIcms[6,1]))
	// end
	skip
end

RESTAURABANCO
return NIL

*--------------------------------------------somar iss
  static function SomarISS(pChave)
*--------------------------------------------somar iss
SALVABANCO
SELECT PEDSVC
nVlrSVC:=0
dbseek(pChave,.T.)
while !eof().and.str(PEDSVC->PS_PEDID,6)==pChave
	nVlrSVC+=PD_VLISS
	skip
end
RESTAURABANCO
return nVlrSVC

*---------------------------------------END FILE--------------------------------------------

