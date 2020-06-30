<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] kind_cd = {"N=>신규","S=>수시","R=>정기"};
String[] status_cd = {"10=>평가대상","20=>평가중","50=>평가완료"};

f.addElement("s_member_name", null, null);
f.addElement("s_asse_year", null, null);
f.addElement("s_project_name", null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(15);
list.setTable(
		" (select a.asse_no, to_number(sum(total_point)) as t_point, to_number(sum(rating_point)) as r_point, count(*) as cnt ,  "
				+" 	       to_number(sum(total_point) / count(*)) as tp, to_number(sum(rating_point) / count(*)) as rp  "
				+"  from tcb_assemaster a, tcb_assedetail b "
				+"  where a.asse_no = b.asse_no "
				+"  group by a.asse_no, a.asse_year, a.member_no ) tt "
				+" , tcb_assemaster a "
);

list.setFields(
		" a.asse_year, a.member_name, a.project_name, a.kind_cd, to_number(tt.tp) as tp, to_number(tt.rp) as rp "
				+" ,(select to_number(sb.rating_point) as qc_rpoint from tcb_assedetail sb where sb.asse_no = a.asse_no and div_cd = 'Q' and sb.status = '50') as qc_rpoint  "
				+" ,(select to_number(sb.total_point) as qc_tpoint from tcb_assedetail sb where sb.asse_no = a.asse_no and div_cd = 'Q' and sb.status = '50') as qc_tpoint "
				+" ,(select to_number(sb.rating_point) as enc_rpoint from tcb_assedetail sb where sb.asse_no = a.asse_no and div_cd = 'E' and sb.status = '50') as enc_rpoint "
				+" ,(select to_number(sb.total_point) as enc_tpoint from tcb_assedetail sb where sb.asse_no = a.asse_no and div_cd = 'E' and sb.status = '50') as enc_tpoint "
				+" ,(select to_number(sb.rating_point) as f_rpoint from tcb_assedetail sb where sb.asse_no = a.asse_no and div_cd = 'F' and sb.status = '50') as f_rpoint "
				+" ,(select to_number(sb.total_point) as f_tpoint from tcb_assedetail sb where sb.asse_no = a.asse_no and div_cd = 'F' and sb.status = '50') as f_tpoint "
				+" ,(select to_number(sb.rating_point) as s_rpoint from tcb_assedetail sb where sb.asse_no = a.asse_no and div_cd = 'S' and sb.status = '50') as s_rpoint "
				+" ,(select to_number(sb.total_point) as s_trpoint from tcb_assedetail sb where sb.asse_no = a.asse_no and div_cd = 'S' and sb.status = '50') as s_tpoint "
				+" , a.member_no , a.asse_no"
);
list.addWhere("a.asse_no = tt.asse_no");

// 소싱그룹 검색
if((!f.get("l_src_cd").equals(""))||(!f.get("m_src_cd").equals(""))||(!f.get("s_src_cd").equals(""))){
	String src_cd_member = "select b.member_no"
			+" from tcb_src_member a inner join tcb_member b on a.src_member_no = b.member_no"
			+" inner join tcb_src_adm c on a.member_no = c.member_no and substr(a.src_cd,0,3)||'000000' = c.src_cd"
			+" inner join tcb_src_adm d on a.member_no = d.member_no and substr(a.src_cd,0,6)||'000' = d.src_cd"
			+" inner join tcb_src_adm e on a.member_no = e.member_no and a.src_cd = e.src_cd"
			+" where a.member_no = '20130300071' "
			+"   and e.src_cd = '"+f.get("l_src_cd")+f.get("m_src_cd")+f.get("s_src_cd")+"'";
	list.addWhere("a.member_no in ("+src_cd_member+")");
}

list.addWhere("a.main_member_no = '"+_member_no+"' ");
list.addSearch("a.member_name", f.get("s_member_name"), "LIKE");
list.addSearch("a.asse_year", f.get("s_asse_year"));
list.addSearch("a.project_name", f.get("s_project_name"), "LIKE");
list.setOrderBy("a.asse_year desc, a.member_no desc ");

DataSet	ds = list.getDataSet();
while(ds.next()){

	ds.put("asse_kind_cd", u.getItem(ds.getString("kind_cd"), kind_cd));	//평가종류
	if("".equals(ds.getString("qc_tpoint"))){	//QC
		ds.put("qc_point", "-");
	}else{
		ds.put("qc_point", "<a href=javascript:goCheckSheet('assessment_q_checkSheet_sumetime.jsp','"+ds.getString("asse_no")+"')>"+ds.getString("qc_rpoint")+"</a>");
	}
	if("".equals(ds.getString("enc_tpoint"))){	//ENC
		ds.put("enc_point", "-");
	}else{
		ds.put("enc_point", "<a href=javascript:goCheckSheet('assessment_e_checkSheet_sumetime.jsp','"+ds.getString("asse_no")+"')>"+ds.getString("enc_rpoint")+"</a>");
	}
	if("".equals(ds.getString("f_tpoint"))){	//안전
		ds.put("f_point", "-");
	}else{
		ds.put("f_point", "<a href=javascript:goCheckSheet('assessment_f_checkSheet_sumetime.jsp','"+ds.getString("asse_no")+"')>"+ds.getString("f_rpoint")+"</a>");
	}

	if("".equals(ds.getString("s_tpoint"))){		//구매
		ds.put("s_point", "-");
	}else{
		if("N".equals(ds.getString("kind_cd"))){	//신규
			ds.put("s_point", "<a href=javascript:goCheckSheet('assessment_s_checkSheet_new.jsp','"+ds.getString("asse_no")+"')>"+ds.getString("s_rpoint")+"</a>");
		}else{	//정기
			ds.put("s_point", "<a href=javascript:goCheckSheet('assessment_s_checkSheet_regular.jsp','"+ds.getString("asse_no")+"')>"+ds.getString("s_rpoint")+"</a>");
		}
	}
}

if(u.isPost()&&f.validate()){
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.asse_purchase_list");
p.setVar("menu_cd","000106");
p.setLoop("list", ds);
p.setVar("l_src_cd", f.get("l_src_cd"));
p.setVar("m_src_cd", f.get("m_src_cd"));
p.setVar("s_src_cd", f.get("s_src_cd"));
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>