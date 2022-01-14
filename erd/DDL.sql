ALTER TABLE TCB_AGREE_TEMPLATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_AGREE_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_AGREE_TEMPLATE
(
  AGREE_NAME         VARCHAR2(20 BYTE),
  AGREE_FIELD_SEQ    NUMBER(38),
  AGREE_PERSON_NAME  VARCHAR2(20 BYTE),
  AGREE_SEQ          NUMBER(38)                 NOT NULL,
  AGREE_CD           CHAR(1 BYTE),
  AGREE_PERSON_ID    VARCHAR2(20 BYTE),
  TEMPLATE_CD        CHAR(7 BYTE)               NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN TCB_AGREE_TEMPLATE.AGREE_FIELD_SEQ IS '특정 부서에서만 선택 하고 싶을때';

COMMENT ON COLUMN TCB_AGREE_TEMPLATE.AGREE_CD IS '0: 수급사업자, 1: 원사업자(거래업체 이전 단계), 2: 원사업자(거래업체 이후 단계)';


ALTER TABLE TCB_AGREE_USER
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_AGREE_USER CASCADE CONSTRAINTS;

CREATE TABLE TCB_AGREE_USER
(
  AGREE_NAME         VARCHAR2(100 BYTE),
  AGREE_FIELD_SEQ    NUMBER(38),
  AGREE_PERSON_NAME  VARCHAR2(20 BYTE),
  AGREE_SEQ          NUMBER(38)                 NOT NULL,
  AGREE_CD           CHAR(1 BYTE),
  AGREE_PERSON_ID    VARCHAR2(20 BYTE),
  TEMPLATE_CD        CHAR(7 BYTE)               NOT NULL,
  USER_ID            VARCHAR2(20 BYTE)          NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_APPLY_NOTI
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_APPLY_NOTI CASCADE CONSTRAINTS;

CREATE TABLE TCB_APPLY_NOTI
(
  MEMBER_NO      CHAR(11 BYTE),
  NOTI_NO        CHAR(5 BYTE),
  NOTI_NAME      VARCHAR2(60 BYTE),
  APPLY_CDS      VARCHAR2(200 BYTE),
  AREA_CDS       VARCHAR2(200 BYTE),
  NOTI_SDATE     VARCHAR2(14 BYTE),
  NOTI_EDATE     VARCHAR2(14 BYTE),
  TEMPLATE_CD    CHAR(7 BYTE),
  APPLY_TEMP_CD  CHAR(7 BYTE),
  NOTI_ETC       VARCHAR2(255 BYTE),
  REG_DATE       VARCHAR2(14 BYTE),
  REG_ID         VARCHAR2(20 BYTE),
  MOD_DATE       VARCHAR2(14 BYTE),
  MOD_ID         VARCHAR2(20 BYTE),
  STATUS         CHAR(2 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_APPLY_PERSON
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_APPLY_PERSON CASCADE CONSTRAINTS;

CREATE TABLE TCB_APPLY_PERSON
(
  APPLY_NO       CHAR(11 BYTE),
  MEMBER_NO      CHAR(11 BYTE),
  NOTI_NO        CHAR(5 BYTE),
  AREA_CD        NUMBER(10),
  APPLY_CD       CHAR(2 BYTE),
  NAME_KR        VARCHAR2(60 BYTE),
  NAME_CH        VARCHAR2(60 BYTE),
  NAME_EN        VARCHAR2(60 BYTE),
  BIRTH_DATE     VARCHAR2(14 BYTE),
  EMAIL          VARCHAR2(255 BYTE),
  HP1            VARCHAR2(3 BYTE),
  HP2            VARCHAR2(4 BYTE),
  HP3            VARCHAR2(4 BYTE),
  POST_CODE      VARCHAR2(6 BYTE),
  ADDRESS        VARCHAR2(255 BYTE),
  CAREER_YN      CHAR(1 BYTE),
  VET_YN         CHAR(1 BYTE),
  DIS_YN         CHAR(1 BYTE),
  INFO_USE_YN    VARCHAR2(15 BYTE),
  APPLY_HTML     CLOB,
  APPLY_DATE     VARCHAR2(14 BYTE),
  FILE_HASH      CLOB,
  CI_DATA        VARCHAR2(255 BYTE),
  SIGN_DATE      VARCHAR2(14 BYTE),
  SIGN_DATA      CLOB,
  IMG_FILE_NAME  VARCHAR2(200 BYTE),
  IMG_FILE_PATH  VARCHAR2(200 BYTE),
  CONT_NO        VARCHAR2(14 BYTE),
  REG_DATE       VARCHAR2(14 BYTE),
  REG_ID         VARCHAR2(20 BYTE),
  MOD_DATE       VARCHAR2(14 BYTE),
  MOD_ID         VARCHAR2(20 BYTE),
  STATUS         CHAR(2 BYTE)
)
LOB (APPLY_HTML) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (FILE_HASH) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (SIGN_DATA) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_APPLY_TEMPLATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_APPLY_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_APPLY_TEMPLATE
(
  APPLY_TEMP_CD  CHAR(7 BYTE),
  TEMPLATE_SEQ   NUMBER(2),
  MEMBER_NO      CHAR(11 BYTE),
  TEMPLATE_NAME  VARCHAR2(100 BYTE),
  TEMPLATE_HTML  CLOB,
  USE_YN         CHAR(1 BYTE),
  STATUS         CHAR(2 BYTE),
  REG_DATE       VARCHAR2(14 BYTE),
  MOD_DATE       VARCHAR2(14 BYTE)
)
LOB (TEMPLATE_HTML) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          16M
            NEXT             1600K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ASSEMASTER
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ASSEMASTER CASCADE CONSTRAINTS;

CREATE TABLE TCB_ASSEMASTER
(
  ASSE_NO         CHAR(11 BYTE)                 NOT NULL,
  MEMBER_NO       CHAR(11 BYTE)                 NOT NULL,
  REG_ID          VARCHAR2(20 BYTE),
  REG_DATE        VARCHAR2(14 BYTE),
  PROJECT_NAME    VARCHAR2(255 BYTE),
  MEMBER_NAME     VARCHAR2(255 BYTE),
  ASSE_YEAR       VARCHAR2(4 BYTE),
  KIND_CD         CHAR(1 BYTE),
  S_YN            CHAR(1 BYTE)                  DEFAULT 'N',
  QC_YN           CHAR(1 BYTE)                  DEFAULT 'N',
  ENC_YN          CHAR(1 BYTE)                  DEFAULT 'N',
  STATUS          CHAR(2 BYTE),
  F_YN            CHAR(1 BYTE),
  MAIN_MEMBER_NO  CHAR(11 BYTE),
  BID_NO          VARCHAR2(9 BYTE),
  BID_DEG         NUMBER
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ASSE_TEMPLATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ASSE_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_ASSE_TEMPLATE
(
  TEMPLATE_CD       CHAR(7 BYTE)                NOT NULL,
  MEMBER_NO         VARCHAR2(255 BYTE),
  TEMPLATE_NAME     VARCHAR2(50 BYTE),
  TEMPLATE_HTML     CLOB,
  TEMPLATE_VER      VARCHAR2(10 BYTE),
  TEMPLATE_DIV_CD   CHAR(1 BYTE),
  TEMPLATE_KIND_CD  CHAR(1 BYTE),
  TEMPLATE_USE_YN   VARCHAR2(1 BYTE)            DEFAULT 'Y',
  REG_DATE          VARCHAR2(14 BYTE),
  TEMPLATE_SUBHTML  CLOB
)
LOB (TEMPLATE_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (TEMPLATE_SUBHTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ATT_CFILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ATT_CFILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_ATT_CFILE
(
  TEMPLATE_CD  CHAR(7 BYTE)                     NOT NULL,
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  FILE_SEQ     NUMBER(38)                       NOT NULL,
  DOC_NAME     VARCHAR2(255 BYTE),
  FILE_PATH    VARCHAR2(255 BYTE),
  FILE_NAME    VARCHAR2(200 BYTE),
  FILE_EXT     VARCHAR2(20 BYTE),
  FILE_SIZE    NUMBER(38),
  AUTO_TYPE    VARCHAR2(20 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BANK_CERT_LOG
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BANK_CERT_LOG CASCADE CONSTRAINTS;

CREATE TABLE TCB_BANK_CERT_LOG
(
  MESSAGE_NO  CHAR(10 BYTE)                     NOT NULL,
  REQ_GUBUN   CHAR(2 BYTE)                      NOT NULL,
  SDD_URL     VARCHAR2(1000 BYTE),
  REQ_URL     VARCHAR2(1000 BYTE),
  REQ_DATA    VARCHAR2(1000 BYTE),
  RES_DATA    VARCHAR2(1000 BYTE),
  REQ_IP      VARCHAR2(100 BYTE),
  REQ_DATE    VARCHAR2(14 BYTE),
  STATUS      CHAR(2 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BANNER_LOG
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BANNER_LOG CASCADE CONSTRAINTS;

CREATE TABLE TCB_BANNER_LOG
(
  LOG_SEQ       NUMBER                          NOT NULL,
  GUBUN         VARCHAR2(50 BYTE),
  BANNER_GUBUN  VARCHAR2(100 BYTE),
  LOG_DATE      VARCHAR2(14 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_BANNER_LOG IS '배너이력로그';

COMMENT ON COLUMN TCB_BANNER_LOG.LOG_SEQ IS '일련번호';

COMMENT ON COLUMN TCB_BANNER_LOG.GUBUN IS '서비스 구분';

COMMENT ON COLUMN TCB_BANNER_LOG.BANNER_GUBUN IS '배너명';

COMMENT ON COLUMN TCB_BANNER_LOG.LOG_DATE IS '배너조회일시';


ALTER TABLE TCB_BATCH_TEMPLATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BATCH_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_BATCH_TEMPLATE
(
  TEMPLATE_CD  CHAR(7 BYTE)                     NOT NULL,
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  B_SEQ        NUMBER                           NOT NULL,
  INPUT_KOR    VARCHAR2(255 BYTE),
  INPUT_ENG    VARCHAR2(255 BYTE),
  INPUT_TYPE   VARCHAR2(255 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_BATCH_TEMPLATE IS '계약서류일괄전송설정';

COMMENT ON COLUMN TCB_BATCH_TEMPLATE.TEMPLATE_CD IS '서식코드';

COMMENT ON COLUMN TCB_BATCH_TEMPLATE.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_BATCH_TEMPLATE.B_SEQ IS '일련번호';

COMMENT ON COLUMN TCB_BATCH_TEMPLATE.INPUT_KOR IS '필드영문명';

COMMENT ON COLUMN TCB_BATCH_TEMPLATE.INPUT_ENG IS '필드한글명';

COMMENT ON COLUMN TCB_BATCH_TEMPLATE.INPUT_TYPE IS '필드TYPE';


ALTER TABLE TCB_BATCH_URL
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BATCH_URL CASCADE CONSTRAINTS;

CREATE TABLE TCB_BATCH_URL
(
  MEMBER_NO      CHAR(11 BYTE),
  BATCH_SEQ      NUMBER(3),
  TEMPLATE_CD    CHAR(7 BYTE),
  TEMPLATE_NAME  VARCHAR2(50 BYTE),
  BATCH_URL      VARCHAR2(200 BYTE),
  STATUS         CHAR(2 BYTE),
  ETC            VARCHAR2(200 BYTE),
  DISPLAY_SEQ    NUMBER(38),
  REG_DATE       VARCHAR2(14 BYTE),
  MOD_DATE       VARCHAR2(14 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN TCB_BATCH_URL.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_BATCH_URL.BATCH_SEQ IS '시퀀스';

COMMENT ON COLUMN TCB_BATCH_URL.TEMPLATE_CD IS '양식코드';

COMMENT ON COLUMN TCB_BATCH_URL.TEMPLATE_NAME IS '양식명';

COMMENT ON COLUMN TCB_BATCH_URL.BATCH_URL IS 'URL';

COMMENT ON COLUMN TCB_BATCH_URL.STATUS IS '상태';

COMMENT ON COLUMN TCB_BATCH_URL.ETC IS '기타';

COMMENT ON COLUMN TCB_BATCH_URL.DISPLAY_SEQ IS '조회순서';

COMMENT ON COLUMN TCB_BATCH_URL.REG_DATE IS '생성일';

COMMENT ON COLUMN TCB_BATCH_URL.MOD_DATE IS '수정일';


ALTER TABLE TCB_BID_CONF
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_CONF CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_CONF
(
  MEMBER_NO   CHAR(11 BYTE)                     NOT NULL,
  CONF_GUBUN  VARCHAR2(10 BYTE)                 NOT NULL,
  CONF_TEXT   CLOB,
  STATUS      CHAR(2 BYTE)
)
LOB (CONF_TEXT) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_ITEM_FORM_DEFAULT
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_ITEM_FORM_DEFAULT CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_ITEM_FORM_DEFAULT
(
  MEMBER_NO        VARCHAR2(11 BYTE)            NOT NULL,
  ITEM_FORM_CD_10  VARCHAR2(2 BYTE),
  ITEM_FORM_CD_20  VARCHAR2(2 BYTE),
  ITEM_FORM_CD_30  VARCHAR2(2 BYTE),
  BUILD_ITEM_YN    VARCHAR2(1 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_MASTER
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_MASTER CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_MASTER
(
  MAIN_MEMBER_NO       VARCHAR2(11 BYTE)        NOT NULL,
  NEGO_AMT             NUMBER(18,2),
  BID_KIND_CD          CHAR(2 BYTE)             NOT NULL,
  BID_NO               CHAR(9 BYTE)             NOT NULL,
  BID_DEG              NUMBER(38)               NOT NULL,
  MAIN_VENDCD          VARCHAR2(10 BYTE),
  FIELD_SEQ            NUMBER(38),
  BID_DATE             VARCHAR2(8 BYTE),
  BID_NAME             VARCHAR2(255 BYTE),
  BID_METHOD           CHAR(2 BYTE),
  SUCC_METHOD          CHAR(2 BYTE),
  FIELD_YN             CHAR(1 BYTE),
  FIELD_DATE           VARCHAR2(14 BYTE),
  FIELD_PLACE          VARCHAR2(200 BYTE),
  FIELD_ETC            VARCHAR2(4000 BYTE),
  SUBMIT_SDATE         VARCHAR2(14 BYTE),
  SUBMIT_EDATE         VARCHAR2(14 BYTE),
  ITEM_FORM_GUBUN      VARCHAR2(2 BYTE),
  ITEM_FORM_CD         VARCHAR2(2 BYTE),
  BID_HTML             CLOB,
  OPEN_PERSON_SEQ      NUMBER(38),
  OPEN_DATE            VARCHAR2(14 BYTE),
  OPEN_USER_ID         VARCHAR2(20 BYTE),
  STATUS               CHAR(2 BYTE),
  REV_DATE             VARCHAR2(14 BYTE),
  REV_REASON           CLOB,
  CCL_DATE             VARCHAR2(14 BYTE),
  CCL_REASON           CLOB,
  ADJ_DATE             VARCHAR2(14 BYTE),
  ADJ_REASON           CLOB,
  REBID_REASON         CLOB,
  AG_BID_REASON        CLOB,
  BID_END_DATE         VARCHAR2(14 BYTE),
  REG_ID               VARCHAR2(20 BYTE),
  REG_DATE             VARCHAR2(14 BYTE),
  MOD_ID               VARCHAR2(20 BYTE),
  MOD_DATE             VARCHAR2(14 BYTE),
  USER_NO              VARCHAR2(100 BYTE),
  FIELD_CANCEL_DATE    VARCHAR2(14 BYTE),
  FIELD_CANCEL_REASON  CLOB,
  CONT_NO              VARCHAR2(11 BYTE),
  ETC1                 VARCHAR2(255 BYTE),
  ETC2                 VARCHAR2(255 BYTE),
  ETC3                 VARCHAR2(255 BYTE),
  ETC4                 VARCHAR2(255 BYTE),
  ESTM_CNT_YN          VARCHAR2(1 BYTE),
  BUILD_ITEM_YN        VARCHAR2(1 BYTE),
  CONT_YN              VARCHAR2(1 BYTE),
  EXPECT_AMT           NUMBER(18,2),
  SRC_CD               VARCHAR2(9 BYTE),
  REQ_NO               CHAR(11 BYTE),
  REQ_YN               CHAR(1 BYTE),
  SKILL_RATE           NUMBER(4,2),
  PRICE_RATE           NUMBER(4,2),
  EVALUATE_STATUS      VARCHAR2(2 BYTE),
  EVALUATE_DATE        VARCHAR2(14 BYTE),
  FIELD_MOD_YN         VARCHAR2(1 BYTE),
  OPEN_NOTI_ID         VARCHAR2(20 BYTE),
  UNIT_YN              CHAR(1 BYTE),
  UNIT_SDATE           VARCHAR2(8 BYTE),
  UNIT_EDATE           VARCHAR2(8 BYTE),
  SUCC_AMT_OPEN_YN     CHAR(1 BYTE),
  STORE_CD             VARCHAR2(2 BYTE),
  JOIN_FINISH_DATE     VARCHAR2(14 BYTE),
  JOIN_FINISH_LOC      VARCHAR2(200 BYTE),
  VAT_YN               VARCHAR2(1 BYTE),
  BID_CATE             VARCHAR2(2 BYTE),
  MAKE_TERM            VARCHAR2(3 BYTE),
  PROJECT_SEQ          NUMBER(38),
  MONETRAY_CD          VARCHAR2(2 BYTE),
  EXPECT_GUBUN         VARCHAR2(2 BYTE),
  SUCC_UNDER_RATE      NUMBER(18,3),
  EVALUATE_CD1         VARCHAR2(10 BYTE),
  EVALUATE_CD2         VARCHAR2(10 BYTE),
  EVALUATE_CD3         VARCHAR2(10 BYTE),
  EVALUATE_CD4         VARCHAR2(10 BYTE),
  EXPECT_AMT_REPORT    CLOB,
  PUBLIC_BID_YN        CHAR(1 BYTE),
  BID_ETC              CLOB,
  JOIN_USE_YN          CHAR(1 BYTE),
  JOIN_METHOD          CHAR(2 BYTE),
  SUCC_PAY_YN          CHAR(1 BYTE),
  EXE_WARR_TYPE        CHAR(2 BYTE),
  EXE_WARR_RATE        NUMBER(4,2),
  BID_KIND_NAME        VARCHAR2(255 BYTE),
  A_RATE_AMT           NUMBER(18,2)
)
LOB (EXPECT_AMT_REPORT) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (BID_ETC) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (BID_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (REV_REASON) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (CCL_REASON) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (ADJ_REASON) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (REBID_REASON) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (AG_BID_REASON) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (FIELD_CANCEL_REASON) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40M
            NEXT             4M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN TCB_BID_MASTER.EXPECT_GUBUN IS '예정가격구분(M038) 
10:단일예가,20:복수예가';

COMMENT ON COLUMN TCB_BID_MASTER.BID_KIND_NAME IS '업무구분 기타내용';

COMMENT ON COLUMN TCB_BID_MASTER.SUCC_AMT_OPEN_YN IS 'Y:낙찰 처리시 입찰업체 전체에게 낙찰금액 공개';

COMMENT ON COLUMN TCB_BID_MASTER.BID_KIND_CD IS '입찰유형(M021) 
10:물품,20:용역,30:공사,90:견적관리';

COMMENT ON COLUMN TCB_BID_MASTER.BID_METHOD IS '경쟁방법(M023) 
01:지명 , 02:수의 , 03:공개 , 20:일반, 21:제한';

COMMENT ON COLUMN TCB_BID_MASTER.SUCC_METHOD IS '낙찰자선정방법(M024) 
01:최저가,02:기술/가격동시입찰,03:협상에의한계약,04:최적가입찰(광동제약),05:최고가 
07:재무/가격평가(CJ),08:적격심사,09:제한적최저가,10:제안서평가방식(nh투자),11:역경매,12:순경매';

COMMENT ON COLUMN TCB_BID_MASTER.ITEM_FORM_GUBUN IS '견적구분(M025) 
10:총액입찰,20:내역입찰';

COMMENT ON COLUMN TCB_BID_MASTER.STATUS IS '입찰상태(M022) 
01:입찰계획중,02:설명회대상,03:현설공고중,04:입찰대상,05:공고중,06:개찰완료,07:낙찰,08:대상업체검토(동희오토만),91:유찰,92:재입찰,93:현설취소,94:입찰취소';

COMMENT ON COLUMN TCB_BID_MASTER.CONT_YN IS '계약대상여부';


ALTER TABLE TCB_BID_MULTI_INFO
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_MULTI_INFO CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_MULTI_INFO
(
  MAIN_MEMBER_NO     VARCHAR2(11 BYTE)          NOT NULL,
  BID_NO             CHAR(9 BYTE)               NOT NULL,
  BID_DEG            NUMBER(38)                 NOT NULL,
  BASIC_AMT          NUMBER(18,2),
  MULTI_AMT_OPEN_YN  CHAR(1 BYTE),
  MULTI_SELECT_CNT   NUMBER(38),
  MULTI_AMT_SRATE    NUMBER(18,2),
  MULTI_AMT_SCNT     NUMBER(18),
  MULTI_AMT_ERATE    NUMBER(18,2),
  MULTI_AMT_ECNT     NUMBER,
  PROC_END_DATE      VARCHAR2(14 BYTE),
  PROC_END_ID        VARCHAR2(20 BYTE),
  REG_DATE           VARCHAR2(14 BYTE),
  REG_ID             VARCHAR2(20 BYTE),
  MOD_DATE           VARCHAR2(14 BYTE),
  MOD_ID             VARCHAR2(20 BYTE),
  STATUS             CHAR(2 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_REQ_FILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_REQ_FILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_REQ_FILE
(
  SEQ             NUMBER(38)                    NOT NULL,
  DOC_NAME        VARCHAR2(200 BYTE),
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  RQRD_YN         CHAR(1 BYTE)                  DEFAULT 'Y'
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN TCB_BID_REQ_FILE.RQRD_YN IS '필수여부';


ALTER TABLE TCB_BID_SHARE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_SHARE CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_SHARE
(
  MAIN_MEMBER_NO   VARCHAR2(11 BYTE)            NOT NULL,
  BID_NO           CHAR(9 BYTE)                 NOT NULL,
  BID_DEG          NUMBER                       NOT NULL,
  SEQ              NUMBER                       NOT NULL,
  SEND_USER_ID     VARCHAR2(20 BYTE),
  SEND_USER_NAME   VARCHAR2(100 BYTE),
  SEND_DATE        VARCHAR2(14 BYTE),
  RECV_FIELD_SEQ   NUMBER,
  RECV_FIELD_NAME  VARCHAR2(100 BYTE),
  RECV_USER_ID     VARCHAR2(20 BYTE),
  RECV_USER_NAME   VARCHAR2(100 BYTE),
  RECV_DATE        VARCHAR2(14 BYTE),
  STATUS           CHAR(2 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_SIDAM_SUPP
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_SIDAM_SUPP CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_SIDAM_SUPP
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         INTEGER                       NOT NULL,
  MEMBER_NO       VARCHAR2(11 BYTE)             NOT NULL,
  SIDAM_SEQ       INTEGER                       NOT NULL,
  REQ_DATE        VARCHAR2(14 BYTE),
  SUBMIT_EDATE    VARCHAR2(14 BYTE),
  SUBMIT_DATE     VARCHAR2(14 BYTE),
  SUBMIT_IP       VARCHAR2(20 BYTE),
  STUFF_AMT       NUMBER(18,2),
  LABOR_AMT       NUMBER(18,2),
  UPKEEP_AMT      NUMBER(18,2),
  TOTAL_COST      NUMBER(18,2),
  SIGN_DATA       CLOB,
  SIGN_DN         VARCHAR2(255 BYTE),
  GIVEUP_REASON   CLOB,
  DISQU_REASON    CLOB,
  DISQU_DATE      VARCHAR2(14 BYTE),
  RIVW_OPIN       CLOB,
  SUBMIT_ETC      CLOB,
  ACPT_STATUS     CHAR(1 BYTE),
  CHG_REASON      CLOB,
  CHG_DATE        VARCHAR2(14 BYTE),
  FILE_GRP_SEQ    INTEGER,
  STATUS          VARCHAR2(2 BYTE),
  REG_ID          VARCHAR2(20 BYTE),
  REG_DATE        VARCHAR2(14 BYTE),
  MOD_ID          VARCHAR2(20 BYTE),
  MOD_DATE        VARCHAR2(14 BYTE)
)
LOB (SIGN_DATA) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (GIVEUP_REASON) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (DISQU_REASON) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (RIVW_OPIN) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (SUBMIT_ETC) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (CHG_REASON) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_BID_SIDAM_SUPP IS '견적(입찰)_수의시담_업체이력 정보';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.MAIN_MEMBER_NO IS '작성업체 회원번호';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.BID_NO IS '공고번호';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.BID_DEG IS '공고차수';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.MEMBER_NO IS '업체 회원번호';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.SIDAM_SEQ IS '시담 회차';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.REQ_DATE IS '요청일시';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.SUBMIT_EDATE IS '마감일시';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.SUBMIT_DATE IS '제출일시';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.SUBMIT_IP IS '제출PC IP';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.STUFF_AMT IS '재료비';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.LABOR_AMT IS '노무비';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.UPKEEP_AMT IS '경비';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.TOTAL_COST IS '견적금액';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.SIGN_DATA IS '서명 데이터';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.SIGN_DN IS '서명 DN값';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.GIVEUP_REASON IS '포기사유';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.DISQU_REASON IS '취소사유';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.DISQU_DATE IS '취소일자';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.RIVW_OPIN IS '검토의견(갑사)';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.SUBMIT_ETC IS '기타의견(을사)';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.ACPT_STATUS IS '검토결과(수용여부) Y: 수용, N : 미수용';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.CHG_REASON IS '마감일시 변경사유';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.CHG_DATE IS '마감일시변경일자';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.FILE_GRP_SEQ IS '파일그룹순번';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.STATUS IS '상태코드';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.REG_ID IS '등록자ID';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.REG_DATE IS '등록일시';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.MOD_ID IS '수정자ID';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPP.MOD_DATE IS '수정일시';


ALTER TABLE TCB_BID_SIDAM_SUPPITEM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_SIDAM_SUPPITEM CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_SIDAM_SUPPITEM
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  MEMBER_NO       VARCHAR2(11 BYTE)             NOT NULL,
  SIDAM_SEQ       NUMBER(38)                    NOT NULL,
  ITEM_CD         VARCHAR2(12 BYTE)             NOT NULL,
  STUFF_AMT       NUMBER(18),
  LABOR_AMT       NUMBER(18),
  UPKEEP_AMT      NUMBER(18),
  ITEM_CNT        NUMBER(10,3),
  COST_SUM        NUMBER(18),
  REG_ID          VARCHAR2(20 BYTE),
  REG_DATE        VARCHAR2(14 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_BID_SIDAM_SUPPITEM IS '업체 시담 견적서 정보';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPPITEM.MAIN_MEMBER_NO IS '작성업체 회원번호';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPPITEM.BID_NO IS '공고번호';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPPITEM.BID_DEG IS '차수';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPPITEM.MEMBER_NO IS '제출업체 회원번호';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPPITEM.SIDAM_SEQ IS '수의시담 회차';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPPITEM.ITEM_CD IS '견적 아이템 코드';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPPITEM.STUFF_AMT IS '재료비';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPPITEM.LABOR_AMT IS '노무비';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPPITEM.UPKEEP_AMT IS '경비';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPPITEM.ITEM_CNT IS '수량';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPPITEM.COST_SUM IS '합계';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPPITEM.REG_ID IS '등록자 ID';

COMMENT ON COLUMN TCB_BID_SIDAM_SUPPITEM.REG_DATE IS '등록일시';


ALTER TABLE TCB_BID_SKILL_REQ_FILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_SKILL_REQ_FILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_SKILL_REQ_FILE
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  SEQ             NUMBER(38)                    NOT NULL,
  DOC_NAME        VARCHAR2(200 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_SUPP
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_SUPP CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_SUPP
(
  MAIN_MEMBER_NO     VARCHAR2(11 BYTE)          NOT NULL,
  BID_NO             CHAR(9 BYTE)               NOT NULL,
  BID_DEG            NUMBER(38)                 NOT NULL,
  MEMBER_NO          VARCHAR2(11 BYTE)          NOT NULL,
  VENDCD             VARCHAR2(10 BYTE)          NOT NULL,
  MEMBER_NAME        VARCHAR2(200 BYTE),
  BOSS_NAME          VARCHAR2(200 BYTE),
  USER_NAME          VARCHAR2(30 BYTE),
  HP1                VARCHAR2(3 BYTE),
  HP2                VARCHAR2(4 BYTE),
  HP3                VARCHAR2(4 BYTE),
  EMAIL              VARCHAR2(60 BYTE),
  FIELD_ENTER_YN     VARCHAR2(1 BYTE),
  FIELD_CONF_YN      CHAR(1 BYTE),
  STATUS             VARCHAR2(2 BYTE),
  GIVEUP_REASON      VARCHAR2(255 BYTE),
  GIVEUP_DATE        VARCHAR2(14 BYTE),
  GIVEUP_NAME        VARCHAR2(15 BYTE),
  GIVEUP_TEL         VARCHAR2(15 BYTE),
  GIVEUP_SIGN_DATA   CLOB,
  DISQU_REASON       VARCHAR2(255 BYTE),
  ESTM_SIGN_DATA     CLOB,
  ESTM_SIGN_DN       VARCHAR2(255 BYTE),
  SUBMIT_DATE        VARCHAR2(14 BYTE),
  SUBMIT_IP          VARCHAR2(20 BYTE),
  STUFF_AMT          NUMBER(18,2),
  LABOR_AMT          NUMBER(18,2),
  UPKEEP_AMT         NUMBER(18,2),
  TOTAL_COST         NUMBER(18,2),
  DISPLAY_SEQ        NUMBER(38),
  BID_SUCC_YN        CHAR(1 BYTE),
  FIELD_GIVEUP_TEL   VARCHAR2(15 BYTE),
  FIELD_GIVEUP_NAME  VARCHAR2(15 BYTE),
  FIELD_GIVEUP_DATE  VARCHAR2(14 BYTE),
  FIELD_GIVEUP_SIGN  CLOB,
  SWORN_DATE         VARCHAR2(14 BYTE),
  SWORN_HTML         CLOB,
  SWORN_SIGN_TEXT    CLOB,
  SWORN_SIGN_DATA    CLOB,
  FIELD_ENTER_NAME   VARCHAR2(15 BYTE),
  FIELD_ENTER_TEL    VARCHAR2(15 BYTE),
  FIELD_ENTER_JUMIN  VARCHAR2(10 BYTE),
  FIELD_ENTER_CAR    VARCHAR2(15 BYTE),
  FIELD_ENTER_ETC    VARCHAR2(255 BYTE),
  SECU_DATE          VARCHAR2(14 BYTE),
  SECU_USER_NAME     VARCHAR2(30 BYTE),
  SECU_SIGN_DATA     CLOB,
  DISQU_ID           VARCHAR2(20 BYTE),
  DISQU_DATE         VARCHAR2(14 BYTE),
  FIELD_VIEW_DATE    VARCHAR2(14 BYTE),
  BID_VIEW_DATE      VARCHAR2(14 BYTE),
  ITEM_MOD_DATE      VARCHAR2(14 BYTE),
  ITEM_MOD_ID        VARCHAR2(20 BYTE),
  ORG_TOTAL_COST     NUMBER(18,2),
  NEGO_REGID         VARCHAR2(20 BYTE),
  NEGO_REGDATE       VARCHAR2(14 BYTE),
  NEGO_CONTENT       CLOB,
  NEGO_STATUS        VARCHAR2(1 BYTE),
  SUBMIT_ETC         CLOB,
  CONT_NO            CHAR(11 BYTE),
  CLIP_GRD           VARCHAR2(5 BYTE),
  Y_DATE             VARCHAR2(8 BYTE),
  MULTI_SELECT_NUM   VARCHAR2(255 BYTE),
  DISQU_OPEN_YN      CHAR(1 BYTE),
  PAY_YN             CHAR(1 BYTE)
)
LOB (GIVEUP_SIGN_DATA) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (ESTM_SIGN_DATA) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (FIELD_GIVEUP_SIGN) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (SWORN_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (SWORN_SIGN_TEXT) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (SWORN_SIGN_DATA) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (SECU_SIGN_DATA) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (NEGO_CONTENT) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (SUBMIT_ETC) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          320M
            NEXT             32M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_SUPPITEM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_SUPPITEM CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_SUPPITEM
(
  ITEM_CD         VARCHAR2(12 BYTE)             NOT NULL,
  STUFF_AMT       NUMBER(18),
  LABOR_AMT       NUMBER(18),
  UPKEEP_AMT      NUMBER(18),
  COST_SUM        NUMBER(18),
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  MEMBER_NO       VARCHAR2(11 BYTE)             NOT NULL,
  ITEM_CNT        NUMBER(10,3)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40M
            NEXT             4M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_SUPPITEM_TERM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_SUPPITEM_TERM CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_SUPPITEM_TERM
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  MEMBER_NO       VARCHAR2(11 BYTE)             NOT NULL,
  ITEM_CD         VARCHAR2(12 BYTE)             NOT NULL,
  TERM_SEQ        NUMBER(38)                    NOT NULL,
  TERM_GUBUN      VARCHAR2(100 BYTE),
  ITEM_CNT        NUMBER(10,3),
  STUFF_AMT       NUMBER(18),
  COST_SUM        NUMBER(18)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_SUPP_ORGITEM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_SUPP_ORGITEM CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_SUPP_ORGITEM
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  MEMBER_NO       VARCHAR2(11 BYTE)             NOT NULL,
  ITEM_CD         VARCHAR2(12 BYTE)             NOT NULL,
  STUFF_AMT       NUMBER(18),
  LABOR_AMT       NUMBER(18),
  UPKEEP_AMT      NUMBER(18),
  COST_SUM        NUMBER(18),
  ITEM_CNT        NUMBER(10,3)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_SUPP_REV
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_SUPP_REV CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_SUPP_REV
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER                        NOT NULL,
  MEMBER_NO       VARCHAR2(11 BYTE)             NOT NULL,
  REV_SEQ         NUMBER(3)                     NOT NULL,
  COST_SUM        NUMBER(18),
  SUBMIT_DATE     VARCHAR2(14 BYTE),
  SUBMIT_STATUS   VARCHAR2(10 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_BID_SUPP_REV IS '입찰_역경매견적';

COMMENT ON COLUMN TCB_BID_SUPP_REV.MAIN_MEMBER_NO IS '공고회원번호';

COMMENT ON COLUMN TCB_BID_SUPP_REV.BID_NO IS '공고번호';

COMMENT ON COLUMN TCB_BID_SUPP_REV.BID_DEG IS '차수';

COMMENT ON COLUMN TCB_BID_SUPP_REV.MEMBER_NO IS '회원관리번호';

COMMENT ON COLUMN TCB_BID_SUPP_REV.REV_SEQ IS '일련번호';

COMMENT ON COLUMN TCB_BID_SUPP_REV.COST_SUM IS '금액';

COMMENT ON COLUMN TCB_BID_SUPP_REV.SUBMIT_DATE IS '투찰일시';


ALTER TABLE TCB_BID_SUPP_SIGN_DOC
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_SUPP_SIGN_DOC CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_SUPP_SIGN_DOC
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER                        NOT NULL,
  MEMBER_NO       VARCHAR2(11 BYTE)             NOT NULL,
  DOC_TYPE        CHAR(2 BYTE)                  NOT NULL,
  DOC_NAME        VARCHAR2(200 BYTE),
  FILE_PATH       VARCHAR2(200 BYTE),
  FILE_NAME       VARCHAR2(200 BYTE),
  FILE_EXT        VARCHAR2(20 BYTE),
  FILE_SIZE       NUMBER,
  FILE_HASH       VARCHAR2(255 BYTE),
  SIGN_DATE       VARCHAR2(14 BYTE),
  SIGN_DN         VARCHAR2(255 BYTE),
  SIGN_DATA       CLOB,
  USER_ID         VARCHAR2(20 BYTE),
  STATUS          CHAR(2 BYTE)
)
LOB (SIGN_DATA) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_BID_SUPP_SIGN_DOC IS '입찰업체각서';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.MAIN_MEMBER_NO IS '공고회원번호';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.BID_NO IS '공고번호';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.BID_DEG IS '공고차수';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.DOC_TYPE IS '각서종류';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.DOC_NAME IS '문서명';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.FILE_PATH IS '파일경로';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.FILE_NAME IS '파일명';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.FILE_EXT IS '파일확장자';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.FILE_SIZE IS '파일크기';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.FILE_HASH IS '파일HASH';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.SIGN_DATE IS '서명일시';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.SIGN_DN IS '서명DN';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.SIGN_DATA IS '서명DATA';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.USER_ID IS '서명자ID';

COMMENT ON COLUMN TCB_BID_SUPP_SIGN_DOC.STATUS IS '상태';


ALTER TABLE TCB_BID_SUPP_SUB
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_SUPP_SUB CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_SUPP_SUB
(
  MAIN_MEMBER_NO       VARCHAR2(11 BYTE)        NOT NULL,
  BID_NO               CHAR(9 BYTE)             NOT NULL,
  BID_DEG              NUMBER(38)               NOT NULL,
  MEMBER_NO            VARCHAR2(11 BYTE)        NOT NULL,
  EVALUATE_DATE        VARCHAR2(14 BYTE),
  PASS_STATUS          VARCHAR2(2 BYTE),
  EVALUATE_POINT       NUMBER(5,2),
  SKILL_POINT          NUMBER(5,2),
  PRICE_POINT          NUMBER(5,2),
  TOTAL_POINT          NUMBER(5,2),
  ETC                  VARCHAR2(225 BYTE),
  JOIN_DATE            VARCHAR2(14 BYTE),
  MIN_RESULT_SEQ       VARCHAR2(10 BYTE),
  MAX_RESULT_SEQ       VARCHAR2(10 BYTE),
  AVG_RESULT_POINT     NUMBER(5,2),
  RESULT_GRADE         VARCHAR2(10 BYTE),
  PENALTY_CNT          NUMBER(38),
  TARGET_YN            CHAR(1 BYTE),
  PENALTY_YN           CHAR(1 BYTE),
  TARGET_REG_DATE      VARCHAR2(14 BYTE),
  TARGET_REG_ID        VARCHAR2(20 BYTE),
  EVALUATE_HTML        CLOB,
  STATUS               CHAR(2 BYTE),
  JOIN_STATUS          CHAR(2 BYTE),
  JOIN_REQ_DATE        VARCHAR2(14 BYTE),
  JOIN_REQ_ID          VARCHAR2(20 BYTE),
  JOIN_CONFIRM_DATE    VARCHAR2(14 BYTE),
  JOIN_CONFIRM_ID      VARCHAR2(20 BYTE),
  JOIN_CONFIRM_REASON  CLOB
)
LOB (EVALUATE_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (JOIN_CONFIRM_REASON) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_SUPP_SUCCPAY
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_SUPP_SUCCPAY CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_SUPP_SUCCPAY
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER                        NOT NULL,
  MEMBER_NO       VARCHAR2(11 BYTE)             NOT NULL,
  DOC_NAME        VARCHAR2(255 BYTE),
  DOC_HTML        CLOB,
  FILE_PATH       VARCHAR2(255 BYTE),
  FILE_NAME       VARCHAR2(255 BYTE),
  FILE_EXT        VARCHAR2(20 BYTE),
  FILE_SIZE       NUMBER,
  FILE_HASH       VARCHAR2(255 BYTE),
  SIGN_DATE       VARCHAR2(14 BYTE),
  SIGN_DN         VARCHAR2(255 BYTE),
  SIGN_DATA       CLOB,
  USER_ID         VARCHAR2(20 BYTE),
  USER_NAME       VARCHAR2(20 BYTE),
  HP1             VARCHAR2(3 BYTE),
  HP2             VARCHAR2(4 BYTE),
  HP3             VARCHAR2(4 BYTE),
  EMAIL           VARCHAR2(255 BYTE),
  SUCCPAY_AMT     NUMBER,
  STATUS          CHAR(2 BYTE)
)
LOB (DOC_HTML) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (SIGN_DATA) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


DROP TABLE TCB_BID_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_TEMPLATE
(
  BID_KIND_CD    CHAR(2 BYTE)                   NOT NULL,
  TEMPLATE_CD    VARCHAR2(7 BYTE),
  TEMPLATE_NAME  VARCHAR2(50 BYTE),
  TEMPLATE_HTML  CLOB,
  STATUS         NUMBER(38),
  MEMBER_NO      CHAR(11 BYTE)                  DEFAULT 'Y'
)
LOB (TEMPLATE_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BOARD
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BOARD CASCADE CONSTRAINTS;

CREATE TABLE TCB_BOARD
(
  BOARD_ID   NUMBER(38)                         NOT NULL,
  CATEGORY   VARCHAR2(20 BYTE)                  NOT NULL,
  TITLE      VARCHAR2(255 BYTE)                 NOT NULL,
  OPEN_DATE  VARCHAR2(8 BYTE),
  FILE_EXT   VARCHAR2(5 BYTE),
  OPEN_YN    CHAR(1 BYTE),
  CONTENTS   CLOB,
  DOC_NAME   VARCHAR2(255 BYTE),
  FILE_PATH  VARCHAR2(255 BYTE),
  FILE_NAME  VARCHAR2(255 BYTE),
  FILE_SIZE  NUMBER(38),
  REG_DATE   VARCHAR2(14 BYTE),
  REG_ID     VARCHAR2(20 BYTE)
)
LOB (CONTENTS) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CAR
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CAR CASCADE CONSTRAINTS;

CREATE TABLE TCB_CAR
(
  CAR_CD     CHAR(2 BYTE),
  CAR_NUM    NUMBER(38),
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  SEQ        NUMBER(38)                         NOT NULL,
  WEIGHT_CD  CHAR(2 BYTE),
  CAR_GUBUN  CHAR(1 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CERT_ADD
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CERT_ADD CASCADE CONSTRAINTS;

CREATE TABLE TCB_CERT_ADD
(
  MEMBER_NO   CHAR(11 BYTE)                     NOT NULL,
  CERT_SEQ    NUMBER(38)                        NOT NULL,
  CERT_NAME   VARCHAR2(200 BYTE)                NOT NULL,
  CERT_NO     VARCHAR2(100 BYTE),
  CERT_SDATE  VARCHAR2(8 BYTE),
  CERT_EDATE  VARCHAR2(8 BYTE),
  CERT_ORG    VARCHAR2(100 BYTE),
  DOC_NAME    VARCHAR2(255 BYTE),
  FILE_NAME   VARCHAR2(255 BYTE),
  FILE_PATH   VARCHAR2(255 BYTE),
  FILE_EXT    VARCHAR2(5 BYTE),
  FILE_SIZE   NUMBER(38),
  REG_ID      VARCHAR2(20 BYTE),
  REG_DATE    VARCHAR2(14 BYTE),
  ETC         VARCHAR2(255 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CLIENT_ITEM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CLIENT_ITEM CASCADE CONSTRAINTS;

CREATE TABLE TCB_CLIENT_ITEM
(
  MEMBER_NO      CHAR(11 BYTE)                  NOT NULL,
  CLIENT_NO      CHAR(11 BYTE)                  NOT NULL,
  SEQ            NUMBER(38)                     NOT NULL,
  ITEM_CD        VARCHAR2(10 BYTE)              NOT NULL,
  MAKER          VARCHAR2(255 BYTE)             NOT NULL,
  MAKER_RCD      CHAR(2 BYTE),
  CERT_DOC_YN    CHAR(1 BYTE),
  CERT_END_DATE  VARCHAR2(14 BYTE),
  ETC            VARCHAR2(255 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CLIENT_TECH
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CLIENT_TECH CASCADE CONSTRAINTS;

CREATE TABLE TCB_CLIENT_TECH
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  CLIENT_NO  CHAR(11 BYTE)                      NOT NULL,
  SEQ        NUMBER(38)                         NOT NULL,
  TECH_CD    VARCHAR2(10 BYTE)                  NOT NULL,
  TECH_EXPL  VARCHAR2(255 BYTE),
  ETC        VARCHAR2(255 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CNTC_BIZ
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CNTC_BIZ CASCADE CONSTRAINTS;

CREATE TABLE TCB_CNTC_BIZ
(
  VENDCD    VARCHAR2(10 BYTE)                   NOT NULL,
  TAX_TYPE  VARCHAR2(3 BYTE),
  CHNG_YMD  VARCHAR2(8 BYTE),
  CLSH_YMD  VARCHAR2(8 BYTE),
  NTS_YMD   VARCHAR2(8 BYTE)                    DEFAULT '20000101',
  REG_DATE  DATE,
  REG_ID    VARCHAR2(16 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_CNTC_BIZ IS '사업자 조회 연계 테이블';

COMMENT ON COLUMN TCB_CNTC_BIZ.VENDCD IS '사업자 번호';

COMMENT ON COLUMN TCB_CNTC_BIZ.TAX_TYPE IS '과세유형';

COMMENT ON COLUMN TCB_CNTC_BIZ.CHNG_YMD IS '과세전환일자';

COMMENT ON COLUMN TCB_CNTC_BIZ.CLSH_YMD IS '폐업일자';

COMMENT ON COLUMN TCB_CNTC_BIZ.NTS_YMD IS '국세청기준일자';

COMMENT ON COLUMN TCB_CNTC_BIZ.REG_DATE IS '등록날짜';

COMMENT ON COLUMN TCB_CNTC_BIZ.REG_ID IS '등록자';


DROP TABLE TCB_CNTC_BIZ_H CASCADE CONSTRAINTS;

CREATE TABLE TCB_CNTC_BIZ_H
(
  VENDCD     VARCHAR2(10 BYTE)                  NOT NULL,
  INQ_DTTM   DATE                               NOT NULL,
  TAX_TYPE   VARCHAR2(1 BYTE),
  CLSH_YMD   VARCHAR2(8 BYTE),
  CHNG_YMD   VARCHAR2(8 BYTE),
  NTS_YMD    VARCHAR2(8 BYTE),
  TAX_TYPE2  VARCHAR2(1 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_CNTC_BIZ_H IS '휴폐업조회목록 이력';

COMMENT ON COLUMN TCB_CNTC_BIZ_H.VENDCD IS '사업자번호';

COMMENT ON COLUMN TCB_CNTC_BIZ_H.INQ_DTTM IS '조회일시';

COMMENT ON COLUMN TCB_CNTC_BIZ_H.TAX_TYPE IS '과세유형';

COMMENT ON COLUMN TCB_CNTC_BIZ_H.CLSH_YMD IS '휴폐업일자';

COMMENT ON COLUMN TCB_CNTC_BIZ_H.CHNG_YMD IS '과세전환일자';

COMMENT ON COLUMN TCB_CNTC_BIZ_H.NTS_YMD IS '국세청기준일자';

COMMENT ON COLUMN TCB_CNTC_BIZ_H.TAX_TYPE2 IS '과세유형 상세';


ALTER TABLE TCB_COMCODE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_COMCODE CASCADE CONSTRAINTS;

CREATE TABLE TCB_COMCODE
(
  CCODE     CHAR(4 BYTE)                        NOT NULL,
  CODE      VARCHAR2(3 BYTE)                    NOT NULL,
  CNAME     VARCHAR2(100 BYTE),
  ETC1      VARCHAR2(50 BYTE),
  ETC2      VARCHAR2(200 BYTE),
  SORT      NUMBER(38),
  USE_YN    CHAR(1 BYTE),
  CONDT_YN  CHAR(1 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CONTMASTER
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONTMASTER CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONTMASTER
(
  CONT_NO            CHAR(11 BYTE)              NOT NULL,
  CONT_CHASU         NUMBER(38)                 NOT NULL,
  MEMBER_NO          CHAR(11 BYTE)              NOT NULL,
  FIELD_SEQ          NUMBER(38),
  TEMPLATE_CD        CHAR(7 BYTE),
  CONT_USERNO        VARCHAR2(40 BYTE),
  CONT_NAME          VARCHAR2(255 BYTE),
  CONT_DATE          VARCHAR2(8 BYTE),
  CONT_SDATE         VARCHAR2(8 BYTE),
  CONT_EDATE         VARCHAR2(8 BYTE),
  SUPP_TAX           NUMBER(16,2),
  SUPP_TAXFREE       NUMBER(16,2),
  SUPP_VAT           NUMBER(16,2),
  CONT_TOTAL         NUMBER(16,2),
  MOD_REQ_DATE       VARCHAR2(14 BYTE),
  MOD_REQ_MEMBER_NO  VARCHAR2(11 BYTE),
  MOD_REQ_REASON     CLOB,
  CONT_HASH          CLOB,
  CONT_HTML          CLOB,
  TRUE_RANDOM        VARCHAR2(10 BYTE),
  REG_DATE           VARCHAR2(14 BYTE),
  REG_ID             VARCHAR2(20 BYTE),
  STATUS             CHAR(2 BYTE),
  CHANGE_GUBUN       VARCHAR2(2 BYTE),
  BID_KIND_CD        CHAR(2 BYTE),
  SRC_CD             VARCHAR2(9 BYTE),
  BATCH_GRP_CD       NUMBER(38),
  AGREE_FIELD_SEQS   VARCHAR2(20 BYTE),
  AGREE_PERSON_IDS   VARCHAR2(255 BYTE),
  EFILE_YN           CHAR(1 BYTE),
  CONT_ETC1          VARCHAR2(255 BYTE),
  CONT_ETC2          VARCHAR2(255 BYTE),
  CONT_ETC3          VARCHAR2(255 BYTE),
  BID_NO             CHAR(9 BYTE),
  BID_DEG            NUMBER(38),
  STAMP_TYPE         VARCHAR2(1 BYTE),
  PAPER_YN           CHAR(1 BYTE),
  SUBSCRIPTION_YN    VARCHAR2(1 BYTE),
  SIGN_TYPES         VARCHAR2(255 BYTE),
  PROJECT_SEQ        NUMBER,
  ORG_CONT_HTML      CLOB,
  VERSION_SEQ        NUMBER(4),
  CERT_DOC_MOD_YN    VARCHAR2(1 BYTE)
)
LOB (MOD_REQ_REASON) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (CONT_HASH) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (CONT_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (ORG_CONT_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4000M
            NEXT             400M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CONT_ADD
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONT_ADD CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONT_ADD
(
  CONT_NO     CHAR(11 BYTE)                     NOT NULL,
  CONT_CHASU  NUMBER(38),
  SEQ         NUMBER(38)                        NOT NULL,
  ADD_COL1    VARCHAR2(4000 BYTE),
  ADD_COL2    VARCHAR2(4000 BYTE),
  ADD_COL3    VARCHAR2(4000 BYTE),
  ADD_COL4    VARCHAR2(4000 BYTE),
  ADD_COL5    VARCHAR2(1000 BYTE),
  ADD_COL6    VARCHAR2(1000 BYTE),
  ADD_COL7    VARCHAR2(255 BYTE),
  ADD_COL8    VARCHAR2(255 BYTE),
  ADD_COL9    VARCHAR2(255 BYTE),
  ADD_COL10   VARCHAR2(255 BYTE),
  ADD_COL11   VARCHAR2(255 BYTE),
  ADD_COL12   VARCHAR2(255 BYTE),
  ADD_COL13   VARCHAR2(255 BYTE),
  ADD_COL14   VARCHAR2(255 BYTE),
  ADD_COL15   VARCHAR2(255 BYTE),
  ADD_COL16   VARCHAR2(255 BYTE),
  ADD_COL17   VARCHAR2(255 BYTE),
  ADD_COL18   VARCHAR2(255 BYTE),
  ADD_COL19   VARCHAR2(255 BYTE),
  ADD_COL20   VARCHAR2(255 BYTE),
  ADD_COL21   CLOB
)
LOB (ADD_COL21) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CONT_AGREE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONT_AGREE CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONT_AGREE
(
  AGREE_NAME           VARCHAR2(100 BYTE),
  AGREE_FIELD_SEQ      NUMBER(38),
  AGREE_PERSON_NAME    VARCHAR2(20 BYTE),
  AGREE_SEQ            NUMBER(38)               NOT NULL,
  AG_MD_DATE           VARCHAR2(14 BYTE),
  MOD_REASON           VARCHAR2(255 BYTE),
  AGREE_CD             CHAR(1 BYTE),
  R_AGREE_PERSON_NAME  VARCHAR2(100 BYTE),
  AGREE_PERSON_ID      VARCHAR2(20 BYTE),
  R_AGREE_PERSON_ID    VARCHAR2(20 BYTE),
  CONT_NO              CHAR(11 BYTE)            NOT NULL,
  CONT_CHASU           NUMBER(38)               NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          16M
            NEXT             1600K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CONT_LOG
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONT_LOG CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONT_LOG
(
  CONT_NO      CHAR(11 BYTE)                    NOT NULL,
  CONT_CHASU   NUMBER                           NOT NULL,
  LOG_SEQ      NUMBER                           NOT NULL,
  MEMBER_NO    CHAR(11 BYTE),
  PERSON_SEQ   NUMBER,
  LOG_IP       VARCHAR2(100 BYTE),
  LOG_DATE     VARCHAR2(14 BYTE),
  LOG_ETC      VARCHAR2(255 BYTE),
  SAYOU        CLOB,
  CONT_STATUS  CHAR(2 BYTE),
  STATUS       CHAR(2 BYTE),
  USER_NAME    VARCHAR2(100 BYTE),
  LOG_LEVEL    CHAR(2 BYTE)
)
LOB (SAYOU) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_CONT_LOG IS '계약진행이력';

COMMENT ON COLUMN TCB_CONT_LOG.CONT_NO IS '계약관리번호';

COMMENT ON COLUMN TCB_CONT_LOG.CONT_CHASU IS '변경차수';

COMMENT ON COLUMN TCB_CONT_LOG.LOG_SEQ IS '일련번호';

COMMENT ON COLUMN TCB_CONT_LOG.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_CONT_LOG.PERSON_SEQ IS '담당자일련번호';

COMMENT ON COLUMN TCB_CONT_LOG.LOG_IP IS '진행IP';

COMMENT ON COLUMN TCB_CONT_LOG.LOG_DATE IS '진행일시';

COMMENT ON COLUMN TCB_CONT_LOG.LOG_ETC IS '진행비고';

COMMENT ON COLUMN TCB_CONT_LOG.SAYOU IS '사유';

COMMENT ON COLUMN TCB_CONT_LOG.CONT_STATUS IS '계약상태';

COMMENT ON COLUMN TCB_CONT_LOG.STATUS IS '상태';


ALTER TABLE TCB_CONT_RESIN
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONT_RESIN CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONT_RESIN
(
  CONT_NO    CHAR(11 BYTE)                      NOT NULL,
  BOOK_NAME  VARCHAR2(100 BYTE),
  N_STATUS   VARCHAR2(2 BYTE),
  N_SDAY     VARCHAR2(8 BYTE),
  N_EDAY     VARCHAR2(8 BYTE),
  N_FDAY     VARCHAR2(8 BYTE),
  N_AUTO     VARCHAR2(255 BYTE),
  N_ETC      VARCHAR2(255 BYTE),
  E_STATUS   VARCHAR2(2 BYTE),
  E_SDAY     VARCHAR2(8 BYTE),
  E_EDAY     VARCHAR2(8 BYTE),
  E_FDAY     VARCHAR2(8 BYTE),
  E_AUTO     VARCHAR2(255 BYTE),
  E_ETC      VARCHAR2(255 BYTE),
  J_STATUS   VARCHAR2(2 BYTE),
  J_SDAY     VARCHAR2(8 BYTE),
  J_EDAY     VARCHAR2(8 BYTE),
  J_FDAY     VARCHAR2(8 BYTE),
  J_AUTO     VARCHAR2(255 BYTE),
  J_ETC      VARCHAR2(255 BYTE),
  C_STATUS   VARCHAR2(2 BYTE),
  C_SDAY     VARCHAR2(8 BYTE),
  C_EDAY     VARCHAR2(8 BYTE),
  C_FDAY     VARCHAR2(8 BYTE),
  C_AUTO     VARCHAR2(255 BYTE),
  C_ETC      VARCHAR2(255 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_CONT_RESIN IS '레진_계약현황';

COMMENT ON COLUMN TCB_CONT_RESIN.CONT_NO IS '계약관리번호';

COMMENT ON COLUMN TCB_CONT_RESIN.BOOK_NAME IS '작품명';

COMMENT ON COLUMN TCB_CONT_RESIN.N_STATUS IS '일반_연재상태';

COMMENT ON COLUMN TCB_CONT_RESIN.N_SDAY IS '일반_연재시작일';

COMMENT ON COLUMN TCB_CONT_RESIN.N_EDAY IS '일반_연재종료일';

COMMENT ON COLUMN TCB_CONT_RESIN.N_FDAY IS '일반_서비스권만료일';

COMMENT ON COLUMN TCB_CONT_RESIN.N_AUTO IS '일반_자동연장조건';

COMMENT ON COLUMN TCB_CONT_RESIN.N_ETC IS '일반_기타';

COMMENT ON COLUMN TCB_CONT_RESIN.E_STATUS IS '영어_연재상태';

COMMENT ON COLUMN TCB_CONT_RESIN.E_SDAY IS '영어_연재시작일';

COMMENT ON COLUMN TCB_CONT_RESIN.E_EDAY IS '영어_연재종료일';

COMMENT ON COLUMN TCB_CONT_RESIN.E_FDAY IS '영어_서비스권만료일';

COMMENT ON COLUMN TCB_CONT_RESIN.E_AUTO IS '영어_자동연장조건';

COMMENT ON COLUMN TCB_CONT_RESIN.E_ETC IS '영어_기타';

COMMENT ON COLUMN TCB_CONT_RESIN.J_STATUS IS '일본어_연재상태';

COMMENT ON COLUMN TCB_CONT_RESIN.J_SDAY IS '일본어_연재시작일';

COMMENT ON COLUMN TCB_CONT_RESIN.J_EDAY IS '일본어_연재종료일';

COMMENT ON COLUMN TCB_CONT_RESIN.J_FDAY IS '일본어_서비스권만료일';

COMMENT ON COLUMN TCB_CONT_RESIN.J_AUTO IS '일본어_자동연장조건';

COMMENT ON COLUMN TCB_CONT_RESIN.J_ETC IS '일본어_기타';

COMMENT ON COLUMN TCB_CONT_RESIN.C_STATUS IS '중국어_연재상태';

COMMENT ON COLUMN TCB_CONT_RESIN.C_SDAY IS '중국어_연재시작일';

COMMENT ON COLUMN TCB_CONT_RESIN.C_EDAY IS '중국어_연재종료일';

COMMENT ON COLUMN TCB_CONT_RESIN.C_FDAY IS '중국어_서비스권만료일';

COMMENT ON COLUMN TCB_CONT_RESIN.C_AUTO IS '중국어_자동연장조건';

COMMENT ON COLUMN TCB_CONT_RESIN.C_ETC IS '중국어_기타';


ALTER TABLE TCB_CONT_SIGN
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONT_SIGN CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONT_SIGN
(
  CONT_NO      CHAR(11 BYTE)                    NOT NULL,
  CONT_CHASU   NUMBER(38)                       NOT NULL,
  SIGN_SEQ     NUMBER(38)                       NOT NULL,
  SIGNER_NAME  VARCHAR2(30 BYTE)                NOT NULL,
  SIGNER_MAX   NUMBER(38),
  MEMBER_TYPE  CHAR(2 BYTE),
  CUST_TYPE    CHAR(2 BYTE),
  SPOP_TYPE    VARCHAR2(3 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          16M
            NEXT             1600K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CONT_SUB
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONT_SUB CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONT_SUB
(
  CONT_NO            CHAR(11 BYTE)              NOT NULL,
  CONT_CHASU         NUMBER(38)                 NOT NULL,
  SUB_SEQ            NUMBER(38)                 NOT NULL,
  CONT_SUB_HTML      CLOB,
  CONT_SUB_NAME      VARCHAR2(50 BYTE),
  CONT_SUB_STYLE     VARCHAR2(50 BYTE),
  GUBUN              VARCHAR2(2 BYTE),
  CHK_YN             VARCHAR2(1 BYTE),
  OPTION_YN          VARCHAR2(1 BYTE),
  ORG_CONT_SUB_HTML  CLOB
)
LOB (ORG_CONT_SUB_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (CONT_SUB_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1000M
            NEXT             100M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CONT_TEMPLATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONT_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONT_TEMPLATE
(
  TEMPLATE_CD      CHAR(7 BYTE)                 NOT NULL,
  MEMBER_NO        VARCHAR2(255 BYTE),
  TEMPLATE_NAME    VARCHAR2(50 BYTE),
  TEMPLATE_HTML    CLOB,
  STATUS           NUMBER(10),
  TEMPLATE_STYLE   VARCHAR2(50 BYTE),
  WRITER_TYPE      CHAR(1 BYTE),
  ORG_TEMPLATE_CD  VARCHAR2(255 BYTE),
  TEMPLATE_TYPE    VARCHAR2(2 BYTE),
  PERSON_YN        CHAR(1 BYTE),
  NEED_ATTACH_YN   VARCHAR2(1 BYTE),
  USE_YN           VARCHAR2(2 BYTE),
  DISPLAY_SEQ      NUMBER(10),
  BATCH_CD         VARCHAR2(2 BYTE),
  EXPIRE_NOTI_DAY  VARCHAR2(10 BYTE),
  FIELD_SEQ        VARCHAR2(255 BYTE),
  RFILE_INFO       VARCHAR2(4000 BYTE),
  AGREE_HTML       CLOB,
  EFILE_YN         CHAR(1 BYTE),
  DOC_TYPE         VARCHAR2(1 BYTE),
  STAMP_YN         VARCHAR2(1 BYTE),
  DISPLAY_NAME     VARCHAR2(255 BYTE),
  WARR_YN          CHAR(1 BYTE),
  SEND_TYPE        CHAR(2 BYTE),
  SIGN_TYPES       VARCHAR2(255 BYTE),
  VERSION_NAME     VARCHAR2(255 BYTE),
  VERSION_SEQ      NUMBER(4),
  DOC_GUBUN        VARCHAR2(2 BYTE),
  MOBILE_RFILE_YN  CHAR(1 BYTE)                 DEFAULT 'N'
)
LOB (AGREE_HTML) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (TEMPLATE_HTML) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN TCB_CONT_TEMPLATE.DOC_GUBUN IS '양식종류 구분';

COMMENT ON COLUMN TCB_CONT_TEMPLATE.MOBILE_RFILE_YN IS '모바일 서식 갑사 구비서류 설정 허용여부';


ALTER TABLE TCB_CONT_TEMPLATE_ADD
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONT_TEMPLATE_ADD CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONT_TEMPLATE_ADD
(
  TEMPLATE_CD       CHAR(7 BYTE)                NOT NULL,
  SEQ               NUMBER(38)                  NOT NULL,
  TEMPLATE_NAME_EN  VARCHAR2(255 BYTE),
  TEMPLATE_NAME_KO  VARCHAR2(255 BYTE),
  MUL_YN            VARCHAR2(2 BYTE),
  COL_NAME          VARCHAR2(255 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CONT_TEMPLATE_HIST
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONT_TEMPLATE_HIST CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONT_TEMPLATE_HIST
(
  TEMPLATE_CD    CHAR(7 BYTE)                   NOT NULL,
  VERSION_SEQ    NUMBER(38)                     NOT NULL,
  VERSION_NAME   VARCHAR2(255 BYTE),
  TEMPLATE_NAME  VARCHAR2(50 BYTE),
  TEMPLATE_HTML  CLOB
)
LOB (TEMPLATE_HTML) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_CONT_TEMPLATE_HIST IS '계약서식 히스토리';

COMMENT ON COLUMN TCB_CONT_TEMPLATE_HIST.TEMPLATE_CD IS '서식코드';

COMMENT ON COLUMN TCB_CONT_TEMPLATE_HIST.VERSION_SEQ IS '서식버전';

COMMENT ON COLUMN TCB_CONT_TEMPLATE_HIST.VERSION_NAME IS '버전명';

COMMENT ON COLUMN TCB_CONT_TEMPLATE_HIST.TEMPLATE_NAME IS '서식명';

COMMENT ON COLUMN TCB_CONT_TEMPLATE_HIST.TEMPLATE_HTML IS '서식HTML';


ALTER TABLE TCB_CONT_TEMPLATE_SUB
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONT_TEMPLATE_SUB CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONT_TEMPLATE_SUB
(
  TEMPLATE_CD     CHAR(7 BYTE)                  NOT NULL,
  SUB_SEQ         NUMBER(10)                    NOT NULL,
  TEMPLATE_NAME   VARCHAR2(50 BYTE),
  TEMPLATE_HTML   CLOB,
  TEMPLATE_STYLE  VARCHAR2(50 BYTE),
  GUBUN           VARCHAR2(2 BYTE),
  OPTION_YN       VARCHAR2(1 BYTE)
)
LOB (TEMPLATE_HTML) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CONT_TEMPLATE_SUB_HIST
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONT_TEMPLATE_SUB_HIST CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONT_TEMPLATE_SUB_HIST
(
  TEMPLATE_CD    CHAR(7 BYTE)                   NOT NULL,
  VERSION_SEQ    NUMBER(38)                     NOT NULL,
  SUB_SEQ        NUMBER                         NOT NULL,
  TEMPLATE_NAME  VARCHAR2(50 BYTE),
  TEMPLATE_HTML  CLOB,
  OPTION_YN      VARCHAR2(1 BYTE),
  GUBUN          VARCHAR2(2 BYTE)
)
LOB (TEMPLATE_HTML) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_CONT_TEMPLATE_SUB_HIST IS '계약서식 히스토리 서브';

COMMENT ON COLUMN TCB_CONT_TEMPLATE_SUB_HIST.TEMPLATE_CD IS '서식코드';

COMMENT ON COLUMN TCB_CONT_TEMPLATE_SUB_HIST.VERSION_SEQ IS '서식버전';

COMMENT ON COLUMN TCB_CONT_TEMPLATE_SUB_HIST.SUB_SEQ IS '일련번호';

COMMENT ON COLUMN TCB_CONT_TEMPLATE_SUB_HIST.TEMPLATE_NAME IS 'SUB서식명';

COMMENT ON COLUMN TCB_CONT_TEMPLATE_SUB_HIST.TEMPLATE_HTML IS '서식HTML';


ALTER TABLE TCB_CONT_TEMPLATE_USER
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONT_TEMPLATE_USER CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONT_TEMPLATE_USER
(
  TEMPLATE_CD    CHAR(7 BYTE)                   NOT NULL,
  MEMBER_NO      CHAR(11 BYTE)                  NOT NULL,
  TEMPLATE_HTML  CLOB,
  REG_ID         VARCHAR2(20 BYTE),
  REG_DATE       VARCHAR2(14 BYTE)
)
LOB (TEMPLATE_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CUST
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CUST CASCADE CONSTRAINTS;

CREATE TABLE TCB_CUST
(
  CONT_NO           CHAR(11 BYTE)               NOT NULL,
  CONT_CHASU        NUMBER(38)                  NOT NULL,
  MEMBER_NO         CHAR(11 BYTE)               NOT NULL,
  SIGN_SEQ          NUMBER(38),
  CUST_GUBUN        CHAR(2 BYTE),
  VENDCD            VARCHAR2(10 BYTE),
  JUMIN_NO          VARCHAR2(50 BYTE),
  MEMBER_NAME       VARCHAR2(200 BYTE),
  BOSS_NAME         VARCHAR2(200 BYTE),
  POST_CODE         CHAR(6 BYTE),
  ADDRESS           VARCHAR2(100 BYTE),
  TEL_NUM           VARCHAR2(15 BYTE),
  MEMBER_SLNO       VARCHAR2(13 BYTE),
  USER_NAME         VARCHAR2(30 BYTE),
  HP1               VARCHAR2(3 BYTE),
  HP2               VARCHAR2(4 BYTE),
  HP3               VARCHAR2(4 BYTE),
  EMAIL             VARCHAR2(255 BYTE),
  SIGN_DATE         VARCHAR2(14 BYTE),
  SIGN_DN           VARCHAR2(255 BYTE),
  SIGN_DATA         CLOB,
  EMAIL_RANDOM      VARCHAR2(30 BYTE),
  PAY_YN            CHAR(1 BYTE),
  DISPLAY_SEQ       NUMBER(38),
  CUST_DETAIL_CODE  VARCHAR2(255 BYTE),
  SIGN_TYPE         CHAR(2 BYTE),
  BOSS_BIRTH_DATE   VARCHAR2(14 BYTE),
  BOSS_GENDER       VARCHAR2(2 BYTE),
  LIST_CUST_YN      CHAR(1 BYTE)
)
LOB (SIGN_DATA) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1000M
            NEXT             100M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CUST_SIGN_IMG
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CUST_SIGN_IMG CASCADE CONSTRAINTS;

CREATE TABLE TCB_CUST_SIGN_IMG
(
  CONT_NO       CHAR(11 BYTE)                   NOT NULL,
  CONT_CHASU    NUMBER                          NOT NULL,
  MEMBER_NO     CHAR(11 BYTE)                   NOT NULL,
  SIGN_IMG_SEQ  NUMBER                          NOT NULL,
  OBJECT_NAME   VARCHAR2(255 BYTE),
  IMG_DATA      CLOB,
  IMG_HASH      VARCHAR2(255 BYTE),
  STATUS        CHAR(10 BYTE)
)
LOB (IMG_DATA) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_CUST_SIGN_IMG IS '계약업체서명날인';

COMMENT ON COLUMN TCB_CUST_SIGN_IMG.CONT_NO IS '계약관리번호';

COMMENT ON COLUMN TCB_CUST_SIGN_IMG.CONT_CHASU IS '변경차수';

COMMENT ON COLUMN TCB_CUST_SIGN_IMG.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_CUST_SIGN_IMG.SIGN_IMG_SEQ IS '일련번호';

COMMENT ON COLUMN TCB_CUST_SIGN_IMG.OBJECT_NAME IS '서명OBJ명';

COMMENT ON COLUMN TCB_CUST_SIGN_IMG.IMG_DATA IS '서명_IMG_DATA';

COMMENT ON COLUMN TCB_CUST_SIGN_IMG.IMG_HASH IS '서명_IMG_HASH';

COMMENT ON COLUMN TCB_CUST_SIGN_IMG.STATUS IS '상태';


ALTER TABLE TCB_CUST_TEMP
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CUST_TEMP CASCADE CONSTRAINTS;

CREATE TABLE TCB_CUST_TEMP
(
  MAIN_MEMBER_NO  CHAR(11 BYTE)                 NOT NULL,
  TEMP_SEQ        NUMBER(38)                    NOT NULL,
  MEMBER_NO       CHAR(11 BYTE)                 NOT NULL,
  SIGN_SEQ        NUMBER(38),
  SIGNER_CD       CHAR(2 BYTE),
  SIGNER_NAME     VARCHAR2(60 BYTE),
  CUST_GUBUN      CHAR(2 BYTE),
  VENDCD          VARCHAR2(10 BYTE),
  JUMIN_NO        VARCHAR2(13 BYTE),
  MEMBER_NAME     VARCHAR2(200 BYTE),
  BOSS_NAME       VARCHAR2(200 BYTE),
  POST_CODE       CHAR(6 BYTE),
  ADDRESS         VARCHAR2(100 BYTE),
  TEL_NUM         VARCHAR2(15 BYTE),
  MEMBER_SLNO     VARCHAR2(13 BYTE),
  USER_NAME       VARCHAR2(30 BYTE),
  HP1             CHAR(3 BYTE),
  HP2             CHAR(4 BYTE),
  HP3             CHAR(4 BYTE),
  EMAIL           VARCHAR2(255 BYTE),
  DISPLAY_SEQ     NUMBER(38)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_DEBT_GROUP
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_DEBT_GROUP CASCADE CONSTRAINTS;

CREATE TABLE TCB_DEBT_GROUP
(
  GROUP_NO    CHAR(8 BYTE)                      NOT NULL,
  MEMBER_NO   CHAR(11 BYTE),
  GROUP_NAME  VARCHAR2(255 BYTE),
  SEND_YN     CHAR(1 BYTE),
  REG_DATE    VARCHAR2(14 BYTE),
  REG_ID      VARCHAR2(20 BYTE),
  STATUS      CHAR(2 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_DEBT_TEMP
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_DEBT_TEMP CASCADE CONSTRAINTS;

CREATE TABLE TCB_DEBT_TEMP
(
  MEMBER_NO        CHAR(11 BYTE)                NOT NULL,
  USER_ID          VARCHAR2(20 BYTE)            NOT NULL,
  TEMP_SEQ         NUMBER(38)                   NOT NULL,
  VENDCD           VARCHAR2(10 BYTE),
  CLIENT_NAME      VARCHAR2(100 BYTE),
  AGENT_CD         VARCHAR2(255 BYTE),
  BOSS_BIRTH_DATE  VARCHAR2(8 BYTE),
  AGENT_NAME       VARCHAR2(255 BYTE),
  DEBT_DATE        VARCHAR2(8 BYTE),
  DEBT_CASH        NUMBER(18),
  DEBT_BILL        NUMBER(18),
  DEBT_SUM         NUMBER(18),
  USER_NAME        VARCHAR2(100 BYTE),
  HP1              VARCHAR2(3 BYTE),
  HP2              VARCHAR2(4 BYTE),
  HP3              VARCHAR2(4 BYTE),
  EMAIL            VARCHAR2(255 BYTE),
  CHARGE_ID        VARCHAR2(20 BYTE),
  SALES_NAME       VARCHAR2(255 BYTE),
  SALES_EMAIL      VARCHAR2(255 BYTE),
  DEBT_DATA        CLOB
)
LOB (DEBT_DATA) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_DEBT_TEMPLATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_DEBT_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_DEBT_TEMPLATE
(
  TEMPLATE_CD      CHAR(7 BYTE)                 NOT NULL,
  MEMBER_NO        VARCHAR2(255 BYTE),
  TEMPLATE_NAME    VARCHAR2(255 BYTE),
  TEMPLATE_TYPE    CHAR(2 BYTE),
  TEMPLATE_HTML    CLOB,
  UNIT_COST        NUMBER(18),
  XLS_PATH         VARCHAR2(255 BYTE),
  XLS_HEADER       CLOB,
  ITEM_XLS_PATH    VARCHAR2(255 BYTE),
  ITEM_XLS_HEADER  CLOB,
  ITEM_SELECT      VARCHAR2(255 BYTE),
  USE_YN           CHAR(1 BYTE),
  STATUS           CHAR(2 BYTE)
)
LOB (TEMPLATE_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (XLS_HEADER) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (ITEM_XLS_HEADER) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_DEBT_TEMP_ITEM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_DEBT_TEMP_ITEM CASCADE CONSTRAINTS;

CREATE TABLE TCB_DEBT_TEMP_ITEM
(
  MEMBER_NO      CHAR(11 BYTE)                  NOT NULL,
  USER_ID        VARCHAR2(20 BYTE)              NOT NULL,
  ITEM_TEMP_SEQ  NUMBER(38)                     NOT NULL,
  VENDCD         VARCHAR2(10 BYTE),
  AGENT_CD       VARCHAR2(255 BYTE),
  ITEM_DATA      VARCHAR2(255 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_DOC_INFO
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_DOC_INFO CASCADE CONSTRAINTS;

CREATE TABLE TCB_DOC_INFO
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  DOC_SEQ    NUMBER                             NOT NULL,
  DOC_NO     VARCHAR2(25 BYTE)                  NOT NULL,
  DOC_NAME   VARCHAR2(255 BYTE),
  USER_NAME  VARCHAR2(20 BYTE),
  STATUS     VARCHAR2(2 BYTE),
  REG_DATE   VARCHAR2(14 BYTE),
  PER_DATE   VARCHAR2(14 BYTE),
  APP_DATE   VARCHAR2(8 BYTE),
  MEMO       CLOB,
  ITEM_CNT   NUMBER
)
LOB (MEMO) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_DOC_INFO IS '결재 문서 정보';

COMMENT ON COLUMN TCB_DOC_INFO.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_DOC_INFO.DOC_SEQ IS '결재시퀀스';

COMMENT ON COLUMN TCB_DOC_INFO.DOC_NO IS '문서번호';

COMMENT ON COLUMN TCB_DOC_INFO.DOC_NAME IS '문서제목';

COMMENT ON COLUMN TCB_DOC_INFO.USER_NAME IS '담당자명';

COMMENT ON COLUMN TCB_DOC_INFO.STATUS IS '등록상태';

COMMENT ON COLUMN TCB_DOC_INFO.REG_DATE IS '등록일시';

COMMENT ON COLUMN TCB_DOC_INFO.PER_DATE IS '승인요청일시';

COMMENT ON COLUMN TCB_DOC_INFO.APP_DATE IS '결재일';

COMMENT ON COLUMN TCB_DOC_INFO.MEMO IS '비고';

COMMENT ON COLUMN TCB_DOC_INFO.ITEM_CNT IS '물품등록건수';


ALTER TABLE TCB_EFILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_EFILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_EFILE
(
  CONT_NO     CHAR(11 BYTE)                     NOT NULL,
  CONT_CHASU  NUMBER(38)                        NOT NULL,
  EFILE_SEQ   NUMBER(38)                        NOT NULL,
  DOC_NAME    VARCHAR2(255 BYTE),
  FILE_NAME   VARCHAR2(255 BYTE),
  FILE_PATH   VARCHAR2(255 BYTE),
  FILE_EXT    VARCHAR2(5 BYTE),
  FILE_SIZE   NUMBER(38),
  REG_TYPE    CHAR(2 BYTE),
  REG_DATE    VARCHAR2(14 BYTE),
  REG_ID      VARCHAR2(20 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_EFILE_TEMPLATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_EFILE_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_EFILE_TEMPLATE
(
  TEMPLATE_CD  CHAR(7 BYTE)                     NOT NULL,
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  EFILE_SEQ    NUMBER(38)                       NOT NULL,
  REG_TYPE     CHAR(2 BYTE),
  DOC_NAME     VARCHAR2(255 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ELCMASTER
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ELCMASTER CASCADE CONSTRAINTS;

CREATE TABLE TCB_ELCMASTER
(
  DOC_NO           VARCHAR2(20 BYTE)            NOT NULL,
  WRITE_MEMBER_NO  CHAR(11 BYTE)                NOT NULL,
  MEMBER_NO        CHAR(11 BYTE),
  FIELD_SEQ        NUMBER(38),
  TEMPLATE_CD      CHAR(7 BYTE),
  TEMPLATE_NAME    VARCHAR2(50 BYTE),
  DOC_TITLE        VARCHAR2(255 BYTE),
  DOC_DATE         VARCHAR2(8 BYTE),
  DOC_HTML         CLOB,
  DOC_HASH         CLOB,
  FILE_PATH        VARCHAR2(255 BYTE),
  FILE_NAME        VARCHAR2(255 BYTE),
  FILE_SIZE        NUMBER(38),
  MOD_REQ_DATE     VARCHAR2(14 BYTE),
  MOD_REQ_REASON   VARCHAR2(255 BYTE),
  TRUE_RANDOM      VARCHAR2(10 BYTE),
  REG_DATE         VARCHAR2(14 BYTE),
  REG_ID           VARCHAR2(20 BYTE),
  MOD_DATE         VARCHAR2(14 BYTE),
  MOD_ID           VARCHAR2(20 BYTE),
  STATUS           CHAR(2 BYTE),
  WRITE_GUBUN      CHAR(2 BYTE)
)
LOB (DOC_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (DOC_HASH) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ELC_SIGNFORM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ELC_SIGNFORM CASCADE CONSTRAINTS;

CREATE TABLE TCB_ELC_SIGNFORM
(
  ELC_GUBUN     VARCHAR2(16 BYTE)               NOT NULL,
  SIGNFORM_SEQ  NUMBER(38)                      NOT NULL,
  SIGN_MAX      NUMBER(38)                      NOT NULL,
  SIGN_NAME     VARCHAR2(30 BYTE),
  SIGN_SEQ      NUMBER(38),
  COMP_TYPE     VARCHAR2(2 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ELC_SUPP
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ELC_SUPP CASCADE CONSTRAINTS;

CREATE TABLE TCB_ELC_SUPP
(
  DOC_NO           VARCHAR2(20 BYTE)            NOT NULL,
  MEMBER_NO        CHAR(11 BYTE)                NOT NULL,
  SUPP_TYPE        CHAR(2 BYTE)                 NOT NULL,
  SIGN_YN          CHAR(1 BYTE),
  NEXT_STATUS      CHAR(2 BYTE),
  REQ_DATE         VARCHAR2(14 BYTE),
  CUST_TYPE        CHAR(2 BYTE),
  VENDCD           VARCHAR2(10 BYTE),
  JUMIN_NO         VARCHAR2(13 BYTE),
  MEMBER_NAME      VARCHAR2(200 BYTE),
  BOSS_NAME        VARCHAR2(200 BYTE),
  POST_CODE        CHAR(6 BYTE),
  ADDRESS          VARCHAR2(255 BYTE),
  TEL_NUM          VARCHAR2(50 BYTE),
  USER_NAME        VARCHAR2(30 BYTE),
  HP1              CHAR(3 BYTE),
  HP2              CHAR(4 BYTE),
  HP3              CHAR(4 BYTE),
  EMAIL            VARCHAR2(255 BYTE),
  VIEW_DATE        VARCHAR2(14 BYTE),
  SIGN_DATE        VARCHAR2(14 BYTE),
  SIGN_DN          VARCHAR2(255 BYTE),
  SIGN_DATA        CLOB,
  EMAIL_RANDOM     VARCHAR2(30 BYTE),
  EMAIL_VIEW_DATE  VARCHAR2(14 BYTE)
)
LOB (SIGN_DATA) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ELC_TEMPLATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ELC_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_ELC_TEMPLATE
(
  TEMPLATE_CD       CHAR(7 BYTE)                NOT NULL,
  MEMBER_NO         CHAR(11 BYTE)               NOT NULL,
  TEMPLATE_NAME     VARCHAR2(50 BYTE)           NOT NULL,
  TEMPLATE_HTML     CLOB,
  WRITE_GUBUN       CHAR(2 BYTE),
  SEND_SIGN_YN      CHAR(1 BYTE),
  SEND_NEXT_STATUS  CHAR(2 BYTE),
  RECV_SIGN_YN      CHAR(1 BYTE),
  RECV_NEXT_STATUS  CHAR(2 BYTE),
  STATUS            NUMBER(38),
  ETC               VARCHAR2(255 BYTE),
  SAMPLE_PATH       VARCHAR2(255 BYTE)
)
LOB (TEMPLATE_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


DROP TABLE TCB_EMAIL_DOCU CASCADE CONSTRAINTS;

CREATE TABLE TCB_EMAIL_DOCU
(
  ID     VARCHAR2(20 BYTE),
  EMAIL  VARCHAR2(255 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


DROP TABLE TCB_EMAIL_DOCU_ERR CASCADE CONSTRAINTS;

CREATE TABLE TCB_EMAIL_DOCU_ERR
(
  ID     VARCHAR2(20 BYTE),
  EMAIL  VARCHAR2(255 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


DROP TABLE TCB_EMAIL_DOCU_SEND CASCADE CONSTRAINTS;

CREATE TABLE TCB_EMAIL_DOCU_SEND
(
  ID     VARCHAR2(20 BYTE),
  EMAIL  VARCHAR2(255 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_EVENT
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_EVENT CASCADE CONSTRAINTS;

CREATE TABLE TCB_EVENT
(
  EVENT_SEQ    NUMBER(38)                       NOT NULL,
  GUBUN        VARCHAR2(20 BYTE)                NOT NULL,
  MEMBER_NAME  VARCHAR2(200 BYTE)               NOT NULL,
  VENDCD       VARCHAR2(50 BYTE)                NOT NULL,
  USER_NAME    VARCHAR2(26 BYTE)                NOT NULL,
  EMAIL        VARCHAR2(255 BYTE)               NOT NULL,
  STATUS       CHAR(2 BYTE),
  REG_DATE     VARCHAR2(14 BYTE),
  OUT_DATE     VARCHAR2(14 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_EXAM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_EXAM CASCADE CONSTRAINTS;

CREATE TABLE TCB_EXAM
(
  MEMBER_NO       CHAR(11 BYTE)                 NOT NULL,
  EXAM_CD         CHAR(7 BYTE)                  NOT NULL,
  EXAM_NAME       VARCHAR2(200 BYTE)            NOT NULL,
  QUESTION_CNT    NUMBER(38),
  QUESTION_DEPTH  VARCHAR2(2 BYTE),
  EXAM_TYPE       VARCHAR2(2 BYTE),
  REG_ID          VARCHAR2(20 BYTE),
  REG_DATE        VARCHAR2(18 BYTE),
  USE_YN          CHAR(1 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_EXAM_GRADE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_EXAM_GRADE CASCADE CONSTRAINTS;

CREATE TABLE TCB_EXAM_GRADE
(
  MEMBER_NO   CHAR(11 BYTE)                     NOT NULL,
  EXAM_CD     CHAR(7 BYTE)                      NOT NULL,
  SEQ         NUMBER(38)                        NOT NULL,
  GRADE       VARCHAR2(255 BYTE),
  LEVEL_O     VARCHAR2(255 BYTE),
  GRADE_TEXT  VARCHAR2(255 BYTE),
  MAX_POINT   NUMBER(38),
  MIN_POINT   NUMBER(38)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_EXAM_ITEM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_EXAM_ITEM CASCADE CONSTRAINTS;

CREATE TABLE TCB_EXAM_ITEM
(
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  EXAM_CD      CHAR(7 BYTE)                     NOT NULL,
  QUESTION_CD  VARCHAR2(9 BYTE)                 NOT NULL,
  ITEM_SEQ     NUMBER(38)                       NOT NULL,
  ITEM_TEXT    VARCHAR2(200 BYTE),
  POINT        NUMBER(5,2)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_EXAM_QUESTION
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_EXAM_QUESTION CASCADE CONSTRAINTS;

CREATE TABLE TCB_EXAM_QUESTION
(
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  EXAM_CD      CHAR(7 BYTE)                     NOT NULL,
  QUESTION_CD  VARCHAR2(9 BYTE)                 NOT NULL,
  L_DIV_CD     VARCHAR2(3 BYTE)                 NOT NULL,
  M_DIV_CD     VARCHAR2(3 BYTE),
  S_DIV_CD     VARCHAR2(3 BYTE),
  DEPTH        NUMBER(38),
  QUESTION     VARCHAR2(200 BYTE),
  POINT        NUMBER(38),
  ETC          VARCHAR2(200 BYTE),
  RATE         NUMBER(38),
  RATE_POINT   NUMBER(5,2)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_EXAM_RESULT
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_EXAM_RESULT CASCADE CONSTRAINTS;

CREATE TABLE TCB_EXAM_RESULT
(
  MEMBER_NO       CHAR(11 BYTE)                 NOT NULL,
  RESULT_SEQ      VARCHAR2(10 BYTE)             NOT NULL,
  EXAM_CD         CHAR(7 BYTE)                  NOT NULL,
  EXAM_NAME       VARCHAR2(200 BYTE),
  CLIENT_NO       CHAR(11 BYTE)                 NOT NULL,
  EXAM_TYPE       VARCHAR2(2 BYTE),
  QUESTION_DEPTH  VARCHAR2(2 BYTE),
  QUESTION_CNT    NUMBER(38),
  RESULT_POINT    NUMBER(5,2),
  RESULT_DATE     VARCHAR2(14 BYTE),
  EXAM_ID         VARCHAR2(200 BYTE),
  STATUS          VARCHAR2(2 BYTE),
  CONT_NO         VARCHAR2(11 BYTE),
  CONT_CHASU      NUMBER(38),
  GRADE_SEQ       NUMBER(38)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_EXAM_RESULT_GRADE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_EXAM_RESULT_GRADE CASCADE CONSTRAINTS;

CREATE TABLE TCB_EXAM_RESULT_GRADE
(
  MEMBER_NO   CHAR(11 BYTE)                     NOT NULL,
  RESULT_SEQ  VARCHAR2(10 BYTE)                 NOT NULL,
  SEQ         NUMBER(38)                        NOT NULL,
  GRADE       VARCHAR2(255 BYTE),
  LEVEL_O     VARCHAR2(255 BYTE),
  GRADE_TEXT  VARCHAR2(255 BYTE),
  MAX_POINT   NUMBER(38),
  MIN_POINT   NUMBER(38)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_EXAM_RESULT_ITEM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_EXAM_RESULT_ITEM CASCADE CONSTRAINTS;

CREATE TABLE TCB_EXAM_RESULT_ITEM
(
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  RESULT_SEQ   VARCHAR2(10 BYTE)                NOT NULL,
  QUESTION_CD  VARCHAR2(9 BYTE)                 NOT NULL,
  ITEM_SEQ     NUMBER(38)                       NOT NULL,
  ITEM_TEXT    VARCHAR2(200 BYTE)               NOT NULL,
  POINT        NUMBER(5,2)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          16M
            NEXT             1600K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_EXAM_RESULT_QUESTION
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_EXAM_RESULT_QUESTION CASCADE CONSTRAINTS;

CREATE TABLE TCB_EXAM_RESULT_QUESTION
(
  MEMBER_NO     CHAR(11 BYTE)                   NOT NULL,
  RESULT_SEQ    VARCHAR2(10 BYTE)               NOT NULL,
  QUESTION_CD   VARCHAR2(9 BYTE)                NOT NULL,
  L_DIV_CD      VARCHAR2(3 BYTE)                NOT NULL,
  M_DIV_CD      VARCHAR2(3 BYTE),
  S_DIV_CD      VARCHAR2(3 BYTE),
  DEPTH         NUMBER(38),
  QUESTION      VARCHAR2(200 BYTE),
  POINT         NUMBER(38),
  RESULT_POINT  NUMBER(5,2),
  ETC           VARCHAR2(200 BYTE),
  RATE_POINT    NUMBER(5,2)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_IDENTIFY_LOG
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_IDENTIFY_LOG CASCADE CONSTRAINTS;

CREATE TABLE TCB_IDENTIFY_LOG
(
  LOG_TYPE    VARCHAR2(100 BYTE),
  LOG_DATE    VARCHAR2(100 BYTE),
  CONT_NO     CHAR(11 BYTE),
  CONT_CHASU  NUMBER,
  MEMBER_NO   CHAR(11 BYTE),
  CONTENT     CLOB,
  ETC         VARCHAR2(255 BYTE),
  STATUS      CHAR(2 BYTE),
  LOG_SEQ     NUMBER
)
LOB (CONTENT) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_IDENTIFY_LOG IS '본인확인TSA이력';

COMMENT ON COLUMN TCB_IDENTIFY_LOG.LOG_TYPE IS '이력구분';

COMMENT ON COLUMN TCB_IDENTIFY_LOG.LOG_DATE IS '이력일자';

COMMENT ON COLUMN TCB_IDENTIFY_LOG.CONT_NO IS '계약번호';

COMMENT ON COLUMN TCB_IDENTIFY_LOG.CONT_CHASU IS '계약차수';

COMMENT ON COLUMN TCB_IDENTIFY_LOG.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_IDENTIFY_LOG.CONTENT IS '전문내용';

COMMENT ON COLUMN TCB_IDENTIFY_LOG.ETC IS '비고';

COMMENT ON COLUMN TCB_IDENTIFY_LOG.STATUS IS '상태';


ALTER TABLE TCB_ITEM_DIV
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ITEM_DIV CASCADE CONSTRAINTS;

CREATE TABLE TCB_ITEM_DIV
(
  MEMBER_NO   CHAR(11 BYTE)                     NOT NULL,
  LITEM_CD    CHAR(2 BYTE)                      NOT NULL,
  MITEM_CD    CHAR(3 BYTE)                      NOT NULL,
  LITEM_NAME  VARCHAR2(255 BYTE),
  MITEM_NAME  VARCHAR2(255 BYTE),
  USE_YN      CHAR(1 BYTE)                      DEFAULT 'Y'
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_ITEM_DIV IS '품목분류';

COMMENT ON COLUMN TCB_ITEM_DIV.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_ITEM_DIV.LITEM_CD IS '대분류코드';

COMMENT ON COLUMN TCB_ITEM_DIV.MITEM_CD IS '중분류코드';

COMMENT ON COLUMN TCB_ITEM_DIV.LITEM_NAME IS '대분류명';

COMMENT ON COLUMN TCB_ITEM_DIV.MITEM_NAME IS '중분류명';

COMMENT ON COLUMN TCB_ITEM_DIV.USE_YN IS '사용여부';


ALTER TABLE TCB_ITEM_INFO
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ITEM_INFO CASCADE CONSTRAINTS;

CREATE TABLE TCB_ITEM_INFO
(
  MEMBER_NO     CHAR(11 BYTE)                   NOT NULL,
  ITEM_CD       VARCHAR2(12 BYTE)               NOT NULL,
  L_CD          VARCHAR2(1 BYTE),
  M_CD          VARCHAR2(3 BYTE),
  S_CD          VARCHAR2(3 BYTE),
  D_CD          VARCHAR2(5 BYTE),
  DEPTH         NUMBER(38),
  ITEM_NM       VARCHAR2(255 BYTE),
  STANDARD      VARCHAR2(255 BYTE),
  UNIT          VARCHAR2(100 BYTE),
  USE_YN        CHAR(1 BYTE),
  MAT_CD        CHAR(2 BYTE),
  CONT_SDATE    CHAR(8 BYTE),
  CONT_EDATE    CHAR(8 BYTE),
  UNIT_CONT_YN  CHAR(1 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ITEM_INFO_CODE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ITEM_INFO_CODE CASCADE CONSTRAINTS;

CREATE TABLE TCB_ITEM_INFO_CODE
(
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  ITEM_NO      CHAR(10 BYTE)                    NOT NULL,
  ITEM_NAME    VARCHAR2(255 BYTE),
  USE_YN       CHAR(1 BYTE),
  MEMO         VARCHAR2(255 BYTE),
  USE_YN_DATE  VARCHAR2(14 BYTE),
  REG_DATE     VARCHAR2(14 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_ITEM_INFO_CODE IS '품목 코드 정보';

COMMENT ON COLUMN TCB_ITEM_INFO_CODE.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_ITEM_INFO_CODE.ITEM_NO IS '품목코드번호';

COMMENT ON COLUMN TCB_ITEM_INFO_CODE.ITEM_NAME IS '품목명';

COMMENT ON COLUMN TCB_ITEM_INFO_CODE.USE_YN IS '사용여부';

COMMENT ON COLUMN TCB_ITEM_INFO_CODE.MEMO IS '메모';

COMMENT ON COLUMN TCB_ITEM_INFO_CODE.USE_YN_DATE IS '사용여부변경일시';

COMMENT ON COLUMN TCB_ITEM_INFO_CODE.REG_DATE IS '등록일시';


ALTER TABLE TCB_ITEM_UNIT
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ITEM_UNIT CASCADE CONSTRAINTS;

CREATE TABLE TCB_ITEM_UNIT
(
  MEMBER_NO       CHAR(11 BYTE)                 NOT NULL,
  ITEM_CD         VARCHAR2(10 BYTE)             NOT NULL,
  SEQ             NUMBER(38)                    NOT NULL,
  UNIT_REG_DATE   VARCHAR2(14 BYTE),
  UNIT_AMT        NUMBER(18),
  UNIT_MEMBER_NO  CHAR(11 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


DROP TABLE TCB_LOGIN_LOG CASCADE CONSTRAINTS;

CREATE TABLE TCB_LOGIN_LOG
(
  MEMBER_NO   CHAR(11 BYTE)                     NOT NULL,
  PERSON_SEQ  NUMBER                            NOT NULL,
  USER_ID     VARCHAR2(20 BYTE)                 NOT NULL,
  LOGIN_IP    VARCHAR2(100 BYTE),
  LOGIN_DATE  VARCHAR2(14 BYTE)                 NOT NULL,
  LOGIN_URL   VARCHAR2(255 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_MAJOR_CUST
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_MAJOR_CUST CASCADE CONSTRAINTS;

CREATE TABLE TCB_MAJOR_CUST
(
  CUST_NAME  VARCHAR2(20 BYTE),
  SALES      NUMBER(38),
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  SEQ        NUMBER(38)                         NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_MATERIAL
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_MATERIAL CASCADE CONSTRAINTS;

CREATE TABLE TCB_MATERIAL
(
  CAR_CD       CHAR(2 BYTE)                     NOT NULL,
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  MATERIAL_CD  CHAR(2 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_MEMBER
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_MEMBER CASCADE CONSTRAINTS;

CREATE TABLE TCB_MEMBER
(
  MEMBER_NO      CHAR(11 BYTE)                  NOT NULL,
  MEMBER_NAME    VARCHAR2(200 BYTE)             NOT NULL,
  VENDCD         VARCHAR2(50 BYTE),
  MEMBER_GUBUN   CHAR(2 BYTE),
  MEMBER_TYPE    CHAR(2 BYTE),
  BOSS_NAME      VARCHAR2(200 BYTE),
  POST_CODE      CHAR(6 BYTE),
  ADDRESS        VARCHAR2(100 BYTE),
  BIZ_POST_CODE  CHAR(6 BYTE),
  BIZ_ADDRESS    VARCHAR2(100 BYTE),
  MEMBER_SLNO    VARCHAR2(13 BYTE),
  CONDITION      VARCHAR2(100 BYTE),
  CATEGORY       VARCHAR2(100 BYTE),
  CERT_DN        VARCHAR2(255 BYTE),
  CERT_END_DATE  VARCHAR2(14 BYTE),
  CI_IMG_PATH    VARCHAR2(255 BYTE),
  JOIN_DATE      VARCHAR2(14 BYTE),
  OUT_DATE       VARCHAR2(14 BYTE),
  STATUS         CHAR(2 BYTE),
  REG_DATE       VARCHAR2(14 BYTE),
  REG_ID         VARCHAR2(20 BYTE),
  LOGO_IMG_PATH  VARCHAR2(255 BYTE),
  SRC_DEPTH      CHAR(2 BYTE),
  MARKET_YN      VARCHAR2(2 BYTE),
  DOCU_USE_YN    CHAR(1 BYTE)                   DEFAULT 'Y',
  SIGN_IMG_PATH  VARCHAR2(255 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          16M
            NEXT             1600K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN TCB_MEMBER.DOCU_USE_YN IS '나이스다큐 이용유무(Y:이용중, N:이용종료)';

COMMENT ON COLUMN TCB_MEMBER.SIGN_IMG_PATH IS '인감도장 이미지 경로';


ALTER TABLE TCB_MEMBER_ADD
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_MEMBER_ADD CASCADE CONSTRAINTS;

CREATE TABLE TCB_MEMBER_ADD
(
  SETUP_DATE       VARCHAR2(8 BYTE),
  WORKER_NUM       NUMBER(38),
  SALES_AMT        NUMBER(16,2),
  BIZ_PROFIT       NUMBER(16,2),
  NET_PROFIT       NUMBER(16,2),
  ASSET            NUMBER(16,2),
  CAPITAL          NUMBER(16,2),
  DEBT             NUMBER(16,2),
  BIZ_PROFIT_RATE  NUMBER(5,2),
  DEBT_RATE        NUMBER(7,2),
  LIQUID_ASSET     NUMBER(16,2),
  LIQUID_DEBT      NUMBER(16,2),
  LIQUID_RATE      NUMBER(7,2),
  TAX_DELAY_YN     VARCHAR2(1 BYTE),
  CREDIT_RATING    VARCHAR2(5 BYTE),
  MEMBER_NO        CHAR(11 BYTE)                NOT NULL,
  POST_ADDRESS     VARCHAR2(255 BYTE),
  ADDRESS_TYPE     VARCHAR2(1 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_MEMBER_BOSS
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_MEMBER_BOSS CASCADE CONSTRAINTS;

CREATE TABLE TCB_MEMBER_BOSS
(
  MEMBER_NO        CHAR(11 BYTE)                NOT NULL,
  SEQ              NUMBER                       NOT NULL,
  BOSS_NAME        VARCHAR2(200 BYTE),
  BOSS_BIRTH_DATE  VARCHAR2(14 BYTE),
  BOSS_GENDER      VARCHAR2(2 BYTE),
  BOSS_HP1         VARCHAR2(3 BYTE),
  BOSS_HP2         VARCHAR2(4 BYTE),
  BOSS_HP3         VARCHAR2(4 BYTE),
  BOSS_EMAIL       VARCHAR2(255 BYTE),
  BOSS_CI          VARCHAR2(255 BYTE),
  CI_DATE          VARCHAR2(14 BYTE),
  STATUS           CHAR(2 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_MEMBER_BOSS IS '회원_대표자정보';

COMMENT ON COLUMN TCB_MEMBER_BOSS.MEMBER_NO IS '회원관리번호';

COMMENT ON COLUMN TCB_MEMBER_BOSS.SEQ IS '일련번호';

COMMENT ON COLUMN TCB_MEMBER_BOSS.BOSS_NAME IS '대표자명';

COMMENT ON COLUMN TCB_MEMBER_BOSS.BOSS_BIRTH_DATE IS '생년월일';

COMMENT ON COLUMN TCB_MEMBER_BOSS.BOSS_GENDER IS '성별';

COMMENT ON COLUMN TCB_MEMBER_BOSS.BOSS_HP1 IS '휴대폰1';

COMMENT ON COLUMN TCB_MEMBER_BOSS.BOSS_HP2 IS '휴대폰2';

COMMENT ON COLUMN TCB_MEMBER_BOSS.BOSS_HP3 IS '휴대폰3';

COMMENT ON COLUMN TCB_MEMBER_BOSS.BOSS_EMAIL IS '이메일';

COMMENT ON COLUMN TCB_MEMBER_BOSS.BOSS_CI IS '본인인증CI';

COMMENT ON COLUMN TCB_MEMBER_BOSS.CI_DATE IS '본인인증일시';

COMMENT ON COLUMN TCB_MEMBER_BOSS.STATUS IS '상태';


ALTER TABLE TCB_MEMBER_MENU
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_MEMBER_MENU CASCADE CONSTRAINTS;

CREATE TABLE TCB_MEMBER_MENU
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  ADM_CD     CHAR(6 BYTE)                       NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


DROP TABLE TCB_MEMBER_PDS CASCADE CONSTRAINTS;

CREATE TABLE TCB_MEMBER_PDS
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  SEQ        NUMBER(38)                         NOT NULL,
  TITLE      VARCHAR2(200 BYTE)                 NOT NULL,
  CONTENTS   CLOB,
  REG_DATE   VARCHAR2(14 BYTE),
  REG_ID     VARCHAR2(30 BYTE)
)
LOB (CONTENTS) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_MEMBER_PDS_FILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_MEMBER_PDS_FILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_MEMBER_PDS_FILE
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  SEQ        NUMBER(38)                         NOT NULL,
  FILE_SEQ   NUMBER(38)                         NOT NULL,
  DOC_NAME   VARCHAR2(255 BYTE)                 NOT NULL,
  FILE_PATH  VARCHAR2(255 BYTE),
  FILE_NAME  VARCHAR2(255 BYTE),
  FILE_EXT   VARCHAR2(5 BYTE),
  FILE_SIZE  NUMBER(38)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_MENU
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_MENU CASCADE CONSTRAINTS;

CREATE TABLE TCB_MENU
(
  MENU_CD          CHAR(6 BYTE)                 NOT NULL,
  P_MENU_CD        CHAR(6 BYTE),
  DEPTH            NUMBER(10),
  DIR              VARCHAR2(255 BYTE),
  MENU_PATH        VARCHAR2(255 BYTE),
  MENU_NM          VARCHAR2(255 BYTE),
  GAP_YN           CHAR(1 BYTE),
  EUL_YN           CHAR(1 BYTE),
  USE_YN           CHAR(1 BYTE),
  SELECT_AUTH_CDS  VARCHAR2(255 BYTE),
  BTN_AUTH_CDS     VARCHAR2(255 BYTE),
  DISPLAY_SEQ      NUMBER(10),
  ETC              VARCHAR2(255 BYTE),
  ADM_CD           VARCHAR2(6 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_MENU_INFO
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_MENU_INFO CASCADE CONSTRAINTS;

CREATE TABLE TCB_MENU_INFO
(
  ADM_CD      CHAR(6 BYTE)                      NOT NULL,
  L_DIV_CD    CHAR(2 BYTE),
  M_DIV_CD    CHAR(2 BYTE),
  S_DIV_CD    CHAR(2 BYTE),
  SEQ         NUMBER(38),
  DEPTH       NUMBER(38),
  DIR         VARCHAR2(100 BYTE),
  SRC_PATH    VARCHAR2(255 BYTE),
  MENU_NM     VARCHAR2(100 BYTE),
  WON_YN      CHAR(1 BYTE),
  SOO_YN      CHAR(1 BYTE),
  DEFAULT_YN  CHAR(1 BYTE),
  ETC         VARCHAR2(20 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_MENU_MEMBER
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_MENU_MEMBER CASCADE CONSTRAINTS;

CREATE TABLE TCB_MENU_MEMBER
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  MENU_CD    CHAR(6 BYTE)                       NOT NULL
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_MENU_SUB
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_MENU_SUB CASCADE CONSTRAINTS;

CREATE TABLE TCB_MENU_SUB
(
  ADM_CD     CHAR(6 BYTE)                       NOT NULL,
  SEQ        NUMBER(38)                         NOT NULL,
  FILE_NAME  VARCHAR2(255 BYTE)                 NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ORDER_FIELD
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ORDER_FIELD CASCADE CONSTRAINTS;

CREATE TABLE TCB_ORDER_FIELD
(
  MEMBER_NO   CHAR(11 BYTE)                     NOT NULL,
  FIELD_SEQ   NUMBER(38)                        NOT NULL,
  ORDER_NAME  VARCHAR2(100 BYTE),
  FIELD_NAME  VARCHAR2(200 BYTE),
  FIELD_LOC   VARCHAR2(200 BYTE),
  DEL_YN      VARCHAR2(1 BYTE)                  DEFAULT 'N'
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ORDER_MASTER
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ORDER_MASTER CASCADE CONSTRAINTS;

CREATE TABLE TCB_ORDER_MASTER
(
  ORDER_NO          CHAR(14 BYTE)               NOT NULL,
  MEMBER_NO         CHAR(11 BYTE)               NOT NULL,
  ORDER_NAME        VARCHAR2(255 BYTE),
  ORDER_USERNO      VARCHAR2(255 BYTE),
  ORDER_DATE        VARCHAR2(14 BYTE),
  ORDER_KIND_CD     CHAR(2 BYTE),
  FIELD_SEQ         NUMBER(38),
  ORDER_AMT         NUMBER(18,2),
  CHECK_USER_ID     VARCHAR2(20 BYTE),
  CHECK_USER_NAME   VARCHAR2(20 BYTE),
  SEND_DATE         VARCHAR2(14 BYTE),
  ACCEPT_DATE       VARCHAR2(14 BYTE),
  MOD_REQ_DATE      VARCHAR2(14 BYTE),
  MOD_REQ_REASON    CLOB,
  MOD_REQ_ID        VARCHAR2(20 BYTE),
  TEMPLATE_CD       CHAR(7 BYTE),
  TEMPLATE_HTML     CLOB,
  TEMPLATE_HTML_RM  CLOB,
  TEMPLATE_STYLE    VARCHAR2(255 BYTE),
  REQ_NO            CHAR(11 BYTE),
  BID_NO            VARCHAR2(9 BYTE),
  BID_DEG           NUMBER(38),
  CONT_NO           VARCHAR2(11 BYTE),
  CONT_CHASU        NUMBER(38),
  REG_DATE          VARCHAR2(14 BYTE),
  REG_ID            VARCHAR2(20 BYTE),
  MOD_DATE          VARCHAR2(14 BYTE),
  MOD_ID            VARCHAR2(20 BYTE),
  STATUS            CHAR(2 BYTE)
)
LOB (MOD_REQ_REASON) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (TEMPLATE_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (TEMPLATE_HTML_RM) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ORDER_TEMPLATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ORDER_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_ORDER_TEMPLATE
(
  TEMPLATE_CD     CHAR(7 BYTE)                  NOT NULL,
  MEMBER_NO       VARCHAR2(11 BYTE),
  TEMPLATE_GUBUN  CHAR(2 BYTE),
  ORDER_KIND      VARCHAR2(100 BYTE),
  TEMPLATE_NAME   VARCHAR2(255 BYTE),
  TEMPLATE_HTML   CLOB,
  TEMPLATE_STYLE  VARCHAR2(255 BYTE),
  USE_YN          CHAR(1 BYTE)
)
LOB (TEMPLATE_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_PAY
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_PAY CASCADE CONSTRAINTS;

CREATE TABLE TCB_PAY
(
  CONT_NO      CHAR(11 BYTE)                    NOT NULL,
  CONT_CHASU   NUMBER(38)                       NOT NULL,
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  CONT_NAME    VARCHAR2(255 BYTE)               NOT NULL,
  PAY_AMOUNT   NUMBER(38),
  PAY_TYPE     CHAR(2 BYTE),
  ACCEPT_DATE  VARCHAR2(14 BYTE),
  PAY_NUMBER   VARCHAR2(20 BYTE),
  TID          VARCHAR2(30 BYTE),
  RECEIT_TYPE  VARCHAR2(1 BYTE),
  ACCEPT_SEQ   NUMBER(38),
  ETC          VARCHAR2(300 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          16M
            NEXT             1600K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_PERSON
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_PERSON CASCADE CONSTRAINTS;

CREATE TABLE TCB_PERSON
(
  MEMBER_NO         CHAR(11 BYTE)               NOT NULL,
  PERSON_SEQ        NUMBER(38)                  NOT NULL,
  USER_ID           VARCHAR2(20 BYTE),
  PASSWD            VARCHAR2(100 BYTE),
  JUMIN_NO          VARCHAR2(50 BYTE),
  USER_NAME         VARCHAR2(30 BYTE),
  POSITION          VARCHAR2(20 BYTE),
  DIVISION          VARCHAR2(50 BYTE),
  TEL_NUM           VARCHAR2(15 BYTE),
  FAX_NUM           VARCHAR2(15 BYTE),
  HP1               VARCHAR2(3 BYTE),
  HP2               VARCHAR2(4 BYTE),
  HP3               VARCHAR2(4 BYTE),
  EMAIL             VARCHAR2(255 BYTE),
  DEFAULT_YN        CHAR(1 BYTE),
  REG_DATE          VARCHAR2(14 BYTE),
  REG_ID            VARCHAR2(20 BYTE),
  USE_YN            CHAR(1 BYTE),
  USER_GUBUN        CHAR(2 BYTE),
  STATUS            NUMBER(38),
  FIELD_SEQ         NUMBER(38),
  USER_LEVEL        CHAR(2 BYTE),
  PASSDATE          VARCHAR2(14 BYTE),
  EVENT_AGREE_DATE  VARCHAR2(14 BYTE),
  AUTH_CD           CHAR(4 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          16M
            NEXT             1600K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_PERSON_AUTH
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_PERSON_AUTH CASCADE CONSTRAINTS;

CREATE TABLE TCB_PERSON_AUTH
(
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  PERSON_SEQ   NUMBER(38)                       NOT NULL,
  ADM_CD       CHAR(6 BYTE)                     NOT NULL,
  READ_YN      CHAR(1 BYTE)                     NOT NULL,
  SAVE_YN      CHAR(1 BYTE),
  PRINT_YN     CHAR(1 BYTE),
  ALL_READ_YN  CHAR(1 BYTE)                     DEFAULT 'N'
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_PROJECT
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_PROJECT CASCADE CONSTRAINTS;

CREATE TABLE TCB_PROJECT
(
  MEMBER_NO          CHAR(11 BYTE)              NOT NULL,
  PROJECT_SEQ        NUMBER(38)                 NOT NULL,
  PROJECT_CD         VARCHAR2(255 BYTE),
  PROJECT_NAME       VARCHAR2(255 BYTE),
  PROJECT_LOC        VARCHAR2(255 BYTE),
  ORDER_COMP_NM      VARCHAR2(255 BYTE),
  PROJECT_CONT_DATE  VARCHAR2(14 BYTE),
  ETC1               CLOB,
  ETC2               CLOB,
  USE_YN             CHAR(1 BYTE),
  REG_DATE           VARCHAR2(14 BYTE),
  REG_ID             VARCHAR2(20 BYTE),
  STATUS             CHAR(2 BYTE)
)
LOB (ETC1) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (ETC2) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_PROJECT_ITEM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_PROJECT_ITEM CASCADE CONSTRAINTS;

CREATE TABLE TCB_PROJECT_ITEM
(
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  PROJECT_SEQ  NUMBER(38)                       NOT NULL,
  ITEM_CD      VARCHAR2(12 BYTE)                NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_PROOF
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_PROOF CASCADE CONSTRAINTS;

CREATE TABLE TCB_PROOF
(
  PROOF_NO          VARCHAR2(20 BYTE)           NOT NULL,
  MEMBER_NO         CHAR(11 BYTE),
  CONT_NO           CHAR(12 BYTE),
  CONT_CHASU        NUMBER,
  VENDCD            CHAR(10 BYTE),
  YEAR              CHAR(4 BYTE),
  SCCODE            CHAR(2 BYTE),
  TRUE_RANDOM       CHAR(5 BYTE),
  TEMPLATE_CD       CHAR(7 BYTE),
  TEMPLATE_NAME     VARCHAR2(255 BYTE),
  PROOF_DATE        VARCHAR2(14 BYTE),
  REQ_DATE          VARCHAR2(14 BYTE),
  PROOF_HTML        CLOB,
  ORG_PROOF_HTML    CLOB,
  PROOF_HASH        CLOB,
  RETURN_DATE       VARCHAR2(14 BYTE),
  RETURN_MEMBER_NO  CHAR(11 BYTE),
  RETURN_REASON     CLOB,
  REG_DATE          VARCHAR2(14 BYTE),
  REG_ID            VARCHAR2(20 BYTE),
  MOD_DATE          VARCHAR2(14 BYTE),
  MOD_ID            VARCHAR2(20 BYTE),
  STATUS            CHAR(2 BYTE)
)
LOB (PROOF_HTML) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (ORG_PROOF_HTML) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (PROOF_HASH) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (RETURN_REASON) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_PROOF IS '실적증명';

COMMENT ON COLUMN TCB_PROOF.PROOF_NO IS '증명서번호';

COMMENT ON COLUMN TCB_PROOF.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_PROOF.CONT_NO IS '계약번호';

COMMENT ON COLUMN TCB_PROOF.CONT_CHASU IS '계약차수';

COMMENT ON COLUMN TCB_PROOF.VENDCD IS '사업자등록번호';

COMMENT ON COLUMN TCB_PROOF.YEAR IS '기준년도';

COMMENT ON COLUMN TCB_PROOF.SCCODE IS '협회코드';

COMMENT ON COLUMN TCB_PROOF.TRUE_RANDOM IS '진위확인';

COMMENT ON COLUMN TCB_PROOF.TEMPLATE_CD IS '서식코드';

COMMENT ON COLUMN TCB_PROOF.TEMPLATE_NAME IS '서식명';

COMMENT ON COLUMN TCB_PROOF.PROOF_DATE IS '문서일자';

COMMENT ON COLUMN TCB_PROOF.REQ_DATE IS '발급요청일자';

COMMENT ON COLUMN TCB_PROOF.PROOF_HTML IS '문서HTML';

COMMENT ON COLUMN TCB_PROOF.ORG_PROOF_HTML IS 'ORG_문서HTML';

COMMENT ON COLUMN TCB_PROOF.PROOF_HASH IS '문서HASH';

COMMENT ON COLUMN TCB_PROOF.RETURN_DATE IS '반려일자';

COMMENT ON COLUMN TCB_PROOF.RETURN_MEMBER_NO IS '반려_회원번호';

COMMENT ON COLUMN TCB_PROOF.RETURN_REASON IS '반려사유';

COMMENT ON COLUMN TCB_PROOF.REG_DATE IS '등록일자';

COMMENT ON COLUMN TCB_PROOF.REG_ID IS '등록자';

COMMENT ON COLUMN TCB_PROOF.MOD_DATE IS '수정일자';

COMMENT ON COLUMN TCB_PROOF.MOD_ID IS '수정자';

COMMENT ON COLUMN TCB_PROOF.STATUS IS '상태';


ALTER TABLE TCB_PROOF_CFILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_PROOF_CFILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_PROOF_CFILE
(
  PROOF_NO   VARCHAR2(20 BYTE)                  NOT NULL,
  CFILE_SEQ  NUMBER(38)                         NOT NULL,
  DOC_NAME   VARCHAR2(255 BYTE),
  FILE_PATH  VARCHAR2(255 BYTE),
  FILE_NAME  VARCHAR2(255 BYTE),
  FILE_SIZE  NUMBER(38),
  FILE_EXT   VARCHAR2(100 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_PROOF_CFILE IS '실적증명문서파일';

COMMENT ON COLUMN TCB_PROOF_CFILE.PROOF_NO IS '증명서번호';

COMMENT ON COLUMN TCB_PROOF_CFILE.CFILE_SEQ IS '일련번호';

COMMENT ON COLUMN TCB_PROOF_CFILE.DOC_NAME IS '문서명';

COMMENT ON COLUMN TCB_PROOF_CFILE.FILE_PATH IS '파일경로';

COMMENT ON COLUMN TCB_PROOF_CFILE.FILE_NAME IS '파일명';

COMMENT ON COLUMN TCB_PROOF_CFILE.FILE_SIZE IS '파일크기';

COMMENT ON COLUMN TCB_PROOF_CFILE.FILE_EXT IS '파일확장자';


ALTER TABLE TCB_PROOF_CUST
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_PROOF_CUST CASCADE CONSTRAINTS;

CREATE TABLE TCB_PROOF_CUST
(
  PROOF_NO     VARCHAR2(20 BYTE)                NOT NULL,
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  SIGN_SEQ     NUMBER(38),
  CUST_GUBUN   CHAR(2 BYTE),
  VENDCD       CHAR(10 BYTE),
  MEMBER_NAME  VARCHAR2(100 BYTE),
  BOSS_NAME    VARCHAR2(100 BYTE),
  ADDRESS      VARCHAR2(255 BYTE),
  USER_NAME    VARCHAR2(100 BYTE),
  TEL_NUM      VARCHAR2(100 BYTE),
  HP1          VARCHAR2(3 BYTE),
  HP2          VARCHAR2(4 BYTE),
  HP3          VARCHAR2(4 BYTE),
  EMAIL        VARCHAR2(255 BYTE),
  SIGN_DATE    VARCHAR2(14 BYTE),
  SIGN_DN      VARCHAR2(255 BYTE),
  SIGN_DATA    CLOB,
  STATUS       CHAR(2 BYTE)
)
LOB (SIGN_DATA) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_PROOF_CUST IS '실적증명_업체정보';

COMMENT ON COLUMN TCB_PROOF_CUST.PROOF_NO IS '증명서번호';

COMMENT ON COLUMN TCB_PROOF_CUST.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_PROOF_CUST.SIGN_SEQ IS '서명일련번호';

COMMENT ON COLUMN TCB_PROOF_CUST.CUST_GUBUN IS '업체구분';

COMMENT ON COLUMN TCB_PROOF_CUST.VENDCD IS '사업자등록번호';

COMMENT ON COLUMN TCB_PROOF_CUST.MEMBER_NAME IS '업체명';

COMMENT ON COLUMN TCB_PROOF_CUST.BOSS_NAME IS '대표자';

COMMENT ON COLUMN TCB_PROOF_CUST.ADDRESS IS '주소';

COMMENT ON COLUMN TCB_PROOF_CUST.USER_NAME IS '담당자명';

COMMENT ON COLUMN TCB_PROOF_CUST.TEL_NUM IS '전화번호';

COMMENT ON COLUMN TCB_PROOF_CUST.HP1 IS '휴대폰1';

COMMENT ON COLUMN TCB_PROOF_CUST.HP2 IS '휴대폰2';

COMMENT ON COLUMN TCB_PROOF_CUST.HP3 IS '휴대폰3';

COMMENT ON COLUMN TCB_PROOF_CUST.EMAIL IS '이메일';

COMMENT ON COLUMN TCB_PROOF_CUST.SIGN_DATE IS '서명일자';

COMMENT ON COLUMN TCB_PROOF_CUST.SIGN_DN IS '서명DN';

COMMENT ON COLUMN TCB_PROOF_CUST.SIGN_DATA IS '서명DATA';

COMMENT ON COLUMN TCB_PROOF_CUST.STATUS IS '상태';


ALTER TABLE TCB_PROOF_SIGN
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_PROOF_SIGN CASCADE CONSTRAINTS;

CREATE TABLE TCB_PROOF_SIGN
(
  PROOF_NO     VARCHAR2(20 BYTE)                NOT NULL,
  SIGN_SEQ     NUMBER(38)                       NOT NULL,
  SIGNER_NAME  VARCHAR2(255 BYTE),
  CUST_GUBUN   CHAR(2 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_PROOF_SIGN IS '실적증명서명관계';

COMMENT ON COLUMN TCB_PROOF_SIGN.PROOF_NO IS '증명서번호';

COMMENT ON COLUMN TCB_PROOF_SIGN.SIGN_SEQ IS '서명일련번호';

COMMENT ON COLUMN TCB_PROOF_SIGN.SIGNER_NAME IS '서명관계명';

COMMENT ON COLUMN TCB_PROOF_SIGN.CUST_GUBUN IS '업체구분';


ALTER TABLE TCB_PROOF_TEMPLATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_PROOF_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_PROOF_TEMPLATE
(
  TEMPLATE_CD    CHAR(7 BYTE)                   NOT NULL,
  TEMPLATE_NAME  VARCHAR2(255 BYTE),
  SCCODE         CHAR(2 BYTE),
  TEMPLATE_HTML  CLOB,
  STATUS         CHAR(2 BYTE)
)
LOB (TEMPLATE_HTML) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_PROOF_TEMPLATE IS '실적증명서식';

COMMENT ON COLUMN TCB_PROOF_TEMPLATE.TEMPLATE_CD IS '서식코드';

COMMENT ON COLUMN TCB_PROOF_TEMPLATE.TEMPLATE_NAME IS '서식명';

COMMENT ON COLUMN TCB_PROOF_TEMPLATE.SCCODE IS '협회코드';

COMMENT ON COLUMN TCB_PROOF_TEMPLATE.TEMPLATE_HTML IS '서식HTML';

COMMENT ON COLUMN TCB_PROOF_TEMPLATE.STATUS IS '상태';


ALTER TABLE TCB_QNA
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_QNA CASCADE CONSTRAINTS;

CREATE TABLE TCB_QNA
(
  QNASEQ      NUMBER(38)                        NOT NULL,
  COMPANYNM   VARCHAR2(50 BYTE),
  PERSONNM    VARCHAR2(13 BYTE),
  MOBILE      VARCHAR2(13 BYTE),
  CONTENTS    CLOB,
  INSERTDATE  DATE,
  GUBUN       VARCHAR2(2 BYTE),
  VISIT       VARCHAR2(2 BYTE),
  ETC         VARCHAR2(100 BYTE)
)
LOB (CONTENTS) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_RECRUIT
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_RECRUIT CASCADE CONSTRAINTS;

CREATE TABLE TCB_RECRUIT
(
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  SEQ          NUMBER(38)                       NOT NULL,
  MEMBER_NAME  VARCHAR2(200 BYTE),
  TITLE        VARCHAR2(255 BYTE),
  CHARGE_NAME  VARCHAR2(20 BYTE),
  S_DATE       VARCHAR2(14 BYTE),
  E_DATE       VARCHAR2(14 BYTE),
  POP_URL      VARCHAR2(255 BYTE),
  STATUS       CHAR(2 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_RECRUIT_CATEGORY
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_RECRUIT_CATEGORY CASCADE CONSTRAINTS;

CREATE TABLE TCB_RECRUIT_CATEGORY
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  SEQ        NUMBER(38)                         NOT NULL,
  CODE       VARCHAR2(2 BYTE),
  CODE_NAME  VARCHAR2(255 BYTE),
  BR_YN      CHAR(1 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_RECRUIT_NOTI
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_RECRUIT_NOTI CASCADE CONSTRAINTS;

CREATE TABLE TCB_RECRUIT_NOTI
(
  MEMBER_NO       CHAR(11 BYTE)                 NOT NULL,
  NOTI_SEQ        NUMBER(38)                    NOT NULL,
  TITLE           VARCHAR2(255 BYTE),
  NOTI_DATE       VARCHAR2(14 BYTE),
  REQ_SDATE       VARCHAR2(14 BYTE),
  REQ_EDATE       VARCHAR2(14 BYTE),
  CATE_NAME       VARCHAR2(255 BYTE),
  NOTI_DOC_NAME   VARCHAR2(255 BYTE),
  NOTI_FILE_PATH  VARCHAR2(255 BYTE),
  REQ_HTML        CLOB,
  EVALUATE_HTML   CLOB,
  STATUS          CHAR(2 BYTE)
)
LOB (REQ_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (EVALUATE_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_RECRUIT_SUPP
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_RECRUIT_SUPP CASCADE CONSTRAINTS;

CREATE TABLE TCB_RECRUIT_SUPP
(
  MEMBER_NO   CHAR(11 BYTE)                     NOT NULL,
  SEQ         NUMBER(38)                        NOT NULL,
  VENDCD      CHAR(10 BYTE)                     NOT NULL,
  VENDNM      VARCHAR2(60 BYTE),
  BOSS_NAME   VARCHAR2(200 BYTE),
  POST_CODE   CHAR(6 BYTE),
  ADDRESS     VARCHAR2(255 BYTE),
  CAPITAL     NUMBER(18),
  SALES_AMT   NUMBER(18),
  WORKER_CNT  NUMBER(38),
  USER_NAME   VARCHAR2(20 BYTE),
  POSITION    VARCHAR2(20 BYTE),
  DEPT_NAME   VARCHAR2(50 BYTE),
  TEL_NUM     VARCHAR2(100 BYTE),
  HP1         VARCHAR2(3 BYTE),
  HP2         VARCHAR2(4 BYTE),
  HP3         VARCHAR2(4 BYTE),
  FAX_NUM     VARCHAR2(100 BYTE),
  PASSWD      VARCHAR2(255 BYTE),
  REG_DATE    VARCHAR2(14 BYTE),
  MOD_DATE    VARCHAR2(14 BYTE),
  STATUS      VARCHAR2(2 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_RECRUIT_SUPP_CATEGORY
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_RECRUIT_SUPP_CATEGORY CASCADE CONSTRAINTS;

CREATE TABLE TCB_RECRUIT_SUPP_CATEGORY
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  SEQ        NUMBER(38)                         NOT NULL,
  VENDCD     CHAR(10 BYTE)                      NOT NULL,
  CODE       VARCHAR2(2 BYTE)                   NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_REQ_FILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_REQ_FILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_REQ_FILE
(
  MEMBER_NO  VARCHAR2(11 BYTE)                  NOT NULL,
  REQ_NO     CHAR(11 BYTE),
  SEQ        NUMBER(38)                         NOT NULL,
  FILE_NAME  VARCHAR2(200 BYTE),
  DOC_NAME   VARCHAR2(200 BYTE),
  FILE_PATH  VARCHAR2(255 BYTE),
  FILE_EXT   VARCHAR2(20 BYTE),
  FILE_SIZE  NUMBER(38)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_REQ_INFO
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_REQ_INFO CASCADE CONSTRAINTS;

CREATE TABLE TCB_REQ_INFO
(
  MEMBER_NO      VARCHAR2(11 BYTE)              NOT NULL,
  REQ_NO         CHAR(11 BYTE),
  MAT_CD         CHAR(2 BYTE)                   NOT NULL,
  REQ_NM         VARCHAR2(255 BYTE),
  USER_ID        VARCHAR2(20 BYTE),
  RPT_ID         VARCHAR2(20 BYTE),
  USE_NOTI       VARCHAR2(255 BYTE),
  REQ_DATE       VARCHAR2(14 BYTE),
  RPT_DATE       VARCHAR2(14 BYTE),
  REQ_FIELD_SEQ  NUMBER(38),
  RETURN_ID      VARCHAR2(20 BYTE),
  RETURN_DATE    VARCHAR2(14 BYTE),
  RETURN_REASON  CLOB,
  STATUS         CHAR(2 BYTE),
  REG_ID         VARCHAR2(20 BYTE),
  REG_DATE       VARCHAR2(14 BYTE),
  MOD_ID         VARCHAR2(20 BYTE),
  MOD_DATE       VARCHAR2(14 BYTE)
)
LOB (RETURN_REASON) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_REQ_ITEM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_REQ_ITEM CASCADE CONSTRAINTS;

CREATE TABLE TCB_REQ_ITEM
(
  MEMBER_NO    VARCHAR2(11 BYTE)                NOT NULL,
  REQ_NO       CHAR(11 BYTE),
  ITEM_CD      VARCHAR2(10 BYTE)                NOT NULL,
  ITEM_ADM_YN  CHAR(1 BYTE),
  ITEM_NM      VARCHAR2(255 BYTE),
  STANDARD     VARCHAR2(255 BYTE),
  UNIT         VARCHAR2(100 BYTE),
  QTY          NUMBER(10,3),
  APP_DATE     VARCHAR2(8 BYTE),
  PLACE        VARCHAR2(255 BYTE),
  ITEM_SDATE   VARCHAR2(8 BYTE),
  ITEM_EDATE   VARCHAR2(8 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_RFILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_RFILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_RFILE
(
  CONT_NO           CHAR(11 BYTE)               NOT NULL,
  CONT_CHASU        NUMBER(38)                  NOT NULL,
  RFILE_SEQ         NUMBER(38)                  NOT NULL,
  DOC_NAME          VARCHAR2(255 BYTE)          NOT NULL,
  ATTCH_YN          CHAR(1 BYTE),
  REG_TYPE          VARCHAR2(2 BYTE),
  ALLOW_EXT         VARCHAR2(100 BYTE),
  UNCHECK_TEXT      VARCHAR2(255 BYTE),
  SAMPLE_FILE_PATH  VARCHAR2(255 BYTE),
  SAMPLE_FILE_NAME  VARCHAR2(255 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          16M
            NEXT             1600K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN TCB_RFILE.UNCHECK_TEXT IS '필수해제사유';


ALTER TABLE TCB_RFILE_CUST
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_RFILE_CUST CASCADE CONSTRAINTS;

CREATE TABLE TCB_RFILE_CUST
(
  CONT_NO     CHAR(11 BYTE)                     NOT NULL,
  CONT_CHASU  NUMBER(38)                        NOT NULL,
  RFILE_SEQ   NUMBER(38)                        NOT NULL,
  MEMBER_NO   CHAR(11 BYTE)                     NOT NULL,
  FILE_PATH   VARCHAR2(255 BYTE),
  FILE_NAME   VARCHAR2(255 BYTE),
  FILE_EXT    VARCHAR2(5 BYTE),
  FILE_SIZE   NUMBER(38),
  REG_GUBUN   VARCHAR2(2 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          16M
            NEXT             1600K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_RFILE_TEMPLATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_RFILE_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_RFILE_TEMPLATE
(
  TEMPLATE_CD       CHAR(7 BYTE)                NOT NULL,
  MEMBER_NO         CHAR(11 BYTE)               NOT NULL,
  RFILE_SEQ         NUMBER(38)                  NOT NULL,
  DOC_NAME          VARCHAR2(255 BYTE)          NOT NULL,
  ATTCH_YN          CHAR(1 BYTE),
  REG_TYPE          VARCHAR2(2 BYTE),
  ALLOW_EXT         VARCHAR2(100 BYTE),
  SAMPLE_FILE_PATH  VARCHAR2(255 BYTE),
  SAMPLE_FILE_NAME  VARCHAR2(255 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN TCB_RFILE_TEMPLATE.SAMPLE_FILE_PATH IS '샘플파일경로';

COMMENT ON COLUMN TCB_RFILE_TEMPLATE.SAMPLE_FILE_NAME IS '샘플파일명';


ALTER TABLE TCB_SAMSONG_EVALUATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_SAMSONG_EVALUATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_SAMSONG_EVALUATE
(
  YYYYMM    CHAR(6 BYTE)                        NOT NULL,
  REG_DATE  VARCHAR2(14 BYTE),
  REG_ID    VARCHAR2(20 BYTE),
  MOD_DATE  VARCHAR2(14 BYTE),
  MOD_ID    VARCHAR2(20 BYTE),
  STATUS    CHAR(2 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_SAMSONG_EVALUATE IS '평가정보(삼송)';

COMMENT ON COLUMN TCB_SAMSONG_EVALUATE.YYYYMM IS '기준월';

COMMENT ON COLUMN TCB_SAMSONG_EVALUATE.REG_DATE IS '등록일시';

COMMENT ON COLUMN TCB_SAMSONG_EVALUATE.REG_ID IS '등록자';

COMMENT ON COLUMN TCB_SAMSONG_EVALUATE.MOD_DATE IS '수정일시';

COMMENT ON COLUMN TCB_SAMSONG_EVALUATE.MOD_ID IS '수정자';

COMMENT ON COLUMN TCB_SAMSONG_EVALUATE.STATUS IS '상태';


ALTER TABLE TCB_SAMSONG_EVALUATE_SUPP
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_SAMSONG_EVALUATE_SUPP CASCADE CONSTRAINTS;

CREATE TABLE TCB_SAMSONG_EVALUATE_SUPP
(
  YYYYMM       CHAR(6 BYTE)                     NOT NULL,
  VENDCD       CHAR(10 BYTE)                    NOT NULL,
  Q_POINT      NUMBER(6,3),
  S_POINT      NUMBER(6,3),
  T_POINT      NUMBER(6,3),
  STATUS       CHAR(2 BYTE),
  MEMBER_NAME  VARCHAR2(200 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_SAMSONG_EVALUATE_SUPP IS '평가정보_업체별(삼송)';

COMMENT ON COLUMN TCB_SAMSONG_EVALUATE_SUPP.YYYYMM IS '기준월';

COMMENT ON COLUMN TCB_SAMSONG_EVALUATE_SUPP.VENDCD IS '사업자번호';

COMMENT ON COLUMN TCB_SAMSONG_EVALUATE_SUPP.Q_POINT IS '품질점수';

COMMENT ON COLUMN TCB_SAMSONG_EVALUATE_SUPP.S_POINT IS '서비스점수';

COMMENT ON COLUMN TCB_SAMSONG_EVALUATE_SUPP.T_POINT IS '기술점수';

COMMENT ON COLUMN TCB_SAMSONG_EVALUATE_SUPP.STATUS IS '상태';


ALTER TABLE TCB_SHARE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_SHARE CASCADE CONSTRAINTS;

CREATE TABLE TCB_SHARE
(
  CONT_NO          CHAR(11 BYTE)                NOT NULL,
  CONT_CHASU       NUMBER                       NOT NULL,
  SEQ              NUMBER                       NOT NULL,
  SEND_USER_ID     VARCHAR2(20 BYTE),
  SEND_USER_NAME   VARCHAR2(100 BYTE),
  SEND_DATE        VARCHAR2(14 BYTE),
  RECV_FIELD_SEQ   NUMBER,
  RECV_FIELD_NAME  VARCHAR2(100 BYTE),
  RECV_USER_ID     VARCHAR2(20 BYTE),
  RECV_USER_NAME   VARCHAR2(100 BYTE),
  RECV_DATE        VARCHAR2(14 BYTE),
  STATUS           CHAR(2 BYTE),
  EMAIL            VARCHAR2(255 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_SHARE IS '계약공람정보';

COMMENT ON COLUMN TCB_SHARE.CONT_NO IS '계약관리번호';

COMMENT ON COLUMN TCB_SHARE.CONT_CHASU IS '계약차수';

COMMENT ON COLUMN TCB_SHARE.SEQ IS '일련번호';

COMMENT ON COLUMN TCB_SHARE.SEND_USER_ID IS '제공담당자ID';

COMMENT ON COLUMN TCB_SHARE.SEND_USER_NAME IS '제공담당자명';

COMMENT ON COLUMN TCB_SHARE.SEND_DATE IS '제공일시';

COMMENT ON COLUMN TCB_SHARE.RECV_FIELD_SEQ IS '수신부서일련번호';

COMMENT ON COLUMN TCB_SHARE.RECV_FIELD_NAME IS '수신부서명';

COMMENT ON COLUMN TCB_SHARE.RECV_USER_ID IS '수신담당자ID';

COMMENT ON COLUMN TCB_SHARE.RECV_USER_NAME IS '수신담당자명';

COMMENT ON COLUMN TCB_SHARE.RECV_DATE IS '수신일시';

COMMENT ON COLUMN TCB_SHARE.STATUS IS '상태';


DROP TABLE TCB_SRC_ADM CASCADE CONSTRAINTS;

CREATE TABLE TCB_SRC_ADM
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  SRC_CD     VARCHAR2(12 BYTE)                  NOT NULL,
  L_SRC_CD   VARCHAR2(3 BYTE)                   NOT NULL,
  M_SRC_CD   VARCHAR2(3 BYTE)                   NOT NULL,
  S_SRC_CD   VARCHAR2(3 BYTE)                   NOT NULL,
  SRC_NM     VARCHAR2(255 BYTE),
  DEPTH      NUMBER(38)                         NOT NULL,
  USE_YN     CHAR(1 BYTE),
  FIELD_SEQ  NUMBER(38)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_SRC_MEMBER
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_SRC_MEMBER CASCADE CONSTRAINTS;

CREATE TABLE TCB_SRC_MEMBER
(
  MEMBER_NO      CHAR(11 BYTE)                  NOT NULL,
  SRC_MEMBER_NO  CHAR(11 BYTE)                  NOT NULL,
  SRC_CD         VARCHAR2(12 BYTE)              NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_STAMP
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_STAMP CASCADE CONSTRAINTS;

CREATE TABLE TCB_STAMP
(
  CONT_NO      CHAR(11 BYTE)                    NOT NULL,
  CONT_CHASU   NUMBER(38)                       NOT NULL,
  MEMBER_NO    CHAR(11 BYTE),
  CERT_NO      VARCHAR2(20 BYTE),
  STAMP_MONEY  NUMBER(16,2),
  ISSUE_DATE   VARCHAR2(8 BYTE),
  CHANNEL      VARCHAR2(30 BYTE),
  FILE_TITLE   VARCHAR2(255 BYTE),
  FILE_NAME    VARCHAR2(255 BYTE),
  FILE_PATH    VARCHAR2(255 BYTE),
  FILE_EXT     VARCHAR2(20 BYTE),
  FILE_SIZE    NUMBER(38)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_SUBSCRIPTION
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_SUBSCRIPTION CASCADE CONSTRAINTS;

CREATE TABLE TCB_SUBSCRIPTION
(
  TEMPLATE_CD  CHAR(7 BYTE)                     NOT NULL,
  RECV_USERID  VARCHAR2(20 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_SUBSCRIPTION IS '신청서접수';

COMMENT ON COLUMN TCB_SUBSCRIPTION.TEMPLATE_CD IS '양식코드';

COMMENT ON COLUMN TCB_SUBSCRIPTION.RECV_USERID IS '접수자아이디';


DROP TABLE TCB_SUBSCRIPTION_NOTI CASCADE CONSTRAINTS;

CREATE TABLE TCB_SUBSCRIPTION_NOTI
(
  CONT_NO      CHAR(11 BYTE)                    NOT NULL,
  CONT_CHASU   NUMBER(10)                       NOT NULL,
  MEMBER_NAME  VARCHAR2(200 BYTE),
  USER_NAME    VARCHAR2(30 BYTE),
  HP1          VARCHAR2(3 BYTE),
  HP2          VARCHAR2(4 BYTE),
  HP3          VARCHAR2(4 BYTE),
  EMAIL        VARCHAR2(255 BYTE),
  ETC          VARCHAR2(100 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_SUBSCRIPTION_NOTI IS 'SDD 신청서 알림용 테이블';

COMMENT ON COLUMN TCB_SUBSCRIPTION_NOTI.CONT_NO IS '계약번호';

COMMENT ON COLUMN TCB_SUBSCRIPTION_NOTI.CONT_CHASU IS '계약차수';

COMMENT ON COLUMN TCB_SUBSCRIPTION_NOTI.MEMBER_NAME IS '회사명';

COMMENT ON COLUMN TCB_SUBSCRIPTION_NOTI.USER_NAME IS '담당자명';

COMMENT ON COLUMN TCB_SUBSCRIPTION_NOTI.HP1 IS '휴대번호앞자리';

COMMENT ON COLUMN TCB_SUBSCRIPTION_NOTI.HP2 IS '휴대번호중간자리';

COMMENT ON COLUMN TCB_SUBSCRIPTION_NOTI.HP3 IS '휴대번호끝자리';

COMMENT ON COLUMN TCB_SUBSCRIPTION_NOTI.EMAIL IS '이메일';

COMMENT ON COLUMN TCB_SUBSCRIPTION_NOTI.ETC IS '기타';


ALTER TABLE TCB_SUPP_ELCFORM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_SUPP_ELCFORM CASCADE CONSTRAINTS;

CREATE TABLE TCB_SUPP_ELCFORM
(
  ELC_GUBUN   VARCHAR2(16 BYTE)                 NOT NULL,
  VENDCD      VARCHAR2(13 BYTE)                 NOT NULL,
  ELC_NM      VARCHAR2(200 BYTE),
  ELC_HTML    CLOB,
  REGDATE     DATE,
  WRITE_CODE  VARCHAR2(2 BYTE),
  ETC         VARCHAR2(255 BYTE)
)
LOB (ELC_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_USEINFO
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_USEINFO CASCADE CONSTRAINTS;

CREATE TABLE TCB_USEINFO
(
  MEMBER_NO         CHAR(11 BYTE)               NOT NULL,
  USESEQ            NUMBER(10)                  NOT NULL,
  RECPMONEYAMT      NUMBER(10),
  USESTARTDAY       VARCHAR2(8 BYTE),
  USEENDDAY         VARCHAR2(8 BYTE),
  MODIFYDATE        VARCHAR2(14 BYTE),
  PAYTYPECD         VARCHAR2(2 BYTE),
  SUPPMONEYAMT      NUMBER(10),
  INSTEADYN         CHAR(1 BYTE),
  BIDUSEYN          CHAR(1 BYTE),
  ORDER_WRITE_TYPE  VARCHAR2(1 BYTE),
  ETC               VARCHAR2(255 BYTE),
  STAMPYN           VARCHAR2(1 BYTE),
  PROOF_YN          CHAR(1 BYTE),
  PAPER_AMT         NUMBER,
  BID_AMT           NUMBER,
  CALC_DAY          CHAR(2 BYTE),
  FREE_AMT          NUMBER
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON COLUMN TCB_USEINFO.FREE_AMT IS '자유서식계약요금';


ALTER TABLE TCB_USEINFO_ADD
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_USEINFO_ADD CASCADE CONSTRAINTS;

CREATE TABLE TCB_USEINFO_ADD
(
  TEMPLATE_CD   VARCHAR2(20 BYTE)               NOT NULL,
  RECPMONEYAMT  NUMBER(38),
  SUPPMONEYAMT  NUMBER(38),
  INSTEADYN     CHAR(1 BYTE),
  USESEQ        NUMBER(38)                      NOT NULL,
  MEMBER_NO     CHAR(11 BYTE)                   NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_USER_CODE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_USER_CODE CASCADE CONSTRAINTS;

CREATE TABLE TCB_USER_CODE
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  CODE       VARCHAR2(10 BYTE)                  NOT NULL,
  L_CD       VARCHAR2(1 BYTE)                   NOT NULL,
  M_CD       VARCHAR2(3 BYTE),
  S_CD       VARCHAR2(3 BYTE),
  D_CD       VARCHAR2(3 BYTE),
  DEPTH      NUMBER(38),
  CODE_NM    VARCHAR2(255 BYTE),
  USE_YN     CHAR(1 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_USE_LOG
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_USE_LOG CASCADE CONSTRAINTS;

CREATE TABLE TCB_USE_LOG
(
  MEMBER_NO   CHAR(11 BYTE)                     NOT NULL,
  USE_SEQ     NUMBER                            NOT NULL,
  USE_YN      CHAR(1 BYTE),
  USE_EDATE   VARCHAR2(8 BYTE),
  CHG_REASON  VARCHAR2(4000 BYTE),
  REG_ID      VARCHAR2(20 BYTE),
  REG_DATE    VARCHAR2(14 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_USE_LOG IS '이용유무 이력';

COMMENT ON COLUMN TCB_USE_LOG.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_USE_LOG.USE_SEQ IS '일련번호';

COMMENT ON COLUMN TCB_USE_LOG.USE_YN IS '나이스다큐 사용 유무(Y:이용중, N:이용종료)';

COMMENT ON COLUMN TCB_USE_LOG.USE_EDATE IS '이용기간 종료일';

COMMENT ON COLUMN TCB_USE_LOG.CHG_REASON IS '변경사유';

COMMENT ON COLUMN TCB_USE_LOG.REG_ID IS '등록자ID';

COMMENT ON COLUMN TCB_USE_LOG.REG_DATE IS '등록일자';


ALTER TABLE TCB_WARR
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_WARR CASCADE CONSTRAINTS;

CREATE TABLE TCB_WARR
(
  CONT_NO      CHAR(11 BYTE)                    NOT NULL,
  CONT_CHASU   NUMBER(38)                       NOT NULL,
  WARR_SEQ     NUMBER(38)                       NOT NULL,
  WARR_TYPE    CHAR(2 BYTE)                     NOT NULL,
  MEMBER_NO    CHAR(11 BYTE),
  WARR_OFFICE  VARCHAR2(30 BYTE),
  WARR_NO      VARCHAR2(100 BYTE),
  WARR_AMT     NUMBER(16,2),
  WARR_SDATE   VARCHAR2(8 BYTE),
  WARR_EDATE   VARCHAR2(8 BYTE),
  WARR_DATE    VARCHAR2(8 BYTE),
  WARR_KAMT1   NUMBER(16,2),
  WARR_KAMT2   NUMBER(16,2),
  DOC_NAME     VARCHAR2(255 BYTE),
  FILE_NAME    VARCHAR2(255 BYTE),
  FILE_PATH    VARCHAR2(255 BYTE),
  FILE_EXT     VARCHAR2(5 BYTE),
  FILE_SIZE    NUMBER(38),
  REG_ID       VARCHAR2(20 BYTE),
  REG_DATE     VARCHAR2(14 BYTE),
  ETC          VARCHAR2(255 BYTE),
  STATUS       VARCHAR2(2 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_WARR_ADD
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_WARR_ADD CASCADE CONSTRAINTS;

CREATE TABLE TCB_WARR_ADD
(
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  WARR_SEQ     NUMBER(38)                       NOT NULL,
  WARR_TYPE    CHAR(2 BYTE)                     NOT NULL,
  WARR_OFFICE  VARCHAR2(30 BYTE),
  WARR_NO      VARCHAR2(100 BYTE),
  WARR_AMT     NUMBER(16,2),
  WARR_RATE    NUMBER(5,2),
  WARR_SDATE   VARCHAR2(8 BYTE),
  WARR_EDATE   VARCHAR2(8 BYTE),
  WARR_DATE    VARCHAR2(8 BYTE),
  WARR_KAMT1   NUMBER(16,2),
  WARR_KAMT2   NUMBER(16,2),
  DOC_NAME     VARCHAR2(255 BYTE),
  FILE_NAME    VARCHAR2(255 BYTE),
  FILE_PATH    VARCHAR2(255 BYTE),
  FILE_EXT     VARCHAR2(5 BYTE),
  FILE_SIZE    NUMBER(38),
  REG_ID       VARCHAR2(20 BYTE),
  REG_DATE     VARCHAR2(14 BYTE),
  ETC          VARCHAR2(255 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_WOOWAHAN
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_WOOWAHAN CASCADE CONSTRAINTS;

CREATE TABLE TCB_WOOWAHAN
(
  WOO_SEQ          CHAR(13 BYTE)                NOT NULL,
  APPLY_PATH       VARCHAR2(255 BYTE),
  PRIVACY_YDATE    VARCHAR2(14 BYTE),
  ADVERTI_YDATE    VARCHAR2(14 BYTE),
  USER_CI          VARCHAR2(100 BYTE),
  USER_NAME        VARCHAR2(60 BYTE),
  USER_BIRTHDAY    VARCHAR2(8 BYTE),
  USER_ADDRESS     VARCHAR2(255 BYTE),
  USER_EMAIL       VARCHAR2(255 BYTE),
  DELIVER_CD       VARCHAR2(2 BYTE),
  INSURE_TYPE      VARCHAR2(50 BYTE),
  DELIVERY_SI_CD   VARCHAR2(2 BYTE),
  DELIVERY_GU_CD   VARCHAR2(2 BYTE),
  DELIVERY_BRANCH  VARCHAR2(20 BYTE),
  APPLY_DATE       VARCHAR2(14 BYTE),
  APPLY_STATUS     VARCHAR2(2 BYTE),
  USER_HP          VARCHAR2(11 BYTE),
  USER_REFERID     VARCHAR2(20 BYTE),
  USER_GENDER      VARCHAR2(1 BYTE),
  CONT_NO          CHAR(11 BYTE),
  SIGN_DATA        CLOB,
  RETRY_DATE       VARCHAR2(14 BYTE),
  IDENTITY_YDATE   VARCHAR2(14 BYTE),
  POST_CODE        VARCHAR2(5 BYTE),
  USER_ADDRESS2    VARCHAR2(100 BYTE)
)
LOB (SIGN_DATA) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_WOOWAHAN IS '우아한청년들_신청';

COMMENT ON COLUMN TCB_WOOWAHAN.WOO_SEQ IS '일련번호';

COMMENT ON COLUMN TCB_WOOWAHAN.APPLY_PATH IS '지원경로';

COMMENT ON COLUMN TCB_WOOWAHAN.PRIVACY_YDATE IS '개인정보동의일시';

COMMENT ON COLUMN TCB_WOOWAHAN.USER_CI IS '사용자CI';

COMMENT ON COLUMN TCB_WOOWAHAN.USER_NAME IS '신청자명';

COMMENT ON COLUMN TCB_WOOWAHAN.USER_BIRTHDAY IS '생년월일';

COMMENT ON COLUMN TCB_WOOWAHAN.USER_ADDRESS IS '거주지주소';

COMMENT ON COLUMN TCB_WOOWAHAN.USER_EMAIL IS '이메일';

COMMENT ON COLUMN TCB_WOOWAHAN.DELIVER_CD IS '배달수단코드';

COMMENT ON COLUMN TCB_WOOWAHAN.INSURE_TYPE IS '보험종류';

COMMENT ON COLUMN TCB_WOOWAHAN.DELIVERY_SI_CD IS '배달지역(시)';

COMMENT ON COLUMN TCB_WOOWAHAN.DELIVERY_GU_CD IS '배달지역(구)';

COMMENT ON COLUMN TCB_WOOWAHAN.DELIVERY_BRANCH IS '지점명';

COMMENT ON COLUMN TCB_WOOWAHAN.APPLY_DATE IS '지원일시';

COMMENT ON COLUMN TCB_WOOWAHAN.APPLY_STATUS IS '지원상태';


ALTER TABLE TCB_WOOWAHAN_AREA
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_WOOWAHAN_AREA CASCADE CONSTRAINTS;

CREATE TABLE TCB_WOOWAHAN_AREA
(
  AREA1        VARCHAR2(2 BYTE)                 NOT NULL,
  AREA2        VARCHAR2(2 BYTE)                 NOT NULL,
  AREA1_NAME   VARCHAR2(20 BYTE),
  AREA2_NAME   VARCHAR2(20 BYTE),
  BRANCH_NAME  VARCHAR2(20 BYTE),
  ACTIVE_AREA  VARCHAR2(255 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_WOOWAHAN_AREA IS '우아한청년들_지역';

COMMENT ON COLUMN TCB_WOOWAHAN_AREA.AREA1 IS '대분류코드';

COMMENT ON COLUMN TCB_WOOWAHAN_AREA.AREA2 IS '중분류코드';

COMMENT ON COLUMN TCB_WOOWAHAN_AREA.AREA1_NAME IS '대분류명';

COMMENT ON COLUMN TCB_WOOWAHAN_AREA.AREA2_NAME IS '중분류명';

COMMENT ON COLUMN TCB_WOOWAHAN_AREA.BRANCH_NAME IS '지점명';

COMMENT ON COLUMN TCB_WOOWAHAN_AREA.ACTIVE_AREA IS '활동구';


DROP TABLE TCB_WOOWAHAN_BLACK CASCADE CONSTRAINTS;

CREATE TABLE TCB_WOOWAHAN_BLACK
(
  USER_HP        VARCHAR2(11 BYTE),
  USER_NAME      VARCHAR2(60 BYTE),
  USER_BIRTHDAY  VARCHAR2(8 BYTE),
  REG_DATE       VARCHAR2(14 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_WOOWAHAN_BLACK IS '우아한청년들_블랙리스트';

COMMENT ON COLUMN TCB_WOOWAHAN_BLACK.USER_HP IS '휴대폰번호';

COMMENT ON COLUMN TCB_WOOWAHAN_BLACK.USER_NAME IS '이름';

COMMENT ON COLUMN TCB_WOOWAHAN_BLACK.USER_BIRTHDAY IS '생년월일';

COMMENT ON COLUMN TCB_WOOWAHAN_BLACK.REG_DATE IS '등록일';


ALTER TABLE TCB_WOOWAHAN_FILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_WOOWAHAN_FILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_WOOWAHAN_FILE
(
  WOO_SEQ      CHAR(13 BYTE)                    NOT NULL,
  REG_TYPE     VARCHAR2(2 BYTE)                 NOT NULL,
  DOC_NAME     VARCHAR2(255 BYTE),
  FILE_PATH    VARCHAR2(255 BYTE),
  FILE_NAME    VARCHAR2(200 BYTE),
  FILE_EXT     VARCHAR2(20 BYTE),
  FILE_SIZE    NUMBER,
  ATTCH_YN     VARCHAR2(1 BYTE),
  DISPLAY_SEQ  NUMBER(38)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_WOOWAHAN_FILE IS '우아한청년들_제출서류';

COMMENT ON COLUMN TCB_WOOWAHAN_FILE.WOO_SEQ IS '일련번호';

COMMENT ON COLUMN TCB_WOOWAHAN_FILE.REG_TYPE IS '문서종류';

COMMENT ON COLUMN TCB_WOOWAHAN_FILE.DOC_NAME IS '문서명';

COMMENT ON COLUMN TCB_WOOWAHAN_FILE.FILE_PATH IS '파일경로';

COMMENT ON COLUMN TCB_WOOWAHAN_FILE.FILE_NAME IS '파일명';

COMMENT ON COLUMN TCB_WOOWAHAN_FILE.FILE_EXT IS '파일확장자';

COMMENT ON COLUMN TCB_WOOWAHAN_FILE.FILE_SIZE IS '파일크기';


DROP TABLE TCB_WOOWAHAN_LINK CASCADE CONSTRAINTS;

CREATE TABLE TCB_WOOWAHAN_LINK
(
  LINK_NAME  VARCHAR2(60 BYTE),
  LINK_CODE  VARCHAR2(10 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_WOOWAHAN_LINK IS '우아한청년들_유입경로';

COMMENT ON COLUMN TCB_WOOWAHAN_LINK.LINK_NAME IS '유입경로명';

COMMENT ON COLUMN TCB_WOOWAHAN_LINK.LINK_CODE IS '유입코드';


CREATE INDEX FK_TCB_CONT_ADD ON TCB_CONT_ADD
(CONT_NO, CONT_CHASU)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX FK_TCB_CONT_TEMPLATE_ADD ON TCB_CONT_TEMPLATE_ADD
(TEMPLATE_CD)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX IDX_TCB_BANNER_LOG_N1 ON TCB_BANNER_LOG
(LOG_DATE)
LOGGING
TABLESPACE TS_DOCU_I
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX IDX_TCB_BANNER_LOG_P ON TCB_BANNER_LOG
(LOG_SEQ)
LOGGING
TABLESPACE TS_DOCU_I
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX IDX_TCB_IDENTIFY_LOG_N1 ON TCB_IDENTIFY_LOG
(LOG_DATE)
LOGGING
TABLESPACE TS_DOCU_I
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_APPLY_NOTI ON TCB_APPLY_NOTI
(MEMBER_NO, NOTI_NO)
LOGGING
TABLESPACE TS_DOCU_I
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_APPLY_PERSON ON TCB_APPLY_PERSON
(APPLY_NO)
LOGGING
TABLESPACE TS_DOCU_I
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_BANK_CERT_LOG ON TCB_BANK_CERT_LOG
(MESSAGE_NO, REQ_GUBUN)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_BATCH_TEMPLATE ON TCB_BATCH_TEMPLATE
(TEMPLATE_CD, MEMBER_NO, B_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_BID_CONF ON TCB_BID_CONF
(MEMBER_NO, CONF_GUBUN)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_BID_SHARE ON TCB_BID_SHARE
(MAIN_MEMBER_NO, BID_NO, BID_DEG, SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_BID_SUPP_REV ON TCB_BID_SUPP_REV
(MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, REV_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_BID_SUPP_SIGN_DOC ON TCB_BID_SUPP_SIGN_DOC
(MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, DOC_TYPE)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_BID_SUPP_SUCCPAY ON TCB_BID_SUPP_SUCCPAY
(MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_CONT_ADD ON TCB_CONT_ADD
(CONT_NO, CONT_CHASU, SEQ)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_CONT_LOG ON TCB_CONT_LOG
(CONT_NO, CONT_CHASU, LOG_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_CONT_RESIN ON TCB_CONT_RESIN
(CONT_NO)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_CONT_TEMPLATE_ADD ON TCB_CONT_TEMPLATE_ADD
(TEMPLATE_CD, SEQ)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_CONT_TEMPLATE_HIST ON TCB_CONT_TEMPLATE_HIST
(TEMPLATE_CD, VERSION_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_CUST_SIGN_IMG ON TCB_CUST_SIGN_IMG
(CONT_NO, CONT_CHASU, MEMBER_NO, SIGN_IMG_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_DOC_INFO ON TCB_DOC_INFO
(MEMBER_NO, DOC_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_ITEM_DIV ON TCB_ITEM_DIV
(MEMBER_NO, LITEM_CD, MITEM_CD)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_ITEM_INFO_CODE ON TCB_ITEM_INFO_CODE
(MEMBER_NO, ITEM_NO)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_MEMBER_BOSS ON TCB_MEMBER_BOSS
(MEMBER_NO, SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_MENU ON TCB_MENU
(MENU_CD)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_PROOF ON TCB_PROOF
(PROOF_NO)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_PROOF_CFILE ON TCB_PROOF_CFILE
(PROOF_NO, CFILE_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_PROOF_CUST ON TCB_PROOF_CUST
(PROOF_NO, MEMBER_NO)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_PROOF_SIGN ON TCB_PROOF_SIGN
(PROOF_NO, SIGN_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_PROOF_TEMPLATE ON TCB_PROOF_TEMPLATE
(TEMPLATE_CD)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_SHARE ON TCB_SHARE
(CONT_NO, CONT_CHASU, SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_SUBSCRIPTION ON TCB_SUBSCRIPTION
(TEMPLATE_CD)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_WOOWAHAN ON TCB_WOOWAHAN
(WOO_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_WOOWAHAN_AREA ON TCB_WOOWAHAN_AREA
(AREA1, AREA2)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_WOOWAHAN_FILE ON TCB_WOOWAHAN_FILE
(WOO_SEQ, REG_TYPE)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX SYS_C3 ON TCB_CONT_TEMPLATE_SUB_HIST
(TEMPLATE_CD, VERSION_SEQ, SUB_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_ASSEMASTER_IDX ON TCB_ASSEMASTER
(ASSE_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_ASSE_TEMPLATE_IDX ON TCB_ASSE_TEMPLATE
(TEMPLATE_CD)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_BATCH_URL_PK ON TCB_BATCH_URL
(MEMBER_NO, BATCH_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_BID_SIDAM_SUPPITEM_PK ON TCB_BID_SIDAM_SUPPITEM
(MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, SIDAM_SEQ, 
ITEM_CD)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_BID_SIDAM_SUPP_PK ON TCB_BID_SIDAM_SUPP
(MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, SIDAM_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_BID_SUPP_ORGITEM_IDX ON TCB_BID_SUPP_ORGITEM
(MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, ITEM_CD)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_CLIENT_ITEM_IDX1 ON TCB_CLIENT_ITEM
(MEMBER_NO, CLIENT_NO, SEQ)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_CLIENT_TECH_IDX1 ON TCB_CLIENT_TECH
(MEMBER_NO, CLIENT_NO, SEQ)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX TCB_CNTC_BIZ_H_N1 ON TCB_CNTC_BIZ_H
(VENDCD, INQ_DTTM)
LOGGING
TABLESPACE TS_DOCU_I
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX TCB_CNTC_BIZ_IDX1 ON TCB_CNTC_BIZ
(NTS_YMD)
LOGGING
TABLESPACE TS_DOCU_I
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_CNTC_BIZ_PK ON TCB_CNTC_BIZ
(VENDCD)
LOGGING
TABLESPACE TS_DOCU_I
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          8M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_CONT_TEMPLATE_PK ON TCB_CONT_TEMPLATE
(TEMPLATE_CD)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_CONT_TEMPLATE_SUB_PK ON TCB_CONT_TEMPLATE_SUB
(TEMPLATE_CD, SUB_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_EFILE_IDX ON TCB_EFILE
(CONT_NO, CONT_CHASU, EFILE_SEQ)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_EFILE_TEMPLATE_IDX ON TCB_EFILE_TEMPLATE
(TEMPLATE_CD, MEMBER_NO, EFILE_SEQ)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_IDENTIFY_LOG_PK ON TCB_IDENTIFY_LOG
(LOG_SEQ)
LOGGING
TABLESPACE TS_DOCU_I
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_ITEM_INFO_IDX ON TCB_ITEM_INFO
(MEMBER_NO, ITEM_CD)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX TCB_MEMBER_VENDCD ON TCB_MEMBER
(VENDCD)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_ORDER_FIELD_IDX ON TCB_ORDER_FIELD
(MEMBER_NO, FIELD_SEQ)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_ORDER_MASTER_IDX ON TCB_ORDER_MASTER
(ORDER_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_ORDER_TEMPLATE_IDX ON TCB_ORDER_TEMPLATE
(TEMPLATE_CD)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_RECRUIT_CATEGORY_IDX ON TCB_RECRUIT_CATEGORY
(MEMBER_NO, SEQ, CODE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_RECRUIT_IDX ON TCB_RECRUIT
(MEMBER_NO, SEQ)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_RECRUIT_SUPP_CATEGORY_IDX ON TCB_RECRUIT_SUPP_CATEGORY
(MEMBER_NO, SEQ, VENDCD, CODE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_RECRUIT_SUPP_IDX ON TCB_RECRUIT_SUPP
(MEMBER_NO, SEQ, VENDCD)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_STAMP_IDX ON TCB_STAMP
(CONT_NO, CONT_CHASU, MEMBER_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_USEINFO_PK ON TCB_USEINFO
(USESEQ, MEMBER_NO)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_USER_CODE_IDX1 ON TCB_USER_CODE
(MEMBER_NO, CODE)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_USE_LOG_PK ON TCB_USE_LOG
(MEMBER_NO, USE_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_WARR_PK ON TCB_WARR
(CONT_NO, CONT_CHASU, WARR_SEQ)
LOGGING
TABLESPACE TS_DOCU_I
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX XPKTCB_COMCODE ON TCB_COMCODE
(CCODE, CODE)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX XPKTCB_QNA ON TCB_QNA
(QNASEQ)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


DROP PUBLIC SYNONYM TCB_BANNER_LOG;

CREATE PUBLIC SYNONYM TCB_BANNER_LOG FOR TCB_BANNER_LOG;


DROP PUBLIC SYNONYM TCB_CNTC_BIZ;

CREATE PUBLIC SYNONYM TCB_CNTC_BIZ FOR TCB_CNTC_BIZ;


DROP PUBLIC SYNONYM TCB_IDENTIFY_LOG;

CREATE PUBLIC SYNONYM TCB_IDENTIFY_LOG FOR TCB_IDENTIFY_LOG;


ALTER TABLE TCB_APPLY_CAREER
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_APPLY_CAREER CASCADE CONSTRAINTS;

CREATE TABLE TCB_APPLY_CAREER
(
  APPLY_NO      CHAR(11 BYTE),
  CAREER_SEQ    NUMBER(10),
  COMPANY       VARCHAR2(100 BYTE),
  WORK_SDATE    VARCHAR2(8 BYTE),
  WORK_EDATE    VARCHAR2(8 BYTE),
  APPLY_JOB     VARCHAR2(60 BYTE),
  POSITION      VARCHAR2(60 BYTE),
  LEAVE_REASON  VARCHAR2(200 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_APPLY_EDU
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_APPLY_EDU CASCADE CONSTRAINTS;

CREATE TABLE TCB_APPLY_EDU
(
  APPLY_NO    CHAR(11 BYTE),
  EDU_SEQ     NUMBER(10),
  EDU_TYPE    CHAR(3 BYTE),
  SCHOOL      VARCHAR2(100 BYTE),
  EDU_SDATE   VARCHAR2(8 BYTE),
  EDU_EDATE   VARCHAR2(8 BYTE),
  GRD_STATUS  VARCHAR2(100 BYTE),
  MAJOR       VARCHAR2(100 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_APPLY_FILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_APPLY_FILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_APPLY_FILE
(
  APPLY_NO   CHAR(11 BYTE),
  FILE_SEQ   NUMBER(10),
  DOC_NAME   VARCHAR2(255 BYTE),
  FILE_NAME  VARCHAR2(255 BYTE),
  FILE_PATH  VARCHAR2(255 BYTE),
  FILE_EXT   VARCHAR2(100 BYTE),
  FILE_SIZE  NUMBER(10)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_APPLY_LICENSE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_APPLY_LICENSE CASCADE CONSTRAINTS;

CREATE TABLE TCB_APPLY_LICENSE
(
  APPLY_NO    CHAR(11 BYTE),
  LICEN_SEQ   NUMBER(10),
  LICEN_TYPE  VARCHAR2(30 BYTE),
  LICENSE     VARCHAR2(60 BYTE),
  PASS_DATE   VARCHAR2(8 BYTE),
  PUBL_NAME   VARCHAR2(60 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ASSEDETAIL
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ASSEDETAIL CASCADE CONSTRAINTS;

CREATE TABLE TCB_ASSEDETAIL
(
  ASSE_NO       CHAR(11 BYTE)                   NOT NULL,
  DIV_CD        CHAR(1 BYTE)                    NOT NULL,
  REG_ID        VARCHAR2(20 BYTE),
  REG_NAME      VARCHAR2(255 BYTE),
  TOTAL_POINT   NUMBER(4,1),
  RATING_POINT  NUMBER(4,1),
  KIND_CD       CHAR(1 BYTE),
  ASSE_HTML     CLOB,
  REG_DATE      VARCHAR2(14 BYTE),
  STATUS        CHAR(2 BYTE),
  SUB_POINT     NUMBER(4,1),
  ASSE_SUBHTML  CLOB,
  TEMPLATE_CD   CHAR(7 BYTE)
)
LOB (ASSE_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (ASSE_SUBHTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40M
            NEXT             4M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_AUTH
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_AUTH CASCADE CONSTRAINTS;

CREATE TABLE TCB_AUTH
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  AUTH_CD    CHAR(4 BYTE)                       NOT NULL,
  AUTH_NM    VARCHAR2(255 BYTE),
  AUTH_INFO  CLOB,
  ETC        VARCHAR2(255 BYTE),
  REG_DATE   VARCHAR2(14 BYTE),
  REG_ID     VARCHAR2(20 BYTE),
  MOD_DATE   VARCHAR2(14 BYTE),
  MOD_ID     VARCHAR2(20 BYTE),
  STATUS     CHAR(2 BYTE)
)
LOB (AUTH_INFO) STORE AS (
  TABLESPACE TS_DOCU_D
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE TS_DOCU_D
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_AUTH IS '권한정보(리뉴얼)';

COMMENT ON COLUMN TCB_AUTH.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_AUTH.AUTH_CD IS '권한코드';

COMMENT ON COLUMN TCB_AUTH.AUTH_NM IS '권한명';

COMMENT ON COLUMN TCB_AUTH.AUTH_INFO IS '권한정보';

COMMENT ON COLUMN TCB_AUTH.ETC IS '비고';

COMMENT ON COLUMN TCB_AUTH.REG_DATE IS '등록일자';

COMMENT ON COLUMN TCB_AUTH.REG_ID IS '등록자';

COMMENT ON COLUMN TCB_AUTH.MOD_DATE IS '수정일자';

COMMENT ON COLUMN TCB_AUTH.MOD_ID IS '수정자';

COMMENT ON COLUMN TCB_AUTH.STATUS IS '상태';


ALTER TABLE TCB_AUTH_FIELD
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_AUTH_FIELD CASCADE CONSTRAINTS;

CREATE TABLE TCB_AUTH_FIELD
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  AUTH_CD    CHAR(4 BYTE)                       NOT NULL,
  SEQ        NUMBER                             NOT NULL,
  FIELD_SEQ  NUMBER,
  MENU_CD    CHAR(6 BYTE),
  BTN_AUTH   CHAR(2 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_AUTH_FIELD IS '소속부서추가권한';

COMMENT ON COLUMN TCB_AUTH_FIELD.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_AUTH_FIELD.AUTH_CD IS '권한코드';

COMMENT ON COLUMN TCB_AUTH_FIELD.SEQ IS '일련번호';

COMMENT ON COLUMN TCB_AUTH_FIELD.FIELD_SEQ IS '부서코드';

COMMENT ON COLUMN TCB_AUTH_FIELD.MENU_CD IS '메뉴코드';

COMMENT ON COLUMN TCB_AUTH_FIELD.BTN_AUTH IS '기능권한';


ALTER TABLE TCB_AUTH_MENU
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_AUTH_MENU CASCADE CONSTRAINTS;

CREATE TABLE TCB_AUTH_MENU
(
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  AUTH_CD      CHAR(4 BYTE)                     NOT NULL,
  MENU_CD      CHAR(6 BYTE)                     NOT NULL,
  SELECT_AUTH  CHAR(2 BYTE),
  BTN_AUTH     CHAR(2 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_AUTH_MENU IS '권한메뉴정보(리뉴얼)';

COMMENT ON COLUMN TCB_AUTH_MENU.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_AUTH_MENU.AUTH_CD IS '권한코드';

COMMENT ON COLUMN TCB_AUTH_MENU.MENU_CD IS '메뉴코드';

COMMENT ON COLUMN TCB_AUTH_MENU.SELECT_AUTH IS '조회권한';

COMMENT ON COLUMN TCB_AUTH_MENU.BTN_AUTH IS '기능권한';


ALTER TABLE TCB_BID_CHARGE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_CHARGE CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_CHARGE
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  CHARGE_SEQ      NUMBER(38)                    NOT NULL,
  CHARGE_CD       CHAR(2 BYTE)                  NOT NULL,
  DIVISION        VARCHAR2(50 BYTE),
  CHARGE_NAME     VARCHAR2(20 BYTE),
  TEL_NUM         VARCHAR2(20 BYTE),
  POSITION        VARCHAR2(20 BYTE),
  PERSON_SEQ      NUMBER(38),
  USER_ID         VARCHAR2(20 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_EMAIL
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_EMAIL CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_EMAIL
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  EMAIL_SEQ       NUMBER(38)                    NOT NULL,
  SEND_DATE       VARCHAR2(14 BYTE)             NOT NULL,
  RECV_DETE       VARCHAR2(14 BYTE),
  MEMBER_NAME     VARCHAR2(200 BYTE),
  USER_NAME       VARCHAR2(30 BYTE),
  EMAIL           VARCHAR2(255 BYTE),
  STATUS          CHAR(2 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_END_ITEM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_END_ITEM CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_END_ITEM
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  SEQ             NUMBER(38)                    NOT NULL,
  MAKER           VARCHAR2(30 BYTE),
  ITEM_CD         VARCHAR2(20 BYTE),
  ITEM_NAME       VARCHAR2(200 BYTE),
  CUSTOMER_AMT    NUMBER(18),
  SUPPLY_AMT      NUMBER(18),
  ITEM_CNT        NUMBER(10,3),
  TOTAL_AMT       NUMBER(18),
  DISCOUNT_RATE   NUMBER(10,3)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_ESTM_FILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_ESTM_FILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_ESTM_FILE
(
  SEQ             NUMBER(38)                    NOT NULL,
  FILE_NAME       VARCHAR2(200 BYTE),
  DOC_NAME        VARCHAR2(200 BYTE),
  FILE_PATH       VARCHAR2(255 BYTE),
  FILE_EXT        VARCHAR2(20 BYTE),
  FILE_SIZE       NUMBER(38),
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  MEMBER_NO       VARCHAR2(11 BYTE)             NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_FILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_FILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_FILE
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  FILE_DIV_CD     CHAR(2 BYTE)                  NOT NULL,
  SEQ             NUMBER(38)                    NOT NULL,
  FILE_NAME       VARCHAR2(200 BYTE),
  DOC_NAME        VARCHAR2(200 BYTE),
  FILE_PATH       VARCHAR2(255 BYTE),
  FILE_EXT        VARCHAR2(20 BYTE),
  FILE_SIZE       NUMBER(38)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_INFO
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_INFO CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_INFO
(
  USER_NO         VARCHAR2(20 BYTE),
  PROJECT_NAME    VARCHAR2(100 BYTE),
  SRC_CD1         VARCHAR2(9 BYTE),
  SRC_CD2         VARCHAR2(9 BYTE),
  SRC_CD3         VARCHAR2(9 BYTE),
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  CONT1_SDAY      VARCHAR2(8 BYTE),
  CONT1_EDAY      VARCHAR2(8 BYTE),
  CONT2_SDAY      VARCHAR2(8 BYTE),
  CONT2_EDAY      VARCHAR2(8 BYTE),
  CONT3_SDAY      VARCHAR2(8 BYTE),
  CONT3_EDAY      VARCHAR2(8 BYTE),
  REQ_DAY         VARCHAR2(8 BYTE),
  ORDER_DAY       VARCHAR2(8 BYTE),
  MEMBER_NAME     VARCHAR2(200 BYTE),
  MEMBER_NO       VARCHAR2(11 BYTE),
  BID_YN          CHAR(1 BYTE)                  DEFAULT 'Y',
  ETC             VARCHAR2(255 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_ITEM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_ITEM CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_ITEM
(
  ITEM_CD         VARCHAR2(12 BYTE)             NOT NULL,
  LGJ_CD          VARCHAR2(3 BYTE),
  MGJ_CD          VARCHAR2(3 BYTE),
  SGJ_CD          VARCHAR2(3 BYTE),
  DEPTH           NUMBER(38),
  ITEM_NM         VARCHAR2(200 BYTE),
  ITEM_SIZE       VARCHAR2(200 BYTE),
  ITEM_UNIT       VARCHAR2(200 BYTE),
  ITEM_CNT        NUMBER(10,3),
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  MAT_ITEM_CD     VARCHAR2(12 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          16M
            NEXT             1600K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_ITEM_TERM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_ITEM_TERM CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_ITEM_TERM
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  ITEM_CD         VARCHAR2(12 BYTE)             NOT NULL,
  TERM_SEQ        NUMBER(38)                    NOT NULL,
  TERM_GUBUN      VARCHAR2(100 BYTE),
  ITEM_CNT        NUMBER(10,3)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_JOIN_ESTM_FILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_JOIN_ESTM_FILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_JOIN_ESTM_FILE
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER                        NOT NULL,
  MEMBER_NO       VARCHAR2(11 BYTE)             NOT NULL,
  SEQ             NUMBER                        NOT NULL,
  FILE_NAME       VARCHAR2(200 BYTE),
  DOC_NAME        VARCHAR2(200 BYTE),
  FILE_PATH       VARCHAR2(255 BYTE),
  FILE_EXT        VARCHAR2(20 BYTE),
  FILE_SIZE       NUMBER
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_BID_JOIN_ESTM_FILE IS '입찰업체_등록평가제출서류';

COMMENT ON COLUMN TCB_BID_JOIN_ESTM_FILE.MAIN_MEMBER_NO IS '공고회원번호';

COMMENT ON COLUMN TCB_BID_JOIN_ESTM_FILE.BID_NO IS '공고번호';

COMMENT ON COLUMN TCB_BID_JOIN_ESTM_FILE.BID_DEG IS '공고차수';

COMMENT ON COLUMN TCB_BID_JOIN_ESTM_FILE.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_BID_JOIN_ESTM_FILE.SEQ IS '일련번호';

COMMENT ON COLUMN TCB_BID_JOIN_ESTM_FILE.FILE_NAME IS '파일명';

COMMENT ON COLUMN TCB_BID_JOIN_ESTM_FILE.DOC_NAME IS '문서명';

COMMENT ON COLUMN TCB_BID_JOIN_ESTM_FILE.FILE_PATH IS '파일경로';

COMMENT ON COLUMN TCB_BID_JOIN_ESTM_FILE.FILE_EXT IS '파일확장자';

COMMENT ON COLUMN TCB_BID_JOIN_ESTM_FILE.FILE_SIZE IS '파일크기';


ALTER TABLE TCB_BID_JOIN_REQ_FILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_JOIN_REQ_FILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_JOIN_REQ_FILE
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER                        NOT NULL,
  SEQ             NUMBER                        NOT NULL,
  DOC_NAME        VARCHAR2(200 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_BID_JOIN_REQ_FILE IS '등록평가제출서류';

COMMENT ON COLUMN TCB_BID_JOIN_REQ_FILE.MAIN_MEMBER_NO IS '공고회원번호';

COMMENT ON COLUMN TCB_BID_JOIN_REQ_FILE.BID_NO IS '공고번호';

COMMENT ON COLUMN TCB_BID_JOIN_REQ_FILE.BID_DEG IS '공고차수';

COMMENT ON COLUMN TCB_BID_JOIN_REQ_FILE.SEQ IS '일련번호';

COMMENT ON COLUMN TCB_BID_JOIN_REQ_FILE.DOC_NAME IS '문서명';


ALTER TABLE TCB_BID_MULTI_AMT
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_MULTI_AMT CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_MULTI_AMT
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER                        NOT NULL,
  AMT_SEQ         NUMBER                        NOT NULL,
  DISPLAY_SEQ     NUMBER,
  MULTI_AMT       NUMBER(18,2),
  SELECT_CNT      NUMBER
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_BID_PAY
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_PAY CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_PAY
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER                        NOT NULL,
  MEMBER_NO       VARCHAR2(11 BYTE)             NOT NULL,
  BID_NAME        VARCHAR2(255 BYTE),
  PAY_AMOUNT      NUMBER,
  PAY_TYPE        CHAR(2 BYTE),
  ACCEPT_DATE     VARCHAR2(14 BYTE),
  PAY_NUMBER      VARCHAR2(20 BYTE),
  TID             VARCHAR2(30 BYTE),
  RECEIT_TYPE     VARCHAR2(1 BYTE),
  ACCEPT_SEQ      NUMBER,
  ETC             VARCHAR2(255 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_BID_PAY IS '입찰결제내역';

COMMENT ON COLUMN TCB_BID_PAY.MAIN_MEMBER_NO IS '공고회원번호';

COMMENT ON COLUMN TCB_BID_PAY.BID_NO IS '공고번호';

COMMENT ON COLUMN TCB_BID_PAY.BID_DEG IS '차수';

COMMENT ON COLUMN TCB_BID_PAY.MEMBER_NO IS '회원관리번호';

COMMENT ON COLUMN TCB_BID_PAY.BID_NAME IS '입찰공고명';

COMMENT ON COLUMN TCB_BID_PAY.PAY_AMOUNT IS '결제금액';

COMMENT ON COLUMN TCB_BID_PAY.PAY_TYPE IS '결제수단코드';

COMMENT ON COLUMN TCB_BID_PAY.ACCEPT_DATE IS '거래일시';

COMMENT ON COLUMN TCB_BID_PAY.PAY_NUMBER IS '주문번호';

COMMENT ON COLUMN TCB_BID_PAY.TID IS '거래번호';

COMMENT ON COLUMN TCB_BID_PAY.RECEIT_TYPE IS '현금영수증유형';

COMMENT ON COLUMN TCB_BID_PAY.ACCEPT_SEQ IS '거래순번';


ALTER TABLE TCB_BID_SKILL_ESTM_FILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_BID_SKILL_ESTM_FILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_BID_SKILL_ESTM_FILE
(
  MAIN_MEMBER_NO  VARCHAR2(11 BYTE)             NOT NULL,
  BID_NO          CHAR(9 BYTE)                  NOT NULL,
  BID_DEG         NUMBER(38)                    NOT NULL,
  MEMBER_NO       VARCHAR2(11 BYTE)             NOT NULL,
  SEQ             NUMBER(38)                    NOT NULL,
  FILE_NAME       VARCHAR2(200 BYTE),
  DOC_NAME        VARCHAR2(200 BYTE),
  FILE_PATH       VARCHAR2(255 BYTE),
  FILE_EXT        VARCHAR2(20 BYTE),
  FILE_SIZE       NUMBER(38)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CALC_MONTH
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CALC_MONTH CASCADE CONSTRAINTS;

CREATE TABLE TCB_CALC_MONTH
(
  MEMBER_NO        CHAR(11 BYTE)                NOT NULL,
  YYYYMM           CHAR(6 BYTE)                 NOT NULL,
  CALC_PERSON_SEQ  NUMBER                       NOT NULL,
  PAY_TYPE_CD      CHAR(2 BYTE),
  USER_NAME        VARCHAR2(20 BYTE),
  FIELD_SEQ        VARCHAR2(255 BYTE),
  TEL_NUM          VARCHAR2(255 BYTE),
  HP1              VARCHAR2(3 BYTE),
  HP2              VARCHAR2(4 BYTE),
  HP3              VARCHAR2(4 BYTE),
  EMAIL            VARCHAR2(255 BYTE),
  CALC_URL         VARCHAR2(255 BYTE),
  CALC_DATE        VARCHAR2(14 BYTE),
  STATUS           CHAR(2 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_CALC_MONTH IS '월정산정보';

COMMENT ON COLUMN TCB_CALC_MONTH.MEMBER_NO IS '회원관리번호';

COMMENT ON COLUMN TCB_CALC_MONTH.YYYYMM IS '정산년월';

COMMENT ON COLUMN TCB_CALC_MONTH.CALC_PERSON_SEQ IS '담당자일련번호';

COMMENT ON COLUMN TCB_CALC_MONTH.PAY_TYPE_CD IS '요금제';

COMMENT ON COLUMN TCB_CALC_MONTH.USER_NAME IS '담당자명';

COMMENT ON COLUMN TCB_CALC_MONTH.FIELD_SEQ IS '부서일련번호';

COMMENT ON COLUMN TCB_CALC_MONTH.TEL_NUM IS '전화번호';

COMMENT ON COLUMN TCB_CALC_MONTH.HP1 IS '휴대폰1';

COMMENT ON COLUMN TCB_CALC_MONTH.HP2 IS '휴대폰2';

COMMENT ON COLUMN TCB_CALC_MONTH.HP3 IS '휴대폰3';

COMMENT ON COLUMN TCB_CALC_MONTH.EMAIL IS '이메일';

COMMENT ON COLUMN TCB_CALC_MONTH.CALC_URL IS '정산URL';

COMMENT ON COLUMN TCB_CALC_MONTH.CALC_DATE IS '정산일';

COMMENT ON COLUMN TCB_CALC_MONTH.STATUS IS '상태';


ALTER TABLE TCB_CALC_PERSON
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CALC_PERSON CASCADE CONSTRAINTS;

CREATE TABLE TCB_CALC_PERSON
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  SEQ        NUMBER                             NOT NULL,
  USER_NAME  VARCHAR2(100 BYTE),
  FIELD_SEQ  VARCHAR2(255 BYTE),
  TEL_NUM    VARCHAR2(255 BYTE),
  HP1        VARCHAR2(3 BYTE),
  HP2        VARCHAR2(4 BYTE),
  HP3        VARCHAR2(4 BYTE),
  EMAIL      VARCHAR2(255 BYTE),
  STATUS     CHAR(2 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_CALC_PERSON IS '정산담당자정보';

COMMENT ON COLUMN TCB_CALC_PERSON.MEMBER_NO IS '회원관리번호';

COMMENT ON COLUMN TCB_CALC_PERSON.SEQ IS '일련번호';

COMMENT ON COLUMN TCB_CALC_PERSON.USER_NAME IS '담당자명';

COMMENT ON COLUMN TCB_CALC_PERSON.FIELD_SEQ IS '부서일련번호';

COMMENT ON COLUMN TCB_CALC_PERSON.TEL_NUM IS '전화번호';

COMMENT ON COLUMN TCB_CALC_PERSON.HP1 IS '휴대폰1';

COMMENT ON COLUMN TCB_CALC_PERSON.HP2 IS '휴대폰2';

COMMENT ON COLUMN TCB_CALC_PERSON.HP3 IS '휴대폰3';

COMMENT ON COLUMN TCB_CALC_PERSON.EMAIL IS '이메일';

COMMENT ON COLUMN TCB_CALC_PERSON.STATUS IS '상태';


ALTER TABLE TCB_CFILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CFILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_CFILE
(
  CONT_NO     CHAR(11 BYTE)                     NOT NULL,
  CONT_CHASU  NUMBER(38)                        NOT NULL,
  CFILE_SEQ   NUMBER(38)                        NOT NULL,
  DOC_NAME    VARCHAR2(255 BYTE)                NOT NULL,
  FILE_NAME   VARCHAR2(255 BYTE),
  FILE_PATH   VARCHAR2(255 BYTE),
  FILE_EXT    VARCHAR2(5 BYTE),
  FILE_SIZE   NUMBER(38),
  AUTO_YN     CHAR(1 BYTE),
  AUTO_TYPE   VARCHAR2(20 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40M
            NEXT             4M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CLIENT
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CLIENT CASCADE CONSTRAINTS;

CREATE TABLE TCB_CLIENT
(
  MEMBER_NO        CHAR(11 BYTE)                NOT NULL,
  CLIENT_SEQ       NUMBER(38)                   NOT NULL,
  CLIENT_NO        CHAR(11 BYTE)                NOT NULL,
  STATUS           VARCHAR2(2 BYTE),
  REASON           CLOB,
  REASON_DATE      VARCHAR2(14 BYTE),
  REASON_ID        VARCHAR2(20 BYTE),
  TEMP_YN          CHAR(1 BYTE),
  CLIENT_TYPE      VARCHAR2(20 BYTE),
  CLIENT_REG_CD    VARCHAR2(1 BYTE),
  CLIENT_REG_DATE  VARCHAR2(14 BYTE)
)
LOB (REASON) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CLIENT_DETAIL
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CLIENT_DETAIL CASCADE CONSTRAINTS;

CREATE TABLE TCB_CLIENT_DETAIL
(
  PERSON_SEQ         NUMBER(38)                 NOT NULL,
  MEMBER_NO          CHAR(11 BYTE)              NOT NULL,
  CLIENT_SEQ         NUMBER(38)                 NOT NULL,
  CLIENT_DETAIL_SEQ  NUMBER(38)                 NOT NULL,
  CUST_DETAIL_CODE   VARCHAR2(255 BYTE),
  CUST_DETAIL_NAME   VARCHAR2(255 BYTE),
  CUST_PERSON_SEQ    NUMBER(38),
  STATUS             VARCHAR2(2 BYTE),
  REASON             VARCHAR2(255 BYTE),
  REASON_DATE        VARCHAR2(14 BYTE),
  REASON_ID          VARCHAR2(20 BYTE),
  TEMP_YN            CHAR(1 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CLIENT_RFILE_TEMPLATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CLIENT_RFILE_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_CLIENT_RFILE_TEMPLATE
(
  RFILE_SEQ         NUMBER                      NOT NULL,
  MEMBER_NO         CHAR(11 BYTE)               NOT NULL,
  DOC_NAME          VARCHAR2(255 BYTE)          NOT NULL,
  ATTCH_YN          CHAR(1 BYTE),
  ALLOW_EXT         VARCHAR2(100 BYTE),
  SAMPLE_FILE_PATH  VARCHAR2(255 BYTE),
  SAMPLE_FILE_NAME  VARCHAR2(255 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_CLIENT_RFILE_TEMPLATE IS '거래처 등록 구비서류';

COMMENT ON COLUMN TCB_CLIENT_RFILE_TEMPLATE.RFILE_SEQ IS '일련번호';

COMMENT ON COLUMN TCB_CLIENT_RFILE_TEMPLATE.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_CLIENT_RFILE_TEMPLATE.DOC_NAME IS '문서명';

COMMENT ON COLUMN TCB_CLIENT_RFILE_TEMPLATE.ATTCH_YN IS '필수여부';

COMMENT ON COLUMN TCB_CLIENT_RFILE_TEMPLATE.ALLOW_EXT IS '첨부파일제한';


ALTER TABLE TCB_CONT_EMAIL
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONT_EMAIL CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONT_EMAIL
(
  CONT_NO      CHAR(11 BYTE)                    NOT NULL,
  CONT_CHASU   NUMBER(38)                       NOT NULL,
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  EMAIL_SEQ    NUMBER(38)                       NOT NULL,
  SEND_DATE    VARCHAR2(14 BYTE)                NOT NULL,
  RECV_DETE    VARCHAR2(14 BYTE),
  MEMBER_NAME  VARCHAR2(200 BYTE),
  USER_NAME    VARCHAR2(30 BYTE),
  EMAIL        VARCHAR2(255 BYTE),
  STATUS       CHAR(2 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40M
            NEXT             4M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_CONT_SIGN_TEMPLATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CONT_SIGN_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_CONT_SIGN_TEMPLATE
(
  TEMPLATE_CD  CHAR(7 BYTE)                     NOT NULL,
  SIGN_SEQ     NUMBER(10)                       NOT NULL,
  SIGNER_NAME  VARCHAR2(50 BYTE)                NOT NULL,
  SIGNER_MAX   NUMBER(10),
  MEMBER_TYPE  CHAR(2 BYTE),
  CUST_TYPE    CHAR(2 BYTE),
  PAY_YN       CHAR(1 BYTE),
  SPOP_TYPE    VARCHAR2(3 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_DEBT
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_DEBT CASCADE CONSTRAINTS;

CREATE TABLE TCB_DEBT
(
  DEBT_NO        CHAR(12 BYTE)                  NOT NULL,
  GROUP_NO       CHAR(8 BYTE)                   NOT NULL,
  MEMBER_NO      CHAR(11 BYTE),
  DEBT_DATE      VARCHAR2(8 BYTE),
  AGENT_CD       VARCHAR2(255 BYTE),
  AGENT_NAME     VARCHAR2(255 BYTE),
  DEBT_CASH      NUMBER(18),
  DEBT_BILL      NUMBER(18),
  DEBT_SUM       NUMBER(18),
  TEMPLATE_CD    CHAR(7 BYTE),
  TEMPLATE_NAME  VARCHAR2(255 BYTE),
  DEBT_HTML      CLOB,
  ORG_DEBT_HTML  CLOB,
  SIGN_HASH      CLOB,
  SIGN_YN        CHAR(1 BYTE),
  SEND_DATE      VARCHAR2(14 BYTE),
  PROC_END_DATE  VARCHAR2(14 BYTE),
  SALES_NAME     VARCHAR2(255 BYTE),
  SALES_EMAIL    VARCHAR2(255 BYTE),
  REG_DATE       VARCHAR2(14 BYTE),
  REG_ID         VARCHAR2(20 BYTE),
  MOD_DATE       VARCHAR2(14 BYTE),
  MOD_ID         VARCHAR2(20 BYTE),
  STATUS         CHAR(2 BYTE)
)
LOB (DEBT_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (ORG_DEBT_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (SIGN_HASH) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_DEBT_CFILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_DEBT_CFILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_DEBT_CFILE
(
  DEBT_NO    CHAR(12 BYTE)                      NOT NULL,
  CFILE_SEQ  NUMBER(38)                         NOT NULL,
  AUTO_YN    CHAR(1 BYTE),
  DOC_NAME   VARCHAR2(255 BYTE),
  FILE_PATH  VARCHAR2(255 BYTE),
  FILE_NAME  VARCHAR2(255 BYTE),
  FILE_SIZE  NUMBER(38),
  FILE_EXT   VARCHAR2(100 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_DEBT_CUST
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_DEBT_CUST CASCADE CONSTRAINTS;

CREATE TABLE TCB_DEBT_CUST
(
  DEBT_NO          CHAR(12 BYTE)                NOT NULL,
  MEMBER_NO        CHAR(11 BYTE)                NOT NULL,
  CUST_GUBUN       CHAR(2 BYTE),
  MEMBER_GUBUN     CHAR(2 BYTE),
  VENDCD           VARCHAR2(10 BYTE),
  MEMBER_NAME      VARCHAR2(200 BYTE),
  BOSS_NAME        VARCHAR2(200 BYTE),
  BOSS_BIRTH_DATE  VARCHAR2(8 BYTE),
  ADDRESS          VARCHAR2(255 BYTE),
  TEL_NUM          VARCHAR2(100 BYTE),
  USER_ID          VARCHAR2(20 BYTE),
  USER_NAME        VARCHAR2(30 BYTE),
  HP1              VARCHAR2(3 BYTE),
  HP2              VARCHAR2(4 BYTE),
  HP3              VARCHAR2(4 BYTE),
  EMAIL            VARCHAR2(255 BYTE),
  VIEW_DATE        VARCHAR2(14 BYTE),
  SIGN_GUBUN       CHAR(2 BYTE),
  SIGN_DATE        VARCHAR2(18 BYTE),
  SIGN_DN          VARCHAR2(255 BYTE),
  SIGN_DATA        CLOB
)
LOB (SIGN_DATA) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_DEBT_PROC
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_DEBT_PROC CASCADE CONSTRAINTS;

CREATE TABLE TCB_DEBT_PROC
(
  DEBT_NO      CHAR(12 BYTE)                    NOT NULL,
  PROC_SEQ     NUMBER(38)                       NOT NULL,
  MEMBER_NO    CHAR(11 BYTE),
  USER_ID      VARCHAR2(20 BYTE),
  PROC_DATE    VARCHAR2(14 BYTE),
  PROC_STATUS  VARCHAR2(2 BYTE),
  SAYOU        CLOB,
  STATUS       CHAR(2 BYTE)
)
LOB (SAYOU) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_FIELD
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_FIELD CASCADE CONSTRAINTS;

CREATE TABLE TCB_FIELD
(
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  FIELD_SEQ    NUMBER(38)                       NOT NULL,
  FIELD_NAME   VARCHAR2(200 BYTE),
  POST_CODE    CHAR(6 BYTE),
  ADDRESS      VARCHAR2(200 BYTE),
  TELNUM       VARCHAR2(15 BYTE),
  BOSS_NAME    VARCHAR2(200 BYTE),
  USE_YN       CHAR(1 BYTE),
  STATUS       NUMBER(38),
  FIELD_GUBUN  CHAR(2 BYTE),
  P_FIELD_SEQ  NUMBER
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            NEXT             40K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_FIELDPERSON
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_FIELDPERSON CASCADE CONSTRAINTS;

CREATE TABLE TCB_FIELDPERSON
(
  MEMBER_NO   CHAR(11 BYTE)                     NOT NULL,
  PERSON_SEQ  NUMBER(38)                        NOT NULL,
  FIELD_SEQ   NUMBER(38)                        NOT NULL
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ITEM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ITEM CASCADE CONSTRAINTS;

CREATE TABLE TCB_ITEM
(
  MEMBER_NO            CHAR(11 BYTE)            NOT NULL,
  DOC_SEQ              NUMBER                   NOT NULL,
  ITEM_NO              CHAR(10 BYTE)            NOT NULL,
  ITEM_SEQ             NUMBER                   NOT NULL,
  ITEM_NAME            VARCHAR2(255 BYTE),
  SUPP_COM_CD          VARCHAR2(11 BYTE),
  SUPP_COM             VARCHAR2(255 BYTE),
  CONT_NAME            VARCHAR2(255 BYTE),
  STATUS               VARCHAR2(10 BYTE),
  PURCHASE_ROUTE       VARCHAR2(10 BYTE),
  SUPP_VAT             VARCHAR2(10 BYTE),
  ITEM_AMOUNT          NUMBER,
  CONT_SDATE           VARCHAR2(8 BYTE),
  CONT_EDATE           VARCHAR2(8 BYTE),
  CONSUMER_PRICE       NUMBER,
  CONSUMER_PRICE_UNIT  NUMBER,
  SUPPLY_PRICE         NUMBER,
  SUPPLY_AMT           NUMBER,
  DC_RATIO             NUMBER(10,3),
  ALREADY_PRICE        NUMBER,
  ALREADY_PRICE_RATIO  NUMBER(10,3),
  REG_DATE             VARCHAR2(14 BYTE),
  REG_ID               VARCHAR2(20 BYTE),
  MEMO                 VARCHAR2(255 BYTE),
  DETAIL_MEMO          VARCHAR2(255 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_ITEM IS '구매품목정보';

COMMENT ON COLUMN TCB_ITEM.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_ITEM.DOC_SEQ IS '결재시퀀스';

COMMENT ON COLUMN TCB_ITEM.ITEM_NO IS '품목코드번호';

COMMENT ON COLUMN TCB_ITEM.ITEM_SEQ IS '품목시퀀스';

COMMENT ON COLUMN TCB_ITEM.ITEM_NAME IS '품목명';

COMMENT ON COLUMN TCB_ITEM.SUPP_COM_CD IS '공급업체회원번호';

COMMENT ON COLUMN TCB_ITEM.SUPP_COM IS '공급업체명';

COMMENT ON COLUMN TCB_ITEM.CONT_NAME IS '계약명';

COMMENT ON COLUMN TCB_ITEM.STATUS IS '품목상태';

COMMENT ON COLUMN TCB_ITEM.PURCHASE_ROUTE IS '구매방법';

COMMENT ON COLUMN TCB_ITEM.SUPP_VAT IS '부가세';

COMMENT ON COLUMN TCB_ITEM.ITEM_AMOUNT IS '수량';

COMMENT ON COLUMN TCB_ITEM.CONT_SDATE IS '계약기간시작';

COMMENT ON COLUMN TCB_ITEM.CONT_EDATE IS '계약기간종료';

COMMENT ON COLUMN TCB_ITEM.CONSUMER_PRICE IS '소비자가';

COMMENT ON COLUMN TCB_ITEM.CONSUMER_PRICE_UNIT IS '소비자단가';

COMMENT ON COLUMN TCB_ITEM.SUPPLY_PRICE IS '공급가';

COMMENT ON COLUMN TCB_ITEM.SUPPLY_AMT IS '공급단가';

COMMENT ON COLUMN TCB_ITEM.DC_RATIO IS 'DC율';

COMMENT ON COLUMN TCB_ITEM.ALREADY_PRICE IS '예가';

COMMENT ON COLUMN TCB_ITEM.ALREADY_PRICE_RATIO IS '예가대비 절감율';

COMMENT ON COLUMN TCB_ITEM.REG_DATE IS '등록일시';

COMMENT ON COLUMN TCB_ITEM.REG_ID IS '등록자';

COMMENT ON COLUMN TCB_ITEM.MEMO IS '메모';

COMMENT ON COLUMN TCB_ITEM.DETAIL_MEMO IS '상세사항';


ALTER TABLE TCB_ORDER_CUST
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ORDER_CUST CASCADE CONSTRAINTS;

CREATE TABLE TCB_ORDER_CUST
(
  ORDER_NO     CHAR(14 BYTE)                    NOT NULL,
  MEMBER_NO    CHAR(11 BYTE)                    NOT NULL,
  CUST_TYPE    CHAR(2 BYTE),
  MEMBER_NAME  VARCHAR2(200 BYTE),
  VENDCD       VARCHAR2(10 BYTE),
  BOSS_NAME    VARCHAR2(200 BYTE),
  ADDRESS      VARCHAR2(255 BYTE),
  PERSON_SEQ   NUMBER(38),
  USER_NAME    VARCHAR2(30 BYTE),
  TEL_NUM      VARCHAR2(15 BYTE),
  HP1          VARCHAR2(3 BYTE),
  HP2          VARCHAR2(4 BYTE),
  HP3          VARCHAR2(4 BYTE),
  EMAIL        VARCHAR2(255 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ORDER_FILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ORDER_FILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_ORDER_FILE
(
  ORDER_NO   CHAR(14 BYTE)                      NOT NULL,
  FILE_SEQ   NUMBER(38)                         NOT NULL,
  DOC_NAME   VARCHAR2(255 BYTE),
  FILE_PATH  VARCHAR2(255 BYTE),
  FILE_NAME  VARCHAR2(255 BYTE),
  FILE_EXT   VARCHAR2(20 BYTE),
  FILE_SIZE  NUMBER(38)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_ORDER_ITEM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_ORDER_ITEM CASCADE CONSTRAINTS;

CREATE TABLE TCB_ORDER_ITEM
(
  ORDER_NO    CHAR(14 BYTE)                     NOT NULL,
  ITEM_SEQ    NUMBER(38)                        NOT NULL,
  ITEM_NAME   VARCHAR2(255 BYTE),
  STANDARD    VARCHAR2(255 BYTE),
  UNIT        VARCHAR2(255 BYTE),
  QTY         NUMBER(18,2),
  UNIT_COST   NUMBER(18,2),
  COST_SUM    NUMBER(18,2),
  DELI_DATE   VARCHAR2(14 BYTE),
  DELI_PLACE  VARCHAR2(255 BYTE),
  ITEM_CD     VARCHAR2(10 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_PAY_DEBT
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_PAY_DEBT CASCADE CONSTRAINTS;

CREATE TABLE TCB_PAY_DEBT
(
  DEBT_NO     CHAR(12 BYTE)                     NOT NULL,
  PAY_AMOUNT  NUMBER(18),
  REG_DATE    VARCHAR2(14 BYTE),
  MOD_DATE    VARCHAR2(14 BYTE),
  STATUS      CHAR(2 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_PROOF_SIGN_TEMPLATE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_PROOF_SIGN_TEMPLATE CASCADE CONSTRAINTS;

CREATE TABLE TCB_PROOF_SIGN_TEMPLATE
(
  TEMPLATE_CD  CHAR(7 BYTE)                     NOT NULL,
  SIGN_SEQ     NUMBER(38)                       NOT NULL,
  SIGNER_NAME  VARCHAR2(255 BYTE),
  CUST_GUBUN   CHAR(2 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_PROOF_SIGN_TEMPLATE IS '실적증명서식_업체관계정보';

COMMENT ON COLUMN TCB_PROOF_SIGN_TEMPLATE.TEMPLATE_CD IS '서식코드';

COMMENT ON COLUMN TCB_PROOF_SIGN_TEMPLATE.SIGN_SEQ IS '서명일련번호';

COMMENT ON COLUMN TCB_PROOF_SIGN_TEMPLATE.SIGNER_NAME IS '서명관계명';

COMMENT ON COLUMN TCB_PROOF_SIGN_TEMPLATE.CUST_GUBUN IS '업체구분';


ALTER TABLE TCB_RECRUIT_CLIENT
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_RECRUIT_CLIENT CASCADE CONSTRAINTS;

CREATE TABLE TCB_RECRUIT_CLIENT
(
  MEMBER_NO      CHAR(11 BYTE)                  NOT NULL,
  SEQ            NUMBER(38)                     NOT NULL,
  VENDCD         CHAR(10 BYTE)                  NOT NULL,
  CLIENT_SEQ     NUMBER(38)                     NOT NULL,
  DELIVERY_YEAR  CHAR(4 BYTE),
  CLIENT_NAME    VARCHAR2(255 BYTE),
  ETC            VARCHAR2(255 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_RECRUIT_CUST
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_RECRUIT_CUST CASCADE CONSTRAINTS;

CREATE TABLE TCB_RECRUIT_CUST
(
  MEMBER_NO       CHAR(11 BYTE)                 NOT NULL,
  NOTI_SEQ        NUMBER(38)                    NOT NULL,
  CUST_SEQ        NUMBER(38)                    NOT NULL,
  CLIENT_NO       CHAR(11 BYTE),
  VENDCD          CHAR(10 BYTE),
  MEMBER_NAME     VARCHAR2(100 BYTE),
  BOSS_NAME       VARCHAR2(100 BYTE),
  USER_NAME       CHAR(18 BYTE),
  HP1             VARCHAR2(3 BYTE),
  HP2             VARCHAR2(4 BYTE),
  HP3             VARCHAR2(4 BYTE),
  EMAIL           VARCHAR2(255 BYTE),
  SRC_CD          VARCHAR2(12 BYTE),
  SRC_NM          VARCHAR2(255 BYTE),
  REQ_HTML        CLOB,
  EVALUATE_HTML   CLOB,
  TOT_POINT       NUMBER(18,2),
  MOD_REQ_DATE    VARCHAR2(14 BYTE),
  MOD_REQ_ID      VARCHAR2(20 BYTE),
  MOD_REQ_REASON  CLOB,
  EVALUATE_ETC    CLOB,
  SUCC_YN         CHAR(1 BYTE),
  REG_DATE        VARCHAR2(14 BYTE),
  REG_ID          VARCHAR2(20 BYTE),
  MOD_DATE        VARCHAR2(14 BYTE),
  MOD_ID          VARCHAR2(20 BYTE),
  STATUS          CHAR(2 BYTE)
)
LOB (REQ_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (EVALUATE_HTML) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (MOD_REQ_REASON) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
LOB (EVALUATE_ETC) STORE AS (
  TABLESPACE USERS
  ENABLE       STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
  INDEX       (
        TABLESPACE USERS
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   ))
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                 ))
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          4M
            NEXT             400K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


ALTER TABLE TCB_RECRUIT_ITEM
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_RECRUIT_ITEM CASCADE CONSTRAINTS;

CREATE TABLE TCB_RECRUIT_ITEM
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  SEQ        NUMBER(38)                         NOT NULL,
  VENDCD     CHAR(10 BYTE)                      NOT NULL,
  ITEM_SEQ   NUMBER(38)                         NOT NULL,
  ITEM_NAME  VARCHAR2(255 BYTE),
  ETC        VARCHAR2(255 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE INDEX FK_TCB_BID_EMAIL ON TCB_BID_EMAIL
(MAIN_MEMBER_NO, BID_NO, BID_DEG)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_APPLY_CAREER ON TCB_APPLY_CAREER
(APPLY_NO, CAREER_SEQ)
LOGGING
TABLESPACE TS_DOCU_I
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_APPLY_EDU ON TCB_APPLY_EDU
(APPLY_NO, EDU_SEQ)
LOGGING
TABLESPACE TS_DOCU_I
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_APPLY_FILE ON TCB_APPLY_FILE
(APPLY_NO, FILE_SEQ)
LOGGING
TABLESPACE TS_DOCU_I
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_APPLY_LICENSE ON TCB_APPLY_LICENSE
(APPLY_NO, LICEN_SEQ)
LOGGING
TABLESPACE TS_DOCU_I
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_AUTH ON TCB_AUTH
(MEMBER_NO, AUTH_CD)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_AUTH_FIELD ON TCB_AUTH_FIELD
(MEMBER_NO, AUTH_CD, SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_AUTH_MENU ON TCB_AUTH_MENU
(MEMBER_NO, AUTH_CD, MENU_CD)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_BID_EMAIL ON TCB_BID_EMAIL
(MAIN_MEMBER_NO, BID_NO, BID_DEG, EMAIL_SEQ)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_BID_JOIN_ESTM_FILE ON TCB_BID_JOIN_ESTM_FILE
(MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_BID_JOIN_REQ_FILE ON TCB_BID_JOIN_REQ_FILE
(MAIN_MEMBER_NO, BID_NO, BID_DEG, SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_BID_PAY ON TCB_BID_PAY
(MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_CALC_MONTH ON TCB_CALC_MONTH
(MEMBER_NO, YYYYMM, CALC_PERSON_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_CALC_PERSON ON TCB_CALC_PERSON
(MEMBER_NO, SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_ITEM ON TCB_ITEM
(MEMBER_NO, DOC_SEQ, ITEM_NO, ITEM_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX PK_TCB_PROOF_SIGN_TEMPLATE ON TCB_PROOF_SIGN_TEMPLATE
(TEMPLATE_CD, SIGN_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX SYS_C ON TCB_CLIENT_RFILE_TEMPLATE
(RFILE_SEQ, MEMBER_NO)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_ASSEDETAIL_IDX ON TCB_ASSEDETAIL
(ASSE_NO, DIV_CD)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_CONT_SIGN_TEMPLATE_PK ON TCB_CONT_SIGN_TEMPLATE
(TEMPLATE_CD, SIGN_SEQ)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_ORDER_CUST_IDX ON TCB_ORDER_CUST
(ORDER_NO, MEMBER_NO)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_ORDER_FILE_IDX ON TCB_ORDER_FILE
(ORDER_NO, FILE_SEQ)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_ORDER_ITEM_IDX ON TCB_ORDER_ITEM
(ORDER_NO, ITEM_SEQ)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_RECRUIT_CLIENT_IDX ON TCB_RECRUIT_CLIENT
(MEMBER_NO, SEQ, VENDCD, CLIENT_SEQ)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE UNIQUE INDEX TCB_RECRUIT_ITEM_IDX ON TCB_RECRUIT_ITEM
(MEMBER_NO, SEQ, VENDCD, ITEM_SEQ)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE TCB_CLIENT_RFILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_CLIENT_RFILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_CLIENT_RFILE
(
  MEMBER_NO  CHAR(11 BYTE)                      NOT NULL,
  RFILE_SEQ  NUMBER                             NOT NULL,
  CLIENT_NO  CHAR(12 BYTE)                      NOT NULL,
  FILE_PATH  VARCHAR2(255 BYTE),
  FILE_NAME  VARCHAR2(255 BYTE),
  FILE_EXT   VARCHAR2(5 BYTE),
  FILE_SIZE  NUMBER,
  REG_GUBUN  VARCHAR2(2 BYTE)
)
TABLESPACE TS_DOCU_D
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE TCB_CLIENT_RFILE IS '거래처 등록 구비서류';

COMMENT ON COLUMN TCB_CLIENT_RFILE.MEMBER_NO IS '회원번호';

COMMENT ON COLUMN TCB_CLIENT_RFILE.RFILE_SEQ IS '일련번호';

COMMENT ON COLUMN TCB_CLIENT_RFILE.CLIENT_NO IS '거래처_회원번호';

COMMENT ON COLUMN TCB_CLIENT_RFILE.FILE_PATH IS '파일경로';

COMMENT ON COLUMN TCB_CLIENT_RFILE.FILE_NAME IS '파일명';

COMMENT ON COLUMN TCB_CLIENT_RFILE.FILE_EXT IS '파일확장자';

COMMENT ON COLUMN TCB_CLIENT_RFILE.FILE_SIZE IS '파일사이즈';

COMMENT ON COLUMN TCB_CLIENT_RFILE.REG_GUBUN IS '등록구분';


ALTER TABLE TCB_DEBT_PFILE
 DROP PRIMARY KEY CASCADE;

DROP TABLE TCB_DEBT_PFILE CASCADE CONSTRAINTS;

CREATE TABLE TCB_DEBT_PFILE
(
  DEBT_NO    CHAR(12 BYTE)                      NOT NULL,
  PROC_SEQ   NUMBER(38)                         NOT NULL,
  PFILE_SEQ  NUMBER(38)                         NOT NULL,
  DOC_NAME   VARCHAR2(255 BYTE),
  FILE_PATH  VARCHAR2(255 BYTE),
  FILE_NAME  VARCHAR2(255 BYTE),
  FILE_SIZE  NUMBER(38),
  FILE_EXT   VARCHAR2(100 BYTE)
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          40K
            NEXT             8K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE UNIQUE INDEX SYS_C2 ON TCB_CLIENT_RFILE
(MEMBER_NO, RFILE_SEQ, CLIENT_NO)
LOGGING
TABLESPACE TS_DOCU_D
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE TCB_AGREE_TEMPLATE ADD (
  PRIMARY KEY
  (TEMPLATE_CD, AGREE_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_AGREE_USER ADD (
  PRIMARY KEY
  (TEMPLATE_CD, AGREE_SEQ, USER_ID)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_APPLY_NOTI ADD (
  CONSTRAINT PK_TCB_APPLY_NOTI
  PRIMARY KEY
  (MEMBER_NO, NOTI_NO)
  USING INDEX PK_TCB_APPLY_NOTI);

ALTER TABLE TCB_APPLY_PERSON ADD (
  CONSTRAINT PK_TCB_APPLY_PERSON
  PRIMARY KEY
  (APPLY_NO)
  USING INDEX PK_TCB_APPLY_PERSON);

ALTER TABLE TCB_APPLY_TEMPLATE ADD (
  PRIMARY KEY
  (APPLY_TEMP_CD, TEMPLATE_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_ASSEMASTER ADD (
  CONSTRAINT TCB_ASSEMASTER_IDX
  PRIMARY KEY
  (ASSE_NO)
  USING INDEX TCB_ASSEMASTER_IDX);

ALTER TABLE TCB_ASSE_TEMPLATE ADD (
  CONSTRAINT TCB_ASSE_TEMPLATE_IDX
  PRIMARY KEY
  (TEMPLATE_CD)
  USING INDEX TCB_ASSE_TEMPLATE_IDX);

ALTER TABLE TCB_ATT_CFILE ADD (
  PRIMARY KEY
  (TEMPLATE_CD, MEMBER_NO, FILE_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BANK_CERT_LOG ADD (
  CONSTRAINT PK_TCB_BANK_CERT_LOG
  PRIMARY KEY
  (MESSAGE_NO, REQ_GUBUN)
  USING INDEX PK_TCB_BANK_CERT_LOG);

ALTER TABLE TCB_BANNER_LOG ADD (
  CONSTRAINT IDX_TCB_BANNER_LOG_P
  PRIMARY KEY
  (LOG_SEQ)
  USING INDEX IDX_TCB_BANNER_LOG_P);

ALTER TABLE TCB_BATCH_TEMPLATE ADD (
  CONSTRAINT PK_TCB_BATCH_TEMPLATE
  PRIMARY KEY
  (TEMPLATE_CD, MEMBER_NO, B_SEQ)
  USING INDEX PK_TCB_BATCH_TEMPLATE);

ALTER TABLE TCB_BATCH_URL ADD (
  CONSTRAINT TCB_BATCH_URL_PK
  PRIMARY KEY
  (MEMBER_NO, BATCH_SEQ)
  USING INDEX TCB_BATCH_URL_PK);

ALTER TABLE TCB_BID_CONF ADD (
  CONSTRAINT PK_TCB_BID_CONF
  PRIMARY KEY
  (MEMBER_NO, CONF_GUBUN)
  USING INDEX PK_TCB_BID_CONF);

ALTER TABLE TCB_BID_ITEM_FORM_DEFAULT ADD (
  PRIMARY KEY
  (MEMBER_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_MASTER ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_MULTI_INFO ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_REQ_FILE ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_SHARE ADD (
  CONSTRAINT PK_TCB_BID_SHARE
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, SEQ)
  USING INDEX PK_TCB_BID_SHARE);

ALTER TABLE TCB_BID_SIDAM_SUPP ADD (
  CONSTRAINT TCB_BID_SIDAM_SUPP_PK
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, SIDAM_SEQ)
  USING INDEX TCB_BID_SIDAM_SUPP_PK);

ALTER TABLE TCB_BID_SIDAM_SUPPITEM ADD (
  CONSTRAINT TCB_BID_SIDAM_SUPPITEM_PK
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, SIDAM_SEQ, ITEM_CD)
  USING INDEX TCB_BID_SIDAM_SUPPITEM_PK);

ALTER TABLE TCB_BID_SKILL_REQ_FILE ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_SUPP ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_SUPPITEM ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, ITEM_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_SUPPITEM_TERM ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, ITEM_CD, TERM_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_SUPP_ORGITEM ADD (
  CONSTRAINT TCB_BID_SUPP_ORGITEM_IDX
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, ITEM_CD)
  USING INDEX TCB_BID_SUPP_ORGITEM_IDX);

ALTER TABLE TCB_BID_SUPP_REV ADD (
  CONSTRAINT PK_TCB_BID_SUPP_REV
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, REV_SEQ)
  USING INDEX PK_TCB_BID_SUPP_REV);

ALTER TABLE TCB_BID_SUPP_SIGN_DOC ADD (
  CONSTRAINT PK_TCB_BID_SUPP_SIGN_DOC
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, DOC_TYPE)
  USING INDEX PK_TCB_BID_SUPP_SIGN_DOC);

ALTER TABLE TCB_BID_SUPP_SUB ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_SUPP_SUCCPAY ADD (
  CONSTRAINT PK_TCB_BID_SUPP_SUCCPAY
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO)
  USING INDEX PK_TCB_BID_SUPP_SUCCPAY);

ALTER TABLE TCB_BOARD ADD (
  PRIMARY KEY
  (CATEGORY, BOARD_ID)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CAR ADD (
  PRIMARY KEY
  (MEMBER_NO, SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CERT_ADD ADD (
  PRIMARY KEY
  (MEMBER_NO, CERT_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CLIENT_ITEM ADD (
  CONSTRAINT TCB_CLIENT_ITEM_IDX1
  PRIMARY KEY
  (MEMBER_NO, CLIENT_NO, SEQ)
  USING INDEX TCB_CLIENT_ITEM_IDX1);

ALTER TABLE TCB_CLIENT_TECH ADD (
  CONSTRAINT TCB_CLIENT_TECH_IDX1
  PRIMARY KEY
  (MEMBER_NO, CLIENT_NO, SEQ)
  USING INDEX TCB_CLIENT_TECH_IDX1);

ALTER TABLE TCB_CNTC_BIZ ADD (
  CONSTRAINT TCB_CNTC_BIZ_PK
  PRIMARY KEY
  (VENDCD)
  USING INDEX TCB_CNTC_BIZ_PK);

ALTER TABLE TCB_COMCODE ADD (
  CONSTRAINT XPKTCB_COMCODE
  PRIMARY KEY
  (CCODE, CODE)
  USING INDEX XPKTCB_COMCODE);

ALTER TABLE TCB_CONTMASTER ADD (
  PRIMARY KEY
  (CONT_NO, CONT_CHASU)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CONT_ADD ADD (
  CONSTRAINT PK_TCB_CONT_ADD
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, SEQ)
  USING INDEX PK_TCB_CONT_ADD);

ALTER TABLE TCB_CONT_AGREE ADD (
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, AGREE_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CONT_LOG ADD (
  CONSTRAINT PK_TCB_CONT_LOG
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, LOG_SEQ)
  USING INDEX PK_TCB_CONT_LOG);

ALTER TABLE TCB_CONT_RESIN ADD (
  CONSTRAINT PK_TCB_CONT_RESIN
  PRIMARY KEY
  (CONT_NO)
  USING INDEX PK_TCB_CONT_RESIN);

ALTER TABLE TCB_CONT_SIGN ADD (
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, SIGN_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CONT_SUB ADD (
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, SUB_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CONT_TEMPLATE ADD (
  CONSTRAINT TCB_CONT_TEMPLATE_PK
  PRIMARY KEY
  (TEMPLATE_CD)
  USING INDEX TCB_CONT_TEMPLATE_PK);

ALTER TABLE TCB_CONT_TEMPLATE_ADD ADD (
  CONSTRAINT PK_TCB_CONT_TEMPLATE_ADD
  PRIMARY KEY
  (TEMPLATE_CD, SEQ)
  USING INDEX PK_TCB_CONT_TEMPLATE_ADD);

ALTER TABLE TCB_CONT_TEMPLATE_HIST ADD (
  CONSTRAINT PK_TCB_CONT_TEMPLATE_HIST
  PRIMARY KEY
  (TEMPLATE_CD, VERSION_SEQ)
  USING INDEX PK_TCB_CONT_TEMPLATE_HIST);

ALTER TABLE TCB_CONT_TEMPLATE_SUB ADD (
  CONSTRAINT TCB_CONT_TEMPLATE_SUB_PK
  PRIMARY KEY
  (TEMPLATE_CD, SUB_SEQ)
  USING INDEX TCB_CONT_TEMPLATE_SUB_PK);

ALTER TABLE TCB_CONT_TEMPLATE_SUB_HIST ADD (
  CONSTRAINT SYS_C3
  PRIMARY KEY
  (TEMPLATE_CD, VERSION_SEQ, SUB_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CONT_TEMPLATE_USER ADD (
  PRIMARY KEY
  (TEMPLATE_CD, MEMBER_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CUST ADD (
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, MEMBER_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CUST_SIGN_IMG ADD (
  CONSTRAINT PK_TCB_CUST_SIGN_IMG
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, MEMBER_NO, SIGN_IMG_SEQ)
  USING INDEX PK_TCB_CUST_SIGN_IMG);

ALTER TABLE TCB_CUST_TEMP ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, TEMP_SEQ, MEMBER_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_DEBT_GROUP ADD (
  PRIMARY KEY
  (GROUP_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_DEBT_TEMP ADD (
  PRIMARY KEY
  (MEMBER_NO, USER_ID, TEMP_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_DEBT_TEMPLATE ADD (
  PRIMARY KEY
  (TEMPLATE_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_DEBT_TEMP_ITEM ADD (
  PRIMARY KEY
  (MEMBER_NO, USER_ID, ITEM_TEMP_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_DOC_INFO ADD (
  CONSTRAINT PK_TCB_DOC_INFO
  PRIMARY KEY
  (MEMBER_NO, DOC_SEQ)
  USING INDEX PK_TCB_DOC_INFO);

ALTER TABLE TCB_EFILE ADD (
  CONSTRAINT TCB_EFILE_IDX
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, EFILE_SEQ)
  USING INDEX TCB_EFILE_IDX);

ALTER TABLE TCB_EFILE_TEMPLATE ADD (
  CONSTRAINT TCB_EFILE_TEMPLATE_IDX
  PRIMARY KEY
  (TEMPLATE_CD, MEMBER_NO, EFILE_SEQ)
  USING INDEX TCB_EFILE_TEMPLATE_IDX);

ALTER TABLE TCB_ELCMASTER ADD (
  PRIMARY KEY
  (DOC_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_ELC_SIGNFORM ADD (
  PRIMARY KEY
  (ELC_GUBUN, SIGNFORM_SEQ));

ALTER TABLE TCB_ELC_SUPP ADD (
  PRIMARY KEY
  (DOC_NO, MEMBER_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_ELC_TEMPLATE ADD (
  PRIMARY KEY
  (TEMPLATE_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_EVENT ADD (
  PRIMARY KEY
  (EVENT_SEQ, EMAIL)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_EXAM ADD (
  PRIMARY KEY
  (MEMBER_NO, EXAM_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_EXAM_GRADE ADD (
  PRIMARY KEY
  (MEMBER_NO, EXAM_CD, SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_EXAM_ITEM ADD (
  PRIMARY KEY
  (MEMBER_NO, EXAM_CD, QUESTION_CD, ITEM_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_EXAM_QUESTION ADD (
  PRIMARY KEY
  (MEMBER_NO, EXAM_CD, QUESTION_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_EXAM_RESULT ADD (
  PRIMARY KEY
  (MEMBER_NO, RESULT_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_EXAM_RESULT_GRADE ADD (
  PRIMARY KEY
  (MEMBER_NO, RESULT_SEQ, SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_EXAM_RESULT_ITEM ADD (
  PRIMARY KEY
  (MEMBER_NO, RESULT_SEQ, QUESTION_CD, ITEM_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_EXAM_RESULT_QUESTION ADD (
  PRIMARY KEY
  (MEMBER_NO, RESULT_SEQ, QUESTION_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_IDENTIFY_LOG ADD (
  CONSTRAINT IDX_TCB_IDENTIFY_LOG_P
  PRIMARY KEY
  (LOG_SEQ)
  USING INDEX TCB_IDENTIFY_LOG_PK);

ALTER TABLE TCB_ITEM_DIV ADD (
  CONSTRAINT PK_TCB_ITEM_DIV
  PRIMARY KEY
  (MEMBER_NO, LITEM_CD, MITEM_CD)
  USING INDEX PK_TCB_ITEM_DIV);

ALTER TABLE TCB_ITEM_INFO ADD (
  CONSTRAINT TCB_ITEM_INFO_IDX
  PRIMARY KEY
  (MEMBER_NO, ITEM_CD)
  USING INDEX TCB_ITEM_INFO_IDX);

ALTER TABLE TCB_ITEM_INFO_CODE ADD (
  CONSTRAINT PK_TCB_ITEM_INFO_CODE
  PRIMARY KEY
  (MEMBER_NO, ITEM_NO)
  USING INDEX PK_TCB_ITEM_INFO_CODE);

ALTER TABLE TCB_ITEM_UNIT ADD (
  PRIMARY KEY
  (MEMBER_NO, ITEM_CD, SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_MAJOR_CUST ADD (
  PRIMARY KEY
  (MEMBER_NO, SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_MATERIAL ADD (
  PRIMARY KEY
  (MEMBER_NO, CAR_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_MEMBER ADD (
  PRIMARY KEY
  (MEMBER_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_MEMBER_ADD ADD (
  PRIMARY KEY
  (MEMBER_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_MEMBER_BOSS ADD (
  CONSTRAINT PK_TCB_MEMBER_BOSS
  PRIMARY KEY
  (MEMBER_NO, SEQ)
  USING INDEX PK_TCB_MEMBER_BOSS);

ALTER TABLE TCB_MEMBER_MENU ADD (
  PRIMARY KEY
  (MEMBER_NO, ADM_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_MEMBER_PDS_FILE ADD (
  PRIMARY KEY
  (MEMBER_NO, SEQ, FILE_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_MENU ADD (
  CONSTRAINT PK_TCB_MENU
  PRIMARY KEY
  (MENU_CD)
  USING INDEX PK_TCB_MENU);

ALTER TABLE TCB_MENU_INFO ADD (
  PRIMARY KEY
  (ADM_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_MENU_MEMBER ADD (
  PRIMARY KEY
  (MEMBER_NO, MENU_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_MENU_SUB ADD (
  PRIMARY KEY
  (ADM_CD, SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_ORDER_FIELD ADD (
  CONSTRAINT TCB_ORDER_FIELD_IDX
  PRIMARY KEY
  (MEMBER_NO, FIELD_SEQ)
  USING INDEX TCB_ORDER_FIELD_IDX);

ALTER TABLE TCB_ORDER_MASTER ADD (
  CONSTRAINT TCB_ORDER_MASTER_IDX
  PRIMARY KEY
  (ORDER_NO)
  USING INDEX TCB_ORDER_MASTER_IDX);

ALTER TABLE TCB_ORDER_TEMPLATE ADD (
  CONSTRAINT TCB_ORDER_TEMPLATE_IDX
  PRIMARY KEY
  (TEMPLATE_CD)
  USING INDEX TCB_ORDER_TEMPLATE_IDX);

ALTER TABLE TCB_PAY ADD (
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, MEMBER_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_PERSON ADD (
  PRIMARY KEY
  (MEMBER_NO, PERSON_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_PERSON_AUTH ADD (
  PRIMARY KEY
  (MEMBER_NO, PERSON_SEQ, ADM_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_PROJECT ADD (
  PRIMARY KEY
  (MEMBER_NO, PROJECT_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_PROJECT_ITEM ADD (
  PRIMARY KEY
  (MEMBER_NO, PROJECT_SEQ, ITEM_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_PROOF ADD (
  CONSTRAINT PK_TCB_PROOF
  PRIMARY KEY
  (PROOF_NO)
  USING INDEX PK_TCB_PROOF);

ALTER TABLE TCB_PROOF_CFILE ADD (
  CONSTRAINT PK_TCB_PROOF_CFILE
  PRIMARY KEY
  (PROOF_NO, CFILE_SEQ)
  USING INDEX PK_TCB_PROOF_CFILE);

ALTER TABLE TCB_PROOF_CUST ADD (
  CONSTRAINT PK_TCB_PROOF_CUST
  PRIMARY KEY
  (PROOF_NO, MEMBER_NO)
  USING INDEX PK_TCB_PROOF_CUST);

ALTER TABLE TCB_PROOF_SIGN ADD (
  CONSTRAINT PK_TCB_PROOF_SIGN
  PRIMARY KEY
  (PROOF_NO, SIGN_SEQ)
  USING INDEX PK_TCB_PROOF_SIGN);

ALTER TABLE TCB_PROOF_TEMPLATE ADD (
  CONSTRAINT PK_TCB_PROOF_TEMPLATE
  PRIMARY KEY
  (TEMPLATE_CD)
  USING INDEX PK_TCB_PROOF_TEMPLATE);

ALTER TABLE TCB_QNA ADD (
  CONSTRAINT XPKTCB_QNA
  PRIMARY KEY
  (QNASEQ)
  USING INDEX XPKTCB_QNA);

ALTER TABLE TCB_RECRUIT ADD (
  CONSTRAINT TCB_RECRUIT_IDX
  PRIMARY KEY
  (MEMBER_NO, SEQ)
  USING INDEX TCB_RECRUIT_IDX);

ALTER TABLE TCB_RECRUIT_CATEGORY ADD (
  CONSTRAINT TCB_RECRUIT_CATEGORY_IDX
  PRIMARY KEY
  (MEMBER_NO, SEQ, CODE)
  USING INDEX TCB_RECRUIT_CATEGORY_IDX);

ALTER TABLE TCB_RECRUIT_NOTI ADD (
  PRIMARY KEY
  (MEMBER_NO, NOTI_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_RECRUIT_SUPP ADD (
  CONSTRAINT TCB_RECRUIT_SUPP_IDX
  PRIMARY KEY
  (MEMBER_NO, SEQ, VENDCD)
  USING INDEX TCB_RECRUIT_SUPP_IDX);

ALTER TABLE TCB_RECRUIT_SUPP_CATEGORY ADD (
  CONSTRAINT TCB_RECRUIT_SUPP_CATEGORY_IDX
  PRIMARY KEY
  (MEMBER_NO, SEQ, VENDCD, CODE)
  USING INDEX TCB_RECRUIT_SUPP_CATEGORY_IDX);

ALTER TABLE TCB_REQ_FILE ADD (
  PRIMARY KEY
  (MEMBER_NO, REQ_NO, SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_REQ_INFO ADD (
  PRIMARY KEY
  (MEMBER_NO, REQ_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_REQ_ITEM ADD (
  PRIMARY KEY
  (MEMBER_NO, REQ_NO, ITEM_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_RFILE ADD (
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, RFILE_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_RFILE_CUST ADD (
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, RFILE_SEQ, MEMBER_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_RFILE_TEMPLATE ADD (
  PRIMARY KEY
  (TEMPLATE_CD, MEMBER_NO, RFILE_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_SAMSONG_EVALUATE ADD (
  PRIMARY KEY
  (YYYYMM)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_SAMSONG_EVALUATE_SUPP ADD (
  PRIMARY KEY
  (YYYYMM, VENDCD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_SHARE ADD (
  CONSTRAINT PK_TCB_SHARE
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, SEQ)
  USING INDEX PK_TCB_SHARE);

ALTER TABLE TCB_SRC_MEMBER ADD (
  PRIMARY KEY
  (MEMBER_NO, SRC_CD, SRC_MEMBER_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_STAMP ADD (
  CONSTRAINT TCB_STAMP_IDX
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, MEMBER_NO)
  USING INDEX TCB_STAMP_IDX);

ALTER TABLE TCB_SUBSCRIPTION ADD (
  CONSTRAINT PK_TCB_SUBSCRIPTION
  PRIMARY KEY
  (TEMPLATE_CD)
  USING INDEX PK_TCB_SUBSCRIPTION);

ALTER TABLE TCB_SUPP_ELCFORM ADD (
  PRIMARY KEY
  (ELC_GUBUN));

ALTER TABLE TCB_USEINFO ADD (
  CONSTRAINT TCB_USEINFO_PK
  PRIMARY KEY
  (USESEQ, MEMBER_NO)
  USING INDEX TCB_USEINFO_PK);

ALTER TABLE TCB_USEINFO_ADD ADD (
  PRIMARY KEY
  (USESEQ, MEMBER_NO, TEMPLATE_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_USER_CODE ADD (
  CONSTRAINT TCB_USER_CODE_IDX1
  PRIMARY KEY
  (MEMBER_NO, CODE)
  USING INDEX TCB_USER_CODE_IDX1);

ALTER TABLE TCB_USE_LOG ADD (
  CONSTRAINT TCB_USE_LOG_PK
  PRIMARY KEY
  (MEMBER_NO, USE_SEQ)
  USING INDEX TCB_USE_LOG_PK);

ALTER TABLE TCB_WARR ADD (
  CONSTRAINT TCB_WARR_PK
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, WARR_SEQ)
  USING INDEX TCB_WARR_PK);

ALTER TABLE TCB_WARR_ADD ADD (
  PRIMARY KEY
  (MEMBER_NO, WARR_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_WOOWAHAN ADD (
  CONSTRAINT PK_TCB_WOOWAHAN
  PRIMARY KEY
  (WOO_SEQ)
  USING INDEX PK_TCB_WOOWAHAN);

ALTER TABLE TCB_WOOWAHAN_AREA ADD (
  CONSTRAINT PK_TCB_WOOWAHAN_AREA
  PRIMARY KEY
  (AREA1, AREA2)
  USING INDEX PK_TCB_WOOWAHAN_AREA);

ALTER TABLE TCB_WOOWAHAN_FILE ADD (
  CONSTRAINT PK_TCB_WOOWAHAN_FILE
  PRIMARY KEY
  (WOO_SEQ, REG_TYPE)
  USING INDEX PK_TCB_WOOWAHAN_FILE);

ALTER TABLE TCB_APPLY_CAREER ADD (
  CONSTRAINT PK_TCB_APPLY_CAREER
  PRIMARY KEY
  (APPLY_NO, CAREER_SEQ)
  USING INDEX PK_TCB_APPLY_CAREER);

ALTER TABLE TCB_APPLY_EDU ADD (
  CONSTRAINT PK_TCB_APPLY_EDU
  PRIMARY KEY
  (APPLY_NO, EDU_SEQ)
  USING INDEX PK_TCB_APPLY_EDU);

ALTER TABLE TCB_APPLY_FILE ADD (
  CONSTRAINT PK_TCB_APPLY_FILE
  PRIMARY KEY
  (APPLY_NO, FILE_SEQ)
  USING INDEX PK_TCB_APPLY_FILE);

ALTER TABLE TCB_APPLY_LICENSE ADD (
  CONSTRAINT PK_TCB_APPLY_LICENSE
  PRIMARY KEY
  (APPLY_NO, LICEN_SEQ)
  USING INDEX PK_TCB_APPLY_LICENSE);

ALTER TABLE TCB_ASSEDETAIL ADD (
  CONSTRAINT TCB_ASSEDETAIL_IDX
  PRIMARY KEY
  (ASSE_NO, DIV_CD)
  USING INDEX TCB_ASSEDETAIL_IDX);

ALTER TABLE TCB_AUTH ADD (
  CONSTRAINT PK_TCB_AUTH
  PRIMARY KEY
  (MEMBER_NO, AUTH_CD)
  USING INDEX PK_TCB_AUTH);

ALTER TABLE TCB_AUTH_FIELD ADD (
  CONSTRAINT PK_TCB_AUTH_FIELD
  PRIMARY KEY
  (MEMBER_NO, AUTH_CD, SEQ)
  USING INDEX PK_TCB_AUTH_FIELD);

ALTER TABLE TCB_AUTH_MENU ADD (
  CONSTRAINT PK_TCB_AUTH_MENU
  PRIMARY KEY
  (MEMBER_NO, AUTH_CD, MENU_CD)
  USING INDEX PK_TCB_AUTH_MENU);

ALTER TABLE TCB_BID_CHARGE ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, CHARGE_SEQ, CHARGE_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_EMAIL ADD (
  CONSTRAINT PK_TCB_BID_EMAIL
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, EMAIL_SEQ)
  USING INDEX PK_TCB_BID_EMAIL);

ALTER TABLE TCB_BID_END_ITEM ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_ESTM_FILE ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_FILE ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, FILE_DIV_CD, SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_INFO ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_ITEM ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, ITEM_CD)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_ITEM_TERM ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, ITEM_CD, TERM_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_JOIN_ESTM_FILE ADD (
  CONSTRAINT PK_TCB_BID_JOIN_ESTM_FILE
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, SEQ)
  USING INDEX PK_TCB_BID_JOIN_ESTM_FILE);

ALTER TABLE TCB_BID_JOIN_REQ_FILE ADD (
  CONSTRAINT PK_TCB_BID_JOIN_REQ_FILE
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, SEQ)
  USING INDEX PK_TCB_BID_JOIN_REQ_FILE);

ALTER TABLE TCB_BID_MULTI_AMT ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, AMT_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_PAY ADD (
  CONSTRAINT PK_TCB_BID_PAY
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO)
  USING INDEX PK_TCB_BID_PAY);

ALTER TABLE TCB_BID_SKILL_ESTM_FILE ADD (
  PRIMARY KEY
  (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CALC_MONTH ADD (
  CONSTRAINT PK_TCB_CALC_MONTH
  PRIMARY KEY
  (MEMBER_NO, YYYYMM, CALC_PERSON_SEQ)
  USING INDEX PK_TCB_CALC_MONTH);

ALTER TABLE TCB_CALC_PERSON ADD (
  CONSTRAINT PK_TCB_CALC_PERSON
  PRIMARY KEY
  (MEMBER_NO, SEQ)
  USING INDEX PK_TCB_CALC_PERSON);

ALTER TABLE TCB_CFILE ADD (
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, CFILE_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CLIENT ADD (
  PRIMARY KEY
  (MEMBER_NO, CLIENT_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CLIENT_DETAIL ADD (
  PRIMARY KEY
  (MEMBER_NO, CLIENT_SEQ, PERSON_SEQ, CLIENT_DETAIL_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CLIENT_RFILE_TEMPLATE ADD (
  CONSTRAINT SYS_C
  PRIMARY KEY
  (RFILE_SEQ, MEMBER_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CONT_EMAIL ADD (
  PRIMARY KEY
  (CONT_NO, CONT_CHASU, MEMBER_NO, EMAIL_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_CONT_SIGN_TEMPLATE ADD (
  CONSTRAINT TCB_CONT_SIGN_TEMPLATE_PK
  PRIMARY KEY
  (TEMPLATE_CD, SIGN_SEQ)
  USING INDEX TCB_CONT_SIGN_TEMPLATE_PK);

ALTER TABLE TCB_DEBT ADD (
  PRIMARY KEY
  (DEBT_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_DEBT_CFILE ADD (
  PRIMARY KEY
  (DEBT_NO, CFILE_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_DEBT_CUST ADD (
  PRIMARY KEY
  (DEBT_NO, MEMBER_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_DEBT_PROC ADD (
  PRIMARY KEY
  (DEBT_NO, PROC_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_FIELD ADD (
  PRIMARY KEY
  (MEMBER_NO, FIELD_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_FIELDPERSON ADD (
  PRIMARY KEY
  (MEMBER_NO, FIELD_SEQ, PERSON_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_ITEM ADD (
  CONSTRAINT PK_TCB_ITEM
  PRIMARY KEY
  (MEMBER_NO, DOC_SEQ, ITEM_NO, ITEM_SEQ)
  USING INDEX PK_TCB_ITEM);

ALTER TABLE TCB_ORDER_CUST ADD (
  CONSTRAINT TCB_ORDER_CUST_IDX
  PRIMARY KEY
  (ORDER_NO, MEMBER_NO)
  USING INDEX TCB_ORDER_CUST_IDX);

ALTER TABLE TCB_ORDER_FILE ADD (
  CONSTRAINT TCB_ORDER_FILE_IDX
  PRIMARY KEY
  (ORDER_NO, FILE_SEQ)
  USING INDEX TCB_ORDER_FILE_IDX);

ALTER TABLE TCB_ORDER_ITEM ADD (
  CONSTRAINT TCB_ORDER_ITEM_IDX
  PRIMARY KEY
  (ORDER_NO, ITEM_SEQ)
  USING INDEX TCB_ORDER_ITEM_IDX);

ALTER TABLE TCB_PAY_DEBT ADD (
  PRIMARY KEY
  (DEBT_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_PROOF_SIGN_TEMPLATE ADD (
  CONSTRAINT PK_TCB_PROOF_SIGN_TEMPLATE
  PRIMARY KEY
  (TEMPLATE_CD, SIGN_SEQ)
  USING INDEX PK_TCB_PROOF_SIGN_TEMPLATE);

ALTER TABLE TCB_RECRUIT_CLIENT ADD (
  CONSTRAINT TCB_RECRUIT_CLIENT_IDX
  PRIMARY KEY
  (MEMBER_NO, SEQ, VENDCD, CLIENT_SEQ)
  USING INDEX TCB_RECRUIT_CLIENT_IDX);

ALTER TABLE TCB_RECRUIT_CUST ADD (
  PRIMARY KEY
  (MEMBER_NO, NOTI_SEQ, CUST_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_RECRUIT_ITEM ADD (
  CONSTRAINT TCB_RECRUIT_ITEM_IDX
  PRIMARY KEY
  (MEMBER_NO, SEQ, VENDCD, ITEM_SEQ)
  USING INDEX TCB_RECRUIT_ITEM_IDX);

ALTER TABLE TCB_CLIENT_RFILE ADD (
  CONSTRAINT SYS_C2
  PRIMARY KEY
  (MEMBER_NO, RFILE_SEQ, CLIENT_NO)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_DEBT_PFILE ADD (
  PRIMARY KEY
  (DEBT_NO, PROC_SEQ, PFILE_SEQ)
  USING INDEX
    TABLESPACE TS_DOCU_D
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ));

ALTER TABLE TCB_BID_MULTI_INFO ADD (
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG) 
  REFERENCES TCB_BID_MASTER (MAIN_MEMBER_NO,BID_NO,BID_DEG));

ALTER TABLE TCB_BID_REQ_FILE ADD (
  CONSTRAINT FK_TCB_BID_REQ_FILE_1 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG) 
  REFERENCES TCB_BID_MASTER (MAIN_MEMBER_NO,BID_NO,BID_DEG));

ALTER TABLE TCB_BID_SHARE ADD (
  CONSTRAINT FK_TCB_BID_SHARE 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG) 
  REFERENCES TCB_BID_MASTER (MAIN_MEMBER_NO,BID_NO,BID_DEG));

ALTER TABLE TCB_BID_SKILL_REQ_FILE ADD (
  CONSTRAINT FK_TCB_BID_TECH_REQ_FILE 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG) 
  REFERENCES TCB_BID_MASTER (MAIN_MEMBER_NO,BID_NO,BID_DEG));

ALTER TABLE TCB_BID_SUPP ADD (
  CONSTRAINT FK_TCB_BID_SUPP_1 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG) 
  REFERENCES TCB_BID_MASTER (MAIN_MEMBER_NO,BID_NO,BID_DEG));

ALTER TABLE TCB_BID_SUPPITEM ADD (
  CONSTRAINT FK_TCB_BID_SUPPITEM_1 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO) 
  REFERENCES TCB_BID_SUPP (MAIN_MEMBER_NO,BID_NO,BID_DEG,MEMBER_NO));

ALTER TABLE TCB_BID_SUPPITEM_TERM ADD (
  CONSTRAINT FK_TCB_BID_SUPPITEM_TERM_1 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO, ITEM_CD) 
  REFERENCES TCB_BID_SUPPITEM (MAIN_MEMBER_NO,BID_NO,BID_DEG,MEMBER_NO,ITEM_CD));

ALTER TABLE TCB_BID_SUPP_ORGITEM ADD (
  CONSTRAINT FK_TCB_BID_SUPP_ORGITEM_1 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO) 
  REFERENCES TCB_BID_SUPP (MAIN_MEMBER_NO,BID_NO,BID_DEG,MEMBER_NO));

ALTER TABLE TCB_BID_SUPP_SIGN_DOC ADD (
  CONSTRAINT FK_TCB_BID_SUPP_SIGN_DOC 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO) 
  REFERENCES TCB_BID_SUPP (MAIN_MEMBER_NO,BID_NO,BID_DEG,MEMBER_NO));

ALTER TABLE TCB_BID_SUPP_SUB ADD (
  CONSTRAINT FK_TCB_BID_SUPP_SUB_1 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO) 
  REFERENCES TCB_BID_SUPP (MAIN_MEMBER_NO,BID_NO,BID_DEG,MEMBER_NO));

ALTER TABLE TCB_BID_SUPP_SUCCPAY ADD (
  CONSTRAINT FK_TCB_BID_SUPP_SUCCPAY 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO) 
  REFERENCES TCB_BID_SUPP (MAIN_MEMBER_NO,BID_NO,BID_DEG,MEMBER_NO));

ALTER TABLE TCB_CONT_ADD ADD (
  CONSTRAINT FK_TCB_CONT_ADD 
  FOREIGN KEY (CONT_NO, CONT_CHASU) 
  REFERENCES TCB_CONTMASTER (CONT_NO,CONT_CHASU));

ALTER TABLE TCB_CONT_AGREE ADD (
  CONSTRAINT FK_TCB_CONT_AGREE_1 
  FOREIGN KEY (CONT_NO, CONT_CHASU) 
  REFERENCES TCB_CONTMASTER (CONT_NO,CONT_CHASU));

ALTER TABLE TCB_CONT_LOG ADD (
  CONSTRAINT FK_TCB_CONT_LOG 
  FOREIGN KEY (CONT_NO, CONT_CHASU) 
  REFERENCES TCB_CONTMASTER (CONT_NO,CONT_CHASU));

ALTER TABLE TCB_CONT_SIGN ADD (
  CONSTRAINT FK_TCB_CONT_SIGN_1 
  FOREIGN KEY (CONT_NO, CONT_CHASU) 
  REFERENCES TCB_CONTMASTER (CONT_NO,CONT_CHASU));

ALTER TABLE TCB_CONT_SUB ADD (
  CONSTRAINT FK_TCB_CONT_SUB_1 
  FOREIGN KEY (CONT_NO, CONT_CHASU) 
  REFERENCES TCB_CONTMASTER (CONT_NO,CONT_CHASU));

ALTER TABLE TCB_CONT_TEMPLATE_SUB ADD (
  CONSTRAINT FK_TCB_CONT_TEMPLATE_SUB_1 
  FOREIGN KEY (TEMPLATE_CD) 
  REFERENCES TCB_CONT_TEMPLATE (TEMPLATE_CD));

ALTER TABLE TCB_CONT_TEMPLATE_SUB_HIST ADD (
  CONSTRAINT FK_TCB_CONT_TEMPLATE_SUB_HIST 
  FOREIGN KEY (TEMPLATE_CD, VERSION_SEQ) 
  REFERENCES TCB_CONT_TEMPLATE_HIST (TEMPLATE_CD,VERSION_SEQ));

ALTER TABLE TCB_CUST ADD (
  CONSTRAINT FK_TCB_CUST_1 
  FOREIGN KEY (CONT_NO, CONT_CHASU) 
  REFERENCES TCB_CONTMASTER (CONT_NO,CONT_CHASU));

ALTER TABLE TCB_CUST_SIGN_IMG ADD (
  CONSTRAINT FK_TCB_CUST_SIGN_IMG 
  FOREIGN KEY (CONT_NO, CONT_CHASU, MEMBER_NO) 
  REFERENCES TCB_CUST (CONT_NO,CONT_CHASU,MEMBER_NO));

ALTER TABLE TCB_EFILE ADD (
  CONSTRAINT FK_TCB_EFILE_1 
  FOREIGN KEY (CONT_NO, CONT_CHASU) 
  REFERENCES TCB_CONTMASTER (CONT_NO,CONT_CHASU));

ALTER TABLE TCB_ELC_SUPP ADD (
  CONSTRAINT FK_TCB_ELC_SUPP_1 
  FOREIGN KEY (DOC_NO) 
  REFERENCES TCB_ELCMASTER (DOC_NO));

ALTER TABLE TCB_EXAM_GRADE ADD (
  CONSTRAINT FK_TCB_EXAM_GRADE_1 
  FOREIGN KEY (MEMBER_NO, EXAM_CD) 
  REFERENCES TCB_EXAM (MEMBER_NO,EXAM_CD));

ALTER TABLE TCB_EXAM_QUESTION ADD (
  CONSTRAINT FK_TCB_EXAM_QUESTION_1 
  FOREIGN KEY (MEMBER_NO, EXAM_CD) 
  REFERENCES TCB_EXAM (MEMBER_NO,EXAM_CD));

ALTER TABLE TCB_MEMBER_BOSS ADD (
  CONSTRAINT FK_TCB_MEMBER_BOSS 
  FOREIGN KEY (MEMBER_NO) 
  REFERENCES TCB_MEMBER (MEMBER_NO));

ALTER TABLE TCB_MEMBER_MENU ADD (
  CONSTRAINT FK_TCB_MEMBER_MENU_1 
  FOREIGN KEY (MEMBER_NO) 
  REFERENCES TCB_MEMBER (MEMBER_NO));

ALTER TABLE TCB_MENU_MEMBER ADD (
  CONSTRAINT FK_TCB_MENU_MEMBER 
  FOREIGN KEY (MEMBER_NO) 
  REFERENCES TCB_MEMBER (MEMBER_NO));

ALTER TABLE TCB_PERSON ADD (
  CONSTRAINT FK_TCB_PERSON_1 
  FOREIGN KEY (MEMBER_NO) 
  REFERENCES TCB_MEMBER (MEMBER_NO));

ALTER TABLE TCB_PERSON_AUTH ADD (
  CONSTRAINT FK_TCB_PERSON_AUTH_1 
  FOREIGN KEY (MEMBER_NO, PERSON_SEQ) 
  REFERENCES TCB_PERSON (MEMBER_NO,PERSON_SEQ));

ALTER TABLE TCB_PROJECT ADD (
  CONSTRAINT FK_TCB_PROJECT_1 
  FOREIGN KEY (MEMBER_NO) 
  REFERENCES TCB_MEMBER (MEMBER_NO));

ALTER TABLE TCB_PROJECT_ITEM ADD (
  CONSTRAINT FK_TCB_PROJECT_ITEM_1 
  FOREIGN KEY (MEMBER_NO, PROJECT_SEQ) 
  REFERENCES TCB_PROJECT (MEMBER_NO,PROJECT_SEQ));

ALTER TABLE TCB_PROOF_CFILE ADD (
  CONSTRAINT FK_TCB_PROOF_CFILE 
  FOREIGN KEY (PROOF_NO) 
  REFERENCES TCB_PROOF (PROOF_NO));

ALTER TABLE TCB_PROOF_CUST ADD (
  CONSTRAINT FK_TCB_PROOF_CUST 
  FOREIGN KEY (PROOF_NO) 
  REFERENCES TCB_PROOF (PROOF_NO));

ALTER TABLE TCB_PROOF_SIGN ADD (
  CONSTRAINT FK_TCB_PROOF_SIGN 
  FOREIGN KEY (PROOF_NO) 
  REFERENCES TCB_PROOF (PROOF_NO));

ALTER TABLE TCB_RECRUIT_CATEGORY ADD (
  CONSTRAINT FK_TCB_RECRUIT_CATEGORY_1 
  FOREIGN KEY (MEMBER_NO, SEQ) 
  REFERENCES TCB_RECRUIT (MEMBER_NO,SEQ));

ALTER TABLE TCB_RECRUIT_SUPP ADD (
  CONSTRAINT FK_TCB_RECRUIT_SUPP_1 
  FOREIGN KEY (MEMBER_NO, SEQ) 
  REFERENCES TCB_RECRUIT (MEMBER_NO,SEQ));

ALTER TABLE TCB_RECRUIT_SUPP_CATEGORY ADD (
  CONSTRAINT FK_TCB_RECRUIT_SUPP_CATEGORY_1 
  FOREIGN KEY (MEMBER_NO, SEQ, VENDCD) 
  REFERENCES TCB_RECRUIT_SUPP (MEMBER_NO,SEQ,VENDCD));

ALTER TABLE TCB_RFILE ADD (
  CONSTRAINT FK_TCB_RFILE_1 
  FOREIGN KEY (CONT_NO, CONT_CHASU) 
  REFERENCES TCB_CONTMASTER (CONT_NO,CONT_CHASU));

ALTER TABLE TCB_RFILE_CUST ADD (
  CONSTRAINT FK_TCB_RFILE_CUST_1 
  FOREIGN KEY (CONT_NO, CONT_CHASU, RFILE_SEQ) 
  REFERENCES TCB_RFILE (CONT_NO,CONT_CHASU,RFILE_SEQ));

ALTER TABLE TCB_SAMSONG_EVALUATE_SUPP ADD (
  CONSTRAINT TCBSAMSOUNGEVALUATESUPP_FK1 
  FOREIGN KEY (YYYYMM) 
  REFERENCES TCB_SAMSONG_EVALUATE (YYYYMM));

ALTER TABLE TCB_SHARE ADD (
  CONSTRAINT FK_TCB_SHARE 
  FOREIGN KEY (CONT_NO, CONT_CHASU) 
  REFERENCES TCB_CONTMASTER (CONT_NO,CONT_CHASU));

ALTER TABLE TCB_SRC_ADM ADD (
  CONSTRAINT FK_TCB_SRC_ADM_1 
  FOREIGN KEY (MEMBER_NO) 
  REFERENCES TCB_MEMBER (MEMBER_NO));

ALTER TABLE TCB_STAMP ADD (
  CONSTRAINT FK_TCB_STAMP_1 
  FOREIGN KEY (CONT_NO, CONT_CHASU) 
  REFERENCES TCB_CONTMASTER (CONT_NO,CONT_CHASU));

ALTER TABLE TCB_USEINFO ADD (
  CONSTRAINT FK_TCB_USEINFO_1 
  FOREIGN KEY (MEMBER_NO) 
  REFERENCES TCB_MEMBER (MEMBER_NO));

ALTER TABLE TCB_WARR ADD (
  CONSTRAINT FK_TCB_WARR_1 
  FOREIGN KEY (CONT_NO, CONT_CHASU) 
  REFERENCES TCB_CONTMASTER (CONT_NO,CONT_CHASU));

ALTER TABLE TCB_WOOWAHAN_FILE ADD (
  CONSTRAINT FK_TCB_WOO_TO_TCB_WOO_FILE 
  FOREIGN KEY (WOO_SEQ) 
  REFERENCES TCB_WOOWAHAN (WOO_SEQ));

ALTER TABLE TCB_APPLY_CAREER ADD (
  CONSTRAINT FK_TCB_APPLY_CAREER 
  FOREIGN KEY (APPLY_NO) 
  REFERENCES TCB_APPLY_PERSON (APPLY_NO));

ALTER TABLE TCB_APPLY_EDU ADD (
  CONSTRAINT FK_TCB_APPLY_EDU 
  FOREIGN KEY (APPLY_NO) 
  REFERENCES TCB_APPLY_PERSON (APPLY_NO));

ALTER TABLE TCB_APPLY_FILE ADD (
  CONSTRAINT FK_TCB_APPLY_FILE 
  FOREIGN KEY (APPLY_NO) 
  REFERENCES TCB_APPLY_PERSON (APPLY_NO));

ALTER TABLE TCB_APPLY_LICENSE ADD (
  CONSTRAINT FK_TCB_APPLY_LICENSE 
  FOREIGN KEY (APPLY_NO) 
  REFERENCES TCB_APPLY_PERSON (APPLY_NO));

ALTER TABLE TCB_ASSEDETAIL ADD (
  CONSTRAINT FK_TCB_ASSEDETAIL_1 
  FOREIGN KEY (ASSE_NO) 
  REFERENCES TCB_ASSEMASTER (ASSE_NO));

ALTER TABLE TCB_AUTH ADD (
  CONSTRAINT FK_TCB_AUTH 
  FOREIGN KEY (MEMBER_NO) 
  REFERENCES TCB_MEMBER (MEMBER_NO));

ALTER TABLE TCB_AUTH_FIELD ADD (
  CONSTRAINT FK_TCB_AUTH_TO_TCB_AUTH_FIELD 
  FOREIGN KEY (MEMBER_NO, AUTH_CD) 
  REFERENCES TCB_AUTH (MEMBER_NO,AUTH_CD));

ALTER TABLE TCB_AUTH_MENU ADD (
  CONSTRAINT FK_TCB_AUTH_MENU 
  FOREIGN KEY (MEMBER_NO, AUTH_CD) 
  REFERENCES TCB_AUTH (MEMBER_NO,AUTH_CD));

ALTER TABLE TCB_BID_CHARGE ADD (
  CONSTRAINT FK_TCB_BID_CHARGE_1 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG) 
  REFERENCES TCB_BID_MASTER (MAIN_MEMBER_NO,BID_NO,BID_DEG));

ALTER TABLE TCB_BID_EMAIL ADD (
  CONSTRAINT FK_TCB_BID_EMAIL 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG) 
  REFERENCES TCB_BID_MASTER (MAIN_MEMBER_NO,BID_NO,BID_DEG));

ALTER TABLE TCB_BID_END_ITEM ADD (
  CONSTRAINT FK_TCB_BID_END_ITEM_1 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG) 
  REFERENCES TCB_BID_MASTER (MAIN_MEMBER_NO,BID_NO,BID_DEG));

ALTER TABLE TCB_BID_ESTM_FILE ADD (
  CONSTRAINT FK_TCB_BID_ESTM_FILE_1 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO) 
  REFERENCES TCB_BID_SUPP (MAIN_MEMBER_NO,BID_NO,BID_DEG,MEMBER_NO));

ALTER TABLE TCB_BID_FILE ADD (
  CONSTRAINT FK_TCB_BID_FILE_1 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG) 
  REFERENCES TCB_BID_MASTER (MAIN_MEMBER_NO,BID_NO,BID_DEG));

ALTER TABLE TCB_BID_INFO ADD (
  CONSTRAINT FK_TCB_BID_INFO_1 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG) 
  REFERENCES TCB_BID_MASTER (MAIN_MEMBER_NO,BID_NO,BID_DEG));

ALTER TABLE TCB_BID_ITEM ADD (
  CONSTRAINT FK_TCB_BID_ITEM_1 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG) 
  REFERENCES TCB_BID_MASTER (MAIN_MEMBER_NO,BID_NO,BID_DEG));

ALTER TABLE TCB_BID_ITEM_TERM ADD (
  CONSTRAINT FK_TCB_BID_ITEM_TERM_1 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG, ITEM_CD) 
  REFERENCES TCB_BID_ITEM (MAIN_MEMBER_NO,BID_NO,BID_DEG,ITEM_CD));

ALTER TABLE TCB_BID_JOIN_ESTM_FILE ADD (
  CONSTRAINT FK_TCB_BID_JOIN_ESTM_FILE 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG) 
  REFERENCES TCB_BID_MASTER (MAIN_MEMBER_NO,BID_NO,BID_DEG));

ALTER TABLE TCB_BID_JOIN_REQ_FILE ADD (
  CONSTRAINT FK_TCB_BID_JOIN_REQ_FILE 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG) 
  REFERENCES TCB_BID_MASTER (MAIN_MEMBER_NO,BID_NO,BID_DEG));

ALTER TABLE TCB_BID_MULTI_AMT ADD (
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG) 
  REFERENCES TCB_BID_MULTI_INFO (MAIN_MEMBER_NO,BID_NO,BID_DEG));

ALTER TABLE TCB_BID_PAY ADD (
  CONSTRAINT FK_TCB_BID_PAY 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO) 
  REFERENCES TCB_BID_SUPP (MAIN_MEMBER_NO,BID_NO,BID_DEG,MEMBER_NO));

ALTER TABLE TCB_BID_SKILL_ESTM_FILE ADD (
  CONSTRAINT FK_TCB_BID_TECH_ESTM_FILE 
  FOREIGN KEY (MAIN_MEMBER_NO, BID_NO, BID_DEG, MEMBER_NO) 
  REFERENCES TCB_BID_SUPP (MAIN_MEMBER_NO,BID_NO,BID_DEG,MEMBER_NO));

ALTER TABLE TCB_CALC_MONTH ADD (
  CONSTRAINT FK_TCB_CALC_MONTH 
  FOREIGN KEY (MEMBER_NO) 
  REFERENCES TCB_MEMBER (MEMBER_NO));

ALTER TABLE TCB_CALC_PERSON ADD (
  CONSTRAINT FK_TCB_CALC_PERSON 
  FOREIGN KEY (MEMBER_NO) 
  REFERENCES TCB_MEMBER (MEMBER_NO));

ALTER TABLE TCB_CFILE ADD (
  CONSTRAINT FK_TCB_CFILE_1 
  FOREIGN KEY (CONT_NO, CONT_CHASU) 
  REFERENCES TCB_CONTMASTER (CONT_NO,CONT_CHASU));

ALTER TABLE TCB_CLIENT ADD (
  CONSTRAINT FK_TCB_CLIENT_1 
  FOREIGN KEY (MEMBER_NO) 
  REFERENCES TCB_MEMBER (MEMBER_NO));

ALTER TABLE TCB_CLIENT_DETAIL ADD (
  CONSTRAINT FK_TCB_CLIENT_DETAIL_1 
  FOREIGN KEY (MEMBER_NO, CLIENT_SEQ) 
  REFERENCES TCB_CLIENT (MEMBER_NO,CLIENT_SEQ));

ALTER TABLE TCB_CLIENT_RFILE_TEMPLATE ADD (
  CONSTRAINT FK_TCB_CLIENT_RFILE_TEMPLATE 
  FOREIGN KEY (MEMBER_NO) 
  REFERENCES TCB_MEMBER (MEMBER_NO));

ALTER TABLE TCB_CONT_EMAIL ADD (
  CONSTRAINT FK_TCB_CONT_EMAIL_1 
  FOREIGN KEY (CONT_NO, CONT_CHASU, MEMBER_NO) 
  REFERENCES TCB_CUST (CONT_NO,CONT_CHASU,MEMBER_NO));

ALTER TABLE TCB_CONT_SIGN_TEMPLATE ADD (
  CONSTRAINT FK_TCB_CONT_SIGN_TEMPLATE 
  FOREIGN KEY (TEMPLATE_CD) 
  REFERENCES TCB_CONT_TEMPLATE (TEMPLATE_CD));

ALTER TABLE TCB_DEBT ADD (
  CONSTRAINT FK_TCB_DEBT_1 
  FOREIGN KEY (GROUP_NO) 
  REFERENCES TCB_DEBT_GROUP (GROUP_NO));

ALTER TABLE TCB_DEBT_CFILE ADD (
  CONSTRAINT FK_TCB_DEBT_CFILE_1 
  FOREIGN KEY (DEBT_NO) 
  REFERENCES TCB_DEBT (DEBT_NO));

ALTER TABLE TCB_DEBT_CUST ADD (
  CONSTRAINT FK_TCB_DEBT_CUST_1 
  FOREIGN KEY (DEBT_NO) 
  REFERENCES TCB_DEBT (DEBT_NO));

ALTER TABLE TCB_DEBT_PROC ADD (
  CONSTRAINT FK_TCB_DEBT_PROC_1 
  FOREIGN KEY (DEBT_NO) 
  REFERENCES TCB_DEBT (DEBT_NO));

ALTER TABLE TCB_FIELD ADD (
  CONSTRAINT FK_TCB_FIELD_1 
  FOREIGN KEY (MEMBER_NO) 
  REFERENCES TCB_MEMBER (MEMBER_NO));

ALTER TABLE TCB_FIELDPERSON ADD (
  CONSTRAINT FK_TCB_FIELDPERSON_1 
  FOREIGN KEY (MEMBER_NO, FIELD_SEQ) 
  REFERENCES TCB_FIELD (MEMBER_NO,FIELD_SEQ),
  CONSTRAINT FK_TCB_FIELDPERSON_2 
  FOREIGN KEY (MEMBER_NO, PERSON_SEQ) 
  REFERENCES TCB_PERSON (MEMBER_NO,PERSON_SEQ));

ALTER TABLE TCB_ITEM ADD (
  CONSTRAINT FK_TCB_DOC_INFO_TO_TCB_ITEM 
  FOREIGN KEY (MEMBER_NO, DOC_SEQ) 
  REFERENCES TCB_DOC_INFO (MEMBER_NO,DOC_SEQ),
  CONSTRAINT FK_TCB_ITEM_INFO__TCB_ITEM 
  FOREIGN KEY (MEMBER_NO, ITEM_NO) 
  REFERENCES TCB_ITEM_INFO_CODE (MEMBER_NO,ITEM_NO));

ALTER TABLE TCB_ORDER_CUST ADD (
  CONSTRAINT FK_TCB_ORDER_CUST_1 
  FOREIGN KEY (ORDER_NO) 
  REFERENCES TCB_ORDER_MASTER (ORDER_NO));

ALTER TABLE TCB_ORDER_FILE ADD (
  CONSTRAINT FK_TCB_ORDER_FILE_1 
  FOREIGN KEY (ORDER_NO) 
  REFERENCES TCB_ORDER_MASTER (ORDER_NO));

ALTER TABLE TCB_ORDER_ITEM ADD (
  CONSTRAINT FK_TCB_ORDER_ITEM_1 
  FOREIGN KEY (ORDER_NO) 
  REFERENCES TCB_ORDER_MASTER (ORDER_NO));

ALTER TABLE TCB_PAY_DEBT ADD (
  CONSTRAINT FK_TCB_PAY_DEBT_1 
  FOREIGN KEY (DEBT_NO) 
  REFERENCES TCB_DEBT (DEBT_NO));

ALTER TABLE TCB_PROOF_SIGN_TEMPLATE ADD (
  CONSTRAINT FK_TCB_PROOF_SIGN_TEMPLATE 
  FOREIGN KEY (TEMPLATE_CD) 
  REFERENCES TCB_PROOF_TEMPLATE (TEMPLATE_CD));

ALTER TABLE TCB_RECRUIT_CLIENT ADD (
  CONSTRAINT FK_TCB_RECRUIT_CLIENT_1 
  FOREIGN KEY (MEMBER_NO, SEQ, VENDCD) 
  REFERENCES TCB_RECRUIT_SUPP (MEMBER_NO,SEQ,VENDCD));

ALTER TABLE TCB_RECRUIT_CUST ADD (
  CONSTRAINT FK_TCB_RECRUIT_CUST_1 
  FOREIGN KEY (MEMBER_NO, NOTI_SEQ) 
  REFERENCES TCB_RECRUIT_NOTI (MEMBER_NO,NOTI_SEQ));

ALTER TABLE TCB_RECRUIT_ITEM ADD (
  CONSTRAINT FK_TCB_RECRUIT_ITEM_1 
  FOREIGN KEY (MEMBER_NO, SEQ, VENDCD) 
  REFERENCES TCB_RECRUIT_SUPP (MEMBER_NO,SEQ,VENDCD));

ALTER TABLE TCB_CLIENT_RFILE ADD (
  CONSTRAINT FK_TO_TCB_CLIENT_RFILE 
  FOREIGN KEY (RFILE_SEQ, MEMBER_NO) 
  REFERENCES TCB_CLIENT_RFILE_TEMPLATE (RFILE_SEQ,MEMBER_NO));

ALTER TABLE TCB_DEBT_PFILE ADD (
  CONSTRAINT FK_TCB_DEBT_PFILE_1 
  FOREIGN KEY (DEBT_NO, PROC_SEQ) 
  REFERENCES TCB_DEBT_PROC (DEBT_NO,PROC_SEQ));
