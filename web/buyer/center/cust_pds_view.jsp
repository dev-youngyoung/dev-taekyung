<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%@ include file="../chk_login.jsp" %>
<%
	f.uploadDir=Startup.conf.getString("file.path.bcont_pds")+_member_no;
	f.maxPostSize= 10*1024;

	String seq = u.request("seq");
	String member_no = u.request("member_no");
	if(seq.equals("")|| member_no.equals("")){
		u.jsError("정상적인 경로로 접근하여 주십시오.");
		return;
	}

	DataObject pdsDao = new DataObject("tcb_member_pds a ");
//pdsDao.setDebug(out);
	DataSet pds = pdsDao.find(
			" member_no = '"+member_no+"' and seq = '"+seq+"' ",
			"a.*,(select member_name from tcb_member where member_no = a.member_no) member_name,"+
					"(select user_name from tcb_person where member_no = a.member_no and user_id = a.reg_id) reg_name",
			""
	);
	if(!pds.next()){
		//u.jsError("정보가 존재 하지 않습니다.");
		return;
	}else{
		pds.put("reg_date", u.getTimeString("yyyy-MM-dd", pds.getString("reg_date")));
		pds.put("contents", u.nl2br(pds.getString("contents")));
	}

	DataObject fileDao = new DataObject("tcb_member_pds_file");
	DataSet fds = fileDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' ");
	while(fds.next()){
		fds.put("file_size_str", u.getFileSize(fds.getLong("file_size")));
	}


	p.setLayout("default");
	p.setDebug(out);
	p.setBody("center.cust_pds_view");
	p.setVar("modify", true);
	p.setVar("menu_cd","000124");
	p.setVar("pds", pds);
	p.setLoop("fds", fds);
	p.setVar("query", u.getQueryString());
	p.setVar("list_query", u.getQueryString("seq"));
	p.setVar("form_script",f.getScript());
	p.display(out);
%>