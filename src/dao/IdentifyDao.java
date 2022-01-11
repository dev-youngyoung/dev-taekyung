package dao;

import nicelib.db.DB;
import nicelib.db.DataObject;
import nicelib.db.DataSet;
import nicelib.util.Util;

public class IdentifyDao extends DataObject {

	public IdentifyDao() {
		this.table = "tcb_identify_log";
	}

	public IdentifyDao(String sTable) {
		this.table = sTable;
	}	

	public String makeLogSeq(){
		String log_seq = "";
		log_seq = this.getOne("select to_char(SYSDATE,'YYYYMMDD') || lpad(  nvl( max( to_number( substr( log_seq,9 ) ) ), 0 )+1, 5,'0' ) from " +this.table+ " where log_date like to_char(SYSDATE, 'YYYYMMDD')||'%' ");
		return log_seq;
	}
	
	public void setInsert(String log_type, String cont_no, String cont_chasu, String member_no, String content, String etc){
        this.item("log_seq", this.makeLogSeq());
        this.item("log_type", log_type);
        this.item("cont_no", cont_no);
        this.item("cont_chasu", cont_chasu);
        this.item("member_no", member_no);
        this.item("content", content);
        this.item("log_date", Util.getTimeString());
        this.item("etc", etc);
        this.item("status", "10");
        this.insert();
    }

	public void setInsert(DB db, String log_type, String cont_no, String cont_chasu, String member_no, String content, String etc){
		this.item("log_seq", this.makeLogSeq());
		this.item("log_type", log_type);
		this.item("cont_no", cont_no);
		this.item("cont_chasu", cont_chasu);
		this.item("member_no", member_no);
		this.item("content", content);
		this.item("log_date", Util.getTimeString());
		this.item("log_etc", etc);
		this.item("status", "10");
		db.setCommand(this.getInsertQuery(), this.record);
		return;
	}
	
	
	public void setInsert(DB db, DataSet dataSet){
		this.item("log_seq", this.makeLogSeq());
		this.item("log_type", dataSet.getString("log_type"));
		this.item("cont_no", dataSet.getString("cont_no"));
		this.item("cont_chasu", dataSet.getString("cont_chasu"));
		this.item("member_no", dataSet.getString("member_no"));
		this.item("content", dataSet.getString("content"));
		this.item("log_date", dataSet.getString("log_date"));
		
		if("".equals(dataSet.getString("log_date"))){
			this.item("log_date", Util.getTimeString());
		}
		
		if("tcb_identify_log".equals(this.table)){
			this.item("etc", dataSet.getString("etc"));
			this.item("status", dataSet.getString("status"));
		}
		
		
		// 가맹 전용 컬럼
		if("tcf_identify_log".equals(this.table)){
			this.item("log_etc", dataSet.getString("log_etc"));
			this.item("fc_member_no", dataSet.getString("fc_member_no"));
			this.item("brand_seq", dataSet.getString("brand_seq"));
		}

		db.setCommand(this.getInsertQuery(), this.record);
		return;
	}

}