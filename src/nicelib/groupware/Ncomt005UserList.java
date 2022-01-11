package nicelib.groupware;

import java.util.Hashtable;

//import sun.org.mozilla.javascript.internal.regexp.SubString;

import nicelib.db.DB;
import nicelib.db.DataObject;
import nicelib.db.DataSet;

/**
 * Ncomt005 회원 목록 갱신을 위한 클래스
 * @author hmson
 */
public class Ncomt005UserList{
	public boolean updateNcomt005UserInfoList() throws Exception{
		System.out.println("### updateNcomt005UserInfoList Start ###");
		int cnt = 0;
		// 현재 max person_seq 채번
		DataObject personDao = new DataObject("tcb_person");
		int person_seq =  Integer.parseInt(personDao.getOne("select nvl(max(person_seq),0) person_seq from tcb_person where member_no = '20201000001'"));
		
		// NCOMT005 조회 LIST 담기
		DataObject ncomt005Obj = new DataObject("NCOMT005");
		//DataSet ncomt005UserInfo = ncomt005Obj.find("entr_com_Date >= TO_CHAR(SYSDATE,'YYYYMMDD') and end_gubn = 'Y'","*","emp_no");
		// NCOMT005에서 읽어오는 정보 조회조건 변경, 995 직무는 이전일자도 조회 (2021.01.05 SWPLUS)
		DataSet ncomt005UserInfo = ncomt005Obj.find("(entr_com_Date >= TO_CHAR(SYSDATE,'YYYYMMDD') OR (entr_com_Date <= TO_CHAR(SYSDATE,'YYYYMMDD') AND autt_code = '995')) and end_gubn = 'Y'","*","emp_no");
		if (!ncomt005UserInfo.next()) {
			System.out.println("### NCOMT005 DATA NOT FOUND ###");
			return false;
		}
		DB db = new DB();
		DataObject memberObj = new DataObject("tcb_person");
		for(int i=0; i< ncomt005UserInfo.size(); i++)
		{
			// SELECT COUNT(*) TCB_PERSON 조회  / 아이디는 변경하여 가입이 가능하므로, 사원번호로 구분
			Hashtable memberInfo = ((Hashtable)ncomt005UserInfo.getRows().get(i));
			String userEmpNo = memberInfo.get("emp_no").toString();
			cnt = memberObj.findCount("USER_EMPNO = '"+ userEmpNo + "' AND MEMBER_NO IN('20201000001', '20201000002') ");
			
			memberObj = new DataObject("tcb_person");
			memberObj.item("user_empno", userEmpNo);
			memberObj.item("user_id", filterStr(memberInfo.get("emp_no").toString()) );
			memberObj.item("field_seq", "");
			memberObj.item("user_name", filterStr(memberInfo.get("han_name").toString()) );
			memberObj.item("division", "" );
			memberObj.item("ogrd_code", filterStr(memberInfo.get("autt_code").toString()) );
			memberObj.item("position", "" );
			memberObj.item("job_code", filterStr(memberInfo.get("jwrk_code").toString()) );
			memberObj.item("job_name", "" );
			memberObj.item("email", filterStr(memberInfo.get("email").toString()) );
			memberObj.item("use_yn", "" );
			String hp1 = "";
			String hp2 = "";
			String hp3 = "";
			
			if(memberInfo.get("cela_tel").toString() != null && memberInfo.get("cela_tel").toString() != "")
			{
				String hp[] = filterStr( memberInfo.get("cela_tel").toString() ).split("-");
				
				if(hp.length==3)
				{
					hp1 = hp[0];
					hp2 = hp[1];
					hp3 = hp[2];
				}
				
				if(hp1.length()>3 || hp2.length() > 4 || hp3.length() > 4){
					hp1 = "";
					hp2 = "";
					hp3 = "";
				}
			}

			memberObj.item("hp1", hp1);
			memberObj.item("hp2", hp2);
			memberObj.item("hp3", hp3);
			
			memberObj.item("tel_num", "");
			memberObj.item("entering_dt", "");
			memberObj.item("jumin_no", "");
			
			if(cnt>0)
			{
				// System.out.println("###UPDATE###");
				// 엡데이트 신규 추가 (2021.02.22 spwlus, 기존에는 update문이 없이 insert만 있었음, 직무코드가 없어서 업데이트가 안됨)
				db.setCommand(
						"UPDATE TCB_PERSON "
					  + "   SET FIELD_SEQ = $field_seq$ " 
					  + "   , USER_NAME = $user_name$ "
					  + "   , DIVISION = $division$ "
					  + "   , OGRD_CODE = $ogrd_code$ "
					  + "   , POSITION = $position$ "
					  + "   , JOB_CODE = $job_code$ "
					  + "   , JOB_NAME = $job_name$ "
					  + "   , EMAIL = $email$ "
					  + "   , USE_YN = $use_yn$ "
					  + "   , HP1 = $hp1$ "
					  + "   , HP2 = $hp2$ " 
					  + "   , HP3 = $hp3$ "
					  + "   , TEL_NUM = $tel_num$ "
					  + "   , ENTERING_DT = $entering_dt$ "
					  + "   , JUMIN_NO = $jumin_no$ "
					  + " WHERE USER_EMPNO = $user_empno$ AND MEMBER_NO IN('20201000001', '20201000002')"
				, memberObj.record);
				
			}
			else
			{
				//System.out.println("###INSERT###");
				// 농심 갑(20201000001) INSERT
				person_seq = person_seq + 1;
				
				// 갑 INSERT(STATUS = 1)
				db.setCommand(
						"INSERT INTO TCB_PERSON( "
					  + " MEMBER_NO, PERSON_SEQ, USER_ID, JUMIN_NO, USER_NAME, POSITION, DIVISION, TEL_NUM, HP1, HP2, HP3, "
					  + " EMAIL, DEFAULT_YN, REG_DATE, REG_ID, USE_YN, USER_GUBUN, FIELD_SEQ, USER_LEVEL, AUTH_CD, STATUS, "
					  + " OGRD_CODE, JOB_CODE, JOB_NAME, USER_EMPNO, ENTERING_DT "
					  + " ) VALUES ( "
					  +	" '20201000001', " + person_seq + ", $user_id$, $jumin_no$, $user_name$, $position$, $division$, $tel_num$, $hp1$, $hp2$, $hp3$, "
					  + " $email$, 'N', TO_CHAR(SYSDATE, 'YYYYMMDDHHMMSS'), $user_id$, $use_yn$, '10', $field_seq$, '30', '0005', '1', "
					  + " $ogrd_code$, $job_code$, $job_name$, $user_empno$, $entering_dt$ "
					  + " )", memberObj.record);
				
				// 을 INSERT
				db.setCommand(
						"INSERT INTO TCB_PERSON( "
					  + " MEMBER_NO, PERSON_SEQ, USER_ID, JUMIN_NO, USER_NAME, POSITION, DIVISION, TEL_NUM, HP1, HP2, HP3, "
					  + " EMAIL, DEFAULT_YN, REG_DATE, REG_ID, USE_YN, USER_GUBUN, FIELD_SEQ, USER_LEVEL, AUTH_CD, "
					  + " OGRD_CODE, JOB_CODE, JOB_NAME, USER_EMPNO, ENTERING_DT "
					  + " ) VALUES ( "
					  +	" '20201000002', " + person_seq + ", $user_id$, $jumin_no$, $user_name$, $position$, $division$, $tel_num$, $hp1$, $hp2$, $hp3$, "
					  + " $email$, 'N', TO_CHAR(SYSDATE, 'YYYYMMDDHHMMSS'), $user_id$, $use_yn$, '10', $field_seq$, '30', '0005', "
					  + " $ogrd_code$, $job_code$, $job_name$, $user_empno$, $entering_dt$ "
					  + " )", memberObj.record);
			}
		}	
		
		if(!db.executeArray()){
			db.setError(db.getError());
			return false;
		}
		
		System.out.println("### updateNcomt005UserInfoList End ###");
		
		return true;
	}
	
	public String filterStr(String str){
		str = str.trim().replaceAll("^\"|\"$", "").replaceAll("\'", "");
		return str;
	}
}