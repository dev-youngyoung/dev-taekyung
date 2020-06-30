<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] gubun = {"0=>����", "1=>Ÿ�Ӿƿ�", "2=>�߸��� ��ȭ��ȣ", "v=>�߽Ź�ȣ ���� ������� ���� �̵�� ����", "w=>�߽Ź�ȣ ���� ����� ��ȣ��Ģ ����",
		"a=>�ܸ��� �Ͻ� ���� ����", "b=>��Ÿ �ܸ��� ����", "c=>�ܸ��⿡�� ���� ����", "d=>��Ÿ", "e=>�� ����", "f>SMTS ���˿���", "g=>SMS ���� �Ұ� �ܸ���",
		"h=>���� ���� ȣ�Ұ� ����", "i=>SMS ��ڰ� ������ �޽���", "j=>�����ٷ��� ASE ������ �޽��� ť", "k=>����翡�� SPAM ó��",
		"l=>www.nospam.go.kr�� ��ϵ� ���Űź� ��ȣ", "m=>�޽��� SPAM ����", "p=>�� ��ȣ�� ���Ŀ� ��߳� ���", "t=>2�� �̻��� SPAM ����",
		"q=>�ʵ� ������ �߸��� ���(��:�޽��� �������)", "s=>�޽��� ��������", "A=>�ڵ��� ȣ ó����", "B=>��������", "C=>�ܸ��� POWER OFF",
		"z=>�� �� ����"};

String s_tran_date = u.request("s_tran_date", u.getTimeString("yyyyMM"));

f.addElement("s_tran_date", s_tran_date, "hname:'���س��', required:'Y', fixbyte:'6'");
f.addElement("s_tran_rslt", null, null);
f.addElement("s_tran_phone", null, null);
f.addElement("s_tran_msg", null, null);

ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum("excel".equals(u.request("mode")) ? -1 : 25);
list.setTable("labor.em_log_" + s_tran_date + " a, labor.em_tran_mms b");
list.setFields("a.tran_phone, to_char(a.tran_date, 'YYYY-MM-DD HH24:MI:SS') tran_date, to_char(a.tran_reportdate, 'YYYY-MM-DD HH24:MI:SS') tran_reportdate, a.tran_net, a.tran_rslt, decode(a.tran_msg, null, b.mms_body, a.tran_msg) tran_msg ");
list.addWhere("a.tran_id = 'NDD002'");
list.addWhere("a.tran_etc4 = b.mms_seq(+)");
if (!"".equals(f.get("s_tran_rslt"))) {
	list.addWhere("0".equals(f.get("s_tran_rslt")) ? "a.tran_rslt = '0'" : "a.tran_rslt != '0'");
}
list.addWhere("(a.tran_msg like '%" + f.get("s_tran_msg") + "%' or b.mms_body like '%" + f.get("s_tran_msg") + "%')");
list.addSearch("a.tran_phone", f.get("s_tran_phone").replaceAll("-", ""), "LIKE");
list.setOrderBy("a.tran_id desc");

//��� ����Ÿ ����
DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("tran_msg", u.nl2br(ds.getString("tran_msg")));
	ds.put("tran_rslt_nm", u.getItem(ds.getString("tran_rslt"), gubun));
}

p.setLoop("list", ds);

if (u.request("mode").equals("excel")) {
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("SMS�����̷�.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/mgr/sms_hist_list_excel.html"));
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("mgr.sms_hist_list");
p.setVar("menu_cd","000074");
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>