#Include "common.ch"
#Include "inkey.ch"
#Include "button.ch"
#Include "setcurs.ch"
#Include "color.ch"
#Include "hbsetup.ch"
#Include "dbedit.ch"

STATIC Static12,Static13

FUNCTION DBEDIT(Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7,Arg8,Arg9,Arg10,Arg11,Arg12)
 LOCAL Local1,Local2,Local3,Local4,Local5,Local6,Local7

 *** FOI PRECISO CRIAR ESTA SECAO PARA INICIALIZACAO DOS ARGUMENTOS
 *** COM UM VALOR DEFAULT, POIS QUANDO COMPILADO COM XHARBOUR
 *** AS LINHAS DE SEPARACAO DE HEADSEP E COLSEP NAO ESTAVAM APARECENDO

 DEFAULT ARG9 TO chr(196)+chr(194)+chr(196)
 DEFAULT ARG10 TO " "+CHR(179)+" "
 DEFAULT ARG11 TO " "
 DEFAULT ARG12 TO " " 

 IF EOF()
 GOTO BOTTOM
 ENDIF
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
 IF NEXTKEY() <> 0
  EXIT
 ENDIF
 ENDDO
 IF (Local4:=INKEY()) == 0
 IF Local5
  Local3:=CALLUSER(Local1,Arg6,0)
  DO WHILE !Local1:STABILIZE()
  ENDDO
 ENDIF
 IF Local3 .AND. Static13
  Local1:HILITE()
  Local4:=INKEY(0)
  Local1:DEHILITE()
  IF (Local6:=SETKEY(Local4)) <> Nil
  EVAL(Local6,PROCNAME(1),PROCLINE(1),"")
  LOOP
  ENDIF
 ELSE
  Static13:=.T.
 ENDIF
 ENDIF
 Local5:=.T.
 DO CASE
 CASE Local4==0
 CASE Local4==24
 IF Static12
  Local1:HITBOTTOM(.T.)
 ELSE
  Local1:DOWN()
 ENDIF
 CASE Local4==5
 IF Static12
  Local1:HITTOP(.T.)
 ELSE
  Local1:UP()
 ENDIF
 CASE Local4==3
 IF Static12
  Local1:HITBOTTOM(.T.)
 ELSE
  Local1:PAGEDOWN()
 ENDIF
 CASE Local4==18
 IF Static12
  Local1:HITTOP(.T.)
 ELSE
  Local1:PAGEUP()
 ENDIF
 CASE Local4==31
 IF Static12
  Local1:HITTOP(.T.)
 ELSE
  Local1:GOTOP()
 ENDIF
 CASE Local4==30
 IF Static12
  Local1:HITBOTTOM(.T.)
 ELSE
  Local1:GOBOTTOM()
 ENDIF
 CASE Local4==4
 Local1:RIGHT()
 CASE Local4==19
 Local1:LEFT()
 CASE Local4==1
 Local1:HOME()
 CASE Local4==6
 Local1:END()
 CASE Local4==26
 Local1:PANLEFT()
 CASE Local4==2
 Local1:PANRIGHT()
 CASE Local4==29
 Local1:PANHOME()
 CASE Local4==23
 Local1:PANEND()
 OTHERWISE
 Local3:=CALLUSER(Local1,Arg6,Local4)
 Local5:=.F.
 ENDCASE
 ENDDO
 SETCURSOR(Local2)
 Static12:=Local7[1]
 Static13:=Local7[2]
 RETURN .T.

********************************
FUNCTION DBEDSETUP(Arg1,Arg2,Arg3,Arg4,Arg5,Arg6,Arg7,Arg8,Arg9,Arg10,Arg11,Arg12)

 LOCAL Local1,Local2,Local3,Local4,Local5,Local6,Local7,Local8

 IF VALTYPE(Arg1) <> "N" .OR. Arg1 < 0
 Arg1:=0
 ENDIF
 IF VALTYPE(Arg2) <> "N" .OR. Arg2 < 0
 Arg2:=0
 ENDIF
 IF VALTYPE(Arg3) <> "N" .OR. Arg3 > MAXROW() .OR. Arg3 < Arg1
 Arg3:=MAXROW()
 ENDIF
 IF VALTYPE(Arg4) <> "N" .OR. Arg4 > MAXCOL() .OR. Arg4 < Arg2
 Arg4:=MAXCOL()
 ENDIF
 IF (Arg4-Arg2)*(Arg3-Arg1) > MAXROW()*MAXCOL()
 Arg1:=Arg2:=0
 Arg3:=MAXROW()
 Arg4:=MAXCOL()
 ENDIF
 Local1:=TBROWSEDB(Arg1,Arg2,Arg3,Arg4)
 IF ISARRAY(Arg5)
 Local3:=LEN(Arg5)
 Local2:=1
 DO WHILE Local2 <= Local3
 IF VALTYPE(Arg5[Local2]) <> "C" .OR. EMPTY(Arg5[Local2])
  EXIT
 ENDIF
 Local2++
 ENDDO
 Local3:=Local2-1
 ELSE
 Local3:=FCOUNT()
 ENDIF
 IF Local3 == 0
 RETURN .F.
 ENDIF
 Local1:HEADSEP("мям")
 Local1:COLSEP(" Ё ")
 Local4:=ARRAY(Local3,6)
 IF ISARRAY(Arg5)
 FOR Local2:=1 TO Local3
 IF "->" $ Arg5[Local2]
  Local6:=AT("->",Arg5[Local2])
  Local4[Local2][3]:=SUBSTR(Arg5[Local2],1,Local6-1)
  Local4[Local2][4]:=SUBSTR(Arg5[Local2],Local6+2)
  Local4[Local2][1]:=Local4[Local2][3]+"->;"+Local4[Local2][4]
 ELSE
  Local4[Local2][3]:=Nil
  Local4[Local2][4]:=Nil
  Local4[Local2][1]:=Arg5[Local2]
 ENDIF
 Local4[Local2][2]:=Arg5[Local2]
 NEXT
 ELSEIF FCOUNT() > 0
 FOR Local2:=1 TO Local3
 Local4[Local2][3]:=Nil
 Local4[Local2][4]:=Nil
 Local4[Local2][1]:=FIELDNAME(Local2)
 Local4[Local2][2]:=FIELDNAME(Local2)
 NEXT
 ELSE
 RETURN .F.
 ENDIF
 FOR Local2:=1 TO Local3
 Local5:=""
 IF ISARRAY(Arg7)
 IF LEN(Arg7) >= Local2 .AND. ISCHARACTER(Arg7[Local2]) .AND. !EMPTY(Arg7[Local2])
  Local5:=Arg7[Local2]
 ENDIF
 ELSEIF ISCHARACTER(Arg7) .AND. !EMPTY(Arg7)
 Local5:=Arg7
 ENDIF
 Local7:=Nil
 IF ISMEMO(&(Local4[Local2][2]))
 Local7:="{|| ' <Memo> '}"
 ELSEIF EMPTY(Local5)
 IF "->" $ Local4[Local2][2]
  IF UPPER(Local4[Local2][3]) == "M"
  Local7:=MEMVARBLOCK(Local4[Local2][2])
  ELSEIF UPPER(Local4[Local2][3]) == "FIELD"
  Local7:=FIELDWBLOCK(Local4[Local2][4],SELECT())
  ELSE
  Local7:=FIELDWBLOCK(Local4[Local2][4],SELECT(Local4[Local2][3]))
  ENDIF
 ELSEIF !EMPTY(FIELDPOS(Local4[Local2][2]))
  Local7:=FIELDWBLOCK(Local4[Local2][2],SELECT())
 ENDIF
 ENDIF
 IF ISNIL(Local7)
 IF EMPTY(Local5)
  Local7:="{||"+Local4[Local2][2]+"}"
 ELSE
  Local7:="{|| Transform("+Local4[Local2][2]+",'"+Local5+"')}"
 ENDIF
 ENDIF
 IF ISCHARACTER(Local7)
 Local4[Local2][2]:=&Local7
 ELSEIF ISBLOCK(Local7)
 Local4[Local2][2]:=Local7
 ENDIF
 IF ISARRAY(Arg8)
 IF LEN(Arg8) >= Local2 .AND. ISCHARACTER(Arg8[Local2])
  Local4[Local2][1]:=Arg8[Local2]
 ENDIF
 ELSEIF ISCHARACTER(Arg8)
 Local4[Local2][1]:=Arg8
 ENDIF
 Local4[Local2][3]:=Nil
 IF ISARRAY(Arg9)
 IF LEN(Arg9) >= Local2 .AND. ISCHARACTER(Arg9[Local2])
  Local4[Local2][3]:=Arg9[Local2]
 ENDIF
 ELSEIF ISCHARACTER(Arg9)
 Local4[Local2][3]:=Arg9
 ENDIF
 Local4[Local2][4]:=Nil
 IF ISARRAY(Arg10)
 IF LEN(Arg10) >= Local2 .AND. ISCHARACTER(Arg10[Local2])
  Local4[Local2][4]:=Arg10[Local2]
 ENDIF
 ELSEIF ISCHARACTER(Arg10)
 Local4[Local2][4]:=Arg10
 ENDIF
 Local4[Local2][5]:=Nil
 IF ISARRAY(Arg11)
 IF LEN(Arg11) >= Local2 .AND. ISCHARACTER(Arg11[Local2])
  Local4[Local2][5]:=Arg11[Local2]
 ENDIF
 ELSEIF ISCHARACTER(Arg11)
 Local4[Local2][5]:=Arg11
 ENDIF
 Local4[Local2][6]:=Nil
 IF ISARRAY(Arg12)
 IF LEN(Arg12) >= Local2 .AND. ISCHARACTER(Arg12[Local2])
  Local4[Local2][6]:=Arg12[Local2]
 ENDIF
 ELSEIF ISCHARACTER(Arg12)
 Local4[Local2][6]:=Arg12
 ENDIF
 NEXT
 FOR Local2:=1 TO Local3
 Local8:=TBCOLUMNNEW(Local4[Local2][1],Local4[Local2][2])
 IF Local4[Local2][3] <> Nil
 Local8:HEADSEP(Local4[Local2][3])
 ENDIF
 IF Local4[Local2][4] <> Nil
 Local8:COLSEP(Local4[Local2][4])
 ENDIF
 IF Local4[Local2][5] <> Nil
 Local8:FOOTSEP(Local4[Local2][5])
 ENDIF
 IF Local4[Local2][6] <> Nil
 Local8:FOOTING(Local4[Local2][6])
 ENDIF
 Local1:ADDCOLUMN(Local8)
 NEXT
 RETURN Local1

********************************
FUNCTION CALLUSER(Arg1,Arg2,Arg3)

 LOCAL Local1,Local2,Local3,Local4
 IF Arg3 <> 0
 Local1:=4
 ELSEIF !Static12 .AND. EMPTYFILE()
 Local1:=3
 ELSEIF Arg1:HITBOTTOM()
 Local1:=2
 ELSEIF Arg1:HITTOP()
 Local1:=1
 ELSE
 Local1:=0
 ENDIF
 DO WHILE !Arg1:STABILIZE()
 ENDDO
 Local3:=RECNO()
 IF VALTYPE(Arg2) <> "C" .OR. EMPTY(Arg2)
 IF Arg3 == 13 .OR. Arg3 == 27
 Local2:=0
 ELSE
 Local2:=1
 ENDIF
 ELSE
 Local2:=&Arg2(Local1,Arg1:COLPOS())
 ENDIF
 Local4:=Local2 <> 0
 IF !Static12 .AND. EOF() .AND. !EMPTYFILE()
 SKIP -1
 ENDIF
 IF Local2 == 3
 Static12:=!(Static12 .AND. EOF())
 IF Static12
 GOTO BOTTOM
 Arg1:DOWN()
 ELSE
 Arg1:REFRESHCURRENT()
 ENDIF
 Static13:=.F.
 ELSEIF Local2 == 2 .OR. Local3 <> RECNO()
 IF Local4
 Static12:=.F.
 IF SET(_SET_DELETED) .AND. DELETED() .OR. !EMPTY(DBFILTER()) .AND. !&(DBFILTER())
  SKIP 
 ENDIF
 IF EOF()
  GOTO BOTTOM
 ENDIF
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
 ENDIF
 ELSE
 Arg1:REFRESHCURRENT()
 ENDIF
 RETURN Local4

********************************
FUNCTION SKIPPED(Arg1)

 LOCAL Local1
 Local1:=0
 IF LASTREC() <> 0
 IF Arg1 == 0
 IF EOF() .AND. !Static12
  SKIP -1
  Local1:=-1
 ELSE
  SKIP 0
 ENDIF
 ELSEIF Arg1 > 0 .AND. RECNO() <> LASTREC()+1
 DO WHILE Local1 < Arg1
  SKIP 
  IF EOF()
  IF Static12
   Local1++
  ELSE
   SKIP -1
  ENDIF
  EXIT
  ENDIF
  Local1++
 ENDDO
 ELSEIF Arg1 < 0
 DO WHILE Local1 > Arg1
  SKIP -1
  IF BOF()
  EXIT
  ENDIF
  Local1--
 ENDDO
 ENDIF
 ENDIF
 RETURN Local1

FUNCTION EMPTYFILE

 IF LASTREC() == 0
 RETURN .T.
 ENDIF
 IF (EOF() .OR. RECNO() == LASTREC()+1) .AND. BOF()
 RETURN .T.
 ENDIF
 RETURN .F.

********************************