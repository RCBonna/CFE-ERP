 static aVariav := {0,'C:\Temp\','AR_HTML.ARR'}
 //.................1
*---------------------------------------------------------------------------------------*
#xtranslate nL         => aVariav\[  1 \]
#xtranslate cArq       => aVariav\[  2 \]
#xtranslate cArqPad    => aVariav\[  3 \]
*--------------------------------------------------------------------------------------*
 function CFEPRAHT()	// Impressao Receituario Agronomico = TIPO DVS PRODUTOS POR PAGINA HTML
*--------------------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'R->PARAMETRO',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'C->CLIENTE',;
				'R->PROD',;
				'R->PRODAPL2',;
				'C->PRODAPL'})
	return NIL
end
CFEPRAHT1()
dbcloseall()
return

static function CFEPRAHT1()
select('PROD')
dbsetorder(2)
select('PRODAPL')
set relation to str(P1_CODPR,L_P) into PROD
DbGoTop()
pb_tela()
pb_lin4(_MSG_,ProcName())
if file(cArqPad)
	VM_RECAGR:=restarray(cArqPad)
else//           1   2     3          4         5          6          7          8         9         10         11        12        13        14    15   16....17
	VM_RECAGR:={  0,  0,    0, space(40), space(20), space(10), space(40), space(20),space(20), space(02), space(11),space(11),space(20),space(20),0.000, 'ha ',space(9)}
	//          ART/REG/NRREC/  NOME      Titulo,    CREA        Endereco,   Bairro ,   Cidade, UF        CPF         Telefone   cultura   Classif  Area  unid  CEP
end

VM_RECAGR[3]++
VM_CODCL:=0
VM_CODPR:=0
VM_DATA :=date()
VM_DET  :={}
pb_box(5,0,,,,'Dados Básicos')
 X:=6
@X  ,02 say 'ART...:'     get VM_RECAGR[01] pict mI8
@X  ,22 say 'Registro..:' get VM_RECAGR[02] pict mI8
@X++,52 say 'Receita...:' get VM_RECAGR[03] pict mI6

pb_box(X++,0,,,,'Dados Profissional')
@X++,02 say 'Nome.........:' get VM_RECAGR[04] pict mXXX
@X  ,02 say 'Titulo Profis:' get VM_RECAGR[05] pict mXXX
@X++,52 say 'Reg.CREA..:' get VM_RECAGR[06] pict mXXX
@X++,02 say 'CPF..........:' get VM_RECAGR[11] pict mCPF
@X  ,02 say 'Endereco:'      get VM_RECAGR[07] pict mXXX+'S20'
@X++,42 say 'Bairro.:'       get VM_RECAGR[08] pict mXXX
@X  ,02 say 'CEP.....:'      get VM_RECAGR[17] pict mCEP
@X  ,27 say 'Cidade..:' get VM_RECAGR[09] pict mXXX
@X++,62 say 'UF.:'           get VM_RECAGR[10] pict mXXX
@X++,02 say 'Telefone Fone:' get VM_RECAGR[12] pict mXXX
pb_box(X++,0,,,,'Cliente/Produto')
@X++,02 say 'Cliente:'       get VM_CODCL      pict mI5      valid fn_codigo(@VM_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
pb_box(X++,0,,,,'Cultura')
@X  ,02 say 'Descricao....:' get VM_RECAGR[13] pict mXXX
@X++,42 say 'Classificacao:' get VM_RECAGR[14] pict mXXX
@X  ,02 say 'Area.........:' get VM_RECAGR[15] pict mD83
@X++,42 say 'Unidade......:' get VM_RECAGR[16] pict mXXX
read
if lastkey()#K_ESC
	savearray(VM_RECAGR,cArqPad)
	for X:=1 to 7 //PR  DESC     QTD    UNID    CULTURA   DOSAGEM    
		aadd(VM_DET,{0,space(15), 0.000,space(3),space(20),space(25),'CLTOX','PATIVO','APLIC','Carencia','Gr Quim','Diagnostico'})
		//...........1.....2.......3......4.........5..........6.......7........8.........9......10.........11.............12
	next
	OPC:=1
	while OPC>0
		pb_msg('Selecione uma linha e pressione ENTER, <ESC> sai para impressao')
		OPC:=abrowse(10,0,18,79,VM_DET,  { 'CodPr', 'Descric','Qtdade','Uni','Cultura','Dosag','ClTox','PrincAtivo','Gr Quimic','Diagnostico'},;
													{     L_P,   42-L_P ,     8  ,    3,      20 ,     25 ,     5 ,         20,        20 ,           30},;
													{ masc(21),    mXXX ,   mD83 , mUUU,     mUUU,   mUUU ,  mUUU ,       mUUU,    mUUU   ,         mXXX},,;
													'Selecao dos Produtos')
		if OPC > 0
			VM_CODPR:=VM_DET[OPC,1]
			VM_QTD  :=VM_DET[OPC,3]
			VM_UND  :=padr(VM_DET[OPC,4],3)
			VM_APLS :={}
			@row(),01 get VM_CODPR pict masc(21) valid VM_CODPR==0.or.(fn_codpr(@VM_CODPR,77).and.fn_codp12(VM_CODPR)).and.(VM_UND:=padr(if(empty(PRODAPL->P1_UND),PROD->PR_UND,PRODAPL->P1_UND),3))>=''
			@row(),45 get VM_QTD   pict masc(29) valid VM_QTD>0               when VM_CODPR>0
			@row(),54 get VM_UND   pict mUUU     valid VM_UND+'x'$'LT xKG x'  when VM_CODPR>0.and.pb_msg('Transforme tudo para unidades permitidas <LT>  ou  <KG>')
			read
			if lastkey()#K_ESC
				if VM_CODPR>0
					VM_DET[OPC,01]:=VM_CODPR
					VM_DET[OPC,02]:=PROD->PR_DESCR
					VM_DET[OPC,03]:=VM_QTD
					VM_DET[OPC,04]:=VM_UND
					VM_DET[OPC,05]:=VM_APLS[1] // cultura
					VM_DET[OPC,06]:=VM_APLS[4] // dosagem
					VM_DET[OPC,07]:=PRODAPL->P1_CLTOX
					VM_DET[OPC,08]:=PRODAPL->P1_PRINAT
					VM_DET[OPC,09]:=VM_APLS[2]+VM_APLS[3] // dosagem
					VM_DET[OPC,10]:=VM_APLS[5] // Carencia
					VM_DET[OPC,11]:=PRODAPL->P1_GRQUIM // 
					VM_DET[OPC,12]:=PRODAPL->P1_DIAGN // 
					if VM_DET[OPC,07]<1.or.VM_DET[OPC,07]>4
						VM_DET[OPC,07]:=1
					end
					keyboard replicate(chr(K_DOWN),OPC)
					if PRODAPL->P1_UND#VM_DET[OPC,4]
						if PRODAPL->(reclock())
							replace PRODAPL->P1_UND with VM_DET[OPC,4]
							PRODAPL->(dbrunlock(PRODAPL->(recno())))
						end
					end
				else
					VM_DET[OPC,01]:=0
					VM_DET[OPC,02]:=space(20)
					VM_DET[OPC,03]:=0.00
					VM_DET[OPC,04]:=space(3)
					VM_DET[OPC,05]:=space(20)
					VM_DET[OPC,06]:=space(25)
					VM_DET[OPC,07]:='CLTOX'
					VM_DET[OPC,08]:=' '
					VM_DET[OPC,09]:=' '
					VM_DET[OPC,10]:=' '
					VM_DET[OPC,11]:=' '
					VM_DET[OPC,12]:=' '
				end
			end
		else
			VM_FL:=.F.
			for X:=1 to len(VM_DET)
				if VM_DET[X,1]>0
					VM_FL:=.T.
				end
			next
			if VM_FL
//				CFEPRA12I() // imprime
				ImprHtml()
			else
				alert('Nao foi digitado produto algum')
			end
		end
	end
end
dbcloseall()
return NIL

run ra.bat

return NIL

*-------------------------------------------------------------------
 static function ImprHtml()
*-------------------------------------------------------------------
local VM_CLT:={'I','II','III','IV'}
local aLinha:=array(30)
local aCampo
local X
afill(aLinha,'&nbsp;')

aCampo:={{"NrART"       ,alltrim(str(VM_RECAGR[01])) },;
			{"NrReg"       ,alltrim(str(VM_RECAGR[02])) },;
			{"NrReceita"   ,pb_zer(     VM_RECAGR[03],6)},;
			{"ProNome"     ,alltrim(    VM_RECAGR[04])  },;
			{"ProTitulo"   ,alltrim(    VM_RECAGR[05])  },;
			{"ProRegistro" ,alltrim(    VM_RECAGR[06])  },;
			{"ProEnd"      ,alltrim(    VM_RECAGR[07])  },;
			{"ProBairro"   ,alltrim(    VM_RECAGR[08])  },;
			{"ProMunicipio",alltrim(    VM_RECAGR[09])  },;
			{"ProCEP"      ,alltrim(    VM_RECAGR[17])  },;
			{"ProCPF"      ,alltrim(    VM_RECAGR[11])  },;
			{"ProUF"       ,alltrim(    VM_RECAGR[10])  },;
			{"ProFone"     ,alltrim(    VM_RECAGR[12])  },;
			{"CliNome"     ,alltrim(CLIENTE->CL_RAZAO)  },;
			{"CliCGC"      ,transform(CLIENTE->CL_CGC,if(CLIENTE->CL_TIPOFJ=='F',mCPF, mCGC))},;
			{"CliLocal"    ,alltrim(CLIENTE->CL_ENDER)  },;
			{"CliMunicipio",alltrim(CLIENTE->CL_CIDAD)  },;
			{"CliCEP"      ,transform(CLIENTE->CL_CEP,masc(10)) },;
			{"CliUF"       ,alltrim(CLIENTE->CL_UF)     },;
			{"CliFONE"     ,alltrim(CLIENTE->CL_FONE)   },;
			{"CulDescricao",alltrim(    VM_RECAGR[13])  },;
			{"CulClassif"  ,alltrim(    VM_RECAGR[14])  },;
			{"CulArea"     ,alltrim(transform(VM_RECAGR[15],mD83))},;
			{"CulUnid"     ,alltrim(    VM_RECAGR[16])  },;
			{"LocalData"   ,alltrim(PARAMETRO->PA_CIDAD)+", "+dtoc(VM_DATA) }}

nL:=0
for X:=1 to len(VM_DET)
	if VM_DET[X,1]>0
		//...1
		nL++
		aLinha[nL]:='Produto.: '+pb_zer(VM_DET[X,1],L_P)+'-'+VM_DET[X,2]+space(5)
		aLinha[nL]+='Cl.Toxicol: '+VM_CLT[VM_DET[X,7]]
		//...2
		nL++
		aLinha[nL]:='Principio Ativo: '+VM_DET[X,8]+space(5)
		aLinha[nL]+='Diagnostico: '+VM_DET[X,12]
		//...3
		nL++
		aLinha[nL]:='Cultura Aplic:'+VM_DET[X,5]+Space(5)
		aLinha[nL]+='Carencia: '+VM_DET[X,10]
		//...4
		nL++
		aLinha[nL]:='Quant.Comprada: '+transform(VM_DET[X,3],mD83)+Space(5)
		aLinha[nL]+='Embalagem: '+VM_DET[X,4]+space(5)
		aLinha[nL]+='Dosagem.: '+VM_DET[X,6]+Space(5)
		aLinha[nL]+='Grupo Quimico: '+VM_DET[X,11]
	else
	end
next

	if file('ra\Ra.Css').and.file('ra\CreaSC.jpg')
		FileCopy('ra\Ra.Css'      ,'c:\temp\Ra.Css')
		FileCopy('ra\CreaSC.jpg'  ,'c:\temp\CreaSC.jpg')
	//	if FileCopy('ra\RaFormat.htm','c:\temp\'+aCampo3+'.htm') > 0
		Texto:=MemoRead('Ra\RaFormat.htm')
	//	MEMOEDIT(TEXTO)
		for X:=1 to len(aCampo)
			Texto:=StrTran(Texto,aCampo[X,1],aCampo[X,2])
		next
		for X:=1 to len(aLinha)
			Texto:=StrTran(Texto,'Linha.'+pb_zer(X,2),aLinha[X])
		next
		MemoWrit(cArq+aCampo[3,2]+'.htm',Texto)
		//		MemoWrit('c:\Temp\_Z.htm',Texto)
		A:="ra.bat "+cArq+aCampo[3,2]+'.htm'
		run &A
	Else
		alert('Faltam arquivos basicos de RA;Solicite instalação correta')
	end	
return NIL

*-------------------------------------------------------------*
 static function FN_CODP12(P1)
*-------------------------------------------------------------*
local RT  :=.T.
local APLS:={}
local OPC :=1,TF
salvabd(SALVA)
select('PRODAPL')
if !dbseek(str(P1,L_P))
	alert('Nao foi implantado a Descricao deste Produto.')
	RT:=.F.
else
	TF:=savescreen()
	salvacor(SALVA)
	setcolor('W+/RB','R/W',,,'W+/RB')
	select('PRODAPL2')
	dbseek(str(P1,L_P),.T.)
	while !eof().and.P1==P2_CODPR
		//.................1.................2...................3..........4.........5.....
		aadd(APLS,{P2_CULTUR,left(P2_UTILIZ,55),right(P2_UTILIZ,65),P2_DOSAGE,P2_CARENC})
		dbskip()
	end
	if len(APLS)>0
		pb_msg('Selecione uma Cultura/Aplicacao e pressione ENTER')
		OPC:=abrowse(15,0,22,79,APLS, {'Cultura', 'Indicacao1','Indicacao2','Dosagem','Carencia'},;
												{       20,          55 ,         65 ,      25 ,       10 },;
												{     mUUU,       mXXX ,        mXXX ,    mUUU ,     mUUU },,;
												'Selecione Cultura/Aplicacao '+trim(PROD->PR_DESCR))
		if OPC>0
			VM_APLS:=APLS[OPC]
		else
			RT:=.F.
		end
	else
		alert('Nao foi implantado as Culturas/Utilizacao deste Produto.')
		RT:=.F.
	end
	salvacor(RESTAURA)
	restscreen(,,,,TF)
end
salvabd(RESTAURA)
return RT
//-------------------------------------------------------------EOF----------------*
