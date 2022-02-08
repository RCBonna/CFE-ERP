*--------------------------------------------------------------------------------------*
 function CFEPRA12()	// Impressao Receituario Agronomico = TIPO DVS PRODUTOS POR FOLHA
*--------------------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'R->PARAMETRO',;
				'C->CLIENTE',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'R->PROD',;
				'R->PRODAPL2',;
				'C->PRODAPL'})
	return NIL
end
select('PROD')
dbsetorder(2)
select('PRODAPL')
set relation to str(P1_CODPR,L_P) into PROD
DbGoTop()
pb_tela()
pb_lin4(_MSG_,ProcName())
if file('PARAREC.ARR')
	VM_RECAGR:=restarray('PARAREC.ARR')
else//         1      2          3          4          5          6      7      8   9        10
	VM_RECAGR:={0,     0,  space(40), space(10), space(11), space(20),0.000,'ha   ', 0,space(120),space(120),3}
	//          NR REC ART  NOME      CREA       CPF        cultura   area   unidade marg, obs
end
if len(VM_RECAGR)==10
	aadd(VM_RECAGR,space(120))
end
if len(VM_RECAGR)==11
	aadd(VM_RECAGR,3)
end

VM_RECAGR[1]++
VM_CODCL:=0
VM_CODPR:=0
VM_DATA :=date()
VM_DET  :={}
pb_box(,,,,,'Selecao')
@06,02 say 'Vinculado ART:' get VM_RECAGR[02] pict masc(08)
@06,30 say 'Cliente:'       get VM_CODCL      pict mI5      valid fn_codigo(@VM_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@07,02 say 'Profissional :' get VM_RECAGR[03] pict mXXX+'S20'
@07,40 say 'CREA.:'         get VM_RECAGR[04] pict mXXX    
@07,59 say 'CPF:'           get VM_RECAGR[05] pict mCPF    
@08,02 say 'Data.........:' get VM_DATA       pict mDT
@08,30 say 'Nr.Lin:'        get VM_RECAGR[12] pict mI2      valid VM_RECAGR[12]>0 when pb_msg('Nr Linhas antes de imprimir nome do Profissional')
@08,50 say 'Margem:'        get VM_RECAGR[09] pict mI2      valid VM_RECAGR[09]>0 when pb_msg('Nr caracteres de margem para impressao do receiturario')
@10,02 say 'Cultura Padr.:' get VM_RECAGR[06] pict mXXX
@12,02 say 'Obs1:'          get VM_RECAGR[10] pict mXXX+'S70' when pb_msg('Linha OBS/1 no fim do receiturario')
@13,02 say 'Obs2:'          get VM_RECAGR[11] pict mXXX+'S70' when pb_msg('Linha OBS/2 no fim do receiturario')
read
if lastkey()#K_ESC
	savearray(VM_RECAGR,'PARAREC.ARR')
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
				CFEPRA12I() // imprime
			else
				alert('Nao foi digitado produto algum')
			end
		end
	end
end
dbcloseall()
return NIL

*-------------------------------------------------------------------
 static function CFEPRA12I()
*-------------------------------------------------------------------
local VM_CLTOX:={ 0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00}
local VM_CLT  :={'I  ','II ','III','IV '}
local VM_UNLT
if pb_ligaimp(C15CPP+CHR(27)+CHR(67)+chr(72))
	set margin to VM_RECAGR[09]
	? VM_EMPR
	? PARAMETRO->PA_ENDER
	? transform(PARAMETRO->PA_CEP,masc(10))   // +space(59)+pb_zer(VM_RECAGR[1],8)
	? PARAMETRO->PA_CIDAD + space(4)+PARAMETRO->PA_UF
	? 
	?
	?
	? space(5)+left(CLIENTE->CL_RAZAO,40)+space(1)+pb_zer(VM_CODCL,5)
	? space(5)
	??padr(transform(CLIENTE->CL_CGC,masc(if(len(trim(CLIENTE->CL_CGC))>11,17,18))),50)
	??I15CPP+padr(VM_RECAGR[06],25)+' '+transform(VM_RECAGR[07],masc(29))
	??' '+VM_RECAGR[08]+C15CPP
	? space(5)+CLIENTE->CL_ENDER
	? space(8)+CLIENTE->CL_CIDAD
	? space(8)+padr(CLIENTE->CL_BAIRRO,30)+space(5)
	??transform(CLIENTE->CL_CEP,masc(10))+space(10)
	??transform(VM_RECAGR[2],masc(8))
	?
	?
	for X:=1 to len(VM_DET)
		if VM_DET[X,1]>0
			?      'Produto......: '+pb_zer(VM_DET[X,1],L_P)+'-'+INEGR+VM_DET[X,2]+'|'+CNEGR
				??'Cl.Toxicol: '+VM_CLT[VM_DET[X,7]]  // 21+3=24
			? I15CPP
				??padr('Principio Ativo:'+VM_DET[X,8],50)     // 21+20=41
				??padr(' Diagnostico:'+VM_DET[X,12],70)+C15CPP
			? padr('Cultura Aplic:'+VM_DET[X,5],50)     // 21+20=41
				??'Carencia: '+VM_DET[X,10] // 10+10
				
			? I15CPP
			??padr('Quant. Comprada:'+transform(VM_DET[X,3],mD83),30) //21+20=41
				??'Embalagem: '+VM_DET[X,4]+space(1)
				??padr('Dosagem.: '+VM_DET[X,6],34)
				??' Grupo Quimico: '+VM_DET[X,11]
			? VM_DET[X,9]+C15CPP
			? replicate('-',80)
			VM_CLTOX[VM_DET[X,7]*2-1+if(VM_DET[X,4]=='LT ',0,1)]+=VM_DET[X,3]
		else
			for Y:=1 to 6
				?
			end
		end
	next
	?
	?
	? I15CPP+INEGR+padc(trim(VM_RECAGR[10]),120)
	?              padc(trim(VM_RECAGR[11]),120)+CNEGR+C15CPP
	for Y:=1 TO VM_RECAGR[12]
		?
	end
	? space(28)+VM_RECAGR[03]
	? space(28)+VM_RECAGR[04]                    +space(08)+transform(VM_RECAGR[05],masc(17))
	? space(04)+transform(VM_CLTOX[01], masc(29))+space(16)+transform(VM_DATA,      masc(07))
	for X:=2 to 8
		? space(04)+transform(VM_CLTOX[X],masc(29))
	next
	eject
	set margin to
	pb_deslimp(CHR(27)+CHR(67)+chr(66))
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
//--------------------------------------------------------EOF---------------------*
