<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%
String[] code_bankCode = {"한국은행=>001","산업은행=>002","기업은행=>003","국민은행=>004","수협은행=>007","수출입은행=>008","농협은행=>011","지역 농축협=>012","우리은행=>020","SC제일은행=>023","한국씨티은행=>027","대구은행=>031","부산은행=>032","광주은행=>034","제주은행=>035","전북은행=>037","경남은행=>039","새마을금고중앙회=>045","신협=>048","저축은행=>050","기타 외국계은행=>051","모건스탠리은행=>052","HSBC은행=>054","도이치은행=>055","제이피모간체이스은행=>057","미즈호은행=>058","엠유에프지은행=>059","BOA은행=>060","비엔피파리은행=>061","중국공상은행=>062","중국은행=>063","산림조합중앙회=>064","대화은행=>065","교통은행=>066","중국건설은행=>067","우체국=>071","신용보증기금=>076","기술보증기금=>077","KEB하나은행=>081","신한은행=>088","케이뱅크=>089","카카오뱅크=>090","국세청=>091","한국주택금융공사=>093","서울보증보험=>094","경찰청=>095","한국전자금융㈜=>096","금융결제원=>099","한국신용정보원=>101","대신저축은행=>102","에스비아이저축은행=>103","에이치케이저축은행=>104","웰컴저축은행=>105","유안타증권(동양종합금융증권)=>209","KB증권=>218","골든브릿지투자증권=>221","한양증권=>222","리딩투자증권=>223","BNK투자증권=>224","IBK투자증권=>225","KTB투자증권=>227","미래에셋대우=>238","삼성증권=>240","한국투자증권=>243","NH투자증권=>247","교보증권=>261","하이투자증권=>262","현대차증권=>263","키움증권=>264","이베스트투자증권=>265","SK증권=>266","대신증권=>267","한화투자증권=>269","하나금융투자=>270","신한금융투자=>278","DB금융투자=>279","유진투자증권=>280","메리츠종합금융증권=>287","NH투자증권=>289","부국증권=>290","신영증권=>291","케이프투자증권=>292","한국증권금융=>293","펀드온라인코리아=>294","우리종합금융=>295","아주캐피탈=>299"};

String callback = u.request("callback");
if(callback.equals("")){
	u.jsErrClose("정상적인 경로로 접근하세요.");
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
        u.jsErrClose("계좌 인증 신청 이력이 없습니다.");
        return;
    }
    bankCertLog.put("limit_date", u.addDate("I",30,u.strToDate(bankCertLog.getString("req_date")),"yyyyMMddHHmmss"));
    bankCertLog.put("str_limit_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", bankCertLog.getString("limit_date")));

    if(Long.parseLong(u.getTimeString()) > Long.parseLong(bankCertLog.getString("limit_date"))){
    	u.jsErrClose("인증등록시간이 만료되었습니다.(만료시간 : "+bankCertLog.getString("str_limit_date")+")\\n\\n계좌인증을 처음부터 재시도 하세요.");
    	return;
    }
}

f.addElement("c_bankname", null, "hname:'은행명', required:'Y'");
f.addElement("c_bankno", null, "hname:'계좌번호', required:'Y'");
f.addElement("c_bankuser", null, "hname:'예금주', required:'Y'");
if(!messageNo.equals("")) {
    f.addElement("cert_key", null, "hname:'인증번호', required:'Y', fixbyte:'4' ");
}
if(u.isPost()&& f.validate()){
    String serviceId = "30047629";
    String apiKey = "2GYrLhrNo1HSxiq1Uy4xvks+hHSPMVBNTc4pjVl5gEs=";
    String transDt = u.getTimeString("yyyyMMdd");
    String transTm = u.getTimeString("HHmmss");


    String c_bankno = f.get("c_bankno");
    String c_bankname = f.get("c_bankname");
    String c_bankuser = f.get("c_bankuser");

    if(messageNo.equals("")) { // 인증신청
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
        hp.setEncoding("UTF-8");
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
            u.jsError("통신정보 저장 처리에 실패 하였습니다.");
            return;
        }

        String ret = hp.sendHTTPS();
        if (ret.equals("")) {
            u.jsError("통신 처리에 실패하였습니다.");
            return;
        }
        u.sp(ret);
        DataSet data = u.json2Dataset(ret.substring(ret.indexOf("{"), ret.length() - 1));
        if (!data.next()) {
            u.jsError("통신 처리에 실패하였습니다.");
            return;
        }
        data.put("resultMsg", URLDecoder.decode(data.getString("resultMsg"), "UTF-8"));

        bankCertLogDao = new DataObject("tcb_bank_cert_log");
        bankCertLogDao.item("res_data", data.toString());
        bankCertLogDao.item("status", "10");
        if(!bankCertLogDao.update("message_no = '"+messageNo+"' and req_gubun = '10' ")){
            u.jsError("통신정보 저장 처리에 실패 하였습니다.");
            return;
        }

        if(!data.getString("resultCd").equals("0000")){
            u.jsError("인증진행에 실패 하였습니다.\\n\\n(Message: "+data.getString("resultMsg")+")");
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
        hp.setEncoding("UTF-8");
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
            u.jsError("통신정보 저장 처리에 실패 하였습니다.");
            return;
        }

        String ret = hp.sendHTTPS();
        if (ret.equals("")) {
            u.jsError("통신 처리에 실패하였습니다.");
            return;
        }
        u.sp(ret);


        DataSet data = u.json2Dataset(ret.substring(ret.indexOf("{"), ret.length() - 1));
        if (!data.next()) {
            u.jsError("통신 처리에 실패하였습니다.");
            return;
        }
        data.put("resultMsg", URLDecoder.decode(data.getString("resultMsg"), "UTF-8"));


        bankCertLogDao = new DataObject("tcb_bank_cert_log");
        bankCertLogDao.item("res_data", data.toString());
        bankCertLogDao.item("status", "10");
        if(!bankCertLogDao.update( " message_no = '"+messageNo+"'  and req_gubun = '20' ")){
            u.jsError("통신정보 저장 처리에 실패 하였습니다.");//실패이력 남기기
            return;
        }

        if(!data.getString("resultCd").equals("0000")){
            u.jsErrClose("인증진행에 실패 하였습니다.\\n\\n(Message: "+data.getString("resultMsg")+")");
            return;
        }

        out.println("<script>");
        out.println("var data = { 'bank_name' : '"+f.get("c_bankname")+"' , 'bank_no' : '"+f.get("c_bankno")+"', 'bank_user' : '"+f.get("c_bankuser")+"' , 'message_no': '"+messageNo+"' };");
        out.println("opener."+callback+"(data);");
        out.println("alert('정상적으로 계좌인증 처리 되었습니다.');");
        out.println("self.close();");
        out.println("</script>");
        return;
    }
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_bank_valid");
p.setVar("popup_title","계좌인증");
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
     * Byte 자를때 유니코드 중간에서 잘라야 하는 경우 쓰레기값 제거해서 반환.
     * @param inputB 원래 문자열바이트
     * @param length 자리수
     * @return byte[] 자르고 난 문자열바이트
     * 페이먼츠 도성진에게 제공 받음.
     */
    public byte[] unicodeCut(byte[] inputB, int length) {
        boolean boo_middle_cut = false;
        int unicodeSize = 0;
        for (int i=0;i<length;i++) {
            if (inputB[i] < 0x00) unicodeSize++;
        } // end for
        if (unicodeSize%2 == 1) boo_middle_cut = true;

        // 유니코드 가운데서 잘리는 경우
        if (boo_middle_cut) return new String(inputB, 0, length-1).getBytes();
            // 유니코드가 아님. 그냥 자를수 있음.
        else return new String(inputB, 0, length).getBytes();
    }

%>