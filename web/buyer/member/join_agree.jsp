<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String sec = u.request("sec");

String main_member_no = "";
String bid_no = "";
String bid_deg = "";
DataSet bid = null;

if(!sec.equals(""))  // �̸��� ���� �ʴ� ���� ���
{
	String dec = u.aseDec(sec);
	
	String[] arrSec = dec.split("\\^");
	
	if(arrSec.length != 3)
	{
		u.jsErrClose("�������� ��η� ���� �ϼ���.");
		return;	
	}
	bid_no = arrSec[0];
	bid_deg = arrSec[1];
	main_member_no = arrSec[2];
	
	DataObject bidDao = new DataObject("tcb_bid_master");
	bid = bidDao.find("main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"'", "bid_name,bid_date,submit_sdate,submit_edate,status");
	if(!bid.next())
	{
		u.jsErrClose("���� ���� ������ �����ϴ�.");
		return;		
	}
	
	if(!u.inArray(bid.getString("status"), new String[]{"03","05"}))
	{
		u.jsErrClose("������ �����Ǿ����ϴ�. ������ �������ּ���");
		return;	
	}

	f.addElement("vendcd1", null, "hname:'����ڵ�Ϲ�ȣ', required:'Y',option:'number',fixbyte:'3' ");
	f.addElement("vendcd2", null, "hname:'����ڵ�Ϲ�ȣ', required:'Y',option:'number',fixbyte:'2'");
	f.addElement("vendcd3", null, "hname:'����ڵ�Ϲ�ȣ', required:'Y',option:'number',fixbyte:'5'");
	
	p.setVar("form_script",f.getScript());
	p.setVar("main_member_no", main_member_no);
	p.setVar("frombid", true);
}

if(u.isPost()){
	String vendcd = f.get("vendcd1") + f.get("vendcd2") + f.get("vendcd3");
	main_member_no = f.get("main_member_no");
	System.out.println("vendcd : " + vendcd);
	
	// ȸ�� ���� Ȯ��. ȸ���� �ƴ� ��� ȸ�� ���� �������� �̵�
	DataObject memberDao = new DataObject("tcb_member");
	DataSet member = memberDao.find("vendcd = '"+vendcd+"'");
	if(!member.next())
	{
		u.jsAlertReplace("���Ե� ȸ�������� �����ϴ�.  ���� Ȯ���ϱ� ���ؼ� ���� ȸ�� ���� ���ּ���.", "join.jsp?"+u.getQueryString());
		return;		
	}
	String member_no = member.getString("member_no");
	
	DB db = new DB();
	// �ŷ�ó ��� ���� Ȯ�� �� ���� ��� ���
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
		u.jsErrClose("[��������] �������� �����Ǿ� �������� �ʽ��ϴ�.");
		return;
	
	} else {
		
		if(!u.inArray(bid.getString("status"), new String[]{"03","05"}))
		{
			u.jsErrClose("[��������] ������ ���� �Ǿ����ϴ�. ������ �������ּ���.");
			return;
		}
		else 
		{
			// ���� ���� ���� Ȯ�� �� ���
			DataObject suppDao = new DataObject("tcb_bid_supp");
			DataSet supp = suppDao.find("main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"' and member_no = '"+member_no+"'");
			if(!supp.next())
			{
				System.out.println("���� ���");
				
				DataObject personDao = new DataObject("tcb_person");
				DataSet person = personDao.find("member_no='"+member_no+"' and default_yn='Y'");
				if(!person.next())
				{
					u.jsErrClose("[��������] �⺻����ڰ� ��ϵǾ� ���� �ʽ��ϴ�.");
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
				u.jsAlertReplace("�α��� �� [��������] �޴����� �ڼ��� ���� ������ Ȯ���ϼ���.", "../");
				return;				
			}
		}		
	}	
	
	if(!db.executeArray()){
		u.jsErrClose("ó�� �� ������ �߻��Ͽ����ϴ�.");
		return;	
	}		
	
	u.jsAlertReplace("�α��� �� [��������] �޴����� �ڼ��� ���� ������ Ȯ���ϼ���.", "../");
	return;

}

p.setLayout("default");
p.setVar("menu_cd","000127");
//p.setDebug(out);
p.setBody("member.join_agree");
p.display(out);
%>