*-----------------------------------------------------------------------------*
* Funcoes da impressora
*-----------------------------------------------------------------------------*

static IMPR:={},_P2:='CFGIMPR.ARR'

*-----------------------------------------------------------------------------*
function IMPR(P1)
*-----------------------------------------------------------------------------*
return(&(IMPR[P1,1]))

*-----------------------------------------------------------------------------*
function IMPRSETUP()
*-----------------------------------------------------------------------------*
local OPC:=1,CONF
pb_lin4('Configura Impressora',procname())
IMPR:=restarray(_P2)
salvacor(.T.)
setcolor('W+/R')
while OPC>0
	OPC:=abrowse(5,13,22,79,IMPR,{'Comando','Descri‡„o'},{40,23},{'@KX','@KX'})
	if OPC>0
		CONF:=padr(IMPR[OPC,1],40)
		@row(),14 get CONF picture '@KX'
		read
		if lastkey()#27
			IMPR[OPC,1]:=trim(CONF)
		end
	end
end
savearray(IMPR,_P2)
salvacor(.F.)
return NIL

*-----------------------------------------------------------------------------*
init procedure IMPRINIC
local P1
if !file(_P2)
	P1:={;
			{'chr(27)+chr(64)',        '01-Reseta Impressora   '},;
			{'chr(27)+chr(15)',        '02-15 Carac p/polegada '},;
			{'chr(18)',                '03-Cancela 15 CPP      '},;
			{'chr(14)',                '04-Expandido uma linha '},;
			{'chr(20)',                '05-Cancela Expandido   '},;
			{'chr(18)',                '06-CFG Especial Cheques'},;
			{'chr(18)',                '07-Cancela CFG Cheques '},;
			{'chr(27)+chr(67)+chr(33)','08-33 linhas por pagina'},;
			{'chr(27)+chr(67)+chr(66)','09-Cancela 33 LPP      '},;
			{'chr(27)+"M"+chr(15)',    '10-20 Carac p/polegada '},;
			{'chr(18)+chr(27)+"P"',    '11-Cancela 20 CPP      '},;
			{'chr(27)+chr(71)',        '12-Enfatizado          '},;
			{'chr(27)+chr(72)',        '13-Cancela Enfatizado  '},;
			{'chr(27)+chr(4)',         '14-Italico             '},;
			{'chr(27)+chr(5)',         '15-Cancela Italico     '},;
			{'chr(27)+"2"',            '16-6 Linhas p/polegada '},;
			{'chr(27)+"0"',            '17-8 Linhas p/polegada '},;
			{'chr(27)+"M"',            '18-12 Carac p/polegada '},;
			{'chr(27)+"P"',            '19-Cancela 12 CPP      '},;
			{'chr(27)+chr(67)+chr(44)','20-44 linhas por pagina'};
			}
	savearray(P1,_P2)
else
	IMPR:=restarray(_P2)
end
return NIL
//-----------------------------------------------------------EOF
