<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] code_exam_type = {"10=>정기평가","20=>수시평가"};
boolean isCJ = _member_no.equals("20130400333");  // 씨제이대한통운

String exam_cd = u.request("exam_cd");
if(exam_cd.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

String where= " member_no = '"+_member_no+"' and exam_cd ='"+exam_cd+"' ";

DataObject examDao = new DataObject("tcb_exam");
DataSet exam = examDao.find( where );
if(!exam.next()){
	u.jsError("평가지 정보가 없습니다.");
	return;
}

DataSet question = examDao.query(
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
	+"       , (                                "
	+"          select count(item_seq)          "
	+"            from tcb_exam_item            "
	+"           where member_no = a.member_no  "
	+"             and exam_cd = a.exam_cd      "
	+"             and question_cd = a.question_cd "
	+"          )  item_cnt                     "
	+"   from tcb_exam_question a               "
	+"  where member_no = '"+_member_no+"'      "
	+"    and exam_cd = '"+exam_cd+"'           "
	+"    and depth = '"+exam.getString("question_depth")+"' "
	+"  order by question_cd asc 			    "
);



f.addElement("exam_name", exam.getString("exam_name"), "hname:'평가지명', required:'Y'");
f.addElement("question_depth", exam.getString("question_depth"), "hname:'문항depth', required:'Y'");
f.addElement("exam_type", exam.getString("exam_type"), "hname:'평가유형'");


if(u.isPost()&&f.validate()){
	
	DB db = new DB();
	//db.setDebug(out);
	examDao.item("member_no", _member_no);
	examDao.item("exam_cd", exam_cd);
	examDao.item("exam_name", f.get("exam_name"));
	examDao.item("question_cnt", f.get("question_cnt"));
	examDao.item("question_depth", f.get("question_depth"));
	examDao.item("exam_type", f.get("exam_type"));
	examDao.item("reg_id", auth.getString("_USER_ID"));
	examDao.item("reg_date", u.getTimeString());
	db.setCommand(examDao.getUpdateQuery(where),examDao.record);
	
	db.setCommand(" delete from tcb_exam_item where "+ where, null);
	db.setCommand(" delete from tcb_exam_question where "+ where, null);
	
	String[] arr_l_div = f.getArr("l_div_nm");
	String[] arr_m_div = f.getArr("m_div_nm");
	String[] arr_s_div = f.getArr("s_div_nm");
	String[] arr_point = f.getArr("point");
	String[] arr_rate = f.getArr("rate"); // 가중치
	String[] arr_rate_point = f.getArr("rate_point");  //환산점수	
	String[] arr_etc = f.getArr("etc");
	String[] arr_question_cd = f.getArr("question_cd");
	
	String l_div_nm = "";
	String m_div_nm = "";
	String s_div_nm = "";

	String _l_div_nm = "";
	String _m_div_nm = "";
	String _s_div_nm = "";
	
	int	l_div_cd = 0;	//	대분류코드
	int	m_div_cd = 0;	//	중분류코드
	int	s_div_cd = 0;	//	소분류코드
	int	depth =	0;	//	DEPTH 
	
	
	DataSet temp = new DataSet();
	temp.addRow(); 
	
	question = new DataSet();
	for(int i=0; i < arr_l_div.length ; i++){
		l_div_nm = arr_l_div[i];
		m_div_nm = arr_m_div[i];
		if(f.get("question_depth").equals("3")){
			s_div_nm = arr_s_div[i];
		}
		
		if(!l_div_nm.equals(_l_div_nm)){
			l_div_cd++;
			m_div_cd = 0;
			s_div_cd = 0;
			_l_div_nm = l_div_nm;
			_m_div_nm = "";
			_s_div_nm = "";
			String question_cd = u.strrpad(l_div_cd+"",3,"0")+ u.strrpad(m_div_cd+"",3,"0")+ u.strrpad(s_div_cd+"",3,"0");
			question.addRow();
			question.put("member_no", _member_no);
			question.put("exam_cd", exam_cd);
			question.put("question_cd", question_cd);
			question.put("l_div_cd", u.strrpad(l_div_cd+"",3,"0"));
			question.put("m_div_cd", u.strrpad(m_div_cd+"",3,"0"));
			question.put("s_div_cd", u.strrpad(s_div_cd+"",3,"0"));
			question.put("question", l_div_nm);
			question.put("depth","1");
			question.put("point", 0);
			question.put("rate", 0);
			question.put("rate_point", 0);			
			question.put("etc", "");
		}
		if(!m_div_nm.equals(_m_div_nm)){
			m_div_cd ++;
			s_div_cd = 0;
			_m_div_nm = m_div_nm;
			_s_div_nm = "";
			String question_cd = u.strrpad(l_div_cd+"",3,"0")+ u.strrpad(m_div_cd+"",3,"0")+ u.strrpad(s_div_cd+"",3,"0");
			question.addRow();
			question.put("member_no", _member_no);
			question.put("exam_cd", exam_cd);
			question.put("question_cd", question_cd);
			question.put("l_div_cd", u.strrpad(l_div_cd+"",3,"0"));
			question.put("m_div_cd", u.strrpad(m_div_cd+"",3,"0"));
			question.put("s_div_cd", u.strrpad(s_div_cd+"",3,"0"));
			question.put("question", m_div_nm);
			question.put("depth","2");
			if(f.get("question_depth").equals("2")){
				question.put("point", arr_point[i]);
				if(isCJ) {
					question.put("rate", arr_rate[i]);
					question.put("rate_point", arr_rate_point[i]);
				} else {
					question.put("rate", 0);
					question.put("rate_point", 0);					
				}
				question.put("etc", arr_etc[i]);
				if(!arr_question_cd[i].equals("")){
					temp.put(arr_question_cd[i],question_cd);
				}
			}else{
				question.put("point", 0);
				question.put("rate", 0);
				question.put("rate_point", 0);				
				question.put("etc", "");
			}
		}
		
		if(f.get("question_depth").equals("3")){
			if(!s_div_nm.equals(_s_div_nm)){
				_s_div_nm = s_div_nm;
				s_div_cd++;
				String question_cd = u.strrpad(l_div_cd+"",3,"0")+ u.strrpad(m_div_cd+"",3,"0")+ u.strrpad(s_div_cd+"",3,"0");
				question.addRow();
				question.put("member_no", _member_no);
				question.put("exam_cd", exam_cd);
				question.put("question_cd", question_cd);
				question.put("l_div_cd", u.strrpad(l_div_cd+"",3,"0"));
				question.put("m_div_cd", u.strrpad(m_div_cd+"",3,"0"));
				question.put("s_div_cd", u.strrpad(s_div_cd+"",3,"0"));
				question.put("question", s_div_nm);
				question.put("depth","3");
				question.put("point", arr_point[i]);
				if(isCJ) {
					question.put("rate", arr_rate[i]);
					question.put("rate_point", arr_rate_point[i]);
				} else {
					question.put("rate", 0);
					question.put("rate_point", 0);					
				}				
				question.put("etc", arr_etc[i]);
				if(!arr_question_cd[i].equals("")){
					temp.put(arr_question_cd[i],question_cd);
				}
			}
		}
	}	
	
	question.first();
	while(question.next()){
		DataObject questionDao = new DataObject("tcb_exam_question"); 
		questionDao.item("member_no", _member_no);
		questionDao.item("exam_cd", question.getString("exam_cd"));
		questionDao.item("question_cd", question.getString("question_cd"));
		questionDao.item("l_div_cd", question.getString("l_div_cd"));
		questionDao.item("m_div_cd", question.getString("m_div_cd"));
		questionDao.item("s_div_cd", question.getString("s_div_cd"));
		questionDao.item("question", question.getString("question"));
		questionDao.item("depth", question.getString("depth"));
		questionDao.item("point", question.getString("point"));
		questionDao.item("rate", question.getString("rate"));
		questionDao.item("rate_point", question.getString("rate_point"));
		questionDao.item("etc", question.getString("etc"));		
		questionDao.item("etc", question.getString("etc"));
		db.setCommand(questionDao.getInsertQuery(),questionDao.record);
		
	}
	
	
	DataObject itemDao = new DataObject("tcb_exam_item");
	DataSet item = itemDao.find(where);
	while(item.next()){
		if(!temp.getString(item.getString("question_cd")).equals("")){
			itemDao =  new DataObject("tcb_exam_item");
			itemDao.item("member_no", _member_no);
			itemDao.item("exam_cd", exam_cd);
			itemDao.item("question_cd", temp.getString(item.getString("question_cd")));
			itemDao.item("item_seq", item.getString("item_seq"));
			itemDao.item("item_text", item.getString("item_text"));
			itemDao.item("point", item.getString("point"));
			db.setCommand(itemDao.getInsertQuery(), itemDao.record);
		}
	}
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("저장하였습니다.", "exam_view.jsp?exam_cd="+exam_cd);
	return;	
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.exam_modify");
p.setVar("modify", true);
p.setVar("exam", exam);
p.setLoop("code_exam_type", u.arr2loop(code_exam_type));
p.setLoop("question", question);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.setVar("isCJ", isCJ);
p.display(out);
%>