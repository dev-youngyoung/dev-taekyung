<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_exam_status = {"00=>평가대상","10=>평가중","20=>평가완료"};
String cont_no = u.request("cont_no");
String cont_chasu = u.request("cont_chasu");
String result_seq = u.request("result_seq");
if(cont_no.equals("")||cont_chasu.equals("")|| result_seq.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
if(!cont.next()){
	u.jsError("계약정보가 없습니다.");
	return;
}
cont.put("cont_date", u.getTimeString("yyyy-MM-dd", cont.getString("cont_date")));

DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq = '2' ");
if(!cust.next()){
	u.jsError("거래처 정보가 없습니다.");
	return;
}

DataObject resultDao = new DataObject("tcb_exam_result a");
//resultDao.setDebug(out);
DataSet result = resultDao.find(
		" member_no = '"+_member_no+"' and result_seq = '"+result_seq+"' and exam_type='20' "
		, "a.*,to_number(result_point) rpoint "
				+",(select user_name from tcb_person where member_no = a.member_no and user_id = a.exam_id) exam_user_name"
				+",(select grade from tcb_exam_result_grade where member_no = a.member_no and result_seq = a.result_seq and seq = a.grade_seq ) grade_name "
);
if(!result.next()){
	u.jsError("평가 정보가 없습니다.");
	return;
}
result.put("result_date", u.getTimeString("yyyy-MM-dd", result.getString("result_date")));
result.put("status_name", u.getItem(result.getString("status"), code_exam_status));

DataObject questionDao = new DataObject("tcb_exam_result_question");
//questionDao.setDebug(out);
DataSet question = questionDao.query(
		" select a.*                               "
				+"       , (                                "
				+"          select count(question_cd)       "
				+"            from tcb_exam_result_question "
				+"           where member_no = a.member_no  "
				+"             and result_seq = a.result_seq"
				+"             and l_div_cd = a.l_div_cd    "
				+"             and depth = a.depth          "
				+"          )  l_div_cnt                    "
				+"       , (                                "
				+"          select count(question_cd)       "
				+"            from tcb_exam_result_question "
				+"           where member_no = a.member_no  "
				+"             and result_seq = a.result_seq"
				+"             and l_div_cd = a.l_div_cd    "
				+"             and m_div_cd = a.m_div_cd    "
				+"             and depth = a.depth          "
				+"          )  m_div_cnt                    "
				+"       , (                                "
				+"          select question                 "
				+"            from tcb_exam_result_question "
				+"           where member_no = a.member_no  "
				+"             and result_seq = a.result_seq"
				+"             and l_div_cd = a.l_div_cd    "
				+"             and m_div_cd = '000'         "
				+"             and s_div_cd = '000'         "
				+"          )  l_div_nm                     "
				+"       , (                                "
				+"          select question                 "
				+"            from tcb_exam_result_question "
				+"           where member_no = a.member_no  "
				+"             and result_seq = a.result_seq"
				+"             and l_div_cd = a.l_div_cd    "
				+"             and m_div_cd = a.m_div_cd    "
				+"             and s_div_cd = '000'         "
				+"          )  m_div_nm                     "
				+"        , to_number(a.result_point) rpoint"
				+"   from tcb_exam_result_question a        "
				+"  where member_no = '"+_member_no+"'      "
				+"    and result_seq = '"+result_seq+"'     "
				+"    and depth = '"+result.getString("question_depth")+"' "
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
	DataObject itemDao = new DataObject("tcb_exam_result_item");
	DataSet item = itemDao.find(
			" member_no = '"+_member_no+"' and result_seq = '"+result_seq+"' and question_cd = '"+question.getString("question_cd")+"' "
			,"item_text, to_number(point) point "
			, " item_seq asc"
	);
	while(item.next()){
		if(question.getString("rpoint").equals(item.getString("point"))){
			item.put("selected", "selected");
		}else{
			item.put("selected", "");
		}
	}
	question.put(".item", item);
}
if(u.isPost()&&f.validate()){
	String status = f.get("status");

	String grade_seq = "";
	if(status.equals("20")){
		DataObject gradeDao = new DataObject("tcb_exam_result_grade");
		if(gradeDao.findCount("member_no = '"+_member_no+"' and result_seq = '"+result_seq+"' ")>0){
			DataSet grade = gradeDao.find(
					" member_no = '"+_member_no+"' "
							+" and result_seq = '"+result_seq+"'"
							+" and max_point > '"+f.get("result_point")+"'"
							+" and min_point<= '"+f.get("result_point")+"' "
			);
			if(!grade.next()){
				u.jsError("평가등급을 알 수 없습니다.");
				return;
			}
			grade_seq = grade.getString("seq");
		}
	}


	DB db = new DB();
	//db.setDebug(out);
	DataObject examResultDao = new DataObject("tcb_exam_result");
	examResultDao.item("result_point", f.get("result_point"));
	examResultDao.item("result_date", u.getTimeString());
	examResultDao.item("exam_id", auth.getString("_USER_ID"));
	examResultDao.item("status", status);
	examResultDao.item("grade_seq", grade_seq);
	db.setCommand(examResultDao.getUpdateQuery("member_no= '"+_member_no+"' and result_seq = '"+result_seq+"'"), examResultDao.record);

	// 양식 저장
	String[] question_cd = f.getArr("question_cd");
	String[] item_point = f.getArr("item_point");
	int cnt = question_cd == null? 0:question_cd.length;
	for(int i =0; i < cnt ; i ++){
		if(item_point[i].equals(""))item_point[i] = "0";
		questionDao = new DataObject("tcb_exam_result_question");
		questionDao.item("result_point", item_point[i]);
		db.setCommand(questionDao.getUpdateQuery("member_no= '"+_member_no+"' and result_seq = '"+result_seq+"' and question_cd = '"+question_cd[i]+"' "), questionDao.record);
	}
	if(!db.executeArray()){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	String msg = "저장하였습니다.";
	if(status.equals("20")){
		msg = "평가 완료 처리 하였습니다.";
	}
	u.jsAlertReplace(msg,"cont_exam_list.jsp?"+u.getQueryString("cont_no, cont_chasu, result_seq"));
	return;
}

DataObject gradeDao = new DataObject("tcb_exam_result_grade");
DataSet grade = gradeDao.find(" member_no ='"+_member_no+"' and result_seq = '"+result_seq+"' ");

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.cont_exam_modify");
p.setVar("menu_cd","000100");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000100", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setVar("cont", cont);
p.setVar("cust", cust);
p.setVar("2depth", result.getString("question_depth").equals("2"));
p.setVar("3depth", result.getString("question_depth").equals("3"));
p.setVar("exam", result);
p.setLoop("question", question);
p.setVar("edit", result.getString("status").equals("10")&&result.getString("exam_id").equals(auth.getString("_USER_ID")));
p.setVar("btn", result.getString("status").equals("10")&&result.getString("exam_id").equals(auth.getString("_USER_ID")));
p.setVar("end", result.getString("status").equals("20"));
p.setLoop("grade", grade);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu,result_seq"));
p.setVar("form_script",f.getScript());
p.display(out);
%>