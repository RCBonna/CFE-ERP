 static aVariav := {0,'C:\Temp\','ART_INF',{},0,0}
 //.................1..2..........3.........4.5.6
*---------------------------------------------------------------------------------------*
#xtranslate nL         => aVariav\[  1 \]
#xtranslate cArq       => aVariav\[  2 \]
#xtranslate cArqPad    => aVariav\[  3 \]
#xtranslate aCampo     => aVariav\[  4 \]
#xtranslate nCol       => aVariav\[  5 \]
#xtranslate pART       => aVariav\[  6 \]
*--------------------------------------------------------------------------------------------*
 function CFEPRAMN(P1)	// Impressao Receituario Agronomico = TIPO DVS PRODUTOS POR FOLHA
*--------------------------------------------------------------------------------------------*
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
pART:=P1
CFEPRAMN1()
dbcloseall()
return

*--------------------------------------------------------------------------------------------*
  static function CFEPRAMN1()
*--------------------------------------------------------------------------------------------*

select('PROD')
dbsetorder(2)
select('PRODAPL')
set relation to str(P1_CODPR,L_P) into PROD
DbGoTop()
pb_tela()
pb_lin4(_MSG_,ProcName())
cArqPad:='ART_INF'+str(pART,1)+'.ARR'
if file(cArqPad)
	VM_RECAGR:=restarray(cArqPad)
else//           1   2     3          4         5          6          7          8         9         10         11        12        13        14    15   16....17......18..
	VM_RECAGR:={  0,  0,    0, space(35), space(20), space(10), space(40), space(20),space(20), space(02), space(11),space(11),space(20),space(20),0.000, 'Ha ',space(9),0}
	//          ART/REG/NRREC/  NOME      Titulo,    CREA        Endereco,   Bairro ,   Cidade, UF         CPF       Telefone  cultura   Classif   Area   unid  CEP......nrCol
end
if len(VM_RECAGR)#18
	dbcloseall()
	alert('Arquivo deste agronomo esta com problemas;e sera eliminado;favor entrar novamente na impressao;Informar os dados')
	ferase(cArqPad)
	return NIL
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
@X++,02 say 'Telefone.....:' get VM_RECAGR[12] pict mXXX
pb_box(X++,0,,,,'Cliente/Produto')
@X++,02 say 'Cliente:'       get VM_CODCL      pict mI5      valid fn_codigo(@VM_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
pb_box(X++,0,,,,'Cultura')
@X  ,02 say 'Descricao....:' get VM_RECAGR[13] pict mXXX
@X++,42 say 'Classificacao:' get VM_RECAGR[14] pict mXXX
@X  ,02 say 'Area.........:' get VM_RECAGR[15] pict mD83
@X++,42 say 'Unidade......:' get VM_RECAGR[16] pict mXXX
@X  ,02 say 'N.ColunasImpr:' get VM_RECAGR[18] pict mI2
read
if lastkey()#K_ESC
	SaveArray(VM_RECAGR,cArqPad)
	nCol:=VM_RECAGR[18]
	for X:=1 to 6 //PR  DESC     QTD    UNID    CULTURA   DOSAGEM    
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
				ImprRANovo()
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
 static function ImprRANovo()
*-------------------------------------------------------------------
local VM_CLT:={'I','II','III','IV'}
local aLinha:=array(30)
local X
afill(aLinha,'')

aCampo:={{"NrART"       ,alltrim(str(VM_RECAGR[01])) },; //1
			{"NrReg"       ,alltrim(str(VM_RECAGR[02])) },;	//2
			{"NrReceita"   ,pb_zer(     VM_RECAGR[03],6)},;	//3
			{"ProNome"     ,            VM_RECAGR[04]   },;	//4
			{"ProTitulo"   ,            VM_RECAGR[05]   },;	//5
			{"ProRegistro" ,            VM_RECAGR[06]   },;	//6
			{"ProEnd"      ,            VM_RECAGR[07]   },;	//7
			{"ProBairro"   ,            VM_RECAGR[08]   },;	//8
			{"ProMunicipio",            VM_RECAGR[09]   },;
			{"ProCEP"      ,            VM_RECAGR[17]   },;
			{"ProCPF"      ,            VM_RECAGR[11]   },;
			{"ProUF"       ,            VM_RECAGR[10]   },;
			{"ProFone"     ,            VM_RECAGR[12]   },;
			{"CliNome"     ,           CLIENTE->CL_RAZAO},;
			{"CliCGC"      ,transform(CLIENTE->CL_CGC,masc(if(len(trim(CLIENTE->CL_CGC))>11,17,18))) },;
			{"CliLocal"    ,          CLIENTE->CL_ENDER+' - '+CLIENTE->CL_BAIRRO },;
			{"CliMunicipio",          CLIENTE->CL_CIDAD },;
			{"CliCEP"      ,transform(CLIENTE->CL_CEP,masc(10)) },;
			{"CliUF"       ,          CLIENTE->CL_UF    },;
			{"CliFONE"     ,          CLIENTE->CL_FONE  },;
			{"CulDescricao",            VM_RECAGR[13]   },;
			{"CulClassif"  ,            VM_RECAGR[14]   },;
			{"CulArea"     ,  transform(VM_RECAGR[15],mD83)},;
			{"CulUnid"     ,            VM_RECAGR[16]   },;
			{"LocalData"   , trim(PARAMETRO->PA_CIDAD)+", "+dtoc(VM_DATA) }}

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
		//...5
		nL++
		aLinha[nL]:=replicate('-',100)
	else
	end
next
if pb_ligaimp(C15CPP)
	??space(nCol+60)+RtDado("NrART")
	?
	? space(nCol+60)+RtDado("NrReg")
	?
	? space(nCol+60)+RtDado("NrReceita")
	?
	?
	?
	? space(nCol)+RtDado("ProNome")
	??space(   1)+RtDado("ProTitulo")
	??space(   1)+RtDado("ProRegistro")
	?
	? space(nCol)+RtDado("ProEnd")
	?
	? space(nCol)+RtDado("ProBairro")
	??space(   3)+RtDado("ProMunicipio")
	??space(   2)+RtDado("ProCEP")
	??space(   1)+RtDado("ProUF")
	??space(   3)+alltrim(RtDado("ProFone"))
	?
	?
	? space(nCol)+RtDado("CliNome")
	??space(  10)+RtDado("CliCGC")
	?
	? space(nCol)+RtDado("CliLocal")
	?
	? space(nCol)+RtDado("CliMunicipio")
	??space(  23)+RtDado("CliCEP")
	??space(   2)+RtDado("CliUF")
	??space(   3)+alltrim(RtDado("CliFone"))
	?
	?
	? space(nCol)+RtDado("CulDescricao")
	??space(   2)+RtDado("CulClassif")
	??space(   2)+RtDado("CulArea")
	??space(   2)+RtDado("CulUnid")
	?
	?
	for nL:=1 to len(aLinha)
		?space(nCol)+I15CPP+alltrim(aLinha[nL])+C15CPP
	end
	?
	?
	?
	?
	?
	?space(nCol)+RtDado("LocalData")
	?
	? space(nCol+38)+RtDado("ProCPF")
	??space(nCol+10)+RtDado("CliCGC")
	?space(nCol)+INEGR+padc("AGROTOXICO E' VENENO",70)+CNEGR
	EJECT
	pb_deslimp()
end
return NIL

*-------------------------------------------------------------*
 static function RtDado(pCampo)
*-------------------------------------------------------------*
nL:=ascan(aCampo,{|DET|Upper(DET[1])==Upper(pCampo)})
if nL>0
	return aCampo[nL,2]
else
	return 'pCampo'
end
return ''

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
//----------------------------------------------------------------EOF-------------*