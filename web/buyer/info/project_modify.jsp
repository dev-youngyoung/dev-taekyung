<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String project_seq = u.request("project_seq");
if(project_seq.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
}
DataObject projectDao = new DataObject("tcb_project");
DataSet project = projectDao.find(" member_no = '"+_member_no+"' and project_seq = '"+project_seq+"' ");
if(!project.next()){
	u.jsError("프로젝트 정보가 없습니다.");
	return;
}
project.put("reg_date", u.getTimeString("yyyy-MM-dd", project.getString("reg_date")));
DataObject peronDao= new DataObject("tcb_person");
project.put("reg_name", projectDao.getOne("select user_name from tcb_person where member_no = '"+_member_no+"' and user_id = '"+project.getString("reg_id")+"' "));

f.addElement("project_name", project.getString("project_name"), "hname:'프로젝트명', required:'Y'");
f.addElement("use_yn", project.getString("use_yn"), "hname:'사용여부', required:'Y'");
f.addElement("project_cd", project.getString("project_cd"), "hname:'프로젝트코드'");
f.addElement("order_comp_nm", project.getString("order_comp_nm"), "hname:'발주처'");
f.addElement("project_cont_date", u.getTimeString("yyyy-MM-dd",project.getString("project_cont_date")), "hname:'계약일자'");
f.addElement("project_loc", project.getString("project_loc"), "hname:'위치'");
f.addElement("etc1", null, "hname:'비고1'");
f.addElement("etc2", null, "hname:'비고2'");
// 입력수정
if(u.isPost() && f.validate()){
	projectDao = new DataObject("tcb_project");
	if(!f.get("project_cd").equals("")){
		if(projectDao.findCount(" member_no = '"+_member_no+"' and upper(project_cd) = '"+f.get("project_cd").toUpperCase()+"' and project_seq <> '"+project_seq+"' ")> 0 ){
			u.jsError("이미 등록된 프로젝트 코드 입니다.");
			return;
		}
	}

	projectDao = new DataObject("tcb_project");
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
	if(!projectDao.update(" member_no = '"+_member_no+"' and project_seq = '"+project_seq+"' ")){
		u.jsError("저장처리에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("저장처리 하였습니다.", "project_modify.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setVar("menu_cd","000117");
p.setBody("info.project_modify");
p.setVar("modify", true);
p.setVar("project",project);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("project_seq"));
p.display(out);
%>