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
 * �ŷ��������
 * �ۼ���: Vincent.
 * �ۼ���: 2004/09/21
 ***************************************/

public class sendSMS {
 

	/******
	 * String �� byte[]�� ��ȯ�Ѵ��� ���� Position ���Ϸ� �߶󳻼� �Ϻ��� �ѱ�String����
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

	//private int timeout = 300000; // 5��
	private int timeout = 20000; // 20��
	private String addr = "10.95.50.53";  // 172.29.220.230

	private int port =0;
	/***Construnctor***/
	public sendSMS(){
		try{
            //�׽�Ʈ��Ʈ�� 29301�ΰ� ������ �������� ���غ� by bluet 20070928
            //�׽�Ʈ���� �۾��Ϸ��� ���̽��� ������ acl_id�� ����ؾ� �� by bluet 20071009
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

	//CB����(���) Header (Primary Bitmap ����)
	private TreeMap getCommCB_header(String ACLID){
		/******************************
		 * ����� (����γ� ������û�γ� key idx�� ���� Document���� idx�� �״�� ������).
		 ******************************/
		TreeMap HeaderMap = new TreeMap();
		HeaderMap.put(new Integer(2),"NICEIF   ");							        //�����׷��ڵ�
		HeaderMap.put(new Integer(3),"0200");														//�ŷ������ڵ�
		HeaderMap.put(new Integer(4),"7301M");													//�ŷ������ڵ�
		HeaderMap.put(new Integer(5),"B");															//�ۼ���Flag
		HeaderMap.put(new Integer(6),"503");														//�ܸ��ⱸ��
		HeaderMap.put(new Integer(7),Utils.paddR("",4));								//�����ڵ�
		HeaderMap.put(new Integer(8),Utils.paddR(ACLID,9));							//�������ID
		HeaderMap.put(new Integer(9),Utils.paddR("",10));							//������� ������ȣ
		HeaderMap.put(new Integer(10),dt.format(new java.util.Date()));	//������� ���۽ð�
		HeaderMap.put(new Integer(11),Utils.paddR("",10));							//NICE ���� ������ȣ
		HeaderMap.put(new Integer(12),Utils.paddR("",14));							//NICE ���� ���۽ð�
    HeaderMap.put(new Integer(13),Utils.paddR("",16));              //Primary Bitmap
    HeaderMap.put(new Integer(14),Utils.paddR("",1));	              //����(Extend Bitmap Code)
		return HeaderMap;
	}

	//SMS �߼ۿ�û
	public TreeMap makeMsg_SMSReg(String ACLID,HashMap pMap){
/*----------------------------------------------
   ������ �߰� �� ����
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

		//����� GET.
		TreeMap HeaderMap = getCommCB_header(ACLID); //ACLID

		TreeMap bodyMap = new TreeMap();
		/******************************
		 * ��û�� Making
		 ******************************/
		bodyMap.put(new Integer(15),send_type);												 									//�߼۱���: 1=���, 2=����
		bodyMap.put(new Integer(16),dt2.format(new java.util.Date()));				//�߼�����
		bodyMap.put(new Integer(17),"1  ");											//SMS ��û���� �Ǽ�: �ִ� 100
		bodyMap.put(new Integer(18),Utils.paddR("",18));		 					//����

		/******************************
		 * ��������� Making
		 ******************************/
		bodyMap.put(new Integer(19),"S");											//��������
		bodyMap.put(new Integer(20),Utils.paddR("",13));							//�ֹι�ȣ/����ڹ�ȣ/���ι�ȣ
		bodyMap.put(new Integer(21),pMap.get("tg"));								//��Ż� ����: 1=SKT, 2=KTF, 3=LGT
		bodyMap.put(new Integer(22),pMap.get("hp1"));								//�ڵ��� ���й�ȣ
		bodyMap.put(new Integer(23),pMap.get("hp2"));								//�ڵ��� �ֹ�ȣ
		bodyMap.put(new Integer(24),pMap.get("hp3"));								//�ڵ��� �ι�ȣ
		bodyMap.put(new Integer(25),Utils.paddR((String)pMap.get("msg"),80));		//SMS�߼۸޽���
		bodyMap.put(new Integer(26),Utils.paddR(callback_no,10));					//�ݹ���ȭ��ȣ 
		bodyMap.put(new Integer(27),Utils.paddR(resv_time,14));						//����߼��Ͻ�
		bodyMap.put(new Integer(28),Utils.paddR("",17));							//����

		HeaderMap.putAll(bodyMap);
		return HeaderMap;
	}


	//SMS �߼ۼ��� Ȯ�ο�û
	public TreeMap makeMsg_SMSConfimReg(String ACLID,HashMap pMap){
		/******************************
		 * ����� GET.
		 ******************************/
		TreeMap HeaderMap = getCommCB_header(ACLID); //ACLID


		TreeMap bodyMap = new TreeMap();
		/******************************
		 * ��û�� Making
		 ******************************/
		bodyMap.put(new Integer(15),"1");												 									//�˻�����: 1=�˻�
		bodyMap.put(new Integer(16),dt2.format(new java.util.Date()));						//�߼�����
		bodyMap.put(new Integer(17),"1  ");											 									//�޴��� ��û���� �Ǽ�: �ִ� 100
		bodyMap.put(new Integer(18),Utils.paddR("",18));		 											//����
		/******************************
		 * ��������� Making
		 ******************************/
		bodyMap.put(new Integer(19),"S");																					//��������
		bodyMap.put(new Integer(20),Utils.paddR("",13));													//�ֹι�ȣ/����ڹ�ȣ/���ι�ȣ
		bodyMap.put(new Integer(21),"1");																					//��Ż� ����: 1=SKT, 2=KTF, 3=LGT
		bodyMap.put(new Integer(22),"011 ");																			//�ڵ��� ���й�ȣ
		bodyMap.put(new Integer(23),"9532");																			//�ڵ��� �ֹ�ȣ
		bodyMap.put(new Integer(24),"6031");																			//�ڵ��� �ι�ȣ
		bodyMap.put(new Integer(25),dt.format(new java.util.Date()));							//SMS��û�ð�
		bodyMap.put(new Integer(26),Utils.paddR("",9));														//����

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

			//uFunc.logm("err2", "������\n"+sendMsg+"\n");
			//uFunc.logm("err2", "������\n"+rsvMsg+"\n");
			//uFunc.logm("err2", "�����ͱ���\n"+Maxlen+"\n");

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


	//SMS��û�� ���� ����
	public TreeMap pars_SMSReg(String rsvMsg){
		//�ŷ����� ��Ͽ� ��������(idx�� ���� Document���� �ε����� �״�� ���� )
		int[] rsvSplit = new int[]{9,9,4,5,1,3,4,9,10,14,10,14,16,1,1,8,3,18,1,13,1,4,4,4,14,4,5}; //[����+���������] Length.
		//�� idx���������� map[�����+������] ����. key�� ���� ����
		TreeMap rsvTMap = parseWorkCB(rsvMsg,rsvSplit);
		return rsvTMap;
	}


	//[��Loop�ΰ� ���� �����]���� ���Ź��� String�� TreeMap ���·� �迭
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


	//[��Loop�ΰ� �ִ� ������]���� ���Ź��� String�� TreeMap ���·� �迭
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
			//��������� �κ��� �ѰǼ��� �� �ִ�.
			int iCnt = Integer.parseInt(rsvTMap.get(new Integer(rsvLoopIdx[i])).toString()); //Loop�׸�i��°�� ���ŰǼ�
			int iPot[] = matchLoopIdx[i]; //����Loop DATA�� ���׸�� length������ �����´�.
			Vector rowVct = new Vector();
			for(int j=0; j<iCnt; j++){ // ���ŰǼ���� Loop.
				TreeMap  innerLoopMap = new TreeMap();
				for(int q=0 ; q<iPot.length ; q++){
					innerLoopMap.put(new Integer(q+1),new String(rsvMsgBytes,iPosition,iPot[q]).trim());
					iPosition += iPot[q];
				}
				rowVct.addElement(innerLoopMap);
			}

			//���ŰǼ��׸��ȣ*10�� key�� �����Ͽ� ���TreeMap�� Put.
			rsvTMap.put(new Integer(rsvLoopIdx[i]*10),rowVct);
		}
		return rsvTMap;
	}

	//���û�� �ʿ��� �������� ����ð��� �����Ѵ�.
	public void set_reconMap(TreeMap rsvTMap,TreeMap rsvTMap_old){
		HashMap reConMap = new HashMap();
		//�ٽÿ�û�ϱ� ���� ���� Row ��������, ����������ð� SET.
		reConMap.put("re_date",rsvTMap.get(new Integer(15))); //��������
		reConMap.put("re_time",rsvTMap.get(new Integer(16))); //����ð�
		rsvTMap.put(new Integer(9999),reConMap); //���û ���� ���� Put
	}


	//���� vector�� ���� ������� vector�����͸� �߰��Ͽ� �ٽ� put.
	public void addloopVct(TreeMap rsvTMap_old, TreeMap rsvTMap,int[] rsvLoopIdx){
		for(int i =0 ;i<rsvLoopIdx.length ; i++){
			Vector v = (Vector)rsvTMap_old.get(new Integer(rsvLoopIdx[i]*10));
			if(v ==null)v = new Vector();
			Vector v2 = (Vector)rsvTMap.get(new Integer(rsvLoopIdx[i]*10));
			if(v2 != null){v.addAll(v2);rsvTMap.put(new Integer(rsvLoopIdx[i]*10),v);}
		}
		return;
	}

	//�ŷ��������
	//�ŷ����� �¶��� ��� -> �������,�ŷ������ڵ�,��������(32:���ΰŷ�����,35:���ΰŷ�����),��ϱ���(21:�ŷ��������,22:�ŷ���������),�߰�����Map
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
