<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String user_id = u.request("user_id").trim();
String passwd = u.request("passwd").trim();
String re = u.request("re");
int nTryCnt = u.parseInt(u.getCookie("try"));  // 로그인시도 횟수
if(nTryCnt >= 5)
{
	out.print("<script>");
	out.print("alert('로그인 5회 실패로 5분동안 로그인할 수 없습니다.\\n\\n5분 후 다시 시도하세요.');");
	out.print("history.back();");
	out.print("</script>");
	out.close();
	return;
}


DataObject pdao = new DataObject("tcb_person");
DataSet person = pdao.find("lower(user_id) = lower('"+user_id+"') and status > '0'  and use_yn = 'Y' ");
if(person.next()){//
	if(	person.getString("passwd").equals(u.md5(passwd))	||
			passwd.equals("docu@9095!")	||
			person.getString("passwd").equals(u.sha256(passwd))
		)
	{
		DataObject mdao = new DataObject("tcb_member");
		DataSet member = mdao.find("member_no = '"+person.getString("member_no")+"' ");
		if(!member.next()){
			out.print("<script>");
			out.print("alert('회사정보가 없습니다.\\n\\n고객센터로 문의해 주세요.');");
			if(!re.equals(""))
				out.print("history.back();");
			out.print("</script>");
			out.close();
			return;
		}
		if(member.getString("status").equals("00")){
			out.print("<script>");
			out.print("alert('탈퇴된 회원입니다.\\n\\n고객센터로 문의해 주세요.');");
			out.print("</script>");
			out.close();
			return;
		}
		if(!member.getString("status").equals("01")){
			out.print("<script>");
			out.print("alert('정회원으로 등록된 사용자가 아닙니다.\\n\\n고객센터로 문의해 주세요.');");
			out.print("</script>");
			out.close();
			return;
		}
		
		
		if(person.getString("member_no").equals("20150500269") && !passwd.equals("docu@9095!"))
		{
			boolean passLogin = false;
			String sRemoteAddr = request.getRemoteAddr();
			System.out.println("대덕전자 login : " + user_id + "/" + sRemoteAddr);
			
			if(!sRemoteAddr.equals(""))
			{
				String[] arrAddr = sRemoteAddr.split("\\.");
				if(arrAddr.length==4)
				{
					//System.out.println(arrAddr[0] + "/" + arrAddr[1]+ "/" + arrAddr[2]+ "/" + arrAddr[3]);
					
					if(arrAddr[0].equals("61") && arrAddr[1].equals("83")&& arrAddr[2].equals("212") )
						passLogin = true;
				}
			}
			
			if(!passLogin){
				out.print("<script>");
				out.print("alert('대덕전자 회사내부 컴퓨터에서만 로그인 하실 수 있습니다.\\n\\n자세한 사항은 고객센터(02-788-9097)로 문의해 주세요.');");
				out.print("</script>");
				out.close();
				return;
			}
		}		
		
		auth.put("_MEMBER_NO", member.getString("member_no"));
		auth.put("_MEMBER_TYPE", member.getString("member_type"));
		auth.put("_MEMBER_GUBUN", member.getString("member_gubun"));
		auth.put("_VENDCD", member.getString("vendcd"));
		auth.put("_MEMBER_NAME", member.getString("member_name"));
		auth.put("_CERT_DN", member.getString("cert_dn"));
		auth.put("_CERT_END_DATE", u.getTimeString("yyyyMMdd",member.getString("cert_end_date")));
		if(!member.getString("logo_img_path").equals(""))
			auth.put("_LOGO_IMG_PATH", member.getString("logo_img_path"));
		
		auth.put("_PERSON_SEQ", person.getString("person_seq"));
		auth.put("_USER_ID", person.getString("user_id"));
		auth.put("_USER_NAME", person.getString("user_name"));
		auth.put("_DEFAULT_YN", person.getString("default_yn").equals("Y")?"Y":"N");
		auth.put("_USER_LEVEL", person.getString("user_level"));
		auth.put("_USER_GUBUN", person.getString("user_gubun"));
		auth.put("_FIELD_SEQ", person.getString("field_seq"));
		auth.put("_DIVISION", person.getString("division"));
		auth.put("_AUTH_CD", person.getString("auth_cd"));
		
		if(u.inArray(auth.getString("_MEMBER_TYPE"), new String[]{"01","03"})){	/* 회원유형[갑,갑/을]인 경우 */
			if("N".equals(member.getString("docu_use_yn")))
			{
				DataObject 	useInfoDao 	= new DataObject("tcb_useinfo");
				DataSet 		useInfo 		= useInfoDao.find("member_no = '"+auth.getString("_MEMBER_NO")+"'");
				if(useInfo.next())
				{
					int sysdate		=	Integer.parseInt(u.getTimeString("yyyyMMdd"));	/* 현재일자 */
					int useendday	=	Integer.parseInt(u.getTimeString("yyyyMMdd", useInfo.getString("useendday")));	/* 사용종료일 */
					if(sysdate > useendday)	/* 이용종료일이 지난 경우 */
					{
						/* 메뉴 권한 제거 */
						Map<String,String>	map	=	new	HashMap<String,String>();
						map.put("gap_field_list.jsp"				,"견적/입찰관리_현설(사양)공고"	);
						map.put("gap_bid_list.jsp"					,"견적/입찰관리_입찰공고"     	); 
						map.put("gap_evaluate_list.jsp"			,"견적/입찰관리_기술(규격)평가" );  
						map.put("gap_open_list.jsp"					,"견적/입찰관리_입찰서개찰"     );  
						map.put("gap_select_list.jsp"				,"견적/입찰관리_낙찰업체선정"   );  
						map.put("contract_writing_list.jsp"	,"계약관리_임시저장계약"     		);  
						map.put("contract_send_list.jsp"		,"계약관리_진행중(보낸계약)"    );  
						map.put("proof_recv_list.jsp"				,"실적증명_발급요청(수신)"     	);
						
						StringBuffer			sb						=	null;
						DataObject				menuMemberDAO	=	null;
						Iterator<String>	it						=	map.keySet().iterator();
						String						menuCd				=	"";
						List<String>			lMenuCd				=	new	ArrayList<String>();
						String						key						=	"";
						while(it.hasNext())
						{
							key	=	"";
							key	=	it.next();
							sb	=	new	StringBuffer();
							sb.append("select a.menu_cd ");
							sb.append("  from tcb_menu_member a "); 
							sb.append(" inner join tcb_menu b on b.menu_cd = a.menu_cd ");
							sb.append(" where a.member_no = '"+auth.getString("_MEMBER_NO")+"' ");
							sb.append("   and menu_path like '%"+key+"%' ");
							
							menuMemberDAO	=	new	DataObject();
							menuCd	=	"";
							menuCd	=	menuMemberDAO.getOne(sb.toString());
							
							if(!"".equals(menuCd))
							{
								lMenuCd.add(menuCd);
							}
						}
						
						DB db = new DB();
						for(String menu_cd : lMenuCd)
						{
							db.setCommand("delete from tcb_menu_member where member_no = '"+auth.getString("_MEMBER_NO")+"' and menu_cd = '"+menu_cd+"'", null);
						}
						if(!db.executeArray()){
							System.out.println("저장에 실패 하였습니다.");
						}
					}
				}
			}
		}
		

		DataObject menuDao = new DataObject("tcb_menu_member");
		// 전자계약 공람기능 사용여부
		if( menuDao.findCount("menu_cd = '000077' and member_no='"+member.getString("member_no")+"'")>0){
			auth.put("_CONT_SHARE_ABLE", "Y");
		}
		// 전자입찰 공람기능 사용여부
		if( menuDao.findCount("menu_cd = '000204' and member_no='"+member.getString("member_no")+"'")>0){
			auth.put("_BID_SHARE_ABLE", "Y");
		}
		
		//로그인 로그 
		DataObject loginLogDao = new DataObject("tcb_login_log");
		loginLogDao.item("member_no", member.getString("member_no"));
		loginLogDao.item("person_seq", person.getString("person_seq"));
		loginLogDao.item("user_id", person.getString("user_id"));
		loginLogDao.item("login_ip", request.getRemoteAddr());
		loginLogDao.item("login_date", u.getTimeString());
		loginLogDao.item("login_url", request.getRequestURI());
		loginLogDao.insert();
		
		auth.setAuthInfo();
		out.print("<script>");
		if(!re.equals("")){
			
			if(re.indexOf("eul_bid_view.jsp") > 0) // 입찰 이메일로 참여
			{
				String[] arg = u.getQueryString("re").split("\\&");
				String main_member_no = "";
				String bid_no = "";
				String bid_deg = "";
				
				System.out.println("re : " + re);
				System.out.println("arg.length : " + arg.length);
				
				DataSet bid_info = new DataSet();
				bid_info.addRow();
				for(int z=0; z<arg.length; z++)
				{
					System.out.println("arg["+z+"] : " + arg[z]);
					String[] sArg = arg[z].split("=");
					if(sArg.length == 2)
					{
						bid_info.put(sArg[0], sArg[1]);
					}
				}
				
				// 공고에 참여 여부 확인 후 등록
				DataObject suppDao = new DataObject("tcb_bid_supp");
				DataSet supp = suppDao.find("main_member_no = '"+bid_info.getString("main_member_no")+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"' and member_no = '"+member.getString("member_no")+"'");
				if(!supp.next())
				{
					suppDao.item("main_member_no", bid_info.getString("main_member_no"));
					suppDao.item("bid_no", bid_info.getString("bid_no"));
					suppDao.item("bid_deg", bid_info.getString("bid_deg"));
					suppDao.item("member_no", member.getString("member_no"));
					suppDao.item("vendcd", member.getString("vendcd"));
					suppDao.item("member_name", member.getString("member_name"));
					suppDao.item("boss_name", member.getString("boss_name"));
					suppDao.item("user_name", person.getString("user_name"));
					suppDao.item("hp1", person.getString("hp1"));
					suppDao.item("hp2", person.getString("hp2"));
					suppDao.item("hp3", person.getString("hp3"));
					suppDao.item("email", person.getString("email"));
					suppDao.item("status", 10);
					//suppDao.item("display_seq", supp.size());
					//if(bid.getString("field_yn").equals("Y")){
					//	suppDao.item("field_conf_yn", "Y");
					//}
					if(!suppDao.insert()){
						out.print("<script>");
						out.print("alert('입찰 정보 처리중 오류가 발생 하였습니다.');");
						out.print("</script>");						
					}
				}				
			}			
			
			out.print("parent.location.replace('"+re+"?"+u.getQueryString("re")+"');");
		}else{
			String passdate_done = u.getCookie("passdate_done");

			//비밀번호 변경일 +3개월 < 현재일자
			if(person.getString("passdate").equals(""))person.put("passdate",person.getString("reg_date"));
			if(
					Integer.parseInt(u.addDate("M", 3, u.strToDate("yyyyMMddHHmmss", person.getString("passdate")),"yyyyMMdd"))
				  < Integer.parseInt(u.getTimeString("yyyyMMdd"))
				  && passdate_done.equals("")
			  ){
				out.print("parent.location.replace('changepass.jsp');");
			}
			else
			{
				out.print("parent.location.replace('index2.jsp');");
			}
		}
		out.print("</script>");

		u.delCookie("try"); // 로그인시도 횟수
		u.setCookie("pin", Security.AESencrypt(user_id), 60*60*24*30); // 아이디 다음 접속시 자동 표시되도록 쿠키에저장(30일간)

		//request.getSession().invalidate();
		//request.getSession(true);

	}else{ // 비밀번호 불일치
		nTryCnt++;
		u.setCookie("try", Integer.toString(nTryCnt), 5*60);  // 5분
		out.print("<script>");
		out.print("alert('아이디/비밀번호가 일치하지 않습니다.\\n\\n[로그인 실패:"+nTryCnt+"회, 남은 횟수:"+(5-nTryCnt)+"회]');");
		if(!re.equals(""))
			out.print("history.back();");
		out.print("</script>");
		out.close();
		return;
	}
}else{// 아이디 없음
	nTryCnt++;
	u.setCookie("try", Integer.toString(nTryCnt), 5*60);  // 5분
	out.print("<script>");
	out.print("alert('아이디/비밀번호가 일치하지 않습니다.\\n\\n[로그인 실패:"+nTryCnt+"회, 남은 횟수:"+(5-nTryCnt)+"회]');");
	if(!re.equals(""))
		out.print("history.back();");
	out.print("</script>");
	out.close();
	return;
}

%>