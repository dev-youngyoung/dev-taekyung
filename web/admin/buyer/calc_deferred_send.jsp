<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String yyyymm = u.request("yyyymm").replaceAll("-","");
String member_no = u.request("member_no");
String pay_sdate = u.request("pay_sdate").replaceAll("-","");
String pay_edate = u.request("pay_edate").replaceAll("-","");
String pay_amount = u.request("pay_amount").replaceAll(",","");
String calc_person_seq = u.request("calc_person_seq").replaceAll(",","");

if(yyyymm.equals("")||member_no.equals("")||pay_sdate.equals("")||pay_edate.equals("")||calc_person_seq.equals("")){
    u.jsAlert("정상적인 경로로 접근하세요.");
    return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
    u.jsAlert("업체정보가 없습니다.");
    return;
}

DataObject calcPersonDao = new DataObject("tcb_calc_person");
DataSet calcPerson = calcPersonDao.find("member_no = '"+member_no+"' and seq = '"+calc_person_seq+"'");
if(!calcPerson.next()){
    u.jsAlert("등록된 계약서 담당자가 정보가 없습니다.");
	return;
}
String calc_key = "{member_no:'"+member_no+"',pay_sdate:'"+pay_sdate+"', pay_edate:'"+pay_edate+"', field_seq:'"+calcPerson.getString("field_seq")+"'}";
String calc_url = "/web/buyer/info/pay_info_list_excel.jsp?key="+u.aseEnc(calc_key);

DataObject calcMonthDao = new DataObject("tcb_calc_month");
calcMonthDao.item("member_no", member_no);
calcMonthDao.item("yyyymm", yyyymm);
calcMonthDao.item("calc_person_seq", calc_person_seq);
calcMonthDao.item("pay_type_cd","50");//후불
calcMonthDao.item("user_name", calcPerson.getString("user_name"));
calcMonthDao.item("field_seq", calcPerson.getString("field_seq"));
calcMonthDao.item("tel_num", calcPerson.getString("user_name"));
calcMonthDao.item("hp1", calcPerson.getString("hp1"));
calcMonthDao.item("hp2", calcPerson.getString("hp2"));
calcMonthDao.item("hp3", calcPerson.getString("hp3"));
calcMonthDao.item("email", calcPerson.getString("email"));
calcMonthDao.item("calc_url", calc_url);
calcMonthDao.item("calc_date", u.getTimeString());
calcMonthDao.item("status", "10");

DataSet calcMonth = calcMonthDao.find("member_no = '"+member_no+"' and yyyymm = '"+yyyymm+"' and calc_person_seq = '"+calc_person_seq+"' ");
if(calcMonth.next()) {
    if(!calcMonthDao.update("member_no = '"+member_no+"' and yyyymm = '"+yyyymm+"' and calc_person_seq = '"+calc_person_seq+"'  ")){
        u.jsAlert("재발송 처리에 실패 히엿습니다.");
    	return;
    }
}else{
    if(!calcMonthDao.insert()){
        u.jsAlert("정산발송 처리에 실패 하엿습니다.");
        return;
    }
}

String str_yyyymm = u.getTimeString("yyyy-MM",u.strToDate(yyyymm+"01"));
//메일발송
DataSet mailInfo = new DataSet();
mailInfo.addRow();
mailInfo.put("member_name", member.getString("member_name"));
mailInfo.put("yyyymm", str_yyyymm);
mailInfo.put("pay_sdate", u.getTimeString("yyyy-MM-dd",pay_sdate));
mailInfo.put("pay_edate", u.getTimeString("yyyy-MM-dd",pay_edate));
mailInfo.put("pay_amount", u.numberFormat(pay_amount));
p.setVar("info", mailInfo);
p.setVar("server_name", request.getServerName());
p.setVar("return_url", calc_url);
String mail_body = p.fetch("../html/mail/buyer_calc_deferred_mail.html");

String[] arr_mail = calcPerson.getString("email").split(";");
for(int i = 0 ; i < arr_mail.length;i++) {
	if(!arr_mail[i].equals("")) {
        u.mail(arr_mail[i], "[나이스다큐] 후불정산 내역 안내('" + str_yyyymm + "')", mail_body);
    }
}

String str_calc_person =
        calcPerson.getString("user_name")+"<br>"
        +calcPerson.getString("hp1")+"-"+calcPerson.getString("hp2")+"-"+calcPerson.getString("hp3")+"<br>"
        +calcPerson.getString("email")+"<br>"
        +(calcPerson.getString("field_seq").equals("")?"(전체)":"(부서지정)");

out.println("<script>");
out.println("alert('발송 되었습니다.');");
out.println("document.getElementById('calc_date_"+member_no+"_"+calc_person_seq+"').innerHTML='"+u.getTimeString("yyyy-MM-dd")+"'");
out.println("document.getElementById('calc_person_"+member_no+"_"+calc_person_seq+"').innerHTML='"+str_calc_person+"'");
out.println("</script>");
//u.jsAlertReplace("발송 되었습니다.","calc_deferred_list.jsp?"+u.getQueryString("yyyymm,member_no,pay_sdate,pay_edate,pay_amount,calc_person_seq"));
%>