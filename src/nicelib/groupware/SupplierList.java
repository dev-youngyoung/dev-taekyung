package nicelib.groupware;

import java.util.Hashtable;

import nicelib.db.DB;
import nicelib.db.DataObject;
import nicelib.db.DataSet;

/**
 * 구매시스템(공급처) 목록 갱신을 위한 클래스
 * @author hmson
 */
public class SupplierList{
	public boolean updateSupplierInfoList() throws Exception{
		System.out.println("### updateSupplierInfoList Start ###");
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
		//System.out.println("현재 Max Member_no :::::::::: " + member_no);
		
		// NAMM.VMMBAT100 조회 LIST 담기
		DataObject dataObj = new DataObject("VMMBAT100");
		DataSet mmbat = dataObj.find("","*","cust_code");
		if (!mmbat.next()) {
			System.out.println("### VMMBAT100 DATA NOT FOUND ###");
			return false;
		}
		
		DB db = new DB();
		DataObject ifMmObj = new DataObject("IF_MMBAT100");
		
		int cnt = 0;
		String custCode = "";
		
		for(int i=0; i< mmbat.size(); i++){
			// SELECT COUNT(*) IF_MMBAT100 조회
			Hashtable custInfo = ((Hashtable)mmbat.getRows().get(i));
			custCode = custInfo.get("cust_code").toString();
			cnt = ifMmObj.findCount("CUST_CODE = '"+ custCode + "' AND IF_GUBN = '02'");
			
			ifMmObj = new DataObject("IF_MMBAT100");
			ifMmObj.item("cust_code", custCode);
			ifMmObj.item("comm_no", filterStr(custInfo.get("comm_no").toString()) );
			ifMmObj.item("jumin_no",  filterStr(custInfo.get("jumin_no").toString()).replaceAll("[^0-9]","") );
			ifMmObj.item("com_name",  filterStr(custInfo.get("com_name").toString()) );
			ifMmObj.item("main_cust_code",  filterStr(custInfo.get("main_cust_code").toString()) );
			ifMmObj.item("cust_gubn", filterStr(custInfo.get("cust_gubn").toString()) );
			ifMmObj.item("cust_gubn_name", filterStr(custInfo.get("cust_gubn_name").toString()) );
			ifMmObj.item("boss_name", filterStr(custInfo.get("boss_name").toString()) );
			ifMmObj.item("boss_tel", filterStr(custInfo.get("boss_tel").toString()) );
			ifMmObj.item("biz_type", filterStr(custInfo.get("biz_type").toString()) );
			ifMmObj.item("site_item", filterStr(custInfo.get("site_item").toString()) );
			ifMmObj.item("head_ofce_adrs", filterStr(custInfo.get("head_ofce_adrs").toString()) );
			ifMmObj.item("sale_chap", filterStr(custInfo.get("sale_chap").toString()) );
			ifMmObj.item("head_ofce_fax", filterStr(custInfo.get("head_ofce_fax").toString()) );
			ifMmObj.item("head_ofce_post", filterStr(custInfo.get("head_ofce_post").toString()) );
			ifMmObj.item("tax_shet_gubn", filterStr(custInfo.get("tax_shet_gubn").toString()) );
			ifMmObj.item("writ_date", filterStr(custInfo.get("writ_date").toString()) );
			ifMmObj.item("writ_emp_no", filterStr(custInfo.get("writ_emp_no").toString()) );
			ifMmObj.item("stop_date", filterStr(custInfo.get("stop_date").toString()) );
			ifMmObj.item("if_flag", filterStr(custInfo.get("if_flag").toString()) );
			ifMmObj.item("if_date", filterStr(custInfo.get("if_date").toString()) );
			ifMmObj.item("if_time", filterStr(custInfo.get("if_time").toString()) );
			ifMmObj.item("boss_mobl", filterStr(custInfo.get("boss_mobl").toString()) );
			ifMmObj.item("sale_chap_mobl", filterStr(custInfo.get("sale_chap_mobl").toString()) );
			ifMmObj.item("cust_grup", filterStr(custInfo.get("cust_grup").toString()) );
			ifMmObj.item("insp_grup", filterStr(custInfo.get("insp_grup").toString()) );
			ifMmObj.item("corp_reg_no", filterStr(custInfo.get("corp_reg_no").toString()) );
			ifMmObj.item("prch_grup", filterStr(custInfo.get("prch_grup").toString()) );
			ifMmObj.item("strt_date", filterStr(custInfo.get("strt_date").toString()) );
			
			if(cnt>0)
			{
				// System.out.println("###UPDATE###");
				db.setCommand(
						  "UPDATE IF_MMBAT100 "
						+ "   SET COMM_NO = $comm_no$ "
						+ "   , JUMIN_NO = $jumin_no$ "
						+ "   , COM_NAME = $com_name$ "
						+ "   , MAIN_CUST_CODE = $main_cust_code$ "
						+ "   , CUST_GUBN = $cust_gubn$ "
						+ "   , CUST_GUBN_NAME = $cust_gubn_name$ "
						+ "   , BOSS_NAME = $boss_name$ "
						+ "   , BOSS_TEL = $boss_tel$ "
						+ "   , BIZ_TYPE = $biz_type$ "
						+ "   , SITE_ITEM = $site_item$ "
						+ "   , HEAD_OFCE_ADRS = $head_ofce_adrs$ "
						+ "   , SALE_CHAP = $sale_chap$ "
						+ "   , HEAD_OFCE_FAX = $head_ofce_fax$ "
						+ "   , HEAD_OFCE_POST = $head_ofce_post$ "
						+ "   , TAX_SHET_GUBN = $tax_shet_gubn$ "
						+ "   , WRIT_DATE = $writ_date$ "
						+ "   , WRIT_EMP_NO = $writ_emp_no$ "
						+ "   , STOP_DATE = $stop_date$ "
						+ "   , IF_FLAG = $if_flag$ "
						+ "   , IF_DATE = $if_date$ "
						+ "   , IF_TIME = $if_time$ "
						+ "   , BOSS_MOBL = $boss_mobl$ "
						+ "   , SALE_CHAP_MOBL = $sale_chap_mobl$ "
						+ "   , CUST_GRUP = $cust_grup$ "
						+ "   , INSP_GRUP = $insp_grup$ "
						+ "   , CORP_REG_NO = $corp_reg_no$ "
						+ "   , PRCH_GRUP = $prch_grup$ "
						+ "   , STRT_DATE = $strt_date$ "
						+ " WHERE CUST_CODE = $cust_code$ AND IF_GUBN = '02'"
						, ifMmObj.record);
			}
			else
			{
				//System.out.println("###INSERT###");
				member_no = member_no + 1;
				db.setCommand(
						  "INSERT INTO IF_MMBAT100( "
						+ " CUST_CODE, COMM_NO, JUMIN_NO, COM_NAME, MAIN_CUST_CODE, CUST_GUBN, CUST_GUBN_NAME, BOSS_NAME, BOSS_TEL, BIZ_TYPE, "	
						+ " SITE_ITEM, HEAD_OFCE_ADRS, SALE_CHAP, HEAD_OFCE_FAX, HEAD_OFCE_POST, TAX_SHET_GUBN, WRIT_DATE, WRIT_EMP_NO, STOP_DATE, "	
						+ " IF_FLAG, IF_DATE, IF_TIME, BOSS_MOBL, SALE_CHAP_MOBL, CUST_GRUP, INSP_GRUP, CORP_REG_NO, PRCH_GRUP, STRT_DATE, "	
						+ " IF_GUBN, MEMBER_NO "	
						+ " ) VALUES ( " + "\n"
						+ " $cust_code$, $comm_no$, $jumin_no$, $com_name$, $main_cust_code$, $cust_gubn$, $cust_gubn_name$, $boss_name$, $boss_tel$, $biz_type$, "
						+ " $site_item$, $head_ofce_adrs$, $sale_chap$, $head_ofce_fax$, $head_ofce_post$, $tax_shet_gubn$, $writ_date$, $writ_emp_no$, $stop_date$, "
						+ " $if_flag$, $if_date$, $if_time$, $boss_mobl$, $sale_chap_mobl$, $cust_grup$, $insp_grup$, $corp_reg_no$, $prch_grup$, $strt_date$, "
						+ "'02'" + ", " + Double.toString(member_no)
						+ " )", ifMmObj.record);
			}
		}
		
		if(!db.executeArray()){
			db.setError(db.getError());
			return false;
		}
		
		System.out.println("### updateSupplierInfoList End ###");
		return true;
	}
	
	public String filterStr(String str){
		str = str.trim().replaceAll("^\"|\"$", "").replaceAll("\'", "");
		return str;
	}
}