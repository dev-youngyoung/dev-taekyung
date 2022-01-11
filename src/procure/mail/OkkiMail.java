package procure.mail;
/*******************************************************************
 *작성자   :   기업정보실.E-biz팀.임준우
 *작성목적 :  걍 심심해서리..
 *작성일자 :  2003.03
 *Parameter: 아래 main() 참조.
 *주의할점:  받을사람, 참조자 보내는 사람의 값은 반드시 이메일주소 스펙에 맞아 한다.
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
		 * 제목으로만 표시해도 무방한 간단 알림메일 보낼때 ****** //메소드.1 OkkiMail.sendJavaMail(
		 * "okki@dnbkorea.com", //받는사람 메일주소. "129메일 발송" //메일제목. );
		 * 
		 * 
		 * //메소드.2 OkkiMail.sendJavaMail( "okki@dnbkorea.com", //받는사람 메일주소 new
		 * String[]{""}, //참조자 배열 "okki@nice.co.kr", //보내는 사람 주소 "여기는 주소란입니다.",
		 * //메일제목 "여기는 본문입니다." //메일본문 );
		 * 
		 * //메소드 3 ..첨부파일 있을때 OkkiMail.sendJavaMail( new String[]{"\"디앤비임준우\"
		 * <okki@dnbkorea.com>"}, //수신자 이름 주소 배열 new String[]{""}, //참조자 이름 주소
		 * 배열 "\"임준우\" <okki@nice.co.kr>", //형식: "임준우" <okki@nice.co.kr> :보내는 사람
		 * 이름,주소 "테스트입니다 귀찮으시더라도 지워 주세요.", //메일제목 "여기는 본문입니다. ", //메일본문
		 * "/user2/dnbkorea/bbs/file/월드컵다시보기032.jpg" //첨부파일(일단 하나로제한) );
		 * 
		 * 
		 **********************************************************************/

		/*
		 * if(args.length ==0){ OkkiMail.sendJavaMail( "okki@dnbkorea.com",
		 * //받는사람 메일주소. "메일 발송테스트" //메일제목. ); System.out.println("발송테스트");
		 * }else{ OkkiMail.sendJavaMail( args[0], //받는사람 메일주소. "메일 발송테스트"
		 * //메일제목. ); }
		 */

		String[] strTo = { "\"유성훈\" <sunghoonryu@gmail.com>" };
		String[] strCc = null;// {"drought@dreamwiz.com"};
		String[] strBcc = null;// {"drought@dreamwiz.com"};
		String strFrom = Startup.conf.getString("email.mailFrom");
		String strFromName = "나이스디앤비";
		String strSubject = "메일 Test를 위한 것 입니다.";
		String strContents = "이 메일은 D&B Korea BBS 메일 Test를 위한 것 입니다.";
		String attchFile = "";
		//sendJavaMail(strTo, strCc, strBcc, strFrom, strFromName, strSubject, strContents, attchFile);
		try {
			boolean bSuccess = mail("sunghoonryu@gmail.com", "유성훈", "나이스다큐 메일테스트입니다.", "모두 행복하세요.");
			System.out.println("테스트메일 전송 여부 : " + bSuccess);
		} catch (Exception e) {
			System.out.println("테스트메일 전송 실패");
		}		

    }

    
	// Send Mail
	public static boolean mail(String mailTo, String mailToName, String subject, String body) throws Exception {
		return mail(mailTo, mailToName, subject, body, null);
	}

	public static boolean mail(String mailTo, String mailToName, String subject, String body, String filepath) throws Exception {
		String encoding = "UTF-8";

		// 실서버용
		String mailHost = host;
		String mailFrom = Startup.conf.getString("email.mailFrom"); //"nicedocu@info.nicednb.com";

		// 개발 테스트용
		//String mailHost = "sendmail.nice.co.kr";		
		//String mailFrom = "shryu@nicednb.com";  
		
		Properties props = new Properties();
		props.put("mail.smtp.host", mailHost);

		Session msgSession = Session.getDefaultInstance(props, null);

		try {
			MimeMessage msg = new MimeMessage(msgSession);
			InternetAddress from = new InternetAddress(mailFrom, "나이스다큐", "UTF-8");
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
			System.out.println("[메일 전송 오류]"+mailTo+" 전송하지 못했습니다.");
			return false;
		}
		return true;
	}    
 
	public static boolean mail_apt(String mailTo, String mailToName, String subject, String body, String filepath) throws Exception {
		String encoding = "UTF-8";
		
		String sHostName;
		sHostName = java.net.InetAddress.getLocalHost().getHostName();
		if(!sHostName.equals("docu01") && !sHostName.equals("docu02")) // 실서버만 sms 보냄
		{
			System.out.println("//-------------------- [가상 이메일전송:개발용] --------------------//");
			System.out.println("  - 받는 사람 : " + mailTo);
			System.out.println("//--------------------------------------------------//");
			return true;
		}		
		
		// 실서버용
		String mailHost = host;
		String mailFrom = Startup.conf.getString("email.mailFrom");
		
		// 개발 테스트용
		//String mailHost = "sendmail.nice.co.kr";		
		//String mailFrom = "shryu@nicednb.com";  
		
		Properties props = new Properties();
		props.put("mail.smtp.host", mailHost);
		
		Session msgSession = Session.getDefaultInstance(props, null);
		
		try {
			MimeMessage msg = new MimeMessage(msgSession);
			InternetAddress from = new InternetAddress(mailFrom, "아파트전자입찰", "UTF-8");
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
			System.out.println("[메일 전송 오류]"+mailTo+" 전송하지 못했습니다.");
			return false;
		}
		return true;
	}        
    
    public static String[] sendJavaMail(String strTo,String strSubject){
        return sendJavaMail(new String[]{strTo},null,null,"\"서버메일링\" <admin@okkimail.okki>",strSubject,"제목을 참조하세요","");
    }
    public static String[] sendJavaMail(
        String strTo, String[] strCc,String strFrom, String strFromName,
        String strSubject,String strContents                ){

/*-----------------------------------------------------------------------------*/
/*  mailing service시 나이스계정으로 나가길 원합니다.
    이런경우 받는메일에 나이스계정이 있다면,
    authentication error(530)가 발생하므로,
    아래와 같이 host를 대체해줍니다.
    by bluet 20050412
/*-----------------------------------------------------------------------------*/
	//Code의 중복을 방지 하기 위해서 수정 
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
    /*******************기능 향상버전업 메소드 2003-04-18************************
     * "new String[]{""}",    //받는사람 메일주소
     * new String[]{""},        //참조자 배열
     * "okki@nice.co.kr","옥기남편", //보내는 사람 주소,보내는사람 이름
     * "여기는 주소란입니다.",        //메일제목
     * "여기는 본문입니다.",        //메일본문
     * "/user2/dnbkora/bbs/file/utf.jpg" //첨부파일하나
     *****************************************************************************/
    public static String[] sendJavaMail( String[] strTo, String[] strCc,String[] strBcc,String strFrom, String strFromName, 
        String strSubject,String strContents,String attchFile ){
    	/*-----------------------------------------------------------------------------*/
/*  mailing service시 나이스계정으로 나가길 원합니다.
    이런경우 받는메일에 나이스계정이 있다면,
    authentication error(530)가 발생하므로,
    아래와 같이 host를 대체해줍니다.
    by bluet 20050412
/*-----------------------------------------------------------------------------*/
        if (strFrom.indexOf("nice.co.kr") != -1) {
			host = "mail.nice.co.kr";
		}

		System.out.println("mail host : " + host);
		
		// 결과 담을 메소드 [0] = 발송 성공 실패 유무 [1]발송성공된TO주소 [2]발송성공된CC주소
		String strRtn[] = { "", "", "" };
		
		Properties props = System.getProperties();
		props.put("mail.smtp.host", host);
		Session session2 = Session.getDefaultInstance(props, null);
		try {
			String sHostName;
			sHostName = java.net.InetAddress.getLocalHost().getHostName();
			if(!sHostName.equals("docu01") && !sHostName.equals("docu02")) // 실서버만 sms 보냄
			{
				System.out.println("//-------------------- [가상 이메일전송:개발용] --------------------//");
				System.out.println("  - 받는 사람 : " + strTo);
				System.out.println("//--------------------------------------------------//");
				strRtn[0] = "ok";
				return strRtn;
			}	
			
			session2.setDebug(false);
			MimeMessage msg = new MimeMessage(session2);

			// if (!checkMailStr(strTo)){strRtn[0]="받는사람의 이메일이 문법이 맞지 않습니다.";
			// return strRtn;}
			// if (!checkMailStr(strFrom)){strRtn[0]="보낸사람의 이메일이 문법이 맞지 않습니다.";
			// return strRtn;}

			//msg.setFrom(new InternetAddress(new String((strFrom).getBytes("KSC5601"), "8859_1")));
			//msg.setFrom(new InternetAddress(strFrom, "나이스다큐", "KSC5601"));  // 성공
			msg.setFrom(new InternetAddress(strFrom, strFromName, "UTF-8"));  // 성공
			

			// 수신자를 배열로 집어 넣는다.
			for (int i = 0; i < strTo.length && strTo[i] != null
					&& !strTo[i].trim().equals(""); i++) {
				strTo[i] = new String((strTo[i]).getBytes("KSC5601"), "UTF-8");
				InternetAddress[] address = { new InternetAddress(strTo[i]) };
				if (i == 0) {
					msg.setRecipients(Message.RecipientType.TO, address);
				} else {
					msg.addRecipients(Message.RecipientType.TO, address);
				}
				strRtn[1] += "■" + strTo[i]; // 리턴되는 것을 보기 위한것.
			}
			// 참조자를 넣는다.
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
			// 히든참조자를 넣는다.
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

			// msg에 제목 등록한다.
			msg.setSubject(strSubject, "UTF-8");

			// 내용을 HTML 타입으로 등록한다. 파일 첨부는 다른 자료를 참고 할것.
			MimeBodyPart mbdpt = new MimeBodyPart();
			mbdpt.setContent(strContents, "text/html; charset=UTF-8");

			// msg.setContent(strContents, "text/html; charset=EUC-KR");

			Multipart mltpt = new MimeMultipart();
			mltpt.addBodyPart(mbdpt);

			/** **첨부파일기능 추가 2003-04-28*** */
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

			// 최종 네트웍에 메일을 날려 보낸다..
			Transport.send(msg);

			/*
			 * 2006-07-18 IT 박호삼 수정 메일 주소 중에 잘못된 것이 하나라도 있을 경우 메일을 보내지 않던 것에서
			 */
		} catch (javax.mail.SendFailedException sfe) {
			Address addr[] = sfe.getInvalidAddresses();
			System.out.print("Wrong mail Addr");
			for (int i = 0; i < addr.length; i++) {
				// 메일 주소가 정확하지 않은 것은 시스템에 뿌려 준다.
				System.out.println(ko(addr[i].toString()));
			}
			addr = sfe.getValidUnsentAddresses();
			String[] strAddr = new String[100];

			for (int i = 0; i < addr.length; i++) {
				strAddr[i] = ko(addr[i].toString());
			}

			addr = sfe.getValidSentAddresses();
			// 메일 주소는 정확한데 보내지 못한것은 다시 보낸다.
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
 * 아래함수로 인해 "."이 있는 mail id는 발송되지 않았습니다. 그래서 isValidEmail 함수를 이용하게 했습니다.
 * 
 * [log file] /user5/dnbLog/duns_mailling.log /user5/clipLog/clip_mailing.log
 * /user5/log/cnote_mailing.log
 * 
 * 남들은 어떻게 했나 이것저것 찾아보았는데 jdk 1.4에 추가된 java.util.regex 팩키지에 대한 추천이 많군요. 그중 소개된
 * sample을 그대로 도용했는데, 특수문자에대한 보완이 조금 더 필요할것 같습니다. by bluet 20050407
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



