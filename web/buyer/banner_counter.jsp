<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] site_names = {"1=>���̽���ť(�Ϲݱ����)","2=>���̽���ť(�Ǽ�)","3=>���̽���ť(����)","4=>���̽���ť(����������)"};
String[] banner_names = {"1=>���̽��ſ���"};
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