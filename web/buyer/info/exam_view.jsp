<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] code_exam_type = {"10=>정기평가","20=>수시평가"};
boolean isCJ = _member_no.equals("20130400333");  // 씨제이대한통운

String exam_cd = u.request("exam_cd");
if(exam_cd.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject examDao = new DataObject("tcb_exam");
DataSet exam = examDao.find(" member_no = '"+_member_no+"' and exam_cd = '"+exam_cd+"' ");
if(!exam.next()){
	u.jsError("평가지 정보가 없습니다.");
	return;
}
exam.put("exam_type", u.getItem(exam.getString("exam_type"), code_exam_type));

DataObject questionDao = new DataObject("tcb_exam_question");
DataSet question = questionDao.query(
		" select a.*                               "
				+"       , (                                "
				+"          select count(question_cd)       "
				+"            from tcb_exam_question        "
				+"           where member_no = a.member_no  "
				+"             and exam_cd = a.exam_cd      "
				+"             and l_div_cd = a.l_div_cd    "
				+"             and depth = a.depth          "
				+"          )  l_div_cnt                    "
				+"       , (                                "
				+"          select count(question_cd)       "
				+"            from tcb_exam_question        "
				+"           where member_no = a.member_no  "
				+"             and exam_cd = a.exam_cd      "
				+"             and l_div_cd = a.l_div_cd    "
				+"             and m_div_cd = a.m_div_cd    "
				+"             and depth = a.depth          "
				+"          )  m_div_cnt                    "
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
				+"    and depth = '"+exam.getString("question_depth")+"' "
				+"  order by question_cd asc 			    "
);

String l_div_cd = "";
String m_div_cd = "";
while(question.next()){
	if(!l_div_cd.equals(question.getString("l_div_cd"))){
		question.put("l_first",true);
		l_div_cd = question.getString("l_div_cd");
		m_div_cd = "";
	}else{
		question.put("l_first",false);
	}
	if(!m_div_cd.equals(question.getString("m_div_cd"))){
		question.put("m_first",true);
		m_div_cd = question.getString("m_div_cd");
	}else{
		question.put("m_first", false);
	}
	question.put("etc", u.nl2br(question.getString("etc")));
	DataObject itemDao = new DataObject("tcb_exam_item");
	DataSet item = itemDao.find(
			" member_no = '"+_member_no+"' and exam_cd = '"+exam_cd+"' and question_cd = '"+question.getString("question_cd")+"' "
			,"*"
			, " item_seq asc"
	);
	question.put(".item", item);
}


if(u.isPost()&&f.validate()){

}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.exam_view");
p.setVar("menu_cd","000113");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000113", "btn_auth").equals("10"));
p.setVar("2depth", exam.getString("question_depth").equals("2"));
p.setVar("3depth", exam.getString("question_depth").equals("3"));
p.setVar("exam", exam);
p.setLoop("question", question);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("exam_cd"));
p.setVar("form_script",f.getScript());
p.setVar("isCJ", isCJ);
p.display(out);
%>