//-----------------------------------------------------------------------------*
  static aVariav := {'',0,.T.,{},{},'',{},''}
//.................1....2..3..4...5..6.7...8
//-----------------------------------------------------------------------------*
#xtranslate cArq       => aVariav\[  1 \]
#xtranslate nX         => aVariav\[  2 \]
#xtranslate LCONT      => aVariav\[  3 \]
#xtranslate aPISCOFINS => aVariav\[  4 \]
#xtranslate aPos       => aVariav\[  5 \]
#xtranslate cTela      => aVariav\[  6 \]
#xtranslate cCampos    => aVariav\[  7 \]
#xtranslate nY         => aVariav\[  8 \]
 
#include 'RCB.CH'

//-----------------------------------------------------------------------------*
  function FispCof()	//	Cadastro de Percentuais de PIS + COFINS
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'R->CTADET',;
				'E->FISACOF'})
	return NIL
end
aPISCOFINS:=addMatCof()

pb_dbedit1('FispCof')  // tela
VM_CAMPO:={'',''}
afields(VM_CAMPO)
ORDEM CODUNI
GO TOP

dbedit(06,01,maxrow()-3,maxcol()-1,;
			VM_CAMPO,;
			'PB_DBEDIT2',;
			{ mUUU ,mXXX       },;
			{ 'Cod','Descricao'};
			)
dbcommit()
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function FispCof1() // Rotina de Inclus„o
//-----------------------------------------------------------------------------*
while lastkey()#K_ESC
//	dbgobottom()
//	dbskip()
	FispCofT(.T.)
end
return NIL
//-----------------------------------------------------------------------------*
  function FispCof2() // Rotina de Altera‡„o
//-----------------------------------------------------------------------------*
if reclock()
	FispCofT(.F.)
end
return NIL

//-----------------------------------------------------------------------------*
  function FispCof3() // Rotina de Pesquisa
  return NIL

//-----------------------------------------------------------------------------*
  function FispCof4() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
if reclock().and.DelRec(' Cod.( '+CO_CODCOF+' '+CO_DESCR+')')
end
dbrunlock()
return NIL

//-----------------------------------------------------------------------------*
  function FispCofT(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST := {}
private nX1
ORDEM CODIGO
VM_CTAX  :=''
if VM_FL
	VM_CODCOF:=space(3)
else
	VM_CODCOF:=CO_CODCOF
end
nX     :=7
pb_box(nX++,08,,,,'CAD.BASE PIS+COFINS')
@nX++,10 say 'Codigo.........:' get VM_CODCOF pict mUUU valid !empty(VM_CODCOF) when VM_FL
read
if lastkey()#K_ESC
	//................1.........2........3....4..5.6.7.8
	cCampos   :={	{VM_CODCOF,space(40),'F','01',0,0,0,0,space(4),space(4) },;
						{VM_CODCOF,space(40),'J','01',0,0,0,0,space(4),space(4) };
					}
	dbseek(VM_CODCOF,.T.)
	while !eof().and.VM_CODCOF==CO_CODCOF
		nY:=1
		if CO_TIPOFJ=='J'
			nY:=2
		end
		cCampos[nY,02]:=CO_DESCR
		cCampos[nY,04]:=CO_TIPOIN
		cCampos[nY,05]:=CO_PERC1
		cCampos[nY,06]:=CO_PERC2
		cCampos[nY,07]:=CO_CCTB1
		cCampos[nY,08]:=CO_CCTB2
		cCampos[nY,09]:=CO_HISPHP
		cCampos[nY,10]:=CO_HISPHC
		skip
	end
	VM_CCTB11 :=cCampos[1,7]
	VM_CCTB12 :=cCampos[1,8]
	VM_CCTB21 :=cCampos[2,7]
	VM_CCTB22 :=cCampos[2,8]
	VM_TIPOIN1:=cCampos[1,4]
	VM_TIPOIN2:=cCampos[2,4]
	@nX++,12 Say 'Descricao......:' get cCampos[1,2] pict mXXX valid !empty(cCampos[1,2])
	pb_box(nX++,18,,,,'Pessoa Fisica')
	@nX++,10 Say 'Tipo Incidencia:' get VM_TIPOIN1   pict mUUU valid TipoIncid(@VM_TIPOIN1)                           when pb_msg('conforme tabela')
	@nX  ,10 Say '% PIS..........:' get cCampos[1,05] pict mI62 valid cCampos[1,5]>=0.and.cCampos[1,5]<100            when pb_msg('% PIS')
	@nX++,50 Say '% COFIS:'         get cCampos[1,06] pict mI62 valid cCampos[1,6]>=0.and.cCampos[1,6]<100            when pb_msg('% COFINS')
	@nX++,10 Say 'Cod.CTB PIS....:' get VM_CCTB11     pict mI4  valid VM_CCTB11==0.or.fn_ifconta(@VM_CTAX,@VM_CCTB11) when pb_msg('Codigo Contabil PIS')
	@nX++,10 Say 'Cod.CTB COFIS..:' get VM_CCTB12     pict mI4  valid VM_CCTB12==0.or.fn_ifconta(@VM_CTAX,@VM_CCTB12) when pb_msg('Codigo Contabil Cofins')
	@nX  ,10 Say 'Hist.PIS.......:' get cCampos[1,09] pict mUUU                                                       when pb_msg('Historico de PIS para integracao com EFPH')
	@nX++,50 Say 'Hist.COFIS.:'     get cCampos[1,10] pict mUUU                                                       when pb_msg('Historico de PIS para integracao com EFPH')
	
	pb_box(nX++,12,,,,'Pessoa Juridica')
	@nX++,10 Say 'Tipo Incidencia:' get VM_TIPOIN2   pict mUUU valid TipoIncid(@VM_TIPOIN2)                           when pb_msg('conforme tabela')
	@nX  ,10 Say '% PIS..........:' get cCampos[2,05] pict mI62 valid cCampos[2,5]>=0.and.cCampos[2,5]<100            when pb_msg('% PIS')
	@nX++,50 Say '% COFIS:'         get cCampos[2,06] pict mI62 valid cCampos[2,6]>=0.and.cCampos[2,6]<100            when pb_msg('% COFINS')
	@nX++,10 Say 'Cod.CTB PIS....:' get VM_CCTB21     pict mI4  valid VM_CCTB21==0.or.fn_ifconta(@VM_CTAX,@VM_CCTB21) when pb_msg('Codigo Contabil PIS')
	@nX++,10 Say 'Cod.CTB COFIS..:' get VM_CCTB22     pict mI4  valid VM_CCTB22==0.or.fn_ifconta(@VM_CTAX,@VM_CCTB22) when pb_msg('Codigo Contabil Cofins')
	@nX  ,10 Say 'Hist.PIS.......:' get cCampos[2,09] pict mUUU                                                       when pb_msg('Historico de PIS para integracao com EFPH')
	@nX++,50 Say 'Hist.COFIS.:'     get cCampos[2,10] pict mUUU                                                       when pb_msg('Historico de PIS para integracao com EFPH')

	read
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		dbseek(VM_CODCOF,.T.)
		while !eof().and.VM_CODCOF==CO_CODCOF
			if reclock()
				delete
			end
			skip
		end
		cCampos[2,2]:=cCampos[1,2]

		cCampos[1,4]:=VM_TIPOIN1
		cCampos[2,4]:=VM_TIPOIN2

		cCampos[1,7]:=VM_CCTB11
		cCampos[1,8]:=VM_CCTB12
		cCampos[2,7]:=VM_CCTB21
		cCampos[2,8]:=VM_CCTB22

		for nX:=1 to 2
			addrec(,cCampos[nX])
		end
		dbcommit()
	end
end
dbrunlock(recno())
pack
ORDEM CODUNI
GO TOP
return NIL

//-----------------------------------------------------------------------------*
  function TipoIncid(pTipo)
//-----------------------------------------------------------------------------*
private pTipo1:=left(pTipo,2)
aPos:={row(),col()}
LCONT:=FN_CODARM(@pTipo1,aPISCOFINS[2])
//alert('Selecionado'+pTipo1+' -> '+iif(LCONT,'Sim','Nao'))
//if LCONT
	pTipo:=left(pTipo1,2)
	nX   :=ascan(aPISCOFINS[1],pTipo)
	@aPos[1],aPos[2]-2 say aPISCOFINS[2,nX]
//end
return LCONT

//-----------------------------------------------------------------------------*
  function ChkPisCofins(pCODCOF)
//-----------------------------------------------------------------------------*
LCONT:=.T.
salvabd(SALVA)
select('FISACOF')
dbseek(pCODCOF,.T.)
if pCODCOF#CO_CODCOF
	salvacor()
	DbGoTop()
	cTela:=savescreen(5,0)
	pb_box(09,30,22,79,'W/R','Tabela de PIS/COFINS')
	VM_ROT:=NIL
	dbedit(09,31,21,78,{fieldname(1),fieldname(2)},'FN_TECLAx','','')
	pCODCOF:=&(fieldname(1))
	restscreen(5,0,,,cTela)
	salvacor(.F.)
	LCONT:=.F.
end
salvabd(RESTAURA)
return(LCONT)

//-----------------------------------------------------------------------------*
  function FispCof5() // Impressão
//-----------------------------------------------------------------------------*
return NIL

//-------------------------------------------------------------------------------------------------------------------*
  function AddMatCof() // Impressão------------DE onde veio esta tabela???
//--------------------------------------------------------------------------------------------------------------------*
return ({{	'01','02','03','04','05','06','07','08','09',;
				'49','50','51','52','53','54','55','56',;
				'60','61','62','63','64','65','66','67',;
				'70','71','72','73','74','75',;
				'98','99'},;
			{	'01-Oper.Tributavel com Aliq.Basica                                   ',;
				'02-Oper.Tributavel com Aliq.Diferenciada                             ',;
				'03-Oper.Tributavel com Aliq.por Unidade de Medida de Produto         ',;
				'04-Oper.Tributavel Monofasica-Revenda a Aliq.Zero                    ',;
				'05-Oper.Tributavel (Substituicao Tributaria)                         ',;
				'06-Oper.Tributavel (Aliquota Zero)                                   ',;
				'07-Oper.Isenta da Contribuicao                                       ',;
				'08-Oper.Sem Incidencia da Contribuicao                               ',;
				'09-Oper.Com Suspensao da Contribuicao                                ',;
				'49-Outras Operacoes de Saida                                         ',;
				'50-Oper.c/Direito a Credito-Vinc.Exclus.Receita Trib(MI)             ',;
				'51-Oper.c/Direito a Credito-Vinc.Exclus.Receita Nao Trib.(MI)        ',;
				'52-Oper.c/Direito a Credito-Vinc.Exclus.Receita de Export            ',;
				'53-Oper.c/Direito a Credito-Vinc.Receita Trib.+Nao Trib.(MI)         ',;
				'54-Oper.c/Direito a Credito-Vinc.Receita Trib.(MI)+Export            ',;
				'55-Oper.c/Direito a Credito-Vinc.Receita Nao Trib.(MI)+Export        ',;
				'56-Oper.c/Direito a Credito-Vinc.Receita Trib+Nao Trib.(MI)+Export   ',;
				'60-Cred.Presumido-Oper.Aq.Vinc.Exclus.Receita Trib.(MI)              ',;
				'61-Cred.Presumido-Oper.Aq.Vinc.Exclus.Receita Nao Trib.(MI)          ',;
				'62-Cred.Presumido-Oper.Aq.Vinc.Exclus.Receita de Export              ',;
				'63-Cred.Presumido-Oper.Aq.Vinc.Exclus.Receita Trib.+Nao Trib.(MI)    ',;
				'64-Cred.Presumido-Oper.Aq.Vinc.Exclus.Receita Trib.(MI)+Export       ',;
				'65-Cred.Presumido-Oper.Aq.Vinc.Exclus.Receita Nao Trib.(MI)+Export   ',;
				'66-Cred.Presumido-Oper.Aq.Vinc.Exclus.Receita Trib.+Nao Trib.(MI)+Exp',;
				'67-Credito Presumido - Outras Operacoes                              ',;
				'70-Operação de Aquisicao sem Direito a Credito                       ',;
				'71-Operação de Aquisicao com Isencao                                 ',;
				'72-Operação de Aquisicao com Suspensao                               ',;
				'73-Operação de Aquisicao a Aliquota Zero                             ',;
				'74-Operação de Aquisicao sem Incidencia da Contribuicao              ',;
				'75-Operação de Aquisicao por Substituicao Tributaria                 ',;
				'98-Outras Operacoes de Entrada                                       ',;
				'99-Outras Operacoes                                                  '} })
*----------------------------------------------EOF -----------------------


