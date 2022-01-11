package dao;

import nicelib.db.DB;
import nicelib.db.DataObject;
import nicelib.util.Util;

public class ContBLogDao extends DataObject {

	public ContBLogDao() {
		this.table = "tcb_cont_log";
	}

	public ContBLogDao(String sTable) {
		this.table = sTable;
	}	

	public String makeLogSeq(String cont_no, String cont_chasu ){
		String log_seq = "";
		log_seq = this.getOne("select nvl(max(log_seq),0)+1 from tcb_cont_log where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
		return log_seq;
	}
	
	public void setInsert(DB db, String cont_no, String cont_chasu, String member_no, String person_seq, String user_name, String log_ip, String log_etc, String sayou, String cont_status, String log_level){
		this.item("cont_no", cont_no);
		this.item("cont_chasu", cont_chasu);
		this.item("log_seq", this.makeLogSeq(cont_no, cont_chasu));
		this.item("member_no", member_no);
		this.item("person_seq", person_seq);
		this.item("user_name", user_name);
		this.item("log_ip", log_ip);
		this.item("log_date", Util.getTimeString());
		this.item("log_etc", log_etc);
		this.item("sayou", sayou);
		this.item("cont_status", cont_status);
		this.item("status", "10");
		this.item("log_level", log_level);
		db.setCommand(this.getInsertQuery(), this.record);
		return;
	}

	public void setInsert(String cont_no, String cont_chasu, String member_no, String person_seq, String user_name, String log_ip, String log_etc, String sayou, String cont_status, String log_level){
		this.item("cont_no", cont_no);
		this.item("cont_chasu", cont_chasu);
		this.item("log_seq", this.makeLogSeq(cont_no, cont_chasu));
		this.item("member_no", member_no);
		this.item("person_seq", person_seq);
		this.item("user_name", user_name);
		this.item("log_ip", log_ip);
		this.item("log_date", Util.getTimeString());
		this.item("log_etc", log_etc);
		this.item("sayou", sayou);
		this.item("cont_status", cont_status);
		this.item("status", "10");
		this.item("log_level", log_level);
		this.insert();
		return;
	}
	
	public void setInsert(DB db, String cont_no, String cont_chasu, String member_no, String person_seq, String user_name, String log_ip, String log_etc, String sayou, String cont_status, String log_level, String log_seq){
		this.item("cont_no", cont_no);
		this.item("cont_chasu", cont_chasu);
		this.item("log_seq", log_seq);
		this.item("member_no", member_no);
		this.item("person_seq", person_seq);
		this.item("user_name", user_name);
		this.item("log_ip", log_ip);
		this.item("log_date", Util.getTimeString());
		this.item("log_etc", log_etc);
		this.item("sayou", sayou);
		this.item("cont_status", cont_status);
		this.item("status", "10");
		this.item("log_level", log_level);
		db.setCommand(this.getInsertQuery(), this.record);
		return;
	}
}