package procure.mail;
/*******************************************************************
 *�ۼ���   :   ���������.E-biz��.���ؿ�
 *�ۼ����� :  �� �ɽ��ؼ���..
 *�ۼ����� :  2003.03
 *Parameter: �Ʒ� main() ����.
 *��������:  �������, ������ ������ ����� ���� �ݵ�� �̸����ּ� ���忡 �¾� �Ѵ�.
 *******************************************************************/

import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;

import procure.common.conf.Startup;

import java.util.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
public class OkkiMail {

    private static String host = Startup.conf.getString("email.mailHost"); // "mail.dnbkorea.com";
    
    public static void main(String args[]){

               String IP = "";
		// try{IP=
		// (String)java.net.InetAddress.getLocalHost().getHostAddress();}catch(Exception
		// e){}
		// if(!IP.equals("172.28.5.56")){host="www.dnbkorea.com";}

		/***********************************************************************
		 * �������θ� ǥ���ص� ������ ���� �˸����� ������ ****** //�޼ҵ�.1 OkkiMail.sendJavaMail(
		 * "okki@dnbkorea.com", //�޴»�� �����ּ�. "129���� �߼�" //��������. );
		 * 
		 * 
		 * //�޼ҵ�.2 OkkiMail.sendJavaMail( "okki@dnbkorea.com", //�޴»�� �����ּ� new
		 * String[]{""}, //������ �迭 "okki@nice.co.kr", //������ ��� �ּ� "����� �ּҶ��Դϴ�.",
		 * //�������� "����� �����Դϴ�." //���Ϻ��� );
		 * 
		 * //�޼ҵ� 3 ..÷������ ������ OkkiMail.sendJavaMail( new String[]{"\"��غ����ؿ�\"
		 * <okki@dnbkorea.com>"}, //������ �̸� �ּ� �迭 new String[]{""}, //������ �̸� �ּ�
		 * �迭 "\"���ؿ�\" <okki@nice.co.kr>", //����: "���ؿ�" <okki@nice.co.kr> :������ ���
		 * �̸�,�ּ� "�׽�Ʈ�Դϴ� �������ô��� ���� �ּ���.", //�������� "����� �����Դϴ�. ", //���Ϻ���
		 * "/user2/dnbkorea/bbs/file/�����Ŵٽú���032.jpg" //÷������(�ϴ� �ϳ�������) );
		 * 
		 * 
		 **********************************************************************/

		/*
		 * if(args.length ==0){ OkkiMail.sendJavaMail( "okki@dnbkorea.com",
		 * //�޴»�� �����ּ�. "���� �߼��׽�Ʈ" //��������. ); System.out.println("�߼��׽�Ʈ");
		 * }else{ OkkiMail.sendJavaMail( args[0], //�޴»�� �����ּ�. "���� �߼��׽�Ʈ"
		 * //��������. ); }
		 */

		String[] strTo = { "\"������\" <sunghoonryu@gmail.com>" };
		String[] strCc = null;// {"drought@dreamwiz.com"};
		String[] strBcc = null;// {"drought@dreamwiz.com"};
		String strFrom = Startup.conf.getString("email.mailFrom");
		String strFromName = "���̽���غ�";
		String strSubject = "���� Test�� ���� �� �Դϴ�.";
		String strContents = "�� ������ D&B Korea BBS ���� Test�� ���� �� �Դϴ�.";
		String attchFile = "";
		//sendJavaMail(strTo, strCc, strBcc, strFrom, strFromName, strSubject, strContents, attchFile);
		try {
			boolean bSuccess = mail("sunghoonryu@gmail.com", "������", "���̽���ť �����׽�Ʈ�Դϴ�.", "��� �ູ�ϼ���.");
			System.out.println("�׽�Ʈ���� ���� ���� : " + bSuccess);
		} catch (Exception e) {
			System.out.println("�׽�Ʈ���� ���� ����");
		}		

    }

    
	// Send Mail
	public static boolean mail(String mailTo, String mailToName, String subject, String body) throws Exception {
		return mail(mailTo, mailToName, subject, body, null);
	}

	public static boolean mail(String mailTo, String mailToName, String subject, String body, String filepath) throws Exception {
		String encoding = "EUC-KR";

		// �Ǽ�����
		String mailHost = host;
		String mailFrom = Startup.conf.getString("email.mailFrom"); //"nicedocu@info.nicednb.com";

		// ���� �׽�Ʈ��
		//String mailHost = "sendmail.nice.co.kr";		
		//String mailFrom = "shryu@nicednb.com";  
		
		Properties props = new Properties();
		props.put("mail.smtp.host", mailHost);

		Session msgSession = Session.getDefaultInstance(props, null);

		try {
			MimeMessage msg = new MimeMessage(msgSession);
			InternetAddress from = new InternetAddress(mailFrom, "���̽���ť", "UTF-8");
			InternetAddress to = new InternetAddress(mailTo, mailToName, "UTF-8");
			//InternetAddress to = new InternetAddress(mailTo);
	
			msg.setFrom(from);
			msg.setRecipient(Message.RecipientType.TO, to);
			msg.setSubject(subject, "UTF-8");
			msg.setSentDate(new Date());
	
			if(filepath == null) {
				msg.setContent(body, "text/html; charset=" + encoding);
			} else {
				MimeBodyPart mbp1 = new MimeBodyPart();
				mbp1.setContent(body, "text/html; charset=" + encoding);
				MimeBodyPart mbp2 = new MimeBodyPart();
	
				FileDataSource fds = new FileDataSource(filepath);
				mbp2.setDataHandler(new DataHandler(fds));
				mbp2.setFileName(fds.getName());
	
				Multipart mp = new MimeMultipart();
				mp.addBodyPart(mbp1);
				mp.addBodyPart(mbp2);
	
				msg.setContent(mp);
			}
	
			Transport.send(msg);
		} catch (Exception e) {
			System.out.println("[���� ���� ����]"+mailTo+" �������� ���߽��ϴ�.");
			return false;
		}
		return true;
	}    
 
	public static boolean mail_apt(String mailTo, String mailToName, String subject, String body, String filepath) throws Exception {
		String encoding = "EUC-KR";
		
		String sHostName;
		sHostName = java.net.InetAddress.getLocalHost().getHostName();
		if(!sHostName.equals("docu01") && !sHostName.equals("docu02")) // �Ǽ����� sms ����
		{
			System.out.println("//-------------------- [���� �̸�������:���߿�] --------------------//");
			System.out.println("  - �޴� ��� : " + mailTo);
			System.out.println("//--------------------------------------------------//");
			return true;
		}		
		
		// �Ǽ�����
		String mailHost = host;
		String mailFrom = Startup.conf.getString("email.mailFrom");
		
		// ���� �׽�Ʈ��
		//String mailHost = "sendmail.nice.co.kr";		
		//String mailFrom = "shryu@nicednb.com";  
		
		Properties props = new Properties();
		props.put("mail.smtp.host", mailHost);
		
		Session msgSession = Session.getDefaultInstance(props, null);
		
		try {
			MimeMessage msg = new MimeMessage(msgSession);
			InternetAddress from = new InternetAddress(mailFrom, "����Ʈ��������", "UTF-8");
			InternetAddress to = new InternetAddress(mailTo, mailToName, "UTF-8");
			
			msg.setFrom(from);
			msg.setRecipient(Message.RecipientType.TO, to);
			msg.setSubject(subject, "UTF-8");
			msg.setSentDate(new Date());
			
			if(filepath == null) {
				msg.setContent(body, "text/html; charset=" + encoding);
			} else {
				MimeBodyPart mbp1 = new MimeBodyPart();
				mbp1.setContent(body, "text/html; charset=" + encoding);
				MimeBodyPart mbp2 = new MimeBodyPart();
				
				FileDataSource fds = new FileDataSource(filepath);
				mbp2.setDataHandler(new DataHandler(fds));
				mbp2.setFileName(fds.getName());
				
				Multipart mp = new MimeMultipart();
				mp.addBodyPart(mbp1);
				mp.addBodyPart(mbp2);
				
				msg.setContent(mp);
			}
			
			Transport.send(msg);
		} catch (Exception e) {
			System.out.println("[���� ���� ����]"+mailTo+" �������� ���߽��ϴ�.");
			return false;
		}
		return true;
	}        
    
    public static String[] sendJavaMail(String strTo,String strSubject){
        return sendJavaMail(new String[]{strTo},null,null,"\"�������ϸ�\" <admin@okkimail.okki>",strSubject,"������ �����ϼ���","");
    }
    public static String[] sendJavaMail(
        String strTo, String[] strCc,String strFrom, String strFromName,
        String strSubject,String strContents                ){

/*-----------------------------------------------------------------------------*/
/*  mailing service�� ���̽��������� ������ ���մϴ�.
    �̷���� �޴¸��Ͽ� ���̽������� �ִٸ�,
    authentication error(530)�� �߻��ϹǷ�,
    �Ʒ��� ���� host�� ��ü���ݴϴ�.
    by bluet 20050412
/*-----------------------------------------------------------------------------*/
	//Code�� �ߺ��� ���� �ϱ� ���ؼ� ���� 
	return sendJavaMail(new String[] {strTo} , strCc,null, strFrom, strFromName, strSubject, strContents, "");
    }
    public static String[] sendJavaMail(
        String strTo, String[] strCc, String[] strBcc,String strFrom, String strFromName, 
        String strSubject,String strContents                ){

        return sendJavaMail(new String[] {strTo} , strCc,strBcc, strFrom, strFromName, strSubject, strContents, "");
    }

    public static String[] sendJavaMail(
            String[] strTo, String[] strCc,String strFrom, String strFromName, 
            String strSubject,String strContents,String attchFile ){
    	return sendJavaMail(strTo,strCc,null,strFrom,strSubject,strContents,attchFile);
    }
    /*******************��� �������� �޼ҵ� 2003-04-18************************
     * "new String[]{""}",    //�޴»�� �����ּ�
     * new String[]{""},        //������ �迭
     * "okki@nice.co.kr","���Ⳳ��", //������ ��� �ּ�,�����»�� �̸�
     * "����� �ּҶ��Դϴ�.",        //��������
     * "����� �����Դϴ�.",        //���Ϻ���
     * "/user2/dnbkora/bbs/file/utf.jpg" //÷�������ϳ�
     *****************************************************************************/
    public static String[] sendJavaMail( String[] strTo, String[] strCc,String[] strBcc,String strFrom, String strFromName, 
        String strSubject,String strContents,String attchFile ){
    	/*-----------------------------------------------------------------------------*/
/*  mailing service�� ���̽��������� ������ ���մϴ�.
    �̷���� �޴¸��Ͽ� ���̽������� �ִٸ�,
    authentication error(530)�� �߻��ϹǷ�,
    �Ʒ��� ���� host�� ��ü���ݴϴ�.
    by bluet 20050412
/*-----------------------------------------------------------------------------*/
        if (strFrom.indexOf("nice.co.kr") != -1) {
			host = "mail.nice.co.kr";
		}

		System.out.println("mail host : " + host);
		
		// ��� ���� �޼ҵ� [0] = �߼� ���� ���� ���� [1]�߼ۼ�����TO�ּ� [2]�߼ۼ�����CC�ּ�
		String strRtn[] = { "", "", "" };
		
		Properties props = System.getProperties();
		props.put("mail.smtp.host", host);
		Session session2 = Session.getDefaultInstance(props, null);
		try {
			String sHostName;
			sHostName = java.net.InetAddress.getLocalHost().getHostName();
			if(!sHostName.equals("docu01") && !sHostName.equals("docu02")) // �Ǽ����� sms ����
			{
				System.out.println("//-------------------- [���� �̸�������:���߿�] --------------------//");
				System.out.println("  - �޴� ��� : " + strTo);
				System.out.println("//--------------------------------------------------//");
				strRtn[0] = "ok";
				return strRtn;
			}	
			
			session2.setDebug(false);
			MimeMessage msg = new MimeMessage(session2);

			// if (!checkMailStr(strTo)){strRtn[0]="�޴»���� �̸����� ������ ���� �ʽ��ϴ�.";
			// return strRtn;}
			// if (!checkMailStr(strFrom)){strRtn[0]="��������� �̸����� ������ ���� �ʽ��ϴ�.";
			// return strRtn;}

			//msg.setFrom(new InternetAddress(new String((strFrom).getBytes("KSC5601"), "8859_1")));
			//msg.setFrom(new InternetAddress(strFrom, "���̽���ť", "KSC5601"));  // ����
			msg.setFrom(new InternetAddress(strFrom, strFromName, "UTF-8"));  // ����
			

			// �����ڸ� �迭�� ���� �ִ´�.
			for (int i = 0; i < strTo.length && strTo[i] != null
					&& !strTo[i].trim().equals(""); i++) {
				strTo[i] = new String((strTo[i]).getBytes("KSC5601"), "UTF-8");
				InternetAddress[] address = { new InternetAddress(strTo[i]) };
				if (i == 0) {
					msg.setRecipients(Message.RecipientType.TO, address);
				} else {
					msg.addRecipients(Message.RecipientType.TO, address);
				}
				strRtn[1] += "��" + strTo[i]; // ���ϵǴ� ���� ���� ���Ѱ�.
			}
			// �����ڸ� �ִ´�.
			if (strCc != null) {
				for (int i = 0; i < strCc.length && strCc[i] != null
						&& !strCc[i].trim().equals(""); i++) {
					strRtn[2] += "|" + strCc[i];
					strCc[i] = new String((strCc[i]).getBytes("KSC5601"), "8859_1");
					InternetAddress[] address = { new InternetAddress(strCc[i]) };
					if (i == 0) {
						msg.setRecipients(Message.RecipientType.CC, address);
					} else {
						msg.addRecipients(Message.RecipientType.CC, address);
					}
				}
			}
			// ���������ڸ� �ִ´�.
			if (strBcc != null) {
				for (int i = 0; i < strBcc.length && strBcc[i] != null
						&& !strBcc[i].trim().equals(""); i++) {
					strRtn[2] += "|" + strBcc[i];
					strBcc[i] = new String((strBcc[i]).getBytes("KSC5601"), "8859_1");
					InternetAddress[] address = { new InternetAddress(strBcc[i]) };
					if (i == 0) {
						msg.setRecipients(Message.RecipientType.BCC, address);
					} else {
						msg.addRecipients(Message.RecipientType.BCC, address);
					}
				}
			}

			// msg�� ���� ����Ѵ�.
			msg.setSubject(strSubject, "UTF-8");

			// ������ HTML Ÿ������ ����Ѵ�. ���� ÷�δ� �ٸ� �ڷḦ ���� �Ұ�.
			MimeBodyPart mbdpt = new MimeBodyPart();
			mbdpt.setContent(strContents, "text/html; charset=EUC-KR");

			// msg.setContent(strContents, "text/html; charset=EUC-KR");

			Multipart mltpt = new MimeMultipart();
			mltpt.addBodyPart(mbdpt);

			/** **÷�����ϱ�� �߰� 2003-04-28*** */
			if (attchFile != null && !attchFile.equals("")) {
				MimeBodyPart mbdptFile = new MimeBodyPart();
				FileDataSource fds = new FileDataSource(attchFile);
				mbdptFile.setDataHandler(new DataHandler(fds));
				mbdptFile.setFileName(new String(fds.getName().getBytes("KSC5601"), "8859_1"));
				mltpt.addBodyPart(mbdptFile);
			}

			msg.setContent(mltpt);
			msg.setSentDate(new java.util.Date());

			strRtn[0] = "ok";

			// ���� ��Ʈ���� ������ ���� ������..
			Transport.send(msg);

			/*
			 * 2006-07-18 IT ��ȣ�� ���� ���� �ּ� �߿� �߸��� ���� �ϳ��� ���� ��� ������ ������ �ʴ� �Ϳ���
			 */
		} catch (javax.mail.SendFailedException sfe) {
			Address addr[] = sfe.getInvalidAddresses();
			System.out.print("Wrong mail Addr");
			for (int i = 0; i < addr.length; i++) {
				// ���� �ּҰ� ��Ȯ���� ���� ���� �ý��ۿ� �ѷ� �ش�.
				System.out.println(ko(addr[i].toString()));
			}
			addr = sfe.getValidUnsentAddresses();
			String[] strAddr = new String[100];

			for (int i = 0; i < addr.length; i++) {
				strAddr[i] = ko(addr[i].toString());
			}

			addr = sfe.getValidSentAddresses();
			// ���� �ּҴ� ��Ȯ�ѵ� ������ ���Ѱ��� �ٽ� ������.
			strRtn = sendJavaMail(strAddr, strCc, strFrom, strFromName, strSubject,
					strContents, attchFile);
		} catch (Exception e) {
			strRtn[0] = e.getMessage();
		}
		return strRtn;
    	
    }

    public static String ko(String en){
        String korean = null;
        try {korean = new String (en.getBytes("8859_1"),"KSC5601");}
        catch(Exception e) {return korean;    }
        return korean;
    }

/*-----------------------------------------------------------------------------*/
/*
 * �Ʒ��Լ��� ���� "."�� �ִ� mail id�� �߼۵��� �ʾҽ��ϴ�. �׷��� isValidEmail �Լ��� �̿��ϰ� �߽��ϴ�.
 * 
 * [log file] /user5/dnbLog/duns_mailling.log /user5/clipLog/clip_mailing.log
 * /user5/log/cnote_mailing.log
 * 
 * ������ ��� �߳� �̰����� ã�ƺ��Ҵµ� jdk 1.4�� �߰��� java.util.regex ��Ű���� ���� ��õ�� ������. ���� �Ұ���
 * sample�� �״�� �����ߴµ�, Ư�����ڿ����� ������ ���� �� �ʿ��Ұ� �����ϴ�. by bluet 20050407
 * /*-----------------------------------------------------------------------------
 */
    public static boolean checkMailStr(String strMail) {
        int comIndex=strMail.indexOf(",");
        int aIndex=strMail.indexOf("@");
        int dotIndex=strMail.indexOf(".");
        int len=strMail.length();
        if(len==0) {return false;}
        if(comIndex==-1 && aIndex > 1 && dotIndex > 3 && aIndex < (dotIndex-1)) {return true;}
          return false;
    }

    public static boolean isValidEmail(String email) {
        boolean flag = false;
        Pattern pattern = Pattern.compile(".+@.+\\.[a-z]+");
        Matcher matcher = pattern.matcher(email);

        if (matcher.find()) {
            flag = true;
            //System.out.println("Valid Email Address.");
        } else {
            //System.out.println("Invalid Email Address. ");
        }

        return flag;
    }


}



