package procure.common.utils;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.EOFException;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.net.Socket;
import java.text.*;
import java.util.*;

/***************************************
 * 거래내역등록
 * 작성자: Vincent.
 * 작성일: 2004/09/21
 ***************************************/

public class sendSMS {
 

	/******
	 * String 을 byte[]로 변환한다음 일정 Position 이하로 잘라내서 완벽한 한글String리턴
	 ********/
	public String snapStrB(String strSrc,int sp_idx){
		String retStr="";
		strSrc = strSrc==null?"":strSrc;
		byte[] byt= strSrc.getBytes();

		if(Utils.hancheck(byt,sp_idx)) sp_idx = sp_idx-1;
		if(sp_idx>byt.length) sp_idx = byt.length;
		retStr = new String(byt,0,sp_idx);
		return retStr;
	}

	//private int timeout = 300000; // 5분
	private int timeout = 20000; // 20초
	private String addr = "10.95.50.53";  // 172.29.220.230

	private int port =0;
	/***Construnctor***/
	public sendSMS(){
		try{
            //테스트포트는 29301인것 같으나 에러나서 못해봄 by bluet 20070928
            //테스트에서 작업하려면 나이스에 연락해 acl_id를 등록해야 함 by bluet 20071009
			//this.port = ((String)java.net.InetAddress.getLocalHost().getHostAddress()).equals("172.28.5.56")?29302:29302;
			this.port = 21046;
		}catch(Exception e){}
	}

	private SimpleDateFormat dt = new SimpleDateFormat("yyyyMMddHHmmss");
	private SimpleDateFormat dt2 = new SimpleDateFormat("yyyyMMdd");

	private PrintStream log;
	{
		String log_file = "/user1/sms_log/"+dt2.format(new java.util.Date())+"_smsLog.log";
		try {log = new PrintStream(new FileOutputStream(log_file, true));}
		catch (Exception e) {log = System.out; }
	}

	//CB전문(등록) Header (Primary Bitmap 없음)
	private TreeMap getCommCB_header(String ACLID){
		/******************************
		 * 공통부 (공통부나 개별요청부나 key idx는 전문 Document상의 idx를 그대로 따른다).
		 ******************************/
		TreeMap HeaderMap = new TreeMap();
		HeaderMap.put(new Integer(2),"NICEIF   ");							        //전문그룹코드
		HeaderMap.put(new Integer(3),"0200");														//거래종별코드
		HeaderMap.put(new Integer(4),"7301M");													//거래구분코드
		HeaderMap.put(new Integer(5),"B");															//송수신Flag
		HeaderMap.put(new Integer(6),"503");														//단말기구분
		HeaderMap.put(new Integer(7),Utils.paddR("",4));								//응답코드
		HeaderMap.put(new Integer(8),Utils.paddR(ACLID,9));							//참가기관ID
		HeaderMap.put(new Integer(9),Utils.paddR("",10));							//기관전문 관리번호
		HeaderMap.put(new Integer(10),dt.format(new java.util.Date()));	//기관전문 전송시간
		HeaderMap.put(new Integer(11),Utils.paddR("",10));							//NICE 전문 관리번호
		HeaderMap.put(new Integer(12),Utils.paddR("",14));							//NICE 전문 전송시간
    HeaderMap.put(new Integer(13),Utils.paddR("",16));              //Primary Bitmap
    HeaderMap.put(new Integer(14),Utils.paddR("",1));	              //공란(Extend Bitmap Code)
		return HeaderMap;
	}

	//SMS 발송요청
	public TreeMap makeMsg_SMSReg(String ACLID,HashMap pMap){
/*----------------------------------------------
   구분자 추가 및 수정
   by bluet 20080627
----------------------------------------------*/
        String send_type    = (String)pMap.get("send_type");
        String callback_no  = (String)pMap.get("callback_no");
        String resv_time    = (String)pMap.get("resv_time");
        if (send_type == null || "".equals(send_type)) {
            send_type = "1";
        }
        if (callback_no == null || "".equals(callback_no)) {
            callback_no = "0221222360  ";
        }
        if (resv_time == null || "".equals(resv_time)) {
            resv_time   = "";
        }

		//공통부 GET.
		TreeMap HeaderMap = getCommCB_header(ACLID); //ACLID

		TreeMap bodyMap = new TreeMap();
		/******************************
		 * 요청부 Making
		 ******************************/
		bodyMap.put(new Integer(15),send_type);												 									//발송구분: 1=즉시, 2=예약
		bodyMap.put(new Integer(16),dt2.format(new java.util.Date()));				//발송일자
		bodyMap.put(new Integer(17),"1  ");											//SMS 요청내역 건수: 최대 100
		bodyMap.put(new Integer(18),Utils.paddR("",18));		 					//공란

		/******************************
		 * 등록전문부 Making
		 ******************************/
		bodyMap.put(new Integer(19),"S");											//내역구분
		bodyMap.put(new Integer(20),Utils.paddR("",13));							//주민번호/사업자번호/법인번호
		bodyMap.put(new Integer(21),pMap.get("tg"));								//통신사 구분: 1=SKT, 2=KTF, 3=LGT
		bodyMap.put(new Integer(22),pMap.get("hp1"));								//핸드폰 구분번호
		bodyMap.put(new Integer(23),pMap.get("hp2"));								//핸드폰 주번호
		bodyMap.put(new Integer(24),pMap.get("hp3"));								//핸드폰 부번호
		bodyMap.put(new Integer(25),Utils.paddR((String)pMap.get("msg"),80));		//SMS발송메시지
		bodyMap.put(new Integer(26),Utils.paddR(callback_no,10));					//콜백전화번호 
		bodyMap.put(new Integer(27),Utils.paddR(resv_time,14));						//예약발송일시
		bodyMap.put(new Integer(28),Utils.paddR("",17));							//공란

		HeaderMap.putAll(bodyMap);
		return HeaderMap;
	}


	//SMS 발송서비스 확인요청
	public TreeMap makeMsg_SMSConfimReg(String ACLID,HashMap pMap){
		/******************************
		 * 공통부 GET.
		 ******************************/
		TreeMap HeaderMap = getCommCB_header(ACLID); //ACLID


		TreeMap bodyMap = new TreeMap();
		/******************************
		 * 요청부 Making
		 ******************************/
		bodyMap.put(new Integer(15),"1");												 									//검색구분: 1=검색
		bodyMap.put(new Integer(16),dt2.format(new java.util.Date()));						//발송일자
		bodyMap.put(new Integer(17),"1  ");											 									//휴대폰 요청내역 건수: 최대 100
		bodyMap.put(new Integer(18),Utils.paddR("",18));		 											//공란
		/******************************
		 * 등록전문부 Making
		 ******************************/
		bodyMap.put(new Integer(19),"S");																					//내역구분
		bodyMap.put(new Integer(20),Utils.paddR("",13));													//주민번호/사업자번호/법인번호
		bodyMap.put(new Integer(21),"1");																					//통신사 구분: 1=SKT, 2=KTF, 3=LGT
		bodyMap.put(new Integer(22),"011 ");																			//핸드폰 구분번호
		bodyMap.put(new Integer(23),"9532");																			//핸드폰 주번호
		bodyMap.put(new Integer(24),"6031");																			//핸드폰 부번호
		bodyMap.put(new Integer(25),dt.format(new java.util.Date()));							//SMS요청시간
		bodyMap.put(new Integer(26),Utils.paddR("",9));														//공란

		HeaderMap.putAll(bodyMap);
		return HeaderMap;
	}

	private String communicate(String sendMsg) throws Exception {
		Socket socket = null;
		String rsvMsg = new String();
		StringBuffer log_sb = new StringBuffer();
		log_sb.append(dt.format(new java.util.Date())); log_sb.append("communicate");
		log_sb.append(dt.format(new java.util.Date())); log_sb.append(sendMsg); log_sb.append('\n');
		int count=0;
		byte[] rsvBytes = new byte[40960];
		try {
			socket =  new Socket(addr, port);
			socket.setSoTimeout(timeout);

			DataInputStream in = new DataInputStream(socket.getInputStream());
			DataOutputStream out = new DataOutputStream(socket.getOutputStream());

			byte[] sendBytes = sendMsg.getBytes();
			out.write(sendBytes, 0, sendBytes.length);
			out.flush();
			int Maxlen =0;

			boolean getLenB = true;
			try {
				byte b;
				while ((b = in.readByte()) != -1) {
					rsvBytes[count] = b;
					if(count ==9 && getLenB) {
						Maxlen = Integer.parseInt((new String(rsvBytes,0,10)).trim());  //
						count=-1;
						getLenB = false;
					}
					if(count ==Maxlen-1 && !getLenB)break;
					count++;
				}
			} catch (EOFException ignored) {}
			rsvMsg = new String(rsvBytes, 0, count+1);

			//uFunc.logm("err2", "보낸것\n"+sendMsg+"\n");
			//uFunc.logm("err2", "받은것\n"+rsvMsg+"\n");
			//uFunc.logm("err2", "받은것길이\n"+Maxlen+"\n");

			out.close();
			in.close();
			log_sb.append(dt.format(new java.util.Date())); log_sb.append(rsvMsg); log.println(log_sb.toString());
		} catch (Exception e) {
			log_sb.append(dt.format(new java.util.Date())); log_sb.append(new String(rsvBytes, 0, count)); log.println(log_sb.toString());
			e.printStackTrace(log);
			throw e;
		} finally {
			if (socket != null) {
				try { socket.close(); } catch(Exception e) {}
			}
		}
		return rsvMsg;
	}

	public String cvtMakeMsgStr(TreeMap map){
		StringBuffer sb = new StringBuffer();
		Iterator lit = map.keySet().iterator();
		while(lit.hasNext()){
			Integer key = (Integer)lit.next();
			sb.append(""+map.get(key));
			//uFunc.logm("err2", key+"|"+((map.get(key)+"").getBytes()).length+"|"+map.get(key)+"<okki>");
		}
		byte[] retBodyBytes = (sb.toString()).getBytes();
		int bodyLength = retBodyBytes.length;
		sb.insert(0,Utils.paddL(""+bodyLength,10));
		return sb.toString();
	}


	//SMS요청에 대한 응답
	public TreeMap pars_SMSReg(String rsvMsg){
		//거래정보 등록에 대한응답(idx는 전문 Document상의 인덱스를 그대로 따름 )
		int[] rsvSplit = new int[]{9,9,4,5,1,3,4,9,10,14,10,14,16,1,1,8,3,18,1,13,1,4,4,4,14,4,5}; //[공통+등록전문부] Length.
		//위 idx정보에따라 map[공통부+개별부] 생성. key는 위의 순서
		TreeMap rsvTMap = parseWorkCB(rsvMsg,rsvSplit);
		return rsvTMap;
	}


	//[★Loop부가 없는 등록형]현재 수신받은 String을 TreeMap 형태로 배열
	public TreeMap parseWorkCB(String rsvMsg,int[] rsvSplit){
		TreeMap rsvTMap = new TreeMap();
		byte[] rsvMsgBytes = rsvMsg.getBytes();
		int iPosition=0;
		for(int i=0 ; i<rsvSplit.length ; i++){
			rsvTMap.put(new Integer(i+2),new String(rsvMsgBytes,iPosition,rsvSplit[i]).trim());
			iPosition += rsvSplit[i];
		}
		return rsvTMap;
	}


	//[★Loop부가 있는 응답형]현재 수신받은 String을 TreeMap 형태로 배열
	public TreeMap parseWorkCB(String rsvMsg,int[] rsvSplit,int[] rsvLoopIdx,int[][] matchLoopIdx){
		TreeMap rsvTMap = new TreeMap();
		byte[] rsvMsgBytes = rsvMsg.getBytes();
		int iPosition=0;
		for(int i=0 ; i<rsvSplit.length ; i++){
			rsvTMap.put(new Integer(i+2),new String(rsvMsgBytes,iPosition,rsvSplit[i]).trim());
			iPosition += rsvSplit[i];

			//uFunc.logm("err2", iPosition+"["+i+"]");
		}
		for(int i=0 ; i<rsvLoopIdx.length ; i++){
			//개별응답부 부분의 총건수가 들어가 있다.
			int iCnt = Integer.parseInt(rsvTMap.get(new Integer(rsvLoopIdx[i])).toString()); //Loop항목i번째의 수신건수
			int iPot[] = matchLoopIdx[i]; //현재Loop DATA의 각항목당 length정보를 가져온다.
			Vector rowVct = new Vector();
			for(int j=0; j<iCnt; j++){ // 수신건수대로 Loop.
				TreeMap  innerLoopMap = new TreeMap();
				for(int q=0 ; q<iPot.length ; q++){
					innerLoopMap.put(new Integer(q+1),new String(rsvMsgBytes,iPosition,iPot[q]).trim());
					iPosition += iPot[q];
				}
				rowVct.addElement(innerLoopMap);
			}

			//수신건수항목번호*10을 key로 지정하여 결과TreeMap에 Put.
			rsvTMap.put(new Integer(rsvLoopIdx[i]*10),rowVct);
		}
		return rsvTMap;
	}

	//재요청에 필요한 응답일자 응답시간을 셋팅한다.
	public void set_reconMap(TreeMap rsvTMap,TreeMap rsvTMap_old){
		HashMap reConMap = new HashMap();
		//다시요청하기 위하 다음 Row 응답일자, 마지막응답시간 SET.
		reConMap.put("re_date",rsvTMap.get(new Integer(15))); //응답일자
		reConMap.put("re_time",rsvTMap.get(new Integer(16))); //응답시간
		rsvTMap.put(new Integer(9999),reConMap); //재요청 관련 정보 Put
	}


	//기존 vector에 현재 응답받은 vector데이터를 추가하여 다시 put.
	public void addloopVct(TreeMap rsvTMap_old, TreeMap rsvTMap,int[] rsvLoopIdx){
		for(int i =0 ;i<rsvLoopIdx.length ; i++){
			Vector v = (Vector)rsvTMap_old.get(new Integer(rsvLoopIdx[i]*10));
			if(v ==null)v = new Vector();
			Vector v2 = (Vector)rsvTMap.get(new Integer(rsvLoopIdx[i]*10));
			if(v2 != null){v.addAll(v2);rsvTMap.put(new Integer(rsvLoopIdx[i]*10),v);}
		}
		return;
	}

	//거래정보등록
	//거래정보 온라인 등록 -> 참가기관,거래구분코드,업무구분(32:개인거래정보,35:법인거래정보),등록구분(21:거래정보등록,22:거래정보해제),추가정보Map
	public TreeMap send_SMSReg(String ACLID,HashMap pMap){
		TreeMap sendMap = new TreeMap();
		TreeMap rsvTMap = new TreeMap();
		String  sendMsg = "";
		String  rsvMsg  = "";
		try{
			sendMap = makeMsg_SMSReg(ACLID,pMap);
			sendMsg =(String)cvtMakeMsgStr(sendMap);
			rsvMsg = communicate(sendMsg);  		
//			Mtils.print pr = new Mtils.print();			
		}catch(Exception e){
			log.println("reg_bad_trs|\n"+dt.format(new java.util.Date())+"\n"+sendMsg+"\n"+rsvMsg+"\n"+e.getMessage());
			//uFunc.logm("err2", e.getMessage());
		}
		return rsvTMap;
	}


}
