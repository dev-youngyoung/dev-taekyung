package nicelib.groupware;

import java.util.Hashtable;

import nicelib.db.DB;
import nicelib.db.DataObject;
import nicelib.db.DataSet;

/**
 * 판매처(영업시스템) 목록 갱신을 위한 클래스
 * @author hmson
 */
public class SellerList{
	public boolean updateSellerInfoList() throws Exception{
		System.out.println("### updateSellerInfoList Start ###");
		//현재 max member_no 채번
		DataObject memberDao = new DataObject("tcb_member");
		double member_no = Double.parseDouble(memberDao.getOne(
				" SELECT MAX(MEMBER_NO) AS MEMBER_NO FROM( "
			   +	" SELECT TO_CHAR(SYSDATE, 'yyyymm') || LPAD( (NVL(MAX(SUBSTR(member_no, 7)), 0) ),5,'0' ) member_no "
			   +	" FROM TCB_MEMBER WHERE  member_no like TO_CHAR(SYSDATE, 'YYYYMM')||'"+"%' "
			   +	" UNION "
			   +	" SELECT TO_CHAR(SYSDATE, 'yyyymm') || LPAD( (NVL(MAX(SUBSTR(member_no, 7)), 0) ),5,'0' ) member_no "
			   +	" FROM IF_MMBAT100 WHERE  member_no like TO_CHAR(SYSDATE, 'YYYYMM')||'"+"%' "
			   +")"
				));
		// System.out.println("현재 Max Member_no :::::::::: " + member_no);
		
		// ECS_CUSTOMER_V 조회 LIST 담기
		DataObject custObj = new DataObject("ECS_CUSTOMER_V");
		DataSet custV = custObj.find("","*","cust_code");
		if (!custV.next()) {
			System.out.println("### ECS_CUSTOMER_V DATA NOT FOUND ###");
			return false;
		}
		
		DB db = new DB();
		DataObject ifMmObj = new DataObject("IF_MMBAT100");
		
		int cnt = 0;
		String cust_code = "";
		
		for(int i=0; i< custV.size(); i++){
			// SELECT COUNT(*) IF_MMBAT100 조회
			Hashtable custInfo = ((Hashtable)custV.getRows().get(i));
			cust_code = custInfo.get("cust_code").toString();
			cnt = ifMmObj.findCount("CUST_CODE = '"+ cust_code + "' AND IF_GUBN = '01'");
			
			ifMmObj = new DataObject("IF_MMBAT100");
			ifMmObj.item("cust_code", cust_code);
			ifMmObj.item("comm_no", custInfo.get("biz_no"));
			ifMmObj.item("com_name", filterStr(custInfo.get("cust_name").toString()) );
			ifMmObj.item("boss_name", filterStr(custInfo.get("biz_name").toString()) );
			ifMmObj.item("head_ofce_post", filterStr(custInfo.get("post_no").toString()) );
			ifMmObj.item("head_ofce_adrs", filterStr(custInfo.get("addr").toString()) );
			
			if(cnt>0)
			{
				// System.out.println("###UPDATE###");
				db.setCommand(
						  "UPDATE IF_MMBAT100 "
					    + "   SET COMM_NO = $comm_no$ "
						+ "	  , COM_NAME = $com_name$ "		  
					    + "   , BOSS_NAME = $boss_name$ "
					    + "   , HEAD_OFCE_POST = $head_ofce_post$ "
					    + "   , HEAD_OFCE_ADRS = $head_ofce_adrs$ "
					    + " WHERE CUST_CODE = $cust_code$ AND IF_GUBN = '01'"
					    , ifMmObj.record);
			}
			else
			{
				// System.out.println("###INSERT###");
				member_no = member_no + 1;
				db.setCommand(
						  "INSERT INTO IF_MMBAT100( "
					    + " CUST_CODE, COMM_NO, COM_NAME, BOSS_NAME, HEAD_OFCE_POST, HEAD_OFCE_ADRS, "
					    + " IF_GUBN, MEMBER_NO "
					    + " ) VALUES ( " + "\n"
					    + " $cust_code$, $comm_no$, $com_name$, $boss_name$, $head_ofce_post$, $head_ofce_adrs$, "
					    + "'01'" + ", " + Double.toString(member_no)
					    + " )", ifMmObj.record);
			}
		}
		
		if(!db.executeArray()){
			db.setError(db.getError());
			return false;
		}
		
		System.out.println("### updateSellerInfoList End ###");
		return true;
	}
	
	public String filterStr(String str){
		str = str.trim().replaceAll("^\"|\"$", "").replaceAll("\'", "");
		return str;
	}
}