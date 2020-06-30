<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%


f.addElement("companynm", null, "hname:'회사명',required:'Y'");
f.addElement("personnm", null, "hname:'담당자명',required:'Y'");
f.addElement("hp1", null, "hname:'휴대폰',required:'Y'");
f.addElement("hp2", null, "hname:'휴대폰',required:'Y'");
f.addElement("hp3", null, "hname:'휴대폰',required:'Y'");
f.addElement("contents", null, "hname:'문의내용',required:'Y'");
f.addElement("chk_confirm1", null, "hname:'개인정보수집이용동의', required:'Y'");


if(u.isPost()&&f.validate()){
	
	String recaptcha_response = f.get("g-recaptcha-response");
	if(!recaptchaVerify(recaptcha_response)){
		u.jsError("정상적인 경로로 접근하세요.1");
		return;
	}
	
	if(f.get("hp1").equals("")||f.get("hp2").equals("")||f.get("hp3").equals("")){
		u.jsError("정상적인경로로 접근하세요.");
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
		u.jsError("저장에 실패하였습니다.");
		return;
	}

	String sSendPhoneNo = "027889097";	// 보내는 사람 번호
	String sSendName = "나이스다큐";  // 보내는 사람명
	String sRecvVendCd = "";  // 받을 업체명
	String sRecvHp1 = "010";  // 받을 담당자 휴대폰 번호
	String sRecvHp2 = "7583";//"7583";  // 받을 담당자 휴대폰 번호
	String sRecvHp3 = "0902";//"0902";  // 받을 담당자 휴대폰 번호
	//String sSmsMsg =  f.get("companynm")+ "에서 문의 (일반기업용) "+f.get("personnm")+"("+f.get("hp1")+"-"+f.get("hp2")+"-"+f.get("hp3")+")";

	//나이스지라 로 메일보내기 
	String body = "일반기업용 시스템이용문의<br>회사명:"+f.get("companynm")+"<br>"+"문의자명:"+f.get("personnm")+"<br>"+"전화번호:"+f.get("hp1")+"-"+f.get("hp2")+"-"+f.get("hp3")+"<br>문의내용:"+u.nl2br(f.get("contents"));
	u.mail("nicedocu@nicednr.co.kr", "일반기업용 시스템이용문의", body);
	
	u.jsAlertReplace("문의가 성공적으로 접수되었습니다.\\n\\n담당자가 검토 후 연락드리겠습니다.","si_qna.jsp");
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