<%@ page import="java.util.*,java.io.*,nicelib.db.*,nicelib.util.*,dao.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
//로그아웃 후 뒤로가기 캐시 방지 2012.11.1 add by 유성훈
response.setHeader("Pragma", "No-cache");
response.setDateHeader("Expires", 0);
response.setHeader("Cache-Control", "no-Cache");
//-------------------------------------------------------

Util u = new Util(request, response, out);


String vendcd = u.request("vendcd").replaceAll("-", "");
String cate_names = "";

int comp_cnt = 0;

DataObject b_memberDao = new DataObject("tcb_member");
DataSet b_member = b_memberDao.find(" vendcd = '"+vendcd+"' and member_type in ('01','03') and status = '01' and member_no <> '20150901887' ");
comp_cnt = b_member.size();

DataObject k_memberDao = new DataObject("tck_member");
DataSet k_member = k_memberDao.find(" vendcd = '"+vendcd+"' and member_type in ('01','03') and status = '01'");
comp_cnt += k_member.size();

DataObject f_memberDao = new DataObject("tcf_member");
DataSet f_member = f_memberDao.find(" vendcd = '"+vendcd+"' and member_type = '10'  and status = '01'");
comp_cnt += f_member.size();

DataObject l_memberDao = new DataObject("tcl_member");
DataSet l_member = l_memberDao.find(" vendcd = '"+vendcd+"' and member_type = '01'  and status = '01'");
comp_cnt += l_member.size();


if(comp_cnt <1){
%>
		<div class="lp-container">
			<div class="lp-contents">
				<p class="title">거래처 확인</p>
				<div class="con1">
					<div class="notice">
						<p>입력한 사업자번호로 거래처가 확인되지 않습니다.</p>
					</div>
					<div class="notice-text">
						회원가입을 요청한 거래처의 사업자번호를<br> 확인 하시기 바랍니다.
					</div>
					<div class="lp-btn">
						<input type="button" value="닫기" onclick="$('#comp_info').html('');$('#comp_info').removeClass('active')">
					</div>
					<div class="number">
						※ 나이스다큐 고객센터 : 02-788-9097~8
					</div>
				</div>
			</div>
		</div>

<%}else{ %>

	<div class="lp-container">
		<div class="lp-contents">
			<p class="title">거래처 확인</p>
			<div class="con2">
				<table class="lp-table">
					<thead>
						<tr>
							<th scope="col">업체명</th>
							<th scope="col">사업자번호</th>
							<th scope="col">서비스종류</th>
						</tr>
					</thead>
					<tbody>
						<% 
							if(b_member.next()){
								cate_names+="<strong>‘일반 기업용’</strong>";
						%>
						<tr>
							<td><%=b_member.getString("member_name") %></td>
							<td><%=u.getBizNo(b_member.getString("vendcd")) %></td>
							<td>일반 기업용</td>
						</tr>
						<%} %>
						<% 
							if(k_member.next()){
								if(!cate_names.equals(""))cate_names+=", ";
								cate_names+="<strong>‘건설 기업용’</strong>";
						%>
						<tr>
							<td><%=k_member.getString("member_name") %></td>
							<td><%=u.getBizNo(k_member.getString("vendcd")) %></td>
							<td>건설 기업용</td>
						</tr>
						<%} %>
						<% 
							if(f_member.next()){
								if(!cate_names.equals(""))cate_names+=", ";
								cate_names+="<strong>‘프랜차이즈 기업용’</strong>";
						%>
						<tr>
							<td><%=f_member.getString("member_name") %></td>
							<td><%=u.getBizNo(f_member.getString("vendcd")) %></td>
							<td>프랜차이즈 기업용</td>
						</tr>
						<%} %>
						<% 
							if(l_member.next()){
								if(!cate_names.equals(""))cate_names+=", ";
								cate_names+="<strong>‘물류 기업용’</strong>";
						%>
						<tr>
							<td><%=l_member.getString("member_name") %></td>
							<td><%=u.getBizNo(l_member.getString("vendcd")) %></td>
							<td>물류 기업용</td>
						</tr>
						<%} %>
					</tbody>
				</table>
				<div class="notice">
					<p>
					<%if(comp_cnt>1) {
						out.print("거래처 또는 고객센터로 업무진행 서비스 종류를 확인 후 회원가입 하시기 바립니다.");
					}else{
						out.print(cate_names +"으로 회원 가입 하세요.");
					}
					%>
					</p>
				</div>
				<div class="lp-btn">
					<input type="button" value="닫기" onclick="$('#comp_info').html('');$('#comp_info').removeClass('active')">
				</div>
				<div class="number">
						※ 나이스다큐 고객센터 : 02-788-9097~8
				</div>
			</div>
		</div>
	</div>


<%}%>
<script>$("#comp_info").addClass("active")</script>

