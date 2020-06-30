<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

f.addElement("s_member_name", null, null);
f.addElement("s_member_no", null, null);
f.addElement("s_template_name", null, null);

ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setFields(
		 "  a.template_cd "
		+", nvl(a.display_name,a.template_name) template_name"
		+", a.member_no "
		+", a.use_yn "
		+", b.member_name "
		+", (select count(cont_no)                     "
		+"	  from tcb_contmaster                      "
		+"	 where template_cd = a.template_cd         "
		+"	   and member_no not in (                  "
		+"			   select member_no                "
		+"			     from tcb_member               "
		+"			    where member_name like '%테스트%'"
		+"			                 )                 "
		+"  ) cont_cnt                                 "
		);
list.setTable("tcb_cont_template a, tcb_member b");
list.addWhere(" template_cd <> '9999999' ");
list.addWhere(" a.member_no = b.member_no(+)");
list.addSearch("nvl(a.display_name,a.template_name)", f.get("s_template_name"), "LIKE");
list.addSearch("a.member_no", f.get("s_member_no"), "LIKE");
list.setOrderBy("a.template_cd desc");

DataSet ds = list.getDataSet();

DataObject memberDao = new DataObject("tcb_member");
while(ds.next()){
	ds.put("use_yn", ds.getString("use_yn").equals("Y")?"사용":"미사용");
	ds.put("cont_cnt", u.numberFormat(ds.getString("cont_cnt")));
	if(!ds.getString("member_no").equals("")&&ds.getString("member_name").equals("")){
		String[] member_nos = ds.getString("member_no").split(",");
		String member_no = "";
		for(int i = 0 ; i < member_nos.length; i++){
			if(!member_no.equals("")) member_no+=",";
			member_no+= "'"+member_nos[i]+"'" ;
		}
		
		String member_name = memberDao.getOne(
				 " select listagg(member_name,',') within group(order by member_name) "
				+"   from tcb_member                                                  "
				+"  where member_no in ("+member_no+")                                "
				);
		ds.put("member_name", member_name);
	}
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("buyer.cont_template_list");
p.setVar("menu_cd", "000055");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("template_cd"));
p.setVar("form_script",f.getScript());
p.display(out);
%>