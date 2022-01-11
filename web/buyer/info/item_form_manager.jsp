<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String[] code_item_form = {"01=>DEPTH2[분류->명칭]","02=>DEPTH3[대분류->중분류->명칭]","03=>DEPTH4[대분류->중분류->소분류->명칭]"};

boolean bInsert = true;
String item_form_cd_10 = "";	// 견적내역양식기본값_물품
String item_form_cd_20 = "";	// 견적내역양식기본값_공사
String item_form_cd_30 = "";	// 견적내역양식기본값_용역
String build_item_yn = "";		// 재노경 분리 여부

DataObject itemformDao = new DataObject("tcb_bid_item_form_default");
DataSet itemform = itemformDao.find(" member_no = '"+_member_no+"' ");

if(itemform.next()){
	item_form_cd_10 = itemform.getString("item_form_cd_10");
	item_form_cd_20 = itemform.getString("item_form_cd_20");
	item_form_cd_30 = itemform.getString("item_form_cd_30");
	build_item_yn = itemform.getString("build_item_yn");
	bInsert = false;
}

f.addElement("item_form_cd_10", item_form_cd_10, "hname:'견적내역양식기본값_물품'");
f.addElement("item_form_cd_20", item_form_cd_20, "hname:'견적내역양식기본값_공사'");
f.addElement("item_form_cd_30", item_form_cd_30, "hname:'견적내역양식기본값_용역'");
f.addElement("build_item_yn", build_item_yn, "hname:'재노경분리여부'" );

if(u.isPost()&& f.validate()){
	itemformDao.item("item_form_cd_10", f.get("item_form_cd_10"));
	itemformDao.item("item_form_cd_20", f.get("item_form_cd_20"));
	itemformDao.item("item_form_cd_30", f.get("item_form_cd_30"));
	itemformDao.item("build_item_yn", f.get("build_item_yn"));

	if(bInsert)
	{
		itemformDao.item("member_no", _member_no);
		if(!itemformDao.insert()){
			u.jsError("저장에 실패하였습니다.");
			return;
		}
	} else {
		if(!itemformDao.update("member_no = '"+_member_no+"' ")){
			u.jsError("저장에 실패하였습니다.");
			return;
		}
	}
	u.jsAlertReplace("저장 하였습니다.", "./item_form_manager.jsp");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.item_form_manager");
p.setVar("menu_cd","000114");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000114", "btn_auth").equals("10"));
p.setLoop("code_item_form", u.arr2loop(code_item_form));
p.setVar("form_script", f.getScript());
p.display(out);
%>