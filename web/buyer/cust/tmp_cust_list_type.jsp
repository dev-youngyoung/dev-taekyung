<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_client_type = null;
String sClientWhere = "";
if(_member_no.equals("20130400091")) // �뺸�������
	code_client_type = new String[]{"0=>��ǰ","1=>�뿪"};
else if(_member_no.equals("20140300055"))  // �ѱ���������
	code_client_type = new String[]{"0=>���޻�","1=>�븮��"};
else if(u.inArray(_member_no, new String[]{"20121200116", "20140101025", "20120200001","20170602171"}))  // �ѱ�����, �ż���, �׽�Ʈ,�븲��������
	code_client_type = new String[]{"0=>��ǰ","1=>����","2=>�뿪"};
else if(_member_no.equals("20140101025"))  // �ż����ȭ��
	code_client_type = new String[]{"0=>��ǰ","1=>����","2=>�뿪"};
else if(_member_no.equals("20170101031"))  // ��������
	code_client_type = new String[]{"0=>��ǰ","1=>����","2=>�뿪"};
else if(_member_no.equals("20121204063"))  // Ȩ�÷���
	code_client_type = new String[]{"0=>��ǰ","1=>����","2=>�뿪"};
else if(u.inArray(_member_no, new String[]{"20180203437", "20181002679","20191200612"}))  // ���̿���, (��)�����ũ����ũ, ��Ʈ��9ȣ��
	code_client_type = new String[]{};
else
{
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

f.addElement("s_member_name", null, null);

//��� ����
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.request("mode").equals("excel")?-1:15);
list.setTable("tcb_client a, tcb_member b ");
list.setFields(		"a.* "
		+	",b.vendcd "
		+	",b.member_name "
		+	",b.boss_name "
		+	",b.member_gubun"
);
list.addWhere(" a.member_no = '"+_member_no+"'");
list.addWhere("	a.client_no = b.member_no ");
list.addWhere("	a.client_reg_cd = '0' ");

list.addWhere("	b.member_gubun != '04' ");
if(!f.get("s_member_name").equals("")){
	list.addWhere(" upper(b.member_name) like upper('%"+f.get("s_member_name")+"%')");
}
list.setOrderBy("client_reg_date desc");


DataSet  ds = list.getDataSet();

while(ds.next()){
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	ds.put("client_reg_date", u.getTimeString("yyyy-MM-dd", ds.getString("client_reg_date")));
	ds.put("client_type", u.getItems(ds.getString("client_type"), code_client_type));
}


p.setLayout("default");
p.setDebug(out);
p.setBody("cust.tmp_cust_list_type");
p.setVar("menu_cd","000088");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000088", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("code_client_type", u.arr2loop(code_client_type));
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>