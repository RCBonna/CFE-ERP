//-----------------------------------------------------------------------------*
  static aVariav := {0,.f.,{},0,'',0,"","",{}}
//...................................................................1......2........3........4.....5......6.....7......8...9
//-----------------------------------------------------------------------------*
#xtranslate nX      => aVariav\[  1 \]
#xtranslate lX      => aVariav\[  2 \]
#xtranslate nX1	  => aVariav\[  3 \]
#xtranslate nY      => aVariav\[  4 \]
#xtranslate cArqExc => aVariav\[  5 \]
#xtranslate nX2	  => aVariav\[  6 \]
#xtranslate cCPO	  => aVariav\[  7 \]
#xtranslate cSBRA	  => aVariav\[  8 \]
#xtranslate aARRS	  => aVariav\[  9 \]

*-----------------------------------------------------------------------------*
 function EXPSQL()
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local  aArquivos:={}
private aArqDBF :={}
cSBRA:=""


aARRS:={	{"+",				","},;
			{"STR(",			""},;
			{"STR (",		""},;
			{"DTOS(",		""},;
			{"DTOS (",		""},;
			{"UPPER(",		""},;
			{"UPPER( ",		""},;
			{"DESCEND(",	""},;
			{"DESCEND( ",	""},;
			{",RECNO(),7)",""},;
			{",L_P)",		""},;
			{",6,2)",		""},;
			{",6,3)",		""},;
			{",1)",			""},;
			{",2)",			""},;
			{",3)",			""},;
			{",4)",			""},;
			{",5)",			""},;
			{",6)",			""},;
			{",7)",			""},;
			{",8)",			""},;
			{",9)",			""},;
			{",10)",			""},;
			{" ,)",			","},;
			{")",				""};
		}
for nX:=0 to 31
	cSBRA+=chr(nX)
end

cArqExc:=lower('CFEAP1 COPIA HELP GDF60S GDFBAS LIVRO MOVBOL PARALINH SENHAINT SERIE ORDAOR')

pb_tela()
pb_lin4(_MSG_,ProcName())
pb_box(10,10)
close all
dInPut    :="c:\prg\prg\cfe"+space(30)
dOutPut   :="c:\prg\prg\cfeexsql.sql"+space(20)
nRegistros:=500000

@11,12 say "Diretorio pesquisa........:" get dInPut     pict mUUU when pb_msg('Nao colocar \ no fim do diretorio')
@12,12 say "Diretorio saida+nome saida:" get dOutPut    picT mUUU
@13,12 say "Nro Registro Exportar.....:" get nRegistros pict mI6 valid nRegistros >= 1
read
dInPut:=trim(dInPut)
dOutPut:=trim(dOutPut)
//if if(lastkey()--K_ESC, pb_sn("Iniciar busca em;"+dInPut), .F.)
if if(lastkey()#K_ESC, pb_ligaimp(,dOutPut),.f.)
	aArquivos   := Directory( dInPut+"\*.dbf", "D" )
	aEval(aArquivos,{ |DET| AAdd(aArqDBF, lower(alltrim(DET[ 1 ])))})
	@14,12 say "Arq.Existentes..:"+str(len(aArqDBF),3)
	@15,12 say CurDir()
	
	pb_msg('Exportando... aguarde..')
	??"-- exportacao dos arquivos do SISTEMA CFE PARA IMPORTACAO EM SQL "+ DTOC(DATE())+" AS "+TIME()
	for nX:=1 to len(aArqDBF)
		@17,12 say 'Exportando......'+padr(aArqDBF[nX],20)
		EXPSQLDBF(SubStr(aArqDBF[nX],1,len(aArqDBF[nX])-4))
	next
	pb_deslimp(,.F.,.F.)
end
alert("Exportacao Concluida")
return NIL

//EXPORTAR OS DADOS

function EXPSQLDBF(pArquivo)
if lower(pArquivo) $ cArqExc // não exportar estes.
	return NIL
end
dbUseArea(.T.,RDDSETDEFAULT(),pArquivo,'DBFGERAL',!SHARED)
if !NetErr()
	if file(pArquivo+OrdBagExt())
		dbsetindex(pArquivo)
	end
	?
	?"--"
	?"-- ------------------------------------TABELA: "+pArquivo+""
	?"--"
	for nY:=1 to FCount()
		?'-- '+str(nY,3)+" "+padr(FieldName(nY),12)+" "+FieldType(nY)+" "+str(FieldSize(nY),4)+" "+str(FieldDeci(nY),2)
	next
	?
//	?"LOCK TABLES `"+pArquivo+"` WRITE;"
	
	?"DROP TABLE IF EXISTS  `"+pArquivo+"`;"
	?"CREATE TABLE `"+pArquivo+"` ("
	?"   `ID` BIGINT AUTO_INCREMENT, PRIMARY KEY(ID),"
	for nY:=1 to FCount()
		?  "   `"+padr(FieldName(nY)+"`",12)
		if FieldType(nY)=="C"
			?? 'VARCHAR('+str(FieldSize(nY),4)+') CHARACTER SET utf8'
		elseif FieldType(nY)=="N"
			if str(FieldDeci(nY),3)>str(0,3)
				??'DECIMAL('+str(FieldSize(nY),4)+','+str(FieldDeci(nY),3)+')'
			else
				if str(FieldSize(nY),4)>str(9,4) // Maior que 9 digitos deve ser BIGINT
					?? 'BIGINT'
				else
					?? 'INT'
				end
			end
			elseif FieldType(nY)=="D"
			?? 'DATE'
		elseif FieldType(nY)=="L"
			?? 'BIT'
		else // memo
			?? 'VARCHAR ( 300 ) CHARACTER SET utf8'
		end
		if str(nY,4) < str(FCount(),4)
			??","
		end
	next
	?") ENGINE=INNODB;"
	?
	CriaIDX1(pArquivo)
	?
	
//	?"LOCK TABLES `"+pArquivo+"` WRITE";
	// ?"TRUNCATE TABLE '"+pArquivo+"' ;"
	DbGoTop()
	nX1:=0
	nX2:=0
	while !eof()
		?"INSERT INTO `"+pArquivo+"` VALUES(null, "
		for nY:=1 to FCount()
			if FieldType(nY)=="C"
				cCpo:=Trim(fieldGet(nY))
				cCPO:=CharRem(cSBRA,cCpo)
				??'"'+Trim(;
							StrTran(;
								StrTran(;
									StrTran(;
										StrTran(;
											StrTran(;
												StrTran(;
													StrTran(;
														StrTran(;
															StrTran(;
																	cCPO,;
																	"|"," " ),;
																"'","''"),;
																"§","." ),;
																"Ç","C" ),;
																";","." ),;
																'&','&amp;'),;
																'"','\"'),;
																chr(144),"E"),;
																chr(199),"A"));
																+'"'
			elseif FieldType(nY)=="N"
				??fieldGet(nY)
			elseif FieldType(nY)=="D"
				??'"'
				??pb_zer(year (fieldGet(nY)),4)+"-"
				??pb_zer(month(fieldGet(nY)),2)+"-"
				??pb_zer(day  (fieldGet(nY)),2)
				??'"'
			elseif FieldType(nY)=="L"
				??if(fieldGet(nY),1,0)
			else
				??'"memo"'
			end
			if nY#FCount()
				??","
			end
		next
		??");"
		nX1++
		@24,70 say "->"+str(nX1,6)
		if nX1>=nRegistros
			dbgobottom()
		end
		skip		
		nX2++
	end
//	?"UNLOCK TABLES;"
	?
else
	alert('Arquivo '+pArquivo+'; nao pode ser aberto')
end
dbcloseall()
return nil

*------------------------------------------------------
static function CriaIDX1(pArquivo)
*------------------------------------------------------
// Criação dos indices
for nY:=1 to Sx_TagCount() //Sx_IndexCount()
//	?"-- Ordem Nome  "+str(nY,2)+":"+OrdName(nY)
//	?"-- Ordem Chave "+str(nY,2)+":"+OrdKey(nY)
	? "   CREATE INDEX IDX_"+upper(pArquivo)+"_"+OrdName(nY)+ " on "+pArquivo+" ("
	cIndice:=OrdKey(nY)
	for nX1:=1 to len(aARRS)
		cIndice:=StrTran(cIndice,aARRS[nX1,1],aARRS[nX1,2])
	end
	??cIndice
	??");"
next
return NIL

*------------------------------------------------------
static function CriaIDX2(pArquivo)
*------------------------------------------------------
// Criação dos indices
for nY:=1 to Sx_TagCount() //Sx_IndexCount()
//	?"-- Ordem Nome  "+str(nY,2)+":"+OrdName(nY)
//	?"-- Ordem Chave "+str(nY,2)+":"+OrdKey(nY)
	??","
	? "   KEY `IDX_"+upper(pArquivo)+"_"+OrdName(nY)+ "` "
	cIndice:=OrdKey(nY)
	for nX1:=1 to len(aARRS)
		cIndice:=StrTran(cIndice,aARRS[nX1,1],aARRS[nX1,2])
	end
	cIndice:=StrTran(cIndice,",","`,`")
	??"(`"
		??cIndice
	??"`),"
next
return NIL

//---------------------------------------------------------------EOF-----------------------------------------------------------------
