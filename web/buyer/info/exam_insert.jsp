<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] code_exam_type = {"10=>정기평가","20=>수시평가"};
boolean isCJ = _member_no.equals("20130400333");  // 씨제이대한통운


f.addElement("exam_name", null, "hname:'평가지명', required:'Y'");
f.addElement("question_depth", "3", "hname:'문항depth', required:'Y'");
f.addElement("exam_type", null, "hname:'평가유형'");

if(u.isPost()&&f.validate()){
	
	DB db = new DB();
	//db.setDebug(out);
	DataObject examDao = new DataObject("tcb_exam");
	String exam_cd = examDao.getOne(
	" SELECT TO_CHAR(SYSDATE, 'yyyy') || LPAD( (NVL(MAX(TO_NUMBER(SUBSTR(exam_cd, 4))), 0) + 1), 3, '0' ) exam_cd "
   +" from tcb_exam where member_no = '"+_member_no+"'"
     );
	examDao.item("member_no", _member_no);
	examDao.item("exam_cd", exam_cd);
	examDao.item("exam_name", f.get("exam_name"));
	examDao.item("question_cnt", f.get("question_cnt"));
	examDao.item("question_depth", f.get("question_depth"));
	examDao.item("exam_type", "10");
	examDao.item("use_yn", "Y");
	examDao.item("reg_id", auth.getString("_USER_ID"));
	examDao.item("reg_date", u.getTimeString());
	
	db.setCommand(examDao.getInsertQuery(),examDao.record);
	
	String[] arr_l_div = f.getArr("l_div_nm");
	String[] arr_m_div = f.getArr("m_div_nm");
	String[] arr_s_div = f.getArr("s_div_nm");
	String[] arr_point = f.getArr("point");
	String[] arr_rate = f.getArr("rate"); // 가중치
	String[] arr_rate_point = f.getArr("rate_point");  //환산점수
	String[] arr_etc = f.getArr("etc");
	
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
	
	
	DataSet question = new DataSet();
	 
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
			question.addRow();
			question.put("member_no", _member_no);
			question.put("exam_cd", exam_cd);
			question.put("question_cd", u.strrpad(l_div_cd+"",3,"0")+ u.strrpad(m_div_cd+"",3,"0")+ u.strrpad(s_div_cd+"",3,"0"));
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
			question.addRow();
			question.put("member_no", _member_no);
			question.put("exam_cd", exam_cd);
			question.put("question_cd", u.strrpad(l_div_cd+"",3,"0")+ u.strrpad(m_div_cd+"",3,"0")+ u.strrpad(s_div_cd+"",3,"0"));
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
				question.addRow();
				question.put("member_no", _member_no);
				question.put("exam_cd", exam_cd);
				question.put("question_cd", u.strrpad(l_div_cd+"",3,"0")+ u.strrpad(m_div_cd+"",3,"0")+ u.strrpad(s_div_cd+"",3,"0"));
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
		db.setCommand(questionDao.getInsertQuery(),questionDao.record);
		
	}
	
	if(isCJ && f.get("question_depth").equals("3"))
	{
		String[] ar_question_cd = new String[] {"001001001","001002001","001003001","001004001","001005001","002001001"};
		String[][] ar_point = new String[][] {
				{"20","16","12","8","4","0"},
				{"20","16","12","8","4","0"},
				{"20","16","12","8","4","0"},
				{"20","10","0"},
				{"20","0"},
				{"0"}
			};
		String[][] ar_item_text = new String[][] {
				{"10% 이상","8% 이상","6% 이상","4% 이상","2% 이상","0% 이상"},
				{"200% 미만","200%~250% 미만","250%~300% 미만","300%~350% 미만","350%~400% 미만","400% 이상"},
				{"200% 이상","150%~200% 미만","100%~150% 미만","50%~100% 미만","0% 초과~50% 미만","0% 이하"},
				{"A등급","B등급","C등급 이하 및 신용등급 無"},
				{"체납사실 無","체납사실 有"},
				{"자동계산"}
			};			
		
		
		for(int i=0; i<ar_question_cd.length; i++)
		{
			for(int j=0; j<ar_point[i].length; j++)
			{
				DataObject examItemDao = new DataObject("tcb_exam_item");
				examItemDao.item("member_no", _member_no);
				examItemDao.item("exam_cd", exam_cd);
				examItemDao.item("question_cd", ar_question_cd[i]);
				examItemDao.item("item_seq", j);
				examItemDao.item("point", ar_point[i][j]);
				examItemDao.item("item_text", ar_item_text[i][j]);
				db.setCommand(examItemDao.getInsertQuery(),examItemDao.record);
			}
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
p.setVar("menu_cd","000113");
p.setBody("info.exam_modify");
p.setLoop("code_exam_type", u.arr2loop(code_exam_type));
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.setVar("isCJ", isCJ);
p.display(out);

%>