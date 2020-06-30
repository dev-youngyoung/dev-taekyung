<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@page import="procure.common.file.MakeZip"%>
<%@ page import="org.jsoup.*" %>
<%@ page import="org.jsoup.nodes.*" %>
<%@ page import="org.jsoup.select.*" %>
<%
String _menu_cd = "000060";

CodeDao code = new CodeDao("tcb_comcode");
String[] code_status = code.getCodeArray("M008", " and code in ('11','12','20','21','30','40','41')");


boolean isKTH = u.inArray(_member_no, new String[]{"20150500312","20171100802"}); // w����, NICE�������(�ŷ�ó�ڵ�ǥ��)
boolean isSKB = _member_no.equals("20171101813"); // sk��ε���   20120100001
boolean isCJT = u.inArray(_member_no, new String[]{"20130400333"}); // CJ�������
boolean isPersonView = u.inArray(_member_no, new String[]{"20130500619","20121200734"}); // ������/ ��������
boolean isNicednr = _member_no.equals("20151100446");
boolean isPbpartners = _member_no.equals("20180100028"); //(��)�Ǻ���Ʈ���� 

boolean bDetailCode = false;
String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu";
String sColumn = "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date, a.status, a.cont_userno, b.member_no, b.member_name, b.cust_detail_code,b.boss_name,a.sign_types,"
				 +"(select agree_person_name from tcb_cont_agree where cont_no = a.cont_no and cont_chasu=a.cont_chasu and agree_seq = "
			     +"      (select min(agree_seq) from tcb_cont_agree where cont_no = a.cont_no and cont_chasu=a.cont_chasu and agree_cd=2 and r_agree_person_id is null) ) agree_name,"
				 +"( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt ";

if(isCJT)
{
	String[] code_cj_division = {"CL1=>CL1","CL2=>CL2","�ؿ��׸�=>�ؿ��׸�","������=>������","����=>����","�ù�=>�ù�"};
	DataObject fieldDao = new DataObject("tcb_field");
	DataSet field = fieldDao.find(" status > 0 and member_no = '"+_member_no+"'" );
	p.setVar("isCJT", isCJT);
	p.setLoop("code_field", field);
	p.setLoop("code_cj_division", u.arr2loop(code_cj_division));
	p.setVar("isDefaultYn", auth.getString("_DEFAULT_YN").equals("Y"));

	f.addElement("s_division", null, null);
	f.addElement("s_field_seq", null, null);
}

if(	_member_no.equals("20121000046") )
	bDetailCode = true;  // �ŷ�ó �ڵ� ǥ�� (��: �ķ�ƮǮ)

f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_vendcd",null, null);
f.addElement("s_status", null, null);
f.addElement("s_template_cd", null, null);

if(	_member_no.equals("20121000046")){
	f.addElement("s_cust_detail_code",null, null);
	f.addElement("s_user_name",null, null);
}
if(isKTH){
	f.addElement("s_cust_detail_code",null, null);
	f.addElement("s_user_name",null, null);
}else if(isPersonView){
	f.addElement("s_user_name",null, null);
}


if(bDetailCode||isKTH||isPersonView)
{
	sTable += " inner join tcb_cust c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu and a.member_no = c.member_no";
	sColumn += ", c.user_name reg_name";
}

if(u.request("mode").equals("excel")){
	sColumn += ", a.cont_total, a.true_random, a.cont_sdate, a.cont_edate, b.user_name, b.vendcd, b.tel_num, b.hp1, b.hp2, b.hp3, b.email, b.address, b.post_code";

	if(isSKB){
		sColumn += ", a.cont_html";
	}
	if(isNicednr){
		sTable += " left outer join tcb_cont_add c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu ";
		sColumn += ", c.add_col1, c.add_col2, c.add_col3";
	}
	if(isPbpartners){ 
		sColumn += ", (select display_name from tcb_cont_template where template_cd = a.template_cd ) as template_name";
	}
}

//��� ����
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel"})?-1:15);
list.setTable(sTable);
list.setFields(sColumn);
list.addWhere("b.list_cust_yn = 'Y'");
list.addWhere(" a.member_no = '"+_member_no+"' ");
// �Ѽ���ũ������ ������ ����, ���ٷ� å�� �ܿ� �����ڶ� ������༭ ��ȸ ����
if(_member_no.equals("20130300071") && !u.inArray(auth.getString("_USER_ID"), new String[]{"jhyoon","drsong"}) ) { 
	list.addWhere("nvl(a.template_cd,'0') not in ('2017021','2017023','2017024','2017025','2017048','2017082','2017083','2017100','2018035')");
}


list.addWhere(" a.status in ('11','12','20','21','30','40','41')");
list.addWhere(" a.subscription_yn is null");//��û�� ����


if(bDetailCode||isKTH)
{
	list.addSearch("b.cust_detail_code", f.get("s_cust_detail_code"), "=");
	list.addSearch("c.user_name", f.get("s_user_name"), "LIKE");
} else if(isPersonView) {
	list.addSearch("c.user_name", f.get("s_user_name"), "LIKE");
}
list.addSearch("a.status",  f.get("s_status"));
//list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
if(!f.get("s_cont_name").equals("")){// Ƽ�˿� ��ҹ��� ���� ���� �˻� 2020-02-12
	list.addWhere(" lower(a.cont_name) like  '%'||lower('"+f.get("s_cont_name")+"')||'%'");
}
list.addSearch("a.cont_userno",  f.get("s_cust_userno"), "LIKE");
list.addSearch("b.member_name",  f.get("s_cust_name"), "LIKE");
list.addSearch("b.vendcd",  f.get("s_vendcd").replaceAll("-", ""), "LIKE");

if(f.get("s_template_cd").equals("9999999")) { // ��������
	list.addWhere("a.template_cd is null");
} else {
	list.addSearch("a.template_cd", f.get("s_template_cd"));
}

list.addSearch("a.cont_etc1",  f.get("s_division"));  // CJ�������
list.addSearch("a.field_seq",  f.get("s_field_seq")); // CJ�������
/*��ȸ����*/
if(!auth.getString("_DEFAULT_YN").equals("Y")){
	//10:�����ȸ  20:�μ���ȸ 
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("10")){
		list.addWhere("(  "
			+"     a.agree_person_ids like '%"+auth.getString("_USER_ID")+"|%' "
		    +"  or a.reg_id = '"+auth.getString("_USER_ID")+"' "
		    +"  or a.field_seq in (select field_seq from tcb_auth_field where member_no = '"+_member_no+"' and auth_cd = '"+auth.getString("_AUTH_CD")+"' and menu_cd = '"+_menu_cd+"') "
		    +"           ) "); 
	}
	if(_authDao.getAuthMenuInfoB(_member_no,auth.getString("_AUTH_CD"),_menu_cd,"select_auth").equals("20")){
		list.addWhere(" (  "
			+"     a.agree_field_seqs like '%|"+auth.getString("_FIELD_SEQ")+"|%' "
			+"  or a.agree_person_ids like '%"+auth.getString("_USER_ID")+"|%' " // ���� ���� ��ȸ ������ �ο��� ���� ���� �켱 �Ѵ�.
			+"  or a.field_seq in ( select field_seq from tcb_field start with member_no = '"+_member_no+"' and field_seq = '" + auth.getString("_FIELD_SEQ") + "' connect by prior member_no = member_no and prior field_seq = p_field_seq ) " 
			+"  or a.field_seq in (select field_seq from tcb_auth_field where member_no = '"+_member_no+"' and auth_cd = '"+auth.getString("_AUTH_CD")+"' and menu_cd = '"+_menu_cd+"') " 
			+"          ) ");
	}
}
list.setOrderBy("a.cont_no desc");

DataSet ds = list.getDataSet();
while(ds.next()){
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if(ds.getInt("cust_cnt")-2>0){
		ds.put("cust_name", ds.getString("member_name")+ "��"+(ds.getInt("cust_cnt")-2)+"����");
	}else{
		ds.put("cust_name", ds.getString("member_name"));
	}

	if((bDetailCode||isKTH)&&ds.getString("cust_detail_code").equals(""))
		ds.put("cust_detail_code", "<font color='red'>[�̵��]</font>");

	ds.put("link", ds.getString("template_cd").equals("")?"contract_free_sendview.jsp":ds.getString("sign_types").equals("")?"contract_sendview.jsp":"contract_msign_sendview.jsp");
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("cont_sdate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_sdate")));
	ds.put("cont_edate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_edate")));
	if(ds.getString("status").equals("30")){//������ �����̸� ���� ǥ��
		ds.put("status_name", "<span class=\"caution-text\">"+u.getItem(ds.getString("status"), code_status)+"</span>");
	}else if(ds.getString("status").equals("12")) {  // ���ιݷ�
		ds.put("status_name", "<span style='color:red'>"+u.getItem(ds.getString("status"), code_status)+"</span>");
	}else if(ds.getString("status").equals("21")) {  // ���δ��
		ds.put("status_name", "<span class=\"caution-text\">"+u.getItem(ds.getString("status"), code_status)+"<br>("+ds.getString("agree_name")+")</span>");
	}else if(ds.getString("status").equals("40")){//������û �����̸� ���� ǥ��
		ds.put("status_name", "<span style='color:blue'>"+u.getItem(ds.getString("status"), code_status)+"</span>");
	}else{
		ds.put("status_name", u.getItem(ds.getString("status"), code_status));
	}
}

if(u.request("mode").equals("excel")){
	p.setVar("isSKB", isSKB); // sk��ε���
	p.setVar("isPersonView", isPersonView);
	p.setVar("isNicednr", isNicednr);
	p.setVar("isPbpartners", isPbpartners);
	p.setVar("title", "������ �����Ȳ");
	String xlsFile = "contract_send_list_excel.html";

	ds.first();
	while(ds.next()){
		ds.put("cont_total", u.numberFormat(ds.getDouble("cont_total"), 0));
		ds.put("status_name", ds.getString("status_name").replaceAll("<br>", ""));
		if(isSKB)
		{
			if(u.inArray(ds.getString("template_cd"), new String[]{"2015002","2017101"}))  //������༭(����Ź)
			{
				Document document = Jsoup.parse(ds.getString("cont_html"));
				String cust_code = getJsoupValue(document,"t1");  // ��ü�ڵ�
				String item_code = getJsoupValue(document,"t2");  // ��ǰ�ڵ�
				String item_name = getJsoupValue(document,"t3");  // ��ǰ��
				String item_sale = getJsoupValue(document,"t4");  // �ǸŰ�
				String move_type = getJsoupValue(document,"t5");  // �������
				String move_limit = getJsoupValue(document,"t6");  // ��۱Ⱓ

				// ��4��. �������
				String item_code1 = getJsoupValue(document,"t24");  // ��ǰ�ڵ�
				String item_charge = getJsoupValue(document,"t28");  // �Ǹż�����

				// ��5�� ���θ�� ����
				String item_code2 = getJsoupValue(document,"t30");  // ��ǰ�ڵ�
				String sale_type = getJsoupValue(document,"t31");  // �뵵
				String pay_cust = getJsoupValue(document,"t33");  // ���δ� ���»�
				String pay_bshop = getJsoupValue(document,"t34");  // ���δ� B shopping

				ds.put("cust_code", cust_code);
				ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
				ds.put("item_code", item_code);
				ds.put("item_name", item_name);
				ds.put("item_sale", item_sale);
				ds.put("move_type", move_type);
				ds.put("move_limit", move_limit);

				ds.put("item_code1", item_code1);
				ds.put("item_charge", item_charge);

				ds.put("item_code2", item_code2);
				ds.put("sale_type", sale_type);
				ds.put("pay_cust", pay_cust);
				ds.put("pay_bshop", pay_bshop);
				ds.put("cont_userno", u.aseDec(ds.getString("cont_no")));
			}
			else if(ds.getString("template_cd").equals("2015001"))  //ǥ�ذŷ����
			{
				Document document = Jsoup.parse(ds.getString("cont_html"));
				String cust_code = getJsoupValue(document,"cust_code");  // ��ü�ڵ�
				ds.put("cust_code", cust_code);
				ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
				ds.put("cont_userno", u.aseDec(ds.getString("cont_no")));
			}
			else if(f.get("s_template_cd").equals("2015016"))  //û����2�� �˻��� ���
			{
				Document document = Jsoup.parse(ds.getString("cont_html"));
				String cust_code = getJsoupValue(document,"cust_code");  // ��ü�ڵ�
				String req_month = getJsoupValue(document,"req_month");  // û����
				String req_count = getJsoupValue(document,"req_count");  // û������
				String cont_total_str = getJsoupValue(document,"cont_total");  // û������


				ds.put("cont_total", cont_total_str);
				ds.put("cust_code", cust_code);
				ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
				ds.put("req_month", req_month);
				ds.put("req_count", req_count);
				ds.put("cont_no", u.aseDec(ds.getString("cont_no")));
				xlsFile = "contract_send_list_excel_2015016.html";
			}
			else
			{
				ds.put("cust_code", "");
				ds.put("item_code", "");
				ds.put("item_name", "");
				ds.put("item_sale", "");
			}

		}

		
	}


	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("������ �����Ȳ.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/"+xlsFile));
	return;
}
else if(u.request("mode").equals("down")){
	String[] save = f.getArr("save");
	if(save==null) return;

	String file_path = "";
	String cont_chasu = "";

	DataSet files = new DataSet();
	DataObject cfileDao = new DataObject("tcb_cfile a inner join tcb_contmaster b on a.cont_no=b.cont_no and a.cont_chasu=b.cont_chasu");

	for(int i=0; i < save.length; i ++){
		String[] arrCont = save[i].split("_");

		DataSet dsCfile = cfileDao.find("a.cont_no = '"+u.aseDec(arrCont[0])+"' and a.cont_chasu="+arrCont[1], "b.cont_name, a.file_path, a.file_name, a.doc_name, a.file_ext");
		while(dsCfile.next())
		{
			files.addRow();
			files.put("file_path",Startup.conf.getString("file.path.bcont_pdf")+dsCfile.getString("file_path")+dsCfile.getString("file_name"));
			//files.put("doc_name", "["+dsCfile.getString("member_name") + "] " + dsCfile.getString("doc_name") + "." + dsCfile.getString("file_ext"));
			files.put("doc_name", dsCfile.getString("cont_name") + "." + dsCfile.getString("file_ext"));
		}
	}

	MakeZip mk = new MakeZip();
	mk.make(files, response);

	return;
}

DataObject templateDao = new DataObject();
DataSet template = templateDao.query("select nvl(display_name, template_name) template_name, template_cd from tcb_cont_template where template_cd in (select decode(template_cd, '', '9999999', template_cd) template_cd from tcb_contmaster where member_no = '"+_member_no+"' and status in ('11','20','21','30','40','41') group by template_cd) order by display_seq asc, template_cd desc");



p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_send_list");
p.setVar("menu_cd", _menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setLoop("template", template);
p.setVar("isSKB", isSKB);
p.setVar("isPersonView", isPersonView);
p.setVar("detail_cd", bDetailCode );   // �ķ�Ʈ���� ����� �������� ǥ��
p.setVar("isKTH",isKTH);  //KTH �ŷ�ó �ڵ� ǥ��
p.setVar("btn_pop_msign_resend", u.inArray(_member_no, new String[]{"20190600690","20151100446"}));//�ϰ� ������ �˾� ���̽���ؾ�, ����� û���
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>
<%!
public String getJsoupValue(Document document, String name){
	String value = "";
	Elements elements = document.getElementsByAttributeValue("name", name);
	int i=0;

	for(Element element: elements){
		if(i > 0) value += "<br>";
		if(element.nodeName().equals("textarea"))
		{
			value += element.text();
		}
		else
		{
			value += element.attr("value");
		}
		i++;
	}
	return value;
}
%>