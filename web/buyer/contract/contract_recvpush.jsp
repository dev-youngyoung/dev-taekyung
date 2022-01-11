<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="org.jsoup.Jsoup" %>
<%@ page import  = " org.jsoup.nodes.Document,
		        	  org.jsoup.nodes.Element,
					  org.jsoup.select.Elements
"%>
<%!
public String getJsoupValue(Document document, String name){
	String value = "";
	Elements elements = document.getElementsByAttributeValue("name", name);
	for(Element element: elements){
		value = element.attr("value");
	}
	return value;
}

public String getJsoupValueSkbroadband(Document document, String name){
	String value = "";
	Elements elements = document.getElementsByAttributeValue("name", name);
	int i=0;

	for(Element element: elements){
		if(i > 0) value += "^";
		if(element.nodeName().equals("textarea"))
		{
			value += element.text();
		}
		else
		{
			value += element.attr("value");
		}
		i++;
	}
	return value;
}

private ArrayList getList(String member_no, String contno)
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
			map.put("contStatus",ds.getString("status"));
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
				
			Document document = Jsoup.parse(ds.getString("cont_html"));			
						
			if(ds.getString("template_cd").equals("2015001"))
			{
				map.put("entpCode",getJsoupValueSkbroadband(document,"cust_code"));
			}
			else if(ds.getString("template_cd").equals("2015016")) // 청구서
			{
				map.put("entpCode",getJsoupValueSkbroadband(document,"cust_code"));
				map.put("req_month",getJsoupValueSkbroadband(document,"req_month"));
				map.put("req_count",getJsoupValueSkbroadband(document,"req_count"));
			}
			else{
				map.put("entpCode",getJsoupValueSkbroadband(document,"t1"));	
			}
			map.put("goodsCode",getJsoupValueSkbroadband(document,"t2"));

			map.put("seqFrameNo",getJsoupValueSkbroadband(document,"seqFrameNo")); // 편성코드
			map.put("bDate",getJsoupValueSkbroadband(document,"b_date")); // 방송일시
			
			list.add(map);
		}
					
		
		
   }catch(Exception e){
	   System.out.println(e.toString());
   }
   return list;
}
%>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'  and status in ('20','21','30','40','41') ",
"tcb_contmaster.*"
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null  and sign_seq > 10 ) chain_unsign_cnt "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null and sign_seq <= 10 ) unsign_cnt "
+" ,(select member_name from tcb_member where member_no = tcb_contmaster.mod_req_member_no ) mod_req_name "
);
if(!cont.next()){
	u.jsError("계약정보가 존재 하지 않습니다.");
	return;
}

ArrayList list = getList(cont.getString("member_no"), cont_no);

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

hp.setEncoding("UTF-8");
hp.setContentType("application/json");
try {
	String ret = hp.sendSkbroadband(cont.getString("template_cd"),json,cont.getString("template_cd").equals("2015016")?true:false);
	System.out.println("리턴[" + ret + "]");
	String code = ret.replace("%22", "\"");				

	if(!code.equals(""))
	{
		JSONObject retJSON2 = JSONObject.fromObject(code);
		
		if(retJSON2.getString("retCode").equals("1")) {
			if(cont.getString("status").equals("50")){
				u.jsAlertReplace("전자서명이 완료 되었습니다.","contend_recvview.jsp?"+u.getQueryString());	
			}
			else{
				u.jsAlertReplace("전자서명 처리 되었습니다.","contract_recvview.jsp?"+u.getQueryString());	
			}
			
			String[] arr_auto_sign = {
					 "20171101813|2019015" //PGM)SK스토아 광고방송 계약서[DB건별]
					,"20171101813|2019016" //PGM)SK스토아 광고방송 계약서[정액방송]
					,"20171101813|2019017" //PGM)SK스토아 판매계약서[혼합수수료]
					,"20171101813|2019018" //PGM)SK스토아 판매계약서[위수탁수수료]
					,"20171101813|2020192" //PGM)SK스토아 판매방송계약서[특약혼합매입]
					};
			if(u.inArray(cont.getString("member_no")+"|"+cont.getString("template_cd"), arr_auto_sign) ) {
				u.redirect("contract_auto_sign.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu);
			}
			System.out.println("전송 성공");  				
		} else {
			u.jsErrClose(retJSON2.getString("retMsg"));
			//u.jsAlert(retJSON2.getString("retMsg"));
			System.out.println("전송 실패");				
		}
	}
} catch(Exception ex) {
	System.out.println("에러:" + ex.getMessage());        
	u.jsError("전자서명값 전송 중 오류가 발생 하였습니다.");
	return;
}



%>