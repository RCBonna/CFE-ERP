*-----------------------------------------------------------------------------*
 static aVariav:= {0, '', 0, 0, 0 }
 //................1..2...3..4..5
*-----------------------------------------------------------------------------*
#xtranslate nOrdem   => aVariav\[  1 \]
#xtranslate dMovto   => aVariav\[  2 \]
#xtranslate nDocto   => aVariav\[  3 \]
#xtranslate nVlrMov  => aVariav\[  4 \]
#xtranslate nQtdeMov => aVariav\[  5 \]

*-----------------------------------------------------------------------------*
 function CFEP4420()	//	Movimetacoes do estoque - ACERTOS							*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'R->PARAMETRO',;
				'R->ALIQUOTAS',;
				'R->CODTR',;
				'C->FISACOF',;
				'C->SALDOS',;
				'C->UNIDADE',;
				'C->GRUPOS',;
				'C->XOBS',;
				'E->PROD',;
				'E->MOVEST'})
	return NIL
end
//-------------------------------------------para relatorio
pb_dbedit1('CFEP442','AcertoLista Exclui')

select('GRUPOS')
set filter to GRUPOS->GE_CODGR%10000>0

select('PROD')
ORDEM CODIGO

select('MOVEST')
ORDEM DTCOD
DbGoTop()
set relation to str(ME_CODPR,L_P) into PROD

VM_CAMPO:={ fieldname(07),;	// Tipo
				fieldname(02),;	// Data
				'str(MOVEST->ME_CODPR,L_P)+chr(45)+left(PROD->PR_DESCR,22)',;
				fieldname(03),;	// Docto
				fieldname(04),;	// Qtde
				fieldname(05),;	// Vlr Mov Médio
				FieldName(15);		// Forma
				}
VM_CABE    :={'T','Dt Movto','Produto','Dcto','Qtde.','Vlr.Est.','F'}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',,VM_CABE)
set relation to
// dbcommit()
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function CFEP4421() // Rotina de Inclus„o
*-----------------------------------------------------------------------------*
local GETLIST  := {}
while lastkey()#K_ESC
	private VM_CODPR := 0
	dMovto  := PARAMETRO->PA_DATA
	nDocto := val(right(dtos(date()),4))
	nQtdeMov  := 0
	pb_box(15,20,,,,'Informe')
	@16,22 say 'C¢d.Produto....:' get VM_CODPR pict masc(21) valid fn_codpr(@VM_CODPR,78).and.fn_rtunid(VM_CODPR)
	@17,22 say 'Data Moviment..:' get dMovto   pict mDT      valid dMovto<=PARAMETRO->PA_DATA
	@18,22 say 'Nr.Documento...:' get nDocto   pict masc(8)
	@19,22 say 'Qtde.Moviment..:' get nQtdeMov pict masc(6)  valid fn_sdest(nQtdeMov)
	@20,22 say 'Vlr Tot.Mvto...:'
	@21,22 say 'Valor Un.Venda.:'
	read
	nVlrMov:=pb_divzero(PROD->PR_VLATU,PROD->PR_QTATU)*abs(nQtdeMov)
	if lastkey()#27
		@20,40 get nVlrMov pict masc(5) valid nQtdeMov#0 .or. nVlrMov#0
		read
	end
	@20,40 say transform(nVlrMov,masc(2))
	@21,40 say transform((PROD->PR_VLVEN*abs(nQtdeMov)),masc(2))
	setcolor(VM_CORPAD)
	if str(round(PROD->PR_QTATU+nQtdeMov,2),15,2)==str(0,15,2)
		nVlrMov:=0 // PROD->PR_VLATU --> se não tem quantidade não pode ter valor
	end
	if if(lastkey()#K_ESC,pb_sn(),.F.)

		select('PROD')
		replace 	PR_VLATU with PR_VLATU+(nVlrMov*if(nQtdeMov<0,-1,1)),;
					PR_QTATU with PR_QTATU+nQtdeMov,;
					PR_DTMOV with dMovto

		select('MOVEST')
		GrMovEst({	VM_CODPR,;	//	1 Cod Produto
						dMovto,;		//	2 Data Movto
						nDocto,;		//	3 Nr Docto
						nQtdeMov,;	//	4 Qtde
						nVlrMov,;	//	5 Vlr Medio
						PROD->PR_VLVEN*abs(nQtdeMov),;//	6 Vlr Venda
						'A',;			//	7 Tipo Ajuste
						PROD->PR_CTB,;	//	8 Tipo Produto
						'',;			// 9 Serie - despesas
						0,;			//10 Cod Fornec
						0,;			//11 D-Conta contábil Despesa
						0,;			//12 D-Conta contábil Icms
						0,;			//13 Vlr Icms
						.F.,;			//14 Contabilizado ?
						'N'})			//15 P=Producao  //  D=Despesas // N=Normal

	end
	dbcommitall()
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEP4422() && Rotina de Impressao
*-----------------------------------------------------------------------------*
CFEP4462('Estoque Lista de Acertos ref: ','A')
select('MOVEST')
ORDEM DTCOD

DbGoTop()
return NIL

*-----------------------------------------------------------------------------*
 function CFEP4423() // Rotina de Exclusão
*-----------------------------------------------------------------------------*
if MOVEST->ME_TIPO$'A '
	if reclock().and.pb_sn('Exclui Movimentacao Acerto:'+pb_zer(ME_CODPR,L_P)+'-'+trim(PROD->PR_DESCR)+'?')
		if pb_sn('Alterar tambem o saldo PRODUTO ?')
			if PROD->(reclock())
				replace  PROD->PR_QTATU with PROD->PR_QTATU-MOVEST->ME_QTD,;
							PROD->PR_VLATU with PROD->PR_VLATU-MOVEST->ME_VLEST
			else
				alert('Saldo nao alterado;Nao foi possivel travar registro item estoque')
			end
		end
		dbdelete()
		dbskip()
		if eof()
			DbGoTop()
		end
	end
else
	alert('Tipo de Movimento deve ser [A] - Acerto')
end
dbUnLockAll()
return NIL
//-----------------------------------------------------------------------------EOF
