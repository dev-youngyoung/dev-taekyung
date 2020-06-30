<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="../contract/include_cont_push.jsp" %>
<%

String key = u.request("key");
String template_cd = u.request("template_cd");
String agree_seq = u.request("agree_seq");

String contstr = u.aseDec(key);  // ���ڵ�
if(contstr.length() != 12)
{
	out.print("No Permission!!");
	return;
}
String cont_no = contstr.substring(0,11);
String cont_chasu = contstr.substring(11);



String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";

DB db = new DB();

ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(where+" and member_no = "+_member_no+" ");
if(!cont.next()){
	u.jsError("������ ���� ���� �ʽ��ϴ�.");
	return;
}

//���� ����
String now_agree_seq = "";
DataObject agreeDao = new DataObject("tcb_cont_agree");
DataSet agree = agreeDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and r_agree_person_id is null and agree_cd='1'","agree_seq","agree_seq asc", 1);
if(!agree.next()){
}
now_agree_seq = agree.getString("agree_seq");

if(!now_agree_seq.equals("")){
	if(!agree_seq.equals(now_agree_seq)){
		u.jsError("�����ڰ� �ùٸ��� �ʽ��ϴ�.");
		return;
	}
}

if(!u.inArray(cont.getString("status"),new String[]{"10","11"})){// �ۼ���, ���ΰ��� �� ���� ����
	u.jsError("������ �ۼ���,���ΰ����� ���¿����� ���� ���� �մϴ�.");
	return;
}

contDao.item("mod_req_date","");
contDao.item("mod_req_reason","");
contDao.item("mod_req_member_no","");
contDao.item("status","20");
db.setCommand(contDao.getUpdateQuery(where), contDao.record);
if(!now_agree_seq.equals("")){
	agreeDao = new DataObject("tcb_cont_agree");
	agreeDao.item("ag_md_date", u.getTimeString());
	agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
	agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
	db.setCommand( agreeDao.getUpdateQuery( where +" and agree_seq='"+now_agree_seq+"'"),agreeDao.record);
}

/* ���α� START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "���ڹ��� �߽�",  "", "20", "10");
/* ���α� END*/

if(!db.executeArray()){
	u.jsError("���ۿ� ���� �Ͽ����ϴ�.");
	return;
}

DataObject templateDao = new DataObject();
String send_type = templateDao.getOne("select send_type from tcb_cont_template where template_cd='"+cont.getString("template_cd")+"' ");

//SMS email ����
DataObject custDao = new DataObject("tcb_cust");
//custDao.setDebug(out);
DataSet cust = custDao.find(where, "tcb_cust.*, (select status from tcb_member where member_no = tcb_cust.member_no) member_status");

String sender_name = auth.getString("_MEMBER_NAME");
while(cust.next()){
	if(!cust.getString("member_no").equals(_member_no)){

		SmsDao smsDao= new SmsDao();
		String email_random = u.getRandString(20);
		custDao = new DataObject("tcb_cust");
		custDao.item("email_random", email_random);
		if(!custDao.update(where+" and member_no = '"+cust.getString("member_no")+"' ")){
		}
		
		//SMS����
		if(!cust.getString("hp2").equals("0000") && !cust.getString("hp1").equals("") && !cust.getString("hp2").equals("")){
			String mail_site = cust.getString("email").split("@")[1];
			if(send_type.equals("10")) {//���� �˾� ���� ������ ����
				smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), auth.getString("_MEMBER_NAME") + " ���� ���ڰ�༭ �����û " + mail_site + "�̸��� Ȯ�� - ���̽���ť");
			} else if(send_type.equals("20")){// �޴��� ���� ���� ����
				String linkUrl = request.getRequestURL().substring(0, request.getRequestURL().indexOf("/web/buyer")) + "/web/buyer/sdd/email_msign_callback.jsp?cont_no="+u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random="+email_random;
				String subject ="[���̽���ť]"+auth.getString("_MEMBER_NAME")+" �ȳ�"; 
				String longMessage = "["+auth.getString("_MEMBER_NAME")+"] ��༭�� ���ڼ������ּ��� \n" 
						+ " *�ȳ�* \n1.���Ź��� ��༭�� ���� PC������ ���ڼ����� �����մϴ�.("+cust.getString("email")
						+ "���� Ȯ�ΰ���) \n2.�ý��� �̿� ���Ǵ� ���̽���ť �����ͷ� ���ּ���. \n3.��� ���� ���Ǵ� ����ü�� ������ڿ��� ���ּ���.\n"
						+ linkUrl;
				smsDao.sendLMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), subject,longMessage);
			}else{// �Ϲ� ����Ʈ �α��� ����
				String cust_name = auth.getString("_MEMBER_NAME");
				if(cust.getString("member_status").equals("02")){//��ȸ�� ������ ���
	                smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), cust_name+"���� ��༭ �����û-www.nicedocu.com(�Ϲݱ����)����>ȸ������ �� ���");
				}else{
					if(u.inArray(_member_no, new String[] {"20180101078","20180101074"})) {
						cust_name = "������";
					}
	                smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), cust_name+"���� ��༭ �����û-www.nicedocu.com(�Ϲݱ����)����>�α��� �� ���");
				}
			}
		}
		
		//�̸��� ����
		if(!cust.getString("email").equals("")){
			DataObject contEmailDao = new DataObject("tcb_cont_email");
			String email_seq = contEmailDao.getOne("select nvl(max(email_seq),0)+1 from tcb_cont_email where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cust.getString("member_no")+"' ");
			contEmailDao.item("cont_no", cont_no);
			contEmailDao.item("cont_chasu", cont_chasu);
			contEmailDao.item("member_no", cust.getString("member_no"));
			contEmailDao.item("email_seq", email_seq);
			contEmailDao.item("send_date", u.getTimeString());
			contEmailDao.item("user_name", cust.getString("user_name"));
			contEmailDao.item("email", cust.getString("email"));
			contEmailDao.item("status", "01");
			if(!contEmailDao.insert()){
			}
			
			String return_url = "";
			if(send_type.equals("10")){
				return_url = "web/buyer/sdd/email_callback.jsp?cont_no="+u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random="+email_random;
			}else if(send_type.equals("20")){
				return_url = "web/buyer/sdd/email_msign_callback.jsp?cont_no="+u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random="+email_random;
				//System.out.println("/web/buyer/sdd/email_msign_callback.jsp?cont_no="+u.aseEnc(cust.getString("cont_no"))+"&cont_chasu="+cont_chasu+"&email_random="+email_random);
			}else{
				if(cust.getString("member_no").substring(0,9).equals("000000000")){ // ���뺸������ �̸��Ϸ� �ٷ� ���� �����ϰ� ȸ���� ����Ʈ�� �α����ϵ���
					return_url = "web/buyer/contract/emailView.jsp?rs="+email_random;
				}else{
					if(cust.getString("member_status").equals("02")){  // ��ȸ��
						return_url = "web/buyer/member/join_agree.jsp";
					}else{  // ȸ��
						return_url =  "web/buyer/index.jsp";
					}
				}
			}
			
			DataSet mailInfo = new DataSet();
			mailInfo.addRow();
			mailInfo.put("send_member_name", auth.getString("_MEMBER_NAME"));
			mailInfo.put("cont_name", cont.getString("cont_name"));
			mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
			mailInfo.put("member_name", cust.getString("member_name"));
			p.setVar("info", mailInfo);
			p.setVar("server_name", request.getServerName());
			p.setVar("return_url", return_url);
			p.setVar("recv_check_url", "/web/buyer/contract/emailReadCheck.jsp?cont_no="+cont_no+"&cont_chasu="+cont_chasu+"&member_no="+cust.getString("member_no")+"&num="+email_seq);
			String mail_body = p.fetch("../html/mail/cont_send_mail.html");
			u.mail(cust.getString("email"), "[���̽���ť] "+auth.getString("_MEMBER_NAME")+"���� ��༭ �����û", mail_body );
		}
	}
}


//��༭ push
if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK�����, �������̺�ε����� ���
	DataSet result = contPush_skstoa(cont_no, cont_chasu);//���Ϸ� push
	if(!result.getString("succ_yn").equals("Y")){
		u.sp(" skstore ������� ���� ����!!!\npage:contract_send_pop.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		u.mail("nicedocu@nicednr.co.kr","skstore ������� ���� ����!!! ", " skstore ������� ���� ����!!!\npage:contract_send_pop.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
	}
}

u.jsErrClose("��༭�� �����Ͽ����ϴ�.");

%>