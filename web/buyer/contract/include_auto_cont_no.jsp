<%!

public boolean isAutoMember(String member_no){
	boolean result = Util.inArray(
			member_no
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
					,"20191101572"  //�������(��)
					,"20200203416"  //����̿�����
			    	,"20200203478"  //�������
				    ,"20200203481"  //�������(��)
					}
			);
	return result;
}

public String getAutoContUserNo(String member_no, String template_cd, Auth auth){
	String cont_userno = "";
	
	// �μ��� �������� ��Ģ ����
			if(u.inArray(_member_no, new String[] {"20150400367","20190205651","20190205653","20190205654","20190205649","20190205652"})){
				
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
			}else if(_member_no.equals("20160401012")){  // ������Ÿġ ����ȣ �ڵ�ü��
				String[] wUserNo = {"2016141=>GA","2016053=>CU","2016054=>GA","2016055=>PO","2016056=>PU","2018030=>PU","2018149=>CA","2018228=>SU","2018062=>PU","2018160=>PU","2020118=>GA","2020127=>BU"};
				String temp = u.getItem(template_cd, wUserNo);
				if(temp.equals("")){
					u.jsError("����ȣ ü�� ��Ģ�� ���� ���� �ʾҽ��ϴ�.");
					return;
				}
				String sHeader = "TWE-" + u.getTimeString("yyyy")+"-"+u.getTimeString("MM")+ temp; // LHWS ����
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
						,"2020117" //�ǰ�������༭ 
				};// TES-0000(�⵵)-00(��)-001~100 0 ���� �μ�
				String[] template_gubun2 = {
						 "2018062"//��ǰ���� ��༭
						,"2018074"//�Ǽ����� ǥ���ϵ��ް�༭
						,"2018075"//���(��Ÿ������) ǥ���ϵ��� �⺻��༭
				};//TES-0000(�⵵)-00(��)-101~200 100�� �� ���� ���翡 ���� �ǰ� ������ ������� ü�Է� �׳� ���ڴٰ� ��. 18181818
				String[] template_gubun3 = {
					 "2018061"//�����ϵ��ް�༭
					,"2018073"//�Ǽ����� ǥ���ϵ��ް�༭
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
				if("".equals(field_name) ){
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
				String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+substr_pos+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and cont_userno like '%"+field_name+"%'  " );
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
				
			}else if(_member_no.equals("20191101572")){ //�������(��)
				
				DataObject fieldDao = new DataObject();
				String field_name = fieldDao.getOne("select field_name from tcb_field where member_no='"+_member_no+"' and field_seq="+auth.getString("_FIELD_SEQ"));
				if("".equals(field_name) ){
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
				String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+substr_pos+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and cont_userno like '%"+field_name+"%'  " );
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
			
			}else {
				cont_userno = cont_no + "-" + cont_chasu;
			} 
	return cont_no;
}


%>