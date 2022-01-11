<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

String cont_no = u.request("cont_no");
String cont_chasu = u.request("cont_chasu");
if(cont_no.equals("")||cont_chasu.equals("")){
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

DataObject examDao = new DataObject("tcb_exam");
DataSet exam = examDao.find(" member_no = '"+_member_no+"' and exam_type='20' and use_yn='Y'");
if(!exam.next()){
	u.jsError("평가지 정보가 없습니다.");
	return;
}
String exam_cd = exam.getString("exam_cd");

DataObject questionDao = new DataObject("tcb_exam_question");
DataSet question = questionDao.query(
		" select a.*               "
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
			,"item_text, to_number(point) point "
			, " item_seq asc"
	);
	question.put(".item", item);
}

if(u.isPost()&&f.validate()){
	String status = f.get("status");

	String grade_seq = "";
	if(status.equals("20")){
		DataObject gradeDao = new DataObject("tcb_exam_grade");
		//gradeDao.setDebug(out);
		if(gradeDao.findCount(" member_no = '"+_member_no+"' and exam_cd = '"+exam.getString("exam_cd")+"' ") > 0 ){
			DataSet grade = gradeDao.find(
					" member_no = '"+_member_no+"' "
							+" and exam_cd = '"+exam.getString("exam_cd")+"'"
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
	DataObject resultDao = new DataObject("tcb_exam_result");
	String result_seq = resultDao.getOne(
			" select TO_CHAR(SYSDATE, 'yyyymm') || LPAD((nvl(max(to_number(substr(result_seq,7))),0)+1),4,'0')  result_seq "
					+"   from tcb_exam_result "
					+"  where member_no = '"+_member_no+"' "
					+"    and substr(result_seq,0,6) = TO_CHAR(SYSDATE, 'yyyymm')    "
	);

	DataObject examResultDao = new DataObject("tcb_exam_result");
	examResultDao.item("member_no", _member_no);
	examResultDao.item("result_seq", result_seq);
	examResultDao.item("exam_cd", exam.getString("exam_cd"));
	examResultDao.item("client_no", cust.getString("member_no"));
	examResultDao.item("exam_type", "20");
	examResultDao.item("question_depth", exam.getString("question_depth"));
	examResultDao.item("result_point", f.get("result_point"));
	examResultDao.item("result_date", u.getTimeString());
	examResultDao.item("exam_id", auth.getString("_USER_ID"));
	examResultDao.item("status", status);
	examResultDao.item("cont_no", cont_no);
	examResultDao.item("cont_chasu", cont_chasu);
	examResultDao.item("grade_seq", grade_seq);
	db.setCommand(examResultDao.getInsertQuery(), examResultDao.record);

	// 양식 저장
	StringBuffer query = new StringBuffer();
	query.append(" insert into tcb_exam_result_question (member_no,result_seq,question_cd,l_div_cd,m_div_cd,s_div_cd,depth,question,point,result_point,etc)  \n");
	query.append(" select member_no                       \n");
	query.append("       , '"+result_seq+"' result_seq    \n");
	query.append("       , question_cd                    \n");
	query.append("       , l_div_cd                       \n");
	query.append("       , m_div_cd                       \n");
	query.append("       , s_div_cd                       \n");
	query.append("       , depth                          \n");
	query.append("       , question                       \n");
	query.append("       , point         				  \n");
	query.append("       , '0' result_point         	  \n");
	query.append("       , etc         					  \n");
	query.append("   from tcb_exam_question               \n");
	query.append("  where member_no = '"+_member_no+"'    \n");
	query.append("    and exam_cd = '"+exam.getString("exam_cd")+"' \n");
	db.setCommand(query.toString(),null);

	String[] question_cd = f.getArr("question_cd");
	String[] item_point = f.getArr("item_point");
	DataObject resultQuestionDao = null;
	int cnt = question_cd == null? 0:question_cd.length;
	for(int i =0; i < cnt ; i ++){
		if(item_point[i].equals(""))item_point[i] = "0";
		resultQuestionDao = new DataObject("tcb_exam_result_question");
		resultQuestionDao.item("result_point", item_point[i]);
		db.setCommand(resultQuestionDao.getUpdateQuery("member_no = '"+_member_no+"' and result_seq = '"+result_seq+"' and question_cd= '"+question_cd[i]+"' "), resultQuestionDao.record);
	}

	db.setCommand("delete from tcb_exam_result_item where member_no = '"+_member_no+"' and result_seq = '"+result_seq+"' ", null);
	query = new StringBuffer();
	query.append(" insert into tcb_exam_result_item (member_no, result_seq,question_cd,item_seq,item_text,point )  \n");
	query.append(" select member_no                   \n");
	query.append("       , '"+result_seq+"' result_seq \n");
	query.append("       , question_cd                \n");
	query.append("       , item_seq                   \n");
	query.append("       , item_text                  \n");
	query.append("       , point                      \n");
	query.append("   from tcb_exam_item               \n");
	query.append("  where member_no = '"+_member_no+"'              \n");
	query.append("    and exam_cd = '"+exam.getString("exam_cd")+"' \n");
	db.setCommand(query.toString(), null);


	db.setCommand("delete from tcb_exam_result_grade where member_no = '"+_member_no+"' and result_seq = '"+result_seq+"' ", null);
	query = new StringBuffer();
	query.append(" insert into tcb_exam_result_grade (member_no,result_seq,seq,grade,level_o,grade_text,max_point,min_point)   \n");
	query.append(" select member_no                   \n");
	query.append("       , '"+result_seq+"' result_seq \n");
	query.append("       ,seq                          \n");
	query.append("       ,grade                        \n");
	query.append("       ,level_o                      \n");
	query.append("       ,grade_text                   \n");
	query.append("       ,max_point                    \n");
	query.append("       ,min_point                    \n");
	query.append("   from tcb_exam_grade               \n");
	query.append("  where member_no = '"+_member_no+"'              \n");
	query.append("    and exam_cd = '"+exam.getString("exam_cd")+"' \n");
	db.setCommand(query.toString(), null);

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

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.cont_exam_modify");
p.setVar("menu_cd","000100");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000100", "btn_auth").equals("10"));
p.setVar("cont", cont);
p.setVar("cust", cust);
p.setVar("2depth", exam.getString("question_depth").equals("2"));
p.setVar("3depth", exam.getString("question_depth").equals("3"));
p.setVar("exam", exam);
p.setLoop("question", question);
p.setVar("edit", true);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu,result_seq"));
p.setVar("form_script",f.getScript());
p.display(out);
%>