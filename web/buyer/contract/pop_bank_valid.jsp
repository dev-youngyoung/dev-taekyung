<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
String[] code_bankCode = {"�ѱ�����=>001","�������=>002","�������=>003","��������=>004","��������=>007","����������=>008","��������=>011","���� ������=>012","�츮����=>020","SC��������=>023","�ѱ���Ƽ����=>027","�뱸����=>031","�λ�����=>032","��������=>034","��������=>035","��������=>037","�泲����=>039","�������ݰ��߾�ȸ=>045","����=>048","��������=>050","��Ÿ �ܱ�������=>051","��ǽ��ĸ�����=>052","HSBC����=>054","����ġ����=>055","�����Ǹ�ü�̽�����=>057","����ȣ����=>058","��������������=>059","BOA����=>060","�����ĸ�����=>061","�߱���������=>062","�߱�����=>063","�긲�����߾�ȸ=>064","��ȭ����=>065","��������=>066","�߱��Ǽ�����=>067","��ü��=>071","�ſ뺸�����=>076","����������=>077","KEB�ϳ�����=>081","��������=>088","���̹�ũ=>089","īī����ũ=>090","����û=>091","�ѱ����ñ�������=>093","���ﺸ������=>094","����û=>095","�ѱ����ڱ�����=>096","����������=>099","�ѱ��ſ�������=>101","�����������=>102","�����������������=>103","����ġ������������=>104","������������=>105","����Ÿ����(�������ձ�������)=>209","KB����=>218","���긴����������=>221","�Ѿ�����=>222","������������=>223","BNK��������=>224","IBK��������=>225","KTB��������=>227","�̷����´��=>238","�Ｚ����=>240","�ѱ���������=>243","NH��������=>247","��������=>261","������������=>262","����������=>263","Ű������=>264","�̺���Ʈ��������=>265","SK����=>266","�������=>267","��ȭ��������=>269","�ϳ���������=>270","���ѱ�������=>278","DB��������=>279","������������=>280","�޸������ձ�������=>287","NH��������=>289","�α�����=>290","�ſ�����=>291","��������������=>292","�ѱ����Ǳ���=>293","�ݵ�¶����ڸ���=>294","�츮���ձ���=>295","����ĳ��Ż=>299"};

String callback = u.request("callback");
if(callback.equals("")){
	u.jsErrClose("�������� ��η� �����ϼ���.");
	return;
}

String messageNo = u.request("messageNo");
if(!messageNo.equals("")){
    messageNo = u.aseDec(messageNo);
}

DataObject bankCertLogDao = new DataObject("tcb_bank_cert_log");
DataSet bankCertLog = new DataSet();
if(!messageNo.equals("")) {
    bankCertLog = bankCertLogDao.find("message_no = '" + messageNo + "' and req_gubun = '10' ");
    if (!bankCertLog.next()) {
        u.jsErrClose("���� ���� ��û �̷��� �����ϴ�.");
        return;
    }
    bankCertLog.put("limit_date", u.addDate("I",30,u.strToDate(bankCertLog.getString("req_date")),"yyyyMMddHHmmss"));
    bankCertLog.put("str_limit_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", bankCertLog.getString("limit_date")));

    if(Long.parseLong(u.getTimeString()) > Long.parseLong(bankCertLog.getString("limit_date"))){
    	u.jsErrClose("������Ͻð��� ����Ǿ����ϴ�.(����ð� : "+bankCertLog.getString("str_limit_date")+")\\n\\n���������� ó������ ��õ� �ϼ���.");
    	return;
    }
}

f.addElement("c_bankname", null, "hname:'�����', required:'Y'");
f.addElement("c_bankno", null, "hname:'���¹�ȣ', required:'Y'");
f.addElement("c_bankuser", null, "hname:'������', required:'Y'");
if(!messageNo.equals("")) {
    f.addElement("cert_key", null, "hname:'������ȣ', required:'Y', fixbyte:'4' ");
}
if(u.isPost()&& f.validate()){
    String serviceId = "30047629";
    String apiKey = "2GYrLhrNo1HSxiq1Uy4xvks+hHSPMVBNTc4pjVl5gEs=";
    String transDt = u.getTimeString("yyyyMMdd");
    String transTm = u.getTimeString("HHmmss");


    String c_bankno = f.get("c_bankno");
    String c_bankname = f.get("c_bankname");
    String c_bankuser = f.get("c_bankuser");

    if(messageNo.equals("")) { // ������û
        bankCertLogDao = new DataObject("tcb_bank_cert_log");
        messageNo = bankCertLogDao.getOne(
                "select '"+u.getTimeString("yyMM")+"'||  lpad(nvl(max(substr(message_no,5)),0)+1,6,'0') message_no"
                        + "  from tcb_bank_cert_log"
                        + " where message_no like '"+u.getTimeString("yyMM")+"%' "
        );

        String planText = serviceId + messageNo + transDt + transTm;
        Security security = new Security();
        String encryptData = security.SHA256encrypt(planText, apiKey);

        String accountNo = security.Nicepay_AES_Encode(c_bankno + messageNo, apiKey);

        DataSet req_info = new DataSet();
        req_info.addRow();
        req_info.put("bank_no", c_bankno);
        req_info.put("bank_name", c_bankname);
        req_info.put("bank_user", c_bankuser);
        req_info.put("bank_no", c_bankno);
        req_info.put("serviceId", serviceId);
        req_info.put("transDt", transDt);
        req_info.put("transTm", transTm);
        req_info.put("messageNo", messageNo);
        req_info.put("planText", planText);
        req_info.put("encryptData", encryptData);
        req_info.put("bankCd", u.getItem(c_bankname, code_bankCode));
        req_info.put("accountNo", accountNo);
        if(c_bankuser.getBytes().length> 16){
            req_info.put("accountNm", URLEncoder.encode(new String(unicodeCut(c_bankuser.getBytes(),16)),"UTF-8"));
        }else{
            req_info.put("accountNm", URLEncoder.encode(c_bankuser,"UTF-8"));
        }



        Http hp = new Http();
        hp.timeOut= 10*1000;
        hp.setEncoding("euc-kr");
        hp.setUrl("https://rest.thebill.co.kr:4435/thebill/rest/certAcct.json");
        hp.setParam("callback", "reqCallBack");
        hp.setParam("serviceId", req_info.getString("serviceId"));
        hp.setParam("encryptData", req_info.getString("encryptData"));
        hp.setParam("messageNo", req_info.getString("messageNo"));
        hp.setParam("bankCd", req_info.getString("bankCd"));
        hp.setParam("accountNo", req_info.getString("accountNo"));
        hp.setParam("accountNm", req_info.getString("accountNm"));
        hp.setParam("transDt", req_info.getString("transDt"));
        hp.setParam("transTm", req_info.getString("transTm"));

        bankCertLogDao = new DataObject("tcb_bank_cert_log");
        bankCertLogDao.item("message_no",messageNo);
        bankCertLogDao.item("req_gubun ","10");
        bankCertLogDao.item("sdd_url", f.get("sdd_url"));
        bankCertLogDao.item("req_url", "https://rest.thebill.co.kr:4435/thebill/rest/certAcct.json");
        bankCertLogDao.item("req_data", req_info.toString());
        bankCertLogDao.item("req_ip", request.getRemoteHost());
        bankCertLogDao.item("req_date", u.getTimeString());
        bankCertLogDao.item("status", "10");
        if(!bankCertLogDao.insert()){
            u.jsError("������� ���� ó���� ���� �Ͽ����ϴ�.");
            return;
        }

        String ret = hp.sendHTTPS();
        if (ret.equals("")) {
            u.jsError("��� ó���� �����Ͽ����ϴ�.");
            return;
        }
        u.sp(ret);
        DataSet data = u.json2Dataset(ret.substring(ret.indexOf("{"), ret.length() - 1));
        if (!data.next()) {
            u.jsError("��� ó���� �����Ͽ����ϴ�.");
            return;
        }
        data.put("resultMsg", URLDecoder.decode(data.getString("resultMsg"), "UTF-8"));

        bankCertLogDao = new DataObject("tcb_bank_cert_log");
        bankCertLogDao.item("res_data", data.toString());
        bankCertLogDao.item("status", "10");
        if(!bankCertLogDao.update("message_no = '"+messageNo+"' and req_gubun = '10' ")){
            u.jsError("������� ���� ó���� ���� �Ͽ����ϴ�.");
            return;
        }

        if(!data.getString("resultCd").equals("0000")){
            u.jsError("�������࿡ ���� �Ͽ����ϴ�.\\n\\n(Message: "+data.getString("resultMsg")+")");
            return;
        }

        u.redirect("pop_bank_valid.jsp?"+u.getQueryString()+"&messageNo="+u.aseEnc(messageNo));
        return;
    }else{

        String planText = serviceId + messageNo + transDt + transTm;

        Security security = new Security();
        String encryptData = security.SHA256encrypt(planText, apiKey);

        String cert_key = f.get("cert_key");

        DataSet req_info = new DataSet();
        req_info.addRow();
        req_info.put("bank_no", c_bankno);
        req_info.put("bank_name", c_bankname);
        req_info.put("bank_user", c_bankuser);
        req_info.put("bank_no", c_bankno);
        req_info.put("serviceId", serviceId);
        req_info.put("transDt", transDt);
        req_info.put("transTm", transTm);
        req_info.put("messageNo", messageNo);
        req_info.put("planText", planText);
        req_info.put("encryptData", encryptData);
        req_info.put("certKey", cert_key);

        Http hp = new Http();
        hp.setEncoding("euc-kr");
        hp.setUrl("https://rest.thebill.co.kr:4435/thebill/rest/certAcctMark.json");
        hp.setParam("callback", "reqCallBack");
        hp.setParam("serviceId", req_info.getString("serviceId"));
        hp.setParam("encryptData", req_info.getString("encryptData"));
        hp.setParam("messageNo", req_info.getString("messageNo"));
        hp.setParam("certKey", req_info.getString("certKey"));
        hp.setParam("transDt", req_info.getString("transDt"));
        hp.setParam("transTm", req_info.getString("transTm"));

        bankCertLogDao = new DataObject("tcb_bank_cert_log");
        bankCertLogDao.item("message_no",messageNo);
        bankCertLogDao.item("req_gubun ","20");
        bankCertLogDao.item("sdd_url", f.get("sdd_url"));
        bankCertLogDao.item("req_url", "https://rest.thebill.co.kr:4435/thebill/rest/certAcctMark.json");
        bankCertLogDao.item("req_data", req_info.toString());
        bankCertLogDao.item("req_ip", request.getRemoteHost());
        bankCertLogDao.item("req_date", u.getTimeString());
        bankCertLogDao.item("status", "10");
        if(!bankCertLogDao.insert()){
            u.jsError("������� ���� ó���� ���� �Ͽ����ϴ�.");
            return;
        }

        String ret = hp.sendHTTPS();
        if (ret.equals("")) {
            u.jsError("��� ó���� �����Ͽ����ϴ�.");
            return;
        }
        u.sp(ret);


        DataSet data = u.json2Dataset(ret.substring(ret.indexOf("{"), ret.length() - 1));
        if (!data.next()) {
            u.jsError("��� ó���� �����Ͽ����ϴ�.");
            return;
        }
        data.put("resultMsg", URLDecoder.decode(data.getString("resultMsg"), "UTF-8"));


        bankCertLogDao = new DataObject("tcb_bank_cert_log");
        bankCertLogDao.item("res_data", data.toString());
        bankCertLogDao.item("status", "10");
        if(!bankCertLogDao.update( " message_no = '"+messageNo+"'  and req_gubun = '20' ")){
            u.jsError("������� ���� ó���� ���� �Ͽ����ϴ�.");//�����̷� �����
            return;
        }

        if(!data.getString("resultCd").equals("0000")){
            u.jsErrClose("�������࿡ ���� �Ͽ����ϴ�.\\n\\n(Message: "+data.getString("resultMsg")+")");
            return;
        }

        out.println("<script>");
        out.println("var data = { 'bank_name' : '"+f.get("c_bankname")+"' , 'bank_no' : '"+f.get("c_bankno")+"', 'bank_user' : '"+f.get("c_bankuser")+"' , 'message_no': '"+messageNo+"' };");
        out.println("opener."+callback+"(data);");
        out.println("alert('���������� �������� ó�� �Ǿ����ϴ�.');");
        out.println("self.close();");
        out.println("</script>");
        return;
    }
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_bank_valid");
p.setVar("popup_title","��������");
p.setVar("modify", false);
p.setVar("messageNo", messageNo);
p.setVar("callback", callback);
p.setVar("bankCertLog",bankCertLog);
p.setVar("query", u.getQueryString());
p.setVar("form_script", f.getScript());
p.display(out);
%>
<%!
    /**
     * Byte �ڸ��� �����ڵ� �߰����� �߶�� �ϴ� ��� �����Ⱚ �����ؼ� ��ȯ.
     * @param inputB ���� ���ڿ�����Ʈ
     * @param length �ڸ���
     * @return byte[] �ڸ��� �� ���ڿ�����Ʈ
     * ���̸��� ���������� ���� ����.
     */
    public byte[] unicodeCut(byte[] inputB, int length) {
        boolean boo_middle_cut = false;
        int unicodeSize = 0;
        for (int i=0;i<length;i++) {
            if (inputB[i] < 0x00) unicodeSize++;
        } // end for
        if (unicodeSize%2 == 1) boo_middle_cut = true;

        // �����ڵ� ����� �߸��� ���
        if (boo_middle_cut) return new String(inputB, 0, length-1).getBytes();
            // �����ڵ尡 �ƴ�. �׳� �ڸ��� ����.
        else return new String(inputB, 0, length).getBytes();
    }

%>