package nicelib.groupware;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import nicelib.db.DataObject;
import nicelib.db.DataSet;
import nicelib.util.Config;
import nicelib.util.Util;
import procure.common.utils.Security;

/**
 * 전자결재에 결재 관련 데이터를 보내기 위한 클래스
 * @author sjlee
 */
public class ApprovalSender {
	
	public boolean sendApprovalSave(DataSet approvalInfo) {
		
		System.out.println("[ApprovalSender][sendApprovalSave] START");
		
		boolean result = false;
		String code = "";
		String message = "";
		
		HttpURLConnection httpUrlConnection = null;
		DataOutputStream dataOutputStream = null;
		BufferedReader bufferedReader = null;
		
		try {
			String documentType = approvalInfo.getString("jobID");
			if (documentType == null || documentType.isEmpty()) documentType = Config.getApprovalDocumentType(); // ECS12/ECS13
			String contNo = approvalInfo.getString("contNo");
			String contChasu = approvalInfo.getString("contChasu");
			String documentID = approvalInfo.getString("docID");
		 	if (documentID == null || documentID.isEmpty()) documentID = contNo;
		 	String userID = approvalInfo.getString("userID"); // 사원번호
		 	String jobID = approvalInfo.getString("jobID");
		 	if (jobID == null || jobID.isEmpty()) jobID = Config.getApprovalDocumentType(); // ECS12/ECS13
		 	String cmpID = approvalInfo.getString("cmpID");
		 	if (cmpID == null || cmpID.isEmpty()) cmpID = "CN";
			String createTime = Util.getTimeString("yyyy-MM-dd HH:mm:ss");
			String createSystem = Config.getApprovalCreateSystem();
			String createServer = Config.getApprovalCreateServer();
			String creator = approvalInfo.getString("creator");
			String subject = approvalInfo.getString("workName");
			String recipient = approvalInfo.getString("userID"); // 사원번호
			String protID = "createDoc";

			String domain = Config.getWebUrl(); // 계약내용 확인 페이지 제공을 위한 전자결제 domain
			String aesContNo = Security.AESencrypt(contNo);
			String queryString = "cont_no=" + aesContNo + "&cont_chasu=" + contChasu; // 계약내용 확인 페이지 제공을 위한 파라미터
			
			// 상신내용
			String workItem = "";
			// 첨부파일명
			String attachmentName = "";
			// 첨부파일경로
			String attachmentPath = "";
			
			if (jobID.equals("ECS12")) {
				workItem = "\n" +
					"<table cellpadding='0' cellspacing='0' height='28' width='670' border='0' style='border-collapse:collapse:border:none'> \n" +
						"<tr> \n" +
							"<td>" + approvalInfo.getString("workItem") + "</td> \n" +
						"</tr> \n" +
						"<tr> \n" +
							"<td><br/></td> \n" +
						"</tr> \n" +
						"<tr> \n" +
							"<td> \n" +
								"<table width='100%' border='0' cellspacing='0' cellpadding='0' > \n" +
									"<tr> \n" +
										"<td height='30' bgcolor='#c8c8c8' width='300' align='center'>전자계약서 및 첨부파일 확인</td> \n" +
										"<td bgcolor='#c8c8c8'>&nbsp; \n" +
											"<a href='" + domain + "/web/buyer/contract/contract_view.jsp?" + queryString + "' target='_new'>[확인하기]</a> \n" +
										"</td> \n" +
									"</tr> \n" +
								"</table> \n" +	
							"</td> \n" + 
						"</tr> \n" + 
	        	   "</table> \n";
			} else if (jobID.equals("ECS13")) {
				workItem = "\n" +
						"<table cellpadding='0' cellspacing='0' width='670' border='1' style='border-collapse:collapse:border:none; border-color:black;'> \n" +
						"<colsgroup> \n" +
							"<col width='15%'> \n" +
							"<col width='15%'> \n" +
							"<col width='14%'> \n" +
							"<col width='14%'> \n" +
							"<col width='14%'> \n" +
							"<col width='14%'> \n" +
							"<col width='14%'> \n" +
						"</colsgroup> \n" +
						"<tr height='30px' style='border:1; border-color:black;'> \n" +
							"<td style='border:1; border-color:black;' bgcolor='#dcdcdc' align='center'>신청부서</td> \n" +
							"<td style='border:1; border-color:black;' bgcolor='#ebebeb' align='center'>부서</td> \n" +
							"<td style='border:1; border-color:black;'>&nbsp;" + approvalInfo.getString("division") + "</td> \n" +
							"<td style='border:1; border-color:black;' bgcolor='#ebebeb' align='center'>담당자</td> \n" +
							"<td style='border:1; border-color:black;'>&nbsp;" + approvalInfo.getString("userName") + "</td> \n" +
							"<td style='border:1; border-color:black;' bgcolor='#ebebeb' align='center'>전화번호</td> \n" +
							"<td style='border:1; border-color:black;'>&nbsp;" + approvalInfo.getString("telNum") + "</td> \n" +
						"</tr> \n" +
						"<tr height='30px' style='border:1; border-color:black;'> \n" +
							"<td style='border:1; border-color:black;' bgcolor='#dcdcdc' align='center'>거래처</td> \n" +
							"<td style='border:1; border-color:black;' bgcolor='#ebebeb' align='center'>상호</td> \n" +
							"<td style='border:1; border-color:black;'>&nbsp;" + approvalInfo.getString("memberName") + "</td> \n" +
							"<td style='border:1; border-color:black;' bgcolor='#ebebeb' align='center'>사업자번호</td> \n" +
							"<td style='border:1; border-color:black;'>&nbsp;" + approvalInfo.getString("vendCd") + "</td> \n" +
							"<td style='border:1; border-color:black;' bgcolor='#ebebeb' align='center'>사업자</td> \n" +
							"<td style='border:1; border-color:black;'>&nbsp;" + approvalInfo.getString("bossName") + "</td> \n" +
						"</tr> \n" +
						"<tr height='30px' style='border:1; border-color:black;'> \n" +
							"<td style='border:1; border-color:black;' bgcolor='#dcdcdc' align='center'>계약정보</td> \n" +
							"<td style='border:1; border-color:black;' bgcolor='#ebebeb' align='center'>계약기간</td> \n" +
							"<td colspan='5' style='border:1; border-color:black;'>&nbsp;" + approvalInfo.getString("contDate") + "</td> \n" +
						"</tr> \n" +
					"</table> \n" +

					"<br/> \n" +

					"<table cellpadding='0' cellspacing='0' width='670' border='1' style='border-collapse:collapse:border:none; border-color:black;'> \n" +
						"<colsgroup> \n" +
							"<col width='15%'> \n" +
							"<col width='40%'> \n" +
							"<col width='15%'> \n" +
							"<col width='30%'> \n" +
						"</colsgroup> \n" +
						"<tr height='30px' style='border:1; border-color:black;'> \n" +
							"<td style='border:1; border-color:black;' bgcolor='#dcdcdc' align='center'>계약명</td> \n" +
							"<td style='border:1; border-color:black;'>&nbsp;" + approvalInfo.getString("contName") + "</td> \n" +
							"<td style='border:1; border-color:black;' bgcolor='#dcdcdc' align='center'>완료요구일</td> \n" +
							"<td style='border:1; border-color:black;'>&nbsp;" + approvalInfo.getString("endRdate") + "</td> \n" +
						"</tr> \n" +
						"<tr height='30px' style='border:1; border-color:black;'> \n" +
							"<td style='border:1; border-color:black;' bgcolor='#dcdcdc' align='center'>계약내용</td> \n" +
							"<td style='border:1; border-color:black;' colspan='3'>&nbsp;" + approvalInfo.getString("contItem") + "</td> \n" +
						"</tr> \n" +
						"<tr height='30px' style='border:1; border-color:black;'> \n" +
							"<td style='border:1; border-color:black;' colspan='4' bgcolor='#dcdcdc' align='center'>요청사항</td> \n" +
						"</tr> \n" +
						"<tr height='30px' style='border:1; border-color:black;'> \n" +
							"<td colspan='4' style='border:1; border-color:black;'>&nbsp;" + approvalInfo.getString("reqItem") + "</td> \n" +
						"</tr> \n" +
					"</table> \n";
				
				DataObject cfileDao = new DataObject("tcb_cfile");
				DataSet cfile = cfileDao.find(" cont_no = '" + contNo + "' and cont_chasu = '" + contChasu + "' and cfile_seq = '1'");
				cfile.next();
				attachmentName = cfile.getString("doc_name") + "." + cfile.getString("file_ext");
				attachmentPath = "http://172.25.1.100:8024/file/bcontract/pdf/" + cfile.getString("file_path") + cfile.getString("file_name");
				// TODO : 테스트용
				// attachmentPath = "http://172.26.10.192/file/bcontract/pdf/" + cfile.getString("file_path") + cfile.getString("file_name");
			}
			
			System.out.println("[ApprovalSender][sendApprovalSave] ==================================================");
			System.out.println("[ApprovalSender][sendApprovalSave] documentType : " + documentType);
			System.out.println("[ApprovalSender][sendApprovalSave] contNo : " + contNo);
			System.out.println("[ApprovalSender][sendApprovalSave] contChasu : " + contChasu);
			System.out.println("[ApprovalSender][sendApprovalSave] documentID(contNo) : " + documentID);
			System.out.println("[ApprovalSender][sendApprovalSave] userID : " + userID);
			System.out.println("[ApprovalSender][sendApprovalSave] jobID(documentType) : " + jobID);
			System.out.println("[ApprovalSender][sendApprovalSave] cmpID : " + cmpID);
			System.out.println("[ApprovalSender][sendApprovalSave] createTime : " + createTime);
			System.out.println("[ApprovalSender][sendApprovalSave] createSystem : " + createSystem);
			System.out.println("[ApprovalSender][sendApprovalSave] createServer : " + createServer);
			System.out.println("[ApprovalSender][sendApprovalSave] creator : " + creator);
			System.out.println("[ApprovalSender][sendApprovalSave] subject(workName) : " + subject);
			System.out.println("[ApprovalSender][sendApprovalSave] recipient(userID) : " + recipient);
			System.out.println("[ApprovalSender][sendApprovalSave] protID : " + protID);
			System.out.println("[ApprovalSender][sendApprovalSave] domain : " + domain);
			System.out.println("[ApprovalSender][sendApprovalSave] queryString : " + queryString);
			System.out.println("[ApprovalSender][sendApprovalSave] workItem : " + workItem);
			System.out.println("[ApprovalSender][sendApprovalSave] ==================================================");
			
			StringBuffer stringBuffer = new StringBuffer();
			stringBuffer.append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
	 		stringBuffer.append("<exchangeableDocument>");
	 			stringBuffer.append("<documentInformation>");
	 				stringBuffer.append("<documentType>"+documentType+"</documentType>");
	 				stringBuffer.append("<documentID>"+documentID+"</documentID>");
	 				stringBuffer.append("<createTime>"+createTime+"</createTime>");
	 				stringBuffer.append("<modifiedTime>"+createTime+"</modifiedTime>");
	 				stringBuffer.append("<createSystem>"+createSystem+"</createSystem>");
	 				stringBuffer.append("<createServer>"+createServer+"</createServer>");
	 				stringBuffer.append("<gccOrganizationCode></gccOrganizationCode>");
	 				stringBuffer.append("<creator>"+creator+"</creator>");
	 				stringBuffer.append("<subject> <![CDATA[ "+subject+" ]]> </subject>");
	 			stringBuffer.append("</documentInformation>");
	 			stringBuffer.append("<processInformation>");
	 				stringBuffer.append("<destinationSystem>CN</destinationSystem>");
	 				stringBuffer.append("<recipient>"+recipient+"</recipient>");
	 				stringBuffer.append("<documentStatus>"+protID+"</documentStatus>");
	 				stringBuffer.append("<workflow></workflow>");
	 			stringBuffer.append("</processInformation>");
	 			stringBuffer.append("<documentDescription>");
	 				stringBuffer.append("<work>");
	 					stringBuffer.append("<work_manage>");
	 						stringBuffer.append("<job_name> <![CDATA[ "+subject+" ]]> </job_name>");
	 					stringBuffer.append("</work_manage>");
	 					stringBuffer.append("<work_ref></work_ref>");
	 					stringBuffer.append("<work_item work_item_code=\"001\" work_item_name=\"본문내용\">");
	 						stringBuffer.append(" <![CDATA[ <table><tr><td>"+workItem+"</td></tr></table> ]]> ");
	 					stringBuffer.append("</work_item>");
	 				stringBuffer.append("</work>");
	 			stringBuffer.append("</documentDescription>");
	 			stringBuffer.append("<documentBody></documentBody>");
	 			stringBuffer.append("<attachments>");
	 			if (jobID.equals("ECS13")) {
	 				stringBuffer.append("<file>");
	 					stringBuffer.append("<seq>1</seq>");
	 					stringBuffer.append("<name>"+attachmentName+"</name>");
	 					stringBuffer.append("<url> <![CDATA[ "+attachmentPath+" ]]> </url>");
	 				stringBuffer.append("</file>");
	 			}
	 			stringBuffer.append("</attachments>");
		 	stringBuffer.append("</exchangeableDocument>");
		 	
		 	String document = stringBuffer.toString();
		 	
		 	System.out.println("[ApprovalSender][sendApprovalSave] ==================================================");
		 	System.out.println("[ApprovalSender][sendApprovalSave] Document : " + document);
		 	System.out.println("[ApprovalSender][sendApprovalSave] ==================================================");
		 	
		 	URL url = new URL(Config.getApprovalAction() + "/ekp/eapp/nongshim/intra.do");
			httpUrlConnection = (HttpURLConnection)url.openConnection();
			
			httpUrlConnection.setRequestMethod("POST");
			httpUrlConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			
			String parameters = "userID=" + URLEncoder.encode(userID, "utf-8") 
					+ "&jobID=" + URLEncoder.encode(jobID, "utf-8") 
					+ "&docID=" + URLEncoder.encode(documentID, "utf-8")
					+ "&cmpID=" + URLEncoder.encode(cmpID, "utf-8")
					+ "&Document=" + URLEncoder.encode(document, "utf-8");

			httpUrlConnection.setDoOutput(true);
			
			dataOutputStream = new DataOutputStream(httpUrlConnection.getOutputStream());
			dataOutputStream.writeBytes(parameters);
			dataOutputStream.flush();
			
			int responseCode = httpUrlConnection.getResponseCode();
			
			System.out.println("[ApprovalSender][sendApprovalSave] ==================================================");
			System.out.println("[ApprovalSender][sendApprovalSave] request URL : " + url);
			System.out.println("[ApprovalSender][sendApprovalSave] request Parameter : " + parameters);
			System.out.println("[ApprovalSender][sendApprovalSave] response Code : " + responseCode);
			System.out.println("[ApprovalSender][sendApprovalSave] ==================================================");
			
			bufferedReader = new BufferedReader(new InputStreamReader(httpUrlConnection.getInputStream()));
			
			String line;
			stringBuffer = new StringBuffer();
			
			while ((line = bufferedReader.readLine()) != null) {
				stringBuffer.append(line);
			}
			
			String responseString = stringBuffer.toString();
			
			System.out.println("[ApprovalSender][sendApprovalSave] ==================================================");
			System.out.println("[ApprovalSender][sendApprovalSave] response String : " + responseString);
			System.out.println("[ApprovalSender][sendApprovalSave] ==================================================");
			
			ApprovalReceiver approvalReceiver = new ApprovalReceiver();
			String status = approvalReceiver.getNodeData(responseString, "status");
			
			System.out.println("[ApprovalSender][sendApprovalSave] ==================================================");
			System.out.println("[ApprovalSender][sendApprovalSave] response status : " + status);
			System.out.println("[ApprovalSender][sendApprovalSave] ==================================================");
		 	
			if (status.equals("Success")) {
				// 전자결재에 상신 정보 저장 성공 메시지를 받았으므로 계약의 결재상태를 20(상신완료) 처리
				DataObject contractDao = new DataObject("tcb_contmaster");
				contractDao.item("appr_status", "20");
				boolean updateResult = contractDao.update("cont_no = '" + contNo + "' and cont_chasu = '" + contChasu + "'");
				System.out.println("[ApprovalSender][sendApprovalSave] updateResult : " + updateResult);
				result = updateResult;
			} else {
				code = approvalReceiver.getNodeData(responseString, "code");
				message = approvalReceiver.getNodeData(responseString, "message");
			}
		} catch (Exception e) {
			message = e.toString();
			e.printStackTrace();
		} finally {
			if (bufferedReader != null) try {bufferedReader.close();} catch (Exception ex1) {}
			if (dataOutputStream != null) try {dataOutputStream.close();} catch (Exception ex2) {}
			if (httpUrlConnection != null) try {httpUrlConnection.disconnect();} catch (Exception ex3) {}
		}
		
		System.out.println("[ApprovalSender][sendApprovalSave] ==================================================");
		System.out.println("[ApprovalSender][sendApprovalSave] result : " + result);
		System.out.println("[ApprovalSender][sendApprovalSave] code : " + code);
		System.out.println("[ApprovalSender][sendApprovalSave] message : " + message);
		System.out.println("[ApprovalSender][sendApprovalSave] ==================================================");
		
		System.out.println("[ApprovalSender][sendApprovalSave] END");
		
		return result;
	}
	
	public boolean sendApprovalDelete(DataSet approvalInfo) {
		
		System.out.println("[ApprovalSender][sendApprovalDelete] START");
		
		boolean result = false;
		String code = "";
		String message = "";
		
		HttpURLConnection httpUrlConnection = null;
		DataOutputStream dataOutputStream = null;
		BufferedReader bufferedReader = null;
		
		try {
			String cmd = "goNsDeleteDoc";
			String jobID = approvalInfo.getString("jobID");
			if (jobID == null || jobID.isEmpty()) jobID = Config.getApprovalDocumentType();
			String contNo = approvalInfo.getString("contNo");
			String contChasu = approvalInfo.getString("contChasu");
			String docID = approvalInfo.getString("docID");
		 	if (docID == null || docID.isEmpty()) docID = contNo;
		 	String cmpID = "CN";
		 	String userID = approvalInfo.getString("userID");
		 	
		 	System.out.println("[ApprovalSender][sendApprovalDelete] ==================================================");
		 	System.out.println("[ApprovalSender][sendApprovalDelete] cmd : " + cmd);
		 	System.out.println("[ApprovalSender][sendApprovalDelete] jobID : " + jobID);
		 	System.out.println("[ApprovalSender][sendApprovalDelete] contNo : " + contNo);
		 	System.out.println("[ApprovalSender][sendApprovalDelete] contChasu : " + contChasu);
		 	System.out.println("[ApprovalSender][sendApprovalDelete] docID : " + docID);
		 	System.out.println("[ApprovalSender][sendApprovalDelete] cmpID : " + cmpID);
		 	System.out.println("[ApprovalSender][sendApprovalDelete] userID : " + userID);
		 	System.out.println("[ApprovalSender][sendApprovalDelete] ==================================================");
		 	
		 	URL url = new URL(Config.getApprovalAction() + "/ekp/user.do");
		 	// URL url = new URL("http://localhost/web/buyer/contract/contract_approval_test.jsp");
			httpUrlConnection = (HttpURLConnection)url.openConnection();
			
			httpUrlConnection.setRequestMethod("POST");
			
			String parameters = "cmd=" + URLEncoder.encode(cmd, "utf-8")
							 + "&jobID=" + URLEncoder.encode(jobID, "utf-8")
							 + "&docID=" + URLEncoder.encode(docID, "utf-8")
							 + "&cmpID=" + URLEncoder.encode(cmpID, "utf-8")
							 + "&userID=" + URLEncoder.encode(userID, "utf-8");

			httpUrlConnection.setDoOutput(true);
			
			dataOutputStream = new DataOutputStream(httpUrlConnection.getOutputStream());
			dataOutputStream.writeBytes(parameters);
			dataOutputStream.flush();
			
			int responseCode = httpUrlConnection.getResponseCode();
			
			System.out.println("[ApprovalSender][sendApprovalDelete] ==================================================");
			System.out.println("[ApprovalSender][sendApprovalDelete] request URL : " + url);
			System.out.println("[ApprovalSender][sendApprovalDelete] request Parameter : " + parameters);
			System.out.println("[ApprovalSender][sendApprovalDelete] response Code : " + responseCode);
			System.out.println("[ApprovalSender][sendApprovalDelete] ==================================================");
			
			bufferedReader = new BufferedReader(new InputStreamReader(httpUrlConnection.getInputStream()));
			
			String line;
			StringBuffer stringBuffer = new StringBuffer();
			
			while ((line = bufferedReader.readLine()) != null) {
				stringBuffer.append(line);
			}
			
			String responseString = stringBuffer.toString();
			
			System.out.println("[ApprovalSender][sendApprovalDelete] ==================================================");
			System.out.println("[ApprovalSender][sendApprovalDelete] response String : " + responseString);
			System.out.println("[ApprovalSender][sendApprovalDelete] ==================================================");
			
			ApprovalReceiver approvalReceiver = new ApprovalReceiver();
			String status = approvalReceiver.getNodeData(responseString, "status");
			
			System.out.println("[ApprovalSender][sendApprovalDelete] ==================================================");
			System.out.println("[ApprovalSender][sendApprovalDelete] response status : " + status);
			System.out.println("[ApprovalSender][sendApprovalDelete] ==================================================");
			
			if (status.equals("Success")) {
				// 전자결재에 상신 삭제 성공 메시지를 받았으므로 계약의 결재상태를 삭제 처리
				DataObject contractDao = new DataObject("tcb_contmaster");
				contractDao.item("appr_status", "10");
				boolean updateResult = contractDao.update("cont_no = '" + contNo + "' and cont_chasu = '" + contChasu + "'");
				System.out.println("[ApprovalSender][sendApprovalDelete] updateResult : " + updateResult);
				result = updateResult;
			} else {
				code = approvalReceiver.getNodeData(responseString, "code");
				message = approvalReceiver.getNodeData(responseString, "message");
			}
		} catch (Exception e) {
			message = e.toString();
			e.printStackTrace();
		} finally {
			if (bufferedReader != null) try {bufferedReader.close();} catch (Exception ex1) {}
			if (dataOutputStream != null) try {dataOutputStream.close();} catch (Exception ex2) {}
			if (httpUrlConnection != null) try {httpUrlConnection.disconnect();} catch (Exception ex3) {}
		}
		
		System.out.println("[ApprovalSender][sendApprovalDelete] ==================================================");
		System.out.println("[ApprovalSender][sendApprovalDelete] result : " + result);
		System.out.println("[ApprovalSender][sendApprovalDelete] code : " + code);
		System.out.println("[ApprovalSender][sendApprovalDelete] message : " + message);
		System.out.println("[ApprovalSender][sendApprovalDelete] ==================================================");
		
		System.out.println("[ApprovalSender][sendApprovalDelete] END");
		
		return result;
	}
}