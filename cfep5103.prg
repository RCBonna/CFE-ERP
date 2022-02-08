*-----------------------------------------------------------------------------*
function CFEP5103() // Eliminar pedidos
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

CFEP5104(.F.) // Mostrar
if reclock().and.pb_sn('Eliminar Pedido N. '+pb_zer(PC_PEDID,6)+'-'+CLIENTE->CL_RAZAO)
	if !PC_FLAG
		CFEP5103E(.F.)
	else
		pb_msg('Pedido ja atualizado...',3,.T.)
	end
end
dbunlockall()
select('PEDCAB')
return NIL

*-----------------------------------------------------------------------------*
function CFEP5103E(P1) // Eliminar 2/2 P1=.T.=>Atualizado   .F.=>Nao atualizado
local RT:=.T.,VM_ULTPD:=PC_PEDID
select('PEDDET')
dbseek(str(VM_ULTPD,6),.T.)
*----------------------------------------------------bloquear registro
select('PEDDET')
while !eof().and.VM_ULTPD==PD_PEDID
	if !reclock()
		RT:=.F.
		exit
	end
	dbskip()
end
*--------------------------------------------se conseguir bloquear / del
select('PEDSVC')
while !eof().and.VM_ULTPD==PS_PEDID
	if !reclock()
		RT:=.F.
		exit
	end
	dbskip()
end

if RT
	select('PEDDET')
	dbseek(str(VM_ULTPD,6),.T.)
	while !eof().and.VM_ULTPD==PD_PEDID
		select('PROD')
		if dbseek(str(PEDDET->PD_CODPR,L_P))
			if PROD->PR_CTB#99.or.PROD->PR_CTB#97
				if P1 // Pedido ja atualizado
					replace PR_QTATU with PR_QTATU-PEDDET->PD_QTDE
				end
			end
		end
		select('PEDDET')
		dbdelete()
		dbskip()
	end
	select('PEDSVC')
	while !eof().and.VM_ULTPD==PS_PEDID
		dbdelete()
		dbskip()
	end

	select('PEDCAB')
	dbdelete()
end
return NIL
//------------------------------------------EOF-----------------------------------
