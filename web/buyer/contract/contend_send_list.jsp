<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.Jsoup"%>
<%@ page import="org.jsoup.nodes.Document" %>
<%@ page import="org.jsoup.nodes.Element" %>
<%@ page import="org.jsoup.select.Elements" %>
<%@ page import="procure.common.file.MakeZip" %>
<%
String _menu_cd = "000063";

boolean isDongheeGroup = u.inArray(_member_no, new String[]{"20130300068","20130300064","20130300063","20130300062","20130300061","20130300060","20130300059","20130300058","20130300057","20121203399","20121202637","20121200067","20130700100"});
boolean isPersonView = u.inArray(_member_no, new String[]{"20130700108","20130500619","20130400333","20181201176"}); // ������ũ, ������, CJ�������, īī��Ŀ�ӽ�  
boolean is3M= u.inArray(_member_no, new String[]{"20121203661","20130400010","20130400009","20130400011","20130400008"});
boolean isSKB = _member_no.equals("20171101813")?true:false;
boolean isOlive = _member_no.equals("20150500217")?true:false;
boolean isKTH = u.inArray(_member_no, new String[]{"20150500312","20171100802"}); // w����, NICE�������(�ŷ�ó�ڵ�ǥ��)
boolean isCJT = u.inArray(_member_no, new String[]{"20130400333"}); // CJ�������
boolean isNH = _member_no.equals("20151101243");//NH����
boolean isLGH = _member_no.equals("20160401012");//��ũ�ν� ���;ؿ�����
boolean isTES = _member_no.equals("20180203437");//��ũ�ν� ȯ�漭��
boolean bviewContNo = u.inArray(_member_no, new String[]{"20160900378"}); // �Ҵ��ڸ���
boolean view_status = u.inArray(_member_no, new String[]{"20130500619","20150500312"}); // ������, w����
boolean isGenie = _member_no.equals("20190300995"); // ���Ϲ���
boolean isNicednr = _member_no.equals("20151100446");
boolean isWoowahan = _member_no.equals("20190600690"); // �����û���
boolean isDwst =  _member_no.equals("20160601552"); 
boolean isNHhanaro =  _member_no.equals("20121200734"); //�������� 
boolean bIsKakao = u.inArray(_member_no, new String[]{"20130900194","20181201176"}); // īī�� 
boolean isPbpartners = _member_no.equals("20180100028"); //(��)�Ǻ���Ʈ���� 


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

DataObject memberDao = new DataObject("tcb_member");
//memberDao.setDebug(out);
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("����� ������ �������� �ʽ��ϴ�.");
	return;
}

boolean src_l = false;
boolean src_m = false;
boolean src_s = false;
if(member.getString("src_depth").equals("01")){
	src_l = true;
}
if(member.getString("src_depth").equals("02")){
	src_l = true;
	src_m = true;
}
if(member.getString("src_depth").equals("03")){
	src_l = true;
	src_m = true;
	src_s = true;
}



CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008", "and code in ('50','91','99')");
String[] code_bid_method = null;
String[] code_succ_method = null;
String[] code_vat_type = {"1=>VAT����","2=>VAT����","3=>VAT�̼���"}; //�������� VAT����
if(isNH){
	code_bid_method = codeDao.getCodeArray("M023");
	code_succ_method = codeDao.getCodeArray("M024");
}



boolean bDetailCode = false;

String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu and a.paper_yn is null";
//String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu";

String sColumn = "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date,a.cont_sdate, a.cont_edate, a.cont_total, a.status, a.cont_userno, a.cont_etc1, a.cont_etc2, b.member_no, b.member_name, b.vendcd, b.boss_name, b.cust_detail_code, a.true_random, a.sign_types, "
				+"( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt  ";


if(	_member_no.equals("20121000046"))
	bDetailCode = true;  // �ŷ�ó �ڵ� ǥ�� (��: �ķ�ƮǮ)


String s_sdate = u.request("s_sdate",is3M && auth.getString("_FIELD_SEQ").equals("2") ? "2013-07-01" : u.getTimeString("yyyy-MM-dd",u.addDate("M",-3)));
String s_edate = u.request("s_edate");

f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name",null, null);
f.addElement("s_vendcd",null, null);
f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_manage_no", null, null);
f.addElement("s_user_no", null, null);
f.addElement("s_template_cd", null, null);

if(	_member_no.equals("20121000046")){
	f.addElement("s_cust_detail_code",null, null);
	f.addElement("s_user_name",null, null);
}
if(isKTH){
	f.addElement("s_cust_detail_code",null, null);
	f.addElement("s_user_name",null, null);
}
if(isPersonView||isNHhanaro){
	f.addElement("s_user_name",null, null);
}
if(isCJT){
	f.addElement("s_boss_name",null, null);
}
if(isLGH){
	f.addElement("s_project_cd",null, null); 
} 
f.addElement("hdn_sort_column", null, null);
f.addElement("hdn_sort_order", null, null);
if(view_status){
	f.addElement("s_status", null, null);
}


if(bDetailCode||isKTH||isPersonView||isOlive||isNHhanaro||isTES)
{
	sTable += " inner join tcb_cust c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu and a.member_no = c.member_no";
	sColumn += ", c.user_name";
}

if(isLGH){
	sTable += " inner join tcb_cust c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu and a.member_no = c.member_no"
	         +" left outer join tcb_project d on a.project_seq = d.project_seq and a.member_no = d.member_no "; 
	sColumn += " , c.user_name , d.project_name, d.project_cd" ;
}


if(u.request("mode").equals("excel"))
{
	if(is3M){
		sTable +=" inner join tcb_cust c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu and a.member_no = c.member_no"
				+" left join tcb_cont_sub d on a.cont_no = d.cont_no and a.cont_chasu = d.cont_chasu and d.sub_seq=1";
		sColumn +=", c.user_name" 
				+",(select src_nm from tcb_src_adm where member_no = a.member_no and substr(src_cd,0,3) = substr(a.src_cd,0,3) and depth='1') l_src_nm,"
				+"(select src_nm from tcb_src_adm where member_no = a.member_no and substr(src_cd,0,6) = substr(a.src_cd,0,6) and depth='2') m_src_nm,"
				+"(select src_nm from tcb_src_adm where member_no = a.member_no and src_cd = a.src_cd and depth='3') s_src_nm,"
				+"substr(b.sign_date,0,8) cust_sign_date, (select substr(sign_date,0,8) from tcb_cust where cont_no=a.cont_no and cont_chasu=a.cont_chasu and member_no=a.member_no) org_sign_date,"
				+"case when cont_edate-to_char(sysdate,'YYYYMMDD') > 0 then 'Active' when cont_edate is null then 'Active' else 'Inactive' end as valid_cont,"
				+"d.cont_sub_html sub_html, a.cont_html";
	}
	
	if(isLGH){
		sTable += " inner join tcb_cust c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu and a.member_no = c.member_no"
		         +" left outer join tcb_project d on a.project_seq = d.project_seq and a.member_no = d.member_no "; 
		sColumn += ", nvl(a.cont_total ,(nvl(a.supp_tax,0) + nvl(a.supp_vat,0))) as cont_total, c.user_name , d.project_name, d.project_cd" ;
	}
	if(isTES){
		sTable += " inner join tcb_cust c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu and a.member_no = c.member_no";
		sColumn += ", c.user_name";
	}

	if(isGenie){
		sTable += " inner join tcb_person c on c.member_no = a.member_no and c.user_id = a.reg_id  ";
		sColumn +=
				 ", substr(b.sign_date,0,8) cust_sign_date"
				+", (select substr(sign_date,0,8) from tcb_cust where cont_no=a.cont_no and cont_chasu=a.cont_chasu and member_no=a.member_no) as org_sign_date "
				+", c.user_name reg_name "
				+", (select field_name from tcb_field where member_no = c.member_no and field_seq = c.field_seq ) field_name ";
	}
	
	if(isSKB){
		sColumn += ", b.user_name, b.tel_num, b.hp1, b.hp2, b.hp3, b.email, b.address, b.post_code, a.cont_html";
	}
	
	if(isWoowahan)
	{ 
		sTable +=" inner join tcb_cust c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu and a.member_no != c.member_no" 
				 +" left outer join tcb_cont_add d on a.cont_no = d.cont_no and a.cont_chasu = d.cont_chasu "; 
		sColumn += ", b.user_name, b.tel_num, b.hp1, b.hp2, b.hp3, b.email, b.address, b.post_code , c.boss_birth_date  ,d.add_col1 ,d.add_col2 ,d.add_col3 ,d.add_col4,d.add_col5  ";
	}
	 
	if(isOlive && f.get("s_template_cd").equals("2015059")){  // ��ǰȮ�μ���
		sColumn += ", a.cont_html";
	}
	
	if(f.get("s_template_cd").equals("2015038")){  // ���������� ��ǰ�Ǹ�(����)��༭
		sColumn += ", a.cont_html";
	}
	
	if(isNH){
		sTable += " inner join tcb_person c on c.member_no = a.member_no and c.user_id = a.reg_id  ";
		sColumn +=   (", b.address "
				    +", b.tel_num "
				    +", b.user_name "
				    +", b.hp1, b.hp2, b.hp3 " 
				    +", c.user_name reg_name "
				    +", (select field_name from tcb_field where member_no = c.member_no and field_seq = c.field_seq ) field_name "
				    +", (select bid_method from tcb_bid_master where main_member_no = a.member_no and bid_no = a.bid_no and bid_deg = a.bid_deg ) bid_method "
				    +", (select succ_method from tcb_bid_master where main_member_no = a.member_no and bid_no = a.bid_no and bid_deg = a.bid_deg ) succ_method " );
	}

	if(isNicednr){
		sTable += " left outer join tcb_cont_add c on a.cont_no = c.cont_no and a.cont_chasu = c.cont_chasu ";
		sColumn += ", c.add_col1, c.add_col2, c.add_col3";
	}

	if(isDwst){
		sColumn += ", a.supp_tax, a.supp_vat, b.sign_date cust2_sign_date, (select sign_date from tcb_cust where cont_no = a.cont_no and cont_chasu = b.cont_chasu and member_no = a.member_no) cust1_sign_date ";
	}
	
	if(isNHhanaro){
		sColumn += ", b.sign_date cust2_sign_date, (select sign_date from tcb_cust where cont_no = a.cont_no and cont_chasu = b.cont_chasu and member_no = a.member_no) cust1_sign_date ";
	} 
	
	if(isPbpartners){ 
		sColumn += ", (select display_name from tcb_cont_template where template_cd = a.template_cd ) as template_name";
	}
	
}

if(u.request("mode").equals("report"))
{
	if(isDongheeGroup)
	{
		sColumn += ", a.cont_html";
	}
}


//��� ����
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(u.inArray(u.request("mode"), new String[]{"excel","report"})?-1:15);
list.setTable(sTable);
list.setFields(sColumn);
list.addWhere("b.list_cust_yn = 'Y'");

list.addWhere(" a.member_no = '"+_member_no+"' ");

// �Ѽ���ũ������ �۴ٷ� ����, ���ٷ� å�� �ܿ� �����ڶ� ������༭ ��ȸ ����
if(_member_no.equals("20130300071") && !u.inArray(auth.getString("_USER_ID"), new String[]{"jhyoon","drsong"}) ) { 
	list.addWhere("nvl(a.template_cd,'0') not in ('2017021','2017023','2017024','2017025','2017048','2017082','2017083','2017100','2018035')");
}


list.addWhere(" a.status in ('50','91','99')");//50:�Ϸ�� ��� 91:�������, 99:������
list.addWhere(" a.subscription_yn is null");//��û�� ����


String s_date_query = "";
if(!s_sdate.equals("")) {
	list.addWhere(" a.cont_date >= '"+s_sdate.replaceAll("-","")+"'");
	s_date_query = " and cont_date >= '"+s_sdate.replaceAll("-","")+"'";
}
if(!s_edate.equals("")) {
	list.addWhere(" a.cont_date <= '"+s_edate.replaceAll("-","")+"'");
	s_date_query += " and cont_date <= '"+s_edate.replaceAll("-","")+"'";
}
if((!f.get("l_src_cd").equals(""))||(!f.get("m_src_cd").equals(""))||(!f.get("s_src_cd").equals(""))){
	list.addWhere(" a.src_cd like '"+f.get("l_src_cd")+f.get("m_src_cd")+f.get("s_src_cd")+"%' ");
}

if(bDetailCode||isKTH||isPersonView||isNHhanaro)
{
	list.addSearch("b.cust_detail_code", f.get("s_cust_detail_code"), "=");
	list.addSearch("c.user_name", f.get("s_user_name"), "LIKE");
}

if(isCJT){
	list.addSearch("b.boss_name", f.get("s_boss_name"), "LIKE");
}

//list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
if(!f.get("s_cont_name").equals("")){// Ƽ�˿� ��ҹ��� ���� ���� �˻� 2020-02-12
	list.addWhere(" lower(a.cont_name) like  '%'||lower('"+f.get("s_cont_name")+"')||'%'");
}
list.addSearch("b.member_name",  f.get("s_cust_name"), "LIKE");
list.addSearch("b.vendcd",  f.get("s_vendcd").replaceAll("-", ""), "LIKE");
list.addSearch("a.status", f.get("s_status"));
list.addSearch("a.cont_userno",  f.get("s_user_no"), "LIKE");

if(f.get("s_template_cd").equals("9999999")) { // ��������
	list.addWhere("a.template_cd is null");
} else {
	list.addSearch("a.template_cd", f.get("s_template_cd"));
}

list.addSearch("a.cont_etc1",  f.get("s_division"));  // CJ�������
list.addSearch("a.field_seq",  f.get("s_field_seq")); // CJ������� 
list.addSearch("d.project_cd",  f.get("s_project_cd"),"LIKE");  // ������Ÿġ
if(bviewContNo)
{
	String sCont_no = "";
	if(f.get("s_manage_no").indexOf("-")>0)
		sCont_no = f.get("s_manage_no").split("-")[0];
	else
		sCont_no = f.get("s_manage_no");
	list.addSearch("a.cont_no", sCont_no,"LIKE");
}

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

String sSortColumn = f.get("hdn_sort_column");
String sSortOrder = f.get("hdn_sort_order");
String sSortCustNameIconName = "";
if(!sSortColumn.equals("")) {
	if(sSortOrder.equals("asc"))
		sSortCustNameIconName =  "<font style='color:blue;font-weight:bold'>��</font>";
	else
		sSortCustNameIconName =  "<font style='color:blue;font-weight:bold'>��</font>";

	list.setOrderBy(sSortColumn + " " + sSortOrder);
} else {
	list.setOrderBy("a.cont_no desc, a.cont_chasu asc");
	sSortCustNameIconName = "<font style='color:blue;font-weight:bold'>��</font>";
}

DataSet ds = list.getDataSet();
while(ds.next()){
	ds.put("manage_no", ds.getString("cont_no")+"-"+ds.getString("cont_chasu")+"-"+ds.getString("true_random"));
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if(ds.getInt("cont_chasu")>0){
		if(!u.request("mode").equals("excel")){
			ds.put("cont_name", "<img src='../html/images/re.jpg' align='absmiddle'> " +ds.getString("cont_name") + " ("+ds.getString("cont_chasu")+"��)");
		}else{
			ds.put("cont_name", "	" +ds.getString("cont_name") + " ("+ds.getString("cont_chasu")+"��)");
		}
	}
	if(ds.getInt("cust_cnt")-2>0){
		ds.put("cust_name", ds.getString("member_name")+ "��"+(ds.getInt("cust_cnt")-2)+"����");
	}else{
		ds.put("cust_name", ds.getString("member_name"));
	}

	if((bDetailCode||isKTH)&& ds.getString("cust_detail_code").equals(""))
		ds.put("cust_detail_code", "<font color='red'>[�̵��]</font>");
	if(isLGH && ds.getString("project_cd").equals("")) 
		ds.put("project_cd", "[�̵��]");

	ds.put("link", ds.getString("template_cd").equals("")?"contend_free_sendview.jsp":ds.getString("sign_types").equals("")?"contend_sendview.jsp":"contend_msign_sendview.jsp");
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("cont_sdate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_sdate")));
	ds.put("cont_edate", u.getTimeString("yyyy-MM-dd",ds.getString("cont_edate")));
	ds.put("status_nm", u.getItem(ds.getString("status"),code_status));
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	ds.put("cont_total", u.numberFormat(ds.getDouble("cont_total"), 0));
	ds.put("write_type", ds.getString("template_cd").equals("")?"��������":"�Ϲݼ���");
	if(isNH){
		ds.put("bid_method", u.getItem(ds.getString("bid_method"), code_bid_method));
		ds.put("succ_method", u.getItem(ds.getString("succ_method"), code_succ_method));
	}
	
	if((ds.getString("template_cd").equals("") && isLGH) || (ds.getString("template_cd").equals("") && isTES)){ //��������
		ds.put("vattype", u.getItem(ds.getString("cont_etc2"),code_vat_type)); 
	} 
}
 
if(u.request("mode").equals("excel")){
	p.setVar("title", "�Ϸ�� �����Ȳ");
	p.setVar("detail_cd", bDetailCode );   // �ķ�Ʈ���� ����� �������� ǥ��
	p.setVar("isKTH",isKTH);//KTH �ŷ�ó �ڵ� ǥ��
	p.setVar("isPersonView",isPersonView);//interpark ����� ǥ��
	p.setVar("is3M",is3M);//3m ��������, ���ݾ� ��ǥ��
	p.setVar("isSKB", isSKB); // sk��ε���
	p.setVar("isOlive", isOlive);  // �ø���
	p.setVar("isNH", isNH);
	p.setVar("isLGH", isLGH); //��ũ�ν� ���;ؿ�����
	p.setVar("isTES", isTES);
	p.setVar("isGenie",isGenie);
	p.setVar("isNicednr", isNicednr);
	p.setVar("isWoowahan",isWoowahan); 
	p.setVar("isDwst", isDwst);
	p.setVar("isNHhanaro", isNHhanaro);
	p.setVar("isPbpartners", isPbpartners);
	
	if((ds.getString("template_cd").equals("") && isLGH) || (ds.getString("template_cd").equals("") && isTES)){ //��������
		p.setVar("vatType", "Y");
	} 
	String xlsFile = "contend_send_list_excel.html";

	if(isGenie){
		ds.first();
		while(ds.next()){
			ds.put("org_sign_date", u.getTimeString("yyyy-MM-dd", ds.getString("org_sign_date")));
		}
	}
	
	if(is3M)
	{
		ds.first();
		while(ds.next()){
			ds.put("cust_sign_date", u.getTimeString("yyyy-MM-dd", ds.getString("cust_sign_date")));
			ds.put("org_sign_date", u.getTimeString("yyyy-MM-dd", ds.getString("org_sign_date")));
			
			if(ds.getString("template_cd").equals("2013040"))  // �ǸŴ븮�� ��༭
			{
				Document document = Jsoup.parse(ds.getString("sub_html"));
				String Division = getJsoupValue(document,"t12");  // 3M ����μ� (Division)

				ds.put("sourcing", ds.getString("l_src_nm"));
				ds.put("group", ds.getString("m_src_nm"));
				ds.put("division", Division);
			}
			else if(ds.getString("template_cd").equals("2013042"))  // �Ǹ��� ��༭
			{
				Document document = Jsoup.parse(ds.getString("cont_html"));
				String Division = getJsoupValue(document,"t1");  // 3M ����μ� (Division)

				if(Division.equals("")) {
				    DataObject daoSub = new DataObject("tcb_cont_sub");
				    DataSet dsSub = daoSub.find("cont_no='"+u.aseDec(ds.getString("cont_no"))+"' and sub_seq=1", "cont_sub_html");
				    if(dsSub.next()) {
						Document document2 = Jsoup.parse(dsSub.getString("cont_sub_html"));
						Division = getJsoupValue(document2, "t1");  // 3M ����μ� (Division)
					}
				}

				ds.put("sourcing", ds.getString("l_src_nm"));
				ds.put("group", ds.getString("m_src_nm"));
				ds.put("division", Division);
			}
			else
			{
				ds.put("sourcing", ds.getString("l_src_nm"));
				ds.put("group", ds.getString("m_src_nm"));
				ds.put("division", ds.getString("s_src_nm"));
			}
		}
	}
	else if(isSKB)
	{
	    int totalCnt = ds.size();
	    int excelCnt = 1;
		ds.first();
		while(ds.next()){
		    System.out.println("SK Stoa �����ٿ�ε� �� : " + excelCnt++ + " / " + totalCnt);
		    Thread.sleep(5);
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
	else if(isOlive && f.get("s_template_cd").equals("2015059"))  //��ǰȮ�μ�
	{
		ds.first();
		while(ds.next())
		{			
			Document document = Jsoup.parse(ds.getString("cont_html"));
			String return_spec = getJsoupValue(document,"rSpec");  // ��ǰ�Թ�
			
			ds.put("return_spec", return_spec);
			xlsFile = "contract_send_list_excel_olive.html";
		}
	}
	else if(f.get("s_template_cd").equals("2015038"))  // ���������� ��ǰ�Ǹ�(����)��༭
	{
		ds.first();
		while(ds.next())
		{
			Document document = Jsoup.parse(ds.getString("cont_html"));
			String cust_code = getJsoupValue(document,"sel1_1");  // ��ü�ڵ�
			String item_code = getJsoupValue(document,"sel1_2");  // ��ǰ�ڵ�

			ds.put("cust_code", cust_code);
			ds.put("item_code", item_code);

			ds.put("contNo",u.aseDec(ds.getString("cont_no"))+"-"+ds.getString("cont_chasu")+"-"+ds.getString("true_random"));
			ds.put("contUrlKey",procure.common.utils.Security.AESencrypt(u.aseDec(ds.getString("cont_no"))+ds.getString("cont_chasu")));
			xlsFile = "contract_send_list_excel_wshopping.html";
		}
	}else if(isDwst){
		ds.first();
		while(ds.next()) {
			ds.put("supp_tax", u.numberFormat(ds.getString("supp_tax")));
			ds.put("supp_vat", u.numberFormat(ds.getString("supp_vat")));
			ds.put("cust1_sign_date", u.getTimeString("yyyy-MM-dd HH:mm", ds.getString("cust1_sign_date")));
			ds.put("cust2_sign_date", u.getTimeString("yyyy-MM-dd HH:mm", ds.getString("cust2_sign_date")));
		}
	}
	
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("�Ϸ�� �����Ȳ.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/"+xlsFile));
	return;
}
else if(u.request("mode").equals("report")){
	ds.first();
	while(ds.next()){
		Document document = Jsoup.parse(ds.getString("cont_html"));
		String cont_ref_info = getJsoupValue(document,"ref_info");
		String cont_edate = "";
		String cont_eyear = getJsoupValue(document,"cont_eyear");
		String cont_emonth = getJsoupValue(document,"cont_emonth");
		String cont_eday = getJsoupValue(document,"cont_eday");
		String cont_pre = getJsoupValue(document,"cont_pre");
		String cont_middle1 = getJsoupValue(document,"cont_middle1");
		String cont_middle2 = getJsoupValue(document,"cont_middle2");
		String cont_rest = getJsoupValue(document,"cont_rest");
		if((!cont_eyear.equals(""))&&!cont_emonth.equals("")&&!cont_eday.equals("")){
			cont_edate = cont_eyear+cont_emonth+ cont_eday;
		}
		ds.put("cont_ref_info", cont_ref_info);
		ds.put("cont_edate", u.getTimeString("yyyy-MM-dd", cont_edate));
		ds.put("calc_cont_pre","");
		ds.put("calc_cont_middle1","");
		ds.put("calc_cont_middle2","");
		ds.put("calc_cont_rest","");
		if(ds.getDouble("cont_total")>0){
			if(!cont_pre.equals(""))ds.put("calc_cont_pre",(Double.parseDouble(cont_pre.replaceAll(",", ""))/ds.getDouble("cont_total")*100));
			if(!cont_middle1.equals(""))ds.put("calc_cont_middle1",(Double.parseDouble(cont_middle1.replaceAll(",", ""))/ds.getDouble("cont_total")*100));
			if(!cont_middle2.equals(""))ds.put("calc_cont_middle2",(Double.parseDouble(cont_middle2.replaceAll(",", ""))/ds.getDouble("cont_total")*100));
			if(!cont_rest.equals(""))ds.put("calc_cont_rest",(Double.parseDouble(cont_rest.replaceAll(",", ""))/ds.getDouble("cont_total")*100));
		}
		ds.put("cont_pre", cont_pre);
		ds.put("cont_middle1", cont_middle1);
		ds.put("cont_middle2", cont_middle2);
		ds.put("cont_rest", cont_rest);
		ds.put("cont_total", u.numberFormat(ds.getDouble("cont_total"), 0));
	}

	p.setVar("title", "��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;Ȳ");
	p.setLoop("list", ds);
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("�����Ȳ.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/contract/contend_send_list_report.html"));
	return;
}
else if(u.request("mode").equals("down")){

	String[] save = f.getArr("save");
	if(save==null) return;
	if(isSKB){
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
	}
	if(isOlive){
		String file_path = "";
		String cont_chasu = "";

		DataSet files = new DataSet();
		DataObject rfileDao = new DataObject("tcb_rfile_cust a inner join tcb_contmaster b on a.cont_no=b.cont_no and a.cont_chasu=b.cont_chasu");

		for(int i=0; i < save.length; i ++){
			String[] arrCont = save[i].split("_");

			DataSet dsRfile = rfileDao.find("a.cont_no = '"+u.aseDec(arrCont[0])+"' and a.cont_chasu="+arrCont[1], "b.cont_name, a.file_path, a.file_name, a.file_ext, a.cont_no, a.cont_chasu, a.rfile_seq");
			while(dsRfile.next())
			{
				if(dsRfile.getString("file_name").equals(""))continue;//��÷�ν� �������Ϸ�

				files.addRow();
				files.put("file_path",Startup.conf.getString("file.path.bcont_pdf")+dsRfile.getString("file_path")+dsRfile.getString("file_name"));
				//����_����ȣ_����_RFILE_SEQ
				String doc_name = dsRfile.getString("cont_name")+ "_"+ dsRfile.getString("cont_no")+"_"+dsRfile.getString("cont_chasu")+dsRfile.getString("rfile_seq")+"."+dsRfile.getString("file_ext");
				files.put("doc_name", doc_name);
			}
		}

		MakeZip mk = new MakeZip();
		mk.make(files, response);
	}

	return;
}

DataObject templateDao = new DataObject();
DataSet template = templateDao.query("select nvl(display_name, template_name) template_name, template_cd from tcb_cont_template where template_cd in (select decode(template_cd, '', '9999999', template_cd) template_cd from tcb_contmaster where member_no = '"+_member_no+"'"+s_date_query+" and status in ('50','91') group by template_cd) order by display_seq asc, template_cd desc");


p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contend_send_list");
p.setVar("menu_cd", _menu_cd);
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setVar("member", member);
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("template", template);
p.setLoop("list", ds);
p.setVar("detail_cd", bDetailCode );   // �ķ�Ʈ���� ����� �������� ǥ��
p.setVar("isKTH",isKTH);//KTH �ŷ�ó �ڵ� ǥ��
p.setVar("isPersonView",isPersonView);//interpark ����� ǥ��
//p.setVar("sSortColumnContUserNo", sSortColumn.equals("a.cont_userno") ? true : false);
p.setVar("isNHhanaro", isNHhanaro);  // ��༭ �ϰ� �ٿ�
p.setVar("isSKB", isSKB);  // ��༭ �ϰ� �ٿ�
p.setVar("isOlive", isOlive);  // ���񼭷� �ϰ� �ٿ�
p.setVar("view_checkbox", isSKB||isOlive);
p.setVar("isLGH", isLGH);
p.setVar("isTES", isTES);
p.setVar("bviewContNo", bviewContNo);
p.setVar("view_status", view_status);
p.setVar("sSortColumn", sSortColumn);
p.setVar("sSortOrder", sSortOrder);
p.setVar("sSortCustNameIconName", sSortCustNameIconName);
p.setVar("src_l", src_l);
p.setVar("src_m", src_m);
p.setVar("src_s", src_s);
p.setVar("l_src_cd", f.get("l_src_cd"));
p.setVar("m_src_cd", f.get("m_src_cd"));
p.setVar("s_src_cd", f.get("s_src_cd"));
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.setVar("isDongheeGroup", u.inArray(_member_no, new String[]{"20130300068","20130300064","20130300063","20130300062","20130300061","20130300060","20130300059","20130300058","20130300057","20121203399","20121202637","20121200067","20130700100"}));
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