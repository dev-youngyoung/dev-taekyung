<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no")); 
String cont_chasu = u.request("cont_chasu");

if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsAlert("정상적인 경로로 접근하세요.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' ";

//계약정보 확인 
ContractDao contDao = new ContractDao("tcb_contmaster");
DataSet cont = contDao.find(where);
if(!cont.next()){
	u.jsAlert("계약정보가 없습니다");
	return;
}

//결제여부 확인
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(where + " and member_no = '"+_member_no+"' ");
if(!cust.next()){
	u.jsAlert("계약관계자 정보가 없습니다.");
	return;
}


if(cust.getString("pay_yn").equals("Y")){
	out.println("<script>");
	out.println("parent.fSign();");
	out.println("</script>");
	return;
}

DataObject useInfoDao = new DataObject("tcb_useinfo");
DataSet useInfo = useInfoDao.find("member_no = '"+cont.getString("member_no")+"' ");
if(!useInfo.next()){
	u.jsAlert("갑 사업자가 나이스다큐 요금제에 가입되어 있지 않습니다. \\n\\n나이스다큐 고객센터(02-788-9097)로 문의하세요");
	return;
}
//이용기간 만료확인
if(useInfo.getLong("useendday")<Long.parseLong(u.getTimeString("yyyyMMdd"))){ 
	if(cont.getString("member_no").equals(_member_no)){
		u.jsAlert("서비스 이용기간이 만료되어 더 이상 계약을 진행할 수 없습니다.\\n\\나이스다큐 고객센터(02-788-9097)로 문의하세요.");
		return;
	}else{
		u.jsAlert("갑 사업자의 나이스다큐 사용기간이 만료되었습니다. \\n\\n나이스다큐 고객센터(02-788-9097)로 문의하세요");
		return;
	}
}
/*
paytypecd M006
10	정액(연간)
20	정액(월)
30	건별제
40	포인트제 -->사용안함.
50	후불제
*/
 
if(cont.getString("member_no").equals(_member_no)){//갑사
	if(u.inArray(useInfo.getString("paytypecd"), new String[]{"10","20","50"})){
		out.println("<script>");
		out.println("parent.fSign();");
		out.println("</script>");
		return;
	}
}else{//을사

	DataObject useInfoAddDao = new DataObject("tcb_useinfo_add");
	DataSet useInfoAdd = useInfoAddDao.find(" member_no = '"+cont.getString("member_no")+"' and template_cd = '"+cont.getString("template_cd")+"' ");
	if(useInfoAdd.next()){
		useInfo.put("insteadyn", useInfoAdd.getString("insteadyn"));
	}
	if(useInfo.getString("insteadyn").equals("Y")){//대납인경우 즉시 서명
		out.println("<script>");
		out.println("parent.fSign();");
		out.println("</script>");
		return;
	}
}


String cont_name = "";
/*결제 금액 정보 확인 START*/
int pay_money = 0;// 결제금액
String insteadyn = useInfo.getString("insteadyn");//대납여부

if(cont.getString("member_no").equals(_member_no)){
	pay_money = useInfo.getInt("recpmoneyamt");
	if(insteadyn.equals("Y")){
		pay_money += useInfo.getInt("suppmoneyamt");
	}
}else{
	pay_money = useInfo.getInt("suppmoneyamt");
}

DataObject useInfoAddDao = new DataObject("tcb_useinfo_add");
DataSet useInfoAdd = useInfoAddDao.find(" member_no = '"+cont.getString("member_no")+"' and template_cd = '"+cont.getString("template_cd")+"' ");
if(useInfoAdd.next()){
	cont_name = "";
	pay_money = 0;

	insteadyn = useInfoAdd.getString("insteadyn");
	if(cont.getString("member_no").equals(_member_no)){
		pay_money = useInfoAdd.getInt("recpmoneyamt");
		if(insteadyn.equals("Y")){
			pay_money += useInfoAdd.getInt("suppmoneyamt");
		}
	}else{
		pay_money = useInfoAdd.getInt("suppmoneyamt");
	}
}

/*결제 금액 정보 확인 END*/

//결제금액이 0원이거나 대납이고 현제 을사인 경우 즉시 서명
if(pay_money==0||(insteadyn.equals("Y")&&!cont.getString("member_no").equals(_member_no)) ){
	out.println("<script>");
	out.println("parent.fSign();");
	out.println("</script>");
	return;
}


out.println("<form name='pay_form' method='post' target='pop_pay' action='pay_req.jsp'>");
out.println("<input type='hidden' name='cont_no' value='"+u.aseEnc(cont_no)+"'>");
out.println("<input type='hidden' name='cont_chasu' value='"+cont_chasu+"'>");
out.println("<input type='hidden' name='pay_money' value='"+u.aseEnc(pay_money+"")+"'>");
out.println("<input type='hidden' name='insteadyn' value='"+insteadyn+"'>");
out.println("<input type='hidden' name='member_no' value='"+_member_no+"'>");
out.println("</form>");
out.println("<script>");
out.println("try{");
out.println("parent.OpenWindow('','pop_pay','670','520');");
out.println("}catch(e){");
out.println(" alert('팝업이 차단되었습니다.\\n\\n팝업 허용 후 다시 시도 하시기 바랍니다.');");
out.println("}");
out.println("");
out.println("document.forms['pay_form'].submit();");
out.println("");
out.println("</script>");
%>	

