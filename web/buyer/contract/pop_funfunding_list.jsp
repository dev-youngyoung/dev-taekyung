<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
if(!_member_no.equals("20190800293")){
    u.jsErrClose("�ش�ȭ�鿡 ���� ��� ������ �����ϴ�.");
    return;
}
//String connect_module = "D:\\nicedata\\https_client\\earlypay.bat";
String connect_module = "/application/nicesh/earlypay.sh";
String header = "X-Funfunding-Site-Key=>IO20IUboJC98/RDQqIJdz1y+A860/u43bLVPQugS1sEdDB55mz2MON5oGJCtMVje||X-Funfunding-Secret-Key=>CQsZtHRHa/EbdQ8Y2q1Gjjo0lH29Ycb9H66GjyPoX+Ip8nzmaTn1rspBou2toemA";
header =  u.aseEnc(header);//cmd ���ڰ���Ī�� = ���� ����� ��. base64�� ��� ���ϰ� ���ڿ������θ� �̿��ϴ� ase��ȣȭ ��� ��.��
String ret = "";

f.addElement("id",null, "hname:'����ȣ', required:'Y'");
if(u.isPost()&&f.validate()){
	String id = f.get("id");
    String connServer = "https://www.funfunding.co.kr/api/nice/detail/"+id;
    try{
        String buffer = null;
        String[] cmd =  {connect_module, "COMMON", connServer, header};
        //  ���߽� ����
        Process process = new ProcessBuilder(cmd).start();
        BufferedReader stdOut = new BufferedReader( new InputStreamReader(process.getInputStream()) );

        // ǥ����� ���¸� ���
        while( (buffer = stdOut.readLine()) != null ) {
            ret += buffer;
        }

    }catch (Exception ex){
        System.out.println("funfunding ��� ���� :" + ex.getMessage());
        u.jsAlert("funfunding�κ��� ������ ������ �� ���� �⺻������ �����մϴ�.\\n\\n[Error message] " + ex.getMessage());
        return;
    }

    DataSet recvData = u.json2Dataset(ret.substring(ret.indexOf("{")));
    recvData.next();
    if(!recvData.getString("result").equals("SUCCESS")){
        u.jsAlert("funfunding�κ��� ������ ������ �� �����ϴ�.\\n\\n[Error message] " + recvData.getString("message"));
        return;
    }

    String data = recvData.getString("data");
    out.println("<script>");
    out.println("var data = "+data+";");
    out.println("opener.spe_setContInfo(data);");
    out.println("self.close();");
    out.println("</script>");
    return;
}

try {
    String buffer = null;
    String connServer = "https://www.funfunding.co.kr/api/nice/list";
    String[] cmd =  {connect_module, "COMMON", connServer, header};

    //  ���߽� ����
    Process process = new ProcessBuilder(cmd).start();
    BufferedReader stdOut = new BufferedReader( new InputStreamReader(process.getInputStream()) );

    // ǥ����� ���¸� ���
    while( (buffer = stdOut.readLine()) != null ) {
        ret += buffer;
    }

} catch(Exception ex) {
    System.out.println("funfunding ��� ���� :" + ex.getMessage());
    u.jsAlert("funfunding�κ��� ������ ������ �� ���� �⺻������ �����մϴ�.\\n\\n[Error message] " + ex.getMessage());
    return;
}

DataSet recvData = u.json2Dataset(ret.substring(ret.indexOf("{")));
recvData.next();
if(!recvData.getString("result").equals("SUCCESS")){
    u.jsAlert("funfunding�κ��� ������ ������ �� �����ϴ�.\\n\\n[Error message] " + recvData.getString("message"));
    return;
}

DataSet list = recvData.getDataSet("data");


p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_funfunding_list");
p.setVar("popup_title","�����");
p.setLoop("list", list);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>
