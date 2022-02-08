//-----------------------------------------------------------------------------*
static aVariav := {0}
//...................1
//-----------------------------------------------------------------------------*
#xtranslate aLinDet    => aVariav\[  1 \]
#include 'SAG.CH'

*-----------------------------------------------------------------------------*
function LivrosTS()	//	Livros Fiscais = Impressao
*-----------------------------------------------------------------------------*
local X        :=0
local NumPagI  :=1
local NumPagF  :=0
local TpLivro  :=0
local NomeLivro:=""
private DATA   :={bom(date()),eom(date())}

pb_lin4(_MSG_,ProcName())
if !abre({	'E->PARAMETRO',;
				'E->LIVROPA';
				})
	return NIL
end
While TpLivro==0
	TpLivro:=ALERT('Infome Tipo de Livro que voce deseja;Imprimir os Termos de Abertura e Encerramento',{'Entrada','Saida'})
	if TpLivro==0
		BeepErro()
	end
end
if TpLivro==1
	NomeLivro :=REG_ENTR
	NumLiv :=LIVROPA->PL_LIVENT
	NumPagF:=LIVROPA->PL_PAGENT+1
elseif TpLivro==2
	NomeLivro :=REG_SAID
	NumLiv :=LIVROPA->PL_LIVSAI
	NumPagF:=LIVROPA->PL_PAGSAI+1
end
Assinat:={LIVROPA->PL_ASS1,LIVROPA->PL_ASS2,LIVROPA->PL_ASS3}
X      :=10
pb_box(X++,0,,,,"Informacoes para "+NomeLivro)

 X++
@X  ,02 say 'Data Inicial....:' get DATA[1]    pict mDT
@X++,40 say 'Data Final......:' get DATA[2]    pict mDT valid DATA[2]>=DATA[1]

 X++
@X++,02 say 'Numero do Livro.:' get NumLiv     pict mI5  valid NumLiv>=1
@X  ,02 say 'Pagina Inicial..: '+Str(NumPagI,5)+padc('Ate',16)
@X++,40 say 'Pagina Final....:' get NumPagF    pict mI5  valid NumPagF> 1

 X++
 X++
@X++,2 Say padc('Linha de Assinaturas',77,'-')
@X++,2 get Assinat[1] pict mXXX+'s77' color 'R/W,R/W*+,,,R/W'
@X++,2 get Assinat[2] pict mXXX+'s77' color 'R/W,R/W*+,,,R/W'
@X++,2 get Assinat[3] pict mXXX+'s77' color 'R/W,R/W*+,,,R/W'
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if pb_ligaimp(I15CPP)
		set century OFF // data com ano 2 digitos
		LivrosT({'ABERT','S'},{NumLiv,NumPagF,Year(DATA[1]),Assinat,NomeLivro},;
					{VM_EMPR,;					//1
					 PARAMETRO->PA_ENDER,;	//2 *
					 PARAMETRO->PA_CIDAD,;	//3 *
					 PARAMETRO->PA_UF,;		//4 *
					 PARAMETRO->PA_CGC,;		//5 *
					 PARAMETRO->PA_INSCR,;	//6 *
					 PARAMETRO->PA_NRJC,;	//7 
					 PARAMETRO->PA_DTJC})	//8
		LivrosT({'ENCER','S'},{NumLiv,NumPagF,Year(DATA[1]),Assinat,NomeLivro},;
					{VM_EMPR,;
					 PARAMETRO->PA_ENDER,;
					 PARAMETRO->PA_CIDAD,;
					 PARAMETRO->PA_UF,;
					 PARAMETRO->PA_CGC,;
					 PARAMETRO->PA_INSCR,;
					 PARAMETRO->PA_NRJC,;
					 PARAMETRO->PA_DTJC})
		set century ON // data com ano 4 digitos
		pb_deslimp(C15CPP)
		select LIVROPA
		replace 	PL_DATA		with date(),;	// Data ultima geracado
					PL_OBS		with '',;	// Observação
					PL_ASS1		with Assinat[1],;	// Assinatura 1
					PL_ASS2		with Assinat[2],;	// Assinatura 2
					PL_ASS3		with Assinat[3]	// Assinatura 3
		if TpLivro==1
			replace 	PL_LIVENT	with NumLiv,;	// Ultimo livro de ENTRADA
						PL_PAGENT	with NumPagF		// Ultima Pagina para livro de Entrada
		elseif TpLivro==2
   		replace  PL_LIVSAI	with NumLiv,;	// Ultimo livro de SAIDA
						PL_PAGSAI	with NumPagF		// Ultima Pagina para livro de SAIDA
		end
	end
end
dbcloseall()
return NIL

*--------------------------------------------------------------------------------------*
 static function LIVROST(P0,P1,P2)	//Imprimir Livros
*--------------------------------------------------------------------------------------*
local X
local VM_NRLIN
private VM_TEXTO
private VM_NRDIA:=pb_zer(P1[1],3)
private VM_NRPAG:=pb_zer(P1[2],4)
private VM_DEPAG:=alltrim(pb_extenso(P1[2],{'pagina','paginas'}))
private VM_EMPR :=alltrim(P2[1])
private VM_ENDER:=alltrim(P2[2])
private VM_CIDA :=alltrim(P2[3])
private VM_UF   :=alltrim(P2[4])
private VM_CGC  :=alltrim(P2[5])
private VM_INSCR:=alltrim(P2[6])
private VM_NRJC :=alltrim(P2[7])
private VM_DTJC :=if(val(VM_NRJC)>0,'em '+str(day(P2[8]),2)+' de '+;
											 pb_mesext(month(P2[8]))  +' de '+;
										           str(year(P2[8]),4),'')
private TpLivro:=CharMix('Livro '+P1[5],' ')

**********************************************************************************
	VM_TEXTO:=space(85)+'Pag : '+if(P0[1]=='ABERT','0001',VM_NRPAG)
	VM_TEXTO+=CRLF+CRLF+CRLF

if P0[1]=='ABERT'
	VM_TEXTO+=padc('T  E  R  M  O     D  E     A  B  E  R  T  U  R  A',100)
end
if P0[1]=='ENCER'
	VM_TEXTO+=padc('T  E  R  M  O     D  E     E  N  C  E  R  R  A  M  E  N  T  O',100)
end

	VM_TEXTO+=CRLF+CRLF+CRLF
	VM_TEXTO+=padc(TpLivro+'   N . '+VM_NRDIA,100)
	VM_TEXTO+=CRLF+CRLF
	VM_TEXTO+='Contem o presente livro &VM_NRPAG ( &VM_DEPAG ) folhas numeradas '
	VM_TEXTO+='via computador de nro 0001 a &VM_NRPAG que '
		VM_TEXTO+=if(P0[1]=='ABERT','servira ', 'serviu ')
	VM_TEXTO+='de livro '
	VM_TEXTO+=P1[5]+' n. &VM_NRDIA para '

	VM_TEXTO+=', para o lancamento das operacaoes proprias, no periodo '
	VM_TEXTO+=pb_zer(day(DATA[1]),2) + ' de '+ pb_mesext(DATA[1],'C')+' de '+str(year(DATA[1]),4)+' a '
	VM_TEXTO+=pb_zer(day(DATA[2]),2) + ' de '+ pb_mesext(DATA[2],'C')+' de '+str(year(DATA[2]),4)

	VM_TEXTO+=' da empresa &VM_EMPR , '
	VM_TEXTO+='estabelecida &VM_ENDER municipio de &VM_CIDA - Estado '
	VM_TEXTO+='&VM_UF , inscrita no CGC/MF sob o nro &VM_CGC e inscricao '
	VM_TEXTO+='estadual nro &VM_INSCR registrada na Junta Comercial do '
	VM_TEXTO+='estado &VM_UF nro &VM_NRJC &VM_DTJC .'
	VM_TEXTO+=CRLF+CRLF
	VM_TEXTO+=space(60)+VM_CIDA
	VM_TEXTO+=', '


if P0[1]=='ABERT'
	VM_TEXTO+=pb_zer(day(DATA[1]),2) + ' de '+ pb_mesext(DATA[1],'C')
end
if P0[1]=='ENCER'
	VM_TEXTO+=pb_zer(day(DATA[2]),2) + ' de '+ pb_mesext(DATA[2],'C')
end

VM_TEXTO+=' de '+str(P1[3],4)
VM_TEXTO+=CRLF+CRLF+CRLF

if P0[2]=='S' // imprime ?
	Impressao(P1,VM_TEXTO)
end
return NIL

*----------------------------------------------------------------------
static function Impressao(P1,P2)
*----------------------------------------------------------------------
local VM_NRLIN:=mlcount(P2,100)
local X
set margin to 15
for X:=1 to VM_NRLIN
	?memoline(P2,100,X)
	?
next
?P1[4,1]//ASSINATURA[1]
?P1[4,2]//ASSINATURA[2]
?P1[4,3]//ASSINATURA[3]
set margin to
eject
Return NIL
*---------------------------------------------------------------------EOF
