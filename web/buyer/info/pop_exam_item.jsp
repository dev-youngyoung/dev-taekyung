<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String exam_cd= u.request("exam_cd");
String question_cd = u.request("question_cd");
if(exam_cd.equals("")|| question_cd.equals("")){
	u.jsErrClose("정상적인 경로로 접근하세요.");
	return;
}

DataObject questionDao =new DataObject(" tcb_exam_question ");
DataSet question = questionDao.query(
		 " select a.*                                 "
		+"       , (                                "
		+"          select question                 "
		+"            from tcb_exam_question        "
		+"           where member_no = a.member_no  "
		+"             and exam_cd = a.exam_cd      "
		+"             and l_div_cd = a.l_div_cd    "
		+"             and m_div_cd = '000'         "
		+"             and s_div_cd = '000'         "
		+"          )  l_div_nm                     "
		+"       , (                                "
		+"          select question                 "
		+"            from tcb_exam_question        "
		+"           where member_no = a.member_no  "
		+"             and exam_cd = a.exam_cd      "
		+"             and l_div_cd = a.l_div_cd    "
		+"             and m_div_cd = a.m_div_cd    "
		+"             and s_div_cd = '000'         "
		+"          )  m_div_nm                     "
		+"   from tcb_exam_question a               "
		+"  where member_no = '"+_member_no+"'      "
		+"    and exam_cd = '"+exam_cd+"'           "
		+"    and question_cd = '"+question_cd+"'   "
		+"  order by question_cd asc 			    "
);

if(!question.next()){
	u.jsErrClose("평가 항목이 없습니다.");
	return;
}

DataObject itemDao = new DataObject("tcb_exam_item");
DataSet item = itemDao.find(
	" member_no = '"+_member_no+"' and exam_cd = '"+exam_cd+"' and question_cd = '"+question_cd+"' "
	,"*"
	," item_seq asc"
	);
	
if(u.isPost()&& f.validate()){
	DB db = new DB();
	db.setCommand(itemDao.getDeleteQuery(" member_no = '"+_member_no+"' and exam_cd = '"+exam_cd+"' and question_cd = '"+question_cd+"' "), null);
	String[] arr_text = f.getArr("item_text");
	String[] arr_point = f.getArr("point");
	
	int item_cnt = arr_text==null?0:arr_text.length;
	
	for(int i = 0 ; i < item_cnt; i++){
		itemDao = new DataObject("tcb_exam_item");
		itemDao.item("member_no",_member_no);
		itemDao.item("exam_cd", exam_cd);
		itemDao.item("question_cd", question_cd);
		itemDao.item("item_seq", i );
		itemDao.item("item_text", arr_text[i]);
		itemDao.item("point", arr_point[i]);
		db.setCommand(itemDao.getInsertQuery(), itemDao.record);	
	}
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	out.print("<script>opener.location.reload();self.close();</script>");
	return;	
}


p.setLayout("popup");
p.setDebug(out);
p.setBody("info.pop_exam_item");
p.setVar("popup_title","평가항목 배점관리");
p.setVar("2depth", question.getString("depth").equals("2"));
p.setVar("3depth", question.getString("depth").equals("3"));
p.setVar("question", question);
p.setLoop("item", item);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>