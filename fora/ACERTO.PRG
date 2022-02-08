
function ACERTO()
use CFEAPR new index CFEIPR02
use CFEAME new index CFEIME01
while !eof()
	PROD=ME_CODPR
	QTD =0
	VLR =0
	while !eof().and.PROD=ME_CODPR
		if ME_TIPO='E'
			QTD+=ME_QTD
			VLR+=ME_VLEST
		elseif ME_TIPO='I'
			QTD+=ME_QTD
			VLR+=ME_VLEST
		elseif ME_TIPO='A'
			QTD+=ME_QTD
			VLR+=ME_VLEST
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
			if round(QTD,2)==round(ME_QTD,2)
				QTD-=ME_QTD
				VLR+=ME_VLEST
			end
		end
		dbskip()
	end
end
dbcloseall()
return NIL
//------------------------------