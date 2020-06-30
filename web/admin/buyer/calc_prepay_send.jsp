<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String yyyymm = u.request("yyyymm").replaceAll("-","");
String member_no = u.request("member_no");
String calc_person_seq = u.request("calc_person_seq");
if(yyyymm.equals("")||member_no.equals("")){
    u.jsError("�������� ��η� �����ϼ���.");
    return;
}

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_pay_type_cd = codeDao.getCodeArray("M006");

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
    u.jsError("��ü������ �����ϴ�.");
    return;
}

DataObject useInfoDao = new DataObject("tcb_useinfo");
DataSet useInfo = useInfoDao.find(" member_no = '"+member_no+"' ");
if(!useInfo.next()){
    u.jsError("��ϵ� �����̿� ������ �����ϴ�.");
    return;
}


DataObject calcPersonDao = new DataObject("tcb_calc_person");
DataSet calcPerson = calcPersonDao.find("member_no = '"+member_no+"' and seq = '"+calc_person_seq+"' ");
if(!calcPerson.next()){
	u.jsError("��ϵ� ��꼭 ����ڰ� ������ �����ϴ�.");
	return;
}


DataObject calcMonthDao = new DataObject("tcb_calc_month");
calcMonthDao.item("member_no", member_no);
calcMonthDao.item("yyyymm", yyyymm);
calcMonthDao.item("calc_person_seq", calc_person_seq);
calcMonthDao.item("pay_type_cd", useInfo.getString("paytypecd"));
calcMonthDao.item("user_name", calcPerson.getString("user_name"));
calcMonthDao.item("tel_num", calcPerson.getString("tel_name"));
calcMonthDao.item("hp1", calcPerson.getString("hp1"));
calcMonthDao.item("hp2", calcPerson.getString("hp2"));
calcMonthDao.item("hp3", calcPerson.getString("hp3"));
calcMonthDao.item("email", calcPerson.getString("email"));
calcMonthDao.item("calc_date", u.getTimeString());
calcMonthDao.item("status", "10");

DataSet calcMonth = calcMonthDao.find("member_no = '"+member_no+"' and yyyymm = '"+yyyymm+"' and calc_person_seq = '"+calc_person_seq+"' ");
if(calcMonth.next()) {
    if(!calcMonthDao.update("member_no = '"+member_no+"' and yyyymm = '"+yyyymm+"' ")){
    	u.jsError("��߼� ó���� ���� �������ϴ�.");
    	return;
    }
}else{
    if(!calcMonthDao.insert()){
        u.jsError("�ȳ��߼� ó���� ���� �Ͽ����ϴ�.");
        return;
    }
}

String str_yyyymm = u.getTimeString("yyyy-MM",u.strToDate(yyyymm+"01"));
//���Ϲ߼�
DataSet mailInfo = new DataSet();
mailInfo.addRow();
mailInfo.put("member_name", member.getString("member_name"));
mailInfo.put("yyyymm", str_yyyymm);
mailInfo.put("use_edate", u.getTimeString("yyyy-MM-dd",useInfo.getString("useendday")));
mailInfo.put("pay_type_cd_nm", u.getItem(useInfo.getString("paytypecd"), code_pay_type_cd));
if(useInfo.getLong("bid_amt") > 0 ) {
    mailInfo.put("bid_amt", u.numberFormat(useInfo.getString("bid_amt")));
}
mailInfo.put("won_cont_amt", u.numberFormat(useInfo.getString("suppmoneyamt")));
p.setVar("info", mailInfo);
p.setVar("server_name", request.getServerName());
p.setVar("return_url", "/buyer");
String mail_body = p.fetch("../html/mail/buyer_calc_prepay_mail.html");
String[] arr_mail = calcPerson.getString("email").split(";");
for(int i = 0 ; i < arr_mail.length;i++) {
    if(!arr_mail[i].equals("")) {
        u.mail(arr_mail[i], "[���̽���ť] �ý��� �̿� ���Ű�� �ȳ�('" + str_yyyymm + "')", mail_body);
    }
}

u.jsAlertReplace("�߼� �Ǿ����ϴ�.","calc_prepay_list.jsp?"+u.getQueryString("yyyymm,member_no,calc_person_seq"));
%>