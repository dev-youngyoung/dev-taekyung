<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}
String list_url = u.request("list_url", "member_list");

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsError("업체정보가 없습니다.");
	return;
}
DataObject clientDao = new DataObject("tcb_client");

boolean cust_view = false;
DataSet cust = new DataSet();
if(u.inArray(member.getString("member_type"), new String[]{"02","03"}) ){//원사업자 관리
	cust_view = true;
	cust = clientDao.query(
			 "select a.member_no, a.member_name, a.vendcd, a.boss_name, b.client_reg_date, b.client_seq"
			+"  from tcb_member a, tcb_client b                                   "
			+" where a.member_no = b.member_no                                    "
			+"   and b.client_no = '"+member_no+"'                                "
			+" order by b.client_reg_date desc                                         "
			);
	while(cust.next()){
		cust.put("client_reg_date", u.getTimeString("yyyy-MM-dd HH:mm", cust.getString("client_reg_date")));
		cust.put("vendcd", u.getBizNo(cust.getString("vendcd")));
	}
}

boolean client_view = false;
DataSet client = new DataSet();
if(u.inArray(member.getString("member_type"), new String[]{"01","03"}) ){//수급사업자 관리
	client_view = true;
	client = clientDao.query(
		 "select a.member_no, a.member_name, a.vendcd, a.boss_name, b.client_reg_date, b.client_seq"
		+"  from tcb_member a, tcb_client b                                   "
		+" where a.member_no = b.client_no                                    "
		+"   and b.member_no = '"+member_no+"'                                "
		+" order by b.client_seq desc                                         "
			);
	while(client.next()){
		client.put("reg_date", u.getTimeString("yyyy-MM-dd HH:mm", client.getString("client_reg_date")));
		client.put("vendcd", u.getBizNo(client.getString("vendcd")));
	}
}
	
// 입력수정
if(u.isPost() && f.validate()){
	if(f.get("gubun").equals("cust")){//원사업자추가
		
		String cust_member_no = f.get("cust_member_no"); 
		if(cust_member_no.equals("")){
			u.jsError("정상적인 경로로 접근하세요.");
			return;
		}
		
		clientDao = new DataObject("tcb_client");
		if(clientDao.findCount(" member_no = '"+cust_member_no+"' and client_no = '"+member_no+"' ")> 0 ){
			u.jsError("이미 등록되어 있는 거래처 입니다.");
			return;
		}
		
		String client_seq = clientDao.getOne(
				"  select nvl(max(client_seq),0)+1 client_seq "+
				"    from tcb_client "+
				"   where member_no = '"+cust_member_no+"'"
			); 
		clientDao.item("member_no", cust_member_no);
		clientDao.item("client_seq", client_seq);
		clientDao.item("client_no", member_no);
		clientDao.item("client_reg_cd","1");
		clientDao.item("client_reg_date", u.getTimeString());
		if(!clientDao.insert()){
			u.jsError("처리에 실패 하였습니다.");
			return;
		}
	}
	if(f.get("gubun").equals("client")){//수급사업자추가
		String client_member_no = f.get("client_member_no"); 
		if(client_member_no.equals("")){
			u.jsError("정상적인 경로로 접근하세요.");
			return;
		}
		clientDao = new DataObject("tcb_client");
		
		if(clientDao.findCount(" member_no = '"+member_no+"' and client_no = '"+client_member_no+"' ")> 0 ){
			u.jsError("이미 등록되어 있는 거래처 입니다.");
			return;
		}
		
		String client_seq = clientDao.getOne(
				"  select nvl(max(client_seq),0)+1 client_seq "+
				"    from tcb_client "+
				"   where member_no = '"+member_no+"'"
			); 
		clientDao.item("member_no", member_no);
		clientDao.item("client_seq", client_seq);
		clientDao.item("client_no", client_member_no);
		clientDao.item("client_reg_cd","1");
		clientDao.item("client_reg_date", u.getTimeString());
		if(!clientDao.insert()){
			u.jsError("처리에 실패 하였습니다.");
			return;
		}
	}
	u.jsAlertReplace("처리하였습니다.", "client_view.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
p.setDebug(out);
p.setBody("buyer.client_view");
if(list_url.indexOf("pay_comp_list")>-1)
	p.setVar("menu_cd","000045");
else
	p.setVar("menu_cd","000044");
p.setVar("member", member);
p.setVar("cust_view", cust_view);
p.setLoop("cust", cust);
p.setVar("client_view", client_view);
p.setLoop("client", client);
p.setVar("list_url", list_url);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no,list_url"));
p.display(out);
%>