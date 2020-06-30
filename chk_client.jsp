<%@ page import="java.util.*,java.io.*,nicelib.db.*,nicelib.util.*,dao.*" %>
<%@ page contentType="text/html; charset=EUC-KR" %>
<%
//�α׾ƿ� �� �ڷΰ��� ĳ�� ���� 2012.11.1 add by ������
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
				<p class="title">�ŷ�ó Ȯ��</p>
				<div class="con1">
					<div class="notice">
						<p>�Է��� ����ڹ�ȣ�� �ŷ�ó�� Ȯ�ε��� �ʽ��ϴ�.</p>
					</div>
					<div class="notice-text">
						ȸ�������� ��û�� �ŷ�ó�� ����ڹ�ȣ��<br> Ȯ�� �Ͻñ� �ٶ��ϴ�.
					</div>
					<div class="lp-btn">
						<input type="button" value="�ݱ�" onclick="$('#comp_info').html('');$('#comp_info').removeClass('active')">
					</div>
					<div class="number">
						�� ���̽���ť ������ : 02-788-9097~8
					</div>
				</div>
			</div>
		</div>

<%}else{ %>

	<div class="lp-container">
		<div class="lp-contents">
			<p class="title">�ŷ�ó Ȯ��</p>
			<div class="con2">
				<table class="lp-table">
					<thead>
						<tr>
							<th scope="col">��ü��</th>
							<th scope="col">����ڹ�ȣ</th>
							<th scope="col">��������</th>
						</tr>
					</thead>
					<tbody>
						<% 
							if(b_member.next()){
								cate_names+="<strong>���Ϲ� ����롯</strong>";
						%>
						<tr>
							<td><%=b_member.getString("member_name") %></td>
							<td><%=u.getBizNo(b_member.getString("vendcd")) %></td>
							<td>�Ϲ� �����</td>
						</tr>
						<%} %>
						<% 
							if(k_member.next()){
								if(!cate_names.equals(""))cate_names+=", ";
								cate_names+="<strong>���Ǽ� ����롯</strong>";
						%>
						<tr>
							<td><%=k_member.getString("member_name") %></td>
							<td><%=u.getBizNo(k_member.getString("vendcd")) %></td>
							<td>�Ǽ� �����</td>
						</tr>
						<%} %>
						<% 
							if(f_member.next()){
								if(!cate_names.equals(""))cate_names+=", ";
								cate_names+="<strong>������������ ����롯</strong>";
						%>
						<tr>
							<td><%=f_member.getString("member_name") %></td>
							<td><%=u.getBizNo(f_member.getString("vendcd")) %></td>
							<td>���������� �����</td>
						</tr>
						<%} %>
						<% 
							if(l_member.next()){
								if(!cate_names.equals(""))cate_names+=", ";
								cate_names+="<strong>������ ����롯</strong>";
						%>
						<tr>
							<td><%=l_member.getString("member_name") %></td>
							<td><%=u.getBizNo(l_member.getString("vendcd")) %></td>
							<td>���� �����</td>
						</tr>
						<%} %>
					</tbody>
				</table>
				<div class="notice">
					<p>
					<%if(comp_cnt>1) {
						out.print("�ŷ�ó �Ǵ� �����ͷ� �������� ���� ������ Ȯ�� �� ȸ������ �Ͻñ� �ٸ��ϴ�.");
					}else{
						out.print(cate_names +"���� ȸ�� ���� �ϼ���.");
					}
					%>
					</p>
				</div>
				<div class="lp-btn">
					<input type="button" value="�ݱ�" onclick="$('#comp_info').html('');$('#comp_info').removeClass('active')">
				</div>
				<div class="number">
						�� ���̽���ť ������ : 02-788-9097~8
				</div>
			</div>
		</div>
	</div>


<%}%>
<script>$("#comp_info").addClass("active")</script>

