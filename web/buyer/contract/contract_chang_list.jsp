<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String _menu_cd = "000058";

CodeDao code = new CodeDao("tcb_comcode");

String s_sdate = u.request("s_sdate", u.getTimeString("yyyy-MM-dd",u.addDate("M",-3)));
String s_edate = u.request("s_edate");

f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(15);


list.setTable(" tcb_contmaster a, tcb_cust b");
list.addWhere(" a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu");
list.addWhere("b.list_cust_yn = 'Y'");

list.setFields(
		"a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date, a.status, a.cont_userno, b.member_name "
	+" ,( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt "
	+" ,( select template_type from tcb_cont_template where template_cd = a.template_cd) template_type "
	+" ,( select template_cd from tcb_contmaster where cont_no= a.cont_no and a.cont_chasu= 0 ) org_template_cd "
);

list.addWhere(" a.member_no = '"+_member_no+"' ");

String[] ing_cont_member = //변경계약을 완료되지 않은 건으로도 작성 하는 회원
{
		 "20121000003"//(주)아이티엠반도체
		,"20121000046"//한국파렛트풀 주식회사
		,"20130700108"//(주)인터파크비즈마켓
		,"20130900194"//(주)카카오
		,"20140300055"//한국유리공업(주)
		,"20140900004"//(주)케이티엠앤에스
		,"20150900434"//나디아퍼시픽 주식회사
};
if(u.inArray(_member_no,ing_cont_member)){
	list.addWhere(" a.status in ('20','30','31','40','41','50')");
}else{
	list.addWhere(" a.status = '50'");
}
list.addWhere(" a.subscription_yn is null");//신청서 제외
list.addWhere(" a.cont_chasu = (select max(cont_chasu) from tcb_contmaster where cont_no = a.cont_no) ");
if(!s_sdate.equals(""))list.addWhere(" a.cont_date >= '"+s_sdate.replaceAll("-","")+"'");
if(!s_edate.equals(""))list.addWhere(" a.cont_date <= '"+s_edate.replaceAll("-","")+"'");
list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
list.addSearch("a.cont_userno",  f.get("s_cust_userno"), "LIKE");
list.addSearch("b.member_name",  f.get("s_cust_name"), "LIKE");
/*조회권한*/
if(!auth.getString("_DEFAULT_YN").equals("Y")){
	//10:담당조회  20:부서조회 
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("10")){
		list.addWhere("a.reg_id = '"+auth.getString("_USER_ID")+"' ");
	}
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("20")){
		list.addWhere(
				 "(                                                          "
				+"  a.field_seq in (                                           "
				+"  select field_seq                                           "
				+"    from tcb_field                                           "
				+"   where member_no = '"+_member_no+"'                        "
				+"   start with field_seq = '"+auth.getString("_FIELD_SEQ")+"' "
				+" connect by prior field_seq = p_field_seq	                   "
				+" )	                   	                   	               "
				+")                                                          "
				);
	}
}

/* 성능을 위해 정렬 안함. 변경계약은 어차피 업체 검색을 하게 마련이기 때문 2018.09.18
list.setOrderBy("a.cont_no desc, a.cont_chasu asc");
*/

DataSet ds = list.getDataSet();
DataObject templateDao = new DataObject("tcb_cont_template");
while(ds.next()){
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if(ds.getInt("cont_chasu")>0)
		ds.put("cont_name",ds.getString("cont_name") + " ("+ds.getString("cont_chasu")+"차)");
	if(ds.getInt("cust_cnt")-2>0){
		ds.put("cust_name", ds.getString("member_name")+ "외"+(ds.getInt("cust_cnt")-2)+"개사");
	}else{
		ds.put("cust_name", ds.getString("member_name"));
	}
	//ds.put("link", ds.getString("template_cd").equals("")?"contract_chang_insert.jsp":"contract_free_chang_insert.jsp");
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	DataSet template = new DataSet();
	if(!ds.getString("template_cd").equals("")){//일반서식 계약인 경우
		if(ds.getString("template_type").equals("00")){//변경계약서식이 없는 경우 자기 양식만-> 내꺼 또는 지정된 서식 지니뮤직 때문에 변경 20191111
			template = templateDao.find(
					 "    member_no like '%"+_member_no+"%' "
					+" and ("
					+"         template_cd = '"+ds.getString("template_cd")+"' "
					+"     or ("
					+"             org_template_cd like '%"+ds.getString("template_cd")+"%'"
					+"         and template_type in ('20','30')"
					+"         and use_yn = 'Y' "
					+ "       ) "
					+"     ) "
					, "template_cd, nvl(display_name,template_name) template_name, sign_types"
					, "display_seq asc"
			);
		}
		if(u.inArray(ds.getString("template_type"), new String[]{"10","20"})){//최초 및 변경 계약
			String template_cd = ds.getString("org_template_cd");//역인계약의 기능때문에 최초계약의 org_template_cd를 부르는듯.. 유팀장님 맞나요?
			if(template_cd.equals("")){
				template_cd = ds.getString("template_cd");
			}
			template = templateDao.find(
					  "     org_template_cd like '%"+template_cd+"%' "
					+ " and template_type in ('20','30') "
					+ " and member_no like '%"+_member_no+"%' and use_yn = 'Y' "
					, "template_cd, nvl(display_name,template_name) template_name, sign_types"
					, "display_seq asc"
			);
		}
	}else{  
		template = templateDao.find(" member_no like '%"+_member_no+"%' and use_yn = 'Y' ", "template_cd, nvl(display_name,template_name) template_name, sign_types", "display_seq asc");  // 변경(20), 취소(30) 양식
	}
	ds.put(".template", template);
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_chang_list");
p.setVar("menu_cd",_menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>
