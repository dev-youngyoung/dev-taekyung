package dao;

import nicelib.util.*;
import nicelib.db.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.*;

import org.apache.commons.configuration.ConfigurationException;

import procure.common.conf.Startup;
import procure.common.utils.StrUtil;
import crosscert.*;

public class ContFLogDao extends DataObject {

	
	public ContFLogDao() {
		this.table = "tcf_cont_log";
	}

	public ContFLogDao(String sTable) {
		this.table = sTable;
	}	
	
	
	public String makeLogSeq(String cont_no, String cont_chasu ){
		String log_seq = "";
		log_seq = this.getOne("select nvl(max(log_seq),0)+1 from tcf_cont_log where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
		return log_seq;
	}
	
	public void setInsert(DB db,String cont_no, String cont_chasu, String member_no, String person_seq,String log_etc, String sayou,String cont_status){
		ContFLogDao logDao = new ContFLogDao(); 
		this.item("cont_no", cont_no);
		this.item("cont_chasu", cont_chasu);
		this.item("log_seq", this.makeLogSeq(cont_no, cont_chasu));
		this.item("member_no", member_no);
		this.item("person_seq", person_seq);
		this.item("log_date", Util.getTimeString());
		this.item("log_etc", log_etc);
		this.item("sayou", sayou);
		this.item("cont_status", cont_status);
		this.item("status", "10");
		db.setCommand(this.getInsertQuery(), this.record);
		return;
	}

}