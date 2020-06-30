<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

if(auth.getString("_FIELD_SEQ")== null || auth.getString("_FIELD_SEQ").equals("")){
	if(auth.getString("_DEFAULT_YN").equals("Y")){
		u.jsError("���μ� ������ �����ϴ�.\\n\\n����� ȸ���������� -> ����� ���� �޴����� �μ� ������ �Է� �Ͽ� �ּ���.");
		return;
	}else{
		u.jsError("���μ� ������ �����ϴ�.\\n\\n�⺻ �����ڿ��� �μ� ���� �Է��� ��û �ϼ���.");
		return;
	}
}

// īī��, kt m&s, �������� �μ����� ����� ������ �� �ִ�. (field_seq = null �� ������)
String sfield_seq = "";
if(!auth.getString("_DEFAULT_YN").equals("Y")){
		sfield_seq = " and ( field_seq is null or '^'|| replace(replace(field_seq,' ',''),',','^')||'^' like '%^'||"+auth.getString("_FIELD_SEQ")+"||'^%' )";
}

DataObject templateDao = new DataObject("tcb_cont_template");
DataSet ds = null;
if(_member_no.equals("20130900194")){
	//īī���� �������� �ǹ� ����. ���� ����ۼ� ���� �űԷ� �ۼ� ���� �����Ӱ� Ǯ�� ��  skl 20171128 �ڿ��� ��û
	ds = templateDao.find(" status > 0 and member_no like '%"+_member_no+"%' and use_yn = 'Y' and (doc_type is null or doc_type=2)" + sfield_seq,"template_cd, nvl(display_name,template_name)template_name"," display_seq asc, template_cd desc");
}else{
	ds = templateDao.find(" status > 0 and template_type in ('00','10') and member_no like '%"+_member_no+"%' and use_yn = 'Y' and (doc_type is null or doc_type=2)" + sfield_seq,"template_cd, nvl(display_name,template_name)template_name"," display_seq asc, template_cd desc");
}

f.addElement("template_cd", null, "hname:'��༭����', required:'Y'");

if(u.isPost()&&f.validate()){

	DB db = new DB();
	db.setCommand("delete from tcb_rfile_template where template_cd = '"+f.get("template_cd")+"' and member_no = '"+_member_no+"' and reg_type = '20' ", null);

	String[] attch_yn = f.getArr("attch_yn");
	String[] doc_name = f.getArr("doc_name");
	String[] reg_type = f.getArr("reg_type");
	int doc_cnt = doc_name==null?0:doc_name.length;
	for(int i = 0 ; i < doc_cnt; i ++){
		if(reg_type[i].equals("10")){
			continue;
		}
		DataObject rfile = new DataObject("tcb_rfile_template");
		rfile.item("template_cd",f.get("template_cd"));
		rfile.item("member_no", _member_no);
		rfile.item("rfile_seq", i+1);
		rfile.item("doc_name", doc_name[i]);
		rfile.item("attch_yn", attch_yn[i].equals("Y")?"Y":"N");
		rfile.item("reg_type","20");
		db.setCommand(rfile.getInsertQuery(), rfile.record);
	}

	if(!db.executeArray()){
		u.jsError("ó���� ���� �Ͽ����ϴ�. \\n\\n �����ͷ� ������ �ּ���.");
		return;
	}
	
	String sign_types = templateDao.getOne("select sign_types from tcb_cont_template where template_cd='"+f.get("template_cd")+"' ");
    if(sign_types.equals("")){
		u.redirect("contract_insert.jsp?template_cd="+f.get("template_cd"));
    }else{
		u.redirect("contract_msign_insert.jsp?template_cd="+f.get("template_cd"));
    }
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_select_template");
p.setVar("menu_cd","000053");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000053", "btn_auth").equals("10"));
p.setLoop("template", ds);
p.setVar("form_script", f.getScript());
p.display(out);
%>