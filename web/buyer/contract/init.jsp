<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %><%@ include file="../chk_login.jsp" %>
<%

// 자유서식 코드
String[] code_signer = {"11=>공급받는자","12=>공급자","21=>갑","22=>을","23=>병","31=>접수자","32=>신청자","41=>도급인","42=>수급인","51=>이용인","52=>제공인","61=>계약담당","62=>계약상대자","71=>배출자","72=>수집/운반자","73=>처리자"};
String[] code_warr_status = {"10=>보증요청","20=>확인대기","30=>완료"};
%>