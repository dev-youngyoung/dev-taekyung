<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%
String template_cd = u.request("template_cd");
String agree_seq = u.request("agree_seq");
String cont_no = u.request("cont_no");
String cont_chasu = u.request("cont_chasu");
if(!cont_no.equals("")) cont_no = u.aseDec(cont_no);
String addWhere = "";

DataSet agreeTemplate = null;
if(! (template_cd.startsWith("999999")||template_cd.equals("") )){//일반 계약
	DataObject agreeTemplateDao = new DataObject("tcb_agree_template");
	agreeTemplate= agreeTemplateDao.find("template_cd ='"+template_cd+"' and agree_seq="+agree_seq, "*", "agree_field_seq");
	if(agreeTemplate.size()==0) {
		DataObject contAgreeDao = new DataObject("tcb_cont_agree");
		agreeTemplate= contAgreeDao.find("cont_no ='"+cont_no+"' and cont_chasu = '"+cont_chasu+"'  and agree_seq="+agree_seq, "*", "agree_field_seq");
	}
}else{// 자유 서식 계약
	if(!cont_no.equals("")){
		DataObject contAgreeDao = new DataObject("tcb_cont_agree");
		agreeTemplate= contAgreeDao.find("cont_no ='"+cont_no+"' and cont_chasu = '"+cont_chasu+"'  and agree_seq="+agree_seq, "*", "agree_field_seq");
	}else{
		DataObject agreeTemplateDao = new DataObject("tcb_agree_user");
		agreeTemplate= agreeTemplateDao.find("template_cd ='"+template_cd+"' and user_id='"+_member_no+"' and agree_seq="+agree_seq, "*", "agree_field_seq");
	}	
}

if(!agreeTemplate.next()){
	u.jsErrClose("정상적인 경로로 접근해 주세요.");
	return;
}

f.addElement("s_member_name",null, null);

if(!agreeTemplate.getString("agree_field_seq").equals("")) // 부서제한인 경우
{
	if(_member_no.equals("20140900004")){ // kt m&n s
		if(agree_seq.equals("5"))//갑 서명	
			addWhere = " and field_seq in (" + agreeTemplate.getString("agree_field_seq") + ", 18, 24, 25, 29, 31)";
		else if(u.inArray(template_cd, new String[]{"2014060","2018023" ,"2018024","2019327"})) // 갑 순번이 4,3번째
			addWhere = " and field_seq in (" + agreeTemplate.getString("agree_field_seq") + ", 18, 24, 25, 29, 31,28)";
		else if(u.inArray(template_cd, new String[]{"2015141"}))
			addWhere = " and field_seq in (" + agreeTemplate.getString("agree_field_seq") + ", 24, 29 ,8 ,28)";
		else if(u.inArray(template_cd, new String[]{"2014076"}))
			addWhere = " and field_seq in (" + agreeTemplate.getString("agree_field_seq") + ", 24, 29 ,31 ,8 ,28)";
		else
			addWhere = " and field_seq=" + agreeTemplate.getString("agree_field_seq");
	}else 
		addWhere = " and field_seq=" + agreeTemplate.getString("agree_field_seq");
}

DataObject filedDao = new DataObject("tcb_field");
DataSet field = filedDao.find("member_no = '"+_member_no+"'" + addWhere, "field_seq, field_name");
DataSet person = new DataSet();

while(field.next())
{
	DataObject personDao = new DataObject();

	String sQuery =
		 " select field_seq"
		+"      , user_id person_id"
		+"      , user_name person_name"
		+"      , 2 plevel"
		+"  from tcb_person"
		+" where status>0 and use_yn = 'Y' and member_no = '" + _member_no + "'"
		+"   and field_seq = '"+field.getString("field_seq")+"'";

	if(u.inArray(template_cd, new String[]{"2015059","2015060"}) && agree_seq.equals("3"))  //씨제이올리브네트웍스 주식회사
		sQuery += " and user_id in ('oy_ckpark','oy_jin7','oy_kju747','oy_sunjung','oy_bksun','oy_minjung24','oy_minjunglee')";  // 박창기님, 진세훈님, 김정언님, 이선정님, 선보경님, 김민정님, 이민정님  

	if(_member_no.equals("20140900004") && field.getString("field_seq").equals("18")) // kt m&ns
		sQuery += " and user_id in ('mns1122014','mns1132019','mns1152006','mns1102022','mns1142013','mns1092008','mns1098863','mns1082057','mns1132014','mns1072021','mns1122013','mns1122008','mns1172017','mns1142019','mns1162018')"; // 김성호,김원재, 류선이, 안종식, 이경호, 최우영, 김세현, 이창영, 황순철 ,장성태, 김승선, 류공수, 나광연,김기태,홍성용
		
	if(_member_no.equals("20140900004") && field.getString("field_seq").equals("24")) // kt m&ns
		sQuery += " and user_id in ('mns1152060')"; // 조하연
		
	if(_member_no.equals("20140900004") && field.getString("field_seq").equals("25")) // kt m&ns
		sQuery += " and user_id in ('mns1162048','mns1132014','mns1072006','mns1122006','mns1072033','mns1152007','mns1122013','mns1088767','mns118056')"; // 임태영,황순철,홍석진,장성태,조정엽,김기봉,구태한,김승선,김지숙,이철욱
	
	if(_member_no.equals("20140900004") && field.getString("field_seq").equals("31")) // kt m&ns 
		sQuery += " and user_id in ('mns1142021','mns1082024','mns1072020')"; // 김민석, 성병진, 박진현

	if(_member_no.equals("20140900004") && field.getString("field_seq").equals("29")) // kt m&ns 	
		sQuery += " and user_id in ('mns1168122')"; // 이준엽
	
	if(_member_no.equals("20140900004") && field.getString("field_seq").equals("8")) // kt m&ns 	
			sQuery += " and user_id in ('mns1182012','mns1092007')"; // 고덕녕, 장민영
	
	if(_member_no.equals("20140900004") && field.getString("field_seq").equals("28")) // kt m&ns 	
		sQuery += " and user_id in ('mns1188715','mns1092006','mns1148278')"; // 김만섭, 조경용 , 박미진

	if(!f.get("s_member_name").equals(""))
		sQuery += " and user_name like '%" + f.get("s_member_name") + "%'";

	DataSet dsPerson = personDao.query(sQuery);
	if(dsPerson.next()){
		person.addRow();
		person.put("field_seq", field.getString("field_seq"));
		person.put("plevel", "1");
		person.put("person_id", "");
		person.put("person_name", field.getString("field_name"));

		dsPerson.first();
		while(dsPerson.next()){
			person.addRow(dsPerson.getRow());
		}
		
	} 
}

int i=0;
person.first();
while(person.next())
	person.put("__no", ++i);

p.setLayout("popup");
p.setDebug(out);
p.setBody("contract.pop_inter_person");
p.setVar("popup_title","사용자 선택");
p.setLoop("person", person);
p.setVar("form_script",f.getScript());
p.display(out);
%>