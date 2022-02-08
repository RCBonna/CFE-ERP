@ECHO OFF
REM Gerado pela xDev Studio v0.70 as 04/08/2012 @ 16:55:08
REM Compilador .: Xharbour & BCC + MinGW
REM Destino ....: C:\PRJ\PrjxH\CFE\_xCFE.EXE
REM Perfil .....: Batch file (Relative Paths)

REM **************************************************************************
REM * Setamos abaixo os PATHs necessarios para o correto funcionamento deste *
REM * script. Se voce for executa-lo em  outra CPU, analise as proximas tres *
REM * linhas abaixo para refletirem as corretas configuracoes de sua maquina *
REM **************************************************************************
 SET PATH=C:\xharbour\bin;C:\bcc582\bin;C:\Program Files\Common Files\Microsoft Shared\Windows Live;C:\Program Files (x86)\Common Files\Microsoft Shared\Windows Live;C:\windows\system32;C:\windows;C:\windows\System32\Wbem;C:\windows\System32\WindowsPowerShell\v1.0\;C:\Program Files\Broadcom\Broadcom 802.11 Network Adapter\Driver;C:\Program Files (x86)\Windows Live\Shared;C:\Program Files\WIDCOMM\Bluetooth Software\;C:\Program Files\WIDCOMM\Bluetooth Software\syswow64;C:\Program Files (x86)\Microsoft SQL Server\100\Tools\Binn\;C:\Program Files\Microsoft SQL Server\100\Tools\Binn\;C:\Program Files\Microsoft SQL Server\100\DTS\Binn\;C:\xharbour\bin;C:\bcc582\bin
 SET INCLUDE=C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include
 SET LIB=C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib
 SET OBJ=C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib

REM - Harbour.xCompiler.prg(97) @ 16:55:08:528
ECHO .ÿ
ECHO * (001/765) Compilando cfe.prg
 harbour.exe ".\cfe.prg" /q /o".\cfe.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:09:448
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfe.obj" >> "b32.bc"
 echo ".\cfe.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:09:448
ECHO .ÿ
ECHO * (002/765) Compilando cfe.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:10:540
ECHO .ÿ
ECHO * (003/765) Compilando cfep0000.prg
 harbour.exe ".\cfep0000.prg" /q /o".\cfep0000.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:10:790
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep0000.obj" >> "b32.bc"
 echo ".\cfep0000.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:10:790
ECHO .ÿ
ECHO * (004/765) Compilando cfep0000.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:11:165
ECHO .ÿ
ECHO * (005/765) Compilando cfep0001.prg
 harbour.exe ".\cfep0001.prg" /q /o".\cfep0001.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:11:399
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep0001.obj" >> "b32.bc"
 echo ".\cfep0001.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:11:399
ECHO .ÿ
ECHO * (006/765) Compilando cfep0001.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:11:679
ECHO .ÿ
ECHO * (007/765) Compilando cfep0002.prg
 harbour.exe ".\cfep0002.prg" /q /o".\cfep0002.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:11:913
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep0002.obj" >> "b32.bc"
 echo ".\cfep0002.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:11:913
ECHO .ÿ
ECHO * (008/765) Compilando cfep0002.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:12:194
ECHO .ÿ
ECHO * (009/765) Compilando cfep43co.prg
 harbour.exe ".\cfep43co.prg" /q /o".\cfep43co.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:12:428
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep43co.obj" >> "b32.bc"
 echo ".\cfep43co.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:12:428
ECHO .ÿ
ECHO * (010/765) Compilando cfep43co.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:12:725
ECHO .ÿ
ECHO * (011/765) Compilando cfep44c0.prg
 harbour.exe ".\cfep44c0.prg" /q /o".\cfep44c0.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:12:959
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep44c0.obj" >> "b32.bc"
 echo ".\cfep44c0.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:12:959
ECHO .ÿ
ECHO * (012/765) Compilando cfep44c0.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:13:255
ECHO .ÿ
ECHO * (013/765) Compilando cfep310t.prg
 harbour.exe ".\cfep310t.prg" /q /o".\cfep310t.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:13:520
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep310t.obj" >> "b32.bc"
 echo ".\cfep310t.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:13:520
ECHO .ÿ
ECHO * (014/765) Compilando cfep310t.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:13:817
ECHO .ÿ
ECHO * (015/765) Compilando cfep310x.prg
 harbour.exe ".\cfep310x.prg" /q /o".\cfep310x.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:14:035
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep310x.obj" >> "b32.bc"
 echo ".\cfep310x.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:14:035
ECHO .ÿ
ECHO * (016/765) Compilando cfep310x.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:14:316
ECHO .ÿ
ECHO * (017/765) Compilando cfep441e.prg
 harbour.exe ".\cfep441e.prg" /q /o".\cfep441e.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:14:597
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep441e.obj" >> "b32.bc"
 echo ".\cfep441e.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:14:597
ECHO .ÿ
ECHO * (018/765) Compilando cfep441e.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:14:877
ECHO .ÿ
ECHO * (019/765) Compilando cfep441g.prg
 harbour.exe ".\cfep441g.prg" /q /o".\cfep441g.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:15:158
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep441g.obj" >> "b32.bc"
 echo ".\cfep441g.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:15:158
ECHO .ÿ
ECHO * (020/765) Compilando cfep441g.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:15:455
ECHO .ÿ
ECHO * (021/765) Compilando cfep441i.prg
 harbour.exe ".\cfep441i.prg" /q /o".\cfep441i.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:15:689
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep441i.obj" >> "b32.bc"
 echo ".\cfep441i.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:15:689
ECHO .ÿ
ECHO * (022/765) Compilando cfep441i.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:15:985
ECHO .ÿ
ECHO * (023/765) Compilando cfep441p.prg
 harbour.exe ".\cfep441p.prg" /q /o".\cfep441p.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:16:281
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep441p.obj" >> "b32.bc"
 echo ".\cfep441p.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:16:281
ECHO .ÿ
ECHO * (024/765) Compilando cfep441p.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:16:578
ECHO .ÿ
ECHO * (025/765) Compilando cfep441x.prg
 harbour.exe ".\cfep441x.prg" /q /o".\cfep441x.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:16:827
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep441x.obj" >> "b32.bc"
 echo ".\cfep441x.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:16:827
ECHO .ÿ
ECHO * (026/765) Compilando cfep441x.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:17:108
ECHO .ÿ
ECHO * (027/765) Compilando cfep510o.prg
 harbour.exe ".\cfep510o.prg" /q /o".\cfep510o.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:17:358
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep510o.obj" >> "b32.bc"
 echo ".\cfep510o.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:17:358
ECHO .ÿ
ECHO * (028/765) Compilando cfep510o.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:17:639
ECHO .ÿ
ECHO * (029/765) Compilando cfep520g.prg
 harbour.exe ".\cfep520g.prg" /q /o".\cfep520g.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:17:904
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep520g.obj" >> "b32.bc"
 echo ".\cfep520g.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:17:904
ECHO .ÿ
ECHO * (030/765) Compilando cfep520g.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:18:185
ECHO .ÿ
ECHO * (031/765) Compilando cfep1410.prg
 harbour.exe ".\cfep1410.prg" /q /o".\cfep1410.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:18:419
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep1410.obj" >> "b32.bc"
 echo ".\cfep1410.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:18:419
ECHO .ÿ
ECHO * (032/765) Compilando cfep1410.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:18:699
ECHO .ÿ
ECHO * (033/765) Compilando cfep1420.prg
 harbour.exe ".\cfep1420.prg" /q /o".\cfep1420.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:18:949
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep1420.obj" >> "b32.bc"
 echo ".\cfep1420.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:18:949
ECHO .ÿ
ECHO * (034/765) Compilando cfep1420.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:19:230
ECHO .ÿ
ECHO * (035/765) Compilando cfep1430.prg
 harbour.exe ".\cfep1430.prg" /q /o".\cfep1430.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:19:464
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep1430.obj" >> "b32.bc"
 echo ".\cfep1430.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:19:464
ECHO .ÿ
ECHO * (036/765) Compilando cfep1430.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:19:745
ECHO .ÿ
ECHO * (037/765) Compilando cfep1440.prg
 harbour.exe ".\cfep1440.prg" /q /o".\cfep1440.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:19:979
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep1440.obj" >> "b32.bc"
 echo ".\cfep1440.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:19:979
ECHO .ÿ
ECHO * (038/765) Compilando cfep1440.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:20:259
ECHO .ÿ
ECHO * (039/765) Compilando cfep1500.prg
 harbour.exe ".\cfep1500.prg" /q /o".\cfep1500.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:20:525
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep1500.obj" >> "b32.bc"
 echo ".\cfep1500.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:20:525
ECHO .ÿ
ECHO * (040/765) Compilando cfep1500.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:20:805
ECHO .ÿ
ECHO * (041/765) Compilando cfep1600.prg
 harbour.exe ".\cfep1600.prg" /q /o".\cfep1600.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:21:039
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep1600.obj" >> "b32.bc"
 echo ".\cfep1600.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:21:055
ECHO .ÿ
ECHO * (042/765) Compilando cfep1600.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:21:336
ECHO .ÿ
ECHO * (043/765) Compilando cfep2100.prg
 harbour.exe ".\cfep2100.prg" /q /o".\cfep2100.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:21:570
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep2100.obj" >> "b32.bc"
 echo ".\cfep2100.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:21:570
ECHO .ÿ
ECHO * (044/765) Compilando cfep2100.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:21:851
ECHO .ÿ
ECHO * (045/765) Compilando cfep2210.prg
 harbour.exe ".\cfep2210.prg" /q /o".\cfep2210.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:22:085
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep2210.obj" >> "b32.bc"
 echo ".\cfep2210.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:22:085
ECHO .ÿ
ECHO * (046/765) Compilando cfep2210.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:22:365
ECHO .ÿ
ECHO * (047/765) Compilando cfep2211.prg
 harbour.exe ".\cfep2211.prg" /q /o".\cfep2211.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:22:646
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep2211.obj" >> "b32.bc"
 echo ".\cfep2211.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:22:646
ECHO .ÿ
ECHO * (048/765) Compilando cfep2211.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:22:927
ECHO .ÿ
ECHO * (049/765) Compilando cfep2220.prg
 harbour.exe ".\cfep2220.prg" /q /o".\cfep2220.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:23:192
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep2220.obj" >> "b32.bc"
 echo ".\cfep2220.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:23:192
ECHO .ÿ
ECHO * (050/765) Compilando cfep2220.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:23:473
ECHO .ÿ
ECHO * (051/765) Compilando cfep2311.prg
 harbour.exe ".\cfep2311.prg" /q /o".\cfep2311.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:23:723
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep2311.obj" >> "b32.bc"
 echo ".\cfep2311.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:23:723
ECHO .ÿ
ECHO * (052/765) Compilando cfep2311.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:24:019
ECHO .ÿ
ECHO * (053/765) Compilando cfep2312.prg
 harbour.exe ".\cfep2312.prg" /q /o".\cfep2312.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:24:269
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep2312.obj" >> "b32.bc"
 echo ".\cfep2312.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:24:269
ECHO .ÿ
ECHO * (054/765) Compilando cfep2312.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:24:565
ECHO .ÿ
ECHO * (055/765) Compilando cfep2313.prg
 harbour.exe ".\cfep2313.prg" /q /o".\cfep2313.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:24:815
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep2313.obj" >> "b32.bc"
 echo ".\cfep2313.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:24:815
ECHO .ÿ
ECHO * (056/765) Compilando cfep2313.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:25:095
ECHO .ÿ
ECHO * (057/765) Compilando cfep2322.prg
 harbour.exe ".\cfep2322.prg" /q /o".\cfep2322.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:25:329
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep2322.obj" >> "b32.bc"
 echo ".\cfep2322.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:25:329
ECHO .ÿ
ECHO * (058/765) Compilando cfep2322.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:25:610
ECHO .ÿ
ECHO * (059/765) Compilando cfep2411.prg
 harbour.exe ".\cfep2411.prg" /q /o".\cfep2411.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:25:860
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep2411.obj" >> "b32.bc"
 echo ".\cfep2411.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:25:860
ECHO .ÿ
ECHO * (060/765) Compilando cfep2411.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:26:141
ECHO .ÿ
ECHO * (061/765) Compilando cfep2500.prg
 harbour.exe ".\cfep2500.prg" /q /o".\cfep2500.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:26:390
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep2500.obj" >> "b32.bc"
 echo ".\cfep2500.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:26:390
ECHO .ÿ
ECHO * (062/765) Compilando cfep2500.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:26:671
ECHO .ÿ
ECHO * (063/765) Compilando cfep3100.prg
 harbour.exe ".\cfep3100.prg" /q /o".\cfep3100.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:26:905
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep3100.obj" >> "b32.bc"
 echo ".\cfep3100.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:26:905
ECHO .ÿ
ECHO * (064/765) Compilando cfep3100.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:27:201
ECHO .ÿ
ECHO * (065/765) Compilando cfep3105.prg
 harbour.exe ".\cfep3105.prg" /q /o".\cfep3105.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:27:498
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep3105.obj" >> "b32.bc"
 echo ".\cfep3105.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:27:498
ECHO .ÿ
ECHO * (066/765) Compilando cfep3105.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:27:779
ECHO .ÿ
ECHO * (067/765) Compilando cfep3210.prg
 harbour.exe ".\cfep3210.prg" /q /o".\cfep3210.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:28:013
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep3210.obj" >> "b32.bc"
 echo ".\cfep3210.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:28:013
ECHO .ÿ
ECHO * (068/765) Compilando cfep3210.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:28:293
ECHO .ÿ
ECHO * (069/765) Compilando cfep4100.prg
 harbour.exe ".\cfep4100.prg" /q /o".\cfep4100.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:28:543
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4100.obj" >> "b32.bc"
 echo ".\cfep4100.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:28:543
ECHO .ÿ
ECHO * (070/765) Compilando cfep4100.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:28:824
ECHO .ÿ
ECHO * (071/765) Compilando cfep4200.prg
 harbour.exe ".\cfep4200.prg" /q /o".\cfep4200.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:29:089
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4200.obj" >> "b32.bc"
 echo ".\cfep4200.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:29:089
ECHO .ÿ
ECHO * (072/765) Compilando cfep4200.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:29:401
ECHO .ÿ
ECHO * (073/765) Compilando cfep4206.prg
 harbour.exe ".\cfep4206.prg" /q /o".\cfep4206.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:29:666
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4206.obj" >> "b32.bc"
 echo ".\cfep4206.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:29:666
ECHO .ÿ
ECHO * (074/765) Compilando cfep4206.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:29:947
ECHO .ÿ
ECHO * (075/765) Compilando cfep4311.prg
 harbour.exe ".\cfep4311.prg" /q /o".\cfep4311.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:30:181
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4311.obj" >> "b32.bc"
 echo ".\cfep4311.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:30:197
ECHO .ÿ
ECHO * (076/765) Compilando cfep4311.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:30:477
ECHO .ÿ
ECHO * (077/765) Compilando cfep4312.prg
 harbour.exe ".\cfep4312.prg" /q /o".\cfep4312.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:30:711
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4312.obj" >> "b32.bc"
 echo ".\cfep4312.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:30:711
ECHO .ÿ
ECHO * (078/765) Compilando cfep4312.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:31:008
ECHO .ÿ
ECHO * (079/765) Compilando cfep4313.prg
 harbour.exe ".\cfep4313.prg" /q /o".\cfep4313.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:31:257
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4313.obj" >> "b32.bc"
 echo ".\cfep4313.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:31:257
ECHO .ÿ
ECHO * (080/765) Compilando cfep4313.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:31:538
ECHO .ÿ
ECHO * (081/765) Compilando cfep4314.prg
 harbour.exe ".\cfep4314.prg" /q /o".\cfep4314.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:31:772
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4314.obj" >> "b32.bc"
 echo ".\cfep4314.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:31:772
ECHO .ÿ
ECHO * (082/765) Compilando cfep4314.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:32:053
ECHO .ÿ
ECHO * (083/765) Compilando cfep4321.prg
 harbour.exe ".\cfep4321.prg" /q /o".\cfep4321.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:32:303
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4321.obj" >> "b32.bc"
 echo ".\cfep4321.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:32:303
ECHO .ÿ
ECHO * (084/765) Compilando cfep4321.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:32:599
ECHO .ÿ
ECHO * (085/765) Compilando cfep4331.prg
 harbour.exe ".\cfep4331.prg" /q /o".\cfep4331.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:32:849
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4331.obj" >> "b32.bc"
 echo ".\cfep4331.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:32:849
ECHO .ÿ
ECHO * (086/765) Compilando cfep4331.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:33:145
ECHO .ÿ
ECHO * (087/765) Compilando cfep4340.prg
 harbour.exe ".\cfep4340.prg" /q /o".\cfep4340.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:33:395
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4340.obj" >> "b32.bc"
 echo ".\cfep4340.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:33:395
ECHO .ÿ
ECHO * (088/765) Compilando cfep4340.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:33:675
ECHO .ÿ
ECHO * (089/765) Compilando cfep4341.prg
 harbour.exe ".\cfep4341.prg" /q /o".\cfep4341.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:33:909
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4341.obj" >> "b32.bc"
 echo ".\cfep4341.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:33:909
ECHO .ÿ
ECHO * (090/765) Compilando cfep4341.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:34:190
ECHO .ÿ
ECHO * (091/765) Compilando cfep4342.prg
 harbour.exe ".\cfep4342.prg" /q /o".\cfep4342.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:34:440
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4342.obj" >> "b32.bc"
 echo ".\cfep4342.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:34:440
ECHO .ÿ
ECHO * (092/765) Compilando cfep4342.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:34:736
ECHO .ÿ
ECHO * (093/765) Compilando cfep4350.prg
 harbour.exe ".\cfep4350.prg" /q /o".\cfep4350.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:34:970
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4350.obj" >> "b32.bc"
 echo ".\cfep4350.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:34:970
ECHO .ÿ
ECHO * (094/765) Compilando cfep4350.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:35:267
ECHO .ÿ
ECHO * (095/765) Compilando cfep4361.prg
 harbour.exe ".\cfep4361.prg" /q /o".\cfep4361.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:35:532
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4361.obj" >> "b32.bc"
 echo ".\cfep4361.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:35:532
ECHO .ÿ
ECHO * (096/765) Compilando cfep4361.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:35:813
ECHO .ÿ
ECHO * (097/765) Compilando cfep4362.prg
 harbour.exe ".\cfep4362.prg" /q /o".\cfep4362.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:36:047
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4362.obj" >> "b32.bc"
 echo ".\cfep4362.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:36:062
ECHO .ÿ
ECHO * (098/765) Compilando cfep4362.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:36:499
ECHO .ÿ
ECHO * (099/765) Compilando cfep4370.prg
 harbour.exe ".\cfep4370.prg" /q /o".\cfep4370.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:36:733
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4370.obj" >> "b32.bc"
 echo ".\cfep4370.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:36:733
ECHO .ÿ
ECHO * (100/765) Compilando cfep4370.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:37:014
ECHO .ÿ
ECHO * (101/765) Compilando cfep4380.prg
 harbour.exe ".\cfep4380.prg" /q /o".\cfep4380.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:37:249
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4380.obj" >> "b32.bc"
 echo ".\cfep4380.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:37:249
ECHO .ÿ
ECHO * (102/765) Compilando cfep4380.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:37:529
ECHO .ÿ
ECHO * (103/765) Compilando cfep4390.prg
 harbour.exe ".\cfep4390.prg" /q /o".\cfep4390.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:37:759
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4390.obj" >> "b32.bc"
 echo ".\cfep4390.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:37:759
ECHO .ÿ
ECHO * (104/765) Compilando cfep4390.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:38:049
ECHO .ÿ
ECHO * (105/765) Compilando cfep4410.prg
 harbour.exe ".\cfep4410.prg" /q /o".\cfep4410.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:38:339
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4410.obj" >> "b32.bc"
 echo ".\cfep4410.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:38:339
ECHO .ÿ
ECHO * (106/765) Compilando cfep4410.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:38:619
ECHO .ÿ
ECHO * (107/765) Compilando cfep4413.prg
 harbour.exe ".\cfep4413.prg" /q /o".\cfep4413.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:38:859
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4413.obj" >> "b32.bc"
 echo ".\cfep4413.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:38:859
ECHO .ÿ
ECHO * (108/765) Compilando cfep4413.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:39:139
ECHO .ÿ
ECHO * (109/765) Compilando cfep4414.prg
 harbour.exe ".\cfep4414.prg" /q /o".\cfep4414.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:39:370
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4414.obj" >> "b32.bc"
 echo ".\cfep4414.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:39:370
ECHO .ÿ
ECHO * (110/765) Compilando cfep4414.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:39:667
ECHO .ÿ
ECHO * (111/765) Compilando cfep4415.prg
 harbour.exe ".\cfep4415.prg" /q /o".\cfep4415.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:39:932
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4415.obj" >> "b32.bc"
 echo ".\cfep4415.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:39:932
ECHO .ÿ
ECHO * (112/765) Compilando cfep4415.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:40:213
ECHO .ÿ
ECHO * (113/765) Compilando cfep4420.prg
 harbour.exe ".\cfep4420.prg" /q /o".\cfep4420.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:40:462
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4420.obj" >> "b32.bc"
 echo ".\cfep4420.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:40:462
ECHO .ÿ
ECHO * (114/765) Compilando cfep4420.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:40:743
ECHO .ÿ
ECHO * (115/765) Compilando cfep4430.prg
 harbour.exe ".\cfep4430.prg" /q /o".\cfep4430.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:40:995
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4430.obj" >> "b32.bc"
 echo ".\cfep4430.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:41:005
ECHO .ÿ
ECHO * (116/765) Compilando cfep4430.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:41:295
ECHO .ÿ
ECHO * (117/765) Compilando cfep4440.prg
 harbour.exe ".\cfep4440.prg" /q /o".\cfep4440.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:41:535
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4440.obj" >> "b32.bc"
 echo ".\cfep4440.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:41:545
ECHO .ÿ
ECHO * (118/765) Compilando cfep4440.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:41:825
ECHO .ÿ
ECHO * (119/765) Compilando cfep4450.prg
 harbour.exe ".\cfep4450.prg" /q /o".\cfep4450.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:42:085
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4450.obj" >> "b32.bc"
 echo ".\cfep4450.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:42:085
ECHO .ÿ
ECHO * (120/765) Compilando cfep4450.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:42:405
ECHO .ÿ
ECHO * (121/765) Compilando cfep4460.prg
 harbour.exe ".\cfep4460.prg" /q /o".\cfep4460.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:42:665
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4460.obj" >> "b32.bc"
 echo ".\cfep4460.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:42:665
ECHO .ÿ
ECHO * (122/765) Compilando cfep4460.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:42:943
ECHO .ÿ
ECHO * (123/765) Compilando cfep4500.prg
 harbour.exe ".\cfep4500.prg" /q /o".\cfep4500.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:43:177
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4500.obj" >> "b32.bc"
 echo ".\cfep4500.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:43:177
ECHO .ÿ
ECHO * (124/765) Compilando cfep4500.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:43:458
ECHO .ÿ
ECHO * (125/765) Compilando cfep4510.prg
 harbour.exe ".\cfep4510.prg" /q /o".\cfep4510.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:43:692
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4510.obj" >> "b32.bc"
 echo ".\cfep4510.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:43:692
ECHO .ÿ
ECHO * (126/765) Compilando cfep4510.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:43:973
ECHO .ÿ
ECHO * (127/765) Compilando cfep4520.prg
 harbour.exe ".\cfep4520.prg" /q /o".\cfep4520.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:44:207
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4520.obj" >> "b32.bc"
 echo ".\cfep4520.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:44:207
ECHO .ÿ
ECHO * (128/765) Compilando cfep4520.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:44:488
ECHO .ÿ
ECHO * (129/765) Compilando cfep4530.prg
 harbour.exe ".\cfep4530.prg" /q /o".\cfep4530.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:44:722
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep4530.obj" >> "b32.bc"
 echo ".\cfep4530.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:44:722
ECHO .ÿ
ECHO * (130/765) Compilando cfep4530.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:45:003
ECHO .ÿ
ECHO * (131/765) Compilando cfep5100.prg
 harbour.exe ".\cfep5100.prg" /q /o".\cfep5100.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:45:299
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5100.obj" >> "b32.bc"
 echo ".\cfep5100.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:45:299
ECHO .ÿ
ECHO * (132/765) Compilando cfep5100.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:45:595
ECHO .ÿ
ECHO * (133/765) Compilando cfep5102.prg
 harbour.exe ".\cfep5102.prg" /q /o".\cfep5102.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:45:829
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5102.obj" >> "b32.bc"
 echo ".\cfep5102.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:45:829
ECHO .ÿ
ECHO * (134/765) Compilando cfep5102.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:46:110
ECHO .ÿ
ECHO * (135/765) Compilando cfep5103.prg
 harbour.exe ".\cfep5103.prg" /q /o".\cfep5103.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:46:344
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5103.obj" >> "b32.bc"
 echo ".\cfep5103.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:46:344
ECHO .ÿ
ECHO * (136/765) Compilando cfep5103.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:46:641
ECHO .ÿ
ECHO * (137/765) Compilando cfep5104.prg
 harbour.exe ".\cfep5104.prg" /q /o".\cfep5104.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:46:890
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5104.obj" >> "b32.bc"
 echo ".\cfep5104.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:46:890
ECHO .ÿ
ECHO * (138/765) Compilando cfep5104.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:47:171
ECHO .ÿ
ECHO * (139/765) Compilando cfep5105.prg
 harbour.exe ".\cfep5105.prg" /q /o".\cfep5105.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:47:405
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5105.obj" >> "b32.bc"
 echo ".\cfep5105.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:47:405
ECHO .ÿ
ECHO * (140/765) Compilando cfep5105.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:47:686
ECHO .ÿ
ECHO * (141/765) Compilando cfep5110.prg
 harbour.exe ".\cfep5110.prg" /q /o".\cfep5110.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:47:935
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5110.obj" >> "b32.bc"
 echo ".\cfep5110.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:47:935
ECHO .ÿ
ECHO * (142/765) Compilando cfep5110.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:48:216
ECHO .ÿ
ECHO * (143/765) Compilando cfep5200.prg
 harbour.exe ".\cfep5200.prg" /q /o".\cfep5200.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:48:481
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5200.obj" >> "b32.bc"
 echo ".\cfep5200.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:48:481
ECHO .ÿ
ECHO * (144/765) Compilando cfep5200.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:48:778
ECHO .ÿ
ECHO * (145/765) Compilando cfep5204.prg
 harbour.exe ".\cfep5204.prg" /q /o".\cfep5204.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:49:012
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5204.obj" >> "b32.bc"
 echo ".\cfep5204.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:49:012
ECHO .ÿ
ECHO * (146/765) Compilando cfep5204.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:49:293
ECHO .ÿ
ECHO * (147/765) Compilando cfep5205.prg
 harbour.exe ".\cfep5205.prg" /q /o".\cfep5205.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:49:542
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5205.obj" >> "b32.bc"
 echo ".\cfep5205.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:49:542
ECHO .ÿ
ECHO * (148/765) Compilando cfep5205.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:49:823
ECHO .ÿ
ECHO * (149/765) Compilando cfep5300.prg
 harbour.exe ".\cfep5300.prg" /q /o".\cfep5300.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:50:073
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5300.obj" >> "b32.bc"
 echo ".\cfep5300.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:50:073
ECHO .ÿ
ECHO * (150/765) Compilando cfep5300.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:50:338
ECHO .ÿ
ECHO * (151/765) Compilando cfep5400.prg
 harbour.exe ".\cfep5400.prg" /q /o".\cfep5400.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:50:556
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5400.obj" >> "b32.bc"
 echo ".\cfep5400.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:50:556
ECHO .ÿ
ECHO * (152/765) Compilando cfep5400.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:50:837
ECHO .ÿ
ECHO * (153/765) Compilando cfep5500.prg
 harbour.exe ".\cfep5500.prg" /q /o".\cfep5500.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:51:071
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5500.obj" >> "b32.bc"
 echo ".\cfep5500.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:51:071
ECHO .ÿ
ECHO * (154/765) Compilando cfep5500.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:51:352
ECHO .ÿ
ECHO * (155/765) Compilando cfep5600.prg
 harbour.exe ".\cfep5600.prg" /q /o".\cfep5600.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:51:555
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5600.obj" >> "b32.bc"
 echo ".\cfep5600.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:51:555
ECHO .ÿ
ECHO * (156/765) Compilando cfep5600.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:51:835
ECHO .ÿ
ECHO * (157/765) Compilando cfep5610.prg
 harbour.exe ".\cfep5610.prg" /q /o".\cfep5610.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:52:085
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5610.obj" >> "b32.bc"
 echo ".\cfep5610.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:52:085
ECHO .ÿ
ECHO * (158/765) Compilando cfep5610.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:52:381
ECHO .ÿ
ECHO * (159/765) Compilando cfep5620.prg
 harbour.exe ".\cfep5620.prg" /q /o".\cfep5620.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:52:615
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5620.obj" >> "b32.bc"
 echo ".\cfep5620.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:52:615
ECHO .ÿ
ECHO * (160/765) Compilando cfep5620.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:52:896
ECHO .ÿ
ECHO * (161/765) Compilando cfep5630.prg
 harbour.exe ".\cfep5630.prg" /q /o".\cfep5630.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:53:146
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5630.obj" >> "b32.bc"
 echo ".\cfep5630.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:53:146
ECHO .ÿ
ECHO * (162/765) Compilando cfep5630.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:53:442
ECHO .ÿ
ECHO * (163/765) Compilando cfep5640.prg
 harbour.exe ".\cfep5640.prg" /q /o".\cfep5640.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:53:676
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5640.obj" >> "b32.bc"
 echo ".\cfep5640.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:53:676
ECHO .ÿ
ECHO * (164/765) Compilando cfep5640.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:53:973
ECHO .ÿ
ECHO * (165/765) Compilando cfep5700.prg
 harbour.exe ".\cfep5700.prg" /q /o".\cfep5700.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:54:160
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep5700.obj" >> "b32.bc"
 echo ".\cfep5700.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:54:160
ECHO .ÿ
ECHO * (166/765) Compilando cfep5700.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:54:441
ECHO .ÿ
ECHO * (167/765) Compilando cfep6100.prg
 harbour.exe ".\cfep6100.prg" /q /o".\cfep6100.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:54:690
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep6100.obj" >> "b32.bc"
 echo ".\cfep6100.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:54:690
ECHO .ÿ
ECHO * (168/765) Compilando cfep6100.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:54:971
ECHO .ÿ
ECHO * (169/765) Compilando cfep6300.prg
 harbour.exe ".\cfep6300.prg" /q /o".\cfep6300.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:55:205
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep6300.obj" >> "b32.bc"
 echo ".\cfep6300.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:55:205
ECHO .ÿ
ECHO * (170/765) Compilando cfep6300.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:55:486
ECHO .ÿ
ECHO * (171/765) Compilando cfep6400.prg
 harbour.exe ".\cfep6400.prg" /q /o".\cfep6400.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:55:720
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep6400.obj" >> "b32.bc"
 echo ".\cfep6400.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:55:720
ECHO .ÿ
ECHO * (172/765) Compilando cfep6400.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:56:001
ECHO .ÿ
ECHO * (173/765) Compilando cfep6500.prg
 harbour.exe ".\cfep6500.prg" /q /o".\cfep6500.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:56:235
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep6500.obj" >> "b32.bc"
 echo ".\cfep6500.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:56:235
ECHO .ÿ
ECHO * (174/765) Compilando cfep6500.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:56:515
ECHO .ÿ
ECHO * (175/765) Compilando cfep7100.prg
 harbour.exe ".\cfep7100.prg" /q /o".\cfep7100.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:56:765
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep7100.obj" >> "b32.bc"
 echo ".\cfep7100.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:56:765
ECHO .ÿ
ECHO * (176/765) Compilando cfep7100.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:57:046
ECHO .ÿ
ECHO * (177/765) Compilando cfep7210.prg
 harbour.exe ".\cfep7210.prg" /q /o".\cfep7210.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:57:295
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep7210.obj" >> "b32.bc"
 echo ".\cfep7210.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:57:295
ECHO .ÿ
ECHO * (178/765) Compilando cfep7210.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:57:576
ECHO .ÿ
ECHO * (179/765) Compilando cfep7220.prg
 harbour.exe ".\cfep7220.prg" /q /o".\cfep7220.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:57:826
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep7220.obj" >> "b32.bc"
 echo ".\cfep7220.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:57:826
ECHO .ÿ
ECHO * (180/765) Compilando cfep7220.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:58:122
ECHO .ÿ
ECHO * (181/765) Compilando cfep7230.prg
 harbour.exe ".\cfep7230.prg" /q /o".\cfep7230.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:58:356
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep7230.obj" >> "b32.bc"
 echo ".\cfep7230.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:58:356
ECHO .ÿ
ECHO * (182/765) Compilando cfep7230.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:58:653
ECHO .ÿ
ECHO * (183/765) Compilando cfep7240.prg
 harbour.exe ".\cfep7240.prg" /q /o".\cfep7240.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:58:887
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep7240.obj" >> "b32.bc"
 echo ".\cfep7240.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:58:887
ECHO .ÿ
ECHO * (184/765) Compilando cfep7240.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:59:167
ECHO .ÿ
ECHO * (185/765) Compilando cfep7300.prg
 harbour.exe ".\cfep7300.prg" /q /o".\cfep7300.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:59:401
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep7300.obj" >> "b32.bc"
 echo ".\cfep7300.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:59:401
ECHO .ÿ
ECHO * (186/765) Compilando cfep7300.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:55:59:682
ECHO .ÿ
ECHO * (187/765) Compilando cfep7500.prg
 harbour.exe ".\cfep7500.prg" /q /o".\cfep7500.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:55:59:885
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep7500.obj" >> "b32.bc"
 echo ".\cfep7500.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:55:59:901
ECHO .ÿ
ECHO * (188/765) Compilando cfep7500.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:00:181
ECHO .ÿ
ECHO * (189/765) Compilando cfep7600.prg
 harbour.exe ".\cfep7600.prg" /q /o".\cfep7600.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:00:384
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfep7600.obj" >> "b32.bc"
 echo ".\cfep7600.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:00:384
ECHO .ÿ
ECHO * (190/765) Compilando cfep7600.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:00:665
ECHO .ÿ
ECHO * (191/765) Compilando cfepabre.prg
 harbour.exe ".\cfepabre.prg" /q /o".\cfepabre.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:00:868
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepabre.obj" >> "b32.bc"
 echo ".\cfepabre.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:00:868
ECHO .ÿ
ECHO * (192/765) Compilando cfepabre.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:01:164
ECHO .ÿ
ECHO * (193/765) Compilando cfepatnf.prg
 harbour.exe ".\cfepatnf.prg" /q /o".\cfepatnf.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:01:398
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepatnf.obj" >> "b32.bc"
 echo ".\cfepatnf.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:01:398
ECHO .ÿ
ECHO * (194/765) Compilando cfepatnf.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:01:695
ECHO .ÿ
ECHO * (195/765) Compilando cfepcart.prg
 harbour.exe ".\cfepcart.prg" /q /o".\cfepcart.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:01:929
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcart.obj" >> "b32.bc"
 echo ".\cfepcart.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:01:929
ECHO .ÿ
ECHO * (196/765) Compilando cfepcart.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:02:225
ECHO .ÿ
ECHO * (197/765) Compilando cfepcccf.prg
 harbour.exe ".\cfepcccf.prg" /q /o".\cfepcccf.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:02:475
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcccf.obj" >> "b32.bc"
 echo ".\cfepcccf.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:02:475
ECHO .ÿ
ECHO * (198/765) Compilando cfepcccf.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:02:771
ECHO .ÿ
ECHO * (199/765) Compilando cfepcccs.prg
 harbour.exe ".\cfepcccs.prg" /q /o".\cfepcccs.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:03:021
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcccs.obj" >> "b32.bc"
 echo ".\cfepcccs.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:03:021
ECHO .ÿ
ECHO * (200/765) Compilando cfepcccs.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:03:301
ECHO .ÿ
ECHO * (201/765) Compilando cfepcctb.prg
 harbour.exe ".\cfepcctb.prg" /q /o".\cfepcctb.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:03:567
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcctb.obj" >> "b32.bc"
 echo ".\cfepcctb.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:03:567
ECHO .ÿ
ECHO * (202/765) Compilando cfepcctb.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:03:863
ECHO .ÿ
ECHO * (203/765) Compilando cfepcdtr.prg
 harbour.exe ".\cfepcdtr.prg" /q /o".\cfepcdtr.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:04:113
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcdtr.obj" >> "b32.bc"
 echo ".\cfepcdtr.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:04:113
ECHO .ÿ
ECHO * (204/765) Compilando cfepcdtr.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:04:393
ECHO .ÿ
ECHO * (205/765) Compilando cfepcf00.prg
 harbour.exe ".\cfepcf00.prg" /q /o".\cfepcf00.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:04:612
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcf00.obj" >> "b32.bc"
 echo ".\cfepcf00.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:04:612
ECHO .ÿ
ECHO * (206/765) Compilando cfepcf00.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:04:908
ECHO .ÿ
ECHO * (207/765) Compilando cfepcf01.prg
 harbour.exe ".\cfepcf01.prg" /q /o".\cfepcf01.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:05:158
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcf01.obj" >> "b32.bc"
 echo ".\cfepcf01.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:05:158
ECHO .ÿ
ECHO * (208/765) Compilando cfepcf01.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:05:439
ECHO .ÿ
ECHO * (209/765) Compilando cfepcfaf.prg
 harbour.exe ".\cfepcfaf.prg" /q /o".\cfepcfaf.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:05:673
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcfaf.obj" >> "b32.bc"
 echo ".\cfepcfaf.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:05:673
ECHO .ÿ
ECHO * (210/765) Compilando cfepcfaf.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:05:969
ECHO .ÿ
ECHO * (211/765) Compilando cfepcfcc.prg
 harbour.exe ".\cfepcfcc.prg" /q /o".\cfepcfcc.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:06:187
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcfcc.obj" >> "b32.bc"
 echo ".\cfepcfcc.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:06:187
ECHO .ÿ
ECHO * (212/765) Compilando cfepcfcc.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:06:484
ECHO .ÿ
ECHO * (213/765) Compilando cfepcfhv.prg
 harbour.exe ".\cfepcfhv.prg" /q /o".\cfepcfhv.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:06:702
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcfhv.obj" >> "b32.bc"
 echo ".\cfepcfhv.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:06:702
ECHO .ÿ
ECHO * (214/765) Compilando cfepcfhv.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:06:999
ECHO .ÿ
ECHO * (215/765) Compilando cfepcfim.prg
 harbour.exe ".\cfepcfim.prg" /q /o".\cfepcfim.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:07:233
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcfim.obj" >> "b32.bc"
 echo ".\cfepcfim.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:07:233
ECHO .ÿ
ECHO * (216/765) Compilando cfepcfim.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:07:498
ECHO .ÿ
ECHO * (217/765) Compilando cfepcflf.prg
 harbour.exe ".\cfepcflf.prg" /q /o".\cfepcflf.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:07:732
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcflf.obj" >> "b32.bc"
 echo ".\cfepcflf.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:07:732
ECHO .ÿ
ECHO * (218/765) Compilando cfepcflf.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:08:013
ECHO .ÿ
ECHO * (219/765) Compilando cfepcflx.prg
 harbour.exe ".\cfepcflx.prg" /q /o".\cfepcflx.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:08:247
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcflx.obj" >> "b32.bc"
 echo ".\cfepcflx.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:08:247
ECHO .ÿ
ECHO * (220/765) Compilando cfepcflx.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:08:527
ECHO .ÿ
ECHO * (221/765) Compilando cfepcfmm.prg
 harbour.exe ".\cfepcfmm.prg" /q /o".\cfepcfmm.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:08:761
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcfmm.obj" >> "b32.bc"
 echo ".\cfepcfmm.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:08:761
ECHO .ÿ
ECHO * (222/765) Compilando cfepcfmm.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:09:042
ECHO .ÿ
ECHO * (223/765) Compilando cfepcfrz.prg
 harbour.exe ".\cfepcfrz.prg" /q /o".\cfepcfrz.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:09:276
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcfrz.obj" >> "b32.bc"
 echo ".\cfepcfrz.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:09:276
ECHO .ÿ
ECHO * (224/765) Compilando cfepcfrz.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:09:557
ECHO .ÿ
ECHO * (225/765) Compilando cfepcftr.prg
 harbour.exe ".\cfepcftr.prg" /q /o".\cfepcftr.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:09:791
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcftr.obj" >> "b32.bc"
 echo ".\cfepcftr.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:09:791
ECHO .ÿ
ECHO * (226/765) Compilando cfepcftr.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:10:079
ECHO .ÿ
ECHO * (227/765) Compilando cfepclcv.prg
 harbour.exe ".\cfepclcv.prg" /q /o".\cfepclcv.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:10:319
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepclcv.obj" >> "b32.bc"
 echo ".\cfepclcv.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:10:319
ECHO .ÿ
ECHO * (228/765) Compilando cfepclcv.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:10:609
ECHO .ÿ
ECHO * (229/765) Compilando cfepclet.prg
 harbour.exe ".\cfepclet.prg" /q /o".\cfepclet.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:10:849
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepclet.obj" >> "b32.bc"
 echo ".\cfepclet.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:10:849
ECHO .ÿ
ECHO * (230/765) Compilando cfepclet.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:11:129
ECHO .ÿ
ECHO * (231/765) Compilando cfepcodi.prg
 harbour.exe ".\cfepcodi.prg" /q /o".\cfepcodi.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:11:359
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcodi.obj" >> "b32.bc"
 echo ".\cfepcodi.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:11:359
ECHO .ÿ
ECHO * (232/765) Compilando cfepcodi.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:11:629
ECHO .ÿ
ECHO * (233/765) Compilando cfepcomc.prg
 harbour.exe ".\cfepcomc.prg" /q /o".\cfepcomc.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:11:869
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcomc.obj" >> "b32.bc"
 echo ".\cfepcomc.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:11:869
ECHO .ÿ
ECHO * (234/765) Compilando cfepcomc.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:12:153
ECHO .ÿ
ECHO * (235/765) Compilando cfepcons.prg
 harbour.exe ".\cfepcons.prg" /q /o".\cfepcons.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:12:387
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcons.obj" >> "b32.bc"
 echo ".\cfepcons.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:12:387
ECHO .ÿ
ECHO * (236/765) Compilando cfepcons.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:12:683
ECHO .ÿ
ECHO * (237/765) Compilando cfepcp01.prg
 harbour.exe ".\cfepcp01.prg" /q /o".\cfepcp01.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:12:917
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcp01.obj" >> "b32.bc"
 echo ".\cfepcp01.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:12:917
ECHO .ÿ
ECHO * (238/765) Compilando cfepcp01.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:13:198
ECHO .ÿ
ECHO * (239/765) Compilando cfepcria.prg
 harbour.exe ".\cfepcria.prg" /q /o".\cfepcria.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:13:401
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcria.obj" >> "b32.bc"
 echo ".\cfepcria.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:13:401
ECHO .ÿ
ECHO * (240/765) Compilando cfepcria.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:13:697
ECHO .ÿ
ECHO * (241/765) Compilando cfepcsfo.prg
 harbour.exe ".\cfepcsfo.prg" /q /o".\cfepcsfo.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:13:931
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcsfo.obj" >> "b32.bc"
 echo ".\cfepcsfo.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:13:931
ECHO .ÿ
ECHO * (242/765) Compilando cfepcsfo.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:14:212
ECHO .ÿ
ECHO * (243/765) Compilando cfepcspr.prg
 harbour.exe ".\cfepcspr.prg" /q /o".\cfepcspr.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:14:446
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepcspr.obj" >> "b32.bc"
 echo ".\cfepcspr.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:14:446
ECHO .ÿ
ECHO * (244/765) Compilando cfepcspr.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:14:743
ECHO .ÿ
ECHO * (245/765) Compilando cfepdscp.prg
 harbour.exe ".\cfepdscp.prg" /q /o".\cfepdscp.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:14:977
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepdscp.obj" >> "b32.bc"
 echo ".\cfepdscp.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:14:977
ECHO .ÿ
ECHO * (246/765) Compilando cfepdscp.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:15:257
ECHO .ÿ
ECHO * (247/765) Compilando cfepdvcp.prg
 harbour.exe ".\cfepdvcp.prg" /q /o".\cfepdvcp.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:15:523
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepdvcp.obj" >> "b32.bc"
 echo ".\cfepdvcp.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:15:523
ECHO .ÿ
ECHO * (248/765) Compilando cfepdvcp.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:15:803
ECHO .ÿ
ECHO * (249/765) Compilando cfepedar.prg
 harbour.exe ".\cfepedar.prg" /q /o".\cfepedar.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:16:037
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepedar.obj" >> "b32.bc"
 echo ".\cfepedar.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:16:037
ECHO .ÿ
ECHO * (250/765) Compilando cfepedar.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:16:303
ECHO .ÿ
ECHO * (251/765) Compilando cfepedec.prg
 harbour.exe ".\cfepedec.prg" /q /o".\cfepedec.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:16:599
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepedec.obj" >> "b32.bc"
 echo ".\cfepedec.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:16:599
ECHO .ÿ
ECHO * (252/765) Compilando cfepedec.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:16:895
ECHO .ÿ
ECHO * (253/765) Compilando cfepeded.prg
 harbour.exe ".\cfepeded.prg" /q /o".\cfepeded.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:17:145
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepeded.obj" >> "b32.bc"
 echo ".\cfepeded.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:17:145
ECHO .ÿ
ECHO * (254/765) Compilando cfepeded.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:17:426
ECHO .ÿ
ECHO * (255/765) Compilando cfepednf.prg
 harbour.exe ".\cfepednf.prg" /q /o".\cfepednf.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:17:660
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepednf.obj" >> "b32.bc"
 echo ".\cfepednf.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:17:660
ECHO .ÿ
ECHO * (256/765) Compilando cfepednf.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:17:941
ECHO .ÿ
ECHO * (257/765) Compilando cfepedpc.prg
 harbour.exe ".\cfepedpc.prg" /q /o".\cfepedpc.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:18:221
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepedpc.obj" >> "b32.bc"
 echo ".\cfepedpc.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:18:221
ECHO .ÿ
ECHO * (258/765) Compilando cfepedpc.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:18:518
ECHO .ÿ
ECHO * (259/765) Compilando cfepedpd.prg
 harbour.exe ".\cfepedpd.prg" /q /o".\cfepedpd.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:18:814
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepedpd.obj" >> "b32.bc"
 echo ".\cfepedpd.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:18:814
ECHO .ÿ
ECHO * (260/765) Compilando cfepedpd.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:19:095
ECHO .ÿ
ECHO * (261/765) Compilando cfepenge.prg
 harbour.exe ".\cfepenge.prg" /q /o".\cfepenge.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:19:360
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepenge.obj" >> "b32.bc"
 echo ".\cfepenge.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:19:360
ECHO .ÿ
ECHO * (262/765) Compilando cfepenge.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:19:641
ECHO .ÿ
ECHO * (263/765) Compilando cfepengm.prg
 harbour.exe ".\cfepengm.prg" /q /o".\cfepengm.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:19:922
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepengm.obj" >> "b32.bc"
 echo ".\cfepengm.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:19:922
ECHO .ÿ
ECHO * (264/765) Compilando cfepengm.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:20:218
ECHO .ÿ
ECHO * (265/765) Compilando cfepengp.prg
 harbour.exe ".\cfepengp.prg" /q /o".\cfepengp.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:20:437
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepengp.obj" >> "b32.bc"
 echo ".\cfepengp.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:20:437
ECHO .ÿ
ECHO * (266/765) Compilando cfepengp.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:20:717
ECHO .ÿ
ECHO * (267/765) Compilando cfepevcp.prg
 harbour.exe ".\cfepevcp.prg" /q /o".\cfepevcp.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:20:951
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepevcp.obj" >> "b32.bc"
 echo ".\cfepevcp.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:20:951
ECHO .ÿ
ECHO * (268/765) Compilando cfepevcp.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:21:232
ECHO .ÿ
ECHO * (269/765) Compilando cfepexpr.prg
 harbour.exe ".\cfepexpr.prg" /q /o".\cfepexpr.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:21:451
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepexpr.obj" >> "b32.bc"
 echo ".\cfepexpr.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:21:451
ECHO .ÿ
ECHO * (270/765) Compilando cfepexpr.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:21:747
ECHO .ÿ
ECHO * (271/765) Compilando cfepext1.prg
 harbour.exe ".\cfepext1.prg" /q /o".\cfepext1.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:21:997
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepext1.obj" >> "b32.bc"
 echo ".\cfepext1.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:21:997
ECHO .ÿ
ECHO * (272/765) Compilando cfepext1.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:22:277
ECHO .ÿ
ECHO * (273/765) Compilando cfepext2.prg
 harbour.exe ".\cfepext2.prg" /q /o".\cfepext2.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:22:543
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepext2.obj" >> "b32.bc"
 echo ".\cfepext2.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:22:543
ECHO .ÿ
ECHO * (274/765) Compilando cfepext2.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:22:823
ECHO .ÿ
ECHO * (275/765) Compilando cfepextr.prg
 harbour.exe ".\cfepextr.prg" /q /o".\cfepextr.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:23:089
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepextr.obj" >> "b32.bc"
 echo ".\cfepextr.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:23:089
ECHO .ÿ
ECHO * (276/765) Compilando cfepextr.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:23:369
ECHO .ÿ
ECHO * (277/765) Compilando cfepfar0.prg
 harbour.exe ".\cfepfar0.prg" /q /o".\cfepfar0.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:23:619
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepfar0.obj" >> "b32.bc"
 echo ".\cfepfar0.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:23:619
ECHO .ÿ
ECHO * (278/765) Compilando cfepfar0.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:23:900
ECHO .ÿ
ECHO * (279/765) Compilando cfepfar2.prg
 harbour.exe ".\cfepfar2.prg" /q /o".\cfepfar2.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:24:134
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepfar2.obj" >> "b32.bc"
 echo ".\cfepfar2.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:24:134
ECHO .ÿ
ECHO * (280/765) Compilando cfepfar2.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:24:415
ECHO .ÿ
ECHO * (281/765) Compilando cfepfar3.prg
 harbour.exe ".\cfepfar3.prg" /q /o".\cfepfar3.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:24:649
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepfar3.obj" >> "b32.bc"
 echo ".\cfepfar3.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:24:649
ECHO .ÿ
ECHO * (282/765) Compilando cfepfar3.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:24:945
ECHO .ÿ
ECHO * (283/765) Compilando cfepfar4.prg
 harbour.exe ".\cfepfar4.prg" /q /o".\cfepfar4.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:25:179
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepfar4.obj" >> "b32.bc"
 echo ".\cfepfar4.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:25:179
ECHO .ÿ
ECHO * (284/765) Compilando cfepfar4.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:25:460
ECHO .ÿ
ECHO * (285/765) Compilando cfepflux.prg
 harbour.exe ".\cfepflux.prg" /q /o".\cfepflux.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:25:709
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepflux.obj" >> "b32.bc"
 echo ".\cfepflux.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:25:709
ECHO .ÿ
ECHO * (286/765) Compilando cfepflux.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:26:006
ECHO .ÿ
ECHO * (287/765) Compilando cfepfun1.prg
 harbour.exe ".\cfepfun1.prg" /q /o".\cfepfun1.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:26:255
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepfun1.obj" >> "b32.bc"
 echo ".\cfepfun1.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:26:255
ECHO .ÿ
ECHO * (288/765) Compilando cfepfun1.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:26:552
ECHO .ÿ
ECHO * (289/765) Compilando cfepfunc.prg
 harbour.exe ".\cfepfunc.prg" /q /o".\cfepfunc.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:26:801
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepfunc.obj" >> "b32.bc"
 echo ".\cfepfunc.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:26:801
ECHO .ÿ
ECHO * (290/765) Compilando cfepfunc.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:27:082
ECHO .ÿ
ECHO * (291/765) Compilando cfepiecp.prg
 harbour.exe ".\cfepiecp.prg" /q /o".\cfepiecp.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:27:316
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepiecp.obj" >> "b32.bc"
 echo ".\cfepiecp.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:27:316
ECHO .ÿ
ECHO * (292/765) Compilando cfepiecp.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:27:613
ECHO .ÿ
ECHO * (293/765) Compilando cfepimnf.prg
 harbour.exe ".\cfepimnf.prg" /q /o".\cfepimnf.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:27:831
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepimnf.obj" >> "b32.bc"
 echo ".\cfepimnf.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:27:831
ECHO .ÿ
ECHO * (294/765) Compilando cfepimnf.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:28:127
ECHO .ÿ
ECHO * (295/765) Compilando cfepind1.prg
 harbour.exe ".\cfepind1.prg" /q /o".\cfepind1.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:28:361
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepind1.obj" >> "b32.bc"
 echo ".\cfepind1.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:28:361
ECHO .ÿ
ECHO * (296/765) Compilando cfepind1.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:28:642
ECHO .ÿ
ECHO * (297/765) Compilando cfepind2.prg
 harbour.exe ".\cfepind2.prg" /q /o".\cfepind2.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:28:907
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepind2.obj" >> "b32.bc"
 echo ".\cfepind2.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:28:907
ECHO .ÿ
ECHO * (298/765) Compilando cfepind2.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:29:188
ECHO .ÿ
ECHO * (299/765) Compilando cfepindi.prg
 harbour.exe ".\cfepindi.prg" /q /o".\cfepindi.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:29:438
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepindi.obj" >> "b32.bc"
 echo ".\cfepindi.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:29:438
ECHO .ÿ
ECHO * (300/765) Compilando cfepindi.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:29:719
ECHO .ÿ
ECHO * (301/765) Compilando cfepinit.prg
 harbour.exe ".\cfepinit.prg" /q /o".\cfepinit.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:29:953
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepinit.obj" >> "b32.bc"
 echo ".\cfepinit.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:29:953
ECHO .ÿ
ECHO * (302/765) Compilando cfepinit.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:30:249
ECHO .ÿ
ECHO * (303/765) Compilando cfepl1cp.prg
 harbour.exe ".\cfepl1cp.prg" /q /o".\cfepl1cp.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:30:483
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepl1cp.obj" >> "b32.bc"
 echo ".\cfepl1cp.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:30:483
ECHO .ÿ
ECHO * (304/765) Compilando cfepl1cp.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:30:779
ECHO .ÿ
ECHO * (305/765) Compilando cfeplien.prg
 harbour.exe ".\cfeplien.prg" /q /o".\cfeplien.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:31:029
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeplien.obj" >> "b32.bc"
 echo ".\cfeplien.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:31:029
ECHO .ÿ
ECHO * (306/765) Compilando cfeplien.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:31:310
ECHO .ÿ
ECHO * (307/765) Compilando cfeplipi.prg
 harbour.exe ".\cfeplipi.prg" /q /o".\cfeplipi.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:31:575
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeplipi.obj" >> "b32.bc"
 echo ".\cfeplipi.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:31:575
ECHO .ÿ
ECHO * (308/765) Compilando cfeplipi.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:31:871
ECHO .ÿ
ECHO * (309/765) Compilando cfeplird.prg
 harbour.exe ".\cfeplird.prg" /q /o".\cfeplird.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:32:105
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeplird.obj" >> "b32.bc"
 echo ".\cfeplird.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:32:121
ECHO .ÿ
ECHO * (310/765) Compilando cfeplird.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:32:402
ECHO .ÿ
ECHO * (311/765) Compilando cfeplisa.prg
 harbour.exe ".\cfeplisa.prg" /q /o".\cfeplisa.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:32:651
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeplisa.obj" >> "b32.bc"
 echo ".\cfeplisa.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:32:651
ECHO .ÿ
ECHO * (312/765) Compilando cfeplisa.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:32:948
ECHO .ÿ
ECHO * (313/765) Compilando cfepmeli.prg
 harbour.exe ".\cfepmeli.prg" /q /o".\cfepmeli.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:33:182
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepmeli.obj" >> "b32.bc"
 echo ".\cfepmeli.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:33:182
ECHO .ÿ
ECHO * (314/765) Compilando cfepmeli.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:33:463
ECHO .ÿ
ECHO * (315/765) Compilando cfepnato.prg
 harbour.exe ".\cfepnato.prg" /q /o".\cfepnato.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:33:712
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepnato.obj" >> "b32.bc"
 echo ".\cfepnato.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:33:712
ECHO .ÿ
ECHO * (316/765) Compilando cfepnato.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:34:009
ECHO .ÿ
ECHO * (317/765) Compilando cfepnoim.prg
 harbour.exe ".\cfepnoim.prg" /q /o".\cfepnoim.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:34:227
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepnoim.obj" >> "b32.bc"
 echo ".\cfepnoim.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:34:227
ECHO .ÿ
ECHO * (318/765) Compilando cfepnoim.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:34:523
ECHO .ÿ
ECHO * (319/765) Compilando cfeppddr.prg
 harbour.exe ".\cfeppddr.prg" /q /o".\cfeppddr.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:34:773
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeppddr.obj" >> "b32.bc"
 echo ".\cfeppddr.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:34:773
ECHO .ÿ
ECHO * (320/765) Compilando cfeppddr.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:35:054
ECHO .ÿ
ECHO * (321/765) Compilando cfeppecl.prg
 harbour.exe ".\cfeppecl.prg" /q /o".\cfeppecl.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:35:288
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeppecl.obj" >> "b32.bc"
 echo ".\cfeppecl.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:35:288
ECHO .ÿ
ECHO * (322/765) Compilando cfeppecl.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:35:569
ECHO .ÿ
ECHO * (323/765) Compilando cfeppnfe.prg
 harbour.exe ".\cfeppnfe.prg" /q /o".\cfeppnfe.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:35:803
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeppnfe.obj" >> "b32.bc"
 echo ".\cfeppnfe.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:35:803
ECHO .ÿ
ECHO * (324/765) Compilando cfeppnfe.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:36:097
ECHO .ÿ
ECHO * (325/765) Compilando cfepra01.prg
 harbour.exe ".\cfepra01.prg" /q /o".\cfepra01.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:36:337
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepra01.obj" >> "b32.bc"
 echo ".\cfepra01.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:36:337
ECHO .ÿ
ECHO * (326/765) Compilando cfepra01.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:36:627
ECHO .ÿ
ECHO * (327/765) Compilando cfepra02.prg
 harbour.exe ".\cfepra02.prg" /q /o".\cfepra02.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:36:867
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepra02.obj" >> "b32.bc"
 echo ".\cfepra02.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:36:867
ECHO .ÿ
ECHO * (328/765) Compilando cfepra02.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:37:167
ECHO .ÿ
ECHO * (329/765) Compilando cfepra11.prg
 harbour.exe ".\cfepra11.prg" /q /o".\cfepra11.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:37:407
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepra11.obj" >> "b32.bc"
 echo ".\cfepra11.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:37:407
ECHO .ÿ
ECHO * (330/765) Compilando cfepra11.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:37:697
ECHO .ÿ
ECHO * (331/765) Compilando cfepra12.prg
 harbour.exe ".\cfepra12.prg" /q /o".\cfepra12.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:37:957
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepra12.obj" >> "b32.bc"
 echo ".\cfepra12.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:37:957
ECHO .ÿ
ECHO * (332/765) Compilando cfepra12.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:38:247
ECHO .ÿ
ECHO * (333/765) Compilando cfepra15.prg
 harbour.exe ".\cfepra15.prg" /q /o".\cfepra15.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:38:487
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepra15.obj" >> "b32.bc"
 echo ".\cfepra15.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:38:487
ECHO .ÿ
ECHO * (334/765) Compilando cfepra15.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:38:779
ECHO .ÿ
ECHO * (335/765) Compilando cfepraht.prg
 harbour.exe ".\cfepraht.prg" /q /o".\cfepraht.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:39:039
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepraht.obj" >> "b32.bc"
 echo ".\cfepraht.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:39:039
ECHO .ÿ
ECHO * (336/765) Compilando cfepraht.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:39:329
ECHO .ÿ
ECHO * (337/765) Compilando cfepramn.prg
 harbour.exe ".\cfepramn.prg" /q /o".\cfepramn.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:39:609
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepramn.obj" >> "b32.bc"
 echo ".\cfepramn.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:39:609
ECHO .ÿ
ECHO * (338/765) Compilando cfepramn.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:39:896
ECHO .ÿ
ECHO * (339/765) Compilando cfeprcpg.prg
 harbour.exe ".\cfeprcpg.prg" /q /o".\cfeprcpg.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:40:130
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeprcpg.obj" >> "b32.bc"
 echo ".\cfeprcpg.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:40:130
ECHO .ÿ
ECHO * (340/765) Compilando cfeprcpg.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:40:426
ECHO .ÿ
ECHO * (341/765) Compilando cfeprecf.prg
 harbour.exe ".\cfeprecf.prg" /q /o".\cfeprecf.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:40:660
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeprecf.obj" >> "b32.bc"
 echo ".\cfeprecf.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:40:660
ECHO .ÿ
ECHO * (342/765) Compilando cfeprecf.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:40:957
ECHO .ÿ
ECHO * (343/765) Compilando cfeprecp.prg
 harbour.exe ".\cfeprecp.prg" /q /o".\cfeprecp.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:41:191
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeprecp.obj" >> "b32.bc"
 echo ".\cfeprecp.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:41:191
ECHO .ÿ
ECHO * (344/765) Compilando cfeprecp.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:41:471
ECHO .ÿ
ECHO * (345/765) Compilando cfeprped.prg
 harbour.exe ".\cfeprped.prg" /q /o".\cfeprped.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:41:737
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeprped.obj" >> "b32.bc"
 echo ".\cfeprped.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:41:737
ECHO .ÿ
ECHO * (346/765) Compilando cfeprped.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:42:033
ECHO .ÿ
ECHO * (347/765) Compilando cfeprven.prg
 harbour.exe ".\cfeprven.prg" /q /o".\cfeprven.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:42:283
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeprven.obj" >> "b32.bc"
 echo ".\cfeprven.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:42:298
ECHO .ÿ
ECHO * (348/765) Compilando cfeprven.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:42:579
ECHO .ÿ
ECHO * (349/765) Compilando cfeprvfi.prg
 harbour.exe ".\cfeprvfi.prg" /q /o".\cfeprvfi.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:42:829
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeprvfi.obj" >> "b32.bc"
 echo ".\cfeprvfi.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:42:829
ECHO .ÿ
ECHO * (350/765) Compilando cfeprvfi.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:43:125
ECHO .ÿ
ECHO * (351/765) Compilando cfepsald.prg
 harbour.exe ".\cfepsald.prg" /q /o".\cfepsald.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:43:421
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepsald.obj" >> "b32.bc"
 echo ".\cfepsald.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:43:421
ECHO .ÿ
ECHO * (352/765) Compilando cfepsald.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:43:718
ECHO .ÿ
ECHO * (353/765) Compilando cfepspcc.prg
 harbour.exe ".\cfepspcc.prg" /q /o".\cfepspcc.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:43:952
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepspcc.obj" >> "b32.bc"
 echo ".\cfepspcc.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:43:952
ECHO .ÿ
ECHO * (354/765) Compilando cfepspcc.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:44:233
ECHO .ÿ
ECHO * (355/765) Compilando cfepspcr.prg
 harbour.exe ".\cfepspcr.prg" /q /o".\cfepspcr.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:44:498
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepspcr.obj" >> "b32.bc"
 echo ".\cfepspcr.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:44:498
ECHO .ÿ
ECHO * (356/765) Compilando cfepspcr.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:44:779
ECHO .ÿ
ECHO * (357/765) Compilando cfeptaen.prg
 harbour.exe ".\cfeptaen.prg" /q /o".\cfeptaen.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:45:044
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeptaen.obj" >> "b32.bc"
 echo ".\cfeptaen.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:45:044
ECHO .ÿ
ECHO * (358/765) Compilando cfeptaen.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:45:325
ECHO .ÿ
ECHO * (359/765) Compilando cfeptard.prg
 harbour.exe ".\cfeptard.prg" /q /o".\cfeptard.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:45:559
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeptard.obj" >> "b32.bc"
 echo ".\cfeptard.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:45:574
ECHO .ÿ
ECHO * (360/765) Compilando cfeptard.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:45:855
ECHO .ÿ
ECHO * (361/765) Compilando cfeptasa.prg
 harbour.exe ".\cfeptasa.prg" /q /o".\cfeptasa.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:46:089
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeptasa.obj" >> "b32.bc"
 echo ".\cfeptasa.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:46:089
ECHO .ÿ
ECHO * (362/765) Compilando cfeptasa.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:46:370
ECHO .ÿ
ECHO * (363/765) Compilando cfeptran.prg
 harbour.exe ".\cfeptran.prg" /q /o".\cfeptran.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:46:635
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeptran.obj" >> "b32.bc"
 echo ".\cfeptran.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:46:635
ECHO .ÿ
ECHO * (364/765) Compilando cfeptran.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:46:916
ECHO .ÿ
ECHO * (365/765) Compilando cfeptrnf.prg
 harbour.exe ".\cfeptrnf.prg" /q /o".\cfeptrnf.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:47:150
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfeptrnf.obj" >> "b32.bc"
 echo ".\cfeptrnf.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:47:150
ECHO .ÿ
ECHO * (366/765) Compilando cfeptrnf.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:47:431
ECHO .ÿ
ECHO * (367/765) Compilando cfepun.prg
 harbour.exe ".\cfepun.prg" /q /o".\cfepun.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:47:680
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepun.obj" >> "b32.bc"
 echo ".\cfepun.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:47:680
ECHO .ÿ
ECHO * (368/765) Compilando cfepun.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:47:961
ECHO .ÿ
ECHO * (369/765) Compilando cfepunf.prg
 harbour.exe ".\cfepunf.prg" /q /o".\cfepunf.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:48:195
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepunf.obj" >> "b32.bc"
 echo ".\cfepunf.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:48:195
ECHO .ÿ
ECHO * (370/765) Compilando cfepunf.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:48:476
ECHO .ÿ
ECHO * (371/765) Compilando cfepvano.prg
 harbour.exe ".\cfepvano.prg" /q /o".\cfepvano.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:48:694
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepvano.obj" >> "b32.bc"
 echo ".\cfepvano.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:48:694
ECHO .ÿ
ECHO * (372/765) Compilando cfepvano.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:48:991
ECHO .ÿ
ECHO * (373/765) Compilando cfepveba.prg
 harbour.exe ".\cfepveba.prg" /q /o".\cfepveba.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:49:240
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepveba.obj" >> "b32.bc"
 echo ".\cfepveba.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:49:240
ECHO .ÿ
ECHO * (374/765) Compilando cfepveba.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:49:537
ECHO .ÿ
ECHO * (375/765) Compilando cfepvebb.prg
 harbour.exe ".\cfepvebb.prg" /q /o".\cfepvebb.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:49:786
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepvebb.obj" >> "b32.bc"
 echo ".\cfepvebb.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:49:786
ECHO .ÿ
ECHO * (376/765) Compilando cfepvebb.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:50:067
ECHO .ÿ
ECHO * (377/765) Compilando cfepvebc.prg
 harbour.exe ".\cfepvebc.prg" /q /o".\cfepvebc.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:50:317
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepvebc.obj" >> "b32.bc"
 echo ".\cfepvebc.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:50:317
ECHO .ÿ
ECHO * (378/765) Compilando cfepvebc.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:50:597
ECHO .ÿ
ECHO * (379/765) Compilando cfepvebd.prg
 harbour.exe ".\cfepvebd.prg" /q /o".\cfepvebd.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:50:831
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepvebd.obj" >> "b32.bc"
 echo ".\cfepvebd.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:50:831
ECHO .ÿ
ECHO * (380/765) Compilando cfepvebd.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:51:112
ECHO .ÿ
ECHO * (381/765) Compilando cfepvebe.prg
 harbour.exe ".\cfepvebe.prg" /q /o".\cfepvebe.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:51:346
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepvebe.obj" >> "b32.bc"
 echo ".\cfepvebe.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:51:346
ECHO .ÿ
ECHO * (382/765) Compilando cfepvebe.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:51:643
ECHO .ÿ
ECHO * (383/765) Compilando cfepvebx.prg
 harbour.exe ".\cfepvebx.prg" /q /o".\cfepvebx.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:51:877
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepvebx.obj" >> "b32.bc"
 echo ".\cfepvebx.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:51:877
ECHO .ÿ
ECHO * (384/765) Compilando cfepvebx.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:52:157
ECHO .ÿ
ECHO * (385/765) Compilando cfepvend.prg
 harbour.exe ".\cfepvend.prg" /q /o".\cfepvend.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:52:391
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cfepvend.obj" >> "b32.bc"
 echo ".\cfepvend.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:52:391
ECHO .ÿ
ECHO * (386/765) Compilando cfepvend.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:52:672
ECHO .ÿ
ECHO * (387/765) Compilando cheque.prg
 harbour.exe ".\cheque.prg" /q /o".\cheque.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:52:906
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cheque.obj" >> "b32.bc"
 echo ".\cheque.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:52:906
ECHO .ÿ
ECHO * (388/765) Compilando cheque.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:53:203
ECHO .ÿ
ECHO * (389/765) Compilando codigos.prg
 harbour.exe ".\codigos.prg" /q /o".\codigos.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:53:421
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\codigos.obj" >> "b32.bc"
 echo ".\codigos.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:53:421
ECHO .ÿ
ECHO * (390/765) Compilando codigos.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:53:717
ECHO .ÿ
ECHO * (391/765) Compilando copiames.prg
 harbour.exe ".\copiames.prg" /q /o".\copiames.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:53:936
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\copiames.obj" >> "b32.bc"
 echo ".\copiames.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:53:936
ECHO .ÿ
ECHO * (392/765) Compilando copiames.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:54:217
ECHO .ÿ
ECHO * (393/765) Compilando cotaasso.prg
 harbour.exe ".\cotaasso.prg" /q /o".\cotaasso.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:54:482
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cotaasso.obj" >> "b32.bc"
 echo ".\cotaasso.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:54:482
ECHO .ÿ
ECHO * (394/765) Compilando cotaasso.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:54:763
ECHO .ÿ
ECHO * (395/765) Compilando cotabaix.prg
 harbour.exe ".\cotabaix.prg" /q /o".\cotabaix.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:55:012
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cotabaix.obj" >> "b32.bc"
 echo ".\cotabaix.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:55:012
ECHO .ÿ
ECHO * (396/765) Compilando cotabaix.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:55:309
ECHO .ÿ
ECHO * (397/765) Compilando cotacria.prg
 harbour.exe ".\cotacria.prg" /q /o".\cotacria.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:55:543
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cotacria.obj" >> "b32.bc"
 echo ".\cotacria.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:55:543
ECHO .ÿ
ECHO * (398/765) Compilando cotacria.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:55:808
ECHO .ÿ
ECHO * (399/765) Compilando cotaedit.prg
 harbour.exe ".\cotaedit.prg" /q /o".\cotaedit.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:56:057
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cotaedit.obj" >> "b32.bc"
 echo ".\cotaedit.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:56:057
ECHO .ÿ
ECHO * (400/765) Compilando cotaedit.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:56:354
ECHO .ÿ
ECHO * (401/765) Compilando cotainte.prg
 harbour.exe ".\cotainte.prg" /q /o".\cotainte.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:56:588
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cotainte.obj" >> "b32.bc"
 echo ".\cotainte.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:56:588
ECHO .ÿ
ECHO * (402/765) Compilando cotainte.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:56:869
ECHO .ÿ
ECHO * (403/765) Compilando cotamovi.prg
 harbour.exe ".\cotamovi.prg" /q /o".\cotamovi.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:57:103
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cotamovi.obj" >> "b32.bc"
 echo ".\cotamovi.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:57:103
ECHO .ÿ
ECHO * (404/765) Compilando cotamovi.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:57:383
ECHO .ÿ
ECHO * (405/765) Compilando cotapara.prg
 harbour.exe ".\cotapara.prg" /q /o".\cotapara.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:57:617
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cotapara.obj" >> "b32.bc"
 echo ".\cotapara.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:57:617
ECHO .ÿ
ECHO * (406/765) Compilando cotapara.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:57:898
ECHO .ÿ
ECHO * (407/765) Compilando cotasald.prg
 harbour.exe ".\cotasald.prg" /q /o".\cotasald.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:58:210
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cotasald.obj" >> "b32.bc"
 echo ".\cotasald.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:58:210
ECHO .ÿ
ECHO * (408/765) Compilando cotasald.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:58:507
ECHO .ÿ
ECHO * (409/765) Compilando ctbcadld.prg
 harbour.exe ".\ctbcadld.prg" /q /o".\ctbcadld.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:58:756
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbcadld.obj" >> "b32.bc"
 echo ".\ctbcadld.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:58:756
ECHO .ÿ
ECHO * (410/765) Compilando ctbcadld.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:59:053
ECHO .ÿ
ECHO * (411/765) Compilando ctbgerld.prg
 harbour.exe ".\ctbgerld.prg" /q /o".\ctbgerld.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:59:302
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbgerld.obj" >> "b32.bc"
 echo ".\ctbgerld.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:59:302
ECHO .ÿ
ECHO * (412/765) Compilando ctbgerld.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:56:59:599
ECHO .ÿ
ECHO * (413/765) Compilando ctbp1110.prg
 harbour.exe ".\ctbp1110.prg" /q /o".\ctbp1110.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:56:59:817
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1110.obj" >> "b32.bc"
 echo ".\ctbp1110.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:56:59:817
ECHO .ÿ
ECHO * (414/765) Compilando ctbp1110.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:00:098
ECHO .ÿ
ECHO * (415/765) Compilando ctbp1120.prg
 harbour.exe ".\ctbp1120.prg" /q /o".\ctbp1120.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:00:341
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1120.obj" >> "b32.bc"
 echo ".\ctbp1120.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:00:341
ECHO .ÿ
ECHO * (416/765) Compilando ctbp1120.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:00:631
ECHO .ÿ
ECHO * (417/765) Compilando ctbp1130.prg
 harbour.exe ".\ctbp1130.prg" /q /o".\ctbp1130.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:00:871
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1130.obj" >> "b32.bc"
 echo ".\ctbp1130.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:00:871
ECHO .ÿ
ECHO * (418/765) Compilando ctbp1130.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:01:151
ECHO .ÿ
ECHO * (419/765) Compilando ctbp1140.prg
 harbour.exe ".\ctbp1140.prg" /q /o".\ctbp1140.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:01:391
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1140.obj" >> "b32.bc"
 echo ".\ctbp1140.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:01:391
ECHO .ÿ
ECHO * (420/765) Compilando ctbp1140.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:01:681
ECHO .ÿ
ECHO * (421/765) Compilando ctbp1150.prg
 harbour.exe ".\ctbp1150.prg" /q /o".\ctbp1150.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:01:881
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1150.obj" >> "b32.bc"
 echo ".\ctbp1150.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:01:881
ECHO .ÿ
ECHO * (422/765) Compilando ctbp1150.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:02:171
ECHO .ÿ
ECHO * (423/765) Compilando ctbp1210.prg
 harbour.exe ".\ctbp1210.prg" /q /o".\ctbp1210.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:02:402
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1210.obj" >> "b32.bc"
 echo ".\ctbp1210.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:02:402
ECHO .ÿ
ECHO * (424/765) Compilando ctbp1210.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:02:683
ECHO .ÿ
ECHO * (425/765) Compilando ctbp1220.prg
 harbour.exe ".\ctbp1220.prg" /q /o".\ctbp1220.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:02:917
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1220.obj" >> "b32.bc"
 echo ".\ctbp1220.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:02:932
ECHO .ÿ
ECHO * (426/765) Compilando ctbp1220.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:03:213
ECHO .ÿ
ECHO * (427/765) Compilando ctbp1230.prg
 harbour.exe ".\ctbp1230.prg" /q /o".\ctbp1230.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:03:447
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1230.obj" >> "b32.bc"
 echo ".\ctbp1230.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:03:447
ECHO .ÿ
ECHO * (428/765) Compilando ctbp1230.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:03:728
ECHO .ÿ
ECHO * (429/765) Compilando ctbp1240.prg
 harbour.exe ".\ctbp1240.prg" /q /o".\ctbp1240.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:03:993
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1240.obj" >> "b32.bc"
 echo ".\ctbp1240.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:03:993
ECHO .ÿ
ECHO * (430/765) Compilando ctbp1240.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:04:289
ECHO .ÿ
ECHO * (431/765) Compilando ctbp1250.prg
 harbour.exe ".\ctbp1250.prg" /q /o".\ctbp1250.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:04:539
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1250.obj" >> "b32.bc"
 echo ".\ctbp1250.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:04:539
ECHO .ÿ
ECHO * (432/765) Compilando ctbp1250.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:04:820
ECHO .ÿ
ECHO * (433/765) Compilando ctbp1260.prg
 harbour.exe ".\ctbp1260.prg" /q /o".\ctbp1260.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:05:069
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1260.obj" >> "b32.bc"
 echo ".\ctbp1260.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:05:069
ECHO .ÿ
ECHO * (434/765) Compilando ctbp1260.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:05:350
ECHO .ÿ
ECHO * (435/765) Compilando ctbp1310.prg
 harbour.exe ".\ctbp1310.prg" /q /o".\ctbp1310.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:05:615
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1310.obj" >> "b32.bc"
 echo ".\ctbp1310.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:05:615
ECHO .ÿ
ECHO * (436/765) Compilando ctbp1310.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:05:896
ECHO .ÿ
ECHO * (437/765) Compilando ctbp1320.prg
 harbour.exe ".\ctbp1320.prg" /q /o".\ctbp1320.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:06:161
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1320.obj" >> "b32.bc"
 echo ".\ctbp1320.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:06:161
ECHO .ÿ
ECHO * (438/765) Compilando ctbp1320.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:06:458
ECHO .ÿ
ECHO * (439/765) Compilando ctbp1330.prg
 harbour.exe ".\ctbp1330.prg" /q /o".\ctbp1330.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:06:707
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1330.obj" >> "b32.bc"
 echo ".\ctbp1330.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:06:707
ECHO .ÿ
ECHO * (440/765) Compilando ctbp1330.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:06:988
ECHO .ÿ
ECHO * (441/765) Compilando ctbp1340.prg
 harbour.exe ".\ctbp1340.prg" /q /o".\ctbp1340.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:07:238
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbp1340.obj" >> "b32.bc"
 echo ".\ctbp1340.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:07:254
ECHO .ÿ
ECHO * (442/765) Compilando ctbp1340.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:07:534
ECHO .ÿ
ECHO * (443/765) Compilando ctbpcria.prg
 harbour.exe ".\ctbpcria.prg" /q /o".\ctbpcria.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:07:768
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbpcria.obj" >> "b32.bc"
 echo ".\ctbpcria.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:07:768
ECHO .ÿ
ECHO * (444/765) Compilando ctbpcria.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:08:049
ECHO .ÿ
ECHO * (445/765) Compilando ctbpdesa.prg
 harbour.exe ".\ctbpdesa.prg" /q /o".\ctbpdesa.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:08:299
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbpdesa.obj" >> "b32.bc"
 echo ".\ctbpdesa.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:08:299
ECHO .ÿ
ECHO * (446/765) Compilando ctbpdesa.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:08:595
ECHO .ÿ
ECHO * (447/765) Compilando ctbpence.prg
 harbour.exe ".\ctbpence.prg" /q /o".\ctbpence.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:08:829
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbpence.obj" >> "b32.bc"
 echo ".\ctbpence.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:08:829
ECHO .ÿ
ECHO * (448/765) Compilando ctbpence.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:09:126
ECHO .ÿ
ECHO * (449/765) Compilando ctbpfili.prg
 harbour.exe ".\ctbpfili.prg" /q /o".\ctbpfili.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:09:406
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbpfili.obj" >> "b32.bc"
 echo ".\ctbpfili.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:09:406
ECHO .ÿ
ECHO * (450/765) Compilando ctbpfili.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:09:703
ECHO .ÿ
ECHO * (451/765) Compilando ctbpfunc.prg
 harbour.exe ".\ctbpfunc.prg" /q /o".\ctbpfunc.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:09:952
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbpfunc.obj" >> "b32.bc"
 echo ".\ctbpfunc.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:09:952
ECHO .ÿ
ECHO * (452/765) Compilando ctbpfunc.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:10:296
ECHO .ÿ
ECHO * (453/765) Compilando ctbpidia.prg
 harbour.exe ".\ctbpidia.prg" /q /o".\ctbpidia.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:10:561
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbpidia.obj" >> "b32.bc"
 echo ".\ctbpidia.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:10:561
ECHO .ÿ
ECHO * (454/765) Compilando ctbpidia.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:10:857
ECHO .ÿ
ECHO * (455/765) Compilando ctbpimen.prg
 harbour.exe ".\ctbpimen.prg" /q /o".\ctbpimen.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:11:107
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbpimen.obj" >> "b32.bc"
 echo ".\ctbpimen.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:11:107
ECHO .ÿ
ECHO * (456/765) Compilando ctbpimen.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:11:403
ECHO .ÿ
ECHO * (457/765) Compilando ctbpimfa.prg
 harbour.exe ".\ctbpimfa.prg" /q /o".\ctbpimfa.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:11:653
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbpimfa.obj" >> "b32.bc"
 echo ".\ctbpimfa.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:11:653
ECHO .ÿ
ECHO * (458/765) Compilando ctbpimfa.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:11:934
ECHO .ÿ
ECHO * (459/765) Compilando ctbpimlo.prg
 harbour.exe ".\ctbpimlo.prg" /q /o".\ctbpimlo.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:12:168
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbpimlo.obj" >> "b32.bc"
 echo ".\ctbpimlo.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:12:168
ECHO .ÿ
ECHO * (460/765) Compilando ctbpimlo.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:12:464
ECHO .ÿ
ECHO * (461/765) Compilando ctbpincf.prg
 harbour.exe ".\ctbpincf.prg" /q /o".\ctbpincf.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:12:698
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbpincf.obj" >> "b32.bc"
 echo ".\ctbpincf.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:12:698
ECHO .ÿ
ECHO * (462/765) Compilando ctbpincf.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:12:994
ECHO .ÿ
ECHO * (463/765) Compilando ctbpinte.prg
 harbour.exe ".\ctbpinte.prg" /q /o".\ctbpinte.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:13:244
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbpinte.obj" >> "b32.bc"
 echo ".\ctbpinte.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:13:244
ECHO .ÿ
ECHO * (464/765) Compilando ctbpinte.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:13:525
ECHO .ÿ
ECHO * (465/765) Compilando ctbplimp.prg
 harbour.exe ".\ctbplimp.prg" /q /o".\ctbplimp.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:13:759
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbplimp.obj" >> "b32.bc"
 echo ".\ctbplimp.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:13:759
ECHO .ÿ
ECHO * (466/765) Compilando ctbplimp.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:14:040
ECHO .ÿ
ECHO * (467/765) Compilando ctbpmetr.prg
 harbour.exe ".\ctbpmetr.prg" /q /o".\ctbpmetr.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:14:274
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctbpmetr.obj" >> "b32.bc"
 echo ".\ctbpmetr.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:14:274
ECHO .ÿ
ECHO * (468/765) Compilando ctbpmetr.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:14:570
ECHO .ÿ
ECHO * (469/765) Compilando ctrpsuin.prg
 harbour.exe ".\ctrpsuin.prg" /q /o".\ctrpsuin.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:14:835
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ctrpsuin.obj" >> "b32.bc"
 echo ".\ctrpsuin.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:14:835
ECHO .ÿ
ECHO * (470/765) Compilando ctrpsuin.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:15:132
ECHO .ÿ
ECHO * (471/765) Compilando cxap0001.prg
 harbour.exe ".\cxap0001.prg" /q /o".\cxap0001.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:15:366
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxap0001.obj" >> "b32.bc"
 echo ".\cxap0001.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:15:366
ECHO .ÿ
ECHO * (472/765) Compilando cxap0001.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:15:646
ECHO .ÿ
ECHO * (473/765) Compilando cxap0002.prg
 harbour.exe ".\cxap0002.prg" /q /o".\cxap0002.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:15:880
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxap0002.obj" >> "b32.bc"
 echo ".\cxap0002.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:15:896
ECHO .ÿ
ECHO * (474/765) Compilando cxap0002.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:16:177
ECHO .ÿ
ECHO * (475/765) Compilando cxap0003.prg
 harbour.exe ".\cxap0003.prg" /q /o".\cxap0003.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:16:411
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxap0003.obj" >> "b32.bc"
 echo ".\cxap0003.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:16:411
ECHO .ÿ
ECHO * (476/765) Compilando cxap0003.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:16:692
ECHO .ÿ
ECHO * (477/765) Compilando cxap0004.prg
 harbour.exe ".\cxap0004.prg" /q /o".\cxap0004.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:16:926
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxap0004.obj" >> "b32.bc"
 echo ".\cxap0004.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:16:926
ECHO .ÿ
ECHO * (478/765) Compilando cxap0004.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:17:206
ECHO .ÿ
ECHO * (479/765) Compilando cxap9999.prg
 harbour.exe ".\cxap9999.prg" /q /o".\cxap9999.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:17:456
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxap9999.obj" >> "b32.bc"
 echo ".\cxap9999.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:17:456
ECHO .ÿ
ECHO * (480/765) Compilando cxap9999.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:17:752
ECHO .ÿ
ECHO * (481/765) Compilando cxapadt.prg
 harbour.exe ".\cxapadt.prg" /q /o".\cxapadt.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:18:049
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxapadt.obj" >> "b32.bc"
 echo ".\cxapadt.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:18:049
ECHO .ÿ
ECHO * (482/765) Compilando cxapadt.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:18:345
ECHO .ÿ
ECHO * (483/765) Compilando cxapadtx.prg
 harbour.exe ".\cxapadtx.prg" /q /o".\cxapadtx.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:18:595
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxapadtx.obj" >> "b32.bc"
 echo ".\cxapadtx.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:18:595
ECHO .ÿ
ECHO * (484/765) Compilando cxapadtx.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:18:891
ECHO .ÿ
ECHO * (485/765) Compilando cxapalte.prg
 harbour.exe ".\cxapalte.prg" /q /o".\cxapalte.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:19:125
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxapalte.obj" >> "b32.bc"
 echo ".\cxapalte.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:19:125
ECHO .ÿ
ECHO * (486/765) Compilando cxapalte.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:19:422
ECHO .ÿ
ECHO * (487/765) Compilando cxapbcl1.prg
 harbour.exe ".\cxapbcl1.prg" /q /o".\cxapbcl1.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:19:656
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxapbcl1.obj" >> "b32.bc"
 echo ".\cxapbcl1.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:19:656
ECHO .ÿ
ECHO * (488/765) Compilando cxapbcl1.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:19:936
ECHO .ÿ
ECHO * (489/765) Compilando cxapcdgr.prg
 harbour.exe ".\cxapcdgr.prg" /q /o".\cxapcdgr.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:20:217
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxapcdgr.obj" >> "b32.bc"
 echo ".\cxapcdgr.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:20:217
ECHO .ÿ
ECHO * (490/765) Compilando cxapcdgr.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:20:498
ECHO .ÿ
ECHO * (491/765) Compilando cxapcria.prg
 harbour.exe ".\cxapcria.prg" /q /o".\cxapcria.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:20:748
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxapcria.obj" >> "b32.bc"
 echo ".\cxapcria.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:20:748
ECHO .ÿ
ECHO * (492/765) Compilando cxapcria.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:21:028
ECHO .ÿ
ECHO * (493/765) Compilando cxapdesp.prg
 harbour.exe ".\cxapdesp.prg" /q /o".\cxapdesp.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:21:262
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxapdesp.obj" >> "b32.bc"
 echo ".\cxapdesp.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:21:262
ECHO .ÿ
ECHO * (494/765) Compilando cxapdesp.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:21:543
ECHO .ÿ
ECHO * (495/765) Compilando cxapedmb.prg
 harbour.exe ".\cxapedmb.prg" /q /o".\cxapedmb.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:21:808
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxapedmb.obj" >> "b32.bc"
 echo ".\cxapedmb.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:21:808
ECHO .ÿ
ECHO * (496/765) Compilando cxapedmb.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:22:089
ECHO .ÿ
ECHO * (497/765) Compilando cxapintc.prg
 harbour.exe ".\cxapintc.prg" /q /o".\cxapintc.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:22:339
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxapintc.obj" >> "b32.bc"
 echo ".\cxapintc.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:22:339
ECHO .ÿ
ECHO * (498/765) Compilando cxapintc.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:22:620
ECHO .ÿ
ECHO * (499/765) Compilando cxapinte.prg
 harbour.exe ".\cxapinte.prg" /q /o".\cxapinte.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:22:854
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxapinte.obj" >> "b32.bc"
 echo ".\cxapinte.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:22:854
ECHO .ÿ
ECHO * (500/765) Compilando cxapinte.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:23:150
ECHO .ÿ
ECHO * (501/765) Compilando cxaplidi.prg
 harbour.exe ".\cxaplidi.prg" /q /o".\cxaplidi.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:23:400
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxaplidi.obj" >> "b32.bc"
 echo ".\cxaplidi.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:23:400
ECHO .ÿ
ECHO * (502/765) Compilando cxaplidi.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:23:696
ECHO .ÿ
ECHO * (503/765) Compilando cxapligr.prg
 harbour.exe ".\cxapligr.prg" /q /o".\cxapligr.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:23:930
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxapligr.obj" >> "b32.bc"
 echo ".\cxapligr.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:23:930
ECHO .ÿ
ECHO * (504/765) Compilando cxapligr.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:24:226
ECHO .ÿ
ECHO * (505/765) Compilando cxappara.prg
 harbour.exe ".\cxappara.prg" /q /o".\cxappara.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:24:460
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxappara.obj" >> "b32.bc"
 echo ".\cxappara.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:24:460
ECHO .ÿ
ECHO * (506/765) Compilando cxappara.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:24:757
ECHO .ÿ
ECHO * (507/765) Compilando cxappre.prg
 harbour.exe ".\cxappre.prg" /q /o".\cxappre.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:25:022
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxappre.obj" >> "b32.bc"
 echo ".\cxappre.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:25:022
ECHO .ÿ
ECHO * (508/765) Compilando cxappre.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:25:303
ECHO .ÿ
ECHO * (509/765) Compilando cxapsald.prg
 harbour.exe ".\cxapsald.prg" /q /o".\cxapsald.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:25:537
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxapsald.obj" >> "b32.bc"
 echo ".\cxapsald.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:25:537
ECHO .ÿ
ECHO * (510/765) Compilando cxapsald.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:25:818
ECHO .ÿ
ECHO * (511/765) Compilando cxaptrac.prg
 harbour.exe ".\cxaptrac.prg" /q /o".\cxaptrac.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:26:067
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\cxaptrac.obj" >> "b32.bc"
 echo ".\cxaptrac.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:26:067
ECHO .ÿ
ECHO * (512/765) Compilando cxaptrac.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:26:348
ECHO .ÿ
ECHO * (513/765) Compilando expcfe.prg
 harbour.exe ".\expcfe.prg" /q /o".\expcfe.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:26:598
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\expcfe.obj" >> "b32.bc"
 echo ".\expcfe.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:26:598
ECHO .ÿ
ECHO * (514/765) Compilando expcfe.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:26:894
ECHO .ÿ
ECHO * (515/765) Compilando expsql.prg
 harbour.exe ".\expsql.prg" /q /o".\expsql.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:27:144
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\expsql.obj" >> "b32.bc"
 echo ".\expsql.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:27:144
ECHO .ÿ
ECHO * (516/765) Compilando expsql.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:27:424
ECHO .ÿ
ECHO * (517/765) Compilando fatpcdcp.prg
 harbour.exe ".\fatpcdcp.prg" /q /o".\fatpcdcp.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:27:674
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fatpcdcp.obj" >> "b32.bc"
 echo ".\fatpcdcp.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:27:674
ECHO .ÿ
ECHO * (518/765) Compilando fatpcdcp.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:27:955
ECHO .ÿ
ECHO * (519/765) Compilando fatpcria.prg
 harbour.exe ".\fatpcria.prg" /q /o".\fatpcria.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:28:189
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fatpcria.obj" >> "b32.bc"
 echo ".\fatpcria.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:28:189
ECHO .ÿ
ECHO * (520/765) Compilando fatpcria.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:28:470
ECHO .ÿ
ECHO * (521/765) Compilando fatpdcf.prg
 harbour.exe ".\fatpdcf.prg" /q /o".\fatpdcf.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:28:750
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fatpdcf.obj" >> "b32.bc"
 echo ".\fatpdcf.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:28:750
ECHO .ÿ
ECHO * (522/765) Compilando fatpdcf.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:29:062
ECHO .ÿ
ECHO * (523/765) Compilando fatpdcfx.prg
 harbour.exe ".\fatpdcfx.prg" /q /o".\fatpdcfx.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:29:312
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fatpdcfx.obj" >> "b32.bc"
 echo ".\fatpdcfx.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:29:312
ECHO .ÿ
ECHO * (524/765) Compilando fatpdcfx.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:29:608
ECHO .ÿ
ECHO * (525/765) Compilando fatpdest.prg
 harbour.exe ".\fatpdest.prg" /q /o".\fatpdest.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:29:858
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fatpdest.obj" >> "b32.bc"
 echo ".\fatpdest.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:29:858
ECHO .ÿ
ECHO * (526/765) Compilando fatpdest.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:30:154
ECHO .ÿ
ECHO * (527/765) Compilando fatpgrpe.prg
 harbour.exe ".\fatpgrpe.prg" /q /o".\fatpgrpe.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:30:404
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fatpgrpe.obj" >> "b32.bc"
 echo ".\fatpgrpe.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:30:404
ECHO .ÿ
ECHO * (528/765) Compilando fatpgrpe.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:30:685
ECHO .ÿ
ECHO * (529/765) Compilando fatplote.prg
 harbour.exe ".\fatplote.prg" /q /o".\fatplote.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:30:934
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fatplote.obj" >> "b32.bc"
 echo ".\fatplote.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:30:934
ECHO .ÿ
ECHO * (530/765) Compilando fatplote.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:31:246
ECHO .ÿ
ECHO * (531/765) Compilando fatppis.prg
 harbour.exe ".\fatppis.prg" /q /o".\fatppis.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:31:496
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fatppis.obj" >> "b32.bc"
 echo ".\fatppis.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:31:496
ECHO .ÿ
ECHO * (532/765) Compilando fatppis.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:31:792
ECHO .ÿ
ECHO * (533/765) Compilando fatpsvc.prg
 harbour.exe ".\fatpsvc.prg" /q /o".\fatpsvc.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:32:042
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fatpsvc.obj" >> "b32.bc"
 echo ".\fatpsvc.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:32:042
ECHO .ÿ
ECHO * (534/765) Compilando fatpsvc.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:32:323
ECHO .ÿ
ECHO * (535/765) Compilando fisato15.prg
 harbour.exe ".\fisato15.prg" /q /o".\fisato15.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:32:619
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fisato15.obj" >> "b32.bc"
 echo ".\fisato15.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:32:619
ECHO .ÿ
ECHO * (536/765) Compilando fisato15.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:32:916
ECHO .ÿ
ECHO * (537/765) Compilando fisp0001.prg
 harbour.exe ".\fisp0001.prg" /q /o".\fisp0001.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:33:165
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fisp0001.obj" >> "b32.bc"
 echo ".\fisp0001.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:33:165
ECHO .ÿ
ECHO * (538/765) Compilando fisp0001.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:33:462
ECHO .ÿ
ECHO * (539/765) Compilando fisp0002.prg
 harbour.exe ".\fisp0002.prg" /q /o".\fisp0002.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:33:696
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fisp0002.obj" >> "b32.bc"
 echo ".\fisp0002.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:33:696
ECHO .ÿ
ECHO * (540/765) Compilando fisp0002.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:33:992
ECHO .ÿ
ECHO * (541/765) Compilando fisp0003.prg
 harbour.exe ".\fisp0003.prg" /q /o".\fisp0003.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:34:257
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fisp0003.obj" >> "b32.bc"
 echo ".\fisp0003.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:34:257
ECHO .ÿ
ECHO * (542/765) Compilando fisp0003.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:34:538
ECHO .ÿ
ECHO * (543/765) Compilando fisp0004.prg
 harbour.exe ".\fisp0004.prg" /q /o".\fisp0004.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:34:741
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fisp0004.obj" >> "b32.bc"
 echo ".\fisp0004.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:34:741
ECHO .ÿ
ECHO * (544/765) Compilando fisp0004.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:35:037
ECHO .ÿ
ECHO * (545/765) Compilando fisp0005.prg
 harbour.exe ".\fisp0005.prg" /q /o".\fisp0005.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:35:271
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fisp0005.obj" >> "b32.bc"
 echo ".\fisp0005.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:35:271
ECHO .ÿ
ECHO * (546/765) Compilando fisp0005.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:35:568
ECHO .ÿ
ECHO * (547/765) Compilando fisp0006.prg
 harbour.exe ".\fisp0006.prg" /q /o".\fisp0006.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:35:817
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fisp0006.obj" >> "b32.bc"
 echo ".\fisp0006.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:35:817
ECHO .ÿ
ECHO * (548/765) Compilando fisp0006.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:36:098
ECHO .ÿ
ECHO * (549/765) Compilando fispcfis.prg
 harbour.exe ".\fispcfis.prg" /q /o".\fispcfis.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:36:332
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fispcfis.obj" >> "b32.bc"
 echo ".\fispcfis.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:36:332
ECHO .ÿ
ECHO * (550/765) Compilando fispcfis.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:36:613
ECHO .ÿ
ECHO * (551/765) Compilando fispcof.prg
 harbour.exe ".\fispcof.prg" /q /o".\fispcof.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:36:878
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fispcof.obj" >> "b32.bc"
 echo ".\fispcof.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:36:878
ECHO .ÿ
ECHO * (552/765) Compilando fispcof.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:37:159
ECHO .ÿ
ECHO * (553/765) Compilando fispcofr.prg
 harbour.exe ".\fispcofr.prg" /q /o".\fispcofr.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:37:393
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fispcofr.obj" >> "b32.bc"
 echo ".\fispcofr.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:37:393
ECHO .ÿ
ECHO * (554/765) Compilando fispcofr.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:37:689
ECHO .ÿ
ECHO * (555/765) Compilando fispcria.prg
 harbour.exe ".\fispcria.prg" /q /o".\fispcria.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:37:923
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fispcria.obj" >> "b32.bc"
 echo ".\fispcria.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:37:923
ECHO .ÿ
ECHO * (556/765) Compilando fispcria.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:38:220
ECHO .ÿ
ECHO * (557/765) Compilando fispdief.prg
 harbour.exe ".\fispdief.prg" /q /o".\fispdief.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:38:469
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fispdief.obj" >> "b32.bc"
 echo ".\fispdief.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:38:469
ECHO .ÿ
ECHO * (558/765) Compilando fispdief.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:38:766
ECHO .ÿ
ECHO * (559/765) Compilando fispnfeg.prg
 harbour.exe ".\fispnfeg.prg" /q /o".\fispnfeg.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:39:046
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fispnfeg.obj" >> "b32.bc"
 echo ".\fispnfeg.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:39:046
ECHO .ÿ
ECHO * (560/765) Compilando fispnfeg.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:39:343
ECHO .ÿ
ECHO * (561/765) Compilando fispnfep.prg
 harbour.exe ".\fispnfep.prg" /q /o".\fispnfep.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:39:577
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fispnfep.obj" >> "b32.bc"
 echo ".\fispnfep.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:39:577
ECHO .ÿ
ECHO * (562/765) Compilando fispnfep.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:39:873
ECHO .ÿ
ECHO * (563/765) Compilando fispobs.prg
 harbour.exe ".\fispobs.prg" /q /o".\fispobs.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:40:107
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fispobs.obj" >> "b32.bc"
 echo ".\fispobs.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:40:107
ECHO .ÿ
ECHO * (564/765) Compilando fispobs.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:40:388
ECHO .ÿ
ECHO * (565/765) Compilando fn_abrex.prg
 harbour.exe ".\fn_abrex.prg" /q /o".\fn_abrex.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:40:606
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_abrex.obj" >> "b32.bc"
 echo ".\fn_abrex.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:40:606
ECHO .ÿ
ECHO * (566/765) Compilando fn_abrex.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:40:887
ECHO .ÿ
ECHO * (567/765) Compilando fn_arqs.prg
 harbour.exe ".\fn_arqs.prg" /q /o".\fn_arqs.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:41:121
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_arqs.obj" >> "b32.bc"
 echo ".\fn_arqs.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:41:121
ECHO .ÿ
ECHO * (568/765) Compilando fn_arqs.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:41:418
ECHO .ÿ
ECHO * (569/765) Compilando fn_cliob.prg
 harbour.exe ".\fn_cliob.prg" /q /o".\fn_cliob.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:41:652
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_cliob.obj" >> "b32.bc"
 echo ".\fn_cliob.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:41:652
ECHO .ÿ
ECHO * (570/765) Compilando fn_cliob.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:41:932
ECHO .ÿ
ECHO * (571/765) Compilando fn_codar.prg
 harbour.exe ".\fn_codar.prg" /q /o".\fn_codar.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:42:166
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_codar.obj" >> "b32.bc"
 echo ".\fn_codar.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:42:166
ECHO .ÿ
ECHO * (572/765) Compilando fn_codar.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:42:447
ECHO .ÿ
ECHO * (573/765) Compilando fn_codfc.prg
 harbour.exe ".\fn_codfc.prg" /q /o".\fn_codfc.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:42:681
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_codfc.obj" >> "b32.bc"
 echo ".\fn_codfc.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:42:681
ECHO .ÿ
ECHO * (574/765) Compilando fn_codfc.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:42:962
ECHO .ÿ
ECHO * (575/765) Compilando fn_codpr.prg
 harbour.exe ".\fn_codpr.prg" /q /o".\fn_codpr.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:43:180
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_codpr.obj" >> "b32.bc"
 echo ".\fn_codpr.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:43:180
ECHO .ÿ
ECHO * (576/765) Compilando fn_codpr.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:43:477
ECHO .ÿ
ECHO * (577/765) Compilando fn_consp.prg
 harbour.exe ".\fn_consp.prg" /q /o".\fn_consp.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:43:695
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_consp.obj" >> "b32.bc"
 echo ".\fn_consp.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:43:695
ECHO .ÿ
ECHO * (578/765) Compilando fn_consp.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:43:992
ECHO .ÿ
ECHO * (579/765) Compilando fn_edvlr.prg
 harbour.exe ".\fn_edvlr.prg" /q /o".\fn_edvlr.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:44:226
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_edvlr.obj" >> "b32.bc"
 echo ".\fn_edvlr.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:44:226
ECHO .ÿ
ECHO * (580/765) Compilando fn_edvlr.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:44:522
ECHO .ÿ
ECHO * (581/765) Compilando fn_edvlx.prg
 harbour.exe ".\fn_edvlx.prg" /q /o".\fn_edvlx.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:44:756
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_edvlx.obj" >> "b32.bc"
 echo ".\fn_edvlx.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:44:756
ECHO .ÿ
ECHO * (582/765) Compilando fn_edvlx.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:45:037
ECHO .ÿ
ECHO * (583/765) Compilando fn_elimi.prg
 harbour.exe ".\fn_elimi.prg" /q /o".\fn_elimi.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:45:271
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_elimi.obj" >> "b32.bc"
 echo ".\fn_elimi.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:45:271
ECHO .ÿ
ECHO * (584/765) Compilando fn_elimi.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:45:552
ECHO .ÿ
ECHO * (585/765) Compilando fn_gravm.prg
 harbour.exe ".\fn_gravm.prg" /q /o".\fn_gravm.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:45:788
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_gravm.obj" >> "b32.bc"
 echo ".\fn_gravm.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:45:788
ECHO .ÿ
ECHO * (586/765) Compilando fn_gravm.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:46:078
ECHO .ÿ
ECHO * (587/765) Compilando fn_grnf.prg
 harbour.exe ".\fn_grnf.prg" /q /o".\fn_grnf.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:46:318
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_grnf.obj" >> "b32.bc"
 echo ".\fn_grnf.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:46:318
ECHO .ÿ
ECHO * (588/765) Compilando fn_grnf.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:46:608
ECHO .ÿ
ECHO * (589/765) Compilando fn_impca.prg
 harbour.exe ".\fn_impca.prg" /q /o".\fn_impca.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:46:838
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_impca.obj" >> "b32.bc"
 echo ".\fn_impca.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:46:838
ECHO .ÿ
ECHO * (590/765) Compilando fn_impca.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:47:118
ECHO .ÿ
ECHO * (591/765) Compilando fn_mkdel.prg
 harbour.exe ".\fn_mkdel.prg" /q /o".\fn_mkdel.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:47:328
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_mkdel.obj" >> "b32.bc"
 echo ".\fn_mkdel.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:47:328
ECHO .ÿ
ECHO * (592/765) Compilando fn_mkdel.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:47:618
ECHO .ÿ
ECHO * (593/765) Compilando fn_msdpl.prg
 harbour.exe ".\fn_msdpl.prg" /q /o".\fn_msdpl.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:47:841
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_msdpl.obj" >> "b32.bc"
 echo ".\fn_msdpl.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:47:841
ECHO .ÿ
ECHO * (594/765) Compilando fn_msdpl.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:48:122
ECHO .ÿ
ECHO * (595/765) Compilando fn_pack.prg
 harbour.exe ".\fn_pack.prg" /q /o".\fn_pack.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:48:325
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_pack.obj" >> "b32.bc"
 echo ".\fn_pack.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:48:325
ECHO .ÿ
ECHO * (596/765) Compilando fn_pack.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:48:621
ECHO .ÿ
ECHO * (597/765) Compilando fn_parc.prg
 harbour.exe ".\fn_parc.prg" /q /o".\fn_parc.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:48:855
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_parc.obj" >> "b32.bc"
 echo ".\fn_parc.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:48:855
ECHO .ÿ
ECHO * (598/765) Compilando fn_parc.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:49:136
ECHO .ÿ
ECHO * (599/765) Compilando fn_parc1.prg
 harbour.exe ".\fn_parc1.prg" /q /o".\fn_parc1.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:49:401
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_parc1.obj" >> "b32.bc"
 echo ".\fn_parc1.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:49:401
ECHO .ÿ
ECHO * (600/765) Compilando fn_parc1.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:49:682
ECHO .ÿ
ECHO * (601/765) Compilando fn_recno.prg
 harbour.exe ".\fn_recno.prg" /q /o".\fn_recno.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:49:932
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_recno.obj" >> "b32.bc"
 echo ".\fn_recno.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:49:932
ECHO .ÿ
ECHO * (602/765) Compilando fn_recno.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:50:212
ECHO .ÿ
ECHO * (603/765) Compilando fn_vlven.prg
 harbour.exe ".\fn_vlven.prg" /q /o".\fn_vlven.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:50:446
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\fn_vlven.obj" >> "b32.bc"
 echo ".\fn_vlven.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:50:446
ECHO .ÿ
ECHO * (604/765) Compilando fn_vlven.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:50:727
ECHO .ÿ
ECHO * (605/765) Compilando gdfpcfee.prg
 harbour.exe ".\gdfpcfee.prg" /q /o".\gdfpcfee.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:50:961
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\gdfpcfee.obj" >> "b32.bc"
 echo ".\gdfpcfee.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:50:961
ECHO .ÿ
ECHO * (606/765) Compilando gdfpcfee.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:51:258
ECHO .ÿ
ECHO * (607/765) Compilando gdfpcfes.prg
 harbour.exe ".\gdfpcfes.prg" /q /o".\gdfpcfes.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:51:492
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\gdfpcfes.obj" >> "b32.bc"
 echo ".\gdfpcfes.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:51:492
ECHO .ÿ
ECHO * (608/765) Compilando gdfpcfes.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:51:788
ECHO .ÿ
ECHO * (609/765) Compilando gdfpcfre.prg
 harbour.exe ".\gdfpcfre.prg" /q /o".\gdfpcfre.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:52:022
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\gdfpcfre.obj" >> "b32.bc"
 echo ".\gdfpcfre.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:52:022
ECHO .ÿ
ECHO * (610/765) Compilando gdfpcfre.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:52:318
ECHO .ÿ
ECHO * (611/765) Compilando gdfpgera.prg
 harbour.exe ".\gdfpgera.prg" /q /o".\gdfpgera.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:52:568
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\gdfpgera.obj" >> "b32.bc"
 echo ".\gdfpgera.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:52:568
ECHO .ÿ
ECHO * (612/765) Compilando gdfpgera.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:52:864
ECHO .ÿ
ECHO * (613/765) Compilando gdfppr60.prg
 harbour.exe ".\gdfppr60.prg" /q /o".\gdfppr60.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:53:098
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\gdfppr60.obj" >> "b32.bc"
 echo ".\gdfppr60.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:53:098
ECHO .ÿ
ECHO * (614/765) Compilando gdfppr60.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:53:395
ECHO .ÿ
ECHO * (615/765) Compilando gdfpprep.prg
 harbour.exe ".\gdfpprep.prg" /q /o".\gdfpprep.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:53:644
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\gdfpprep.obj" >> "b32.bc"
 echo ".\gdfpprep.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:53:644
ECHO .ÿ
ECHO * (616/765) Compilando gdfpprep.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:53:941
ECHO .ÿ
ECHO * (617/765) Compilando gdfpsag.prg
 harbour.exe ".\gdfpsag.prg" /q /o".\gdfpsag.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:54:190
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\gdfpsag.obj" >> "b32.bc"
 echo ".\gdfpsag.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:54:190
ECHO .ÿ
ECHO * (618/765) Compilando gdfpsag.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:54:471
ECHO .ÿ
ECHO * (619/765) Compilando ie_ok.prg
 harbour.exe ".\ie_ok.prg" /q /o".\ie_ok.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:54:721
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ie_ok.obj" >> "b32.bc"
 echo ".\ie_ok.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:54:721
ECHO .ÿ
ECHO * (620/765) Compilando ie_ok.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:55:017
ECHO .ÿ
ECHO * (621/765) Compilando import.prg
 harbour.exe ".\import.prg" /q /o".\import.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:55:220
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\import.obj" >> "b32.bc"
 echo ".\import.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:55:220
ECHO .ÿ
ECHO * (622/765) Compilando import.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:55:516
ECHO .ÿ
ECHO * (623/765) Compilando invdigit.prg
 harbour.exe ".\invdigit.prg" /q /o".\invdigit.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:55:766
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\invdigit.obj" >> "b32.bc"
 echo ".\invdigit.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:55:766
ECHO .ÿ
ECHO * (624/765) Compilando invdigit.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:56:047
ECHO .ÿ
ECHO * (625/765) Compilando invelim.prg
 harbour.exe ".\invelim.prg" /q /o".\invelim.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:56:296
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\invelim.obj" >> "b32.bc"
 echo ".\invelim.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:56:296
ECHO .ÿ
ECHO * (626/765) Compilando invelim.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:56:577
ECHO .ÿ
ECHO * (627/765) Compilando invexpor.prg
 harbour.exe ".\invexpor.prg" /q /o".\invexpor.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:56:811
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\invexpor.obj" >> "b32.bc"
 echo ".\invexpor.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:56:811
ECHO .ÿ
ECHO * (628/765) Compilando invexpor.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:57:108
ECHO .ÿ
ECHO * (629/765) Compilando leit001.prg
 harbour.exe ".\leit001.prg" /q /o".\leit001.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:57:357
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\leit001.obj" >> "b32.bc"
 echo ".\leit001.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:57:357
ECHO .ÿ
ECHO * (630/765) Compilando leit001.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:57:638
ECHO .ÿ
ECHO * (631/765) Compilando leitep00.prg
 harbour.exe ".\leitep00.prg" /q /o".\leitep00.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:57:888
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\leitep00.obj" >> "b32.bc"
 echo ".\leitep00.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:57:888
ECHO .ÿ
ECHO * (632/765) Compilando leitep00.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:58:168
ECHO .ÿ
ECHO * (633/765) Compilando leitep01.prg
 harbour.exe ".\leitep01.prg" /q /o".\leitep01.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:58:402
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\leitep01.obj" >> "b32.bc"
 echo ".\leitep01.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:58:402
ECHO .ÿ
ECHO * (634/765) Compilando leitep01.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:58:699
ECHO .ÿ
ECHO * (635/765) Compilando leitep02.prg
 harbour.exe ".\leitep02.prg" /q /o".\leitep02.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:58:933
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\leitep02.obj" >> "b32.bc"
 echo ".\leitep02.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:58:933
ECHO .ÿ
ECHO * (636/765) Compilando leitep02.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:59:229
ECHO .ÿ
ECHO * (637/765) Compilando leitep03.prg
 harbour.exe ".\leitep03.prg" /q /o".\leitep03.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:59:463
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\leitep03.obj" >> "b32.bc"
 echo ".\leitep03.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:59:463
ECHO .ÿ
ECHO * (638/765) Compilando leitep03.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:57:59:760
ECHO .ÿ
ECHO * (639/765) Compilando leitep04.prg
 harbour.exe ".\leitep04.prg" /q /o".\leitep04.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:57:59:994
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\leitep04.obj" >> "b32.bc"
 echo ".\leitep04.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:57:59:994
ECHO .ÿ
ECHO * (640/765) Compilando leitep04.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:00:274
ECHO .ÿ
ECHO * (641/765) Compilando leitep05.prg
 harbour.exe ".\leitep05.prg" /q /o".\leitep05.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:00:524
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\leitep05.obj" >> "b32.bc"
 echo ".\leitep05.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:00:524
ECHO .ÿ
ECHO * (642/765) Compilando leitep05.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:00:805
ECHO .ÿ
ECHO * (643/765) Compilando leitep06.prg
 harbour.exe ".\leitep06.prg" /q /o".\leitep06.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:01:039
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\leitep06.obj" >> "b32.bc"
 echo ".\leitep06.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:01:054
ECHO .ÿ
ECHO * (644/765) Compilando leitep06.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:01:335
ECHO .ÿ
ECHO * (645/765) Compilando leitep07.prg
 harbour.exe ".\leitep07.prg" /q /o".\leitep07.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:01:600
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\leitep07.obj" >> "b32.bc"
 echo ".\leitep07.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:01:600
ECHO .ÿ
ECHO * (646/765) Compilando leitep07.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:01:881
ECHO .ÿ
ECHO * (647/765) Compilando leitep10.prg
 harbour.exe ".\leitep10.prg" /q /o".\leitep10.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:02:115
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\leitep10.obj" >> "b32.bc"
 echo ".\leitep10.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:02:115
ECHO .ÿ
ECHO * (648/765) Compilando leitep10.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:02:412
ECHO .ÿ
ECHO * (649/765) Compilando leitep20.prg
 harbour.exe ".\leitep20.prg" /q /o".\leitep20.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:02:677
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\leitep20.obj" >> "b32.bc"
 echo ".\leitep20.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:02:677
ECHO .ÿ
ECHO * (650/765) Compilando leitep20.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:02:973
ECHO .ÿ
ECHO * (651/765) Compilando libacess.prg
 harbour.exe ".\libacess.prg" /q /o".\libacess.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:03:192
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\libacess.obj" >> "b32.bc"
 echo ".\libacess.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:03:192
ECHO .ÿ
ECHO * (652/765) Compilando libacess.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:03:488
ECHO .ÿ
ECHO * (653/765) Compilando libgdf.prg
 harbour.exe ".\libgdf.prg" /q /o".\libgdf.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:03:691
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\libgdf.obj" >> "b32.bc"
 echo ".\libgdf.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:03:691
ECHO .ÿ
ECHO * (654/765) Compilando libgdf.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:03:972
ECHO .ÿ
ECHO * (655/765) Compilando limpahis.prg
 harbour.exe ".\limpahis.prg" /q /o".\limpahis.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:04:252
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\limpahis.obj" >> "b32.bc"
 echo ".\limpahis.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:04:252
ECHO .ÿ
ECHO * (656/765) Compilando limpahis.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:04:533
ECHO .ÿ
ECHO * (657/765) Compilando livros0.prg
 harbour.exe ".\livros0.prg" /q /o".\livros0.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:04:783
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\livros0.obj" >> "b32.bc"
 echo ".\livros0.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:04:783
ECHO .ÿ
ECHO * (658/765) Compilando livros0.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:05:079
ECHO .ÿ
ECHO * (659/765) Compilando livrosg.prg
 harbour.exe ".\livrosg.prg" /q /o".\livrosg.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:05:329
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\livrosg.obj" >> "b32.bc"
 echo ".\livrosg.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:05:329
ECHO .ÿ
ECHO * (660/765) Compilando livrosg.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:05:641
ECHO .ÿ
ECHO * (661/765) Compilando livrosi.prg
 harbour.exe ".\livrosi.prg" /q /o".\livrosi.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:05:890
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\livrosi.obj" >> "b32.bc"
 echo ".\livrosi.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:05:890
ECHO .ÿ
ECHO * (662/765) Compilando livrosi.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:06:187
ECHO .ÿ
ECHO * (663/765) Compilando livrosts.prg
 harbour.exe ".\livrosts.prg" /q /o".\livrosts.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:06:436
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\livrosts.obj" >> "b32.bc"
 echo ".\livrosts.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:06:436
ECHO .ÿ
ECHO * (664/765) Compilando livrosts.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:06:733
ECHO .ÿ
ECHO * (665/765) Compilando lotealoj.prg
 harbour.exe ".\lotealoj.prg" /q /o".\lotealoj.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:06:967
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\lotealoj.obj" >> "b32.bc"
 echo ".\lotealoj.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:06:967
ECHO .ÿ
ECHO * (666/765) Compilando lotealoj.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:07:263
ECHO .ÿ
ECHO * (667/765) Compilando masc.prg
 harbour.exe ".\masc.prg" /q /o".\masc.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:07:482
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\masc.obj" >> "b32.bc"
 echo ".\masc.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:07:482
ECHO .ÿ
ECHO * (668/765) Compilando masc.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:07:762
ECHO .ÿ
ECHO * (669/765) Compilando ordp0000.prg
 harbour.exe ".\ordp0000.prg" /q /o".\ordp0000.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:08:012
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp0000.obj" >> "b32.bc"
 echo ".\ordp0000.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:08:012
ECHO .ÿ
ECHO * (670/765) Compilando ordp0000.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:08:293
ECHO .ÿ
ECHO * (671/765) Compilando ordp1100.prg
 harbour.exe ".\ordp1100.prg" /q /o".\ordp1100.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:08:527
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp1100.obj" >> "b32.bc"
 echo ".\ordp1100.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:08:527
ECHO .ÿ
ECHO * (672/765) Compilando ordp1100.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:08:823
ECHO .ÿ
ECHO * (673/765) Compilando ordp1200.prg
 harbour.exe ".\ordp1200.prg" /q /o".\ordp1200.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:09:057
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp1200.obj" >> "b32.bc"
 echo ".\ordp1200.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:09:057
ECHO .ÿ
ECHO * (674/765) Compilando ordp1200.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:09:354
ECHO .ÿ
ECHO * (675/765) Compilando ordp1300.prg
 harbour.exe ".\ordp1300.prg" /q /o".\ordp1300.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:09:603
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp1300.obj" >> "b32.bc"
 echo ".\ordp1300.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:09:603
ECHO .ÿ
ECHO * (676/765) Compilando ordp1300.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:09:900
ECHO .ÿ
ECHO * (677/765) Compilando ordp1400.prg
 harbour.exe ".\ordp1400.prg" /q /o".\ordp1400.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:10:134
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp1400.obj" >> "b32.bc"
 echo ".\ordp1400.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:10:134
ECHO .ÿ
ECHO * (678/765) Compilando ordp1400.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:10:430
ECHO .ÿ
ECHO * (679/765) Compilando ordp1500.prg
 harbour.exe ".\ordp1500.prg" /q /o".\ordp1500.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:10:664
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp1500.obj" >> "b32.bc"
 echo ".\ordp1500.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:10:664
ECHO .ÿ
ECHO * (680/765) Compilando ordp1500.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:10:960
ECHO .ÿ
ECHO * (681/765) Compilando ordp2100.prg
 harbour.exe ".\ordp2100.prg" /q /o".\ordp2100.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:11:210
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp2100.obj" >> "b32.bc"
 echo ".\ordp2100.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:11:210
ECHO .ÿ
ECHO * (682/765) Compilando ordp2100.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:11:506
ECHO .ÿ
ECHO * (683/765) Compilando ordp2105.prg
 harbour.exe ".\ordp2105.prg" /q /o".\ordp2105.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:11:756
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp2105.obj" >> "b32.bc"
 echo ".\ordp2105.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:11:756
ECHO .ÿ
ECHO * (684/765) Compilando ordp2105.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:12:052
ECHO .ÿ
ECHO * (685/765) Compilando ordp2200.prg
 harbour.exe ".\ordp2200.prg" /q /o".\ordp2200.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:12:286
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp2200.obj" >> "b32.bc"
 echo ".\ordp2200.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:12:286
ECHO .ÿ
ECHO * (686/765) Compilando ordp2200.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:12:567
ECHO .ÿ
ECHO * (687/765) Compilando ordp2300.prg
 harbour.exe ".\ordp2300.prg" /q /o".\ordp2300.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:12:817
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp2300.obj" >> "b32.bc"
 echo ".\ordp2300.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:12:817
ECHO .ÿ
ECHO * (688/765) Compilando ordp2300.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:13:098
ECHO .ÿ
ECHO * (689/765) Compilando ordp2400.prg
 harbour.exe ".\ordp2400.prg" /q /o".\ordp2400.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:13:332
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp2400.obj" >> "b32.bc"
 echo ".\ordp2400.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:13:332
ECHO .ÿ
ECHO * (690/765) Compilando ordp2400.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:13:628
ECHO .ÿ
ECHO * (691/765) Compilando ordp3100.prg
 harbour.exe ".\ordp3100.prg" /q /o".\ordp3100.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:13:878
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp3100.obj" >> "b32.bc"
 echo ".\ordp3100.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:13:878
ECHO .ÿ
ECHO * (692/765) Compilando ordp3100.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:14:158
ECHO .ÿ
ECHO * (693/765) Compilando ordp3200.prg
 harbour.exe ".\ordp3200.prg" /q /o".\ordp3200.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:14:408
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp3200.obj" >> "b32.bc"
 echo ".\ordp3200.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:14:408
ECHO .ÿ
ECHO * (694/765) Compilando ordp3200.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:14:689
ECHO .ÿ
ECHO * (695/765) Compilando ordp3300.prg
 harbour.exe ".\ordp3300.prg" /q /o".\ordp3300.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:14:923
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp3300.obj" >> "b32.bc"
 echo ".\ordp3300.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:14:923
ECHO .ÿ
ECHO * (696/765) Compilando ordp3300.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:15:235
ECHO .ÿ
ECHO * (697/765) Compilando ordp3400.prg
 harbour.exe ".\ordp3400.prg" /q /o".\ordp3400.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:15:469
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp3400.obj" >> "b32.bc"
 echo ".\ordp3400.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:15:469
ECHO .ÿ
ECHO * (698/765) Compilando ordp3400.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:15:765
ECHO .ÿ
ECHO * (699/765) Compilando ordp3500.prg
 harbour.exe ".\ordp3500.prg" /q /o".\ordp3500.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:15:999
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp3500.obj" >> "b32.bc"
 echo ".\ordp3500.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:15:999
ECHO .ÿ
ECHO * (700/765) Compilando ordp3500.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:16:296
ECHO .ÿ
ECHO * (701/765) Compilando ordp4100.prg
 harbour.exe ".\ordp4100.prg" /q /o".\ordp4100.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:16:498
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordp4100.obj" >> "b32.bc"
 echo ".\ordp4100.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:16:498
ECHO .ÿ
ECHO * (702/765) Compilando ordp4100.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:16:779
ECHO .ÿ
ECHO * (703/765) Compilando ordpclor.prg
 harbour.exe ".\ordpclor.prg" /q /o".\ordpclor.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:17:029
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordpclor.obj" >> "b32.bc"
 echo ".\ordpclor.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:17:029
ECHO .ÿ
ECHO * (704/765) Compilando ordpclor.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:17:325
ECHO .ÿ
ECHO * (705/765) Compilando ordpfunc.prg
 harbour.exe ".\ordpfunc.prg" /q /o".\ordpfunc.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:17:559
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordpfunc.obj" >> "b32.bc"
 echo ".\ordpfunc.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:17:559
ECHO .ÿ
ECHO * (706/765) Compilando ordpfunc.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:17:856
ECHO .ÿ
ECHO * (707/765) Compilando ordpocap.prg
 harbour.exe ".\ordpocap.prg" /q /o".\ordpocap.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:18:105
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordpocap.obj" >> "b32.bc"
 echo ".\ordpocap.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:18:105
ECHO .ÿ
ECHO * (708/765) Compilando ordpocap.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:18:386
ECHO .ÿ
ECHO * (709/765) Compilando ordpocca.prg
 harbour.exe ".\ordpocca.prg" /q /o".\ordpocca.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:18:636
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordpocca.obj" >> "b32.bc"
 echo ".\ordpocca.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:18:636
ECHO .ÿ
ECHO * (710/765) Compilando ordpocca.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:18:932
ECHO .ÿ
ECHO * (711/765) Compilando ordpoci5.prg
 harbour.exe ".\ordpoci5.prg" /q /o".\ordpoci5.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:19:182
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordpoci5.obj" >> "b32.bc"
 echo ".\ordpoci5.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:19:182
ECHO .ÿ
ECHO * (712/765) Compilando ordpoci5.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:19:478
ECHO .ÿ
ECHO * (713/765) Compilando ordpocin.prg
 harbour.exe ".\ordpocin.prg" /q /o".\ordpocin.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:19:728
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordpocin.obj" >> "b32.bc"
 echo ".\ordpocin.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:19:728
ECHO .ÿ
ECHO * (714/765) Compilando ordpocin.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:20:008
ECHO .ÿ
ECHO * (715/765) Compilando ordpocix.prg
 harbour.exe ".\ordpocix.prg" /q /o".\ordpocix.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:20:258
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\ordpocix.obj" >> "b32.bc"
 echo ".\ordpocix.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:20:258
ECHO .ÿ
ECHO * (716/765) Compilando ordpocix.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:20:539
ECHO .ÿ
ECHO * (717/765) Compilando paractbf.prg
 harbour.exe ".\paractbf.prg" /q /o".\paractbf.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:20:773
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\paractbf.obj" >> "b32.bc"
 echo ".\paractbf.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:20:773
ECHO .ÿ
ECHO * (718/765) Compilando paractbf.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:21:069
ECHO .ÿ
ECHO * (719/765) Compilando paralinh.prg
 harbour.exe ".\paralinh.prg" /q /o".\paralinh.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:21:303
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\paralinh.obj" >> "b32.bc"
 echo ".\paralinh.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:21:303
ECHO .ÿ
ECHO * (720/765) Compilando paralinh.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:21:584
ECHO .ÿ
ECHO * (721/765) Compilando pexpo01.prg
 harbour.exe ".\pexpo01.prg" /q /o".\pexpo01.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:21:865
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\pexpo01.obj" >> "b32.bc"
 echo ".\pexpo01.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:21:865
ECHO .ÿ
ECHO * (722/765) Compilando pexpo01.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:22:161
ECHO .ÿ
ECHO * (723/765) Compilando pexpo01e.prg
 harbour.exe ".\pexpo01e.prg" /q /o".\pexpo01e.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:22:411
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\pexpo01e.obj" >> "b32.bc"
 echo ".\pexpo01e.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:22:411
ECHO .ÿ
ECHO * (724/765) Compilando pexpo01e.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:22:692
ECHO .ÿ
ECHO * (725/765) Compilando pexpo01s.prg
 harbour.exe ".\pexpo01s.prg" /q /o".\pexpo01s.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:22:926
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\pexpo01s.obj" >> "b32.bc"
 echo ".\pexpo01s.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:22:926
ECHO .ÿ
ECHO * (726/765) Compilando pexpo01s.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:23:212
ECHO .ÿ
ECHO * (727/765) Compilando pexpo02e.prg
 harbour.exe ".\pexpo02e.prg" /q /o".\pexpo02e.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:23:462
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\pexpo02e.obj" >> "b32.bc"
 echo ".\pexpo02e.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:23:462
ECHO .ÿ
ECHO * (728/765) Compilando pexpo02e.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:23:752
ECHO .ÿ
ECHO * (729/765) Compilando pexpo02s.prg
 harbour.exe ".\pexpo02s.prg" /q /o".\pexpo02s.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:23:992
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\pexpo02s.obj" >> "b32.bc"
 echo ".\pexpo02s.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:23:992
ECHO .ÿ
ECHO * (730/765) Compilando pexpo02s.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:24:272
ECHO .ÿ
ECHO * (731/765) Compilando pimp01.prg
 harbour.exe ".\pimp01.prg" /q /o".\pimp01.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:24:552
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\pimp01.obj" >> "b32.bc"
 echo ".\pimp01.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:24:552
ECHO .ÿ
ECHO * (732/765) Compilando pimp01.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:24:852
ECHO .ÿ
ECHO * (733/765) Compilando recibo.prg
 harbour.exe ".\recibo.prg" /q /o".\recibo.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:25:082
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\recibo.obj" >> "b32.bc"
 echo ".\recibo.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:25:082
ECHO .ÿ
ECHO * (734/765) Compilando recibo.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:25:362
ECHO .ÿ
ECHO * (735/765) Compilando sagpumi.prg
 harbour.exe ".\sagpumi.prg" /q /o".\sagpumi.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:25:622
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\sagpumi.obj" >> "b32.bc"
 echo ".\sagpumi.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:25:622
ECHO .ÿ
ECHO * (736/765) Compilando sagpumi.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:25:912
ECHO .ÿ
ECHO * (737/765) Compilando salvat.prg
 harbour.exe ".\salvat.prg" /q /o".\salvat.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:26:102
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\salvat.obj" >> "b32.bc"
 echo ".\salvat.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:26:102
ECHO .ÿ
ECHO * (738/765) Compilando salvat.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:26:382
ECHO .ÿ
ECHO * (739/765) Compilando sispexpo.prg
 harbour.exe ".\sispexpo.prg" /q /o".\sispexpo.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:26:662
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\sispexpo.obj" >> "b32.bc"
 echo ".\sispexpo.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:26:662
ECHO .ÿ
ECHO * (740/765) Compilando sispexpo.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:26:942
ECHO .ÿ
ECHO * (741/765) Compilando sispmsge.prg
 harbour.exe ".\sispmsge.prg" /q /o".\sispmsge.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:27:172
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\sispmsge.obj" >> "b32.bc"
 echo ".\sispmsge.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:27:172
ECHO .ÿ
ECHO * (742/765) Compilando sispmsge.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:27:462
ECHO .ÿ
ECHO * (743/765) Compilando sispmsgl.prg
 harbour.exe ".\sispmsgl.prg" /q /o".\sispmsgl.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:27:685
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\sispmsgl.obj" >> "b32.bc"
 echo ".\sispmsgl.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:27:685
ECHO .ÿ
ECHO * (744/765) Compilando sispmsgl.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:27:966
ECHO .ÿ
ECHO * (745/765) Compilando sped0000.prg
 harbour.exe ".\sped0000.prg" /q /o".\sped0000.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:28:247
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\sped0000.obj" >> "b32.bc"
 echo ".\sped0000.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:28:247
ECHO .ÿ
ECHO * (746/765) Compilando sped0000.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:28:543
ECHO .ÿ
ECHO * (747/765) Compilando sped1000.prg
 harbour.exe ".\sped1000.prg" /q /o".\sped1000.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:28:777
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\sped1000.obj" >> "b32.bc"
 echo ".\sped1000.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:28:793
ECHO .ÿ
ECHO * (748/765) Compilando sped1000.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:29:074
ECHO .ÿ
ECHO * (749/765) Compilando sped9000.prg
 harbour.exe ".\sped9000.prg" /q /o".\sped9000.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:29:308
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\sped9000.obj" >> "b32.bc"
 echo ".\sped9000.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:29:308
ECHO .ÿ
ECHO * (750/765) Compilando sped9000.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:29:604
ECHO .ÿ
ECHO * (751/765) Compilando spedc000.prg
 harbour.exe ".\spedc000.prg" /q /o".\spedc000.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:29:854
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\spedc000.obj" >> "b32.bc"
 echo ".\spedc000.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:29:854
ECHO .ÿ
ECHO * (752/765) Compilando spedc000.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:30:150
ECHO .ÿ
ECHO * (753/765) Compilando spedc00f.prg
 harbour.exe ".\spedc00f.prg" /q /o".\spedc00f.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:30:400
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\spedc00f.obj" >> "b32.bc"
 echo ".\spedc00f.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:30:400
ECHO .ÿ
ECHO * (754/765) Compilando spedc00f.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:30:696
ECHO .ÿ
ECHO * (755/765) Compilando spedd000.prg
 harbour.exe ".\spedd000.prg" /q /o".\spedd000.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:30:914
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\spedd000.obj" >> "b32.bc"
 echo ".\spedd000.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:30:914
ECHO .ÿ
ECHO * (756/765) Compilando spedd000.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:31:195
ECHO .ÿ
ECHO * (757/765) Compilando spede000.prg
 harbour.exe ".\spede000.prg" /q /o".\spede000.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:31:414
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\spede000.obj" >> "b32.bc"
 echo ".\spede000.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:31:414
ECHO .ÿ
ECHO * (758/765) Compilando spede000.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:31:710
ECHO .ÿ
ECHO * (759/765) Compilando spedg000.prg
 harbour.exe ".\spedg000.prg" /q /o".\spedg000.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:31:928
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\spedg000.obj" >> "b32.bc"
 echo ".\spedg000.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:31:928
ECHO .ÿ
ECHO * (760/765) Compilando spedg000.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:32:194
ECHO .ÿ
ECHO * (761/765) Compilando spedh000.prg
 harbour.exe ".\spedh000.prg" /q /o".\spedh000.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:32:443
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\spedh000.obj" >> "b32.bc"
 echo ".\spedh000.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:32:443
ECHO .ÿ
ECHO * (762/765) Compilando spedh000.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(97) @ 16:58:32:724
ECHO .ÿ
ECHO * (763/765) Compilando xxsenha.prg
 harbour.exe ".\xxsenha.prg" /q /o".\xxsenha.c"   /M  /N -DxHB 
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(138) @ 16:58:32:958
 echo  -DxHB  > "b32.bc"
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" >> "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" >> "b32.bc"
 echo -o".\xxsenha.obj" >> "b32.bc"
 echo ".\xxsenha.c" >> "b32.bc"

REM - Harbour.xCompiler.prg(139) @ 16:58:32:958
ECHO .ÿ
ECHO * (764/765) Compilando xxsenha.c
 BCC32 -M -c @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

REM - Harbour.xCompiler.prg(285) @ 16:58:33:800
 echo -I"C:\xharbour\include;C:\bcc582\include;;C:\xharbour\include;C:\bcc582\include" + > "b32.bc"
 echo -L"C:\xharbour\lib;C:\bcc582\lib;C:\bcc582\lib\psdk;;C:\xharbour\lib;C:\bcc582\lib;C:\xharbour\include;C:\bcc582\include;;C:\xharbour\lib;C:\bcc582\lib" + >> "b32.bc"
 echo -Gn -M -m  -Tpe -s + >> "b32.bc"
 echo c0w32.obj +     >> "b32.bc"
 echo ".\cfe.obj"  +  >> "b32.bc"
 echo ".\cfep0000.obj"  +  >> "b32.bc"
 echo ".\cfep0001.obj"  +  >> "b32.bc"
 echo ".\cfep0002.obj"  +  >> "b32.bc"
 echo ".\cfep43co.obj"  +  >> "b32.bc"
 echo ".\cfep44c0.obj"  +  >> "b32.bc"
 echo ".\cfep310t.obj"  +  >> "b32.bc"
 echo ".\cfep310x.obj"  +  >> "b32.bc"
 echo ".\cfep441e.obj"  +  >> "b32.bc"
 echo ".\cfep441g.obj"  +  >> "b32.bc"
 echo ".\cfep441i.obj"  +  >> "b32.bc"
 echo ".\cfep441p.obj"  +  >> "b32.bc"
 echo ".\cfep441x.obj"  +  >> "b32.bc"
 echo ".\cfep510o.obj"  +  >> "b32.bc"
 echo ".\cfep520g.obj"  +  >> "b32.bc"
 echo ".\cfep1410.obj"  +  >> "b32.bc"
 echo ".\cfep1420.obj"  +  >> "b32.bc"
 echo ".\cfep1430.obj"  +  >> "b32.bc"
 echo ".\cfep1440.obj"  +  >> "b32.bc"
 echo ".\cfep1500.obj"  +  >> "b32.bc"
 echo ".\cfep1600.obj"  +  >> "b32.bc"
 echo ".\cfep2100.obj"  +  >> "b32.bc"
 echo ".\cfep2210.obj"  +  >> "b32.bc"
 echo ".\cfep2211.obj"  +  >> "b32.bc"
 echo ".\cfep2220.obj"  +  >> "b32.bc"
 echo ".\cfep2311.obj"  +  >> "b32.bc"
 echo ".\cfep2312.obj"  +  >> "b32.bc"
 echo ".\cfep2313.obj"  +  >> "b32.bc"
 echo ".\cfep2322.obj"  +  >> "b32.bc"
 echo ".\cfep2411.obj"  +  >> "b32.bc"
 echo ".\cfep2500.obj"  +  >> "b32.bc"
 echo ".\cfep3100.obj"  +  >> "b32.bc"
 echo ".\cfep3105.obj"  +  >> "b32.bc"
 echo ".\cfep3210.obj"  +  >> "b32.bc"
 echo ".\cfep4100.obj"  +  >> "b32.bc"
 echo ".\cfep4200.obj"  +  >> "b32.bc"
 echo ".\cfep4206.obj"  +  >> "b32.bc"
 echo ".\cfep4311.obj"  +  >> "b32.bc"
 echo ".\cfep4312.obj"  +  >> "b32.bc"
 echo ".\cfep4313.obj"  +  >> "b32.bc"
 echo ".\cfep4314.obj"  +  >> "b32.bc"
 echo ".\cfep4321.obj"  +  >> "b32.bc"
 echo ".\cfep4331.obj"  +  >> "b32.bc"
 echo ".\cfep4340.obj"  +  >> "b32.bc"
 echo ".\cfep4341.obj"  +  >> "b32.bc"
 echo ".\cfep4342.obj"  +  >> "b32.bc"
 echo ".\cfep4350.obj"  +  >> "b32.bc"
 echo ".\cfep4361.obj"  +  >> "b32.bc"
 echo ".\cfep4362.obj"  +  >> "b32.bc"
 echo ".\cfep4370.obj"  +  >> "b32.bc"
 echo ".\cfep4380.obj"  +  >> "b32.bc"
 echo ".\cfep4390.obj"  +  >> "b32.bc"
 echo ".\cfep4410.obj"  +  >> "b32.bc"
 echo ".\cfep4413.obj"  +  >> "b32.bc"
 echo ".\cfep4414.obj"  +  >> "b32.bc"
 echo ".\cfep4415.obj"  +  >> "b32.bc"
 echo ".\cfep4420.obj"  +  >> "b32.bc"
 echo ".\cfep4430.obj"  +  >> "b32.bc"
 echo ".\cfep4440.obj"  +  >> "b32.bc"
 echo ".\cfep4450.obj"  +  >> "b32.bc"
 echo ".\cfep4460.obj"  +  >> "b32.bc"
 echo ".\cfep4500.obj"  +  >> "b32.bc"
 echo ".\cfep4510.obj"  +  >> "b32.bc"
 echo ".\cfep4520.obj"  +  >> "b32.bc"
 echo ".\cfep4530.obj"  +  >> "b32.bc"
 echo ".\cfep5100.obj"  +  >> "b32.bc"
 echo ".\cfep5102.obj"  +  >> "b32.bc"
 echo ".\cfep5103.obj"  +  >> "b32.bc"
 echo ".\cfep5104.obj"  +  >> "b32.bc"
 echo ".\cfep5105.obj"  +  >> "b32.bc"
 echo ".\cfep5110.obj"  +  >> "b32.bc"
 echo ".\cfep5200.obj"  +  >> "b32.bc"
 echo ".\cfep5204.obj"  +  >> "b32.bc"
 echo ".\cfep5205.obj"  +  >> "b32.bc"
 echo ".\cfep5300.obj"  +  >> "b32.bc"
 echo ".\cfep5400.obj"  +  >> "b32.bc"
 echo ".\cfep5500.obj"  +  >> "b32.bc"
 echo ".\cfep5600.obj"  +  >> "b32.bc"
 echo ".\cfep5610.obj"  +  >> "b32.bc"
 echo ".\cfep5620.obj"  +  >> "b32.bc"
 echo ".\cfep5630.obj"  +  >> "b32.bc"
 echo ".\cfep5640.obj"  +  >> "b32.bc"
 echo ".\cfep5700.obj"  +  >> "b32.bc"
 echo ".\cfep6100.obj"  +  >> "b32.bc"
 echo ".\cfep6300.obj"  +  >> "b32.bc"
 echo ".\cfep6400.obj"  +  >> "b32.bc"
 echo ".\cfep6500.obj"  +  >> "b32.bc"
 echo ".\cfep7100.obj"  +  >> "b32.bc"
 echo ".\cfep7210.obj"  +  >> "b32.bc"
 echo ".\cfep7220.obj"  +  >> "b32.bc"
 echo ".\cfep7230.obj"  +  >> "b32.bc"
 echo ".\cfep7240.obj"  +  >> "b32.bc"
 echo ".\cfep7300.obj"  +  >> "b32.bc"
 echo ".\cfep7500.obj"  +  >> "b32.bc"
 echo ".\cfep7600.obj"  +  >> "b32.bc"
 echo ".\cfepabre.obj"  +  >> "b32.bc"
 echo ".\cfepatnf.obj"  +  >> "b32.bc"
 echo ".\cfepcart.obj"  +  >> "b32.bc"
 echo ".\cfepcccf.obj"  +  >> "b32.bc"
 echo ".\cfepcccs.obj"  +  >> "b32.bc"
 echo ".\cfepcctb.obj"  +  >> "b32.bc"
 echo ".\cfepcdtr.obj"  +  >> "b32.bc"
 echo ".\cfepcf00.obj"  +  >> "b32.bc"
 echo ".\cfepcf01.obj"  +  >> "b32.bc"
 echo ".\cfepcfaf.obj"  +  >> "b32.bc"
 echo ".\cfepcfcc.obj"  +  >> "b32.bc"
 echo ".\cfepcfhv.obj"  +  >> "b32.bc"
 echo ".\cfepcfim.obj"  +  >> "b32.bc"
 echo ".\cfepcflf.obj"  +  >> "b32.bc"
 echo ".\cfepcflx.obj"  +  >> "b32.bc"
 echo ".\cfepcfmm.obj"  +  >> "b32.bc"
 echo ".\cfepcfrz.obj"  +  >> "b32.bc"
 echo ".\cfepcftr.obj"  +  >> "b32.bc"
 echo ".\cfepclcv.obj"  +  >> "b32.bc"
 echo ".\cfepclet.obj"  +  >> "b32.bc"
 echo ".\cfepcodi.obj"  +  >> "b32.bc"
 echo ".\cfepcomc.obj"  +  >> "b32.bc"
 echo ".\cfepcons.obj"  +  >> "b32.bc"
 echo ".\cfepcp01.obj"  +  >> "b32.bc"
 echo ".\cfepcria.obj"  +  >> "b32.bc"
 echo ".\cfepcsfo.obj"  +  >> "b32.bc"
 echo ".\cfepcspr.obj"  +  >> "b32.bc"
 echo ".\cfepdscp.obj"  +  >> "b32.bc"
 echo ".\cfepdvcp.obj"  +  >> "b32.bc"
 echo ".\cfepedar.obj"  +  >> "b32.bc"
 echo ".\cfepedec.obj"  +  >> "b32.bc"
 echo ".\cfepeded.obj"  +  >> "b32.bc"
 echo ".\cfepednf.obj"  +  >> "b32.bc"
 echo ".\cfepedpc.obj"  +  >> "b32.bc"
 echo ".\cfepedpd.obj"  +  >> "b32.bc"
 echo ".\cfepenge.obj"  +  >> "b32.bc"
 echo ".\cfepengm.obj"  +  >> "b32.bc"
 echo ".\cfepengp.obj"  +  >> "b32.bc"
 echo ".\cfepevcp.obj"  +  >> "b32.bc"
 echo ".\cfepexpr.obj"  +  >> "b32.bc"
 echo ".\cfepext1.obj"  +  >> "b32.bc"
 echo ".\cfepext2.obj"  +  >> "b32.bc"
 echo ".\cfepextr.obj"  +  >> "b32.bc"
 echo ".\cfepfar0.obj"  +  >> "b32.bc"
 echo ".\cfepfar2.obj"  +  >> "b32.bc"
 echo ".\cfepfar3.obj"  +  >> "b32.bc"
 echo ".\cfepfar4.obj"  +  >> "b32.bc"
 echo ".\cfepflux.obj"  +  >> "b32.bc"
 echo ".\cfepfun1.obj"  +  >> "b32.bc"
 echo ".\cfepfunc.obj"  +  >> "b32.bc"
 echo ".\cfepiecp.obj"  +  >> "b32.bc"
 echo ".\cfepimnf.obj"  +  >> "b32.bc"
 echo ".\cfepind1.obj"  +  >> "b32.bc"
 echo ".\cfepind2.obj"  +  >> "b32.bc"
 echo ".\cfepindi.obj"  +  >> "b32.bc"
 echo ".\cfepinit.obj"  +  >> "b32.bc"
 echo ".\cfepl1cp.obj"  +  >> "b32.bc"
 echo ".\cfeplien.obj"  +  >> "b32.bc"
 echo ".\cfeplipi.obj"  +  >> "b32.bc"
 echo ".\cfeplird.obj"  +  >> "b32.bc"
 echo ".\cfeplisa.obj"  +  >> "b32.bc"
 echo ".\cfepmeli.obj"  +  >> "b32.bc"
 echo ".\cfepnato.obj"  +  >> "b32.bc"
 echo ".\cfepnoim.obj"  +  >> "b32.bc"
 echo ".\cfeppddr.obj"  +  >> "b32.bc"
 echo ".\cfeppecl.obj"  +  >> "b32.bc"
 echo ".\cfeppnfe.obj"  +  >> "b32.bc"
 echo ".\cfepra01.obj"  +  >> "b32.bc"
 echo ".\cfepra02.obj"  +  >> "b32.bc"
 echo ".\cfepra11.obj"  +  >> "b32.bc"
 echo ".\cfepra12.obj"  +  >> "b32.bc"
 echo ".\cfepra15.obj"  +  >> "b32.bc"
 echo ".\cfepraht.obj"  +  >> "b32.bc"
 echo ".\cfepramn.obj"  +  >> "b32.bc"
 echo ".\cfeprcpg.obj"  +  >> "b32.bc"
 echo ".\cfeprecf.obj"  +  >> "b32.bc"
 echo ".\cfeprecp.obj"  +  >> "b32.bc"
 echo ".\cfeprped.obj"  +  >> "b32.bc"
 echo ".\cfeprven.obj"  +  >> "b32.bc"
 echo ".\cfeprvfi.obj"  +  >> "b32.bc"
 echo ".\cfepsald.obj"  +  >> "b32.bc"
 echo ".\cfepspcc.obj"  +  >> "b32.bc"
 echo ".\cfepspcr.obj"  +  >> "b32.bc"
 echo ".\cfeptaen.obj"  +  >> "b32.bc"
 echo ".\cfeptard.obj"  +  >> "b32.bc"
 echo ".\cfeptasa.obj"  +  >> "b32.bc"
 echo ".\cfeptran.obj"  +  >> "b32.bc"
 echo ".\cfeptrnf.obj"  +  >> "b32.bc"
 echo ".\cfepun.obj"  +  >> "b32.bc"
 echo ".\cfepunf.obj"  +  >> "b32.bc"
 echo ".\cfepvano.obj"  +  >> "b32.bc"
 echo ".\cfepveba.obj"  +  >> "b32.bc"
 echo ".\cfepvebb.obj"  +  >> "b32.bc"
 echo ".\cfepvebc.obj"  +  >> "b32.bc"
 echo ".\cfepvebd.obj"  +  >> "b32.bc"
 echo ".\cfepvebe.obj"  +  >> "b32.bc"
 echo ".\cfepvebx.obj"  +  >> "b32.bc"
 echo ".\cfepvend.obj"  +  >> "b32.bc"
 echo ".\cheque.obj"  +  >> "b32.bc"
 echo ".\codigos.obj"  +  >> "b32.bc"
 echo ".\copiames.obj"  +  >> "b32.bc"
 echo ".\cotaasso.obj"  +  >> "b32.bc"
 echo ".\cotabaix.obj"  +  >> "b32.bc"
 echo ".\cotacria.obj"  +  >> "b32.bc"
 echo ".\cotaedit.obj"  +  >> "b32.bc"
 echo ".\cotainte.obj"  +  >> "b32.bc"
 echo ".\cotamovi.obj"  +  >> "b32.bc"
 echo ".\cotapara.obj"  +  >> "b32.bc"
 echo ".\cotasald.obj"  +  >> "b32.bc"
 echo ".\ctbcadld.obj"  +  >> "b32.bc"
 echo ".\ctbgerld.obj"  +  >> "b32.bc"
 echo ".\ctbp1110.obj"  +  >> "b32.bc"
 echo ".\ctbp1120.obj"  +  >> "b32.bc"
 echo ".\ctbp1130.obj"  +  >> "b32.bc"
 echo ".\ctbp1140.obj"  +  >> "b32.bc"
 echo ".\ctbp1150.obj"  +  >> "b32.bc"
 echo ".\ctbp1210.obj"  +  >> "b32.bc"
 echo ".\ctbp1220.obj"  +  >> "b32.bc"
 echo ".\ctbp1230.obj"  +  >> "b32.bc"
 echo ".\ctbp1240.obj"  +  >> "b32.bc"
 echo ".\ctbp1250.obj"  +  >> "b32.bc"
 echo ".\ctbp1260.obj"  +  >> "b32.bc"
 echo ".\ctbp1310.obj"  +  >> "b32.bc"
 echo ".\ctbp1320.obj"  +  >> "b32.bc"
 echo ".\ctbp1330.obj"  +  >> "b32.bc"
 echo ".\ctbp1340.obj"  +  >> "b32.bc"
 echo ".\ctbpcria.obj"  +  >> "b32.bc"
 echo ".\ctbpdesa.obj"  +  >> "b32.bc"
 echo ".\ctbpence.obj"  +  >> "b32.bc"
 echo ".\ctbpfili.obj"  +  >> "b32.bc"
 echo ".\ctbpfunc.obj"  +  >> "b32.bc"
 echo ".\ctbpidia.obj"  +  >> "b32.bc"
 echo ".\ctbpimen.obj"  +  >> "b32.bc"
 echo ".\ctbpimfa.obj"  +  >> "b32.bc"
 echo ".\ctbpimlo.obj"  +  >> "b32.bc"
 echo ".\ctbpincf.obj"  +  >> "b32.bc"
 echo ".\ctbpinte.obj"  +  >> "b32.bc"
 echo ".\ctbplimp.obj"  +  >> "b32.bc"
 echo ".\ctbpmetr.obj"  +  >> "b32.bc"
 echo ".\ctrpsuin.obj"  +  >> "b32.bc"
 echo ".\cxap0001.obj"  +  >> "b32.bc"
 echo ".\cxap0002.obj"  +  >> "b32.bc"
 echo ".\cxap0003.obj"  +  >> "b32.bc"
 echo ".\cxap0004.obj"  +  >> "b32.bc"
 echo ".\cxap9999.obj"  +  >> "b32.bc"
 echo ".\cxapadt.obj"  +  >> "b32.bc"
 echo ".\cxapadtx.obj"  +  >> "b32.bc"
 echo ".\cxapalte.obj"  +  >> "b32.bc"
 echo ".\cxapbcl1.obj"  +  >> "b32.bc"
 echo ".\cxapcdgr.obj"  +  >> "b32.bc"
 echo ".\cxapcria.obj"  +  >> "b32.bc"
 echo ".\cxapdesp.obj"  +  >> "b32.bc"
 echo ".\cxapedmb.obj"  +  >> "b32.bc"
 echo ".\cxapintc.obj"  +  >> "b32.bc"
 echo ".\cxapinte.obj"  +  >> "b32.bc"
 echo ".\cxaplidi.obj"  +  >> "b32.bc"
 echo ".\cxapligr.obj"  +  >> "b32.bc"
 echo ".\cxappara.obj"  +  >> "b32.bc"
 echo ".\cxappre.obj"  +  >> "b32.bc"
 echo ".\cxapsald.obj"  +  >> "b32.bc"
 echo ".\cxaptrac.obj"  +  >> "b32.bc"
 echo ".\expcfe.obj"  +  >> "b32.bc"
 echo ".\expsql.obj"  +  >> "b32.bc"
 echo ".\fatpcdcp.obj"  +  >> "b32.bc"
 echo ".\fatpcria.obj"  +  >> "b32.bc"
 echo ".\fatpdcf.obj"  +  >> "b32.bc"
 echo ".\fatpdcfx.obj"  +  >> "b32.bc"
 echo ".\fatpdest.obj"  +  >> "b32.bc"
 echo ".\fatpgrpe.obj"  +  >> "b32.bc"
 echo ".\fatplote.obj"  +  >> "b32.bc"
 echo ".\fatppis.obj"  +  >> "b32.bc"
 echo ".\fatpsvc.obj"  +  >> "b32.bc"
 echo ".\fisato15.obj"  +  >> "b32.bc"
 echo ".\fisp0001.obj"  +  >> "b32.bc"
 echo ".\fisp0002.obj"  +  >> "b32.bc"
 echo ".\fisp0003.obj"  +  >> "b32.bc"
 echo ".\fisp0004.obj"  +  >> "b32.bc"
 echo ".\fisp0005.obj"  +  >> "b32.bc"
 echo ".\fisp0006.obj"  +  >> "b32.bc"
 echo ".\fispcfis.obj"  +  >> "b32.bc"
 echo ".\fispcof.obj"  +  >> "b32.bc"
 echo ".\fispcofr.obj"  +  >> "b32.bc"
 echo ".\fispcria.obj"  +  >> "b32.bc"
 echo ".\fispdief.obj"  +  >> "b32.bc"
 echo ".\fispnfeg.obj"  +  >> "b32.bc"
 echo ".\fispnfep.obj"  +  >> "b32.bc"
 echo ".\fispobs.obj"  +  >> "b32.bc"
 echo ".\fn_abrex.obj"  +  >> "b32.bc"
 echo ".\fn_arqs.obj"  +  >> "b32.bc"
 echo ".\fn_cliob.obj"  +  >> "b32.bc"
 echo ".\fn_codar.obj"  +  >> "b32.bc"
 echo ".\fn_codfc.obj"  +  >> "b32.bc"
 echo ".\fn_codpr.obj"  +  >> "b32.bc"
 echo ".\fn_consp.obj"  +  >> "b32.bc"
 echo ".\fn_edvlr.obj"  +  >> "b32.bc"
 echo ".\fn_edvlx.obj"  +  >> "b32.bc"
 echo ".\fn_elimi.obj"  +  >> "b32.bc"
 echo ".\fn_gravm.obj"  +  >> "b32.bc"
 echo ".\fn_grnf.obj"  +  >> "b32.bc"
 echo ".\fn_impca.obj"  +  >> "b32.bc"
 echo ".\fn_mkdel.obj"  +  >> "b32.bc"
 echo ".\fn_msdpl.obj"  +  >> "b32.bc"
 echo ".\fn_pack.obj"  +  >> "b32.bc"
 echo ".\fn_parc.obj"  +  >> "b32.bc"
 echo ".\fn_parc1.obj"  +  >> "b32.bc"
 echo ".\fn_recno.obj"  +  >> "b32.bc"
 echo ".\fn_vlven.obj"  +  >> "b32.bc"
 echo ".\gdfpcfee.obj"  +  >> "b32.bc"
 echo ".\gdfpcfes.obj"  +  >> "b32.bc"
 echo ".\gdfpcfre.obj"  +  >> "b32.bc"
 echo ".\gdfpgera.obj"  +  >> "b32.bc"
 echo ".\gdfppr60.obj"  +  >> "b32.bc"
 echo ".\gdfpprep.obj"  +  >> "b32.bc"
 echo ".\gdfpsag.obj"  +  >> "b32.bc"
 echo ".\ie_ok.obj"  +  >> "b32.bc"
 echo ".\import.obj"  +  >> "b32.bc"
 echo ".\invdigit.obj"  +  >> "b32.bc"
 echo ".\invelim.obj"  +  >> "b32.bc"
 echo ".\invexpor.obj"  +  >> "b32.bc"
 echo ".\leit001.obj"  +  >> "b32.bc"
 echo ".\leitep00.obj"  +  >> "b32.bc"
 echo ".\leitep01.obj"  +  >> "b32.bc"
 echo ".\leitep02.obj"  +  >> "b32.bc"
 echo ".\leitep03.obj"  +  >> "b32.bc"
 echo ".\leitep04.obj"  +  >> "b32.bc"
 echo ".\leitep05.obj"  +  >> "b32.bc"
 echo ".\leitep06.obj"  +  >> "b32.bc"
 echo ".\leitep07.obj"  +  >> "b32.bc"
 echo ".\leitep10.obj"  +  >> "b32.bc"
 echo ".\leitep20.obj"  +  >> "b32.bc"
 echo ".\libacess.obj"  +  >> "b32.bc"
 echo ".\libgdf.obj"  +  >> "b32.bc"
 echo ".\limpahis.obj"  +  >> "b32.bc"
 echo ".\livros0.obj"  +  >> "b32.bc"
 echo ".\livrosg.obj"  +  >> "b32.bc"
 echo ".\livrosi.obj"  +  >> "b32.bc"
 echo ".\livrosts.obj"  +  >> "b32.bc"
 echo ".\lotealoj.obj"  +  >> "b32.bc"
 echo ".\masc.obj"  +  >> "b32.bc"
 echo ".\ordp0000.obj"  +  >> "b32.bc"
 echo ".\ordp1100.obj"  +  >> "b32.bc"
 echo ".\ordp1200.obj"  +  >> "b32.bc"
 echo ".\ordp1300.obj"  +  >> "b32.bc"
 echo ".\ordp1400.obj"  +  >> "b32.bc"
 echo ".\ordp1500.obj"  +  >> "b32.bc"
 echo ".\ordp2100.obj"  +  >> "b32.bc"
 echo ".\ordp2105.obj"  +  >> "b32.bc"
 echo ".\ordp2200.obj"  +  >> "b32.bc"
 echo ".\ordp2300.obj"  +  >> "b32.bc"
 echo ".\ordp2400.obj"  +  >> "b32.bc"
 echo ".\ordp3100.obj"  +  >> "b32.bc"
 echo ".\ordp3200.obj"  +  >> "b32.bc"
 echo ".\ordp3300.obj"  +  >> "b32.bc"
 echo ".\ordp3400.obj"  +  >> "b32.bc"
 echo ".\ordp3500.obj"  +  >> "b32.bc"
 echo ".\ordp4100.obj"  +  >> "b32.bc"
 echo ".\ordpclor.obj"  +  >> "b32.bc"
 echo ".\ordpfunc.obj"  +  >> "b32.bc"
 echo ".\ordpocap.obj"  +  >> "b32.bc"
 echo ".\ordpocca.obj"  +  >> "b32.bc"
 echo ".\ordpoci5.obj"  +  >> "b32.bc"
 echo ".\ordpocin.obj"  +  >> "b32.bc"
 echo ".\ordpocix.obj"  +  >> "b32.bc"
 echo ".\paractbf.obj"  +  >> "b32.bc"
 echo ".\paralinh.obj"  +  >> "b32.bc"
 echo ".\pexpo01.obj"  +  >> "b32.bc"
 echo ".\pexpo01e.obj"  +  >> "b32.bc"
 echo ".\pexpo01s.obj"  +  >> "b32.bc"
 echo ".\pexpo02e.obj"  +  >> "b32.bc"
 echo ".\pexpo02s.obj"  +  >> "b32.bc"
 echo ".\pimp01.obj"  +  >> "b32.bc"
 echo ".\recibo.obj"  +  >> "b32.bc"
 echo ".\sagpumi.obj"  +  >> "b32.bc"
 echo ".\salvat.obj"  +  >> "b32.bc"
 echo ".\sispexpo.obj"  +  >> "b32.bc"
 echo ".\sispmsge.obj"  +  >> "b32.bc"
 echo ".\sispmsgl.obj"  +  >> "b32.bc"
 echo ".\sped0000.obj"  +  >> "b32.bc"
 echo ".\sped1000.obj"  +  >> "b32.bc"
 echo ".\sped9000.obj"  +  >> "b32.bc"
 echo ".\spedc000.obj"  +  >> "b32.bc"
 echo ".\spedc00f.obj"  +  >> "b32.bc"
 echo ".\spedd000.obj"  +  >> "b32.bc"
 echo ".\spede000.obj"  +  >> "b32.bc"
 echo ".\spedg000.obj"  +  >> "b32.bc"
 echo ".\spedh000.obj"  +  >> "b32.bc"
 echo ".\xxsenha.obj", +  >> "b32.bc"
 echo ".\_xCFE.EXE", +    >> "b32.bc"
 echo ".\_xCFE.map", +    >> "b32.bc"
 echo lang.lib +      >> "b32.bc"
 echo vm.lib +        >> "b32.bc"
 echo rtl.lib +       >> "b32.bc"
 echo rdd.lib +       >> "b32.bc"
 echo macro.lib +     >> "b32.bc"
 echo pp.lib +        >> "b32.bc"
 echo dbfntx.lib +    >> "b32.bc"
 echo bcc640.lib +    >> "b32.bc"
 echo dbffpt.lib +    >> "b32.bc"
 echo common.lib +    >> "b32.bc"
 echo gtwin.lib +  >> "b32.bc"
 echo codepage.lib +  >> "b32.bc"
 echo ct.lib +     >> "b32.bc"
 echo tip.lib +     >> "b32.bc"
 echo hsx.lib +     >> "b32.bc"
 echo pcrepos.lib +     >> "b32.bc"
 echo hbsix.lib +     >> "b32.bc"
 echo cw32.lib +      >> "b32.bc"
 echo import32.lib +  >> "b32.bc"
 echo rasapi32.lib + >> "b32.bc"
 echo nddeapi.lib + >> "b32.bc"
 echo iphlpapi.lib + >> "b32.bc"
 echo , >> "b32.bc"

REM - Harbour.xCompiler.prg(286) @ 16:58:33:816
ECHO .ÿ
ECHO * (765/765) Linkando _xCFE.EXE
 ILINK32 @B32.BC
 IF ERRORLEVEL 1 GOTO FIM

:FIM
 ECHO Fim do script de compilacao!
