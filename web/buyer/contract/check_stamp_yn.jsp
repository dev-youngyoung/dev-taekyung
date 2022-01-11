<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="nicelib.sap.*" %>
<%
String contNo = u.aseDec(u.request("cont_no"));
System.out.println("[check_stamp_yn.jsp] contNo : " + contNo);

DataObject stampDao = new DataObject();

StringBuffer sbSql = new StringBuffer();
sbSql.append("select count(*) as cnt ");
sbSql.append("from tcb_contmaster a, ");
sbSql.append("    ( ");
sbSql.append("        select b1.conno as cont_no, a1.dstate "); // conno:계약번호, dstate:결재 상태값(1:저장, 2:상신 (진행, 반려, 기안취소 포함), 3:삭제, 9:결재완료)
sbSql.append("        from findt001 a1, findt002 b1 ");
sbSql.append("        where a1.appno = b1.appno "); // appno:신청번호
sbSql.append("        and a1.dstate not in ('1','3') "); // 저장(1), 삭제(3) 상태 제외
sbSql.append("    ) b ");
sbSql.append("where a.cont_no = b.cont_no ");
sbSql.append("  and a.cont_no = '" + contNo + "' "); // 계약번호

DataSet stampData = stampDao.query(sbSql.toString());
stampData.next();

String cnt = stampData.getString("cnt");
System.out.println("[check_stamp_yn.jsp] cnt : " + cnt);
int stampCnt = Integer.parseInt(cnt);

String result = "{\"stampYn\" : \"" + ((stampCnt > 0) ? "Y" : "N") + "\" }";
System.out.println("[check_stamp_yn.jsp] result : " + result);
out.print(result);
%>