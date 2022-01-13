<%-- 
<%@ page import="java.util.*,java.io.*,nicelib.db.*,nicelib.util.*,dao.*" %>
<%@page import="procure.common.conf.Startup"%>
<%@page import="procure.common.utils.*"%> 
--%>
<%!/**
		 * 자필서명 양식의 계약정보 저장
		 * @param response
		 * @param request
		 * @param u
		 * @param f
		 * @param _member_no
		 * @param auth
		 */
	public java.util.Map<String, String> _saveMsignContract(HttpServletResponse response, HttpServletRequest request, Util u,
			Form f, String _member_no, Auth auth) {
		Map<String, String> rtnMap = new HashMap<String, String>();
		rtnMap.put("code", "SUCC");
		rtnMap.put("msg", "저장하였습니다");
		rtnMap.put("url", "contract_msign_modify.jsp?" + u.getQueryString());
		try {
			String cont_no = u.aseDec(u.request("cont_no"));
			String cont_chasu = u.request("cont_chasu", "0");
			String template_cd = u.request("template_cd");

			response.setHeader("Cache-Control", "no-Cache, no-store, must-revalidate");

			/* 계약정보 조회 */
			DataSet contmasterDS = new DataObject("tcb_contmaster")
					.find(" cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'and status = '10'");
			if (contmasterDS.next()) {
				if ("".equals(template_cd)) {
					template_cd = contmasterDS.getString("template_cd");
				}
			} else {
				throw new Exception("NO_CONT_DATA");
			}

			/* 서식정보 조회 */
			DataSet contTemplateDS = new DataObject("tcb_cont_template").find(" template_cd ='" + template_cd + "'");
			if (!contTemplateDS.next()) {
			}

			/* 계약업체 조회 */
			DataSet custDS = new DataObject().query(" select a.*, nvl(b.member_gubun,'04') member_gubun "
					+ "   from tcb_cust a, tcb_member b       " + "  where a.member_no = b.member_no(+)   "
					+ "    and a.cont_no = '" + cont_no + "'      " + "    and a.cont_chasu = '" + cont_chasu + "'"
					+ "    and a.sign_seq <= 10               " + "  order by display_seq  asc            "); // sign_seq
																																																																																																	// 가
																																																																																																	// 10보다
																																																																																																	// 큰거는
																																																																																																	// 연대보증
			if (!custDS.next()) {
				throw new Exception("NO_CUST_DATA");
			}

			/* 갑사정보 조회 */
			DataSet memberDS = new DataObject("tcb_member").find("member_no = '" + _member_no + "' ");
			if (!memberDS.next()) {
				throw new Exception("NO_MEMBER_DATA");
			}

			/* 계약서류 조회 */
			DataSet cfileDS = new DataObject("tcb_cfile")
					.find(" cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'");

			// 내부 관리 서류 조회
			DataSet efileDS = new DataObject("tcb_efile")
					.find(" cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'");

			// 계약서 저장
			String random_no = u.strpad(u.getRandInt(0, 99999) + "", 5, "0");

			String cont_html_rm_str = "";
			String[] cont_html_rm = f.getArr("cont_html_rm");
			String[] cont_html = f.getArr("cont_html");
			String[] cont_sub_name = f.getArr("cont_sub_name");
			String[] cont_sub_style = f.getArr("cont_sub_style");
			String[] gubun = f.getArr("gubun");
			String[] sub_seq = f.getArr("sub_seq");

			// decodeing 처리 START
			for (int i = 0; i < cont_html_rm.length; i++) {

				cont_html_rm[i] = new String(Base64Coder.decode(cont_html_rm[i]), "UTF-8");

			}
			for (int i = 0; i < cont_html.length; i++) {
				cont_html[i] = new String(Base64Coder.decode(cont_html[i]), "UTF-8");
			}
			// decodeing 처리 END

			String arrOption_yn[] = new String[cont_html_rm.length];

			for (int i = 0; i < cont_html_rm.length; i++) {
				arrOption_yn[i] = f.get("option_yn_" + i);
			}

			for (int i = 0; i < cont_html_rm.length; i++) {
				if (i != 0)
					cont_html_rm_str += "<pd4ml:page.break>";
				if (gubun[i].equals("10")) {
					cont_html_rm_str += cont_html_rm[i];
				}
			}

			ArrayList autoFiles = new ArrayList();

			int file_seq = 1;

			String cont_userno = "";
			/*
			 * if(bAutoContUserNo) // 그루폰의 경우는 계약관리번호를 사용자 계약번호로 셋팅 cont_userno = cont_no +
			 * "-" + cont_chasu; else
			 */
			cont_userno = f.get("cont_userno");

			ContractDao contDao = new ContractDao();

			// 계약서파일 생성
			DataSet pdfInfo = new DataSet();
			pdfInfo.addRow();
			pdfInfo.put("member_no", _member_no);
			pdfInfo.put("cont_no", cont_no);
			pdfInfo.put("cont_chasu", cont_chasu);
			pdfInfo.put("random_no", random_no);
			pdfInfo.put("cont_userno", cont_userno);
			pdfInfo.put("html", cont_html_rm_str);
			pdfInfo.put("doc_type", contTemplateDS.getString("doc_type"));
			pdfInfo.put("file_seq", file_seq++);
			DataSet pdf = contDao.makePdf(pdfInfo);
			if (pdf == null) {
				throw new Exception("MAKE_FILE_ERR");
			}

			// 자동생성파일 생성
			for (int i = 0; i < cont_html_rm.length; i++) {
				if (gubun[i].equals("20") || gubun[i].equals("50") // 작성업체만 보고 인쇄하는 양식(서명대상 X)
						|| (gubun[i].equals("40") && arrOption_yn[i].equals("A") || arrOption_yn[i].equals("Y")) // 자동으로
																													// 생성되는
																													// 양식
																													// 또는
																													// 체크된
																													// 양식인
																													// 경우
				) {
					DataSet pdfInfo2 = new DataSet();
					pdfInfo2.addRow();
					pdfInfo2.put("member_no", _member_no);
					pdfInfo2.put("cont_no", cont_no);
					pdfInfo2.put("cont_chasu", cont_chasu);
					pdfInfo2.put("random_no", random_no);
					pdfInfo2.put("cont_userno", cont_userno);
					pdfInfo2.put("html", cont_html_rm[i]);
					pdfInfo2.put("doc_type", contTemplateDS.getString("doc_type"));
					pdfInfo2.put("file_seq", file_seq++);
					DataSet pdf2 = contDao.makePdf(pdfInfo2);
					pdf2.put("cont_sub_name", cont_sub_name[i]);
					pdf2.put("gubun", gubun[i]);
					autoFiles.add(pdf2);
				}
			}

			// 계약기간구하기
			String cont_sdate = f.get("cont_sdate").replaceAll("-", "");
			String cont_edate = f.get("cont_edate").replaceAll("-", "");
			;
			if (!f.get("cont_syear").equals("") && !f.get("cont_smonth").equals("") && !f.get("cont_sday").equals("")) {
				cont_sdate = u.strrpad(f.get("cont_syear"), 4, "0") + u.strrpad(f.get("cont_smonth"), 2, "0")
						+ u.strrpad(f.get("cont_sday"), 2, "0");
			}
			// 계약종료일이 없는 경우 계약기간 +1년이다.
			if (!f.get("cont_eyear").equals("") && !f.get("cont_emonth").equals("") && !f.get("cont_eday").equals("")) {
				cont_edate = u.strrpad(f.get("cont_eyear"), 4, "0") + u.strrpad(f.get("cont_emonth"), 2, "0")
						+ u.strrpad(f.get("cont_eday"), 2, "0");
			} else if (!f.get("cont_term").equals("")) {
				Date date = u.addDate("D", -1, u.strToDate("yyyy-MM-dd", f.get("cont_date")));
				cont_sdate = f.get("cont_date").replaceAll("-", "");
				cont_edate = u.addDate("Y", Integer.parseInt(f.get("cont_term")), date, "yyyyMMdd");
			} else if (!f.get("cont_term_month").equals("")) {
				Date date = u.addDate("D", -1, u.strToDate("yyyy-MM-dd", f.get("cont_date")));
				cont_sdate = f.get("cont_date").replaceAll("-", "");
				cont_edate = u.addDate("M", Integer.parseInt(f.get("cont_term_month")), date, "yyyyMMdd");
			}
			if (cont_sdate.equals("") && !cont_edate.equals(""))
				cont_sdate = f.get("cont_date").replaceAll("-", "");

			DB db = new DB();
			// db.setDebug(out);
			contDao = new ContractDao();

			contDao.item("member_no", _member_no);
			contDao.item("template_cd", template_cd);
			contDao.item("cont_name", f.get("cont_name"));
			contDao.item("cont_date", f.get("cont_date").replaceAll("-", ""));
			contDao.item("cont_sdate", cont_sdate);
			contDao.item("cont_edate", cont_edate);
			contDao.item("supp_tax", f.get("supp_tax").replaceAll(",", ""));
			contDao.item("supp_taxfree", f.get("supp_taxfree").replaceAll(",", ""));
			contDao.item("supp_vat", f.get("supp_vat").replaceAll(",", ""));
			contDao.item("cont_total", f.get("cont_total").replaceAll(",", ""));
			contDao.item("cont_userno", cont_userno);
			contDao.item("cont_html", cont_html[0]);
			contDao.item("org_cont_html", cont_html[0]);
			contDao.item("reg_date", u.getTimeString());
			contDao.item("true_random", random_no);
			contDao.item("status", "10");
			contDao.item("stamp_type", f.get("stamp_type"));
			contDao.item("change_gubun", f.get("change_gubun"));
			contDao.item("src_cd", f.get("src_cd"));
			if (!f.get("cont_etc1").equals("")) {
				contDao.item("cont_etc1", f.get("cont_etc1"));
			}

			db.setCommand(contDao.getUpdateQuery(" cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'"),
					contDao.record);

			for (int i = 1; i < cont_html.length; i++) {
				DataObject cont_sub = new DataObject("tcb_cont_sub");
				cont_sub.item("cont_sub_html", cont_html[i]);
				cont_sub.item("org_cont_sub_html", cont_html[i]);
				cont_sub.item("cont_sub_name", cont_sub_name[i]);
				cont_sub.item("cont_sub_style", cont_sub_style[i]);
				cont_sub.item("option_yn", arrOption_yn[i]);
				db.setCommand(cont_sub.getUpdateQuery(
						" cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' and sub_seq = " + i),
						cont_sub.record);
			}

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
				db.setCommand("delete from tcb_agree_user where template_cd = '" + template_cd + "' and user_id = '"
						+ auth.getString("_USER_ID") + "' ", null);
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

					// 본인 결재 라인에 저장
					DataObject cont_agree_user = new DataObject("tcb_agree_user");
					cont_agree_user.item("template_cd", template_cd);
					cont_agree_user.item("user_id", auth.getString("_USER_ID"));
					cont_agree_user.item("agree_seq", agree_seq[i]);
					cont_agree_user.item("agree_name", agree_name[i]);
					cont_agree_user.item("agree_field_seq", agree_field_seq[i]);
					cont_agree_user.item("agree_person_name", agree_person_name[i]);
					cont_agree_user.item("agree_person_id", agree_person_id[i]);
					cont_agree_user.item("agree_cd", agree_cd[i]); // 결재구분코드(0:업체서명전, 1:업체서명후)
					db.setCommand(cont_agree_user.getInsertQuery(), cont_agree_user.record);
				}
			}

			// 업체 저장
			db.setCommand(
					"delete from tcb_cust where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' ",
					null);
			String[] member_no = f.getArr("member_no");
			String[] cust_sign_seq = f.getArr("cust_sign_seq");
			String[] vendcd = f.getArr("vendcd");
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
			String[] jumin_no = f.getArr("jumin_no");
			String[] member_gubun = f.getArr("member_gubun"); // 01:법인(본사), 02:법인(지사), 03:개인사업자
			String[] cust_gubun = f.getArr("cust_gubun");
			String[] cust_detail_code = f.getArr("cust_detail_code");
			String[] boss_birth_date = f.getArr("boss_birth_date");
			String[] boss_gender = f.getArr("boss_gender");
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
				if (cust_gubun[i].equals("01") && !jumin_no[i].equals("")) { // 개인사업자이지만 생년월일이 있는 경우
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
				custDao.item("cust_detail_code", cust_detail_code[i]);
				custDao.item("boss_birth_date", boss_birth_date[i].replaceAll("-", ""));
				custDao.item("boss_gender", boss_gender[i]);
				custDS.first();
				while (custDS.next()) {
					if (custDS.getString("member_no").equals(member_no[i]) && !custDS.getString("pay_yn").equals("")) {
						custDao.item("pay_yn", custDS.getString("pay_yn"));
					}
				}

				if (member_no[i].startsWith("0")) {
					custDao.item("boss_name", member_name[i]);
					custDao.item("user_name", member_name[i]);
				}

				db.setCommand(custDao.getInsertQuery(), custDao.record);

				// 소싱카테고리를 관리하는 업체고 계약서 작성시 소싱그룹 지정이 되어 있다면 작성시 지정한 소싱 그룹으로 소싱 정보를 입력한다. (단, 소싱
				// 그룹은 1개업체가 여러군데 지정될 수 있으므로 insert만 한다.)
				if (!memberDS.getString("src_depth").equals("") && !f.get("src_cd").equals("")
						&& !member_no[i].equals(_member_no)) {
					DataObject srcDao = new DataObject("tcb_src_member");
					if (srcDao.findCount("member_no='" + _member_no + "' and src_member_no='" + member_no[i]
							+ "' and src_cd='" + f.get("src_cd") + "'") == 0) {
						srcDao.item("member_no", _member_no);
						srcDao.item("src_member_no", member_no[i]);
						srcDao.item("src_cd", f.get("src_cd"));
						db.setCommand(srcDao.getInsertQuery(), srcDao.record);
					}
				}

			}

			db.setCommand(" update tcb_cust "
					+ "    set list_cust_yn = decode(display_seq, (select min(display_seq)  from tcb_cust where cont_no = '"
					+ cont_no + "' and cont_chasu = '" + cont_chasu + "' and member_no <> '" + _member_no + "' ),'Y') "
					+ "  where cont_no = '" + cont_no + "' " + "    and cont_chasu = '" + cont_chasu + "' ", null);

			int cfile_seq_real = 1;
			String file_hash = pdf.getString("file_hash");
			f.uploadDir = Startup.conf.getString("file.path.bcont_pdf") + pdf.getString("file_path");
			// 계약서류갑지
			db.setCommand(
					"delete from tcb_cfile where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' ",
					null);
			DataObject cfileDao = new DataObject("tcb_cfile");
			cfileDao.item("cont_no", cont_no);
			cfileDao.item("cont_chasu", cont_chasu);
			cfileDao.item("cfile_seq", cfile_seq_real++);
			cfileDao.item("doc_name", contTemplateDS.getString("template_name"));
			cfileDao.item("file_path", pdf.getString("file_path"));
			cfileDao.item("file_name", pdf.getString("file_name"));
			cfileDao.item("file_ext", pdf.getString("file_ext"));
			cfileDao.item("file_size", pdf.getString("file_size"));
			cfileDao.item("auto_yn", "Y");
			cfileDao.item("auto_type", "");
			db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);

			// 자동생성파일
			System.out.println("autoFiles.size() ==> " + autoFiles.size());
			for (int i = 0; i < autoFiles.size(); i++) {
				DataSet temp = (DataSet) autoFiles.get(i);
				cfileDao = new DataObject("tcb_cfile");
				cfileDao.item("cont_no", cont_no);
				cfileDao.item("cont_chasu", cont_chasu);
				cfileDao.item("cfile_seq", cfile_seq_real++);
				cfileDao.item("doc_name", temp.getString("cont_sub_name"));
				cfileDao.item("file_path", temp.getString("file_path"));
				cfileDao.item("file_name", temp.getString("file_name"));
				cfileDao.item("file_ext", temp.getString("file_ext"));
				cfileDao.item("file_size", temp.getString("file_size"));
				cfileDao.item("auto_yn", "Y");
				if (temp.getString("gubun").equals("50")) // 작성업체만 보고 인쇄하는 양식은 서명대상이 아님. gubun[i].equals("50")
					cfileDao.item("auto_type", "3"); // null:자동생성, 1:자동첨부, 2:필수첨부, 3:내부용
				else {
					file_hash += "|" + temp.getString("file_hash");
					cfileDao.item("auto_type", "");
				}
				db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
			}

			String[] cfile_seq = f.getArr("cfile_seq");
			String[] cfile_doc_name = f.getArr("cfile_doc_name");
			String[] cfile_auto_type = f.getArr("cfile_auto_type");
			int cfile_cnt = cfile_seq == null ? 0 : cfile_seq.length;
			for (int i = 0; i < cfile_cnt; i++) {
				if (cfile_auto_type[i].equals("0") || cfile_auto_type[i].equals("3")) { // 자동생성 또는 내부용
					continue;
				}
				String cfile_name = "";
				cfileDao = new DataObject("tcb_cfile");
				cfileDao.item("cont_no", cont_no);
				cfileDao.item("cont_chasu", cont_chasu);
				cfileDao.item("cfile_seq", cfile_seq_real++);
				cfileDao.item("doc_name", cfile_doc_name[i]);
				cfileDao.item("file_path", pdf.getString("file_path"));
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
				cfileDao.item("auto_yn", cfile_auto_type[i].equals("") ? "N" : "Y");
				cfileDao.item("auto_type", cfile_auto_type[i]);
				db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
				file_hash += "|" + contDao.getHash("file.path.bcont_pdf", pdf.getString("file_path") + cfile_name);
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
			db.setCommand("delete from tcb_rfile_cust where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu
					+ "' ", null);
			db.setCommand(
					"delete from tcb_rfile where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' ",
					null);
			DataObject rfile_cust = null;
			String[] rfile_seq = f.getArr("rfile_seq");
			String[] attch_yn = f.getArr("attch_yn");
			String[] rfile_doc_name = f.getArr("rfile_doc_name");
			String[] rfile_attch_type = f.getArr("attch_type");
			String[] reg_type = f.getArr("reg_type");
			String[] allow_ext = f.getArr("allow_ext");
			int rfile_cnt = rfile_seq == null ? 0 : rfile_seq.length;
			DataObject rfileDao = null;
			for (int i = 0; i < rfile_cnt; i++) {
				rfileDao = new DataObject("tcb_rfile");
				rfileDao.item("cont_no", cont_no);
				rfileDao.item("cont_chasu", cont_chasu);
				rfileDao.item("rfile_seq", rfile_seq[i]);
				rfileDao.item("attch_yn", attch_yn[i].equals("Y") ? "Y" : "N");
				rfileDao.item("doc_name", rfile_doc_name[i]);
				rfileDao.item("reg_type", reg_type[i]);
				rfileDao.item("allow_ext", allow_ext[i]);
				db.setCommand(rfileDao.getInsertQuery(), rfileDao.record);

				if (rfile_attch_type[i].equals("2")) {// 직접첨부 인경우
					rfile_cust = new DataObject("tcb_rfile_cust");
					rfile_cust.item("cont_no", cont_no);
					rfile_cust.item("cont_chasu", cont_chasu);
					rfile_cust.item("member_no", _member_no);
					rfile_cust.item("rfile_seq", rfile_seq[i]);
					File file = f.saveFileTime("rfile_" + rfile_seq[i]);
					if (file == null) {
						rfile_cust.item("file_path", "");
						rfile_cust.item("file_name", "");
						rfile_cust.item("file_ext", "");
						rfile_cust.item("file_size", "");
						rfile_cust.item("reg_gubun", "");
					} else {
						rfile_cust.item("file_path", pdf.getString("file_path"));
						rfile_cust.item("file_name", file.getName());
						rfile_cust.item("file_ext", u.getFileExt(file.getName()));
						rfile_cust.item("file_size", file.length());
						rfile_cust.item("reg_gubun", "20");
					}
					db.setCommand(rfile_cust.getInsertQuery(), rfile_cust.record);
				}

				if (rfile_attch_type[i].equals("3")) {
					rfile_cust = new DataObject("tcb_rfile_cust");
					rfile_cust.item("cont_no", cont_no);
					rfile_cust.item("cont_chasu", cont_chasu);
					rfile_cust.item("member_no", _member_no);
					rfile_cust.item("rfile_seq", rfile_seq[i]);
					rfile_cust.item("file_path", f.get("rfile_file_path_" + rfile_seq[i]));
					rfile_cust.item("file_name", f.get("rfile_file_name_" + rfile_seq[i]));
					rfile_cust.item("file_ext", f.get("rfile_file_ext_" + rfile_seq[i]));
					rfile_cust.item("file_size", f.get("rfile_file_size_" + rfile_seq[i]));
					db.setCommand(rfile_cust.getInsertQuery(), rfile_cust.record);
				}
			}

			// 내부관리서류
			if (contmasterDS.getString("efile_yn").equals("Y")) {
				db.setCommand("delete from tcb_efile where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu
						+ "' ", null);
				String[] efile_seq = f.getArr("efile_seq");
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
									efileDao.item("file_path", pdf.getString("file_path"));
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
						efileDao.item("file_path", pdf.getString("file_path"));
						efileDao.item("file_name", attfile.getName());
						efileDao.item("file_ext", u.getFileExt(attfile.getName()));
						efileDao.item("file_size", attfile.length());
						efileDao.item("reg_date", u.getTimeString());
						efileDao.item("reg_id", auth.getString("_USER_ID"));
					}
					efileDao.item("reg_type", efile_reg_type[i]);
					db.setCommand(efileDao.getInsertQuery(), efileDao.record);
				}
			}

			// 인지세
			if (contTemplateDS.getString("stamp_yn").equals("Y")) {
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

			ContractDao cont2 = new ContractDao();
			cont2.item("cont_hash", file_hash);
			if (agree_cnt > 0) {
				cont2.item("agree_field_seqs", agree_field_seqs);
				cont2.item("agree_person_ids", agree_person_ids);
			}
			db.setCommand(cont2.getUpdateQuery("cont_no= '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'"),
					cont2.record);

			// 계약서 추가 입력정보 (DB화하여 검색이 필요한 경우)
			DataObject tempaddDao = new DataObject("tcb_cont_template_add");
			DataSet tempaddDs = tempaddDao.find("template_cd = '" + template_cd + "'");
			db.setCommand(
					"delete from tcb_cont_add where cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'",
					null);

			if (tempaddDs.size() > 0) {
				DataObject contaddDao = new DataObject("tcb_cont_add"); // Array가 아닌 데이터는 복수인 데이터.
				contaddDao.item("cont_no", cont_no);
				contaddDao.item("cont_chasu", cont_chasu);
				contaddDao.item("seq", 1);

				while (tempaddDs.next()) {
					if (tempaddDs.getString("mul_yn").equals("Y")) { // 복수
						String[] colVals = f.getArr(tempaddDs.getString("template_name_en"));
						String colVal = "";
						for (int i = 0; i < colVals.length; i++) {
							colVal += colVals[i] + "|";
						}
						contaddDao.item(tempaddDs.getString("col_name"), colVal);
					} else { // 단수
						contaddDao.item(tempaddDs.getString("col_name"),
								f.get(tempaddDs.getString("template_name_en")));
					}

				}
				db.setCommand(contaddDao.getInsertQuery(), contaddDao.record);
			}

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
			if (u.inArray(errCode, new String[] { "NO_CONT_DATA", "MAKE_FILE_ERR", "INSERT_FILE_INFO_ERR", "SAVE_ERR",
					"NO_CUST_DATA", "NO_MEMBER_DATA" })) {
				rtnMap.put("code", errCode);
				if ("NO_CONT_DATA".equals(errCode)) {
					rtnMap.put("msg", "계약정보가 존재 하지 않습니다.");
				} else if ("MAKE_FILE_ERR".equals(errCode)) {
					rtnMap.put("msg", "계약서 파일 생성에 실패 하였습니다.");
				} else if ("INSERT_FILE_INFO_ERR".equals(errCode)) {
					rtnMap.put("msg", "파일정보 저장에 실패 하였습니다.");
				} else if ("SAVE_ERR".equals(errCode)) {
					rtnMap.put("msg", "저장에 실패 하였습니다.");
				} else if ("NO_CUST_DATA".equals(errCode)) {
					rtnMap.put("msg", "계약업체 정보가 존재 하지 않습니다.");
				} else if ("NO_MEMBER_DATA".equals(errCode)) {
					rtnMap.put("msg", "사용자 정보가 존재하지 않습니다.");
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