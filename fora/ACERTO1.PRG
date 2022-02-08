function ACERTO1(ZZ)
if ZZ=NIL
	pb_msg('Falta parametro (A-ATUALIZA) ou (V-VISUALIZA)',nil,.f.)
	quit
end
ZZ=UPPER(ZZ)
use CFEAPR new index CFEIPR02 alias PRD
? 'processando ....'
replace all PR_SLDQT with 0,PR_SLDVL with 0,PR_RESER with 0
use CFEAME new index CFEIME01 alias MOV
clear
SET DATE BRIT
while !eof()
	PROD=ME_CODPR
	if ZZ#'A'
		clear
		@1,00 say 'Produto : ' get PROD pict '99999'
		read
		if lastkey()=27
			exit
		end
		setcolor('')
		dbseek(str(PROD,5),.T.)
	end
	PROD=ME_CODPR
	QTD =0
	VLR =0
	MED =0
	array={}
	aadd(ARRAY,{'TP','    DCTO','    DATA','       QTD','       VLEST MV','     QTD-C','        VLR-C','  Reg'})
	while !eof().and.PROD=ME_CODPR
		XXX(ZZ)
		aadd(ARRAY,{ME_TIPO,STR(ME_DCTO,8),ME_DATA,str(ME_QTD,10,2),ME_VLEST,STR(QTD,10,2),VLR,str(recno(),5)})
		dbskip()
	end
	select('PRD')
	dbseek(str(PROD,5))
	@1,00 say 'Produto : '+pb_zer(PROD,5)+'-'+PRD->PR_DESCR
	@1,45 say 'QTDE/VLR: '+transform(PR_QTATU,'@E 999,999.99')+'/'+transform(PR_VLATU,'@E 999,999,999.99')
	if ZZ='A'
		replace  PR_QTATU with QTD,;
					PR_VLATU with VLR
		select('MOV')
	else
		select('MOV')
		SUB:=aalist(ARRAY,{{2,0,23,79}})
		if lastkey()==13.and.val(SUB[8])>1
			@15,30 say 'Alteracao de uma movimentacao...'
			pb_box(19,30)
			QTD1=val(SUB[4])
			VLR1=SUB[5]
			@20,32 say 'Quantidade :' get QTD1 valid QTD1>0
			@21,32 say 'Valor Mov  :' get VLR1 valid VLR1>0
			read
			setcolor('')
			if lastkey()#27
				REG=val(SUB[8])
				dbgoto(REG)
				repl ME_QTD with QTD1,ME_VLEST with VLR1
				REG=val(ARRAY[2,8])
				dbgoto(REG)
			end
		end
	end
end
dbcloseall()
return NIL

function XXX(ZZ)
if ME_TIPO='E'
	QTD+=ME_QTD
	VLR+=ME_VLEST
elseif ME_TIPO='I'
	QTD+=ME_QTD
	VLR+=ME_VLEST
elseif ME_TIPO='A'
	QTD+=ME_QTD
	if ME_VLEST>0
		VLR+=ME_VLEST
	else
		VLR+=round(ME_QTD*MED,2)
		if ZZ='A'
			replace ME_VLEST with round(ME_QTD*MED,2)
		end
	end
elseif ME_TIPO='F'
	QTD+=ME_QTD
	VLR+=ME_VLEST
elseif ME_TIPO='T'
	QTD+=ME_QTD
	VLR+=ME_VLEST
elseif ME_TIPO='S'
	if QTD>0
		MED=VLR/QTD
	end
	if round(QTD,2)==round(abs(ME_QTD),2)
		if ZZ='A'
			replace ME_VLEST with VLR
		end
		QTD=0
		VLR=0
	else
		QTD-=ME_QTD
		VLR-=round(abs(ME_QTD)*MED,2)
		if ZZ='A'
			replace ME_VLEST with round(abs(ME_QTD)*MED,2)
		end
	end
end
return NIL
