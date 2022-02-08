*-----------------------------------------------------------------------------*
function FN_CODFC(P1,P2)  // Verificar FUNCIONARIO/EMPRESA
#include 'RCB.CH'
*-----------------------------------------------------------------------------*
local VM_RT:=.T.,VM_TF
private P11:=P1
salvabd()
select('CLICONV')
if !dbseek(str(P1,5)+P2)
	ordem SONOME
	set filter to P11==FC_EMPRESA
	DbGoTop()
	VM_TF:=savescreen(5)
	salvacor(SALVA)
	pb_box(05,14,22,79,'W+/RB','Cadastro de FUNCIONARIOS')
	private VM_ROT:={||CFEPFAX0T(.T.)}
	VM_TECLA:=''
	dbedit(06,15,21,78,{'FC_NOME','FC_CODIGO','if(!FC_ATIVO,"Demit","     ")'},;
								'FN_TECLAx',,{'Codigo','Nome','Situc'},,,,)
	P2:=&(fieldname(2))
	VM_RT:=.F.
	keyboard chr(iif(lastkey()==K_ESC,0,K_ENTER))
	restscreen(5,,,,VM_TF)
	salvacor(RESTAURA)
	dbsetorder(1)
	set filter to
else
	@row(),col() say '-'+trim(CLICONV->FC_NOME)
	if !CLICONV->FC_ATIVO
		alert('Funcionario nao esta mais ativo desde '+dtoc(CLICONV->FC_DATAD))
		VM_RT:=.F.
	end
end
salvabd(.F.)
return(VM_RT)
