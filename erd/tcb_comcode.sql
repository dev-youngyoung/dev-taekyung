SET DEFINE OFF;
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M001', '00', '회원구분(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M001', '01', '법인(본사)', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M001', '02', '법인(지사)', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M001', '03', '개인사업자', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M001', '04', '개인', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M002', '00', '회원종류(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M002', '01', '갑사', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M002', '02', '을사', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M002', '03', '갑/을사', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M003', '00', '입찰권한(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M003', '10', '입찰권한', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M003', '20', '개찰권한', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M003', '30', '입찰/개찰권한', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M003', '99', '권한없음', 
    9, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M004', '00', '계약권한(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M004', '10', '계약작성', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M004', '20', '계약조회', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M004', '99', '권한없음', 
    9, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M005', '00', '담당자구분(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M005', '10', '본사', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M005', '20', '지점', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M006', '00', '비건설_요금제', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M006', '10', '년선납', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M006', '20', '월정액', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M006', '30', '건별제', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M006', '40', '포인트제', 
    4, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M006', '50', '후불제', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M007', '00', '보증서종류(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M007', '10', '계약이행', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M007', '20', '하자이행', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M007', '30', '선급금', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M007', '40', '근재보험', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M007', '50', '이행지급', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M007', '60', '기타', 
    8, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M007', '70', '배상책임보험', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M008', '00', '계약상태(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M008', '10', '작성중', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M008', '11', '검토중', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M008', '12', '내부반려', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M008', '20', '서명요청', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M008', '21', '승인대기', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M008', '30', '서명대기', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M008', '40', '수정요청', 
    7, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M008', '41', '반려', 
    8, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M008', '50', '계약완료', 
    9, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M008', '90', '종료계약', 
    10, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M008', '91', '계약해지', 
    11, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M010', '00', '계약서변경구분(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M010', '01', '연장', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M010', '02', '증액', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M010', '03', '감액', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M010', '04', '연장증액', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M010', '05', '연장감액', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M010', '06', '단축증액', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M010', '07', '단축감액', 
    7, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M010', '08', '내역변경', 
    8, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M010', '90', '계약해지', 
    9, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M010', '99', '기타', 
    10, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M013', '00', '사용자유형(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M013', '10', '전체관리자', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M013', '20', '부서관리자', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M013', '30', '일반사용자', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M014', '00', '채권잔액상태', 
    0, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M014', '10', '작성중', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M014', '20', '서명요청', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M014', '30', '확인요청(내부)', 
    3, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M014', '40', '수정요청', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M014', '41', '반려', 
    5, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M014', '50', '완료', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC2, SORT)
 Values
   ('M021', '00', '입찰유형(비건설)', 'bid_kind_cd', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('M021', '10', '물품', 'bid_kind_cd', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('M021', '20', '용역', 'bid_kind_cd', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('M021', '30', '공사', 'bid_kind_cd', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('M021', '90', '견적관리', 'bid_kind_cd', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M022', '00', '입찰상태(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M022', '01', '입찰계획중', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M022', '02', '설명회대상', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M022', '03', '현설공고중', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M022', '04', '입찰대상', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M022', '05', '공고중', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M022', '06', '개찰완료', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M022', '07', '낙찰', 
    7, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('M022', '08', '대상업체검토', '동희오토만', 
    8, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M022', '91', '유찰', 
    9, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M022', '92', '재입찰', 
    10, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M022', '93', '현설취소', 
    11, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M022', '94', '입찰취소', 
    12, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M023', '00', '입찰방법(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M023', '01', '지명경쟁', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M023', '02', '수의계약', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M023', '03', '공개경쟁', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M023', '20', '일반경쟁', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M023', '21', '제한경쟁', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M024', '00', '낙찰방법(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M024', '01', '최저가', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M024', '02', '기술·가격동시입찰', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M024', '03', '협상에 의한 계약', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('M024', '04', '최적가 입찰', '광동제약', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M024', '05', '최고가', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('M024', '07', '재무·가격 평가(CJ)', 'CJT', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M024', '08', '적격심사', 
    7, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M024', '09', '제한적최저가', 
    8, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('M024', '10', '제안서평가방식', 'nh투자', 
    9, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M024', '11', '역경매', 
    10, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M024', '12', '순경매', 
    11, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M025', '00', '견적구분', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M025', '10', '총액입찰', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M025', '20', '내역입찰', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M026', '00', '견적내역양식(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M026', '01', 'DEPTH2[분류->명칭]', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M026', '02', 'DEPTH3[대분류->중분류->명칭]', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M026', '03', 'DEPTH4[대분류->중분류->소분류->명칭]', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('M026', '04', 'DEPTH3[톤->지역(도)->지역(세부)]', 'CJT', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC1, SORT)
 Values
   ('M027', '00', '기술평가상태(비건설)', '평가중', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M027', '10', '평가중', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M027', '20', '평가완료', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M028', '00', '기술평가업체상태(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M028', '10', '적격', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M028', '20', '부적격', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M029', '00', '협상상태(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M029', '1 ', '타결', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M029', '2 ', '결렬', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M030', '00', '투찰업체상태(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M030', '10', '입찰참가대상', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M030', '30', '견적서제출', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M031', '00', '입찰담당자구분(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M031', '01', '현설담당', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M031', '02', '입찰담당', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M031', '03', '기술평가담당', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M032', '00', '입찰파일구분(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M032', '10', '현설첨부파일', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M032', '20', '현설결과서류', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M032', '30', '입찰관련 첨부서류', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M032', '40', '기술평가 첨부서류', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M033', '00', '구매요청상태(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M033', '10', '작성중', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M033', '20', '요청중', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M033', '30', '반려', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M033', '40', '접수', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M034', '00', '견적관리상태(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M034', '01', '작성중', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M034', '05', '견적요청', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M034', '07', '업체선정', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M034', '91', '요청종료', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M034', '94', '요청취소', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M035', '00', '물품유형(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M035', '10', '원자재', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M035', '20', '부자재', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M035', '30', '설비', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M036', '00', '물량생산기간(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M036', 'Y2', '2년', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M036', 'Y3', '3년', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M036', 'Y4', '4년', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M036', 'Y5', '5년', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M036', 'Y6', '6년', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M037', '00', '입찰통화(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '01', '대한민국 원 KRW', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '02', '미국 달러 USD', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '03', '유럽연합 유로 EUR', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '04', '일본 엔 JPY', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '05', '중국 위안 CNY', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '06', '홍콩 달러 HKD', 
    6, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '07', '대만 달러 TWD', 
    7, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '08', '영국 파운드 GBP', 
    8, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '09', '오만 리알 OMR', 
    9, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '10', '캐나다 달러 CAD', 
    10, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '11', '스위스 프랑 CHF', 
    11, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '12', '스웨덴 크로나 SEK', 
    12, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '13', '호주 달러 AUD', 
    13, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '14', '뉴질랜드 달러 NZD', 
    14, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '15', '체코 코루나 CZK', 
    15, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '16', '칠레 페소 CLP', 
    16, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '17', '터키 리라 TRY', 
    17, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '18', '몽골 투그릭 MNT', 
    18, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '19', '이스라엘 세켈 ILS', 
    19, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '20', '덴마크 크로네 DKK', 
    20, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '21', '노르웨이 크로네 NOK', 
    21, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '22', '사우디아라비아 리얄 SAR', 
    22, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '23', '쿠웨이트 디나르 KWD', 
    23, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '24', '바레인 디나르 BHD', 
    24, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '25', '아랍에미리트 디르함 AED', 
    25, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '26', '요르단 디나르 JOD', 
    26, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '27', '이집트 파운드 EGP', 
    27, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '28', '태국 바트 THB', 
    28, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '29', '싱가포르 달러 SGD', 
    29, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '30', '말레이시아 링깃 MYR', 
    30, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '31', '인도네시아 루피아 IDR', 
    31, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '32', '카타르 리얄 QAR', 
    32, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '33', '카자흐스탄 텡게 KZT', 
    33, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '34', '브루나이 달러 BND', 
    34, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '35', '인도 루피 INR', 
    35, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '36', '파키스탄 루피 PKR', 
    36, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '37', '방글라데시 타카 BDT', 
    37, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '38', '필리핀 페소 PHP', 
    38, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '39', '멕시코 페소 MXN', 
    39, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '40', '브라질 레알 BRL', 
    40, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '41', '베트남 동 VND', 
    41, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '42', '남아프리카 공화국 랜드 ZAR', 
    42, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '43', '러시아 루블 RUB', 
    43, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '44', '헝가리 포린트 HUF', 
    44, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M037', '45', '폴란드 즈워티 PLN', 
    45, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M038', '00', '예정가격구분(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M038', '10', '단일예가', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M038', '20', '복수예가', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M039', '00', '입찰보증금구분(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M039', '10', '각서', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M039', '20', '보증증권', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M040', '00', '복수예가상태(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M040', '10', '생성중', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M040', '20', '생성완료', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M041', '00', '계약서전송방식(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M041', '10', '이메일서명', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M042', '00', '계약서서명방식(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M042', '10', '공인인증서', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M042', '20', '본인확인서비스', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('C104', '00', '계약서_보증기관', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC1, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('C104', '01', '전문건설공제조합', 'http://ebiz.kscfc.co.kr', '9', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC1, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('C104', '02', '서울보증보험', 'http://www.sgic.co.kr', '9', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC1, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('C104', '03', '건설공제조합', 'http://www.cgbest.co.kr', '9', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC1, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('C104', '04', '전기공사공제조합', 'http://ecfc.co.kr', '9', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC1, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('C104', '05', '기계설비건설공제조합', 'http://seolbi.com', '9', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC1, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('C104', '06', '엔지니어링공제조합', 'http://efc.co.kr', '9', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC1, SORT, USE_YN, CONDT_YN)
 Values
   ('C104', '07', '정보통신공제조합', 'http://www.icfc.or.kr/', 
    7, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC1, SORT, USE_YN, CONDT_YN)
 Values
   ('C104', '08', '자본재공제조합', 'http://www.mafc.or.kr/', 
    8, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('C104', '99', '기타', 
    8, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M220', '00', '우아한배달수단', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M220', '10', '(전기)자전거', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M220', '20', '킥보드', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M220', '30', '도보', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M220', '40', '오토바이', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M220', '50', '자동차', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M221', '00', '우아한지원상태', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M221', '20', 'STEP2 진행중', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M221', '30', 'STEP3 진행중', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M221', '50', '지원완료', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M222', '00', '우아한첨부종류', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M222', '10', '프로필사진', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M222', '20', '운전면허증', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M222', '30', '보험증권', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M222', '40', '신고필증', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M034', '04', '수의시담', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M043', '00', '입찰등록방법(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M043', '10', '온라인접수', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M043', '20', '방문접수', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M044', '00', '입찰등록상태(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M044', '10', '등록신청', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M044', '20', '불합격', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M044', '30', '합격', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M200', '00', '신세계백화점 점포코드', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '01', '공사팀', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '02', '본점', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '03', '영등포점', 
    3, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '04', '강남점', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '05', '인천점', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '06', '경기점', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '07', '광주점', 
    7, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '08', '마산점', 
    8, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '09', '센터점', 
    9, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '10', '의정부점', 
    10, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '11', '김해점', 
    11, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '21', '스타수퍼', 
    21, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '22', '마린시티', 
    22, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '23', '청담 SSG', 
    23, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '24', '청담 BTS', 
    24, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M200', '25', '인재개발원', 
    25, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M210', '00', 'NH개발-업체종류', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '01', '실내건축', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '02', '전기', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '03', '통신', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '04', '토목건축', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '05', '철콘', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '06', '철골', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '07', '토공사', 
    7, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '08', '기계설비', 
    8, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '09', '설계용역', 
    9, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '10', '기타(내역)', 
    99, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '11', '미장방수조적', 
    10, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '12', '도장', 
    11, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '13', '석공사', 
    12, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '14', '금속창호', 
    13, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '15', '소방', 
    14, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '16', '태양광(설계)', 
    15, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M210', '17', '태양광(시공)', 
    16, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M300', '00', 'CJ대한통운-전문취급물자', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '01', '택배', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '02', '수출입컨테이너', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '03', '제주-내륙', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '04', '국내항공화물', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '05', '해외항공화물', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '06', '주류', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '07', '의약품', 
    7, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '08', '고가품', 
    8, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '09', '전자', 
    9, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '10', '화학', 
    10, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '11', '냉동냉장식품', 
    11, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '12', '의류', 
    12, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '13', '고체연료', 
    13, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '14', '액체연료', 
    14, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '15', '제품벌크', 
    15, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '16', '제품Pallet', 
    16, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '17', '이사', 
    17, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '18', '건설자재', 
    18, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '19', '곡물', 
    19, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '20', '중량물/기계', 
    20, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M300', '21', '자동차/부품', 
    21, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M301', '00', 'CJ대한통운-보험종류', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M301', '01', '자동차보험', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M301', '02', '적재물보험', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M301', '03', '상해보험', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M301', '04', '보증보험', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M301', '05', '주선적재물배상택임보험', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M302', '00', 'CJ대한통운-차종', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M302', '01', 'T/R', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M302', '02', 'T/R(저온)', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M302', '03', '덤프T/R', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M302', '04', '샤시', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M302', '05', '윙바디', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M302', '06', '윙바디(저온)', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M302', '07', '카고', 
    7, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M302', '08', '덤프', 
    8, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M302', '09', '탱크로리(2만L)', 
    9, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M302', '10', '탱크로리(2만8천L)', 
    10, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M302', '11', '탱크로리(3만2천L)', 
    11, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M303', '00', 'CJ대한통운-톤급', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M303', '01', '1톤', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M303', '02', '2.5톤', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M303', '03', '5톤', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M303', '04', '5톤장축', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M303', '05', '7~9톤', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M303', '06', '10~14톤', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M303', '07', '15~18톤', 
    7, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M303', '08', '19~22톤', 
    8, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M303', '09', '25톤이상', 
    9, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M303', '10', '20ft', 
    10, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M303', '11', '40ft', 
    11, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M045', '00', '열람권한', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M045', '10', '모든부서', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M045', '20', '소속부서', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M045', '40', '본인담당', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M046', '00', '업무권한', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M046', '10', '단순조회', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M046', '20', '기능사용', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M047', '00', '입찰이행보증유형', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M047', '10', '보증보험증권 제출', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M047', '20', '이행보증각서 제출', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M047', '90', '해당없음', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M048', '00', '후불정산주기', 0, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M048', '01', '말일(전월01일~전월말일)', 1, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M048', '21', '21일(전월21일~당월20일)', 2, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M048', '25', '25일(전월25일~당월24일)', 3, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M048', '26', '26일(전월26일~당월25일)', 4, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M008', '99', '계약폐기', 
    11, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('M024', '14', '추정가격 산정용', '킨텍스', 
    13, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M049', '00', '구매정보 등록상태', 0, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M049', '10', '승인대기', 1, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M049', '20', '승인완료', 2, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M050', '00', '구매방법', 0, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M050', '01', '직접구매', 1, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M050', '02', '비교견적', 2, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M050', '03', '지명입찰', 3, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M050', '04', '공개입찰', 4, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M050', '05', '수의계약', 5, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M050', '06', '연장', 6, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M050', '07', '단가계약', 7, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M051', '00', '품목상태', 0, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M051', '01', '유효', 1, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('M051', '02', '무효', 2, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M009', '00', '계약상태(비건설)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M009', '91', '계약해지', 
    11, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M009', '90', '종료계약', 
    10, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M009', '50', '계약완료', 
    9, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M009', '41', '반려', 
    8, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M009', '40', '수정요청', 
    7, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M009', '30', '서명대기', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M009', '21', '승인대기', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M009', '20', '서명요청', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M009', '12', '내부반려', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M009', '11', '검토중', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M009', '10', '작성중', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M009', '99', '계약폐기', 
    11, 'N', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M031', '04', '시담담당', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('P001', '00', '실적증명상태', 0, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('P001', '10', '작성중', 1, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('P001', '20', '발급요청중', 2, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('P001', '30', '검토중', 3, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('P001', '40', '반려', 4, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('P001', '50', '서명완료(甲)', 5, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('P001', '60', '발급완료', 6, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('P002', '00', '실적증명제출협회', 0, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('P002', '01', '대한전문건설협회', 1, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('P002', '02', '대한설비건설협회', 2, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('P002', '03', '한국정보통신공사협회', 3, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('P002', '04', '한국전기공사협회', 4, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN)
 Values
   ('P002', '05', '한국소방공사협회', 5, 'Y');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M024', '13', 'QSTP평가', 
    12, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M007', '80', '공사대급지급보증', 
    7, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M052', '00', '양식종류 구분(일반)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M052', '10', '모바일_근로(기존UI)', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, ETC2, SORT, USE_YN, CONDT_YN)
 Values
   ('M021', '99', '기타', 'bid_kind_cd', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('C105', '00', '계약(갑,을)서명순서', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('C105', '01', '①을 > ②갑', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('C105', '02', '①갑 > ②을', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT)
 Values
   ('M053', '00', '수의시담 진행상태(일반)', 0);
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M053', '10', '작성중', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M053', '20', '요청', 
    2, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M053', '30', '제출', 
    3, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M053', '40', '종료', 
    4, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M053', '41', '취소', 
    5, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M053', '42', '시담포기', 
    6, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M053', '50', '완료', 
    7, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M052', '11', '모바일_근로(신규UI)', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M052', '12', '모바일_업무(신규UI)', 
    1, 'Y', 'N');
Insert into TCB_COMCODE
   (CCODE, CODE, CNAME, SORT, USE_YN, CONDT_YN)
 Values
   ('M052', '13', '모바일_업무(기존UI)', 
    1, 'Y', 'N');
COMMIT;
