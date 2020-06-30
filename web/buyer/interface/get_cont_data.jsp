<%@page import="java.net.URLEncoder"%>
<%@page import="gui.ava.html.image.generator.HtmlImageGenerator"%>
<%@page import="nicednb.Client"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
/**
외부업체 데이터 연동용

vcd : 사업자번호
key : 키값 ()
dat : 기준날짜(YYYYMMDD) (예:수정날짜)

*/
System.out.println(request.getRequestURL()+"?"+request.getQueryString());
DataSet rdata = new DataSet();
rdata.addRow();
rdata.put("result_code","10");
rdata.put("result_msg", "success");

String i_vendcd = u.request("i_vendcd");
String i_key = u.request("i_key");
String s_date = u.request("s_date");
String s_cont_status = u.request("s_cont_status");

DataSet request_info = new DataSet();
request_info.addRow();
request_info.put("reuqest_url:",request.getRequestURL());
request_info.put("i_vendcd", i_vendcd);
request_info.put("i_key", i_key);
request_info.put("s_date", s_date);
request_info.put("s_cont_status", s_cont_status);
rdata.put(".request_info", request_info);

if(i_vendcd.length()!=10 || s_date.length()!=8 ||s_cont_status.length()!=2){
	rdata.put("result_code","90");
	rdata.put("result_msg", "Parameter Verification failure!!");
	
	response.setContentType("application/json; charset=UTF-8");
	out.clearBuffer();
	out.print(u.loop2json(rdata));
	return;
}

if(!u.isPost()){
	rdata.put("result_code","90");
	rdata.put("result_msg", "http request method post only!!");
	
	response.setContentType("application/json; charset=UTF-8");
	out.clearBuffer();
	out.print(u.loop2json(rdata));
	return;
}

String client_key = "";

String _member_no = "";

Client cs = new Client();
if(i_vendcd.equals("1208765763")){  //// 우아한형제들
	
	client_key = cs.getClientKey("www.woowahan.com");
	_member_no = "20190300598";
	
}else{
	rdata.put("result_code","90");
	rdata.put("result_msg", "No Permission!!");
	
	response.setContentType("application/json; charset=UTF-8");
	out.clearBuffer();
	out.print(u.loop2json(rdata));
	return;
}


DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	rdata.put("result_code","90");
	rdata.put("result_msg", "No company information!!");
	
	response.setContentType("application/json; charset=UTF-8");
	out.clearBuffer();
	out.print(u.loop2json(rdata));
	return;
}


String[] code_stamp_img = {
		"10=>pdf_watermark_edit.gif"
		,"11=>pdf_watermark_progress.gif"
		,"12=>pdf_watermark_progress.gif"
		,"20=>pdf_watermark_progress.gif"
		,"21=>pdf_watermark_progress.gif"
		,"30=>pdf_watermark_progress.gif"
		,"40=>pdf_watermark_progress.gif"
		,"41=>pdf_watermark_progress.gif"
		,"50=>pdf_watermark_finish.gif"
		,"90=>pdf_watermark_cancel.gif"
		,"91=>pdf_watermark_cancel.gif"
		,"99=>pdf_watermark_disuse.gif"
		};
String stamp_path = Startup.conf.getString("dir")+"/web/buyer/html/images/stamp/contract/";


if(!i_key.equals(client_key))
{
	out.print("Certfication Key Error!!");
	return;
}

DataObject contDao = new DataObject("tcb_contmaster");
DataObject custDao = new DataObject("tcb_csut");
DataObject cfileDao = new DataObject("tcb_cfile");

DataSet cont = contDao.query(
 "    select a.cont_no "
+"         , a.cont_chasu "
+"         , a.template_cd "
+"         , a.cont_userno "
+"         , a.cont_name "
+"         , a.cont_date "
+"         , a.cont_sdate "
+"         , a.cont_edate "
+"         , a.cont_total "
+"         , a.true_random "
+"         , a.reg_date "
+"         , a.reg_id "
+"         , a.status "
+"   from tcb_contmaster a "
+"  where member_no = '"+_member_no+"'  "
+"    and status = '"+s_cont_status+"'   "
+"    and (  "
+"              a.reg_date like '"+s_date+"%' "
+"          or a.mod_req_date like '"+s_date+"%' "
+"          or exists( select * from tcb_cust where cont_no = a.cont_no and cont_chasu = a.cont_chasu and  sign_date like '"+s_date+"%' ) "
+"        ) "
		);

String ci_img = "";
if(!member.getString("ci_img_path").equals("")){
	ci_img = u.aseEnc(Startup.conf.getString("file.path.bcont_logo")+member.getString("ci_img_path"));
}

String stamp_img = "";


while(cont.next()){
	cont.put("cont_url_key", u.aseEnc(cont.getString("cont_no")+cont.getString("cont_chasu")));
	stamp_img = u.aseEnc(stamp_path+u.getItem(cont.getString("status"), code_stamp_img));
	
	DataSet sender = custDao.query(
	  "  select  "
	 +"          vendcd "
	 +"        , member_name "
	 +"        , boss_name "
	 +"        , address "
	 +"        , user_name "
	 +"        , tel_num "
	 +"        , hp1 "
	 +"        , hp2 "
	 +"        , hp3 "
	 +"        , email "
	 +"        , sign_date "
	 +"  from tcb_cust "
	 +" where cont_no = '"+cont.getString("cont_no")+"' "
	 +"   and cont_chasu = '"+cont.getString("cont_chasu")+"' "
	 +"   and member_no = '"+_member_no+"' "
		);
	while(sender.next()){
		sender.put("address", sender.getString("address").replaceAll(System.getProperty("line.separator"), ""));
		if(sender.getString("sign_date").equals("")){
			stamp_img = "";
		}
	}
	
	DataSet receiver = custDao.query(
	  "  select  "
	 +"          vendcd "
	 +"        , member_name "
	 +"        , boss_name "
	 +"        , address "
	 +"        , user_name "
	 +"        , tel_num "
	 +"        , hp1 "
	 +"        , hp2 "
	 +"        , hp3 "
	 +"        , email "
	 +"        , sign_date "
	 +"  from tcb_cust "
	 +" where cont_no = '"+cont.getString("cont_no")+"' "
	 +"   and cont_chasu = '"+cont.getString("cont_chasu")+"' "
	 +"   and member_no <> '"+_member_no+"' "
	 +" order by display_seq asc "
		); 
	while(receiver.next()){
		receiver.put("address", receiver.getString("address").replaceAll(System.getProperty("line.separator"), ""));
	}
	
	DataSet cfile = cfileDao.query(
		  "  select  "
		 +"          doc_name "
		 +"        , file_path "
		 +"        , file_name "
		 +"        , file_ext "
		 +"        , auto_yn "
		 +"  from tcb_cfile "
		 +" where cont_no = '"+cont.getString("cont_no")+"' "
		 +"   and cont_chasu = '"+cont.getString("cont_chasu")+"' "
		 +" order by cfile_seq asc "
		) ;
	while(cfile.next()){
		String full_file_path = u.aseEnc(Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path")+cfile.getString("file_name"));
		String down_file_name = u.aseEnc(cfile.getString("doc_name"));
		
		String down_url = "";
		if(cfile.getString("file_ext").toLowerCase().equals("pdf")&&!cont.getString("paper_yn").equals("Y")){
			String footer_img = "";//당일 날 계약서를 가져 가지 않으면 못 가져감
			if(!cfile.getString("auto_yn").equals("Y")){
				String mng_no = cont.getString("cont_no")+"-"+cont.getString("cont_chasu")+"-"+cont.getString("true_random");
				String signStr = "<table width='740px' height='40px' border='0'><tr><td valign='bottom' style='font-family:나눔고딕; font-size:10px'><font color='#5B5B5B'>*본 계약서는 상기업체 간에 전자서명법  등 관련법령에 근거하여 전자서명으로 체결한 전자계약서입니다.<br>&nbsp;&nbsp;전자계약 진위여부는 나이스다큐(http://www.nicedocu.com,일반기업용)에서 확인하실 수 있습니다. (관리번호:"+mng_no+")</font></td></tr></table>";
				footer_img = procure.common.conf.Startup.conf.getString("file.path.lcont_temp") + mng_no+"_"+ "_" + u.getTimeString() + ".png";
				HtmlImageGenerator imageGenerator = new HtmlImageGenerator();
				imageGenerator.loadHtml(signStr);
				imageGenerator.saveAsImage(footer_img);  // 물류쪽 임시 폴더에 같이 저장함. 매일 밤 배치파일이 돌면서 삭제한다.
				footer_img = u.aseEnc(footer_img);	
			}
			down_url ="http://www.nicedocu.com/servlets/nicelib.pdf.PDFDown"
					+"?system=buyer"
					+"&full_file_path="+full_file_path
					+"&down_file_name="+down_file_name
					+"&stamp_img="+stamp_img
					+"&ci_img="+ci_img
					+"&footer_img="+footer_img;
		}else{
			down_url = "http://www.nicedocu.com/servlets/procure.common.file.FileDownLoad"
					 + "?ENC_YN=Y"
					 + "&FILE_KEY=file.path.bcont_pdf"
					 + "&FILE_SUB_PATH="+u.aseEnc(cfile.getString("file_path")+cfile.getString("file_name"))
					 + "&FILE_TAR_FILE="+URLEncoder.encode(cfile.getString("doc_name")+cfile.getString("file_ext"));
		}
		cfile.put("download_url", down_url);
	}
	
	cfile.removeColumn("file_path, file_name, file_ext, auto_yn, __ord, __last");
	sender.removeColumn("__ord, __last");
	receiver.removeColumn("__ord, __last");
	
	cont.put(".sender",sender);
	cont.put(".receiver",receiver);
	cont.put(".cont_file",cfile);
}

cont.removeColumn("__ord, __last, true_random");

rdata.put("response_data_cnt", cont.size());
rdata.put(".resonse_data", cont);

response.setContentType("application/json; charset=UTF-8");
out.clearBuffer();
out.print(u.loop2json(rdata));
%>