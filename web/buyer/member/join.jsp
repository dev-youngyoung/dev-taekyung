<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String sec = u.request("sec");

f.addElement("vendcd1", null, "hname:'����ڵ�Ϲ�ȣ', required:'Y',option:'number',fixbyte:'3' ");
f.addElement("vendcd2", null, "hname:'����ڵ�Ϲ�ȣ', required:'Y',option:'number',fixbyte:'2'");
f.addElement("vendcd3", null, "hname:'����ڵ�Ϲ�ȣ', required:'Y',option:'number',fixbyte:'5'");
f.addElement("member_gubun", null, null);
f.addElement("member_slno1", null, "hnme:'���ι�ȣ',option:'number', minbyte:'6'");
f.addElement("member_slno2", null, "hnme:'���ι�ȣ',option:'number', minbyte:'7'");
f.addElement("member_name", null, "hname:'��ü��',required:'Y'");
f.addElement("boss_name", null, "hname:'��ǥ�ڸ�',required:'Y'");
f.addElement("condition", null, "hname:'����',required:'Y'");
f.addElement("category", null, "hname:'����', required:'Y'");
f.addElement("post_code", null, "hname:'�����ȣ',required:'Y', option:'number'");
f.addElement("address", null, "hname:'�ּ�', required:'Y'");

f.addElement("user_id", null, "hname:'���̵�', required:'Y', option:'userid', func:'validChkId'");
f.addElement("passwd", null, "hname:'��й�ȣ',required:'Y', option:'userpw', match:'passwd2', minbyte:'4', mixbyte:'20'");
f.addElement("user_name", null, "hname:'����ڸ�',required:'Y'");
f.addElement("position", null, "hname:'����',requried:'Y'");
f.addElement("email", null, "hname:'�̸���', required:'Y',option:'email'");
f.addElement("tel_num", null, "hname:'��ȭ��ȣ', required:'Y'");
f.addElement("division", null, "hname:'�μ�', required:'Y'");
f.addElement("fax_num", null, "hname:'�ѽ�'");
f.addElement("hp1", null, "hname:'�޴���ȭ', required:'Y'");
f.addElement("hp2", null, "hname:'�޴���ȭ', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", null, "hname:'�޴���ȭ', required:'Y', minbyte:'4', maxbyte:'4'");

// �Է¼���
if(u.isPost() && f.validate())
{
	String	sMemberNo	=	f.get("hdn_member_no");
	boolean	bMember		=	false;
	if(sMemberNo != null && sMemberNo.length() > 0)
	{
		bMember	=	true;
	}

	DataObject memberDao = new DataObject("tcb_member");
	if(!bMember)
	{
		if(memberDao.findCount("vendcd = '"+f.get("vendcd1")+f.get("vendcd2")+f.get("vendcd3")+"' ")>0){
			u.jsError("�̹� ���Ե� ����� ��� ��ȣ �Դϴ�.");
			return;
		}

		sMemberNo = memberDao.getOne(
				"SELECT TO_CHAR(SYSDATE, 'yyyymm') || LPAD( (NVL(MAX(SUBSTR(member_no, 7)), 0) + 1),5,'0' ) member_no"+
	    		"  FROM tcb_member WHERE  member_no like '"+u.getTimeString("yyyyMM")+"%'"
	    		    				);
		if(sMemberNo.equals("")){
	  		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �����ͷ� ���� �Ͽ� �ֽʽÿ�.");
	    	return;
	  }
	}

	memberDao.item("member_no", sMemberNo);
	memberDao.item("vendcd", f.get("vendcd1")+f.get("vendcd2")+f.get("vendcd3"));
	memberDao.item("member_name", f.get("member_name"));
	memberDao.item("member_gubun", f.get("member_gubun"));
	memberDao.item("member_type", "02");
	memberDao.item("boss_name", f.get("boss_name"));
	memberDao.item("post_code", f.get("post_code"));
	memberDao.item("address", f.get("address"));
	memberDao.item("member_slno", f.get("member_slno1")+f.get("member_slno2"));
	memberDao.item("condition", f.get("condition"));
	memberDao.item("category", f.get("category"));
	memberDao.item("join_date", u.getTimeString());
	memberDao.item("reg_date", u.getTimeString());
	memberDao.item("reg_id", f.get("user_id"));
	memberDao.item("status", "01");
	memberDao.item("market_yn", u.getCookie("event_agree_yn").equals("Y")?"Y":"N");


	String sPersonSeq = f.get("hdn_person_seq");
	boolean	bPerson = false;
	if(sPersonSeq != null && sPersonSeq.length() > 0)
	{
		bPerson	=	true;
	}

	DataObject personDao = new DataObject("tcb_person");
	if(!bPerson)
	{
		sPersonSeq = personDao.getOne(
				"select nvl(max(person_seq),0)+1 person_seq "+
				"  from tcb_person where member_no = '"+sMemberNo+"'"
				);
	}
	
	if(sPersonSeq.equals("")){
	  	u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �����ͷ� ���� �Ͽ� �ֽʽÿ�.");
	    return;
  	}

	personDao.item("member_no", sMemberNo);
	personDao.item("person_seq", sPersonSeq);
	personDao.item("user_id", f.get("user_id"));
	if(!f.get("passwd").equals("")){
	 //personDao.item("passwd", u.md5(f.get("passwd")));
	 personDao.item("passwd", u.sha256(f.get("passwd")));
	}
	personDao.item("user_name", f.get("user_name"));
	personDao.item("position", f.get("position"));
	personDao.item("division", f.get("division"));
	personDao.item("tel_num", f.get("tel_num"));
	personDao.item("fax_num", f.get("fax_num"));
	personDao.item("hp1", f.get("hp1"));
	personDao.item("hp2", f.get("hp2"));
	personDao.item("hp3", f.get("hp3"));
	personDao.item("email", f.get("email"));
	personDao.item("default_yn", "Y");
	personDao.item("use_yn", "Y");
	personDao.item("reg_date", u.getTimeString());
	personDao.item("reg_id", f.get("user_id"));
	personDao.item("user_gubun", "10");
	personDao.item("status", "1");
	personDao.item("user_level", "10");//10:������ , 20:�μ������� , 30:�Ϲݻ����
	personDao.item("event_agree_date", u.getCookie("event_agree_yn").equals("Y")?u.getTimeString():"");
	
	
	
	DB db = new DB();
	if(!bMember)
	{
		db.setCommand(memberDao.getInsertQuery(), memberDao.record);
	}else
	{
		db.setCommand(memberDao.getUpdateQuery(" member_no = '"+sMemberNo+"' "), memberDao.record);
	}

	if(!bPerson)
	{
		db.setCommand(personDao.getInsertQuery(), personDao.record);
	}else
	{
		db.setCommand(personDao.getUpdateQuery(" member_no = '"+sMemberNo+"' and person_seq = '"+sPersonSeq+"' and default_yn = 'Y' "), personDao.record);
	}
	
	/* ����� ��� ���̺� �ݿ�*/
	String vendcd = f.get("vendcd1")+f.get("vendcd2")+f.get("vendcd3");
	if(vendcd != null && !"".equals(vendcd) && vendcd.length() == 10)
	{
		DataObject	cntcBizDAO = new DataObject("tcb_cntc_biz");
		DataSet	cntcBizDS =	cntcBizDAO.query("select vendcd from tcb_cntc_biz where vendcd = '"+vendcd+"'");
		if(!cntcBizDS.next())
		{
			cntcBizDAO.item("vendcd", vendcd);
			cntcBizDAO.item("reg_date", new java.util.Date());
			cntcBizDAO.item("reg_iD", "NICEDOCU");
			db.setCommand(cntcBizDAO.getInsertQuery(), cntcBizDAO.record); 
		}	
	}

	String addMsg = "";
	if(!sec.equals(""))  // �̸��� ���� �ʴ� ���� ���
	{
		String main_member_no = "";
		String bid_no = "";
		String bid_deg = "";
		DataSet bid = null;
		String dec = u.aseDec(sec);
		String member_no = sMemberNo;
		
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
			addMsg = "[ȸ������] ���������� ���ԵǾ����ϴ�.\\n\\n[��������] �������� �����Ǿ� �������� �ʽ��ϴ�.";
		
		} else {
			DataObject clientDao = new DataObject("tcb_client");
			String id = clientDao.getOne(
					"select nvl(max(client_seq),0)+1 client_seq "+
					"  from tcb_client where member_no='"+main_member_no+"'"
				);
			clientDao.item("member_no", main_member_no);
			clientDao.item("client_no", member_no);
			clientDao.item("client_seq", id);
			clientDao.item("client_reg_cd", "1");
			db.setCommand(clientDao.getInsertQuery(), clientDao.record);
			
			if(!u.inArray(bid.getString("status"), new String[]{"03","05"}))
			{
				addMsg = "[ȸ������] ���������� ���ԵǾ����ϴ�.\\n\\n[��������] ������ ���� �Ǿ����ϴ�. ������ �������ּ���";
			}
			else 
			{
				// ���� ���� ���� Ȯ�� �� ���
				DataObject suppDao = new DataObject("tcb_bid_supp");
				DataSet supp = suppDao.find("main_member_no = '"+main_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"' and member_no = '"+member_no+"'");
				if(!supp.next())
				{
					suppDao.item("main_member_no", main_member_no);
					suppDao.item("bid_no", bid_no);
					suppDao.item("bid_deg", bid_deg);
					suppDao.item("member_no", member_no);
					suppDao.item("vendcd", f.get("vendcd1")+f.get("vendcd2")+f.get("vendcd3"));
					suppDao.item("member_name", f.get("member_name"));
					suppDao.item("boss_name", f.get("boss_name"));
					suppDao.item("user_name", f.get("user_name"));
					suppDao.item("hp1", f.get("hp1"));
					suppDao.item("hp2", f.get("hp2"));
					suppDao.item("hp3", f.get("hp3"));
					suppDao.item("email", f.get("email"));
					suppDao.item("status", 10);
					//suppDao.item("display_seq", supp.size());
					//if(bid.getString("field_yn").equals("Y")){
					//	suppDao.item("field_conf_yn", "Y");
					//}
					db.setCommand(suppDao.getInsertQuery(), suppDao.record);
				}
				
				addMsg = "[ȸ������] ���������� ���ԵǾ����ϴ�.\\n\\n�ڡڷα��� �� ��� [��������] �޴����� ���� Ȯ���ϼ���.�ڡ�";
			}		
		}
	} else if(subdomain.equals("wmp"))
	{
		DataObject clientDao = new DataObject("tcb_client");
		String id = clientDao.getOne(
				"select nvl(max(client_seq),0)+1 client_seq "+
				"  from tcb_client where member_no='20150901887'"
			);
		clientDao.item("member_no", "20150901887");
		clientDao.item("client_no", sMemberNo);
		clientDao.item("client_seq", id);
		clientDao.item("client_reg_cd", "1");
		db.setCommand(clientDao.getInsertQuery(), clientDao.record);
		
		addMsg = "[ȸ������] ���������� ���ԵǾ����ϴ�.\\n\\n�ڡ�[�������� ���� ���ð�� �ڵ����� ���ڿ� �̸��Ϸ� �ȳ��˴ϴ�.]�ڡ�";
	}
	
	System.out.print(addMsg);
	if(!db.executeArray()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �����ͷ� ���� �Ͽ� �ֽʽÿ�.");
		return;
	}
	
	if(!addMsg.equals(""))
	{
		u.jsAlert(addMsg);
	}
	else
	{
		u.jsAlert("���������� ȸ�� ���� �Ǿ����ϴ�.\\n\\n�ڡڷα��� �� ��� [�ŷ���ü����] �޴����� ���� ��ü�� �߰��ϼ���!!�ڡ�");
	}
	
	u.jsReplace("../");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setVar("menu_cd","000127");
p.setBody("member.join");
p.setVar("title_img","join");
p.setVar("form_script", f.getScript());
p.display(out);
%>