package dao;

import nicelib.db.DataObject;

public class AuthDao extends DataObject {

	public String auth_menu_json = "";

	public AuthDao(String table) {
		this.table = table;
	}

	public String getAuthMenuInfoK(String member_no, String auth_cd , String menu_cd,String column) {
		DataObject authMenuDao = new DataObject("tck_auth_menu");
		String info = authMenuDao.getOne("select "+column+" from tck_auth_menu where member_no = '"+member_no+"' and auth_cd = '"+auth_cd+"' and menu_cd = '"+menu_cd+"' ");
		return info;
	}

	public String getAuthMenuInfoB(String member_no, String auth_cd , String menu_cd,String column) {
		DataObject authMenuDao = new DataObject("tcb_auth_menu");
		String info = authMenuDao.getOne("select "+column+" from tcb_auth_menu where member_no = '"+member_no+"' and auth_cd = '"+auth_cd+"' and menu_cd = '"+menu_cd+"' ");
		return info;
	}

	public String getAuthMenuInfoB(String member_no, String auth_cd , String menu_cd,String column, String field_seq) {
		DataObject authMenuDao = new DataObject("tcb_auth_menu");
		String info = authMenuDao.getOne("select "+column+" from tcb_auth_field where member_no = '"+member_no+"' and auth_cd = '"+auth_cd+"' and menu_cd = '"+menu_cd+"' and field_seq = '"+field_seq+"' ");
		if(info.equals("")) {
			info = authMenuDao.getOne("select "+column+" from tcb_auth_menu where member_no = '"+member_no+"' and auth_cd = '"+auth_cd+"' and menu_cd = '"+menu_cd+"' ");
		}
		return info;
	}

	// 2019.06.26 dskim 근로계약용 추가
	public String getAuthMenuInfoW(String member_no, String auth_cd , String menu_cd,String column) {
		DataObject authMenuDao = new DataObject("tcw_auth_menu");
		String info = authMenuDao.getOne("select "+column+" from tcw_auth_menu where member_no = '"+member_no+"' and auth_cd = '"+auth_cd+"' and menu_cd = '"+menu_cd+"' ");
		return info;
	}

}
