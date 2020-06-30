<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] site_names = {"1=>나이스다큐(일반기업용)","2=>나이스다큐(건설)","3=>나이스다큐(물류)","4=>나이스다큐(프렌차이즈)"};
String[] banner_names = {"1=>나이스신용평가"};
String[] banner_links = {"1=>http://www.nicerating.com/main.do"};

String banner_seq = u.request("banner_seq");
String site_gubun = u.request("site_gubun");
if(banner_seq.equals("")|| site_gubun.equals("")){
	return;
}

String site_name = u.getItem(site_gubun, site_names);
String banner_name = u.getItem(banner_seq, banner_names);
if(site_name.equals("")|| banner_name.equals("")){
	return;
}

DataObject bannerCounter = new DataObject("tcc_banner_counter");
bannerCounter.item("banner_seq",banner_seq);
bannerCounter.item("site_name", site_name);
bannerCounter.item("click_date",u.getTimeString());
bannerCounter.item("banner_name",banner_name);
bannerCounter.insert();

u.redirect(u.getItem(banner_seq, banner_links));
%>