<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

f.addElement("s_member_name",null, null);

//��� ����
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_client a, tcb_member b ");
list.setFields("a.*, b.vendcd, b.member_name, b.boss_name");
list.addWhere(" a.client_no = '"+_member_no+"'");
list.addWhere("	a.member_no = b. member_no ");
list.addSearch("b.member_name", f.get("s_member_name"), "LIKE");
list.setOrderBy("client_reg_date desc");

DataSet ds = list.getDataSet();
while(ds.next()){
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	if(u.inArray(ds.getString("member_no"), new String[]{"20121203661","20130400010","20130400009","20130400011","20130400008"})) // �ѱ�������
	{
		String[] code_client_type = {"0=>���޻�","1=>�Ǹ�(�븮)��"};
		ds.put("client_type_nm", Util.getItems(ds.getString("client_type"), code_client_type));
	}
	else if(ds.getString("member_no").equals("20140300055")) // �ѱ���������
	{
		String[] code_client_type = {"0=>���޻�","1=>�Ǹ�(�븮)��"};
		ds.put("client_type_nm", Util.getItems(ds.getString("client_type"), code_client_type));
	}
	else if(ds.getString("member_no").equals("20130400091")) // �뺸�������
	{
		String[] code_client_type = {"0=>��ǰ","1=>�뿪"};
		ds.put("client_type_nm", Util.getItems(ds.getString("client_type"), code_client_type));
	}
	else if( u.inArray(ds.getString("member_no"), new String[]{"20121200116", "20140101025", "20120200001", "20170101031","20170602171"}) ) // �ѱ�����, �ż���, �׽�Ʈ02, ��������, �븲��������
	{
		String[] code_client_type = {"0=>��ǰ","1=>����","2=>�뿪"};
		ds.put("client_type_nm", Util.getItems(ds.getString("client_type"), code_client_type));
	}
	else if( u.inArray(ds.getString("member_no"), new String[]{"20160901598"}) ) // NH��������
	{
		String[] code_client_type = {"1=>��Ͼ�ü","2=>���¾�ü"};
		ds.put("client_type_nm", Util.getItems(ds.getString("client_type"), code_client_type));
	}
	else if( u.inArray(ds.getString("member_no"), new String[]{"20150200088"}) ) // �ڽ����ڽ�
	{
		String[] code_client_type = new String[]{"0=>������","1=>����","2=>������"};
		ds.put("client_type_nm", Util.getItems(ds.getString("client_type"), code_client_type));
	}
	else if( u.inArray(ds.getString("member_no"), new String[]{"20130400333"}) ) // CJ�������
	{
		String[] code_client_type = new String[]{"0=>����","1=>����","2=>����"};
		ds.put("client_type_nm", Util.getItems(ds.getString("client_type"), code_client_type));
	}
	else
	{
		ds.put("client_type_nm", "�Ϲݰŷ�ó");
	}

	if(ds.getString("client_reg_cd").equals("0"))
		ds.put("client_reg_nm", "�����");
	else
		ds.put("client_reg_nm", "���ĵ��");


	if(ds.getString("member_no").equals("20160901598")&&ds.getString("client_type").equals("1")){//NH���� ���� ��Ͼ�ü ��û�� ��� ��û�� �˾� �߰�
		DataObject recruitNotiDao = new DataObject("tcb_recruit_noti");
		DataSet recruitNoti  = recruitNotiDao.find("member_no = '20160901598' and req_sdate <= '"+u.getTimeString("yyyyMMdd")+"' and req_edate >= '"+u.getTimeString("yyyyMMdd")+"' and status = '10'");
		if(recruitNoti.next()){
			DataObject recruitCustDao = new DataObject("tcb_recruit_cust");
			DataSet recruitCust = recruitCustDao.find("member_no = '20160901598' and noti_seq = '"+recruitNoti.getString("noti_seq")+"' and client_no = '"+_member_no+"' ");
			if(recruitCust.next()){
				String[] code_status = {"10=>�ӽ�����","20=>��û��","30=>������û","31=>������û","40=>�ɻ�Ϸ�","50=>�Ϸ�"};

				if(u.inArray(recruitCust.getString("status"), new String[]{"10","20","30","31"})   ){
					String btn = " <button type=\"button\" class=\"sbtn color\" onclick=\"OpenWindows('pop_nhqv_recruit_req.jsp?noti_seq="+recruitNoti.getString("noti_seq")+"','pop_nhqv_recruit_req','1000','700');\">��û��("+u.getItem(recruitCust.getString("status"), code_status)+")</button>";
					ds.put("client_reg_nm", ds.getString("client_reg_nm")+"<br>"+ btn);
				}
			}
		}
	}

}

if(!f.get("s_member_name").equals("")&&ds.size()==0){
	u.jsAlert("�˻� ����� �����ϴ�.\\n\\n��ü�߰���ư�� Ŭ���Ͽ� �ŷ���ü�� �߰� �Ͻ� �� �ֽ��ϴ�.");
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.cust_list");
p.setVar("menu_cd","000099");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>