package procure.common.utils;

public class TaxUtil {
	// 사업자 번호 반환0:원래번호,1:첫째, 2:둘째, 3:셋째
	public static String [] getBizNum4Arr(String sBizNum){
		String [] returnVal = new String[4];
		if(sBizNum == null || sBizNum.length() != 10){
			returnVal[0]=sBizNum;
			returnVal[1]="";
			returnVal[2]="";
			returnVal[3]="";
			
			return returnVal;
		}
		
		returnVal[0]=sBizNum;
		returnVal[1]=returnVal[0].substring(0, 3);
		returnVal[2]=returnVal[0].substring(3, 5);
		returnVal[3]=returnVal[0].substring(5); 
		
		return returnVal;
	}
	
	public static String getBizNum4Dis(String sBizNum, String mask){
		String[] biznumArr = getBizNum4Arr(sBizNum);
		
		return biznumArr[1] + mask + biznumArr[2] + mask + biznumArr[3];
	}
	
	public static String getEditCdSub(String taxEditCd){
		String editCdSub = "00";
		if(taxEditCd == null || taxEditCd.length() != 2){
			return editCdSub;
		}
		
		if(taxEditCd.equals("01")){
			editCdSub = "01";
		}else if(taxEditCd.equals("06")){
			editCdSub = "02";
		}else if(taxEditCd.equals("07")){
			editCdSub = "03";
		}else{
			editCdSub = "00";
		}
		
		return editCdSub;
		
	}
	
	public static void main(String[] args){
		
	}
}
