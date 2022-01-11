<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%
f.addElement("c_bankname", null, "hname:'은행명', required:'Y'");
f.addElement("c_bankno", null, "hname:'계좌번호', required:'Y'");

if(u.isPost()&&f.validate())
{
    String[] bankCode = {"한국은행=>001","산업은행=>002","기업은행=>003","국민은행=>004","수협은행=>007","수출입은행=>008","농협은행=>011","지역 농축협=>012","우리은행=>020","SC제일은행=>023","한국씨티은행=>027","대구은행=>031","부산은행=>032","광주은행=>034","제주은행=>035","전북은행=>037","경남은행=>039","새마을금고중앙회=>045","신협=>048","저축은행=>050","기타 외국계은행=>051","모건스탠리은행=>052","HSBC은행=>054","도이치은행=>055","제이피모간체이스은행=>057","미즈호은행=>058","엠유에프지은행=>059","BOA은행=>060","비엔피파리은행=>061","중국공상은행=>062","중국은행=>063","산림조합중앙회=>064","대화은행=>065","교통은행=>066","중국건설은행=>067","우체국=>071","신용보증기금=>076","기술보증기금=>077","KEB하나은행=>081","신한은행=>088","케이뱅크=>089","카카오뱅크=>090","국세청=>091","한국주택금융공사=>093","서울보증보험=>094","경찰청=>095","한국전자금융㈜=>096","금융결제원=>099","한국신용정보원=>101","대신저축은행=>102","에스비아이저축은행=>103","에이치케이저축은행=>104","웰컴저축은행=>105","유안타증권(동양종합금융증권)=>209","KB증권=>218","골든브릿지투자증권=>221","한양증권=>222","리딩투자증권=>223","BNK투자증권=>224","IBK투자증권=>225","KTB투자증권=>227","미래에셋대우=>238","삼성증권=>240","한국투자증권=>243","NH투자증권=>247","교보증권=>261","하이투자증권=>262","현대차증권=>263","키움증권=>264","이베스트투자증권=>265","SK증권=>266","대신증권=>267","한화투자증권=>269","하나금융투자=>270","신한금융투자=>278","DB금융투자=>279","유진투자증권=>280","메리츠종합금융증권=>287","NH투자증권=>289","부국증권=>290","신영증권=>291","케이프투자증권=>292","한국증권금융=>293","펀드온라인코리아=>294","우리종합금융=>295","아주캐피탈=>299"};

    Http hp = new Http();
    hp.setEncoding("UTF-8");
    hp.setUrl("https://web.nicepay.co.kr/api/checkBankAccountAPI.jsp");
    hp.setParam("mid", "nicedocu1m");
    hp.setParam("merchantKey", "Q1h4Zo1gtPrDVGU/6kWxb/4j0oCIAaYJAO35vM/huB4FLWOszTRVTSdxG64kat2QC4qhcpp9zOXTW03xbsovwA==");
    hp.setParam("inAccount", f.get("c_bankno"));

    System.out.println("bankName : " + f.get("c_bankname"));
    System.out.println("bankCode : " + u.getItem(f.get("c_bankname"), bankCode));

    hp.setParam("inBankCode", u.getItem(f.get("c_bankname"), bankCode));
    String ret = hp.sendHTTPS();
    // 성공시 : PG=NICE|respCode=0000|errMsg=정상처리|receiverName=유성훈|NICE=PG|RegDate=20171025
    // 실패시 : PG=NICE|respCode=V454|errMsg=해당계좌오류|receiverName=|NICE=PG|RegDate=20171025

    String[] retArr = ret.split("\\|");
    DataSet retBank = new DataSet();
    retBank.addRow();
    for(int i=0; i<retArr.length; i++) {
        String[] tmp = retArr[i].split("=");
        retBank.put(tmp[0], tmp.length==2 ? tmp[1] : "");
    }
    System.out.println("[respCode]"+retBank.getString("respCode"));
    System.out.println("[receiverName]"+retBank.getString("receiverName"));

    if(!retBank.getString("respCode").equals("0000")) {
        u.jsError("계좌 정보가 올바르지 않습니다.["+retBank.getString("errMsg")+"]");
        return;
    }

    out.print("<script>");
    out.println("if(opener!=null){");
    out.println("var arr = new Array('"+f.get("c_bankname")+"', '"+f.get("c_bankno")+"','"+retBank.getString("receiverName")+"');");
    out.println("opener.setBank(arr);");
    out.println("}");
    out.println("window.close();");
    out.print("</script>");
}


p.setLayout("subscription");
//p.setDebug(out);
p.setBody("contract.pop_bank_c");
p.setVar("popup_title","계좌확인");
p.setVar("form_script",f.getScript());
p.display(out);
%>