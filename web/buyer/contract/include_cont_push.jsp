<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%!
private ArrayList getList_skstoa(String member_no, String contno, String cont_status)
{
	ArrayList list = new ArrayList();

	System.out.println("member_no : "+member_no);
	System.out.println("contno : "+contno);
	try{
		DataObject dao = new DataObject();
		String sql = "select * from "
				+"     (select "
				+"             tm.cont_name "
	            +"            ,tm.cont_date "
	            +"            ,tm.cont_userno "
	            +"            ,tm.cont_no "
   	            +"            ,tm.cont_chasu "
   	            +"            ,tm.reg_id "
   	            +"            ,tm.version_seq "
   	            +"            ,TO_CHAR(TO_DATE(tm.reg_date  , 'YYYYMMDD hh24:mi:ss'),'YYYY-MM-DD HH24:MI:SS')  as reg_date "
	            +"            ,status "
	            +"            ,tc.vendcd "	 
	            +"            ,(select sign_date from tcb_cust where cont_no=tm.cont_no and cont_chasu=tm.cont_chasu and member_no = tm.member_no) main_sign_date"		         
			    +"            , tm.cont_edate, template_cd, tm.cont_html"
			    + "     from tcb_contmaster tm inner join tcb_cust tc on tm.cont_no=tc.cont_no and tm.cont_chasu=tc.cont_chasu"
				+ "    where tm.member_no = '"+member_no+"'"
				+ "      and tm.member_no <> tc.member_no"
				+ "      and tm.cont_no = '" + contno +"'" 
				+ "   )"
				+ "   where status <> '00'";
		
				//System.out.println("sql : "+sql);
		DataSet ds = dao.query(sql);
		

		while(ds.next()){
			Map map = new HashMap();
			
			// 공통사항
			map.put("contName",ds.getString("cont_name"));   
			map.put("contDay",ds.getString("cont_date"));
			map.put("contNo",ds.getString("cont_no"));
			if(cont_status.equals("")){
				map.put("contStatus",ds.getString("status"));
			}else {
				map.put("contStatus", cont_status);
			}

			map.put("templateCd",ds.getString("template_cd"));
			map.put("version",ds.getString("version_seq"));
			map.put("sIdNo",ds.getString("vendcd"));
			map.put("contUrlKey",procure.common.utils.Security.AESencrypt(ds.getString("cont_no")+ds.getString("cont_chasu")));
			
			DataObject dao2 = new DataObject();
			sql ="    select "
				+"             agree_name, "
				+"             case when ag_md_date is null then agree_person_name else r_agree_person_name end as agree_person_name, "
				+"             case when ag_md_date is null then agree_person_id else r_agree_person_id end as agree_person_id, "				
				+"             case when ag_md_date is null then 0 else " 
				+"					case when mod_reason is not null then 1 else 2 end " 
				+"              end as agree_yn, "
				+"             TO_CHAR(TO_DATE(ag_md_date, 'YYYYMMDD hh24:mi:ss'),'YYYY-MM-DD HH24:MI:SS') as ag_md_date "
				+"      from tcb_cont_agree "
				+"      where cont_no = '" + ds.getString("cont_no") + "'" 
				+"        and cont_chasu = " + ds.getString("cont_chasu");		
			
			DataSet ds2 = dao2.query(sql);
			
			DataObject dao_person = new DataObject();
			String sql_person = "     select user_name from tcb_person where user_id = '" + ds.getString("reg_id") + "'";
			DataSet ds_person = dao_person.query(sql_person);
			
			String approve = "";
			
			while(ds_person.next()){	
				approve = "작성자|" + ds_person.getString("user_name") + "|" + ds.getString("reg_id") + "|1|" + ds.getString("reg_date") + "^";
			}
			
			while(ds2.next()){							
					approve += ds2.getString("agree_name") + "|" + ds2.getString("agree_person_name") + "|" + ds2.getString("agree_person_id")
					         + "|" + ds2.getString("agree_yn") + "|" + ds2.getString("ag_md_date") + "|^";								
			}
			map.put("Approve",approve);				
				
			JsoupUtil jsoupUtil = new JsoupUtil(ds.getString("cont_html"));
						
			if(ds.getString("template_cd").equals("2015001"))
			{
				map.put("entpCode", jsoupUtil.getValue("cust_code","^"));
			} else if(ds.getString("template_cd").equals("2015016"))  { // 청구서
				map.put("entpCode",jsoupUtil.getValue("cust_code","^"));
				map.put("req_month",jsoupUtil.getValue("req_month","^"));
				map.put("req_count",jsoupUtil.getValue("req_count","^"));
			}else if(Util.inArray(ds.getString("template_cd"), new String[]{"2019017", "2019018","2020192"})) { // PGM)SK스토아 판매계약서[혼합수수료], 위수탁수수료
				map.put("entpCode",jsoupUtil.getValue("b_t1","^"));
			}else{
				map.put("entpCode",jsoupUtil.getValue("t1","^"));	
			}
			map.put("goodsCode",jsoupUtil.getValue("t2","^"));

			map.put("seqFrameNo",jsoupUtil.getValue("seqFrameNo","^")); // 편성코드
			map.put("bDate",jsoupUtil.getValue("b_date","^")); // 방송일시


			list.add(map);
		}
					
		
		
   }catch(Exception e){
	   System.out.println(e.toString());
   }
   return list;
}

public DataSet contPush_skstoa(String cont_no , String cont_chasu){
	return contPush_skstoa(cont_no, cont_chasu,"");
}


public DataSet contPush_skstoa(String cont_no , String cont_chasu, String cont_status){
	System.out.println("contPush_skstoa START cont_no:"+cont_no+"-"+cont_chasu+", cont_status:"+cont_status);
	DataSet result = new DataSet();
	result.addRow();
	
	DataObject contDao = new DataObject("tcb_contmaster");
	//contDao.setDebug(out);
	DataSet cont = contDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
	if(!cont.next()){
		result.put("succ_yn","N");
		result.put("err_msg", "계약정보가 없습니다.");
		return result;
	}

	ArrayList list = getList_skstoa(cont.getString("member_no"), cont_no, cont_status);

	System.out.println("list================================="+list);
	JSONArray json = JSONArray.fromObject(list);

	System.out.println(json);	

	Http hp = new Http();

	if(json.toString().indexOf("1234567891") > 0) {
		System.out.println("http://1.255.85.244:8081/front/nicedocu/contract-progress");
		hp.setUrl("http://1.255.85.244:8081/front/nicedocu/contract-progress");
	} else { 
		System.out.println("http://api.bshopping.co.kr/front/nicedocu/contract-progress");
		hp.setUrl("http://api.bshopping.co.kr/front/nicedocu/contract-progress");
	}

	//hp.setEncoding("UTF-8");
	hp.setEncoding("UTF-8");
	hp.setContentType("application/json");
	try {
		String ret = hp.sendSkbroadband(cont.getString("template_cd"),json,cont.getString("template_cd").equals("2015016")?true:false);
		System.out.println("리턴[" + ret + "]");
		String code = ret.replace("%22", "\"");				

		if(!code.equals("")){
			JSONObject retJSON2 = JSONObject.fromObject(code);
			
			if(retJSON2.getString("retCode").equals("1")) {
				System.out.println("전송 성공");
			} else {			
				System.out.println("전송 실패");
				result.put("succ_yn","N");
				result.put("err_msg", "skstora error : "+retJSON2.getString("retMsg"));
				return result;
			}
		}
		result.put("succ_yn","Y");
		result.put("err_msg", "");
	} catch(Exception ex) {
		System.out.println("에러:" + ex.getMessage());        
		result.put("succ_yn","N");
		result.put("err_msg", "계약서 상태값 전송 중 오류가 발생 하였습니다.");
		return result;
	}
	System.out.println("contPush_skstoa END cont_no:"+cont_no+"-"+cont_chasu+", cont_status:"+cont_status);
	return result;
}

public DataSet contPush_earlypay(String cont_no , String cont_chasu){
	DataSet result = new DataSet();
	result.addRow();

	String connect_module = "/application/nicesh/earlypay.sh";

	try {
		String buffer = null;
		String ret = "";
		JSONObject retJSON = null;
		String[] cmd = null;
	
		DataObject contDao = new DataObject("tcb_contmaster");
		//contDao.setDebug(out);
		DataSet cont = contDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "cont_html, status, member_no");
		if(!cont.next()){
			result.put("succ_yn","N");
			result.put("err_msg", "계약정보가 존재 하지 않습니다.");
			return result;
		}
		
	    String loan_id = "";
	    String request_amount = "";
        String connServer = "";

        if(cont.getString("member_no").equals("20180101074")) {// 피플펀드
            connServer = "https://earlypay-admin.peoplefund.co.kr";
        } else {  // 펀다 (20180101078), 얼리페이(20181200231) 유한회사 위커머스(20181201402)
            connServer = "https://earlypay.funda.kr";
        }

		JsoupUtil jsoupUtil = new JsoupUtil(cont.getString("cont_html"));
		loan_id = jsoupUtil.getValue("loan_id");
		request_amount = jsoupUtil.getValue("request_amount");
		System.out.println("loan_id : " + loan_id);
		System.out.println("request_amount : " + request_amount);
		if(!loan_id.equals("")) {
			if (cont.getString("status").equals("30")) {
				cmd = new String[]{connect_module, "S", connServer, loan_id, request_amount.replaceAll(",", "")};
			} else if (cont.getString("status").equals("50")) {
				cmd = new String[]{connect_module, "E", connServer, loan_id, ""};
			}
		} else {
			result.put("succ_yn","Y");
			result.put("err_msg", "연동 전 작성 계약서라 PUSH 하지 않음.");
			return result;
		}
	
	
		Process process = new ProcessBuilder(cmd).start();
		BufferedReader stdOut = new BufferedReader( new InputStreamReader(process.getInputStream()) );
	
		// 표준출력 상태를 출력
		while( (buffer = stdOut.readLine()) != null ) {
			ret += buffer;
		}
		System.out.println("ret : "+ret);
	
		if(ret.indexOf("{") < -1) {
			result.put("succ_yn","Y");
			result.put("err_msg", "Earlypay와 통신중 에러가 발생했습니다..\\n\\n[Error message] invalid value");
			return result;
		}
		retJSON = JSONObject.fromObject(ret.substring(ret.indexOf("{")));  // json 값만 가져오기
		System.out.println("retJSON - "+retJSON);
	
		if(ret.indexOf("message") > 0) {// 에러 메시지
			String message = retJSON.getString("message");
			System.out.println("earypay 에러 :" + message);
		}
	
	} catch(Exception ex) {
		result.put("succ_yn","N");
		result.put("err_msg", "Earlypay와 통신중 에러가 발생했습니다.\\n\\n[Error message] " + ex.getMessage());
		return result;
	}

	result.put("succ_yn","Y");
	result.put("err_msg", "");
	return result;
}


	public DataSet contPush_gtp(String cont_no , String cont_chasu){
		DataSet result = new DataSet();
		result.addRow();
		String salt_key = "20181002679";
		try {
			String buffer = null;
			String ret = "";
			JSONObject retJSON = null;
			String[] cmd = null;

			DataObject contDao = new DataObject("tcb_contmaster");
			//contDao.setDebug(out);
			DataSet cont = contDao.query(
				  " select "
				+ "       a.cont_no||a.cont_chasu NO_CONT "
				+ "     , decode(a.template_cd, '2018230','10','2018231','20','2018229','30') CD_CONT_TYPE"  //10: 물품/20: 공사/30: 용역
				+ "     , a.cont_name  NM_CONT "
				+ "     , a.cont_date DT_CONT "
				+ "     , a.cont_sdate DT_SUPPLY_FR "
				+ "     , a.cont_edate DT_SUPPLY_TO "
				+ "     , substr(cont_date,0,4)YY_ACCT "
				+ "     , a.cont_total AM_CONT "
				+ "     , b.vendcd NO_COMPANY "
				+ "     , b.member_name NM_PARTNER "
				+ "     , b.boss_name NM_CEO "
				+ "     , b.user_name NM_PTR "
				+ "     , b.tel_num NO_TEL "
				+ "     , b.hp1||'-'||b.hp2||'-'||b.hp3  NO_MOBIL "
				+ "     , b.email E_MAIL "
				+ "     , b.address ADS_HD "
				+ "  from tcb_contmaster a, tcb_cust b "
				+ " where a.cont_no = b.cont_no "
				+ "   and a.cont_chasu = b.cont_chasu "
				+ "   and b.list_cust_yn = 'Y' "
				+ "   and a.member_no = '20181002679' "
				+ "   and a.template_cd in ('2018229','2018230','2018231') "
				+ "  and a.status = '50' "
				+ "  and a.cont_no = '"+cont_no+"' "
				+ "  and a.cont_chasu = '"+cont_chasu+"' "
			);
			if(!cont.next()) {
				result.put("succ_yn", "N");
				result.put("err_msg", "계약정보가 존재 하지 않습니다.");
				return result;
			}

			Security security = new Security();
			String enc_str = security.SHA256encrypt(cont.getString("no_cont"), salt_key);
			System.out.println("enc_str=>"+enc_str);
			Http http = new Http("http://110.93.26.52:8888/data_recv.jsp");
			//Http http = new Http("http://localhost:8080/data_recv.jsp");
			http.setParam("enc_str", enc_str);
			http.setParam("no_cont", cont.getString("no_cont"));
			http.setParam("cd_cont_type", cont.getString("cd_cont_type"));
			http.setParam("nm_cont", cont.getString("nm_cont"));
			http.setParam("dt_cont", cont.getString("dt_cont"));
			http.setParam("dt_supply_fr", cont.getString("dt_supply_fr"));
			http.setParam("dt_supply_to", cont.getString("dt_supply_to"));
			http.setParam("yy_acct", cont.getString("yy_acct"));
			http.setParam("am_cont", cont.getString("am_cont"));
			http.setParam("no_company", cont.getString("no_company"));
			http.setParam("nm_partner", cont.getString("nm_partner"));
			http.setParam("nm_ceo", cont.getString("nm_ceo"));
			http.setParam("nm_ptr", cont.getString("nm_ptr"));
			http.setParam("no_tel", cont.getString("no_tel"));
			http.setParam("no_mobil", cont.getString("no_mobil"));
			http.setParam("e_mail", cont.getString("e_mail"));
			http.setParam("ads_hd", cont.getString("ads_hd"));
			http.timeOut = 10 * 1000;
			String rtn = http.send("POST");
			System.out.println("rtn = > ["+rtn+"]");
			if(!rtn.trim().equals("success")){
				result.put("succ_yn","N");
				result.put("err_msg", "경기테크노파크와 연동에 실패하였습니다.\\n\\n[Error message] " + rtn);
				return result;
			}

		}catch(Exception e){
			result.put("succ_yn","N");
			result.put("err_msg", "경기테크노파크와 통신중 에러가 발생했습니다.\\n\\n[Error message] " + e.getMessage());
			return result;
		}

		result.put("succ_yn","Y");
		result.put("err_msg", "");
		return result;
	}


%>