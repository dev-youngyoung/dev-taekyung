<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String member_no = u.request("member_no");
String client_type = u.request("client_type");
String member_slno1 = u.request("member_slno1");
String member_slno2 = u.request("member_slno2");
if(member_no.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

if(u.isPost()){
	DB db = new DB();

	// ���� ��ü�� ���
	DataObject dao = new DataObject("tcb_client");
	//dao.setDebug(out);
	int client_seq = dao.getOneInt(
		"  select nvl(max(client_seq),0)+1 client_seq "+
		"    from tcb_client "+
		"   where member_no = '"+member_no+"'"
	);
	dao.item("member_no", member_no);
	dao.item("client_seq", client_seq);
	dao.item("client_no", _member_no);
	if(!client_type.equals("")){
		dao.item("client_type", client_type);
	}
	// ������� �ʿ��� ��ü�� �ŷ�ó�� ��� (�뺸�������, �ѱ�����, �ż���, �׽�Ʈ, NH��������,�븲C&S, ���̿��� , �����ũ����ũ, ������Ʈ����,��Ʈ��9ȣ��)
	if( u.inArray(member_no, new String[]{"20130400091", "20121200116", "20140101025", "20120200001","20160901598","20170101031","20121204063","20170602171","20180203437","20181002679","20151101243","20191200612"}) ) {
		dao.item("client_reg_cd", "0");   // 0:����Ͼ�ü, 1:���ĵ�Ͼ�ü
	} else {
		dao.item("client_reg_cd", "1");
	}
	dao.item("client_reg_date", u.getTimeString());
	db.setCommand(dao.getInsertQuery(), dao.record);
	

	if( !member_slno1.equals("") && !member_slno2.equals("") && auth.getString("_MEMBER_GUBUN").equals("03") ){//CJ������� ���� ����� ������������� ���ε�Ϲ�ȣ�� �����ص�
		DataObject member = new DataObject("tcb_member");
		
		if( Integer.parseInt(member_slno1.substring(0,2)) < 20 ){
			member_slno1 = member_slno1.replaceAll("-","");
			member_slno1 = member_slno1.substring(2);
		}else{
			member_slno1 = member_slno1.replaceAll("-","");
			member_slno1 = member_slno1.substring(2);
			member_slno2 = member_slno2.equals("1") ? "3" : "4";
		}
		member.item("member_slno", member_slno1+member_slno2);
		db.setCommand(member.getUpdateQuery("member_no= '"+_member_no+"'"), member.record); // �ֹι�ȣ
		
	}
	
	if(!db.executeArray()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �� ���ͷ� ������ �ּ���.");
		return;
	}
}

// ��ü�� �߰��� ÷���ؾ��� ������ �ִ� ��� �ٷ� �̵�
DataObject rfileDao = new DataObject("tcb_client_rfile_template");
DataSet rf = rfileDao.find("member_no='"+member_no+"'");
if(rf.next()) {
	u.jsAlertReplace("�⺻ ������� �Ϸ�Ǿ����ϴ�.\\n\\n�߰� ���񼭷� ������ ÷���� �ֽñ� �ٶ��ϴ�.", "company_view.jsp?member_no="+member_no);
}

if(member_no.equals("20130400333")&&client_type.indexOf("0")>-1){ // CJ��������� �����Ȳ�� �߰��� �Է��ϵ��� �Ѵ�.
	u.jsAlertReplace("�ŷ�ó�� ��� �Ǿ����ϴ�. \\n\\n������ �����Ͻô� ��ü�� �߰� ������ �Է����ֽñ� �ٶ��ϴ�.", "../info/company_add_info.jsp");
}else if(u.inArray(member_no, new String[]{"20130400091", "20121200116", "20140101025", "20120200001","20160901598"}) ){//����� �޼��� ����
	u.jsAlertReplace("����� �ŷ�ó�� ��� �Ǿ����ϴ�.","cust_list.jsp?"+u.getQueryString("member_no"));
}else{
	u.jsAlertReplace("�ŷ�ó�� ��� �Ǿ����ϴ�.","cust_list.jsp?"+u.getQueryString("member_no"));
}
return;
%>