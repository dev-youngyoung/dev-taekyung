<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page import="java.util.ArrayList
				,nicelib.db.DataSet
				,nicelib.util.Util
				,nicelib.db.DataObject
				,nicelib.db.DB
				,java.net.URLDecoder
"%>
<%@ include file = "../../../inc/funUtil.inc" %>
<%
// http://dev.nicedocu.com/web/buyer/admin/batch_person_insert.jsp?member_no=20130500019

	Util u = new Util(request, response, out);
	
	String grid = u.request("grid");
	if(!grid.equals("")){
		grid = URLDecoder.decode(grid,"UTF-8");
	}
	
	DataSet data = u.grid2dataset(grid);

	try{
		
		String	sMemberNo	= u.request("member_no");	// ȸ����ȣ
		String  person_seq	=	"";		// �Ϸù�ȣ
		String 	user_id			=	"";	//	���̵�
		String	field_name		=	"";	//	��ǥ�ڸ�
		String	field_seq		=	"";	//	�μ��ڵ�

		System.out.println("realGrid.getRowCnt["+data.size()+"]");

		while(data.next()){
			DB db = new DB();

			user_id	= data.getString("user_id").replaceAll(" ", "");

			// 1. ���� ��ϵ� ��������� Ȯ��
			DataObject daoPerson = new DataObject("tcb_person");
			DataSet dsPerson = daoPerson.find("user_id = '"+user_id+"'", "member_no");
			if(dsPerson.next()) // ȸ��
			{
				System.out.println("���� ����� �Դϴ�.  user_id->" + user_id);
			}
			else
			{	// �̵�� �����

				person_seq = daoPerson.getOne("select nvl(max(person_seq),0)+1 person_seq from tcb_person where member_no = '"+sMemberNo+"'");
				if(person_seq.equals("")){
					System.out.println("����� SEQ ���� ���� : user_id->" + user_id);
					continue;
				}

				field_name = data.getString("field_name");
				DataObject daoField = new DataObject("tcb_field");
				DataSet dsField = daoField.find(" member_no = '"+sMemberNo+"' and field_name = '"+field_name+"'", "field_seq");
				if(!dsField.next())
				{
					field_seq = daoPerson.getOne("select nvl(max(field_seq),0)+1 field_seq from tcb_field where member_no = '"+sMemberNo+"'");
					if(field_seq.equals("")){
						System.out.println("�μ� ���� ���� : user_id->" + user_id);
						continue;
					}
					daoField.item("member_no", sMemberNo);
					daoField.item("field_seq", field_seq);
					daoField.item("field_name", field_name);
					daoField.item("use_yn", "Y");
					daoField.item("status", "1");
					daoField.item("field_gubun", "01");  // 01:�μ�, 02:����
					db.setCommand(daoField.getInsertQuery(), daoField.record);
				} else {
					field_seq = dsField.getString("field_seq");
				}

				daoPerson.item("member_no", sMemberNo);
				daoPerson.item("person_seq", person_seq);
				daoPerson.item("user_id", user_id);
				if(data.getString("passwd").equals("")){
					daoPerson.item("passwd", Util.sha256(data.getString("user_id")));
				}else{
					daoPerson.item("passwd", Util.sha256(data.getString("passwd")));
				}
				daoPerson.item("user_name", data.getString("user_name"));
				daoPerson.item("tel_num", data.getString("tel_num"));
				daoPerson.item("division", data.getString("field_name"));
				//daoPerson.item("division", "3");
				daoPerson.item("position", data.getString("position"));
				daoPerson.item("tel_num", data.getString("tel_num"));
				daoPerson.item("fax_num", data.getString("fax_num"));
				daoPerson.item("hp1", data.getString("hp1"));
				daoPerson.item("hp2", data.getString("hp2"));
				daoPerson.item("hp3", data.getString("hp3"));
				daoPerson.item("email", data.getString("email"));
				if(data.getString("user_level").equals("10"))
					daoPerson.item("default_yn", "Y");
				else
					daoPerson.item("default_yn", "N");
				daoPerson.item("use_yn","Y");
				daoPerson.item("reg_date", Util.getTimeString());
				daoPerson.item("reg_id", "systemadmin");
				daoPerson.item("user_gubun", data.getString("user_gubun"));		// 10-����, 20-����
				daoPerson.item("status", "1");
				daoPerson.item("field_seq", field_seq);
				daoPerson.item("user_level", data.getString("user_level"));
				db.setCommand(daoPerson.getInsertQuery(), daoPerson.record);
			}

			db.executeArray();
		}

		out.print("1");
		
	}catch(Exception e){
		out.print("0");
		return;
	}
%>