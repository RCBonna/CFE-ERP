*-----------------------------------------------------------------------------*
static aVariav := {.T.,''}
 //.................1.2..3..4..5..6..7..8..9.10.11.12.13.14 15 16 17,18,19,20,21
*-----------------------------------------------------------------------------*
#xtranslate pLinha	=> aVariav\[  1 \]
#xtranslate qLinha	=> aVariav\[  2 \]

static TLivro:="Registro de Entrada"
function LivrosI(P1)	//	Livros Fiscais = Impressao
*-----------------------------------------------------------------------------*
#include 'SAG.CH'

local X
local Linha
pb_lin4(_MSG_,ProcName())
if !abre({	'E->PARAMETRO',;
				'E->CLIENTE',;
				'R->NATOP',;
				'E->LIVROPA',;
				'E->LIVRO';
				})
	return NIL
end
private DATA   :={bom(date()),eom(date())}
private Lar    :=132
private TOT    :={{0,0,0,0},{0,0,0,0},0}

Periodo:=LIVROPA->PL_PERIO
select LIVRO
if P1=='E'
	TLivro :=REG_ENTR
	NumLiv :=LIVROPA->PL_LIVENT
	NumPag :=LIVROPA->PL_PAGENT+1
	ORDEM ENTRADAS
else
	TLivro :=REG_SAID
	NumLiv :=LIVROPA->PL_LIVSAI
	NumPag :=LIVROPA->PL_PAGSAI+1
	ORDEM SAIDAS
end
X      :=16
Termo  :={'N','N'}
Assinat:={LIVROPA->PL_ASS1,LIVROPA->PL_ASS2,LIVROPA->PL_ASS3}
pb_box(X++,18,,,,"Informacoes para "+TLivro)
 X++
@X++,20 say 'Imprime Periodo.:' get Periodo    pict mPER valid Periodo<=LIVROPA->PL_PERIO
@X++,20 say 'Numero do Livro.:' get NumLiv     pict mI5  valid NumLiv>=1
@X++,20 say 'Pagina Inicial..:' get NumPag     pict mI5  valid NumPag> 1
 X++
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if pb_ligaimp(I15CPP)
		set century OFF // data com ano 4 digitos
		NumPag--
   	DATA:={CTOD(""),CTOD("")}
   	DATA[1]:=ctod("01/"+right(Periodo,2)+"/"+left(Periodo,4))
   	DATA[2]:=eom(DATA[1])
   	FL_CAB :=.F.
   	select LIVRO
   	DbGoTop()
   	dbseek(dtos(DATA[1]),.T.)
		DataQueb:=LV_DATA
		pLinha:=.T.
		qLinha:=''
		while !eof().and.dtos(LV_DATA)<=dtos(DATA[2])

//   		if DataQueb#LV_DATA
//				?'--> Quebra:CTB...'+transform(TOT[3],  masc(25))
//				?'--> Quebra:Base..'+transform(TOT[1,1],masc(25))
//				?'--> Quebra:Icms..'+transform(TOT[1,2],masc(25))
//				?'--> Quebra:Isent.'+transform(TOT[1,3],masc(25))
//				?'--> Quebra:Outr..'+transform(TOT[1,4],masc(25))
//				DataQueb:=LV_DATA
//			end

   		if !FL_CAB
	  			Liv_Cab(.T.)
	  			FL_CAB:=.T.
			end
  			Liv_Cab(.F.)
			if qLinha==dtos(LV_DATA)+LV_SERIE+str(LV_NRDOC,12)
				pLinha:=.F.
			else
				qLinha:=dtos(LV_DATA)+LV_SERIE+str(LV_NRDOC,12)
				pLinha:=.T.
			end
			Liv_Lin()
			TOT[3]+=LV_VLRCTB
			PROXIMO
		end
		if TOT[1,1]+TOT[1,2]+TOT[1,3]+TOT[1,4]+;
		   TOT[2,1]+TOT[2,2]+TOT[2,3]+TOT[2,4] > 0
   		?replicate('-',Lar)
   		? padc("Totais",46)+transform(TOT[3],mD82)
   		??space(11)+"|Icms|"
         ??transform(TOT[1,1],mD82)+space(8)
         ??transform(TOT[1,2],mD82)+"| "
         ??transform(TOT[1,3],mD82)+"|"
         ??transform(TOT[1,4],mI92)+"|"
     			Liv_Cab(.F.)
   		? space(69)+"|Ipi |"
         ??transform(TOT[2,1],mD82)+space(8)
         ??transform(TOT[2,2],mD82)+"| "
         ??transform(TOT[2,3],mD82)+"|"
         ??transform(TOT[2,4],mI92)+"|"
   		?replicate('-',Lar)
		end
		eject
		set century ON // data com ano 4 digitos
		pb_deslimp(C15CPP)
		select LIVROPA
		replace 	PL_DATA		with date(),;		// Data ultima geracado
					PL_OBS		with '',;			// Observação
					PL_ASS1		with Assinat[1],;	// Assinatura 1
					PL_ASS2		with Assinat[2],;	// Assinatura 2
					PL_ASS3		with Assinat[3],;	// Assinatura 3
					PL_PERIO		with Periodo
		if P1=='E'
			replace 	PL_LIVENT	with NumLiv,;	// Ultimo livro de ENTRADA
						PL_PAGENT	with NumPag		// Ultima Pagina para livro de Entrada
		elseif P1=='S'
   		replace  PL_LIVSAI	with NumLiv,;	// Ultimo livro de SAIDA
						PL_PAGSAI	with NumPag		// Ultima Pagina para livro de SAIDA
		end
	end
end
dbcloseall()
return NIL

//--------------------------------------Linha do livro
  static function LIV_LIN()
//--------------------------------------Linha do livro
if pLinha
	? dtoc(LV_DATA)             +"|"
	??LV_ESPECIE                +" "
	??LV_SERIE                  +"  "
	??pb_zer(LV_NRDOC,        9)+" "
	??dtoc(LV_DTDOC)            +" "
	??pb_zer(LV_CODEMI,       5)+" "
	??LV_UFEMI                  +"|"
else
	?Space(45)+"|"
end
??transform(LV_VLRCTB, mD82)+"|"
??Str(LV_CODCTB,          3)+"  "
??LV_CODFIS                 +"|"
??"Icms|"
??transform(LV_ICMSBAS,mD82)+" "
??transform(LV_ICMSPER,mI62)+" "
??transform(LV_ICMSVLR,mD82)+"| "
??transform(LV_VLRISE, mD82)+"|"
??transform(LV_VLROUT, mI92)+"|"
if len(alltrim(LV_OBS))>0
	?space(40)+LV_OBS
end
TOT[1,1]+=LV_ICMSBAS
TOT[1,2]+=LV_ICMSVLR
TOT[1,3]+=LV_VLRISE
TOT[1,4]+=LV_VLROUT
return NIL

*--------------------------------------cabecalho do livro
  static function LIV_CAB(PULA)
*--------------------------------------cabecalho do livro
if PULA.or.prow()>60
	Eject
	NumPag++
	?replicate('-',Lar)
	?INEGR+padc(TLivro,Lar)+CNEGR
	?replicate('-',Lar)
	?padr('Empresa.......: '+VM_EMPR,66)                              +"|"+padr('Folha.........: '+pb_zer(NumPag,3) ,64)                  +"|"
	?padr('Inscr Estadual: '+PARAMETRO->PA_INSCR,66)                  +"|"+space(64)                                                       +"|"
	?padr('C.G.C.........: '+transform(PARAMETRO->PA_CGC,masc(18)),66)+"|"+padr('Mes/Ano.......: '+right(PERIODO,2)+'/'+left(PERIODO,4),64)+"|"
	?replicate('-',Lar)
	?space(         8)+'+'+padc('Documentos Fiscais',36,'-')+'+            |          +'+padc('Valores das Operacoes Fiscais',61,'-')+'+'
	?padc('Data'   ,8)+'|    Serie            Data   Emitente|       Valor|Classific.|ICMS|     Com Debito de Imposto      |   Sem Debito Imposto  |'
	?padc('Entrada',8)+'|ESP SubSe   Numero Document Codig UF|    Contabil|Ctb Fiscal| IPI|Base Calculo % Aliq Imp Debitado|Isento/N.Trib|   Outros|'
	?replicate('-',Lar)
end
return NIL

*-------------------------------------------------------------EOF-----------------------------------
