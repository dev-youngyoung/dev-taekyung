package nicelib.groupware;

import java.util.Hashtable;

//import sun.org.mozilla.javascript.internal.regexp.SubString;

import nicelib.db.DB;
import nicelib.db.DataObject;
import nicelib.db.DataSet;

/**
 * K_USER_INFO 회원 목록 갱신을 위한 클래스
 * @author hmson
 */
public class KUserList{
	public boolean updateKUserInfoList() throws Exception{
		System.out.println("### updateKUserInfoList Start ###");
		int cnt = 0;
		// 현재 max person_seq 채번
		DataObject personDao = new DataObject("tcb_person");
		int person_seq =  Integer.parseInt(personDao.getOne("select nvl(max(person_seq),0) person_seq from tcb_person where member_no = '20201000001'"));
		
		// K_USER_INFO 조회 LIST 담기
		DataObject kuserObj = new DataObject("K_USER_INFO");
		DataSet kUserInfo = kuserObj.find("","*","user_empno");
		if (!kUserInfo.next()) {
			System.out.println("### K_USER_INFO DATA NOT FOUND ###");
			return false;
		}
		DB db = new DB();
		DataObject memberObj = new DataObject("tcb_person");
		for(int i=0; i< kUserInfo.size(); i++){
			// SELECT COUNT(*) TCB_PERSON 조회  / 아이디는 변경하여 가입이 가능하므로, 사원번호로 구분
			Hashtable memberInfo = ((Hashtable)kUserInfo.getRows().get(i));
			String userEmpNo = memberInfo.get("user_empno").toString();
			cnt = memberObj.findCount("USER_EMPNO = '"+ userEmpNo + "' AND MEMBER_NO IN('20201000001', '20201000002') ");
			
			memberObj = new DataObject("tcb_person");
			memberObj.item("user_empno", userEmpNo);
			memberObj.item("user_id", filterStr(memberInfo.get("user_id").toString()) );
			memberObj.item("field_seq", filterStr(memberInfo.get("dept_code").toString()) );
			memberObj.item("user_name", filterStr(memberInfo.get("user_name").toString()) );
			memberObj.item("division", filterStr(memberInfo.get("dept_name").toString()) );
			memberObj.item("ogrd_code", filterStr(memberInfo.get("ogrd_code").toString()) );
			memberObj.item("position", filterStr(memberInfo.get("ogrd_name").toString()) );
			memberObj.item("job_code", filterStr(memberInfo.get("job_code").toString()) );
			memberObj.item("job_name", filterStr(memberInfo.get("job_name").toString()) );
			memberObj.item("email", filterStr(memberInfo.get("email_id").toString()) );
			memberObj.item("use_yn", filterStr(memberInfo.get("user_status").toString()) );
			String hp1 = "";
			String hp2 = "";
			String hp3 = "";
			
			if(memberInfo.get("cel_no").toString() != null && memberInfo.get("cel_no").toString() != "")
			{
				String hp[] = filterStr( memberInfo.get("cel_no").toString() ).split("-");
				
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
			
			memberObj.item("tel_num", memberInfo.get("otel_no").toString());
			memberObj.item("entering_dt", memberInfo.get("entering_dt").toString());
			memberObj.item("jumin_no", "");
			memberObj.item("prio_dept_code", memberInfo.get("prio_dept_code").toString());
			
			if(cnt>0)
			{
				// System.out.println("###UPDATE###");
				db.setCommand(
						"UPDATE TCB_PERSON "
					  + "   SET DEPT_CODE = $field_seq$ " 
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
					  + "   , PRIO_DEPT_CODE = $prio_dept_code$ "
					  + " WHERE USER_EMPNO = $user_empno$ AND MEMBER_NO IN('20201000001', '20201000002')"
				, memberObj.record);
			}
			else
			{
				// System.out.println("###INSERT###");
				// 농심 갑(20201000001) INSERT
				person_seq = person_seq + 1;
				
				// 갑 INSERT(STATUS = 1)
				db.setCommand(
						"INSERT INTO TCB_PERSON( "
					  + " MEMBER_NO, PERSON_SEQ, USER_ID, JUMIN_NO, USER_NAME, POSITION, DIVISION, TEL_NUM, HP1, HP2, HP3, "
					  + " EMAIL, DEFAULT_YN, REG_DATE, REG_ID, USE_YN, USER_GUBUN, DEPT_CODE, USER_LEVEL, AUTH_CD, STATUS, "
					  + " OGRD_CODE, JOB_CODE, JOB_NAME, USER_EMPNO, ENTERING_DT, DEPT_YN, PRIO_DEPT_CODE "
					  + " ) VALUES ( "
					  +	" '20201000001', " + person_seq + ", $user_id$, $jumin_no$, $user_name$, $position$, $division$, $tel_num$, $hp1$, $hp2$, $hp3$, "
					  + " $email$, 'N', TO_CHAR(SYSDATE, 'YYYYMMDDHHMMSS'), $user_id$, $use_yn$, '10', $field_seq$, '30', '0005', '1', "
					  + " $ogrd_code$, $job_code$, $job_name$, $user_empno$, $entering_dt$, 'Y', $prio_dept_code$ "
					  + " )", memberObj.record);
				
				// 을 INSERT
				db.setCommand(
						"INSERT INTO TCB_PERSON( "
					  + " MEMBER_NO, PERSON_SEQ, USER_ID, JUMIN_NO, USER_NAME, POSITION, DIVISION, TEL_NUM, HP1, HP2, HP3, "
					  + " EMAIL, DEFAULT_YN, REG_DATE, REG_ID, USE_YN, USER_GUBUN, DEPT_CODE, USER_LEVEL, AUTH_CD, "
					  + " OGRD_CODE, JOB_CODE, JOB_NAME, USER_EMPNO, ENTERING_DT, DEPT_YN, PRIO_DEPT_CODE "
					  + " ) VALUES ( "
					  +	" '20201000002', " + person_seq + ", $user_id$, $jumin_no$, $user_name$, $position$, $division$, $tel_num$, $hp1$, $hp2$, $hp3$, "
					  + " $email$, 'N', TO_CHAR(SYSDATE, 'YYYYMMDDHHMMSS'), $user_id$, $use_yn$, '10', $field_seq$, '30', '0005', "
					  + " $ogrd_code$, $job_code$, $job_name$, $user_empno$, $entering_dt$, 'Y', $prio_dept_code$ "
					  + " )", memberObj.record);
			}
		}
		
		if(!db.executeArray()){
			db.setError(db.getError());
			return false;
		}
		
		System.out.println("### updateKUserInfoList End ###");
		
		return true;
	}
	
	public String filterStr(String str){
		str = str.trim().replaceAll("^\"|\"$", "").replaceAll("\'", "");
		return str;
	}
}