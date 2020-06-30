package dao;

import nicelib.util.*;
import nicelib.db.*;

public class SmsDao extends DataObject {

	public String sender_key = "db7a13360184505cb51b9c511b7d18f2b253934c";//īī�� ������ Ű
	
	public SmsDao() {
		this.table = "em_tran";
	}
	
	
	public boolean sendSMS(String systemGubun,String recvHp1, String recvHp2, String recvHp3, String smsMsg)
	{
		boolean bSuccess = false;
		String[] code_hp1 = {"010","011","016","017","018","019"}; 
		// ���޵� ���� ������ �϶��� ó��
		if ( 	
			 (recvHp1 != null) && (recvHp1.length() == 3)
			 &&	(recvHp2 != null) && (recvHp2.length() >= 3)
			 &&	(recvHp3 != null) && (recvHp3.length() >= 3) && !recvHp3.equals("0000")
			 && (smsMsg != null) && !smsMsg.equals("")
			 && Util.inArray(recvHp1, code_hp1)
			)
		{
			String tran_callback = "027889097"; //
			String tran_phone = recvHp1+ recvHp2+ recvHp3;// "-" ������ 12�ڸ� �����»�� ��ȭ��ȣ (������ �����߰�)
			
			try {
				String sHostName;
				sHostName = java.net.InetAddress.getLocalHost().getHostName();
				if(sHostName.equals("docu01") || sHostName.equals("docu02")) // �Ǽ����� sms ����
				{
					DB db = new DB();
					//db.setDebug(out);
					DataObject smsDao = new DataObject("em_tran");
					smsDao.item("tran_phone", tran_phone.trim());
					smsDao.item("tran_callback", tran_callback);					
					smsDao.item("tran_status", "1");
					//smsDao.item("tran_date", Util.getTimeString("yyyyMMddHHmmss"));
					smsDao.item("tran_msg", smsMsg);
					smsDao.item("tran_type", "4");
					smsDao.item("tran_id", "NDD002");
					
					String query = 
					 " INSERT INTO em_tran       "
					+"          (                "
					+"            tran_pr        "
					+"          , tran_phone     "
					+"          , tran_callback  "
					+"          , tran_status    "
					+"          , tran_date      "
					+"          , tran_msg       "
					+"          , tran_type      "
					+"          , tran_id        "
					+"          ) VALUES (       "
					+"          seq_sms.nextval  "
					+"          , $tran_phone$   "
					+"          , $tran_callback$"
					+"          , $tran_status$  "
					+"			, SYSDATE        "
					+"		    , $tran_msg$     "
					+"		    , $tran_type$    "
					+"		    , $tran_id$      "
					+"          )                ";
					System.out.println(query);
					db.setCommand(query, smsDao.record);
					if(!db.executeArray()){
						System.out.println("//-------------------- [SMS���� ����] --------------------//");
						System.out.println("  - �޴»�� �޴���ȭ : " + tran_phone);
						System.out.println("  - ���� �޽��� : " + smsMsg);
						System.out.println("//--------------------------------------------------//");
					} 
					else
					{
						System.out.println("//-------------------- [SMS����] --------------------//");
						System.out.println("  - �޴»�� �޴���ȭ : " + tran_phone);
						System.out.println("  - ���� �޽��� : " + smsMsg);
						System.out.println("//--------------------------------------------------//");
					}
					bSuccess = true;					
				}
				else
				{
					System.out.println("//-------------------- [���� SMS����:���߿�] --------------------//");
					System.out.println("  - �޴»�� �޴���ȭ : " + tran_phone);
					System.out.println("  - ���� �޽��� : " + smsMsg);
					System.out.println("//--------------------------------------------------//");
					bSuccess = true;
				}
		
				
			} catch (Exception e) {
				e.printStackTrace();
			}			

		}
		else
		{
			System.out.println("[ERROR "+this.getClass()+".sendSMS()] : ���޵� parmater�� ������ �ֽ��ϴ�.");
			System.out.println("recvHp1:"+recvHp1);
			System.out.println("recvHp2:"+recvHp2);
			System.out.println("recvHp3:"+recvHp3);
			System.out.println("smsMsg:"+smsMsg);
		}
		
		return bSuccess;
		
	}
	
	public boolean sendLMS(String systemGubun,String recvHp1, String recvHp2, String recvHp3, String subject, String smsMsg)
	{
		boolean bSuccess = false;
		String[] code_hp1 = {"010","011","016","017","018","019"}; 
		// ���޵� ���� ������ �϶��� ó��
		if ( 	
			 (recvHp1 != null) && (recvHp1.length() == 3)
			 &&	(recvHp2 != null) && (recvHp2.length() >= 3)
			 &&	(recvHp3 != null) && (recvHp3.length() >= 3) && !recvHp3.equals("0000")
			 && (smsMsg != null) && !smsMsg.equals("")
			 && Util.inArray(recvHp1, code_hp1)
			)
		{
			String tran_callback = "027889097"; //
			String tran_phone = recvHp1+ recvHp2+ recvHp3;// "-" ������ 12�ڸ� �����»�� ��ȭ��ȣ (������ �����߰�)
			
			try {
				String sHostName;
				sHostName = java.net.InetAddress.getLocalHost().getHostName();
				if(sHostName.equals("docu01") || sHostName.equals("docu02")) // �Ǽ����� sms ����
				{
				

					DB db = new DB();
					
					DataObject smsDao = new DataObject("em_tran");
					DataSet ds= smsDao.query("select em_tran_mms_seq.nextval mms_seq from dual");
					while(!ds.next()){
					}
					String mms_seq = ds.getString("mms_seq");
					smsDao.item("tran_phone", tran_phone.trim());
					smsDao.item("tran_callback", tran_callback);					
					smsDao.item("tran_status", "1");
					//smsDao.item("tran_msg", smsMsg);
					smsDao.item("tran_type", "6");
					smsDao.item("tran_id", "NDD002");
					smsDao.item("tran_ etc4", mms_seq);
					
					String query = 
					 " INSERT INTO em_tran       "
					+"          (                "
					+"            tran_pr        "
					+"          , tran_phone     "
					+"          , tran_callback  "
					+"          , tran_status    "
					+"          , tran_date      "
					//+"          , tran_msg       "
					+"          , tran_type      "
					+"          , tran_id        "
					+"          , tran_etc4      "
					+"          ) VALUES (       "
					+"          seq_sms.nextval  "
					+"          , $tran_phone$   "
					+"          , $tran_callback$"
					+"          , $tran_status$  "
					+"			, SYSDATE        "
					//+"		    , $tran_msg$     "
					+"		    , $tran_type$    "
					+"		    , $tran_id$      "
					+"		    , $tran_ etc4$   "
					+"          )                ";
					
					db.setCommand(query, smsDao.record);
					
					DataObject mmsDao = new DataObject("em_tran_mms");
					mmsDao.item("mms_seq", mms_seq);
					mmsDao.item("file_cnt",0);
					mmsDao.item("mms_subject", Util.cutString(subject, 35) );
					mmsDao.item("mms_body", smsMsg);
					db.setCommand(mmsDao.getInsertQuery(), mmsDao.record);
					
					if(!db.executeArray()){
						System.out.println("//-------------------- [LMS���� ����] --------------------//");
						System.out.println("  - �޴»�� �޴���ȭ : " + tran_phone);
						System.out.println("  - ���� �޽��� : " + smsMsg);
						System.out.println("//--------------------------------------------------//");
					}
					
					bSuccess = true;					
				}
				else
				{
					System.out.println("//-------------------- [���� LMS����:���߿�] --------------------//");
					System.out.println("  - �޴»�� �޴���ȭ : " + tran_phone);
					System.out.println("  - ���� �޽��� : " + smsMsg);
					System.out.println("//--------------------------------------------------//");
					bSuccess = true;
				}
		
				
			} catch (Exception e) {
				e.printStackTrace();
			}			

		}
		else
		{
			System.out.println("[ERROR "+this.getClass()+".sendLMS()] : ���޵� parmater�� ������ �ֽ��ϴ�.");
			System.out.println("recvHp1:"+recvHp1);
			System.out.println("recvHp2:"+recvHp2);
			System.out.println("recvHp3:"+recvHp3);
			System.out.println("smsMsg:"+smsMsg);
		}
		
		return bSuccess;
		
	}
	
	public boolean sendKakaoTalk(String systemGubun, String recvHp1, String recvHp2, String recvHp3, String smsMsg,String re_type, String re_body) {
		boolean bSuccess = false;
		String[] code_hp1 = {"010","011","016","017","018","019"}; 
		// ���޵� ���� ������ �϶��� ó��
		if ( 	
			 (recvHp1 != null) && (recvHp1.length() == 3)
			 &&	(recvHp2 != null) && (recvHp2.length() >= 3)
			 &&	(recvHp3 != null) && (recvHp3.length() >= 3) && !recvHp3.equals("0000")
			 && (smsMsg != null) && !smsMsg.equals("")
			 && Util.inArray(recvHp1, code_hp1)
			)
		{
			
			String template_code = "";
			
			String tran_callback = "027889097"; //
			String tran_phone = recvHp1+ recvHp2+ recvHp3;// "-" ������ 12�ڸ� �����»�� ��ȭ��ȣ (������ �����߰�)
			
			try {
				String sHostName;
				sHostName = java.net.InetAddress.getLocalHost().getHostName();
				if(sHostName.equals("docu01") || sHostName.equals("docu02")) // �Ǽ����� sms ����
				{
				

					DB db = new DB();
					
					DataObject smsDao = new DataObject("em_tran");
					DataSet ds= smsDao.query("select em_tran_kko_seq.nextval kko_seq from dual");
					while(!ds.next()){
					}
					String kko_seq = ds.getString("kko_seq");
					smsDao.item("tran_phone", tran_phone.trim());
					smsDao.item("tran_callback", tran_callback);					
					smsDao.item("tran_status", "1");
					smsDao.item("tran_type", "7");
					smsDao.item("tran_id", "NDD002");
					smsDao.item("tran_ etc4", kko_seq);
					
					String query = 
					 " INSERT INTO em_tran       "
					+"          (                "
					+"            tran_pr        "
					+"          , tran_phone     "
					+"          , tran_callback  "
					+"          , tran_status    "
					+"          , tran_date      "
					+"          , tran_type      "
					+"          , tran_id        "
					+"          , tran_etc4      "
					+"          ) VALUES (       "
					+"          seq_sms.nextval  "
					+"          , $tran_phone$   "
					+"          , $tran_callback$"
					+"          , $tran_status$  "
					+"			, SYSDATE        "
					+"		    , $tran_type$    "
					+"		    , $tran_id$      "
					+"		    , $tran_ etc4$   "
					+"          )                ";
					
					db.setCommand(query, smsDao.record);
					
					DataObject kkoDao = new DataObject("em_tran_kko");
					kkoDao.item("mms_seq", kko_seq);
					kkoDao.item("sender_key",sender_key);
					kkoDao.item("template_code", template_code);
					kkoDao.item("nation_code", "82");
					kkoDao.item("message",smsMsg);
					kkoDao.item("re_type", re_type);
					kkoDao.item("re_body", re_body);
					db.setCommand(kkoDao.getInsertQuery(), kkoDao.record);
					
					if(!db.executeArray()){
						System.out.println("//-------------------- [LMS���� ����] --------------------//");
						System.out.println("  - �޴»�� �޴���ȭ : " + tran_phone);
						System.out.println("  - ���� �޽��� : " + smsMsg);
						System.out.println("//--------------------------------------------------//");
					}
					
					bSuccess = true;					
				}
				else
				{
					System.out.println("//-------------------- [���� LMS����:���߿�] --------------------//");
					System.out.println("  - �޴»�� �޴���ȭ : " + tran_phone);
					System.out.println("  - ���� �޽��� : " + smsMsg);
					System.out.println("//--------------------------------------------------//");
					bSuccess = true;
				}
		
				
			} catch (Exception e) {
				e.printStackTrace();
			}			

		}
		else
		{
			System.out.println("[ERROR "+this.getClass()+".sendLMS()] : ���޵� parmater�� ������ �ֽ��ϴ�.");
			System.out.println("recvHp1:"+recvHp1);
			System.out.println("recvHp2:"+recvHp2);
			System.out.println("recvHp3:"+recvHp3);
			System.out.println("smsMsg:"+smsMsg);
		}
		
		return bSuccess;
	}
	
	

}