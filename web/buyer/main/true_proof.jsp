<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

f.addElement("proof_no1", null, "hname:'발급번호', required:'Y', fixbyte:'4'");
f.addElement("proof_no2", null, "hname:'발급번호', required:'Y', fixbyte:'8'");
f.addElement("proof_no3", null, "hname:'발급번호', required:'Y', maxbyte:'5'");

if(u.isPost() && f.validate()){
	String proof_no = f.get("proof_no1")+"-"+f.get("proof_no2")+"-"+f.get("proof_no3");
	DataObject contDao = new DataObject("tcb_contmaster");
	DataSet proof = contDao.query(
			 "select c.template_name                              	"
			+"     , a.status                                  		"
			+"     , b.member_name won_member_name             		"
			+"  from tcb_proof a, tcb_proof_cust b, tcb_proof_template c  "
			+" where a.proof_no = b.proof_no                     	"
			+"   and b.cust_gubun = '10'                       		"
			+"   and a.template_cd = c.template_cd               	"
			+"   and a.proof_no = '"+proof_no+"'               		"
		);
	
	if(!proof.next()){
		u.jsError("해당 문서가 존재하지 않습니다.");
		return;
	}

	CodeDao codeDao = new CodeDao("tcb_comcode");
	String[] status_code = codeDao.getCodeArray("P001");	// 실적증명상태
	String status_name = u.getItem(proof.getString("status"), status_code);
	
	String msg = "<b><font color=\"blue\">["+status_name +"]</font></b>인 전자문서 입니다.";
	p.setVar("proof", proof);
	p.setVar("msg", msg);
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("main.true_proof");
p.setVar("popup_title","실적증명서 진위확인");
p.setVar("form_script",f.getScript());
p.display(out);
%>