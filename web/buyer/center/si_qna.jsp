<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%


f.addElement("companynm", null, "hname:'ȸ���',required:'Y'");
f.addElement("personnm", null, "hname:'����ڸ�',required:'Y'");
f.addElement("hp1", null, "hname:'�޴���',required:'Y'");
f.addElement("hp2", null, "hname:'�޴���',required:'Y'");
f.addElement("hp3", null, "hname:'�޴���',required:'Y'");
f.addElement("contents", null, "hname:'���ǳ���',required:'Y'");
f.addElement("chk_confirm1", null, "hname:'�������������̿뵿��', required:'Y'");


if(u.isPost()&&f.validate()){
	
	String recaptcha_response = f.get("g-recaptcha-response");
	if(!recaptchaVerify(recaptcha_response)){
		u.jsError("�������� ��η� �����ϼ���.1");
		return;
	}
	
	if(f.get("hp1").equals("")||f.get("hp2").equals("")||f.get("hp3").equals("")){
		u.jsError("�������ΰ�η� �����ϼ���.");
		return;
	}
	
	String query =
	"INSERT INTO tcb_qna "+
	"     (qnaseq,         "+
	"      companynm,     "+
	"      personnm,      "+
	"      mobile,        "+
	"      insertdate,    "+
	"      contents,       "+
	"      gubun       "+
	"      )       "+
	"     VALUES "+
	"     ((SELECT (NVL(MAX(qnaseq), 0) + 1) qnaseq "+
	"               FROM tcb_qna),             "+
	"      $companynm$,             "+
	"      $personnm$,            "+
	"      $mobile$,             "+
	"      sysdate,       "+
	"      $contents$,     "+
	"      $gubun$ 	   "+
	"     )";

	DataObject qnaDao = new DataObject("tcb_qna");
	qnaDao.item("companynm", f.get("companynm"));
	qnaDao.item("personnm", f.get("personnm"));
	qnaDao.item("mobile", f.get("hp1")+"-"+f.get("hp2")+"-"+f.get("hp3"));
	qnaDao.item("contents", f.get("contents"));
	qnaDao.item("gubun", f.get("gubun"));

	DB db = new DB();
	db.setCommand(query, qnaDao.record);
	if(!db.executeArray()){
		u.jsError("���忡 �����Ͽ����ϴ�.");
		return;
	}

	String sSendPhoneNo = "027889097";	// ������ ��� ��ȣ
	String sSendName = "���̽���ť";  // ������ �����
	String sRecvVendCd = "";  // ���� ��ü��
	String sRecvHp1 = "010";  // ���� ����� �޴��� ��ȣ
	String sRecvHp2 = "7583";//"7583";  // ���� ����� �޴��� ��ȣ
	String sRecvHp3 = "0902";//"0902";  // ���� ����� �޴��� ��ȣ
	//String sSmsMsg =  f.get("companynm")+ "���� ���� (�Ϲݱ����) "+f.get("personnm")+"("+f.get("hp1")+"-"+f.get("hp2")+"-"+f.get("hp3")+")";

	//���̽����� �� ���Ϻ����� 
	String body = "�Ϲݱ���� �ý����̿빮��<br>ȸ���:"+f.get("companynm")+"<br>"+"�����ڸ�:"+f.get("personnm")+"<br>"+"��ȭ��ȣ:"+f.get("hp1")+"-"+f.get("hp2")+"-"+f.get("hp3")+"<br>���ǳ���:"+u.nl2br(f.get("contents"));
	u.mail("nicedocu@nicednr.co.kr", "�Ϲݱ���� �ý����̿빮��", body);
	
	u.jsAlertReplace("���ǰ� ���������� �����Ǿ����ϴ�.\\n\\n����ڰ� ���� �� �����帮�ڽ��ϴ�.","si_qna.jsp");
	return;
}

p.setLayout("default");
p.setDebug(out);
p.setBody("center.si_qna");
p.setVar("menu_cd","000171");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("id"));
p.setVar("form_script",f.getScript());
p.display(out);
%>
<%!
public boolean recaptchaVerify(String recaptcha_response){
	String secret = "6LduZXUUAAAAAIqE5yimuQwMkgPHox2gSWzw2eXP";
	if(recaptcha_response.equals("")){
		return false;
	}
	try{
		URL url = new URL("https://www.google.com/recaptcha/api/siteverify");
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		
		// add reuqest header
		con.setRequestMethod("POST");
		con.setRequestProperty("User-Agent", "Mozilla/5.0");
		con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
		
		String postParams = "secret=" + secret + "&response="+ recaptcha_response;
		
		// Send post request
		con.setDoOutput(true);
		DataOutputStream wr = new DataOutputStream(con.getOutputStream());
		wr.writeBytes(postParams);
		wr.flush();
		wr.close();
		
		int responseCode = con.getResponseCode();
		
		BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();
		
		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		in.close();
		System.out.println(response.toString());
		// print result
		DataSet result = Util.json2Dataset(response.toString());
		result.next();
		return result.getString("success").equals("true");
	}catch(Exception e){
		e.printStackTrace(System.out);
		return false;
	}
}

%>