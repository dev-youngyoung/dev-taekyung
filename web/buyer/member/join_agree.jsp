<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String sec = u.request("sec");

String main_member_no = "";
String bid_no = "";
String bid_deg = "";
DataSet bid = null;

if(!sec.equals(""))  // 이메일 입찰 초대 받은 경우
{
	String dec = u.aseDec(sec);
	
	String[] arrSec = dec.split("\\^");
	
	if(arrSec.length != 3)
	{
		u.jsErrClose("정상적인 경로로 접근 하세요.");
		return;	
	}
	bid_no = arrSec[0];
	bid_deg = arrSec[1];
	main_member_no = arrSec[2];
	
	DataObject bidDao = new DataObject("tcb_bid_master");
	bid = bidDao.find("main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"'", "bid_name,bid_date,submit_sdate,submit_edate,status");
	if(!bid.next())
	{
		u.jsErrClose("입찰 공고 정보가 없습니다.");
		return;		
	}
	
	if(!u.inArray(bid.getString("status"), new String[]{"03","05"}))
	{
		u.jsErrClose("입찰이 마감되었습니다. 다음에 참여해주세요");
		return;	
	}

	f.addElement("vendcd1", null, "hname:'사업자등록번호', required:'Y',option:'number',fixbyte:'3' ");
	f.addElement("vendcd2", null, "hname:'사업자등록번호', required:'Y',option:'number',fixbyte:'2'");
	f.addElement("vendcd3", null, "hname:'사업자등록번호', required:'Y',option:'number',fixbyte:'5'");
	
	p.setVar("form_script",f.getScript());
	p.setVar("main_member_no", main_member_no);
	p.setVar("frombid", true);
}

if(u.isPost()){
	String vendcd = f.get("vendcd1") + f.get("vendcd2") + f.get("vendcd3");
	main_member_no = f.get("main_member_no");
	System.out.println("vendcd : " + vendcd);
	
	// 회원 여부 확인. 회원이 아닌 경우 회원 가입 페이지로 이동
	DataObject memberDao = new DataObject("tcb_member");
	DataSet member = memberDao.find("vendcd = '"+vendcd+"'");
	if(!member.next())
	{
		u.jsAlertReplace("가입된 회원정보가 없습니다.  공고를 확인하기 위해서 먼저 회원 가입 해주세요.", "join.jsp?"+u.getQueryString());
		return;		
	}
	String member_no = member.getString("member_no");
	
	DB db = new DB();
	// 거래처 등록 여부 확인 후 없는 경우 등록
	DataObject clientDao = new DataObject("tcb_client");
	DataSet client = clientDao.find("member_no = '"+main_member_no+"' and client_no = '"+member_no+"'");
	if(!client.next())
	{
		String id = clientDao.getOne(
				"select nvl(max(client_seq),0)+1 client_seq "+
				"  from tcb_client where member_no='"+main_member_no+"'"
			);
		clientDao.item("member_no", main_member_no);
		clientDao.item("client_no", member_no);
		clientDao.item("client_seq", id);
		clientDao.item("client_reg_cd", "1");
		db.setCommand(clientDao.getInsertQuery(), clientDao.record);
		
	}
	
	DataObject bidDao = new DataObject("tcb_bid_master");
	bid = bidDao.find("main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"'", "bid_name,bid_date,submit_sdate,submit_edate,status");
	if(!bid.next())
	{
		u.jsErrClose("[전자입찰] 입찰공고가 삭제되어 존재하지 않습니다.");
		return;
	
	} else {
		
		if(!u.inArray(bid.getString("status"), new String[]{"03","05"}))
		{
			u.jsErrClose("[전자입찰] 입찰이 마감 되었습니다. 다음에 참여해주세요.");
			return;
		}
		else 
		{
			// 공고에 참여 여부 확인 후 등록
			DataObject suppDao = new DataObject("tcb_bid_supp");
			DataSet supp = suppDao.find("main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"' and member_no = '"+member_no+"'");
			if(!supp.next())
			{
				System.out.println("공고 등록");
				
				DataObject personDao = new DataObject("tcb_person");
				DataSet person = personDao.find("member_no='"+member_no+"' and default_yn='Y'");
				if(!person.next())
				{
					u.jsErrClose("[전자입찰] 기본담당자가 등록되어 있지 않습니다.");
					return;
				
				} 						
				
				suppDao.item("main_member_no", main_member_no);
				suppDao.item("bid_no", bid_no);
				suppDao.item("bid_deg", bid_deg);
				suppDao.item("member_no", member_no);
				suppDao.item("vendcd", vendcd);
				suppDao.item("member_name", member.getString("member_name"));
				suppDao.item("boss_name", member.getString("boss_name"));
				suppDao.item("user_name", member.getString("user_name"));
				suppDao.item("hp1", person.getString("hp1"));
				suppDao.item("hp2", person.getString("hp2"));
				suppDao.item("hp3", person.getString("hp3"));
				suppDao.item("email", person.getString("email"));
				suppDao.item("status", "10");
				//suppDao.item("display_seq", supp.size());
				//if(bid.getString("field_yn").equals("Y")){
				//	suppDao.item("field_conf_yn", "Y");
				//}
				db.setCommand(suppDao.getInsertQuery(), suppDao.record);
			}
			else
			{
				u.jsAlertReplace("로그인 후 [전자입찰] 메뉴에서 자세한 공고 내용을 확인하세요.", "../");
				return;				
			}
		}		
	}	
	
	if(!db.executeArray()){
		u.jsErrClose("처리 중 오류가 발생하였습니다.");
		return;	
	}		
	
	u.jsAlertReplace("로그인 후 [전자입찰] 메뉴에서 자세한 공고 내용을 확인하세요.", "../");
	return;

}

p.setLayout("default");
p.setVar("menu_cd","000127");
//p.setDebug(out);
p.setBody("member.join_agree");
p.display(out);
%>