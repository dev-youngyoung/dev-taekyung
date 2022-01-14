SET DEFINE OFF;
Insert into TCB_AGREE_TEMPLATE
   (AGREE_NAME, AGREE_FIELD_SEQ, AGREE_PERSON_NAME, AGREE_SEQ, AGREE_CD, AGREE_PERSON_ID, TEMPLATE_CD)
 Values
   ('검토', 3, '이태백', 1, '1', 
    'test02', '2021232');
Insert into TCB_AGREE_TEMPLATE
   (AGREE_NAME, AGREE_SEQ, AGREE_CD, TEMPLATE_CD)
 Values
   ('업체서명', 2, '0', '2021232');
Insert into TCB_AGREE_TEMPLATE
   (AGREE_NAME, AGREE_SEQ, AGREE_CD, TEMPLATE_CD)
 Values
   ('당사 서명', 3, '2', '2021232');
Insert into TCB_AGREE_TEMPLATE
   (AGREE_NAME, AGREE_SEQ, AGREE_CD, TEMPLATE_CD)
 Values
   ('관리자 승인', 1, '1', '2020285');
Insert into TCB_AGREE_TEMPLATE
   (AGREE_NAME, AGREE_SEQ, AGREE_CD, TEMPLATE_CD)
 Values
   ('업체서명', 2, '0', '2020285');
Insert into TCB_AGREE_TEMPLATE
   (AGREE_NAME, AGREE_SEQ, AGREE_CD, TEMPLATE_CD)
 Values
   ('당사 서명', 3, '2', '2020285');
COMMIT;
