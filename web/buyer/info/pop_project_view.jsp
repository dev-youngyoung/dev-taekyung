<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
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
project.put("project_cont_date", u.getTimeString("yyyy-MM-dd",project.getString("project_cont_date")));
project.put("etc1", u.nl2br(project.getString("etc1")));
project.put("etc2", u.nl2br(project.getString("etc2")));
project.put("use_yn_nm", project.getString("use_yn").equals("Y")?"진행중":"종료");

project.put("reg_date", u.getTimeString("yyyy-MM-dd", project.getString("reg_date")));
DataObject peronDao= new DataObject("tcb_person");
project.put("reg_name", projectDao.getOne("select user_name from tcb_person where member_no = '"+_member_no+"' and user_id = '"+project.getString("reg_id")+"' "));


// 입력수정
if(u.isPost() && f.validate()){
}


p.setLayout("popup");
//p.setDebug(out);
p.setBody("info.pop_project_view");
p.setVar("popup_title","프로젝트 조회");
p.setVar("modify", true);
p.setVar("project",project);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("project_seq"));
p.display(out);
%>