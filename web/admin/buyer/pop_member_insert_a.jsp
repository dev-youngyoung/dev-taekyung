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
		String	sMemberNo	= 	u.request("member_no");	// 회원번호

		String  custMemberNo	=	""; //  거래처 회원번호
		String	member_gubun 	= 	"";			// 회원구분 (01 : 법인(본사), 02 : 법인(지사), 03 : 개인사업자)
		String	member_type		= 	"02";		// 회원종류 (02 : 을사업자)
		String  status			= 	"02";		// 회원상태 (02 : 비회원)

		String 	vendcd			=	"";	//	사업자번호
		String	member_name		=	"";	//	업체명
		String	boss_name		=	"";	//	대표자명
		String	post_code		=	"";	//	우편번호
		String	address			=	"";	//	주소

		String  person_seq		=   "";
		String	user_name		=	"";	//	담당자명
		String	tel_num			=	"";	//	전화번호
		String	hp1				=	"";	//	휴대번호
		String	hp2				=	"";	//
		String	hp3				=	"";	//
		String	email			=	"";	//	이메일
		
		String condition		= "";	// 업태
		String category			= "";	// 업종

		String[] arr = {"81","82","83","84","86","87","88"};  // 법인사업자 구분

		System.out.println("realGrid.getRowCnt["+data.size()+"]");

		while(data.next()){
			
			DB db = new DB();

			vendcd	=	data.getString("vendcd").replaceAll("-", "");

			// 1. 회원인지 체크
			DataObject doMember = new DataObject("tcb_member");
			DataSet dsMember = doMember.find("vendcd = '"+vendcd+"'", "member_no");
			
			
			if(dsMember.next()) // 회원
			{
				System.out.println("기존에 가입된 회원입니다.  사업자번호->" + vendcd);
				custMemberNo = dsMember.getString("member_no");

				DataObject daoPerson = new DataObject("tcb_person");
				int nExitPerson = daoPerson.getOneInt("select count(*) from tcb_person where member_no = '"+custMemberNo+"' and user_name = '"+ data.getString("user_name").trim() +"'");
				if(nExitPerson > 0)
				{
					System.out.println("기존에 가입된 사용자입니다.  : 사용자명 ->" + data.getString("user_name"));
				}
				else
				{
					person_seq = daoPerson.getOne("select nvl(max(person_seq),0)+1 person_seq from tcb_person where member_no = '"+custMemberNo+"'");
					if(person_seq.equals("")){
						System.out.println("담당자 SEQ 생성 오류 : 사업자번호->" + vendcd);
						continue;
					}

					if(!person_seq.equals("1") && data.getString("user_name").equals("")){
						System.out.println("기존 담당자 정보가 있어 담당자는 추가 하지 않습니다.->" + vendcd);
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
						daoPerson.item("user_gubun", "10");		// 10-본사, 20-지사
						daoPerson.item("status", "1");
						db.setCommand(daoPerson.getInsertQuery(), daoPerson.record);
					}
				}
			}
			else
			{	// 미가입회원
				custMemberNo = doMember.getOne(
							"SELECT TO_CHAR(SYSDATE, 'yyyymm') || LPAD( (NVL(MAX(SUBSTR(member_no, 7)), 0) + 1),5,'0' ) member_no"+
				    		"  FROM tcb_member WHERE  member_no like '"+u.getTimeString("yyyyMM")+"%'"
							);
				String vendcd2 = vendcd.substring(3,5);

				if( u.inArray(vendcd2,arr) ){
					member_gubun = "01";	// 법인사업자(본사)
				}else if(vendcd2.equals("85")){
					member_gubun = "02";	// 법인사업자(지사)
				}else{						// 개인사업자
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
					System.out.println("담당자 SEQ 생성 오류 : 사업자번호->" + vendcd);
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
				daoPerson.item("user_gubun", "10");		// 10-본사, 20-지사
				daoPerson.item("status", "1");
				db.setCommand(daoPerson.getInsertQuery(), daoPerson.record);
			}

			// 2. 이미 등록된 거래처인지 체크
			DataObject daoClient = new DataObject("tcb_client");
			int nExistCust = daoClient.getOneInt("select count(*) from tcb_client where member_no='"+sMemberNo+"' and client_no='"+custMemberNo+"'");
			if(nExistCust > 0)
			{
				System.out.println("이미 거래처로 등록되어 있어 등록하지 않습니다. 사업자번호->" + vendcd);
				continue;
			}

			// 3. 거래처로 등록
			int client_seq = daoClient.getOneInt(" select nvl(max(client_seq),0)+1 from tcb_client where member_no='"+sMemberNo+"' ");
			daoClient.item("member_no", sMemberNo);
			daoClient.item("client_seq", client_seq);
			daoClient.item("client_no",  custMemberNo);
			daoClient.item("client_reg_cd", "1");
			daoClient.item("client_type",  data.getString("detailcode"));
			db.setCommand(daoClient.getInsertQuery(), daoClient.record);
			
			/*
			// 4. 거래처 상세 등록
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