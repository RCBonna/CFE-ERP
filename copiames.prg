*-----------------------------------------------------------------------------*
 static aVariav:= {'',{},{},''}
 //.................1. 2..3..4
*-----------------------------------------------------------------------------*
#xtranslate cArqZip    => aVariav\[  1 \]
#xtranslate aFileGra   => aVariav\[  2 \]
#xtranslate aFileDir   => aVariav\[  3 \]

*------------------------------------------------------------------------------------
#include 'RCB.CH'

function COPIAMES(ANOMES,pDirDest)
*------------------------------------------------------------------------------------
	DirMake(  trim(pDirDest))
	cArqZip :=trim(pDirDest) + '\' + ANOMES + '.ZIP'
	aFileDir:=Directory('.\*.*')
	aFileGra:={}
	if len(aFileDir)>0
		AEval(aFileDir,{|DET|if(OrdBagExt()$DET[1],'',aadd(aFileGra,DET[1]))})
		hb_zipfile(cArqZip,aFileGra,9,,.T.,'[CFE]',.T.,.F.)
	else
		Alert('Arquivos nao encontrados em '+pDirDest)
	end
return NIL
*---------------------------------------------EOF------------------------------------
