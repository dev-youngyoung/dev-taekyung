<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String s_vendcd = u.request("s_vendcd");  

// 목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(5);
list.setTable("IF_MMBAT100 I, TCB_MEMBER T");
// 회원가입시 사업자번호 입력 후 거래처 선택시 거래처코드 보여주는 로직 추가(2020.12.29, swplus)
// (pop_search_join.html, chk_vendcd.jsp 공동 수정)
//list.setFields("I.*, T.MEMBER_NO JOIN_MEM, T.STATUS");
list.setFields("decode(I.CUST_GUBN_NAME, null,'회계거래처','구매거래처')||'('||LTRIM(I.CUST_CODE, '000')||')' LTRIM_CUST_CODE, I.*, T.MEMBER_NO JOIN_MEM, T.STATUS");
list.addWhere("I.MEMBER_NO = T.MEMBER_NO (+)");
list.addSearch("COMM_NO", s_vendcd);
list.setOrderBy("I.MEMBER_NO");

DataSet ds = null;
Security security = new	Security();
ds = list.getDataSet();

p.setLayout("popup");
p.setBody("member.pop_search_join");
p.setVar("popup_title","사업자번호 검색");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.setVar("s_vendcd",s_vendcd);
p.display(out);
%>