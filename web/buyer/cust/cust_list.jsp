<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

f.addElement("s_member_name",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_client a, tcb_member b ");
list.setFields("a.*, b.vendcd, b.member_name, b.boss_name");
list.addWhere(" a.client_no = '"+_member_no+"'");
list.addWhere("	a.member_no = b. member_no ");
list.addSearch("b.member_name", f.get("s_member_name"), "LIKE");
list.setOrderBy("client_reg_date desc");

DataSet ds = list.getDataSet();
while(ds.next()){
	ds.put("vendcd", u.getBizNo(ds.getString("vendcd")));
	if(u.inArray(ds.getString("member_no"), new String[]{"20121203661","20130400010","20130400009","20130400011","20130400008"})) // 한국쓰리엠
	{
		String[] code_client_type = {"0=>공급사","1=>판매(대리)점"};
		ds.put("client_type_nm", Util.getItems(ds.getString("client_type"), code_client_type));
	}
	else if(ds.getString("member_no").equals("20140300055")) // 한국유리공업
	{
		String[] code_client_type = {"0=>공급사","1=>판매(대리)점"};
		ds.put("client_type_nm", Util.getItems(ds.getString("client_type"), code_client_type));
	}
	else if(ds.getString("member_no").equals("20130400091")) // 대보정보통신
	{
		String[] code_client_type = {"0=>물품","1=>용역"};
		ds.put("client_type_nm", Util.getItems(ds.getString("client_type"), code_client_type));
	}
	else if( u.inArray(ds.getString("member_no"), new String[]{"20121200116", "20140101025", "20120200001", "20170101031","20170602171"}) ) // 한국제지, 신세계, 테스트02, 수협은행, 대림씨엔에스
	{
		String[] code_client_type = {"0=>물품","1=>공사","2=>용역"};
		ds.put("client_type_nm", Util.getItems(ds.getString("client_type"), code_client_type));
	}
	else if( u.inArray(ds.getString("member_no"), new String[]{"20160901598"}) ) // NH투자증권
	{
		String[] code_client_type = {"1=>등록업체","2=>협력업체"};
		ds.put("client_type_nm", Util.getItems(ds.getString("client_type"), code_client_type));
	}
	else if( u.inArray(ds.getString("member_no"), new String[]{"20150200088"}) ) // 코스모코스
	{
		String[] code_client_type = new String[]{"0=>원자재","1=>외주","2=>부자재"};
		ds.put("client_type_nm", Util.getItems(ds.getString("client_type"), code_client_type));
	}
	else if( u.inArray(ds.getString("member_no"), new String[]{"20130400333"}) ) // CJ대한통운
	{
		String[] code_client_type = new String[]{"0=>수송","1=>구매","2=>공사"};
		ds.put("client_type_nm", Util.getItems(ds.getString("client_type"), code_client_type));
	}
	else
	{
		ds.put("client_type_nm", "일반거래처");
	}

	if(ds.getString("client_reg_cd").equals("0"))
		ds.put("client_reg_nm", "가등록");
	else
		ds.put("client_reg_nm", "정식등록");


	if(ds.getString("member_no").equals("20160901598")&&ds.getString("client_type").equals("1")){//NH투자 증권 등록업체 신청인 경우 신청서 팝업 추가
		DataObject recruitNotiDao = new DataObject("tcb_recruit_noti");
		DataSet recruitNoti  = recruitNotiDao.find("member_no = '20160901598' and req_sdate <= '"+u.getTimeString("yyyyMMdd")+"' and req_edate >= '"+u.getTimeString("yyyyMMdd")+"' and status = '10'");
		if(recruitNoti.next()){
			DataObject recruitCustDao = new DataObject("tcb_recruit_cust");
			DataSet recruitCust = recruitCustDao.find("member_no = '20160901598' and noti_seq = '"+recruitNoti.getString("noti_seq")+"' and client_no = '"+_member_no+"' ");
			if(recruitCust.next()){
				String[] code_status = {"10=>임시저장","20=>신청중","30=>수정요청","31=>수정신청","40=>심사완료","50=>완료"};

				if(u.inArray(recruitCust.getString("status"), new String[]{"10","20","30","31"})   ){
					String btn = " <button type=\"button\" class=\"sbtn color\" onclick=\"OpenWindows('pop_nhqv_recruit_req.jsp?noti_seq="+recruitNoti.getString("noti_seq")+"','pop_nhqv_recruit_req','1000','700');\">신청서("+u.getItem(recruitCust.getString("status"), code_status)+")</button>";
					ds.put("client_reg_nm", ds.getString("client_reg_nm")+"<br>"+ btn);
				}
			}
		}
	}

}

if(!f.get("s_member_name").equals("")&&ds.size()==0){
	u.jsAlert("검색 결과가 없습니다.\\n\\n업체추가버튼을 클릭하여 거래업체를 추가 하실 수 있습니다.");
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.cust_list");
p.setVar("menu_cd","000099");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>