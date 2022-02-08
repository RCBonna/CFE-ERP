#Include "common.ch"
#Include "inkey.ch"
#Include "button.ch"
#Include "setcurs.ch"
#Include "color.ch"
#Include "hbsetup.ch"
#Include "dbedit.ch"

static Static12,Static13

function DBEDIT2(Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7,Arg8,Arg9,Arg10,Arg11,Arg12)
 local Local1,Local2,Local3,Local4,Local5,Local6,Local7
 *** FOI PRECISO CRIAR ESTA SECAO PARA INICIALIZACAO DOS ARGUMENTOS
 *** COM UM VALOR default, POIS QUANDO COMPILADO COM XHARBOUR
 *** AS LINHAS DE SEPARACAO DE HEADSEP E COLSEP NAO ESTAVAM APARECENDO

 default ARG9  TO chr(196)+chr(194)+chr(196)
 default ARG10 TO " "+CHR(179)+" "
 default ARG11 TO " "
 default ARG12 TO " " 

 if eof()
 GOTO BOTTOM
 end
 Local1:=DBEDSETUP(Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7,Arg8,Arg9,Arg10,Arg11,Arg12)
 Local1:SKIPBLOCK({| _1 | SKIPPED(_1)})
 Local1:AUTOLITE(.F.)
 Local2:=SETCURSOR(0)
 Local7:={Static12,Static13}
 Static12:=.F.
 Static13:=.T.
 Local5:=.T.
 Local3:=.T.
 DO WHILE Local3
 DO WHILE !Local1:STABILIZE()
 if NEXTKEY() <> 0
  EXIT
 end
 ENDDO
 if (Local4:=INKEY()) == 0
 if Local5
  Local3:=CALLUSER(Local1,Arg6,0)
  DO WHILE !Local1:STABILIZE()
  ENDDO
 end
 if Local3 .AND. Static13
  Local1:HILITE()
  Local4:=INKEY(0)
  Local1:DEHILITE()
  if (Local6:=SETKEY(Local4)) <> Nil
  EVAL(Local6,PROCNAME(1),PROCLINE(1),"")
  LOOP
  end
 else
  Static13:=.T.
 end
 end
 Local5:=.T.
 DO case
 case Local4==0
 case Local4==24
 if Static12
  Local1:HITBOTTOM(.T.)
 else
  Local1:DOWN()
 end
 case Local4==5
 if Static12
  Local1:HITTOP(.T.)
 else
  Local1:UP()
 end
 case Local4==3
 if Static12
  Local1:HITBOTTOM(.T.)
 else
  Local1:PAGEDOWN()
 end
 case Local4==18
 if Static12
  Local1:HITTOP(.T.)
 else
  Local1:PAGEUP()
 end
 case Local4==31
 if Static12
  Local1:HITTOP(.T.)
 else
  Local1:GOTOP()
 end
 case Local4==30
 if Static12
  Local1:HITBOTTOM(.T.)
 else
  Local1:GOBOTTOM()
 end
 case Local4==4
 Local1:RIGHT()
 case Local4==19
 Local1:LEFT()
 case Local4==1
 Local1:HOME()
 case Local4==6
 Local1:END()
 case Local4==26
 Local1:PANLEFT()
 case Local4==2
 Local1:PANRIGHT()
 case Local4==29
 Local1:PANHOME()
 case Local4==23
 Local1:PANEND()
 OTHERWISE
 Local3:=CALLUSER(Local1,Arg6,Local4)
 Local5:=.F.
 ENDcase
 ENDDO
 SETCURSOR(Local2)
 Static12:=Local7[1]
 Static13:=Local7[2]
 RETURN .T.

********************************
function DBEDSETUP(Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7,Arg8,Arg9,Arg10,Arg11,Arg12)

	local Local1,Local2,Local3,Local4,Local5,Local6,Local7,Local8

	if VALTYPE(Arg1) <> "N" .OR. Arg1 < 0
		Arg1:=0
	end
	if VALTYPE(Arg2) <> "N" .OR. Arg2 < 0
		Arg2:=0
	end
	if VALTYPE(Arg3) <> "N" .OR. Arg3 > MAXROW() .OR. Arg3 < Arg1
		Arg3:=MAXROW()
	end
 if VALTYPE(Arg4) <> "N" .OR. Arg4 > MAXCOL() .OR. Arg4 < Arg2
	Arg4:=MAXCOL()
 end
 if (Arg4-Arg2)*(Arg3-Arg1) > MAXROW()*MAXCOL()
	Arg1:=Arg2:=0
	Arg3:=MAXROW()
	Arg4:=MAXCOL()
 end
 Local1:=TBROWSEDB(Arg1,Arg2,Arg3,Arg4)
 if ISARRAY(Arg5)
	Local3:=LEN(Arg5)
	Local2:=1
 DO WHILE Local2 <= Local3
 if VALTYPE(Arg5[Local2]) <> "C" .OR. EMPTY(Arg5[Local2])
	EXIT
 end
 Local2++
 ENDDO
 Local3:=Local2-1
 else
 Local3:=FCOUNT()
 end
 if Local3 == 0
 RETURN .F.
 end
 Local1:HEADSEP("мям")
 Local1:COLSEP(" Ё ")
 Local4:=ARRAY(Local3,6)
 if ISARRAY(Arg5)
 FOR Local2:=1 TO Local3
 if "->" $ Arg5[Local2]
  Local6:=AT("->",Arg5[Local2])
  Local4[Local2][3]:=SUBSTR(Arg5[Local2],1,Local6-1)
  Local4[Local2][4]:=SUBSTR(Arg5[Local2],Local6+2)
  Local4[Local2][1]:=Local4[Local2][3]+"->;"+Local4[Local2][4]
 else
  Local4[Local2][3]:=Nil
  Local4[Local2][4]:=Nil
  Local4[Local2][1]:=Arg5[Local2]
 end
 Local4[Local2][2]:=Arg5[Local2]
 NEXT
 elseif FCOUNT() > 0
 FOR Local2:=1 TO Local3
 Local4[Local2][3]:=Nil
 Local4[Local2][4]:=Nil
 Local4[Local2][1]:=FIELDNAME(Local2)
 Local4[Local2][2]:=FIELDNAME(Local2)
 NEXT
 else
 RETURN .F.
 end
 FOR Local2:=1 TO Local3
 Local5:=""
 if ISARRAY(Arg7)
 if LEN(Arg7) >= Local2 .AND. ISCHARACTER(Arg7[Local2]) .AND. !EMPTY(Arg7[Local2])
  Local5:=Arg7[Local2]
 end
 elseif ISCHARACTER(Arg7) .AND. !EMPTY(Arg7)
 Local5:=Arg7
 end
 Local7:=Nil
 if ISMEMO(&(Local4[Local2][2]))
 Local7:="{|| ' <Memo> '}"
 elseif EMPTY(Local5)
 if "->" $ Local4[Local2][2]
  if UPPER(Local4[Local2][3]) == "M"
  Local7:=MEMVARBLOCK(Local4[Local2][2])
  elseif UPPER(Local4[Local2][3]) == "FIELD"
  Local7:=FIELDWBLOCK(Local4[Local2][4],SELECT())
  else
  Local7:=FIELDWBLOCK(Local4[Local2][4],SELECT(Local4[Local2][3]))
  end
 elseif !EMPTY(FIELDPOS(Local4[Local2][2]))
  Local7:=FIELDWBLOCK(Local4[Local2][2],SELECT())
 end
 end
 if ISNIL(Local7)
 if EMPTY(Local5)
  Local7:="{||"+Local4[Local2][2]+"}"
 else
  Local7:="{|| Transform("+Local4[Local2][2]+",'"+Local5+"')}"
 end
 end
 if ISCHARACTER(Local7)
 Local4[Local2][2]:=&Local7
 elseif ISBLOCK(Local7)
 Local4[Local2][2]:=Local7
 end
 if ISARRAY(Arg8)
 if LEN(Arg8) >= Local2 .AND. ISCHARACTER(Arg8[Local2])
  Local4[Local2][1]:=Arg8[Local2]
 end
 elseif ISCHARACTER(Arg8)
 Local4[Local2][1]:=Arg8
 end
 Local4[Local2][3]:=Nil
 if ISARRAY(Arg9)
 if LEN(Arg9) >= Local2 .AND. ISCHARACTER(Arg9[Local2])
  Local4[Local2][3]:=Arg9[Local2]
 end
 elseif ISCHARACTER(Arg9)
 Local4[Local2][3]:=Arg9
 end
 Local4[Local2][4]:=Nil
 if ISARRAY(Arg10)
 if LEN(Arg10) >= Local2 .AND. ISCHARACTER(Arg10[Local2])
  Local4[Local2][4]:=Arg10[Local2]
 end
 elseif ISCHARACTER(Arg10)
 Local4[Local2][4]:=Arg10
 end
 Local4[Local2][5]:=Nil
 if ISARRAY(Arg11)
 if LEN(Arg11) >= Local2 .AND. ISCHARACTER(Arg11[Local2])
  Local4[Local2][5]:=Arg11[Local2]
 end
 elseif ISCHARACTER(Arg11)
 Local4[Local2][5]:=Arg11
 end
 Local4[Local2][6]:=Nil
 if ISARRAY(Arg12)
 if LEN(Arg12) >= Local2 .AND. ISCHARACTER(Arg12[Local2])
  Local4[Local2][6]:=Arg12[Local2]
 end
 elseif ISCHARACTER(Arg12)
 Local4[Local2][6]:=Arg12
 end
 NEXT
 FOR Local2:=1 TO Local3
 Local8:=TBCOLUMNNEW(Local4[Local2][1],Local4[Local2][2])
 if Local4[Local2][3] <> Nil
 Local8:HEADSEP(Local4[Local2][3])
 end
 if Local4[Local2][4] <> Nil
 Local8:COLSEP(Local4[Local2][4])
 end
 if Local4[Local2][5] <> Nil
 Local8:FOOTSEP(Local4[Local2][5])
 end
 if Local4[Local2][6] <> Nil
 Local8:FOOTING(Local4[Local2][6])
 end
 Local1:ADDCOLUMN(Local8)
 NEXT
 RETURN Local1

********************************
function CALLUSER(Arg1,Arg2,Arg3)

 local Local1,Local2,Local3,Local4
 if Arg3 <> 0
 Local1:=4
 elseif !Static12 .AND. EMPTYFILE()
 Local1:=3
 elseif Arg1:HITBOTTOM()
 Local1:=2
 elseif Arg1:HITTOP()
 Local1:=1
 else
 Local1:=0
 end
 DO WHILE !Arg1:STABILIZE()
 ENDDO
 Local3:=RECNO()
 if VALTYPE(Arg2) <> "C" .OR. EMPTY(Arg2)
 if Arg3 == 13 .OR. Arg3 == 27
 Local2:=0
 else
 Local2:=1
 end
 else
 Local2:=&Arg2(Local1,Arg1:COLPOS())
 end
 Local4:=Local2 <> 0
 if !Static12 .AND. eof() .AND. !EMPTYFILE()
 SKIP -1
 end
 if Local2 == 3
 Static12:=!(Static12 .AND. eof())
 if Static12
 GOTO BOTTOM
 Arg1:DOWN()
 else
 Arg1:REFRESHCURRENT()
 end
 Static13:=.F.
 elseif Local2 == 2 .OR. Local3 <> RECNO()
 if Local4
 Static12:=.F.
 if SET(_SET_DELETED) .AND. DELETED() .OR. !EMPTY(DBFILTER()) .AND. !&(DBFILTER())
  SKIP 
 end
 if eof()
  GOTO BOTTOM
 end
 Local3:=RECNO()
 Arg1:REFRESHALL()
 DO WHILE !Arg1:STABILIZE()
 ENDDO
 DO WHILE Local3 <> RECNO()
  Arg1:UP()
  DO WHILE !Arg1:STABILIZE()
  ENDDO
 ENDDO
 Static13:=.F.
 end
 else
 Arg1:REFRESHCURRENT()
 end
 RETURN Local4

*------------------------------------------------------------------*
function SKIPPED(Arg1)
*------------------------------------------------------------------*

 local Local1
 Local1:=0
 if LASTREC() <> 0
 if Arg1 == 0
 if eof() .AND. !Static12
  SKIP -1
  Local1:=-1
 else
  SKIP 0
 end
 elseif Arg1 > 0 .AND. RECNO() <> LASTREC()+1
 DO WHILE Local1 < Arg1
  SKIP 
  if eof()
  if Static12
   Local1++
  else
   SKIP -1
  end
  EXIT
  end
  Local1++
 ENDDO
 elseif Arg1 < 0
 DO WHILE Local1 > Arg1
  SKIP -1
  if BOF()
  EXIT
  end
  Local1--
 ENDDO
 end
 end
 RETURN Local1

function EMPTYFILE

 if LASTREC() == 0
 RETURN .T.
 end
 if (eof() .OR. RECNO() == LASTREC()+1) .AND. BOF()
 RETURN .T.
 end
 RETURN .F.

********************************