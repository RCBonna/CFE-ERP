//--------------------------
//
//--------------------------
function LIBERA_VER()
local P2K
local X    :=array(3)
local DT1  :=boy(date())
local DT2  :=eoy(date())
local CGC  :=0
local CGCG :={	{"Coolacer",75815456000109},; 
					{"",        0},;
					{"",        0},;
					{"",        0},;
					{"",        0},;
					{"",        0},;
					{"",        0},;
					{"",        0},;
					{"",        0},;
					{"",        0},;
				 }
set color to 'w+/b'
CLS

set date brit
set century ON
@00,00 to 23,79 double
@09,08 to 19,70
@11,10 say 'Informe data inicio:' get DT1
@12,10 say 'Informe data Final :' get DT2
@14,10 say 'CNPJ...............:' get CGC pict '@E 99,999,999/9999-99' valid cgc>0
@16,10 say '1-Coolacer'
@17,10 say '2-........'
READ
	if CGC > 10
		P1:=pb_zer(CGC,15)
	elseif CGC>0
		P1:=pb_zer(CGCG[CGC,2],15)
	end
	GDF_Cripto({.T.,DT1,DT2,P1})
	
	if GDF_Cripto({.F.,DT1,DT2,P1})==0
		alert('GDF=LIBERADO')
	else
		alert('GDF=NAO LIBERADO')
	end

return NIL

static function GDF_Cripto(P1)
//--------------------------1=LOGICO
//--------------------------2=DT1
//--------------------------3=DT2
//--------------------------4=CGC
local X:={0,0}
local CHAVE:='421?'
local P2K  :=''
local P2   :=''
local RT   :=1
local ARQ  :='GDFXXLIB.RCB'
CHAVE+=CHAVE+CHAVE+CHAVE+CHAVE+CHAVE+CHAVE+CHAVE+CHAVE+CHAVE+CHAVE+CHAVE
if P1[1] // CRIPTOGRAFA
	P2:=dtos(P1[2])+'?'+dtos(P1[3])+'?'+P1[4]+'?'
// ..........8.......1.......8.......1..15.....1......6  = 32+6
// ..........8.......9......17......18..32....33
	for X[1]:=1 to len(P2)
		X[2]+=asc(substr(P2,X[1],1)) // SOMATORIO
	next
	P2 +=pb_zer(X[2],6)
	for X[1]:=1 to len(P2)
		P2K+=chr(asc(substr(P2,X[1],1))+asc(substr(CHAVE,X[1],1)))
	next
	NHAND:=FCREATE(ARQ)
	FWRITE(NHAND,P2K)
	FCLOSE(NHAND)
	RT:=0
else // LER E CONFERIR
	if file(ARQ)
		NHAND:=FOPEN(ARQ)
		if ferror()==0
			X[1]:=40
			P2:=space(X[1])
			if FREAD(NHAND,@P2,X[1]) == X[1]
				for X[1]:=1 to len(P2)
					P2K+=chr(asc(substr(P2,X[1],1))-asc(substr(CHAVE,X[1],1)))
					if X[1]<35
						X[2]+=asc(substr(P2K,X[1],1)) // SOMATORIO
					end
				next
				if pb_zer(X[2],6)==substr(P2K,35,6)
					//--------------------------------------->
					if P1[4]==substr(P2K,19,15)
						if 	dtos(date())>=substr(P2K,01,08).and.;
							dtos(date())<=substr(P2K,10,08)
							RT:=0
						else
							alert('Error(dt)')
							RT:=2
						end
					else
						Alert('Error(Cgc)')
						RT:=3
					end
				else
					alert('Error(chksun)')
					RT:=4
				end
			else
				Alert('Error(Read)')
				RT:=5
			end	
			FCLOSE(NHAND)
		else
			alert('Error(Open)')
			RT:=6
		end
	else
		alert('Error(Existar)')
		RT:=7
	end
end
return RT
