package dao;

import nicelib.db.DB;
import nicelib.db.DataObject;
import nicelib.util.Util;

public class EmailDao extends DataObject {

	
	public EmailDao() {
		this.table = "tcc_email";
	}
	
	public EmailDao(String table) {
		this.table = table;
	}
	
	public boolean insertMail(String system_id,String receiver_email, String receiver_name, String title, String mail_content, String send_level) throws Exception{
		return insertMail(system_id, receiver_email, receiver_name, title, mail_content, Util.getTimeString() , send_level, null, null);
	}
	
	public boolean insertMail(String system_id,String receiver_email, String receiver_name, String title, String mail_content, String send_req_date,String send_level, String etc1, String etc2) throws Exception{
		if(system_id ==null || receiver_email == null || title == null|| mail_content == null|| send_req_date == null || send_level == null){
			this.setError("필수값이 없습니다.");
			return false;
		}
		if(system_id.equals("") || receiver_email.equals("") || title.equals("")|| mail_content.equals("")|| send_req_date.equals("")|| send_level.equals("")){
			this.setError("필수값이 없습니다.");
			return false;
		}
		
		String query = ""; 
		query+=" INSERT INTO tcc_email (";
		query+=" 		  email_seq";
		query+=" 		, system_id";
		query+=" 		, title";
		query+=" 		, receiver_email";
		query+=" 		, receiver_name";
		query+=" 		, mail_content";
		query+=" 		, send_req_date";
		query+=" 		, send_level";
		query+=" 		, select_yn";
		query+=" 		, reg_date";
		if(etc1!=null)	query+=", etc1";
		if(etc2!=null)	query+=", etc2";
		query+=" 		) VALUES (";
		query+=" 		  tcc_email_seq.nextval";
		query+=" 		, $system_id$";
		query+=" 		, $title$";
		query+=" 		, $receiver_email$";
		query+=" 		, $receiver_name$";
		query+=" 		, $mail_content$";
		query+=" 		, $send_req_date$";
		query+=" 		, $send_level$";
		query+=" 		, $select_yn$";
		query+=" 		, $reg_date$";
		if(etc1!=null)	query+=", $etc1$";
		if(etc2!=null)	query+=", $etc2$";
		query+=" 		)       ";
		
		DataObject emailDao = new DataObject("tcc_email");
		emailDao.item("system_id", system_id);
		emailDao.item("receiver_email", receiver_email);
		emailDao.item("receiver_name", receiver_name);
		emailDao.item("title", title);
		emailDao.item("mail_content", mail_content);
		emailDao.item("send_req_date", send_req_date);
		emailDao.item("send_level", send_level);
		emailDao.item("select_yn", "N");
		if(etc1!=null) emailDao.item("etc1", etc1);
		if(etc2!=null) emailDao.item("etc2", etc2);
		emailDao.item("reg_date", Util.getTimeString());
		DB db = new DB();
		db.setCommand(query, emailDao.record);
		if(!db.executeArray()){
			this.setError(db.getError());
			return false;
		}
		return true;
	}
}