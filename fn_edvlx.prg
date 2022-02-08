static VLR:={}

function FN_EDVLR()
#include 'RCB.CH'

local GetList:={}
local ARQ    :='VLR.ARR'
local FLAG   :=.F.
local TF     :=savescreen(5,0,21,30)
local TOTAL,P4,VM_VLR
VLR          :={}
if file(ARQ)
	VLR:=restarray(ARQ)
end
aadd(VLR,{date(),time(),0})
set key K_F7 to
while .t.
	TOTAL:=0
	aeval(VLR,{|DET|TOTAL+=DET[3]})
	@21,1 say space(18)+transform(TOTAL,'@ 99999999.99')+' '
	keyboard replicate(chr(K_DOWN),len(VLR))
	set key K_CTRL_END to LIMPA()
//	set key 73 to IMPRVERIF()
	pb_msg('Para limpar Arquivo CTRL+END')
	P4:=abrowse(5,0,20,30,VLR,	{'Data','Hora',             'Valor'},;
										{    8,      8,                  11},;
										{  '@D',  '@KX',   '@E 99999999.99'})
	set key K_CTRL_END to
	if P4>0
		VM_VLR:=VLR[P4,3]
		@row(),19 get VM_VLR pict '@E 99999999.99'
		read
		if lastkey()#K_ESC
			VLR[P4,3]:=VM_VLR
			FLAG:=.T.
			if VM_VLR>0.00
				IMPRVERIF(dtoc(VLR[P4,1])+' '+VLR[P4,2],VM_VLR,if(P4==len(VLR),'','*'))
			end
		end
	else
		if FLAG
			savearray(VLR,ARQ)
		end
		exit
	end
end
restscreen(5,0,21,30,TF)
set key K_F7 to FN_EDVLR()		// F7-Grava valores
return NIL

static function LIMPA()
if pb_sn('Limpar arquivo de Contagem')
	ferase('VLR.ARR')
	keyboard chr(27)
end
return NIL

*----------------------------------------------------------------------------*
static function IMPRVERIF(P1,P2,P3)
set print ON
set console OFF
?'Impresso :' + P1 + transform(P2,'@E 999999')+P3
for X:=1 TO 9
	?
end
set print OFF
set console ON
return NIL
