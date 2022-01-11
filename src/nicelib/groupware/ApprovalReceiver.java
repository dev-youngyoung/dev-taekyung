package nicelib.groupware;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import nicelib.db.DataObject;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

/**
 * 전자결재에서 결재상태 데이터를 받기 위한 클래스
 * @author sjlee
 */
public class ApprovalReceiver extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// super.doGet(request, response);
		PrintWriter printWriter = response.getWriter();
		printWriter.print("[ApprovalReceiver] Groupware Approval Receiver");
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// super.doPost(request, response);
		
		System.out.println("[ApprovalReceiver] Groupware Approval Receiver START");

		String status = "Success";		// 성공여부
		String code = "0";				// 에러코드
		String message = "";			// 메시지
		
		// 전자결재에서 전달받은 파라미터
		String protID = request.getParameter("protID");
        String userID = request.getParameter("userID");				// 상신자 아이디
        String jobID = request.getParameter("jobID");				// ECS12 시스템 명칭
        String docID = request.getParameter("docID");				// 문서고유번호(key)
        String xmlData = request.getParameter("Document");			// 상신 정보 xml
        
        System.out.println("[ApprovalReceiver] parameter protID : " + protID);
        System.out.println("[ApprovalReceiver] parameter userID : " + userID);
        System.out.println("[ApprovalReceiver] parameter jobID : " + jobID);
        System.out.println("[ApprovalReceiver] parameter docID : " + docID);
        System.out.println("[ApprovalReceiver] parameter Document : " + xmlData);
        
        boolean updateResult = false;
		
		try {
	        // protID에 따른 작업 분기
	        if (protID.equals("deleteDoc")) {
	        	// deleteDoc의 경우 문서 삭제(재기안이 가능하도록 상신대기(10)으로)
	        	DataObject contDao = new DataObject("tcb_contmaster"); // 계약정보
	        	contDao.item("appr_status", "10"); // 상신대기
	        	updateResult = contDao.update(" cont_no = '" + docID + "' and cont_chasu = '0'");
	        } else if (protID.equals("createDoc")) {
	        	// createDoc의 경우 문서 상태 변경
	        	String documentStatus = this.getNodeData(xmlData, "documentStatus");
	        	System.out.println("[ApprovalReceiver] documentStatus : " + documentStatus);
	        	
	        	DataObject contractDao = new DataObject("tcb_contmaster");
				
	        	if (documentStatus.equals("accepted")) {
	        		// accepted : 기안올림(30)
	        		contractDao.item("appr_status", "30");
	        		updateResult = contractDao.update("cont_no = '" + docID + "' and cont_chasu = '0'");
	        	} else if (documentStatus.equals("updated")) {
	        		// updated : 중간결재 승인(31)
	        		contractDao.item("appr_status", "31");
	        		updateResult = contractDao.update("cont_no = '" + docID + "' and cont_chasu = '0'");
	        	} else if (documentStatus.equals("processed")) {
	        		// processed : 최종승인(50)
	        		contractDao.item("appr_status", "50");
	        		updateResult = contractDao.update("cont_no = '" + docID + "' and cont_chasu = '0'");
	        	} else if (documentStatus.equals("returned")) {
	        		// returned : 기안취소/반려(40)
	        		contractDao.item("appr_status", "40");
	        		updateResult = contractDao.update("cont_no = '" + docID + "' and cont_chasu = '0'");
	        	} else {
	        		// null이거나 위에 해당하지 않는 값
	        		message = "documentStatus ["+ documentStatus +"] is not correct.";
	        		System.out.println("[ApprovalReceiver] documentStatus ["+ documentStatus +"] is not correct.");
	        	}
	        } else {
	        	// 해당작업 없음
	        	message = "protID ["+ protID +"] is not defined.";
	        	System.out.println("[ApprovalReceiver] protID ["+ protID +"] is not defined.");
	        }
		} catch (Exception e) {
        	message = e.toString();
		}
		
		if (!updateResult) {
			status = "Error";
        	code = "100";
		}
		
		String responseStr = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
							   + "<ndata>"
							   + "<status>"+status+"</status>"
							   + "<code>"+code+"</code>"
							   + "<message>"+message+"</message>"
						   + "</ndata>";
		
		PrintWriter printWriter = response.getWriter();
		printWriter.print(responseStr);
		
		/*HttpURLConnection httpUrlConnection = null;
		DataOutputStream dataOutputStream = null;
		BufferedReader bufferedReader = null;
		
		try {
			// 처리 결과를 전자결재에 전달
			URL url = new URL("http://gw.nongshim.net/servlet/com.nanum.xf.servlet.job.XFJobServlet");
			httpUrlConnection = (HttpURLConnection)url.openConnection();
			
			httpUrlConnection.setRequestMethod("POST");
			
			String parameters = "protID=" + protID
							 + "&userID=" + userID
							 + "&jobID=" + jobID
							 + "&docID=" + docID
							 + "&Document="
							 + "<?xml version=\"1.0\" encoding=\"euc-kr\"?>"
							 + "<ndata>"
							  	 + "<status>"+status+"</status>"
						 	 	 + "<code>"+code+"</code>"
						 	 	 + "<message>"+message+"</message>"
						 	 + "</ndata>";

			httpUrlConnection.setDoOutput(true);
			
			dataOutputStream = new DataOutputStream(httpUrlConnection.getOutputStream());
			dataOutputStream.writeBytes(parameters);
			dataOutputStream.flush();
			
			int responseCode = httpUrlConnection.getResponseCode();
			
			System.out.println("[ApprovalReceiver] request URL : " + url);
			System.out.println("[ApprovalReceiver] request Parameter : " + parameters);
			System.out.println("[ApprovalReceiver] response Code : " + responseCode);
			
			bufferedReader = new BufferedReader(new InputStreamReader(httpUrlConnection.getInputStream()));
			
			String line;
			StringBuffer stringBuffer = new StringBuffer();
			
			while ((line = bufferedReader.readLine()) != null) {
				stringBuffer.append(line);
			}
			
			System.out.println("[ApprovalReceiver] response : " + stringBuffer.toString());
		} catch (Exception e) {
			System.out.println("[ApprovalReceiver] send result fail.");
			e.printStackTrace();
		} finally {
			if (bufferedReader != null) try {bufferedReader.close();} catch (Exception ex1) {}
			if (dataOutputStream != null) try {dataOutputStream.close();} catch (Exception ex2) {}
			if (httpUrlConnection != null) try {httpUrlConnection.disconnect();} catch (Exception ex3) {}
		}*/
		
		System.out.println("[ApprovalReceiver] Groupware Approval Receiver END");
	}
	
	public String getNodeData(String xmlData, String nodeName) {
		
		Document document = null;
		NodeList nodeList = null;
		Element element = null;
		
		try {
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setNamespaceAware(true);
			DocumentBuilder builder = factory.newDocumentBuilder();
			StringReader reader = new StringReader(xmlData);
			InputSource source = new InputSource(reader);
			document = builder.parse(source);
			
			nodeList = document.getElementsByTagName(nodeName);
			if (nodeList.getLength() != 1 ) {
				System.out.println("[ApprovalReceiver getNodeData] Node " + nodeName + " is not one.");
				return null;
			}
			
			element = (Element)nodeList.item(0);
			return element.getFirstChild().getNodeValue();
		} catch (Exception ex) {
			System.out.println(ex.toString());
			ex.printStackTrace();
			return null;
		}
	}
}