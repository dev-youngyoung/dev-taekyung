package dao;

import nicelib.db.DB;
import nicelib.db.DataObject;
import nicelib.db.DataSet;
import nicelib.util.Util;

public class SmsDao extends DataObject {

	private final String SENDER_KEY = "cdd9d60e07d7f276c9ec1880967f432bfb2bd9e7"; // 카카오 프로필 키
	private final String CHANNEL = "A"; // 채널(A:알림톡)
	private final String SND_TYPE = "P"; // 전송 타입(P:Push, R:Realtime)
	private final String SMS_SND_NUM = "028207114"; // 발신자 번호
	private final String REQ_USR_ID = "ADMIN"; // 발송요청자
	private final String REQ_DEPT_CD = "ECS"; // 시스템 구분
	private final String SLOT2 = "ECS"; // 시스템 상세 구분
	
	public SmsDao() {
		this.table = "MZSENDTRAN";
	}
	
	/*
	 * @param : phoneNum1(수신번호 첫자리)
	 * @param : phoneNum2(수신번호 둘째자리)
	 * @param : phoneNum3(수신번호 셋째자리)
	 * @param : tmplCd(템플릿코드)
	 * @param : subject(LMS제목)
	 * @param : sndMsg(알림톡전송메시지)
	 * @param : smsSndMsg(LMS/SMS전송메시지)
	 */
	public boolean sendKakaoTalk(String phoneNum1, 
								 String phoneNum2, 
								 String phoneNum3, 
								 String tmplCd, 
								 String subject, 
								 String sndMsg, 
								 String smsSndMsg) {
		boolean result = this.sendKakaoTalk(CHANNEL, 
											SND_TYPE, 
											phoneNum1, 
											phoneNum2, 
											phoneNum3, 
											tmplCd, 
											subject, 
											sndMsg, 
											smsSndMsg, 
											SMS_SND_NUM, 
											REQ_DEPT_CD, 
											REQ_USR_ID, 
											"Y", 
											SLOT2);
		return result;
	}
	
	/*
	 * @param : phoneNum1(수신번호 첫자리)
	 * @param : phoneNum2(수신번호 둘째자리)
	 * @param : phoneNum3(수신번호 셋째자리)
	 * @param : tmplCd(템플릿코드)
	 * @param : subject(LMS제목)
	 * @param : sndMsg(알림톡전송메시지)
	 * @param : smsSndMsg(LMS/SMS전송메시지)
	 * @param : smsSndNum(발신자번호)
	 * @param : reqUsrId(발송자ID)
	 */
	public boolean sendKakaoTalk(String phoneNum1, 
								 String phoneNum2, 
								 String phoneNum3, 
								 String tmplCd, 
								 String subject, 
								 String sndMsg, 
								 String smsSndMsg, 
								 String smsSndNum, 
								 String reqUsrId) {
		boolean result = this.sendKakaoTalk(CHANNEL, 
											SND_TYPE, 
											phoneNum1, 
											phoneNum2, 
											phoneNum3, 
											tmplCd, 
											subject, 
											sndMsg, 
											smsSndMsg, 
											smsSndNum, 
											REQ_DEPT_CD, 
											reqUsrId, 
											"Y", 
											SLOT2);
		return result;
	}
	
	/*
	 * @param : channel(채널값)
	 * @param : sndType(전송타입)
	 * @param : phoneNum1(수신번호 첫자리)
	 * @param : phoneNum2(수신번호 둘째자리)
	 * @param : phoneNum3(수신번호 셋째자리)
	 * @param : tmplCd(템플릿코드)
	 * @param : subject(LMS제목)
	 * @param : sndMsg(알림톡전송메시지)
	 * @param : smsSndMsg(LMS/SMS전송메시지)
	 * @param : smsSndNum(발신자번호)
	 * @param : reqDeptCd(시스템구분)
	 * @param : reqUsrId(발송자ID)
	 * @param : smsSndYn(LMS발송여부/알림톡실패시)
	 * @param : slot2(시스템상세구분)
	 */
	public boolean sendKakaoTalk(String channel, 
								 String sndType, 
								 String phoneNum1, 
								 String phoneNum2, 
								 String phoneNum3, 
								 String tmplCd, 
								 String subject, 
								 String sndMsg, 
								 String smsSndMsg, 
								 String smsSndNum, 
								 String reqDeptCd, 
								 String reqUsrId, 
								 String smsSndYn, 
								 String slot2) {
		System.out.println("[SmsDao][sendKakaoTalk] START");
		
		boolean result = false;
		
		System.out.println("[SmsDao][sendKakaoTalk] channel(채널값) : " + channel);
		System.out.println("[SmsDao][sendKakaoTalk] sndType(전송타입) : " + sndType);
		System.out.println("[SmsDao][sendKakaoTalk] phoneNum1(수신번호 첫자리) : " + phoneNum1);
		System.out.println("[SmsDao][sendKakaoTalk] phoneNum2(수신번호 둘째자리) : " + phoneNum2);
		System.out.println("[SmsDao][sendKakaoTalk] phoneNum3(수신번호 셋째자리) : " + phoneNum3);
		System.out.println("[SmsDao][sendKakaoTalk] tmplCd(템플릿코드) : " + tmplCd);
		System.out.println("[SmsDao][sendKakaoTalk] subject(LMS제목) : " + subject);
		System.out.println("[SmsDao][sendKakaoTalk] sndMsg(알림톡전송메시지) : " + sndMsg);
		System.out.println("[SmsDao][sendKakaoTalk] smsSndMsg(LMS/SMS전송메시지) : " + smsSndMsg);
		System.out.println("[SmsDao][sendKakaoTalk] smsSndNum(발신자번호) : " + smsSndNum);
		System.out.println("[SmsDao][sendKakaoTalk] reqDeptCd(시스템구분) : " + reqDeptCd);
		System.out.println("[SmsDao][sendKakaoTalk] reqUsrId(발송자ID) : " + reqUsrId);
		System.out.println("[SmsDao][sendKakaoTalk] smsSndYn(LMS발송여부/알림톡실패시) : " + smsSndYn);
		System.out.println("[SmsDao][sendKakaoTalk] slot2(시스템상세구분) : " + slot2);
		
		// 정상적인 휴대폰 첫자리 번호 목록
		String[] codePhone1 = {"010", "011", "016", "017", "018", "019"};
		
		// 휴대폰번호 검증
		if ( (phoneNum1 == null || phoneNum1.length() != 3) || 
			 (phoneNum2 == null || !(phoneNum2.length() >= 3) || phoneNum2.equals("0000")) || 
			 (phoneNum3 == null || !(phoneNum3.length() >= 3)) || 
			 !Util.inArray(phoneNum1, codePhone1) ) {
			System.out.println("[SmsDao][sendKakaoTalk] invalid phone number");
			return false;
		}
		
		// 템플릿 코드 검증
		if (tmplCd == null || tmplCd.isEmpty()) {
			System.out.println("[SmsDao][sendKakaoTalk] template code is empty");
			return false;
		}
		
		// 메시지 검증
		if (sndMsg == null || sndMsg.isEmpty()) {
			System.out.println("[SmsDao][sendKakaoTalk] send message is empty");
			return false;
		}
		
		try {
			// 메시지 개행문자 처리
			smsSndMsg = smsSndMsg.replaceAll("\\n", "\'||CHR(13)||CHR(10)||\'");
			smsSndMsg = "\'" + smsSndMsg + "\'";
			System.out.println("[SmsDao][sendKakaoTalk] replaced smsSndMsg(LMS/SMS전송메시지) : " + smsSndMsg);
			
			SmsDao smsDao = new SmsDao();
			smsDao.item("SENDER_KEY", SENDER_KEY);
			smsDao.item("CHANNEL", channel);
			smsDao.item("SND_TYPE", sndType);
			smsDao.item("PHONE_NUM", phoneNum1 + phoneNum2 + phoneNum3);
			smsDao.item("TMPL_CD", tmplCd);
			smsDao.item("SUBJECT", subject);
			smsDao.item("SND_MSG", sndMsg);
			smsDao.item("SMS_SND_NUM", smsSndNum);
			smsDao.item("REQ_DEPT_CD", reqDeptCd);
			smsDao.item("REQ_USR_ID", reqUsrId);
			smsDao.item("SMS_SND_YN", smsSndYn);
			smsDao.item("SLOT2", slot2);
			
			DB db = new DB();
			String query = "INSERT INTO MZSENDTRAN "
						 + "("
						 + "    SN"
						 + "  , SENDER_KEY"
						 + "  , CHANNEL"
						 + "  , SND_TYPE"
						 + "  , PHONE_NUM"
						 + "  , TMPL_CD"
						 + "  , SUBJECT"
						 + "  , SND_MSG"
						 + "  , SMS_SND_MSG"
						 + "  , SMS_SND_NUM"
						 + "  , REQ_DEPT_CD"
						 + "  , REQ_USR_ID"
						 + "  , REQ_DTM"
						 + "  , SMS_SND_YN"
						 + "  , SLOT2"
						 + ") VALUES ("
						 + "    NAECS.MZSENDTRAN_SEQ.NEXTVAL"
						 + "  , $SENDER_KEY$"
						 + "  , $CHANNEL$"
						 + "  , $SND_TYPE$"
						 + "  , $PHONE_NUM$"
						 + "  , $TMPL_CD$"
						 + "  , $SUBJECT$"
						 + "  , $SND_MSG$"
						 + "  , " + smsSndMsg
						 + "  , $SMS_SND_NUM$"
						 + "  , $REQ_DEPT_CD$"
						 + "  , $REQ_USR_ID$"
						 + "  , TO_CHAR(SYSDATE, 'yyyymmddhh24miss')"
						 + "  , $SMS_SND_YN$"
						 + "  , $SLOT2$"
						 + ")";
			db.setCommand(query, smsDao.record);
		
			if (db.executeArray()) {
				result = true;
				System.out.println("[SmsDao][sendKakaoTalk] send kakaotalk is success.");
				System.out.println("[SmsDao][sendKakaoTalk] send number : " + phoneNum1 + phoneNum2 + phoneNum3);
				System.out.println("[SmsDao][sendKakaoTalk] send message : " + sndMsg);
			}
		} catch (Exception e) {
			System.out.println("[SmsDao][sendKakaoTalk] send kakaotalk is fail.");
			System.out.println("[SmsDao][sendKakaoTalk] send template code : " + tmplCd);
			System.out.println("[SmsDao][sendKakaoTalk] send number : " + phoneNum1 + phoneNum2 + phoneNum3);
			System.out.println("[SmsDao][sendKakaoTalk] send message : " + sndMsg);
			e.printStackTrace();
		}
		
		System.out.println("[SmsDao][sendKakaoTalk] send kakaotalk result : " + result);
		System.out.println("[SmsDao][sendKakaoTalk] END");
		
		return result;
	}
	
	public boolean sendSMS(String systemGubun,String recvHp1, String recvHp2, String recvHp3, String smsMsg)
	{
		boolean bSuccess = false;
		String[] code_hp1 = {"010","011","016","017","018","019"}; 
		// 전달된 값이 정상적 일때만 처리
		if ( 	
			 (recvHp1 != null) && (recvHp1.length() == 3)
			 &&	(recvHp2 != null) && (recvHp2.length() >= 3)
			 &&	(recvHp3 != null) && (recvHp3.length() >= 3) && !recvHp3.equals("0000")
			 && (smsMsg != null) && !smsMsg.equals("")
			 && Util.inArray(recvHp1, code_hp1)
			)
		{
			String tran_callback = "028208282"; //
			String tran_phone = recvHp1+ recvHp2+ recvHp3;// "-" 제거한 12자리 보내는사람 전화번호 (우측에 공백추가)
			
			try {
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
				"	INSERT INTO SDK_SMS_SEND					"  
				+"	(                                           "  
				+"	     MSG_ID                                 "  
				+"	,    USER_ID                                "  
				+"	,    SCHEDULE_TYPE                          "  
				+"	,    NOW_DATE                               "  
				+"	,    SEND_DATE                              "  
				+"	,    CALLBACK                               "  
				+"	,    DEST_COUNT                             "  
				+"	,    DEST_INFO                              "  
				+"	,    SMS_MSG                                "  
				+"	,    RESERVED1                              "  
				+"	,    RESERVED2                              "  
				+"	)                                           "  
				+"	VALUES                                      "  
				+"	(                                           "  
				+"	     SDK_SMS_SEQ.NEXTVAL                    "  
				+"	,    'SD'                                   "  
				+"	,    0                                      "  
				+"	,    TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')    "  
				+"	,    TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')    "  
				+"	,    $tran_callback$                        "  
				+"	,    1                                      "  
				+"	,    '^' || $tran_phone$                    "  
				+"	,    $tran_msg$                      		"  
				+"	,    'SD_NAECS'                             "  
				+"	,    'NAECS'                                "  
				+"	)                                           "; 

				
				/*
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
				
				*/
				
				System.out.println(query);
				db.setCommand(query, smsDao.record);
				if(!db.executeArray()){
					System.out.println("//-------------------- [SMS전송 오류] --------------------//");
					System.out.println("  - 받는사람 휴대전화 : " + tran_phone);
					System.out.println("  - 전송 메시지 : " + smsMsg);
					System.out.println("//--------------------------------------------------//");
				} 
				else
				{
					System.out.println("//-------------------- [SMS전송] --------------------//");
					System.out.println("  - 받는사람 휴대전화 : " + tran_phone);
					System.out.println("  - 전송 메시지 : " + smsMsg);
					System.out.println("//--------------------------------------------------//");
				}
				bSuccess = true;					
						
			} catch (Exception e) {
				e.printStackTrace();
			}			

		}
		else
		{
			System.out.println("[ERROR "+this.getClass()+".sendSMS()] : 전달된 parmater에 오류가 있습니다.");
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
		// 전달된 값이 정상적 일때만 처리
		if ( 	
			 (recvHp1 != null) && (recvHp1.length() == 3)
			 &&	(recvHp2 != null) && (recvHp2.length() >= 3)
			 &&	(recvHp3 != null) && (recvHp3.length() >= 3) && !recvHp3.equals("0000")
			 && (smsMsg != null) && !smsMsg.equals("")
			 && Util.inArray(recvHp1, code_hp1)
			)
		{
			String tran_callback = "027889097"; //
			String tran_phone = recvHp1+ recvHp2+ recvHp3;// "-" 제거한 12자리 보내는사람 전화번호 (우측에 공백추가)
			
			try {
				String sHostName;
				sHostName = java.net.InetAddress.getLocalHost().getHostName();
				if(sHostName.equals("docu01") || sHostName.equals("docu02")) // 실서버만 sms 보냄
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
						System.out.println("//-------------------- [LMS전송 오류] --------------------//");
						System.out.println("  - 받는사람 휴대전화 : " + tran_phone);
						System.out.println("  - 전송 메시지 : " + smsMsg);
						System.out.println("//--------------------------------------------------//");
					}
					
					bSuccess = true;					
				}
				else
				{
					System.out.println("//-------------------- [가상 LMS전송:개발용] --------------------//");
					System.out.println("  - 받는사람 휴대전화 : " + tran_phone);
					System.out.println("  - 전송 메시지 : " + smsMsg);
					System.out.println("//--------------------------------------------------//");
					bSuccess = true;
				}
		
				
			} catch (Exception e) {
				e.printStackTrace();
			}			

		}
		else
		{
			System.out.println("[ERROR "+this.getClass()+".sendLMS()] : 전달된 parmater에 오류가 있습니다.");
			System.out.println("recvHp1:"+recvHp1);
			System.out.println("recvHp2:"+recvHp2);
			System.out.println("recvHp3:"+recvHp3);
			System.out.println("smsMsg:"+smsMsg);
		}
		
		return bSuccess;
	}
}