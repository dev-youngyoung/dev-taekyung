<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
f.addElement("c_bankname", null, "hname:'�����', required:'Y'");
f.addElement("c_bankno", null, "hname:'���¹�ȣ', required:'Y'");

if(u.isPost()&&f.validate())
{
    String[] bankCode = {"�ѱ�����=>001","�������=>002","�������=>003","��������=>004","��������=>007","����������=>008","��������=>011","���� ������=>012","�츮����=>020","SC��������=>023","�ѱ���Ƽ����=>027","�뱸����=>031","�λ�����=>032","��������=>034","��������=>035","��������=>037","�泲����=>039","�������ݰ��߾�ȸ=>045","����=>048","��������=>050","��Ÿ �ܱ�������=>051","��ǽ��ĸ�����=>052","HSBC����=>054","����ġ����=>055","�����Ǹ�ü�̽�����=>057","����ȣ����=>058","��������������=>059","BOA����=>060","�����ĸ�����=>061","�߱���������=>062","�߱�����=>063","�긲�����߾�ȸ=>064","��ȭ����=>065","��������=>066","�߱��Ǽ�����=>067","��ü��=>071","�ſ뺸�����=>076","����������=>077","KEB�ϳ�����=>081","��������=>088","���̹�ũ=>089","īī����ũ=>090","����û=>091","�ѱ����ñ�������=>093","���ﺸ������=>094","����û=>095","�ѱ����ڱ�����=>096","����������=>099","�ѱ��ſ�������=>101","�����������=>102","�����������������=>103","����ġ������������=>104","������������=>105","����Ÿ����(�������ձ�������)=>209","KB����=>218","���긴����������=>221","�Ѿ�����=>222","������������=>223","BNK��������=>224","IBK��������=>225","KTB��������=>227","�̷����´��=>238","�Ｚ����=>240","�ѱ���������=>243","NH��������=>247","��������=>261","������������=>262","����������=>263","Ű������=>264","�̺���Ʈ��������=>265","SK����=>266","�������=>267","��ȭ��������=>269","�ϳ���������=>270","���ѱ�������=>278","DB��������=>279","������������=>280","�޸������ձ�������=>287","NH��������=>289","�α�����=>290","�ſ�����=>291","��������������=>292","�ѱ����Ǳ���=>293","�ݵ�¶����ڸ���=>294","�츮���ձ���=>295","����ĳ��Ż=>299"};

    Http hp = new Http();
    hp.setEncoding("euc-kr");
    hp.setUrl("https://web.nicepay.co.kr/api/checkBankAccountAPI.jsp");
    hp.setParam("mid", "nicedocu1m");
    hp.setParam("merchantKey", "Q1h4Zo1gtPrDVGU/6kWxb/4j0oCIAaYJAO35vM/huB4FLWOszTRVTSdxG64kat2QC4qhcpp9zOXTW03xbsovwA==");
    hp.setParam("inAccount", f.get("c_bankno"));

    System.out.println("bankName : " + f.get("c_bankname"));
    System.out.println("bankCode : " + u.getItem(f.get("c_bankname"), bankCode));

    hp.setParam("inBankCode", u.getItem(f.get("c_bankname"), bankCode));
    String ret = hp.sendHTTPS();
    // ������ : PG=NICE|respCode=0000|errMsg=����ó��|receiverName=������|NICE=PG|RegDate=20171025
    // ���н� : PG=NICE|respCode=V454|errMsg=�ش���¿���|receiverName=|NICE=PG|RegDate=20171025

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
        u.jsError("���� ������ �ùٸ��� �ʽ��ϴ�.["+retBank.getString("errMsg")+"]");
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
p.setVar("popup_title","����Ȯ��");
p.setVar("form_script",f.getScript());
p.display(out);
%>