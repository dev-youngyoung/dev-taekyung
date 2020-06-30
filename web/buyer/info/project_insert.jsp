<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
f.addElement("project_name", null, "hname:'������Ʈ��', required:'Y'");
f.addElement("use_yn", "Y", "hname:'��뿩��', required:'Y'");
f.addElement("project_cd", null, "hname:'������Ʈ�ڵ�'");
f.addElement("order_comp_nm", null, "hname:'����ó'");
f.addElement("project_cont_date", null, "hname:'�������'");
f.addElement("project_loc", null, "hname:'��ġ'");
f.addElement("etc1", null, "hname:'���1'");
f.addElement("etc2", null, "hname:'���2'");

// �Է¼���
if(u.isPost() && f.validate()){
	DataObject projectDao = new DataObject("tcb_project");
	if(!f.get("project_cd").equals("")){
		if(projectDao.findCount(" member_no = '"+_member_no+"' and upper(project_cd) = '"+f.get("project_cd").toUpperCase()+"' ")> 0 ){
			u.jsError("�̹� ��ϵ� ������Ʈ �ڵ� �Դϴ�.");
			return;
		}
	}
	String project_seq = projectDao.getOne("select nvl(max(project_seq),0)+1 from tcb_project where member_no = '"+_member_no+"' ");
	if(project_seq.equals("")){
		u.jsError("����ó���� ���� �Ͽ����ϴ�.");
		return;
	}

	projectDao = new DataObject("tcb_project");
	projectDao.item("member_no", _member_no);
	projectDao.item("project_seq", project_seq);
	projectDao.item("project_cd", f.get("project_cd"));
	projectDao.item("project_name", f.get("project_name"));
	projectDao.item("project_loc", f.get("project_loc"));
	projectDao.item("order_comp_nm", f.get("order_comp_nm"));
	projectDao.item("project_cont_date", f.get("project_cont_date").replaceAll("-", ""));
	projectDao.item("etc1", f.get("etc1"));
	projectDao.item("etc2", f.get("etc2"));
	projectDao.item("use_yn", f.get("use_yn").equals("Y")?"Y":"N");
	projectDao.item("reg_date", u.getTimeString());
	projectDao.item("reg_id", auth.getString("_USER_ID"));
	projectDao.item("status", "10");
	if(!projectDao.insert()){
		u.jsError("����ó���� ���� �Ͽ����ϴ�.");
		return;
	}
	u.jsAlertReplace("����ó�� �Ͽ����ϴ�.", "project_modify.jsp?project_seq="+project_seq);
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setVar("menu_cd","000117");
p.setBody("info.project_modify");
p.setVar("modify", false);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("project_seq"));
p.display(out);
%>