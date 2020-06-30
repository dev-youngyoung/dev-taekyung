<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page import=" java.util.ArrayList
				 ,nicelib.db.DataSet
				 ,nicelib.util.Util
				 ,nicelib.db.DataObject
				 ,nicelib.db.DB
				 ,java.net.URLDecoder
"%>
<%@ include file = "../../../inc/funUtil.inc" %>
<%

	Util u = new Util(request, response, out);
	
	String grid = u.request("grid");
	if(!grid.equals("")){
		grid = URLDecoder.decode(grid,"UTF-8");
	}
	
	DataSet data = u.grid2dataset(grid);

	try
	{
		String	sMemberNo	= 	u.request("member_no");	// ȸ����ȣ

		String  custMemberNo	=	""; //  �ŷ�ó ȸ����ȣ
		String	member_gubun 	= 	"";			// ȸ������ (01 : ����(����), 02 : ����(����), 03 : ���λ����)
		String	member_type		= 	"02";		// ȸ������ (02 : �������)
		String  status			= 	"02";		// ȸ������ (02 : ��ȸ��)

		String 	vendcd			=	"";	//	����ڹ�ȣ
		String	member_name		=	"";	//	��ü��
		String	boss_name		=	"";	//	��ǥ�ڸ�
		String	post_code		=	"";	//	�����ȣ
		String	address			=	"";	//	�ּ�

		String  person_seq		=   "";
		String	user_name		=	"";	//	����ڸ�
		String	tel_num			=	"";	//	��ȭ��ȣ
		String	hp1				=	"";	//	�޴��ȣ
		String	hp2				=	"";	//
		String	hp3				=	"";	//
		String	email			=	"";	//	�̸���
		
		String condition		= "";	// ����
		String category			= "";	// ����

		String[] arr = {"81","82","83","84","86","87","88"};  // ���λ���� ����

		System.out.println("realGrid.getRowCnt["+data.size()+"]");

		while(data.next()){
			
			DB db = new DB();

			vendcd	=	data.getString("vendcd").replaceAll("-", "");

			// 1. ȸ������ üũ
			DataObject doMember = new DataObject("tcb_member");
			DataSet dsMember = doMember.find("vendcd = '"+vendcd+"'", "member_no");
			
			
			if(dsMember.next()) // ȸ��
			{
				System.out.println("������ ���Ե� ȸ���Դϴ�.  ����ڹ�ȣ->" + vendcd);
				custMemberNo = dsMember.getString("member_no");

				DataObject daoPerson = new DataObject("tcb_person");
				int nExitPerson = daoPerson.getOneInt("select count(*) from tcb_person where member_no = '"+custMemberNo+"' and user_name = '"+ data.getString("user_name").trim() +"'");
				if(nExitPerson > 0)
				{
					System.out.println("������ ���Ե� ������Դϴ�.  : ����ڸ� ->" + data.getString("user_name"));
				}
				else
				{
					person_seq = daoPerson.getOne("select nvl(max(person_seq),0)+1 person_seq from tcb_person where member_no = '"+custMemberNo+"'");
					if(person_seq.equals("")){
						System.out.println("����� SEQ ���� ���� : ����ڹ�ȣ->" + vendcd);
						continue;
					}

					if(!person_seq.equals("1") && data.getString("user_name").equals("")){
						System.out.println("���� ����� ������ �־� ����ڴ� �߰� ���� �ʽ��ϴ�.->" + vendcd);
					} else {
						daoPerson.item("member_no", custMemberNo);
						daoPerson.item("person_seq", person_seq);
						daoPerson.item("user_name", data.getString("user_name"));
						daoPerson.item("tel_num", data.getString("tel_num"));
						daoPerson.item("hp1", data.getString("hp1"));
						daoPerson.item("hp2", data.getString("hp2"));
						daoPerson.item("hp3", data.getString("hp3"));
						daoPerson.item("email", data.getString("email"));
						if(person_seq.equals("1"))
							daoPerson.item("default_yn", "Y");
						else
							daoPerson.item("default_yn", "N");
						daoPerson.item("use_yn","N");
						daoPerson.item("reg_date", u.getTimeString());
						daoPerson.item("reg_id", "systemadmin");
						daoPerson.item("user_gubun", "10");		// 10-����, 20-����
						daoPerson.item("status", "1");
						db.setCommand(daoPerson.getInsertQuery(), daoPerson.record);
					}
				}
			}
			else
			{	// �̰���ȸ��
				custMemberNo = doMember.getOne(
							"SELECT TO_CHAR(SYSDATE, 'yyyymm') || LPAD( (NVL(MAX(SUBSTR(member_no, 7)), 0) + 1),5,'0' ) member_no"+
				    		"  FROM tcb_member WHERE  member_no like '"+u.getTimeString("yyyyMM")+"%'"
							);
				String vendcd2 = vendcd.substring(3,5);

				if( u.inArray(vendcd2,arr) ){
					member_gubun = "01";	// ���λ����(����)
				}else if(vendcd2.equals("85")){
					member_gubun = "02";	// ���λ����(����)
				}else{						// ���λ����
					member_gubun = "03";
				}
				member_name = data.getString("member_name");
				boss_name = data.getString("boss_name");
				post_code = data.getString("post_code");
				address = data.getString("address");
				condition = data.getString("condition");
				category = data.getString("category");

				doMember.item("member_no",	custMemberNo);
				doMember.item("vendcd", vendcd);
				doMember.item("member_name", member_name);
				doMember.item("member_gubun", member_gubun);
				doMember.item("member_type", member_type);
				doMember.item("boss_name", boss_name);
				doMember.item("post_code", post_code.replaceAll("-", ""));
				doMember.item("address", address);
				doMember.item("reg_date", u.getTimeString());
				doMember.item("reg_id", "systemadmin");
				doMember.item("status", status);
				doMember.item("condition",condition);
				doMember.item("category",category);
				db.setCommand(doMember.getInsertQuery(), doMember.record);

				DataObject daoPerson = new DataObject("tcb_person");
				person_seq = daoPerson.getOne("select nvl(max(person_seq),0)+1 person_seq from tcb_person where member_no = '"+custMemberNo+"'");
				if(person_seq.equals("")){
					System.out.println("����� SEQ ���� ���� : ����ڹ�ȣ->" + vendcd);
					continue;
				}

				daoPerson.item("member_no", custMemberNo);
				daoPerson.item("person_seq", person_seq);
				daoPerson.item("user_name", data.getString("user_name"));
				daoPerson.item("tel_num", data.getString("tel_num"));
				daoPerson.item("hp1", data.getString("hp1"));
				daoPerson.item("hp2", data.getString("hp2"));
				daoPerson.item("hp3", data.getString("hp3"));
				daoPerson.item("email", data.getString("email"));
				if(person_seq.equals("1"))
					daoPerson.item("default_yn", "Y");
				else
					daoPerson.item("default_yn", "N");
				daoPerson.item("use_yn","N");
				daoPerson.item("reg_date", u.getTimeString());
				daoPerson.item("reg_id", "systemadmin");
				daoPerson.item("user_gubun", "10");		// 10-����, 20-����
				daoPerson.item("status", "1");
				db.setCommand(daoPerson.getInsertQuery(), daoPerson.record);
			}

			// 2. �̹� ��ϵ� �ŷ�ó���� üũ
			DataObject daoClient = new DataObject("tcb_client");
			int nExistCust = daoClient.getOneInt("select count(*) from tcb_client where member_no='"+sMemberNo+"' and client_no='"+custMemberNo+"'");
			if(nExistCust > 0)
			{
				System.out.println("�̹� �ŷ�ó�� ��ϵǾ� �־� ������� �ʽ��ϴ�. ����ڹ�ȣ->" + vendcd);
				continue;
			}

			// 3. �ŷ�ó�� ���
			int client_seq = daoClient.getOneInt(" select nvl(max(client_seq),0)+1 from tcb_client where member_no='"+sMemberNo+"' ");
			daoClient.item("member_no", sMemberNo);
			daoClient.item("client_seq", client_seq);
			daoClient.item("client_no",  custMemberNo);
			daoClient.item("client_reg_cd", "1");
			daoClient.item("client_type",  data.getString("detailcode"));
			db.setCommand(daoClient.getInsertQuery(), daoClient.record);
			
			/*
			// 4. �ŷ�ó �� ���
			if(!wgs.getString("detailcode",i).equals(""))
			{
				DataObject daoClientDetail = new DataObject("tcb_client_detail");
				
				daoClientDetail.item("member_no", sMemberNo);
				daoClientDetail.item("client_seq", client_seq);
				daoClientDetail.item("person_seq",  1);
				daoClientDetail.item("client_detail_seq",  1);
				daoClientDetail.item("cust_detail_code",  wgs.getString("detailcode",i));
				db.setCommand(daoClientDetail.getInsertQuery(), daoClientDetail.record);					
			}
			*/

			db.executeArray();
		}

		out.print("1");

	}catch(Exception e){
		out.print("2");
		return;
	}
%>