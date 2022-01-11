package	procure.common.utils; 

import java.util.StringTokenizer;

/**
 * 금액 단위 관련 class
 * @author 원두영
 *
 */
public class MoneyUtil {
	public final static String MONEY_NUM[] = {"","일","이","삼","사","오","육","칠","팔", "구"};
	public final static String MONEY_DANWI[] = {"", "만","억","조","경"};
	public final static String MONEY_DETAIL[] = {"","십","백","천"};
	
	public static String getCommaMoney(long money){
		String sSign = "";
		long tMoney;
		
		if(money < 0)
		{
			sSign = "-";
			tMoney = money * -1;
		}
		else
		{
			tMoney = money;
		}
		if(tMoney / 1000 <= 0) return new Long(money).toString();
		StringBuffer buffer = new StringBuffer(new Long(tMoney).toString());
		int length = buffer.length();
		int count=1;
		for(int i=length-1; i > 0; i--){
			if(count % 3 == 0) buffer.insert(i, ',');
			count++;
		}
		return sSign + buffer.toString();
	}
	
	/**
	 * @author 박이수
	 * @param money
	 * @return
	 */
	public static String getCommaMoney(String money){
		if(money == null || "".equals(money)) return "";
		return getCommaMoney(Double.valueOf(money).longValue());
	}
	
	public static String getCommaMoney(double money){
		int umoney = Integer.parseInt((money+"").split("\\.")[1]); 
		long lmoney = Long.parseLong((money+"").split("\\.")[0]);
		if(umoney>0){
			return getCommaMoney(lmoney)+"."+umoney;
		}else{
			return getCommaMoney(lmoney);
		}
		
	}
	
	public static long getEscapeMoney(String commaMoney){
		if(commaMoney == null) return 0;
		StringBuffer buffer = new StringBuffer();
		StringTokenizer token = new StringTokenizer(commaMoney,",");
		while(token.hasMoreTokens()){
			String tmp = token.nextToken();
			buffer.append(tmp);
		}
		return Long.valueOf(buffer.toString()).longValue();
	}
	
	public static String getHanMoney(long money){
		if(money == 0) return "영";
		char [] source = new Long(money).toString().toCharArray();
		StringBuffer buf = new StringBuffer();
		boolean flag = false;
		for(int i= 0; i < source.length; i++){
			if(i==0 && source[i]== '-')
			{
				buf.append("감 ");
				continue;
			}
			int val = source[i]-48;
			buf.append(MONEY_NUM[val]);
			int detail = (source.length -1 - i) % 4;
			
			if(!MONEY_NUM[val].equals("")){
				buf.append(MONEY_DETAIL[detail]);
				flag = true;
			}
			int danwi = (source.length -1 - i) / 4;
			if(detail == 0 && danwi > 0 && flag){
				buf.append(MONEY_DANWI[danwi]);
				flag=false;
			}
			
		}
		return buf.toString();
	}
	
}
