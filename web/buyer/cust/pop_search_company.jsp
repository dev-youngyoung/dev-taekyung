<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

f.addElement("s_member_name",null, null);
f.addElement("s_vendcd",null, null);

String s_member_name = f.get("s_member_name").toLowerCase().replace("kth","����Ƽ������").replace("3m","������").replace("nh����","������ġ����");


//��� ����
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_member");
list.setFields("*");
list.addWhere(" member_type in ('01','03') ");// ������ڸ�
if(subdomain.equals("wmp"))
{
	list.addWhere(" member_no = '20150901887'");// ������ ������ ��ȸ
}
else
{
	list.addWhere(" member_no <> '20150901887'");// ������ ��ȸ �ȵ�����
	list.addSearch("lower(member_name)", s_member_name, "LIKE");
}
list.addWhere(" member_no <> '"+_member_no+"'");// ���� ����
list.addWhere(" member_no not in (select member_no from tcb_client where client_no = '"+_member_no+"')");// �����߰��Ǿ� �ִ� ��ü ����

list.addSearch("vendcd", f.get("s_vendcd"));
list.setOrderBy("member_name asc ");

DataSet ds = new DataSet();
DataSet noti  = new DataSet(); 
if(!u.request("search").equals("")){	
	//��� ����Ÿ ����
	ds = list.getDataSet();
	
	while(ds.next()){
		ds.put("vendcd",u.getBizNo(ds.getString("vendcd")));
		if(ds.getString("member_no").equals("20160901598")){//NH���������� ���
			DataObject notiDao = new DataObject("tcb_recruit_noti");
			noti  = notiDao.find("member_no = '20160901598' and req_sdate <= '"+u.getTimeString("yyyyMMdd")+"' and req_edate >= '"+u.getTimeString("yyyyMMdd")+"' and status = '10'");
			if(noti.next()){
			}
		}
	}
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_search_company");
p.setVar("popup_title","��ü�˻�");
p.setLoop("list", ds);
p.setVar("noti", noti);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.setVar("bWemakeCust", request.getServerName().split("\\.")[0].equals("wemakeprice"));
p.display(out);


%>