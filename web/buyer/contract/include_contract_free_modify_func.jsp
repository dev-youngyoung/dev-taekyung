<%-- 
<%@ page import="java.util.*,java.io.*,nicelib.db.*,nicelib.util.*,dao.*"%>
<%@page import="procure.common.conf.Startup"%>
<%@page import="procure.common.utils.*"%>
 --%>
<%!/**
 * 자유서식 계약 저장
 * @param response
 * @param request
 * @param u
 * @param f
 * @param _member_no
 * @param auth
 * @return
 */
public Map<String, String> _saveFreeContract(HttpServletResponse response, HttpServletRequest request, Util u,Form f, String _member_no, Auth auth) {
	Map<String, String> rtnMap = new HashMap<String, String>();
	rtnMap.put("code", "SUCC");
	rtnMap.put("msg", "저장하였습니다");
	rtnMap.put("url", "contract_free_modify.jsp?" + u.getQueryString());
	try {
		String cont_no    = u.aseDec(u.request("cont_no"));
		String cont_chasu = u.request("cont_chasu", "0");

		// 사용자 계약번호 자동 설정 여부
		boolean bAutoContUserNo = u.inArray(_member_no, new String[] { "20130500019", "20121203661", "20130400011","20130400010", "20130400009", "20130400008" }); // 그루폰, 한국쓰리엠
		// 카카오는 자유서식에서 추가 정보를 입력할 수 있는 기능이 있음
		boolean bIsKakao = u.inArray(_member_no, new String[] { "20130900194", "20181201176" });
		// 테크로스 워터앤에너지,테크로스환경서비스 는 자유서식에서 vat 포함여부 기능
		boolean bIsTechcross = u.inArray(_member_no, new String[] { "20160401012", "20180203437" });

		// 계약업체 조회
		DataSet custDS = new DataObject("tcb_cust").find(" cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'");
		if (!custDS.next()) {
			throw new Exception("NO_CUST_DATA");
		}

		// 계약서류 조회
		String fileDir = "";
		DataSet cfileDS = new DataObject("tcb_cfile").find(" cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'");
		while (cfileDS.next()) {
			fileDir = cfileDS.getString("file_path");
		}

		// 서비스 이용 기간 체크
		DataSet useinfoDS = new DataObject("tcb_useinfo").find("member_no='" + _member_no + "' and usestartday <='"+ u.getTimeString("yyyyMMdd")+ "' and nvl(useendday,case when paytypecd != '10' then to_char(sysdate,'YYYYMMDD') end) >='"+ u.getTimeString("yyyyMMdd") + "' ");
		if (!useinfoDS.next()) {
			throw new Exception("USEINFO_ERR");
		}

		/* 내부관리서류조회 */
		DataSet efileDS = new DataObject("tcb_efile")
				.find(" cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'");

		// 계약서 저장
		String cont_userno = "";
		if (bAutoContUserNo) // 그루폰의 경우는 계약관리번호를 사용자 계약번호로 셋팅
			cont_userno = cont_no + "-" + cont_chasu;
		else
			cont_userno = f.get("cont_userno");

		DB db = new DB();
		// db.setDebug(out);
		ContractDao contDao = new ContractDao();

		contDao.item("member_no", _member_no);
		// contDao.item("field_seq", auth.getString("_FIELD_SEQ")); -- 최초 작성자 정보가 변경되지
		// 않도록 주석처리
		contDao.item("cont_userno", cont_userno);
		contDao.item("cont_name", f.get("cont_name"));
		contDao.item("cont_date", f.get("cont_date").replaceAll("-", ""));
		contDao.item("cont_sdate", f.get("cont_sdate").replaceAll("-", ""));
		contDao.item("cont_edate", f.get("cont_edate").replaceAll("-", ""));
		contDao.item("cont_total", f.get("cont_total").replaceAll(",", ""));
		contDao.item("cont_html", f.get("cont_html"));
		contDao.item("reg_date", u.getTimeString());
		contDao.item("true_random", u.strpad(u.getRandInt(0, 99999) + "", 5, "0"));
		// contDao.item("reg_id", auth.getString("_USER_ID"));
		contDao.item("status", "10");
		contDao.item("stamp_type", f.get("stamp_type"));
		contDao.item("src_cd", f.get("src_cd"));
		contDao.item("project_seq", f.get("project_seq"));
		if (bIsKakao) {
			contDao.item("cont_etc1", f.get("cont_etc1"));
			contDao.item("cont_etc2", f.get("cont_etc2"));
			contDao.item("cont_etc3", f.get("cont_etc3"));
		} else if (bIsTechcross) {
			contDao.item("cont_etc2", f.get("cont_etc2"));
		}
		db.setCommand(contDao.getUpdateQuery(" cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'"),
				contDao.record);

		// 서명 서식 저장
		db.setCommand("delete from tcb_cont_sign where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu
				+ "' ", null);
		String[] sign_seq = f.getArr("sign_seq");
		String[] signer_name = f.getArr("signer_name");
		String[] signer_max = f.getArr("signer_max");
		String[] member_type = f.getArr("member_type");
		String[] cust_type = f.getArr("cust_type");
		for (int i = 0; i < sign_seq.length; i++) {
			DataObject cont_sign = new DataObject("tcb_cont_sign");
			cont_sign.item("cont_no", cont_no);
			cont_sign.item("cont_chasu", cont_chasu);
			cont_sign.item("sign_seq", sign_seq[i]);
			cont_sign.item("signer_name", signer_name[i]);
			cont_sign.item("signer_max", signer_max[i]);
			cont_sign.item("member_type", member_type[i]);
			cont_sign.item("cust_type", cust_type[i]);
			db.setCommand(cont_sign.getInsertQuery(), cont_sign.record);
		}

		// 내부 결재 서식 저장
		String[] agree_seq = f.getArr("agree_seq");
		String agree_field_seqs = "";
		String agree_person_ids = "";
		int agree_cnt = agree_seq == null ? 0 : agree_seq.length;
		if (agree_cnt > 0) {
			db.setCommand("delete from tcb_cont_agree where cont_no = '" + cont_no + "' and cont_chasu = '"
					+ cont_chasu + "' ", null);
			String[] agree_name = f.getArr("agree_name");
			String[] agree_field_seq = f.getArr("agree_field_seq");
			String[] agree_person_name = f.getArr("agree_person_name");
			String[] agree_person_id = f.getArr("agree_person_id");
			String[] agree_cd = f.getArr("agree_cd");
			for (int i = 0; i < agree_cnt; i++) {
				DataObject cont_agree = new DataObject("tcb_cont_agree");
				cont_agree.item("cont_no", cont_no);
				cont_agree.item("cont_chasu", cont_chasu);
				cont_agree.item("agree_seq", agree_seq[i]);
				cont_agree.item("agree_name", agree_name[i]);
				cont_agree.item("agree_field_seq", agree_field_seq[i]);
				cont_agree.item("agree_person_name", agree_person_name[i]);
				cont_agree.item("agree_person_id", agree_person_id[i]);
				cont_agree.item("ag_md_date", "");
				cont_agree.item("mod_reason", "");
				cont_agree.item("r_agree_person_id", "");
				cont_agree.item("r_agree_person_name", "");
				cont_agree.item("agree_cd", agree_cd[i]); // 결재구분코드(0:업체서명전, 1:업체서명후)
				db.setCommand(cont_agree.getInsertQuery(), cont_agree.record);
				agree_field_seqs += agree_field_seq[i] + "|";
				agree_person_ids += agree_person_id[i] + "|";
			}
		}

		// 업체 저장
		db.setCommand(
				"delete from tcb_cust where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' ",
				null);
		String[] member_no = f.getArr("member_no");
		String[] cust_gubun = f.getArr("cust_gubun");
		String[] cust_sign_seq = f.getArr("cust_sign_seq");
		String[] vendcd = f.getArr("vendcd");
		String[] jumin_no = f.getArr("jumin_no");
		String[] member_name = f.getArr("member_name");
		String[] boss_name = f.getArr("boss_name");
		String[] post_code = f.getArr("post_code");
		String[] address = f.getArr("address");
		String[] tel_num = f.getArr("tel_num");
		String[] member_slno = f.getArr("member_slno");
		String[] user_name = f.getArr("user_name");
		String[] hp1 = f.getArr("hp1");
		String[] hp2 = f.getArr("hp2");
		String[] hp3 = f.getArr("hp3");
		String[] email = f.getArr("email");
		int member_cnt = member_no == null ? 0 : member_no.length;
		DataObject custDao = null;
		for (int i = 0; i < member_cnt; i++) {
			custDao = new DataObject("tcb_cust");
			custDao.item("cont_no", cont_no);
			custDao.item("cont_chasu", cont_chasu);
			custDao.item("member_no", member_no[i]);
			custDao.item("sign_seq", cust_sign_seq[i]);
			custDao.item("cust_gubun", cust_gubun[i]);// 01:사업자 02:개인
			custDao.item("vendcd", vendcd[i].replaceAll("-", ""));
			if (cust_gubun[i].equals("02") && !jumin_no[i].equals("")) {
				custDao.item("jumin_no", new Security().AESencrypt(jumin_no[i].replaceAll("-", "")));
			}
			custDao.item("member_name", member_name[i]);
			custDao.item("boss_name", boss_name[i]);
			custDao.item("post_code", post_code[i].replaceAll("-", ""));
			custDao.item("address", address[i]);
			custDao.item("tel_num", tel_num[i]);
			custDao.item("member_slno", member_slno[i].replaceAll("-", ""));
			custDao.item("user_name", user_name[i]);
			custDao.item("hp1", hp1[i]);
			custDao.item("hp2", hp2[i]);
			custDao.item("hp3", hp3[i]);
			custDao.item("email", email[i]);
			custDao.item("display_seq", i);
			custDS.first();
			while (custDS.next()) {
				if (custDS.getString("member_no").equals(member_no[i]) && !custDS.getString("pay_yn").equals("")) {
					custDao.item("pay_yn", custDS.getString("pay_yn"));
				}
			}

			db.setCommand(custDao.getInsertQuery(), custDao.record);
		}

		db.setCommand(" update tcb_cust "
				+ "    set list_cust_yn = decode(display_seq, (select min(display_seq)  from tcb_cust where cont_no = '"
				+ cont_no + "' and cont_chasu = '" + cont_chasu + "' and member_no <> '" + _member_no + "' ),'Y') "
				+ "  where cont_no = '" + cont_no + "' " + "    and cont_chasu = '" + cont_chasu + "' ", null);

		// 계약서류
		db.setCommand(
				"delete from tcb_cfile where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' ",
				null);

		f.uploadDir = Startup.conf.getString("file.path.bcont_pdf") + fileDir;
		String file_hash = "";
		String[] cfile_seq = f.getArr("cfile_seq");
		String[] cfile_doc_name = f.getArr("cfile_doc_name");
		int cfile_seq_real = 1;
		int cfile_cnt = cfile_seq == null ? 0 : cfile_seq.length;
		DataObject cfileDao = null;
		for (int i = 0; i < cfile_cnt; i++) {
			String cfile_name = "";
			cfileDao = new DataObject("tcb_cfile");
			cfileDao.item("cont_no", cont_no);
			cfileDao.item("cont_chasu", cont_chasu);
			cfileDao.item("cfile_seq", cfile_seq_real++);
			cfileDao.item("doc_name", cfile_doc_name[i]);
			cfileDao.item("file_path", fileDir);
			File attFile = f.saveFileTime("cfile_" + cfile_seq[i]);
			if (attFile == null) {
				cfileDS.first();
				while (cfileDS.next()) {
					if (cfile_seq[i].equals(cfileDS.getString("cfile_seq"))) {
						cfileDao.item("file_name", cfileDS.getString("file_name"));
						cfileDao.item("file_ext", cfileDS.getString("file_ext"));
						cfileDao.item("file_size", cfileDS.getString("file_size"));
						cfile_name = cfileDS.getString("file_name");
					}
				}
			} else {
				cfileDao.item("file_name", attFile.getName());
				cfileDao.item("file_ext", u.getFileExt(attFile.getName()));
				cfileDao.item("file_size", attFile.length());
				cfile_name = attFile.getName();
			}
			if (cfile_name.equals("")) {
				throw new Exception("INSERT_FILE_INFO_ERR");
			}
			cfileDao.item("auto_yn", "N");
			db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
			file_hash += "|" + contDao.getHash("file.path.bcont_pdf", fileDir + cfile_name);
		}

		// 보증서
		db.setCommand(
				"delete from tcb_warr where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' ",
				null);
		String[] warr_type = f.getArr("warr_type");
		String[] warr_etc = f.getArr("warr_etc");
		int warr_cnt = warr_type == null ? 0 : warr_type.length;
		DataObject warrDao = null;
		for (int i = 0; i < warr_cnt; i++) {
			warrDao = new DataObject("tcb_warr");
			warrDao.item("cont_no", cont_no);
			warrDao.item("cont_chasu", cont_chasu);
			warrDao.item("member_no", "");
			warrDao.item("warr_seq", i);
			warrDao.item("warr_type", warr_type[i]);
			warrDao.item("etc", warr_etc[i]);
			db.setCommand(warrDao.getInsertQuery(), warrDao.record);
		}

		// 구비서류
		db.setCommand(
				"delete from tcb_rfile where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' ",
				null);
		String[] attch_yn = f.getArr("attch_yn");
		String[] rfile_doc_name = f.getArr("rfile_doc_name");
		int rfile_cnt = rfile_doc_name == null ? 0 : rfile_doc_name.length;
		DataObject rfileDao = null;
		for (int i = 0; i < rfile_cnt; i++) {
			rfileDao = new DataObject("tcb_rfile");
			rfileDao.item("cont_no", cont_no);
			rfileDao.item("cont_chasu", cont_chasu);
			rfileDao.item("rfile_seq", i + 1);
			rfileDao.item("attch_yn", attch_yn[i].equals("Y") ? "Y" : "N");
			rfileDao.item("doc_name", rfile_doc_name[i]);
			db.setCommand(rfileDao.getInsertQuery(), rfileDao.record);
		}

		// 인지세
		if (useinfoDS.getString("stampyn").equals("Y")) {
			db.setCommand("delete from tcb_stamp where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu
					+ "' ", null);
			int nStampType = f.getInt("stamp_type");
			for (int i = 0; i < member_cnt; i++) {
				if (nStampType == 0)
					break; // 해당 사항 없음
				if (nStampType == 1 && i == 1)
					continue; // 원사업자 납부
				if (nStampType == 2 && i == 0)
					continue; // 수급사업자 납부

				DataObject stampDao = new DataObject("tcb_stamp");
				stampDao.item("cont_no", cont_no);
				stampDao.item("cont_chasu", cont_chasu);
				stampDao.item("member_no", member_no[i]);
				db.setCommand(stampDao.getInsertQuery(), stampDao.record);
			}
		}

		/* 내부서류 */
		db.setCommand(
				"delete from tcb_efile where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' ",
				null);
		String[] efile_seq = f.getArr("efile_seq");
		/*
		 * System.out.println("efile_seq.length["+efile_seq.length+"]");
		 */

		String[] efile_reg_type = f.getArr("efile_reg_type");
		String[] efile_doc_name = f.getArr("efile_doc_name");
		String[] efile_del_yn = f.getArr("efile_del_yn");
		int efile_cnt = efile_seq == null ? 0 : efile_seq.length;
		DataObject efileDao = null;
		for (int i = 0; i < efile_cnt; i++) {
			efileDao = new DataObject("tcb_efile");
			efileDao.item("cont_no", cont_no);
			efileDao.item("cont_chasu", cont_chasu);
			efileDao.item("efile_seq", efile_seq[i]);
			efileDao.item("doc_name", efile_doc_name[i]);
			File attfile = f.saveFileTime("efile_" + efile_seq[i]);
			String efile_name = "";
			if (attfile == null) {
				if (!efile_del_yn[i].equals("Y")) {
					efileDS.first();
					while (efileDS.next()) {
						if (efile_seq[i].equals(efileDS.getString("efile_seq"))) {
							efileDao.item("file_path", fileDir);
							efileDao.item("file_name", efileDS.getString("file_name"));
							efileDao.item("file_ext", efileDS.getString("file_ext"));
							efileDao.item("file_size", efileDS.getString("file_size"));
							efileDao.item("reg_date", efileDS.getString("reg_date"));
							efileDao.item("reg_id", efileDS.getString("reg_id"));
						}
					}
				} else {
					efileDao.item("file_path", "");
					efileDao.item("file_name", "");
					efileDao.item("file_ext", "");
					efileDao.item("file_size", "");
					efileDao.item("reg_date", efileDS.getString("reg_date"));
					efileDao.item("reg_id", efileDS.getString("reg_id"));
				}

			} else {
				efileDao.item("file_path", fileDir);
				efileDao.item("file_name", attfile.getName());
				efileDao.item("file_ext", u.getFileExt(attfile.getName()));
				efileDao.item("file_size", attfile.length());
				efileDao.item("reg_date", u.getTimeString());
				efileDao.item("reg_id", auth.getString("_USER_ID"));
			}
			efileDao.item("reg_type", efile_reg_type[i]);
			db.setCommand(efileDao.getInsertQuery(), efileDao.record);
		}

		ContractDao cont2 = new ContractDao();
		cont2.item("cont_hash", file_hash);
		if (agree_cnt > 0) {
			cont2.item("agree_field_seqs", agree_field_seqs);
			cont2.item("agree_person_ids", agree_person_ids);
		}
		db.setCommand(cont2.getUpdateQuery("cont_no= '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'"),
				cont2.record);

		/* 계약로그 START */
		ContBLogDao logDao = new ContBLogDao();
		logDao.setInsert(db, cont_no, String.valueOf(cont_chasu), auth.getString("_MEMBER_NO"),
				auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 수정", "",
				"10", "20");
		/* 계약로그 END */

		if (!db.executeArray()) {
			throw new Exception("SAVE_ERR");
		}
	} catch (Exception e) {
		String errCode = e.getMessage();
		if (u.inArray(errCode,
				new String[] { "NO_CUST_DATA", "USEINFO_ERR", "INSERT_FILE_INFO_ERR", "SAVE_ERR" })) {
			if ("NO_CUST_DATA".equals(errCode)) {
				rtnMap.put("msg", "계약업체 정보가 존재 하지 않습니다.");
			} else if ("USEINFO_ERR".equals(errCode)) {
				rtnMap.put("msg", "서비스 이용기간이 종료 되었습니다.\\\\n\\\\n나이스다큐 고객센터[02-788-9097]에 문의하세요.");
			} else if ("INSERT_FILE_INFO_ERR".equals(errCode)) {
				rtnMap.put("msg", "파일정보 저장에 실패 하였습니다.");
			} else if ("SAVE_ERR".equals(errCode)) {
				rtnMap.put("msg", "저장에 실패 하였습니다.");
			}
		} else {
			rtnMap.put("code", "OTHER_ERR");
			rtnMap.put("msg", "저장에 실패하였습니다.");
		}
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	return rtnMap;
}%>