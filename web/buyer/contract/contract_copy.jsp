<%@ page import="javax.xml.crypto.Data" %>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String s_cont_no = u.aseDec(u.request("cont_no"));
String s_cont_chasu = u.request("cont_chasu");
String template_cd = u.request("template_cd");
if(s_cont_no.equals("")||s_cont_chasu.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

ContractDao contDao = new ContractDao();

String cont_no = contDao.makeContNo();
String cont_chasu = "0";

String random_no = u.strpad(u.getRandInt(0,99999)+"",5,"0");

String cont_userno = "";

DataSet cont = contDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"'");
if(!cont.next()){
	u.jsError("��������� �����ϴ�.");
	return;
}

DataObject attCfileDao = new DataObject("tcb_att_cfile");
if(attCfileDao.findCount("template_cd = '"+cont.getString("template_cd")+"' and  member_no = '"+cont.getString("member_no")+"' and auto_type = '1' ") > 0 ){
	u.jsError("��༭�� �ڵ� ÷�θ� �̿��ϴ� ������ ���� ����� ��� �� �� �����ϴ�.");
	return;
}

//����� ����ȣ �ڵ� ���� ����
boolean bAutoContUserNo = u.inArray(
		_member_no
		, new String[]{
				"20150400367"	//�������(��)
				,"20170100166"	//�ֽ�ȸ�� �Ż���ī����
				,"20170100165"	//�ֽ�ȸ�� ����å�Ż��
				,"20160401012"	//������Ÿġ���ͼַ�� �ֽ�ȸ��
				,"20150900434"	//������۽��� �ֽ�ȸ��
				,"20150500312"	//(��)����������
				,"20140900004"	//(��)����Ƽ���ؿ���
				,"20130400011"	//�ѱ����������Ǿ��� ����ȸ��
				,"20130400010"	//�ѱ������� Ʈ���̵� ����ȸ��
				,"20130400009"	//�ѱ�������������ũ ����ȸ��
				,"20130400008"	//�ֽ�ȸ�� ���������̿���Ƽ
				,"20121203661"	//�ѱ�������(��)
				,"20180203437"	//���̿���
				,"20121200073"	//������Ǯ
				,"20181201176"	//īī�� Ŀ�ӽ�
				,"20131000506"	//�����������̽����ֽ�ȸ��
				,"20190205651"	//���λ�� �ֽ�ȸ��
				,"20190205653"	//�̼���� �ֽ�ȸ��
				,"20190205654"	//(��) ����������
				,"20190205649"	//������� (��)
				,"20190205652"	//���밳���ֽ�ȸ��
				,"20180100028"	//�Ǻ���Ʈ����
				,"20190300598"	//�����������
				,"20190600117"	//�����Ǿ���Ʈ����
				,"20191101572"  //�������(��)
				,"20200203416"  //����̿�����
				,"20200203478"  //�������
				,"20200203481"  //�������(��)
				,"20180100684"	//��������
		});
if(_member_no.equals("20150900434") && !template_cd.equals("2015106")) // ������۽��� ��ǰ���ް�༭ �ܴ� �ڵ�ä�� �ƴ�.
	bAutoContUserNo = false;

if(bAutoContUserNo){
	if(u.inArray(_member_no, new String[] {"20120200001","20150400367","20190205651","20190205653","20190205654","20190205649","20190205652"})){
		
		DataObject templateDao = new DataObject("tcb_cont_template");
		DataSet template = templateDao.find(" template_cd = '"+cont.getString("template_cd")+"'", "field_seq");
		
		if(template.next()){
		}
		String dept_name ="";
		if(!"".equals(template.getString("field_seq"))){
			DataObject deptDao = new DataObject("tcb_field");
			DataSet dept = deptDao.find(" member_no = '"+_member_no+"' and field_seq =  '"+template.getString("field_seq")+"'" , " field_name");
			if(!dept.next()){
				u.jsError("�μ��� �������� �ʾ� ����ȣ�� ������ �� �����ϴ�.\\n�����ͷ� �������ּ���.");
				return;
			}
			dept_name = dept.getString("field_name");
			cont_userno = contDao.getOne(
					  " select '"+dept_name+" '||'"+u.getTimeString("yyyyMM")+"-'||lpad(nvl(max(to_number(substr(cont_userno,-3))),0)+1,3,'0') cont_userno "
					 +"   from tcb_contmaster                                                                                                          "
					 +"  where member_no like '%"+_member_no+"%'                                                                                               "
					 +"    and cont_userno like '"+dept_name+" "+u.getTimeString("yyyyMM")+"-%'                                                            "
			);
		}else{
			u.jsError("�μ��� �������� �ʾ� ����ȣ�� ������ �� �����ϴ�.\\n�����ͷ� �������ּ���.");
			return;
		}
		
	}else if(_member_no.equals("20170100165")){//����å �Ż��
		cont_userno = contDao.getOne(
				 " select  'TB"+u.getTimeString("yyMM")+"'|| lpad(to_number(nvl(max(substr(cont_userno,7)),'000'))+1,3,'0') "
				+"    from tcb_contmaster                                                                                   "
				+"  where member_no = '"+_member_no+"'                                                                      "
				+"     and cont_userno like 'TB"+u.getTimeString("yyMM")+"%'                                                "
				);
	}else if(_member_no.equals("20170100166")){//�Ż�� ��ī����
		cont_userno = contDao.getOne(
				 " select  'AC"+u.getTimeString("yyMM")+"'|| lpad(to_number(nvl(max(substr(cont_userno,7)),'000'))+1,3,'0') "
				+"    from tcb_contmaster                                                                                   "
				+"  where member_no = '"+_member_no+"'                                                                      "
				+"     and cont_userno like 'AC"+u.getTimeString("yyMM")+"%'                                                "
				);
	}else if(_member_no.equals("20140900004")) // ����Ƽ���ؿ���
	{
		DataObject fieldDao = new DataObject();
		String field_name = fieldDao.getOne("select field_name from tcb_field where member_no='"+_member_no+"' and field_seq="+auth.getString("_FIELD_SEQ"));
		if(field_name.equals("")){
			u.jsError("�μ��� �������� �ʾ� ����ȣ�� ������ �� �����ϴ�.");
			return;
		}
		field_name = field_name + "-" + u.getTimeString("yyyy");

		int substr_pos = field_name.length()+1;
		String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+substr_pos+"))),0)+1 from tcb_contmaster where member_no = '20140900004' and field_seq="+auth.getString("_FIELD_SEQ"));
		if(userNoSeq.equals("")){
			u.jsError("����ȣ ������ ���� �Ͽ����ϴ�.");
			return;
		}
		cont_userno = field_name + u.strrpad(userNoSeq, 4, "0");
	}else if(_member_no.equals("20150500312")){  // ���������� ����ȣ �ڵ�ü��
		String[] wUserNo = {"2015036=>ǥ��","2015037=>��������","2015038=>��ǰ����","2016108=>�μ�","2017257=>������","2017259=>�����԰���"};

		String sHeader = "W����_"+ u.getItem(template_cd, wUserNo)+"_"+u.getTimeString("yy")+"_";
		int pos = sHeader.length();

		String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+(pos+1)+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and template_cd = '"+template_cd+"' and substr(cont_userno,0,"+pos+")='"+sHeader+"'");
		if(userNoSeq.equals("")){
			u.jsError("����ȣ ������ ���� �Ͽ����ϴ�.");
			return;
		}
		cont_userno =sHeader+u.strrpad(userNoSeq, 8, "0");
	}else if(_member_no.equals("20150900434")){  // ����� �۽��� ����ȣ �ڵ�ü��
		String[] pacificUserNo = {"2015106=>NPPO"};

		String sHeader = u.getItem(template_cd, pacificUserNo)+u.getTimeString("yyyyMM");
		int pos = sHeader.length();

		String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+(pos+1)+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and template_cd = '"+template_cd+"' and substr(cont_userno,0,"+pos+")='"+sHeader+"'");
		if(userNoSeq.equals("")){
			u.jsError("����ȣ ������ ���� �Ͽ����ϴ�.");
			return;
		}
		cont_userno =sHeader+u.strrpad(userNoSeq, 3, "0");
	}else if(_member_no.equals("20160401012")){  // ������Ÿġ ����ȣ �ڵ�ü�� (������Ÿġ -> ��ũ�ν� ���;ؿ�����) 
		String[] wUserNo = {"2016141=>GA","2016053=>CU","2016054=>GA","2016055=>PO","2016056=>PU","2018030=>PU","2018149=>CA","2018228=>SU","2018062=>PU","2018160=>PU","2020118=>GA","2020127=>BU"};
		String temp = u.getItem(template_cd, wUserNo);
		if(temp.equals("")){ 
			u.jsError("����ȣ ü�� ��Ģ�� ���� ���� �ʾҽ��ϴ�.");
			return;
		}
		String sHeader = "TWE-"+u.getTimeString("yyyy")+"-"+u.getTimeString("MM")+ temp;    
		int pos = sHeader.length();

		String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+(pos+1)+"))),99)+1 from tcb_contmaster where member_no = '"+_member_no+"' and template_cd = '"+template_cd+"' and substr(cont_userno,0,"+pos+")='"+sHeader+"'");
		if(userNoSeq.equals("")){
			u.jsError("����ȣ ������ ���� �Ͽ����ϴ�.");
			return;
		}
		cont_userno =sHeader+u.strrpad(userNoSeq, 3, "0");

	}else if(_member_no.equals("20180203437")){//���̿��� 
		String[] template_gubun1 = {
				"2018063"//�뿪��༭
				,"2018064"//�ڹ���༭
				,"2018065"//��⹰ó����Ź��༭
				,"2018066"//��⹰ó����Ź��༭
				,"2018072"//����Ʈ����(�ý���) ���̼��� ���
				,"2019192"//�������� ���� �� �м� �뿪��༭
				,"2019199"//(������) �����ϾȰ������ ǥ���ϵ��ް�༭
				,"2020117" //�ǰ�������༭ 
		};// TES-0000(�⵵)-00(��)-001~100 0 ���� �μ�
		String[] template_gubun2 = {
				 "2018062"//��ǰ���� ��༭
				,"2018073"//�Ǽ����� ǥ���ϵ��ް�༭
				,"2018074"//�Ǽ����� ǥ���ϵ��ް�༭
				,"2018075"//���(��Ÿ������) ǥ���ϵ��� �⺻��༭
				,"2019202" //(������)ȭ�о��� ǥ���ϵ��� �⺻��༭
		};//TES-0000(�⵵)-00(��)-101~200 100�� �� ���� ���翡 ���� �ǰ� ������ ������� ü�Է� �׳� ���ڴٰ� ��. 18181818
		String[] template_gubun3 = {
			 "2018061"//�����ϵ��ް�༭
			,"2018073"//�Ǽ����� ǥ���ϵ��ް�༭
			,"2019200" //(������)���������� ǥ���ϵ��ް�༭
			,"2019201" //(������)�ؿܰǼ����� ǥ���ϵ��ް�༭
			,"2019235" //������༭
		};//TES-0000(�⵵)-00(��)-201~300 
		String query = "";
		if(u.inArray(template_cd, template_gubun1)){
			query =  " select 'TES-"+u.getTimeString("yyyy-MM")+"-0'||lpad(nvl(max(to_number(substr(cont_userno,14,2))),0)+1,2,'0')||'-00' cont_userno "
					+"   from tcb_contmaster                                                                                                           "
					+"  where member_no = '20180203437'                                                                                                "
					+"    and cont_userno like 'TES-"+u.getTimeString("yyyy-MM")+"-0%'                                           ";
					
		}
		if(u.inArray(template_cd, template_gubun2)){
			query =  " select 'TES-"+u.getTimeString("yyyy-MM")+"-1'||lpad(nvl(max(to_number(substr(cont_userno,14,2))),0)+1,2,'0')||'-00' cont_userno "
					+"   from tcb_contmaster                                                                                                           "
					+"  where member_no = '20180203437'                                                                                                "
					+"    and cont_userno like 'TES-"+u.getTimeString("yyyy-MM")+"-1%'                                           ";
					
		}
		if(u.inArray(template_cd, template_gubun3)){
			query =  " select 'TES-"+u.getTimeString("yyyy-MM")+"-2'||lpad(nvl(max(to_number(substr(cont_userno,14,2))),0)+1,2,'0')||'-00' cont_userno "
					+"   from tcb_contmaster                                                                                                           "
					+"  where member_no = '20180203437'                                                                                                "
					+"    and cont_userno like 'TES-"+u.getTimeString("yyyy-MM")+"-2%'                                           ";
					
		}
		if(!query.equals("")){
			cont_userno = contDao.getOne(query);
		}
		
	}else if(_member_no.equals("20121200073")){
		
		DataObject fieldDao = new DataObject();
		String field_name = fieldDao.getOne("select field_name from tcb_field where member_no='"+_member_no+"' and field_seq="+auth.getString("_FIELD_SEQ"));
		if("".equals(field_name)){
			u.jsError("�μ��� �������� �ʾ� ����ȣ�� ������ �� �����ϴ�.");
			return;
		}
		
		String[] code_logis_deptnm = {"1=>�ÿ�","2=>ü��","3=>����","4=>�׿�","5=>���","6=>MHE","7=>�ַ��","8=>�����","9=>����","10=>���","11=>����",
				"12=>�λ�","13=>����","14=>���","15=>�泲","16=>����","17=>����","18=>����","19=>�泲","20=>ȣ��","21=>�濵","22=>������","23=>����","24=>����1"
				,"25=>����2","26=>�ӿ�","27=>�ѱ�������Ǯ"};

		field_name = u.getItem(auth.getString("_FIELD_SEQ"), code_logis_deptnm);
		
		if("".equals(field_name)){
			u.jsError("�μ� �� ��ϵ��� �ʾ� ����ȣ�� ������ �� �����ϴ�.\\n�����͸� ���� �μ���� ����� ��û���ּ���.");
			return; 
		}
		
		cont_userno = "KLP-"+field_name + "-" + u.getTimeString("yyyy-MM")+"-";
		 
		int substr_pos = cont_userno.length()+1;
		String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+substr_pos+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and cont_userno like '%"+cont_userno+"%'  " );
		if("".equals(userNoSeq)){
			u.jsError("����ȣ ������ ���� �Ͽ����ϴ�.");
			return;
		}
		cont_userno = cont_userno + u.strrpad(userNoSeq, 4, "0");
		 
	}else if(_member_no.equals("20181201176")){// īī�� Ŀ�ӽ�
		cont_userno = contDao.getOne(
				  " select  lpad(nvl(max(substr(cont_userno,9,5)),0)+1,5,'0') as cont_userno "
				 +"   from tcb_contmaster                                                                                                          "
				 +"  where member_no = '20181201176'                                                                                               "
					);
		cont_userno = u.getTimeString("yyMMdd")+cont_userno;//��ü ��û�������� �Ϸù�ȣ ������ ���� ����.
	
	}else if(_member_no.equals("20131000506")){//�����������̽����ֽ�ȸ��
		cont_userno = contDao.getOne(
				  " select  lpad(nvl(max(substr(cont_userno,9,5)),0)+1,5,'0') as cont_userno "
				 +"   from tcb_contmaster                                                                                                          "
				 +"  where member_no = '20131000506'                                                                                               "
				 +"    and length(cont_userno) = 13 "
				 +"    and cont_userno like '"+u.getTimeString("yyyy-MM")+"-"+"%'  "
					);
		cont_userno = u.getTimeString("yyyy-MM")+"-"+cont_userno;
	
	}else if("20180100028".equals(_member_no)){
		
		if("2019112".equals(template_cd)){
			cont_userno = contDao.getOne(
				" select lpad(nvl(max(to_number(substr(cont_userno,6,4))),0) + 1,4,'0') as cont_userno "
				+"  from tcb_contmaster "
				+" where member_no = '"+_member_no+"' and cont_userno like '"+u.getTimeString("yyyy")+"%' "
			);
			cont_userno = u.getTimeString("yyyy") + "-" + cont_userno;
		}
	}else if(_member_no.equals("20190300598")){	//����������� 2020-02-MHKCON-0008
		if("2019240".equals(template_cd) || "2019151".equals(template_cd)|| "2020068".equals(template_cd)){	// ��� : ��ȭ ������ ���� ��༭(���ο�) <-> ��ȭ ������ ���� ��༭(����)(template_cd:2019151)  �� ������ ��Ģ 
			
			// 2019-07-MHKCON-0001
			
			cont_userno = contDao.getOne(
					  " select  '"+u.getTimeString("yyyy-MM")+"-MHKCON-' || lpad(nvl(max(to_number(substr(cont_userno,16,5))),0)+1,4,'0') as cont_userno "
					 +"   from tcb_contmaster                                                                                                          "
					 +"  where member_no = '"+_member_no+"'                                                                                               "
					 +"   and template_cd in( '2019151','2019240','2020068')    and cont_userno like '"+u.getTimeString("yyyy-MM")+"-MHKCON-%'"
						);
		
		}else if("2019290".equals(template_cd)){ //�������� ǥ�ذ�༭  2019-08-MHKFRE-0001 (�⵵-��- MHKFRE-���� )
			cont_userno = contDao.getOne(
					  " select  '"+u.getTimeString("yyyy-MM")+"-MHKFRE-' || lpad(nvl(max(to_number(substr(cont_userno,16,5))),0)+1,4,'0') as cont_userno "
					 +"   from tcb_contmaster                                                                                                          "
					 +"  where member_no = '"+_member_no+"'                                                                                               "
					 +"   and template_cd in( '2019290')    and cont_userno like '"+u.getTimeString("yyyy-MM")+"-MHKFRE-%'"
						);   
		}else if("2020106".equals(template_cd)){ //�Ŵ�����Ʈ ���� ��༭ (�⵵-��¥-MHKMAG-0001 ) 
			cont_userno = contDao.getOne(
					  " select  '"+u.getTimeString("yyyy-MM")+"-MHKMAG-' || lpad(nvl(max(to_number(substr(cont_userno,16,5))),0)+1,4,'0') as cont_userno "
					 +"   from tcb_contmaster                                                                                                          "
					 +"  where member_no = '"+_member_no+"'                                                                                               "
					 +"   and template_cd in( '2020106')    and cont_userno like '"+u.getTimeString("yyyy-MM")+"-MHKMAG-%'"
						);   
		}else{	
			bAutoContUserNo = false;
		} 
	}else if("20190600117".equals(_member_no)) {
		
		String cont_text = "'PG-'";
		if("2019173".equals(cont.getString("template_cd"))){
			cont_text = "'AG-'";
		} 
		
		cont_userno = contDao.getOne(
			  " select  "+cont_text+"  ||  '"+u.getTimeString("yyMM")+"-' || lpad(nvl(max(to_number(substr(cont_userno,10,3))),0)+1,2,'0') as cont_userno "
			 +"   from tcb_contmaster                                                                                                          "
			 +"  where member_no = '"+_member_no+"'                                                                                               "
			 +"   and template_cd in( '"+cont.getString("template_cd")+"')    and cont_userno like  "+cont_text+" ||  '"+u.getTimeString("yy-MM")+"-%'"
		);
	}else if(_member_no.equals("20191101572")){ //�������(��)
		
		DataObject fieldDao = new DataObject();
		String field_name = fieldDao.getOne("select field_name from tcb_field where member_no='"+_member_no+"' and field_seq="+auth.getString("_FIELD_SEQ"));
		if("".equals(field_name)){
			u.jsError("�μ��� �������� �ʾ� ����ȣ�� ������ �� �����ϴ�.");
			return;
		}
		 
		//  �μ��� ����, ��ȣ �� ���ĺ� : ������(R), â��1����(C), â��2����(J), õ�Ȱ���(N), ��ȯ����(L), ���ձ�����(H) 
		String[] code_logis_deptnm = {"1=>H","3=>R","4=>C","5=>J","6=>N","7=>L","8=>H"};

		field_name = u.getItem(auth.getString("_FIELD_SEQ"), code_logis_deptnm);
		
		if("".equals(field_name)){
			u.jsError("�μ� �� ��ϵ��� �ʾ� ����ȣ�� ������ �� �����ϴ�.\\n�����͸� ���� �μ���� ����� ��û���ּ���.");
			return; 
		}
		cont_userno =  field_name + "-" + u.getTimeString("yyyy")+"-"; 
		 
		int substr_pos = cont_userno.length()+1;
		String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+substr_pos+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and cont_userno like '%"+cont_userno+"%'  " );
		if("".equals(userNoSeq)){
			u.jsError("����ȣ ������ ���� �Ͽ����ϴ�.");
			return;
		}
		cont_userno = cont_userno + u.strrpad(userNoSeq, 4, "0");
		
	}else if(_member_no.equals("20200203416")){ //����̿�����  DR20200001
		cont_userno = contDao.getOne(
				 " select  'DR"+u.getTimeString("yyyy")+"'|| lpad(nvl(max(substr(cont_userno,7,4)),0)+1,4,'0') as cont_userno "
				+"    from tcb_contmaster                                                                                   "
				+"  where member_no = '"+_member_no+"'                                                                      "
				+"     and cont_userno like 'DR"+u.getTimeString("yyyy")+"%'                                                "
				); 
	}else if(_member_no.equals("20200203478")){ //�������	 
		cont_userno = contDao.getOne( 
				 " select  'DP"+u.getTimeString("yyyy")+"'|| lpad(nvl(max(substr(cont_userno,7,4)),0)+1,4,'0') as cont_userno "
				+"    from tcb_contmaster                                                                                   "
				+"  where member_no = '"+_member_no+"'                                                                      "
				+"     and cont_userno like 'DP"+u.getTimeString("yyyy")+"%'                                                "
				);  
	}else if(_member_no.equals("20200203481")){ //����������		
		cont_userno = contDao.getOne(
				 " select  'BE"+u.getTimeString("yyyy")+"'|| lpad(nvl(max(substr(cont_userno,7,4)),0)+1,4,'0') as cont_userno "
				+"    from tcb_contmaster                                                                                   "
				+"  where member_no = '"+_member_no+"'                                                                      "
				+"     and cont_userno like 'BE"+u.getTimeString("yyyy")+"%'                                                "
				);   
	}else if(_member_no.equals("20180100684")){//��������
		cont_userno = contDao.getOne(
				" select  '"+u.getTimeString("yyMMdd")+"' || lpad(nvl(max(to_number(substr(cont_userno,7,10))),0)+1,4,'0') as cont_userno "
						+"   from tcb_contmaster                                                                                          "
						+"  where member_no = '"+_member_no+"'                                                                            "
						+"    and cont_userno like '"+u.getTimeString("yyMMdd")+"%'"
		);
	}else {
		cont_userno = cont_no + "-" + cont_chasu;
	}

}else{
	cont_userno = "";
}

DB db = new DB();

//��ึ����
contDao = new ContractDao("tcb_contmaster");
cont.removeColumn("__last,__ord");
cont.put("cont_no", cont_no);
cont.put("cont_chasu", "0");
cont.put("member_no", _member_no);
cont.put("field_seq", auth.getString("_FIELD_SEQ"));
cont.put("cont_userno", cont_userno);
cont.put("cont_name", cont.getString("cont_name")+"_���纻");
cont.put("cont_html", cont.getString("org_cont_html"));
cont.put("org_cont_html", "");
cont.put("true_random", cont.getString("true_random"));
cont.put("reg_date", u.getTimeString());
cont.put("reg_id",auth.getString("_USER_ID"));
cont.put("status", "10");
contDao.item(cont.getRow());
db.setCommand(contDao.getInsertQuery(), contDao.record);


//���� ���� ����
DataObject contSignDao = new DataObject("tcb_cont_sign");
DataSet contSign = contSignDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"'");
contSign.removeColumn("__last,__ord");
while(contSign.next()){
	contSign.put("cont_no", cont_no);
	contSign.put("cont_chasu", "0");
	contSignDao = new DataObject("tcb_cont_sign");

	contSignDao.item(contSign.getRow());
	db.setCommand(contSignDao.getInsertQuery(), contSignDao.record);
}


//����� ����
DataObject contSubDao = new DataObject("tcb_cont_sub");
DataSet contSub = contSubDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"'");
contSub.removeColumn("__last,__ord");
while(contSub.next()){
	contSub.put("cont_no", cont_no);
	contSub.put("cont_chasu", "0");
	contSub.put("cont_sub_html", contSub.getString("org_cont_sub_html"));

	contSubDao = new DataObject("tcb_cont_sub");
	contSubDao.item(contSub.getRow());
	db.setCommand(contSubDao.getInsertQuery(), contSubDao.record);
}

//����ü
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"'");
cust.removeColumn("__last,__ord");
while(cust.next()){
	cust.put("cont_no", cont_no);
	cust.put("cont_chasu", "0");
	cust.put("sign_date", "");
	cust.put("sign_dn", "");
	cust.put("sign_data","");
	cust.put("email_random","");
	cust.put("pay_yn","");
	if(cust.getString("member_no").equals(cont.getString("member_no"))){
		DataObject memberDao = new DataObject("tcb_member");
		DataSet member = memberDao.find(" member_no = '"+_member_no+"' ");
		if(!member.next()){
		}
		cust.put("member_name", member.getString("member_name"));
		cust.put("vendcd", member.getString("vendcd"));
		cust.put("boss_name", member.getString("boss_name"));
		cust.put("post_code", member.getString("post_code"));
		cust.put("address", member.getString("address"));
		cust.put("member_slno", member.getString("member_slno"));
		DataObject personDao = new DataObject("tcb_person");
		DataSet person = personDao.find("member_no = '"+_member_no+"' and user_id = '"+auth.getString("_USER_ID")+"' ");
		if(!person.next()){
			cust.put("tel_num", person.getString("tel_num"));
			cust.put("user_name", person.getString("user_name"));
			cust.put("hp1", person.getString("hp1"));
			cust.put("hp2", person.getString("hp2"));
			cust.put("hp3", person.getString("hp3"));
			cust.put("email", person.getString("email"));
		}
	}else{
		cust.put("member_no", "00000000000");
		cust.put("vendcd", "0000000000");
		cust.put("jumin_no", "");
		cust.put("member_name", "������ ���");
		cust.put("post_code", "");
		cust.put("address", "��� ����� ��ü���� �� �缱����");
		cust.put("tel_num", "");
		cust.put("member_slno", "");
		cust.put("user_name", "");
		cust.put("hp1", "");
		cust.put("hp2", "");
		cust.put("hp3", "");
		cust.put("email", "");
		cust.put("cust_detail_code", "");
	}

	custDao = new DataObject("tcb_cust");
	custDao.item(cust.getRow());
	db.setCommand(custDao.getInsertQuery(), custDao.record);
}


//�������
String file_path = u.getTimeString("yyyy")+"/"+_member_no+"/"+cont_no+"/";
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"' and auto_yn = 'Y'");
if(cfile.size() > 0){
	File folder = new File(Startup.conf.getString("file.path.bcont_pdf")+file_path);
	if(!folder.exists()){
		folder.mkdirs();
	}
}
String cont_hash = "";
cfile.removeColumn("__last,__ord");
while(cfile.next()){
	String source = Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path")+cfile.getString("file_name");
	String target = Startup.conf.getString("file.path.bcont_pdf")+ file_path + cfile.getString("file_name");
	u.copyFile(source, target);
	if(!cont_hash.equals(""))cont_hash += "|";
	cont_hash += contDao.getHash("file.path.bcont_pdf",file_path + cfile.getString("file_name"));

	cfile.put("cont_no", cont_no);
	cfile.put("cont_chasu", "0");
	cfile.put("file_path", cfile.getString("auto_type").equals("2")?"":file_path);
	cfile.put("file_name", cfile.getString("auto_type").equals("2")?"":cfile.getString("file_name"));
	cfile.put("file_ext", cfile.getString("auto_type").equals("2")?"":cfile.getString("file_ext"));
	cfile.put("file_size", cfile.getString("auto_type").equals("2")?"":cfile.getString("file_size"));
	cfileDao = new DataObject("tcb_cfile");
	cfileDao.item(cfile.getRow());
	db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
}


// ���� ����
DataObject contAgreeDao = new DataObject("tcb_cont_agree");
DataSet contAgree = contAgreeDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"'");
contAgree.removeColumn("__last,__ord");
while(contAgree.next()){
	contAgree.put("cont_no", cont_no);
	contAgree.put("cont_chasu", cont_chasu);
	contAgree.put("r_agree_person_id", "");
	contAgree.put("r_agree_person_name", "");
	contAgree.put("ag_md_date", "");

	contAgreeDao = new DataObject("tcb_cont_agree");
	contAgreeDao.item(contAgree.getRow());
	db.setCommand(contAgreeDao.getInsertQuery(), contAgreeDao.record);
}

//����
DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"'");
while(warr.next()){
	warrDao = new DataObject("tcb_warr");
	warrDao.item("cont_no",cont_no);
	warrDao.item("cont_chasu", "0");
	warrDao.item("member_no", warr.getString("member_no"));
	warrDao.item("warr_seq", warr.getString("warr_seq"));
	warrDao.item("warr_type", warr.getString("warr_type"));
	warrDao.item("etc", warr.getString("etc"));
	db.setCommand(warrDao.getInsertQuery(), warrDao.record);
}

//���񼭷�
DataObject rfileDao = new DataObject("tcb_rfile");
DataSet rfile = rfileDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"'");
rfile.removeColumn("__last,__ord");
while(rfile.next()){
	rfileDao = new DataObject("tcb_rfile");
	rfile.put("cont_no", cont_no);
	rfile.put("cont_chasu", "0");
	rfileDao = new DataObject("tcb_rfile");
	rfileDao.item(rfile.getRow());
	db.setCommand(rfileDao.getInsertQuery(), rfileDao.record);
}

//��� hash
contDao = new ContractDao("tcb_contmaster");
contDao.item("cont_hash", cont_hash);
db.setCommand(contDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu = '0'"), contDao.record);

/* ���α� START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "���ڹ��� ����",  "����", "10","10");
/* ���α� END*/

if(!db.executeArray()){
	u.jsError("ó���� �����Ͽ����ϴ�.");
	return;
}
if(cont.getString("sign_types").equals("")) {
	u.jsAlertReplace("��༭�� ���� �Ͽ����ϴ�. \\n\\n�ӽ������� �޴��� �̵� �մϴ�.", "./contract_modify.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=0");
}else{
	u.jsAlertReplace("��༭�� ���� �Ͽ����ϴ�. \\n\\n�ӽ������� �޴��� �̵� �մϴ�.", "./contract_msign_modify.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=0");
}
%>


