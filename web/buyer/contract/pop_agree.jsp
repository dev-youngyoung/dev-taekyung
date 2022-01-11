<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%

// 전자결재 승인 대상 목록
if(auth.getString("_MEMBER_TYPE").equals("01")||auth.getString("_MEMBER_TYPE").equals("03")){
	f.addElement("s_template_cd", null, null);
	
	String s_status = u.inArray(_member_no, new String[]{"20171101813","20130500457"}) ? "'21'" : "'11','21','30'";  // sk브로드밴드는 승인대기건만
	
	DataObject templateDao = new DataObject();
	DataSet template = templateDao.query("select template_name, template_cd from tcb_cont_template where template_cd in (select template_cd from tcb_contmaster where member_no = '"+_member_no+"' and status in ('11','20','21','30','40','41') group by template_cd) order by display_seq asc, template_cd desc");
	
	DataObject daoAgree = new DataObject();
	String sql = "select * from"
    +"("
    +"    select ta.cont_no, ta.cont_chasu, tm.cont_name, tm.cont_date, tm.template_cd,tc.member_name, agree_seq, "
    +"            (select min(agree_seq) from tcb_cont_agree where cont_no=ta.cont_no and cont_chasu=ta.cont_chasu and ag_md_date is null) confirm_seq, "
    +"            (select ag_md_date from tcb_cont_agree where cont_no=ta.cont_no AND cont_chasu=ta.cont_chasu AND agree_seq = ta.agree_seq-1) last_agree_date"
    +"    from tcb_cont_agree ta inner join tcb_contmaster tm on ta.cont_no=tm.cont_no and ta.cont_chasu=tm.cont_chasu and status in ("+s_status+")"
    +"         inner join tcb_cust tc on tm.cont_no=tc.cont_no and tm.cont_chasu=tc.cont_chasu and tc.display_seq = (select max(display_seq) from tcb_cust where cont_no=tm.cont_no and cont_chasu=tm.cont_chasu)"
    +"    where agree_person_id = '"+auth.getString("_USER_ID")+"'";
    
	if(!f.get("s_template_cd").equals(""))			    
   		sql += "      and tm.template_cd = '"+f.get("s_template_cd")+"'";

	sql += ")"
	+"where agree_seq = confirm_seq "
	+"order by last_agree_date desc ";	
	
	DataSet dsAgree = daoAgree.query(sql);
	while(dsAgree.next())
	{
		dsAgree.put("cont_no", u.aseEnc(dsAgree.getString("cont_no")));
		dsAgree.put("last_agree_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", dsAgree.getString("last_agree_date")));
	}

	p.setLoop("template", template);
	p.setLoop("agree", dsAgree);
	p.setVar("form_script", f.getScript());
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_agree");
p.setVar("popup_title","검토/승인 대기 계약");
p.display(out);


%>