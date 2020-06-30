<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String search_type = u.request("search_type");  // �����, ���� ��� �˻��� �� �ִ� ȭ�� ���(C:�����, P:����, B:���λ���� ��ǥ��, ����: ����) CP, CP�� ���� �Ͽ� ���
String sign_seq = u.request("sign_seq");

f.addElement("s_member_name",null, null);


//��� ����
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(5);
list.setTable("tcb_client a, tcb_member b, tcb_person c, tcb_member_boss d");
list.setFields("b.*, c.user_name, c.tel_num , c.hp1, c.hp2, c.hp3, c.email, c.jumin_no, d.boss_birth_date, d.boss_gender, d.boss_hp1, d.boss_hp2, d.boss_hp3,d.boss_email, d.boss_ci");
list.addWhere(" a.client_no = b.member_no");
list.addWhere(" b.member_no = c.member_no");
list.addWhere(" b.member_no = d.member_no(+)");
list.addWhere(" b.member_gubun = '04' ");
list.addWhere(" b.status <> '00' ");
list.addWhere(" c.default_yn = 'Y' ");
list.addWhere("a.member_no='"+_member_no+"'");
list.addSearch("member_name", f.get("s_member_name"), "LIKE");
list.setOrderBy("member_name asc ");

DataSet ds = null;
Security	security	=	new	Security();
if(!u.request("search").equals("")){
	//��� ����Ÿ ����
	ds = list.getDataSet();

	while(ds.next()){
		if(!ds.getString("jumin_no").equals("")){
			String jumin_no = security.AESdecrypt(ds.getString("jumin_no"));
			String genderHan = "";
			if(jumin_no.length() > 6){
				genderHan = u.inArray(jumin_no.substring(6,7), new String[]{"1","3"}) ? " (��)" : " (��)";
			}
			ds.put("print_jumin_no", jumin_no.substring(0,2)+"�� "+jumin_no.substring(2,4)+"�� "+jumin_no.substring(4,6)+"��" + genderHan);
			ds.put("jumin_no", jumin_no);
		}
		if(!ds.getString("boss_birth_date").equals("")){
			String gender = ds.getString("boss_gender");
			ds.put("print_jumin_no", u.getTimeString("yy��MM��dd��", ds.getString("boss_birth_date")) + "("+gender+")");
			ds.put("jumin_no", ds.getString("boss_birth_date"));
			ds.put("boss_birth_date", u.getTimeString("yyyy-MM-dd", ds.getString("boss_birth_date")));
		}
	}
	
	
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_search_person");
p.setVar("popup_title","���� �˻�");
p.setVar("tab_view_cp", search_type.equals("CP"));
p.setVar("tab_view_pb", search_type.equals("PB"));
p.setLoop("list", ds);
p.setVar("sign_seq", sign_seq);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);


%>