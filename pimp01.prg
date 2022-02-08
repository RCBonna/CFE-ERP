*-----------------------------------------------------------------------------*
static aVariav:= { 0,0,1,2003,'','',0,'','','', 0,.T., 0, 0}
 //................1.2.3....4..5..6.7..8..9.10.11, 12.13.14
*-----------------------------------------------------------------------------*
#xtranslate nX       => aVariav\[  1 \]
#xtranslate nY       => aVariav\[  2 \]
#xtranslate nMES     => aVariav\[  3 \]
#xtranslate nANO     => aVariav\[  4 \]
#xtranslate cArqE    => aVariav\[  5 \]
#xtranslate cArqS    => aVariav\[  6 \]
#xtranslate nNrReg   => aVariav\[  7 \]
#xtranslate dInic    => aVariav\[  8 \]
#xtranslate dFinal   => aVariav\[  9 \]
#xtranslate cTipoCli => aVariav\[ 10 \]
#xtranslate xCGC     => aVariav\[ 11 \]
#xtranslate cRT      => aVariav\[ 12 \]
#xtranslate Lar      => aVariav\[ 13 \]
#xtranslate nZ       => aVariav\[ 14 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
 function PIMP01()	// Importacao de Dados IONIX
*-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'R->CODTR',;
				'R->CTRNF',;
				'R->NATOP',;
				'R->ALIQUOTAS',;
				'R->ENTCAB',;
				'C->ENTDET',;
				'C->PEDCAB',;
				'C->PEDDET',;
				'R->PEDSVC',;
				'R->SALDOS',;
				'R->CLIENTE',;
				'R->ATIVIDAD',;
				'R->GRUPOS',;
				'R->FORNEC',;
				'C->PROD'})
	return NIL
end
select CLIENTE
ORDEM CGC
select PROD
ORDEM CODIGO


//ALERT('1='+PARAMETRO->PA_CGC+';2='+transform('75815456000370',masc(18)))
if PARAMETRO->PA_CGC=='75815456000370'
	if pb_ligaimp(I15CPP)
		?'Relatorio da importacao do IONICS - CFE '+dtoc(date())+' '+time()
		?replicate('-',Lar)
		cArqE:='c:\Temp\Posto\'
		cRT  :=xClientes(cArqE+'CLIENTES')
//		if cRT
			cRT:=xProdutos(cArqE+'PRODUTOS')
			if cRT
				cRT:=xNotaSaida(cArqE+'NOTA2',cArqE+'NOTA2PRO')
			end
//		else
//			alert('Erro no arquivo de Clientes-Nao e possivel Continuar')
//		end
		pb_deslimp(C15CPP)
	end	
else
	alert('Empresa incorreta;deve ser CFE do Posto')
end	

dbcloseall()
return NIL

*-----------------------------------------------------
static function xClientes(pArq)
*-----------------------------------------------------
?replicate('-',Lar)
?'CADASTRO DE CLIENTES'
?replicate('-',Lar)
cRT:=.T.
select CLIENTE
ORDEM CGC
USE (pArq) NEW
go top
while !eof()
	xCGC:=padr(SONUMEROS(CGC),14)
	?'Cliente '+CODIGO+'-'
	select CLIENTE
	if dbseek(xCGC)
		??' Esta CFE :'+xCGC+' Nome CFE:'+CL_RAZAO+' IONICS:'+CLIENTES->NOME
		nX:=(CLIENTE->CL_RAZAO==CLIENTES->NOME+space(5))
		??'('+iif(nX,'Correto  ','Incorreto')+')'
		if nX // Tem Erro
			cRT:=.F.
		end
	else
		??' Nao Achei:'+xCGC+' no cadastro CFE - Nome:'+CLIENTES->NOME
		cRT:=.F.
	end
	select CLIENTES
	skip
end
close
return cRT

*-----------------------------------------------------
static function xProdutos(pArq)
*-----------------------------------------------------
@24,00 say 'PRODUTO...'
?replicate('-',Lar)
?'CADASTRO DE PRODUTOS'
?replicate('-',Lar)
cRT:=.T.
select PROD
ORDEM CODIGO
USE (pArq) NEW
go top
while !eof()
	nX:=val(PRODUTOS->CODIGO)+60000
	@24,20 say recno()
	@24,30 say nX 
	@24,40 say PRODUTOS->DESCRICAO
	select PROD
	if dbseek(str(nX,L_P))
		?'Prod:'+str(nX,L_P)+' Ja  existe CFE'
	else
		?'Prod:'+str(nX,L_P)+' Nao Cadastrado'
		while !addrec();end
		replace 	PR_CODGR   with 6001,;
					PR_CODPR   with nX,;
					PR_DESCR   with PRODUTOS->DESCRICAO,;
					PR_COMPL   with PRODUTOS->DESCR_RED,;
					PR_UND     with UPPER(PRODUTOS->UNIDADE_VED),;
					PR_LOCAL   with 'POSTO',;
					PR_ETMIN   with  0,;
					PR_QTATU   with  0,;
					PR_VLATU   with  0,;
					PR_VLVEN   with PRODUTOS->PRECO_VEND,;
					PR_DTMOV   with PRODUTOS->DT_ULT_SAI,;
					PR_DTCOM   with PRODUTOS->DT_ULT_ENT,;
					PR_VLCOM   with PRODUTOS->PRECO_CUST,;
					PR_SLDQT   with  0,;
					PR_SLDVL   with  0,;
					PR_ABCVE   with 'A',;
					PR_ABCET   with 'A',;
					PR_CTB     with 30,;
					PR_RESER   with  0,;
					PR_LUCRO   with 15,;
					PR_PRVEN   with  0,;
					PR_PIPI    with  0,;
					PR_CODTR   with '060',;
					PR_CFTRIB  with '00',;
					PR_PICMS   with  0,;
					PR_PTRIB   with 100,;
					PR_IMPET   with 'N',;
					PR_CODNBM  with '',;
					PR_MODO    with 'N',;
					PR_CTRL    with 'S',;
					PR_PERVEN  with 10,;
					PR_CODTRE  with '060',;
					PR_CODOBS  with '',;
					PR_PISCOF  with '',;
					PR_CODCOE  with '',;
					PR_CODCOS  with ''
		??' Criado Nro '+str(PR_CODPR,L_P)
	end
	select PRODUTOS
	skip
end
return cRT

*-----------------------------------------------------
static function xNotaSaida(pArq1,pArq2)
*-----------------------------------------------------
?replicate('-',Lar)
?'NOTAS FISCAIS ENCONTRADAS NO IONICS'
?replicate('-',Lar)

pb_msg('')
@24,00 say 'Notas Fiscais '
@24,20 say 'Cria Indice'
cRT:=.T.
nX :=0
select PEDCAB
go bottom
nNrReg:=PEDCAB->PC_PEDID+1

ORDEM NNFSER
USE (pArq2) NEW
Index on val(NUMERONOTA) to TMPION
go top

USE (pArq1) NEW
go bottom
while !bof().and.nX<1000
	@24,20 say NOTA2->NNUMERONOT
	@24,28 say nX
	@24,40 say NOTA2->NDATAEM
	nX++
	select PEDCAB
	if dbseek(str(val(NOTA2->NNUMERONOT),6)+'  1') // já tem nota fiscal cadastrada+Serie 1
		? 'NF - JA ACHEI PEDCAB '+NOTA2->NNUMERONOT
	else
		xCGC:=padr(SONUMEROS(NOTA2->nCGC),14)
		if !CLIENTE->(dbseek(xCGC))
			nY:=99999 // não tem codigo
		else
			nY:=CLIENTE->CL_CODCL
		end
		while !addrec();end
		replace	PC_PEDID  with nNrReg,;
					PC_CODCL  with nY,;
					PC_CODBC  with 1,;
					PC_DTEMI  with NOTA2->NDATAEM,;
					PC_DESC   with 0,;
					PC_TOTAL  with NOTA2->NVALORNOTA	,;
					PC_VLRENT with 0,;
					PC_ENCFI  with 0,;
					PC_VLROBS with 0,;
					PC_CODCG  with 1,;
					PC_CODOP  with val(SONUMEROS(NOTA2->NCFOP1)+'000'),;
					PC_FATUR  with 1,;
					PC_NRDPL  with val(NOTA2->NNUMERONOT)*100,;
					PC_NRNF   with val(NOTA2->NNUMERONOT),;
					PC_VEND   with 0,;
					PC_FLAG   with .T.,;
					PC_SERIE  with '  1',;
					PC_OBSER  with '',;
					PC_DESVC  with '',;
					PC_FLDUP  with .F.,;
					PC_TPDOC  with 'NFF',;
					PC_CODFC  with '',;
					PC_FLCAN  with .F.,;
					PC_FLCTB  with .F.,;
					PC_FLOFI  with .F.,;
					PC_FLCXA  with .F.,;
					PC_FLSVC  with .F.,;
					PC_NRCXA  with 0 ,;
					PC_LOTE   with 0 ,;
					TR_NOME   with '',;
					TR_ENDE   with '',;
					TR_MUNI   with '',;
					TR_UFT    with '',;
					TR_TIPO   with 1 ,;
					TR_PLACA  with '',;
					TR_UFV    with '',;
					TR_CGC    with '',;
					TR_INCR   with '',;
					TR_QTDEM  with 0 ,;
					TR_ESPE   with '',;
					TR_MARC   with '',;
					TR_PBRU   with 0 ,;
					TR_PLIQ   with 0 ,;
					TR_PICMS  with 0 ,;
					TR_BICMS  with 0 ,;
					TR_VICMS  with 0
		xNotaDet()
		xCriaCReceber() //...............Criar Contas A Receber
		
	end
	select NOTA2
	skip(-1)
end
return cRT

*-----------------------------------------------------
static function xNotaDet()
*-----------------------------------------------------
select NOTA2PRO
nZ:=0
dbseek(PEDCAB->PC_NRNF)
while !eof().and.PEDCAB->PC_NRNF==val(NUMERONOTA)
	@24,55 say 'DET:'+NUMERONOTA
	nZ++
	select PEDDET
	replace	PD_PEDID  with PEDCAB->PC_PEDID,;
				PD_ORDEM  with nZ,;
				PD_CODPR  with 60000+val(NOTA2PRO->CODIGO),;
				PD_QTDE   with NOTA2PRO->QUANTIDADE,;
				PD_VALOR  with NOTA2PRO->VLTOTAL,;
				PD_VLRMD  with NOTA2PRO->VALORLIQ,;
				PD_DESCV  with NOTA2PRO->DESCONTO,;
				PD_DESCG  with 0,;
				PD_ENCFI  with 0,;
				PD_CODTR  with NOTA2PRO->CST,;
				PD_ICMSP  with NOTA2PRO->ALICOTA,;
				PD_VLICM  with 0,;
				PD_BAICM  with NOTA2PRO->VALORLIQ,;
				PD_VLIRR  with 0,;
				PD_VLISS  with 0,;
				PD_CODOP  with PEDCAB->PC_CODOP,;
				PD_PTRIB  with 0,;
				PD_VLROU  with 0,;
				PD_VLRIS  with NOTA2PRO->VALORLIQ,;
				PD_CODCOF with '',;
				PD_VLPIS  with 0,;
				PD_VLCOFI with 0,;
				PD_VLITEM with NOTA2PRO->VALORLIQ
	select NOTA2PRO
	skip
end
return NIL

*-----------------------------------------------------
static function xCriaCReceber()
*-----------------------------------------------------



return NIL
