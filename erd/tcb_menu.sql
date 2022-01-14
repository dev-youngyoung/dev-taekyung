SET DEFINE OFF;
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000001', '000000', 1, 'bid', 
    '견적/입찰관리', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000010', '000001', 2, 'bid', 
    '구매요청', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000031', '000010', 3, 'bid', '../buyreq/buy_req_list.jsp', 
    '구매요청작성', 'Y', 1, '010201');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000032', '000010', 3, 'bid', '../buyreq/buy_report_list.jsp', 
    '구매요청현황', 'Y', 2, '010202');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000011', '000001', 2, 'bid', 
    '견적관리', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000033', '000011', 3, 'bid', '../esti/gap_esti_list.jsp', 
    '견적요청현황', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 1, '010501');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000034', '000011', 3, 'bid', '../esti/gap_esti_rlist.jsp', 
    '견적결과', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 2, '010502');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000012', '000001', 2, 'bid', 
    '입찰관리', 3);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000035', '000012', 3, 'bid', '../bid/buy_rpt_list.jsp', 
    '구매요청접수', 'Y', 1, '010109');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000036', '000012', 3, 'bid', '../bid/gap_plan_list.jsp', 
    '입찰계획', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 2, '010101');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000037', '000012', 3, 'bid', '../bid/donghee/gap_confirm_list.jsp', 
    '대상업체검토', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 3, '동희오토전용', '010111');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000038', '000012', 3, 'bid', '../bid/gap_field_list.jsp', 
    '현설(사양)공고', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 4, '010102');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000039', '000012', 3, 'bid', '../bid/gap_bid_list.jsp', 
    '입찰공고', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 5, '010103');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000040', '000012', 3, 'bid', '../bid/gap_evaluate_list.jsp', 
    '기술(규격)평가', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 6, '010110');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000041', '000012', 3, 'bid', '../bid/gap_open_list.jsp', 
    '입찰서개찰', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 7, '010104');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000042', '000012', 3, 'bid', '../bid/gap_select_list.jsp', 
    '낙찰업체선정', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 8, '010105');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000043', '000012', 3, 'bid', '../bid/gap_result_list.jsp', 
    '입찰결과', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 9, '010106');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000044', '000012', 3, 'bid', '../bid/gap_charge_list.jsp', 
    '구매담당자변경', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 10, '010108');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000045', '000012', 3, 'bid', '../bid/gap_multiamt_list.jsp', 
    '복수예가관리', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 11, '010113');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000046', '000012', 3, 'bid', '../bid/dwst/project_item_list.jsp', 
    '프로젝트별 품목관리', 'Y', 12, '대우에스티 전용', '010112');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000013', '000001', 2, 'bid', 
    '현황관리', 4);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000047', '000013', 3, 'bid', '../bid/gap_watch_list.jsp', 
    '입찰진행현황', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 1, '010301');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000048', '000013', 3, 'bid', '../bid/gap_supp_mgr_list.jsp', 
    '입찰진행관리', 'Y', 'Y', 
    2, '위메프,인터파크비즈', '010302');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000049', '000013', 3, 'bid', '../bid/sungwoo/sungwoo_bid_list.jsp', 
    '입찰현황', 'Y', 'Y', 
    3, '현대성우홀딩스', '010303');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000014', '000001', 2, 'bid', 
    '참여지정공고(지명)', 5);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, EUL_YN, USE_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000050', '000014', 3, 'bid', '../bid/eul_bid_list.jsp', 
    '참여대상', 'Y', 'Y', 1, '010402');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, EUL_YN, USE_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000051', '000014', 3, 'bid', '../bid/eul_result_list.jsp', 
    '참여결과', 'Y', 'Y', 2, '010403');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000150', '000001', 2, 'bid', 
    '참여가능공고(공개)', 6);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, EUL_YN, USE_YN, DISPLAY_SEQ)
 Values
   ('000151', '000150', 3, 'bid', '../bid/eul_obid_list.jsp', 
    '입찰공고', 'Y', 'Y', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, EUL_YN, USE_YN, DISPLAY_SEQ)
 Values
   ('000152', '000150', 3, 'bid', '../bid/eul_oresult_list.jsp', 
    '입찰결과', 'Y', 'Y', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM)
 Values
   ('000203', '000001', 2, 'bid', '공람');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ)
 Values
   ('000204', '000203', 3, 'bid', '../bid/share_list.jsp', 
    '공람완료', 'Y', 'Y', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000002', '000000', 1, 'contract', 
    '계약관리', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000015', '000002', 2, 'contract', 
    '계약작성', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000052', '000015', 3, 'contract', '../contract/contract_select_bid.jsp', 
    '계약대상(전자입찰)', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 1, '020105');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000053', '000015', 3, 'contract', '../contract/contract_select_template.jsp', 
    '신규계약작성', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 2, '020101');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000054', '000015', 3, 'contract', '../contract/batch_contract_insert.jsp', 
    '일괄계약작성', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 3, 'sk브로드', '020108');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000153', '000015', 3, 'contract', '../contract/batch_contract_insert_hts.jsp', 
    '연봉계약일괄작성', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 4, '한수테크니컬서비스', '020110');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000170', '000015', 3, 'contract', '../contract/batch_contract_insert_we.jsp', 
    '일괄계약생성', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 5, '위메프', '020111');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000222', '000015', 3, 'contract', '../contract/batch_contract_insert_kintex2.jsp', 
    '일괄계약작성_개인', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 6, '킨텍스');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000191', '000015', 3, 'contract', '../contract/batch_contract_insert_cbo.jsp', 
    '일괄계약작성', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 6, '싸이버원');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC)
 Values
   ('000201', '000015', 3, 'contract', '../contract/batch_contract_insert_nicecms.jsp', 
    '일괄계약작성_나이스씨엠에스', 'Y', 'Y', 6, '나이스씨엠에스');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC)
 Values
   ('000208', '000015', 3, 'contract', '../contract/batch_contract_insert_winplus.jsp', 
    '일괄계약작성_윈플러스', 'Y', 'Y', 6, '윈플러스');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC)
 Values
   ('000202', '000015', 3, 'contract', '../contract/batch_contract_insert_playtime.jsp', 
    '일괄계약작성_플레이타임그룹', 'Y', 'Y', 6, '플레이타임그룹');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000212', '000015', 3, 'contract', '../contract/batch_contract_insert_hanjin.jsp', 
    '일괄계약작성_한진', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 6, '한진중공업');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000209', '000015', 3, 'contract', '../contract/batch_contract_insert_genie.jsp', 
    '일괄계약작성_지니뮤직', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 6, '지니뮤직');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC)
 Values
   ('000200', '000015', 3, 'contract', '../contract/batch_contract_insert_kbsjob.jsp', 
    '일괄계약작성_한국고용정보', 'Y', 'Y', 6, '한국고용정보');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000211', '000015', 3, 'contract', '../contract/batch_contract_insert_kintex.jsp', 
    '일괄계약작성_법인', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 6, '킨텍스');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000225', '000015', 3, 'contract', '../contract/batch_contract_insert_winplusmart.jsp', 
    '일괄계약작성', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 6, '원플러스마트');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000185', '000015', 3, 'contract', '../contract/batch_contract_insert_gtp.jsp', 
    '일괄계약작성', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 6, '경기테크노파크');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC)
 Values
   ('000196', '000015', 3, 'contract', '../contract/batch_contract_insert_woo.jsp', 
    '일괄계약작성', 'Y', 'Y', 6, '우아한청년들');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC)
 Values
   ('000197', '000015', 3, 'contract', '../contract/batch_contract_insert_inpro.jsp', 
    '일괄계약작성_인프로', 'Y', 'Y', 6, '인프로');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000055', '000015', 3, 'contract', '../contract/contract_free_template.jsp', 
    '자유서식 계약작성', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 6, '사업자만', '020102');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000223', '000015', 3, 'contract', '../contract/batch_contract_insert_wjfood_03.jsp', 
    '일괄계약작성_개인', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 6, '웅진식품');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000224', '000015', 3, 'contract', '../contract/batch_contract_insert_wjfood_01.jsp', 
    '일괄계약작성_법인', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 6, '웅진식품');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000194', '000015', 3, 'contract', '../contract/batch_contract_insert_dole.jsp', 
    '일괄계약작성_돌코리아', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 6, '돌코리아');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC)
 Values
   ('000195', '000015', 3, 'contract', '../contract/batch_contract_insert_cjfoodville.jsp', 
    '일괄계약전송', 'Y', 'Y', 6, 'CJ푸드빌');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC)
 Values
   ('000220', '000015', 3, 'contract', '../contract/batch_contract_insert_jette.jsp', 
    '일괄계약작성', 'Y', 'Y', 6, '제때');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000183', '000015', 3, 'contract', '../contract/batch_contract_insert_dnr.jsp', 
    '도급계약일괄작성', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 6, '나이스디앤알');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000019', '000002', 2, 'contract', 
    '공람', 5);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000198', '000015', 3, 'contract', '../contract/batch_contract_insert_meritz.jsp', 
    '폐기확인서일괄전송', 'Y', 'Y', '메리츠', 6);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC)
 Values
   ('000199', '000015', 3, 'contract', '../contract/batch_contract_insert_nicetcm.jsp', 
    '일괄계약작성', 'Y', 'Y', 6, '한국전자금융');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC)
 Values
   ('000206', '000015', 3, 'contract', '../contract/batch_contract_insert_treenod.jsp', 
    '일괄계약작성_트리노드', 'Y', 'Y', 6, '트리노드');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC)
 Values
   ('000207', '000015', 3, 'contract', '../contract/batch_contract_insert_goodtour.jsp', 
    '일괄계약작성_참좋은여행', 'Y', 'Y', 6, '참좋은여행');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000210', '000015', 3, 'contract', '../contract/batch_contract_insert_nicepay.jsp', 
    '일괄계약작성_나이스페이먼츠', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 6, '나이스페이먼츠');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000056', '000015', 3, 'contract', '../contract/contract_free_template2.jsp', 
    '자유서식 계약작성', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 7, '개인포함', '020107');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000221', '000015', 3, 'contract', '../contract/batch_contract_insert_jette2.jsp', 
    '일괄계약작성_개인', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 7, '제때');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000057', '000015', 3, 'contract', '../contract/offcont_template.jsp', 
    '서면계약등록', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 8, '020109');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000058', '000015', 3, 'contract', '../contract/contract_chang_list.jsp', 
    '변경계약작성', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 9, '020103');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000059', '000015', 3, 'contract', '../contract/contract_writing_list.jsp', 
    '임시저장 계약', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 10, '020104');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000016', '000002', 2, 'contract', 
    '계약진행', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000060', '000016', 3, 'contract', '../contract/contract_send_list.jsp', 
    '진행중(보낸계약)', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 1, '020201');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000228', '000016', 3, 'contract', '../contract/contract_sign_all_list.jsp', 
    '진행중(보낸계약_일괄서명)', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 1, '일괄서명');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, EUL_YN, USE_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000061', '000016', 3, 'contract', '../contract/contract_recv_list.jsp', 
    '진행중(받은계약)', 'Y', 'Y', 2, '020202');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000017', '000002', 2, 'contract', 
    '계약완료', 3);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000063', '000017', 3, 'contract', '../contract/contend_send_list.jsp', 
    '완료(보낸계약)', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 1, '020301');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, EUL_YN, USE_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000065', '000017', 3, 'contract', '../contract/contend_recv_list.jsp', 
    '완료(받은계약)', 'Y', 'Y', 3, '020302');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000066', '000017', 3, 'contract', '../contract/contract_expire_list.jsp', 
    '만료예정 계약서', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 4, '020303');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000067', '000017', 3, 'contract', '../contract/contend_offcont_list.jsp', 
    '서면계약조회', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 5, '020306');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000068', '000017', 3, 'contract', '../contract/contend_warr_list.jsp', 
    '보증보험증권관리', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 6, '020411');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000154', '000017', 3, 'contract', '../contract/contend_complete_list.jsp', 
    '완료된계약(양식내역)', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 7, '농협유통', '020307');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000018', '000002', 2, 'contract', 
    '현황관리', 4);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000069', '000018', 3, 'contract', '../contract/contract_view_list.jsp', 
    '계약진행현황', 'Y', 'Y', 
    1, '동희산업용', '020401');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000070', '000018', 3, 'contract', '../contract/ktmns.jsp', 
    '계약진행현황', 'Y', 'Y', 
    2, 'KT m&s', '020402');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000071', '000018', 3, 'contract', '../contract/sungwoo_cont_list.jsp', 
    '계약현황', 'Y', 'Y', 
    3, '현대성우홀딩스', '020403');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000072', '000018', 3, 'contract', '../contract/cont_report_cj.jsp', 
    '부문별 집계표', 'Y', 'Y', 
    4, 'CJ대한통운', '020404');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000073', '000018', 3, 'contract', '../contract/contract_view_list_new.jsp', 
    '계약진행현황', 'Y', 'Y', 
    5, '태평양', '020405');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000074', '000018', 3, 'contract', '../contract/cont_part_cj.jsp', 
    '부서별 계약현황', 'Y', 'Y', 
    6, 'CJ대한통운', '020407');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000075', '000018', 3, 'contract', '../contract/contract_charge_list.jsp', 
    '결재선 관리', 'Y', 'Y', 7, '020406');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000076', '000018', 3, 'contract', '../contract/cont_po_list.jsp', 
    '발주서 현황', 'Y', 'Y', 
    8, '성주디앤디', '020408');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000155', '000018', 3, 'contract', '../contract/resin_manage.jsp', 
    '계약현황관리', 'Y', 'Y', 
    9, '레진엔터', '020409');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000162', '000018', 3, 'contract', '../contract/cont_stamp_send_list.jsp', 
    '인지세관리', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 10, '020410');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC)
 Values
   ('000213', '000018', 3, 'contract', '../contract/woowahan_list.jsp', 
    '라이더 지원현황 관리', 'Y', 'Y', 11, '우아한청년들');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, ETC)
 Values
   ('000192', '000018', 3, 'contract', '../contract/nicednr_manage_list.jsp', 
    '계약현황관리', 'Y', 'Y', '나이스디앤알');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, ETC)
 Values
   ('000205', '000018', 3, 'contract', '../contract/playtime_manage_list.jsp', 
    '계약현황관리', 'Y', 'Y', '플레이타임그룹');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000077', '000019', 3, 'contract', '../contract/share_list.jsp', 
    '공람완료', 'Y', 'Y', 1, '020501');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000214', '000002', 2, 'contract', 
    '구매실적관리', 5);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000219', '000214', 3, 'contract', '../contract/purchase_select_list.jsp', 
    '구매실적 조회', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 11, '구매업무시스템');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000217', '000214', 3, 'contract', '../contract/item_code_list.jsp', 
    '품목코드 관리', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 11, '구매업무시스템');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000218', '000214', 3, 'contract', '../contract/purchase_info_list.jsp', 
    '구매정보 관리', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 11, '구매업무시스템');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000156', '000002', 2, 'contract', 
    '전자문서', 6);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000157', '000156', 3, 'contract', '../contract/subscription_list.jsp', 
    '수신함', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 1, '020601');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000186', '000000', 1, 'apply', 
    '입사지원관리', 3);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000187', '000186', 2, 'apply', 
    '입사지원', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000188', '000187', 3, 'apply', '../apply/apply_list.jsp', 
    '지원자목록', 'Y', 'Y', '20=>소속부서,40=>모든부서', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000189', '000187', 3, 'apply', '../apply/apply_cont_list.jsp', 
    '계약대상자목록', 'Y', 'Y', '20=>소속부서,40=>모든부서', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ)
 Values
   ('000190', '000187', 3, 'apply', '../apply/apply_noti_list.jsp', 
    '입사지원 링크관리', 'Y', 'Y', 3);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000003', '000000', 1, 'debt', 
    '채권잔액', 3);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000020', '000003', 2, 'debt', 
    '확인서관리', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000078', '000020', 3, 'debt', '../debt/debt_upload.jsp', 
    '확인서생성', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 1, '070101');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000079', '000020', 3, 'debt', '../debt/debt_group_list.jsp', 
    '확인서진행', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 2, '070102');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000080', '000020', 3, 'debt', '../debt/debt_tot_list.jsp', 
    '확인서현황', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 3, '070103');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, EUL_YN, BTN_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000081', '000020', 3, 'debt', '../debt/debt_recv_list.jsp', 
    '확인서조회', 'Y', '10=>단순조회,20=>기능사용', 4);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000004', '000000', 1, 'cust', 
    '거래업체관리', 4);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000021', '000004', 2, 'cust', 
    '협력업체관리', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000082', '000021', 3, 'cust', '../cust/my_cust_list.jsp', 
    '협력업체 조회', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 1, '030101');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000083', '000021', 3, 'cust', '../cust/nh_cust_list.jsp', 
    '협력업체 조회', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 2, 'NH개발', '030117');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000084', '000021', 3, 'cust', '../cust/add_cust_list.jsp', 
    '기업현황 조회', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 3, 'CJ대한통운', '030116');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000085', '000021', 3, 'cust', '../cust/person_my_cust_list.jsp', 
    '협력업체 조회', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 4, '파렛트풀용', '030109');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000086', '000021', 3, 'cust', '../cust/person_cust_list.jsp', 
    '담당자별 업체조회', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 5, '파렛트풀용', '030108');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000087', '000021', 3, 'cust', '../cust/my_cust_person_list.jsp', 
    '개인회원 조회', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 6, '030107');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000088', '000021', 3, 'cust', '../cust/tmp_cust_list_type.jsp', 
    '가등록업체 조회', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 7, '한국제지', '030114');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000089', '000021', 3, 'cust', '../cust/my_cust_list_type.jsp', 
    '협력업체 조회', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 8, '가등록시 사용, 3M,유', '030111');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, EUL_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000099', '000021', 3, 'cust', '../cust/cust_list.jsp', 
    '거래처등록관리', 'Y', 'Y', 
    18, '을사 전용', '030122');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000091', '000021', 3, 'cust', '../cust/nhqv_cust_list_type.jsp?client_type=1', 
    '등록업체 조회', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 10, 'NH투자증권전용', '030119');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000092', '000021', 3, 'cust', '../cust/nhqv_cust_list_type.jsp?client_type=2', 
    '협력업체 조회', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 11, 'NH투자증권전용', '030120');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000093', '000021', 3, 'cust', '../cust/src_comp_list.jsp', 
    '업체소싱그룹관리', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 12, '030106');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000096', '000021', 3, 'cust', '../cust/recruit_list.jsp', 
    '협력업체 모집', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 15, '030115');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000097', '000021', 3, 'cust', '../cust/client_license_list.jsp', 
    '보유면허별 업체현황', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 16, 'LG히타치', '030118');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000098', '000021', 3, 'cust', '../cust/nhqv_recruit_list.jsp', 
    '등록업체선정', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 17, 'nh투자증권전용', '030121');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000022', '000004', 2, 'cust', 
    '업체평가관리', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000100', '000022', 3, 'cust', '../cust/cont_exam_list.jsp', 
    '수시평가', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 1, '동희오토', '030301');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000101', '000022', 3, 'cust', '../cust/assessment_list.jsp', 
    '평가대상등록', 'Y', 'Y', 
    2, '한수테크니컬 서비스', '030302');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000102', '000022', 3, 'cust', '../cust/assessment_checking_slist.jsp', 
    '[구매] 신규/정기 평가', 'Y', 'Y', 
    3, '한수테크니컬 서비스', '030303');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000103', '000022', 3, 'cust', '../cust/assessment_checking_qlist.jsp', 
    '[QC] 업체 수시평가', 'Y', 'Y', 
    4, '한수테크니컬 서비스', '030304');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000104', '000022', 3, 'cust', '../cust/assessment_checking_elist.jsp', 
    '[ENC] 업체 수시평가', 'Y', 'Y', 
    5, '한수테크니컬 서비스', '030305');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000105', '000022', 3, 'cust', '../cust/assessment_checking_flist.jsp', 
    '[안전] 업체 수시평가', 'Y', 'Y', 
    6, '한수테크니컬 서비스', '030307');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000106', '000022', 3, 'cust', '../cust/asse_purchase_list.jsp', 
    '협력업체 평가현황', 'Y', 'Y', 
    7, '한수테크니컬 서비스', '030306');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000158', '000022', 3, 'cust', '../cust/asse_plan_list.jsp', 
    '평가계획등록', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 8, 'NH투자증권', '030308');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000159', '000022', 3, 'cust', '../cust/asse_progress_list.jsp', 
    '평가진행', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 9, 'NH투자증권', '030309');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000160', '000022', 3, 'cust', '../cust/asse_result_list.jsp', 
    '평가완료', 'Y', 'Y', 
    10, 'NH투자증권', '030310');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000161', '000022', 3, 'cust', '../cust/nhqv_asse_list.jsp', 
    '수시평가 기초자료', 'Y', 'Y', 
    11, 'NH투자증권', '030311');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000184', '000022', 3, 'cust', '../cust/samsong_evaluate_list.jsp', 
    '협력사평가정보관리', 'Y', 'Y', '삼송전용', 
    '10=>단순조회,20=>기능사용', 12);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000172', '000000', 1, 'proof', 
    '실적증명', 4);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000173', '000172', 2, 'proof', 
    '증명서작성', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, EUL_YN, USE_YN, DISPLAY_SEQ)
 Values
   ('000176', '000173', 3, 'proof', '../proof/proof_select_template.jsp', 
    '실적증명서작성', 'Y', 'Y', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, EUL_YN, USE_YN, DISPLAY_SEQ)
 Values
   ('000177', '000173', 3, 'proof', '../proof/proof_writing_list.jsp', 
    '임시저장', 'Y', 'Y', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000174', '000172', 2, 'proof', 
    '발급진행', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, EUL_YN, USE_YN, DISPLAY_SEQ)
 Values
   ('000178', '000174', 3, 'proof', '../proof/proof_send_list.jsp', 
    '발급요청(발신)', 'Y', 'Y', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000179', '000174', 3, 'proof', '../proof/proof_recv_list.jsp', 
    '발급요청(수신)', 'Y', 'Y', '10=>단순조회,20=>기능사용', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000175', '000172', 2, 'proof', 
    '발급완료', 3);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, EUL_YN, USE_YN, DISPLAY_SEQ)
 Values
   ('000180', '000175', 3, 'proof', '../proof/proofend_send_list.jsp', 
    '발급완료(발신)', 'Y', 'Y', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000181', '000175', 3, 'proof', '../proof/proofend_recv_list.jsp', 
    '발급완료(수신)', 'Y', 'Y', '10=>단순조회,20=>기능사용', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000005', '000000', 1, 'report', 
    '통계관리', 5);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000023', '000005', 2, 'report', 
    '전자입찰', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000140', '000023', 3, 'report', '../report/comp_bid_list.jsp', 
    '업체별 입찰참여현황', 'Y', 1, '040101');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000163', '000023', 3, 'report', '../report/charge_bid_list.jsp', 
    '입찰 절감율현황', 'Y', 2, '040102');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000168', '000023', 3, 'report', '../report/bid_project_list.jsp', 
    '프로젝트별', 'Y', 3, '위메프', '040401');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000169', '000023', 3, 'report', '../report/bid_item_list.jsp', 
    '품목별', 'Y', 4, '위메프', '040402');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000024', '000005', 2, 'report', 
    '전자계약', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000107', '000024', 3, 'report', '../report/bid_unit_list.jsp', 
    '품목별 단가계약 현황', 'Y', 'Y', 1, '040201');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000165', '000024', 3, 'report', '../report/comp_cont_list.jsp', 
    '업체별 계약현황', 'Y', 2, '빙그레', '040202');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000166', '000024', 3, 'report', '../report/cont_part_list.jsp', 
    '부서별 계약현황', 'Y', 'Y', 3, '040203');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000167', '000024', 3, 'report', '../report/contract_src_report.jsp', 
    '소싱그룹별계약현황', 'Y', 4, '040301');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, DISPLAY_SEQ, ETC)
 Values
   ('000182', '000024', 3, 'report', '../report/project_cont_info.jsp', 
    '프로젝트별계약현황', 'Y', 'Y', 5, '하이텍전용');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000006', '000000', 1, 'info', 
    '회원정보수정', 6);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000025', '000006', 2, 'info', 
    '기본정보', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, EUL_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000108', '000025', 3, 'info', '../info/company_modify.jsp', 
    '회사정보변경', 'Y', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, EUL_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000109', '000025', 3, 'info', '../info/cert_info.jsp', 
    '인증서 등록/갱신', 'Y', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000110', '000025', 3, 'info', '../info/place_list.jsp', 
    '부서/지점관리', 'Y', 'Y', '10=>단순조회,20=>기능사용', 3);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000111', '000025', 3, 'info', '../info/dept_info.jsp', 
    '부서관리', 'Y', 'Y', '10=>단순조회,20=>기능사용', 4);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000112', '000025', 3, 'info', '../info/user_code_manager.jsp', 
    '코드관리', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 5, 'LG히타치,대보정보통', '050106');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000113', '000025', 3, 'info', '../info/exam_list.jsp', 
    '평가지관리', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 6, '050103');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000114', '000025', 3, 'info', '../info/item_form_manager.jsp', 
    '입찰내역Detph관리', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 7, '050104');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000115', '000025', 3, 'info', '../info/cont_template_list.jsp', 
    '계약서식관리', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 8, '050105');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000116', '000025', 3, 'info', '../info/construction_site.jsp', 
    '현장관리', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 9, '050107');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000117', '000025', 3, 'info', '../info/project_list.jsp', 
    '프로젝트관리', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 10, '050108');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000136', '000025', 3, 'info', '../info/src_cate_list.jsp', 
    '업체소싱카테고리관리', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 11, '050101');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, DISPLAY_SEQ, ADM_CD)
 Values
   ('000137', '000025', 3, 'info', '../info/item_manager.jsp', 
    '품목관리', 'Y', 12, '050102');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000026', '000006', 2, 'info', 
    '담당자관리', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, EUL_YN, USE_YN, DISPLAY_SEQ)
 Values
   ('000118', '000026', 3, 'info', '../info/my_info_modify_comp.jsp', 
    '내정보수정', 'Y', 'Y', 'Y', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000139', '000026', 3, 'info', '../info/auth_list.jsp', 
    '권한그룹관리', 'Y', 'Y', '10=>단순조회,20=>기능사용', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, EUL_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000120', '000026', 3, 'info', '../info/person_list.jsp', 
    '담당자관리', 'Y', 'Y', 'Y', '20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 3);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000121', '000026', 3, 'info', '../info/person_menu_auth.jsp', 
    '담당자별권한관리', 'Y', 'Y', '10=>단순조회,20=>기능사용', 4);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000122', '000026', 3, 'info', '../info/person_part_auth.jsp', 
    '담당자별조회부서관리', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 5, 'CJ대한통운전용');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000134', '000006', 2, 'info', 
    '결제정보', 4);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ETC, ADM_CD)
 Values
   ('000090', '000021', 3, 'cust', '../cust/my_cust_list_type.jsp?s_client_type=1', 
    '대리점 조회', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 9, '3M,유리공업', '030110');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, EUL_YN, USE_YN, DISPLAY_SEQ)
 Values
   ('000135', '000134', 3, 'info', '../info/pay_list.jsp', 
    '결제내역', 'Y', 'Y', 'Y', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000007', '000000', 1, 'center', 
    '고객센터', 7);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000027', '000007', 2, 'center', 
    '알림방', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ)
 Values
   ('000123', '000027', 3, 'center', '../center/my_pds_list.jsp', 
    '알림방(작업업체用)', 'Y', 'Y', '10=>단순조회,20=>기능사용', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, EUL_YN, USE_YN, DISPLAY_SEQ)
 Values
   ('000124', '000027', 3, 'center', '../center/cust_pds_list.jsp', 
    '알림방(수신업체用)', 'Y', 'Y', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000028', '000007', 2, 'center', 
    '고객센터', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, USE_YN, DISPLAY_SEQ)
 Values
   ('000125', '000028', 3, 'center', '../center/noti_list.jsp', 
    '공지사항', 'Y', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, USE_YN, DISPLAY_SEQ)
 Values
   ('000126', '000028', 3, 'center', '../center/faq_list.jsp', 
    'FAQ', 'Y', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, USE_YN, DISPLAY_SEQ)
 Values
   ('000171', '000028', 3, 'center', '../center/si_qna.jsp', 
    '문의 및 상담', 'Y', 3);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, DISPLAY_SEQ)
 Values
   ('000193', '000028', 3, 'center', '../center/event_req.jsp?event_id=10', 
    '이벤트신청', 4);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000008', '000000', 1, 'member', 
    '회원메뉴', 8);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000029', '000008', 2, 'member', 
    '회원정보', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, DISPLAY_SEQ)
 Values
   ('000127', '000029', 3, 'member', '../member/join_agree.jsp', 
    '회원가입', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, DISPLAY_SEQ)
 Values
   ('000128', '000029', 3, 'member', '../member/find_id.jsp', 
    '아이디 찾기', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, DISPLAY_SEQ)
 Values
   ('000129', '000029', 3, 'member', '../member/find_pw.jsp', 
    '비밀번호 찾기', 3);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000009', '000000', 1, 'guide', 
    '서비스안내', 9);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_NM, DISPLAY_SEQ)
 Values
   ('000030', '000009', 2, 'guide', 
    '전자구매시스템', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, USE_YN, DISPLAY_SEQ)
 Values
   ('000130', '000030', 3, 'guide', '../guide/service_intro.jsp', 
    '서비스소개', 'Y', 1);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, DISPLAY_SEQ)
 Values
   ('000131', '000030', 3, 'guide', '../guide/service_client.jsp', 
    '고객사', 2);
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000229', '000015', 3, 'contract', '../contract/batch_contract_insert_nb.jsp', 
    '일괄계약작성_nb', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 6, '엔비모빌리티');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000230', '000015', 3, 'contract', '../contract/batch_contract_insert_nb2.jsp', 
    '일괄계약작성_nb2', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 7, '엔비모빌리티');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, BTN_AUTH_CDS, DISPLAY_SEQ, ADM_CD)
 Values
   ('000231', '000021', 3, 'cust', '../cust/my_cust_list_up.jsp?client_type=1', 
    '뉴_등록업체 조회', 'Y', 'Y', 
    '10=>단순조회,20=>기능사용', 1, '030312');
Insert into TCB_MENU
   (MENU_CD, P_MENU_CD, DEPTH, DIR, MENU_PATH, MENU_NM, GAP_YN, USE_YN, SELECT_AUTH_CDS, BTN_AUTH_CDS, DISPLAY_SEQ, ETC)
 Values
   ('000232', '000015', 3, 'contract', '../contract/batch_contract_insert_trn.jsp', 
    '일괄계약작성_trn', 'Y', 'Y', '10=>본인담당,20=>소속부서,40=>모든부서', 
    '10=>단순조회,20=>기능사용', 6, '티알엔');
COMMIT;
