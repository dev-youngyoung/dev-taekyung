package procure.common.utils;

import java.text.*;
/**
 *<pre>
 *
 * 파일명 : NumUtil
 * 기   능 : 숫자 관련 처리 유틸
 *	최초 작성일	: 2000. 06. 08
 * Comments	: 숫자 관련 유틸
 * @version	: 1.0
 * 수정내역		: 
 *
 *</pre>
 */

public class NumUtil
{
	/**	Null을 0으로 바꾼다	*/
	public static Double Null2Zero(Double pValue)
	{
		Double zValue = new Double(0);
		if (pValue == null)
			return  zValue;
		else
		   return pValue;
	}


	/** 숫자형 앞에 0 SET. */
	public static String formatZero(String str, int nNum) 
	{  
		int iCnt = 0;  	
		if (str == null || str.equals("")) 
		{	
			str = "1";
			for(int i=iCnt;i<nNum;i++)
			{
				str = "0" + str;
			}
			return str;
		}else
		{
			iCnt = str.length();
			for(int i=iCnt;i<nNum;i++)
			{
				str = "0" + str;
			}
			return str;
		}
	}   

	/** 숫자에 콤마 넣기 */
	public static String sAddComma(String sData, boolean bEdit) 
	{		
		if (sData==null) 
		{
			if (bEdit) return "";
			else return "&nbsp;";
		}
		
		String sSumdata = "";          
		int j=0 ;
		
		if ((sData != "") && (sData.indexOf(",") < 0) && (sData.length() > 3)) 
		{
			for (int i = sData.length()-1; i >= 0 ; i-- ) 
			{
				if (sData.substring(i,i+1).equals(".") || sData.substring(i,i+1).equals("-")) 	j=-1;		
				else if (j == 3) 
				{
					sSumdata = "," + sSumdata ;
					j = 0 ;
				}
				sSumdata = sData.substring(i,i+1) + sSumdata ;
				j++ ;
			}
			return sSumdata ;
		}   
		else { return sData ; }
	}


	/** Double형 숫자를 받아서 나누기 */
	public static double dDivide(double dNum1,double dNum2)
	{
		if (dNum1==0.0) return 0.0;
		return dNum1/dNum2;
	}


	//double형 자리수에 따른 반올림, 올림, 버림
	public static double decimal_ctl(double value, int place, int type) { //place 값이 변경할 값의 자리수를 벗어날때 처리 추가해야함()
		if(value == 0)
			return 0 ;

		double multi = 1 ;
		if(place < 0 ) {		//소수점 이하
			place = place+1 ;
			while (place++ < 0) 
				multi *= 10.0; 
		}else{					//소수점 이상
			while (place-- > 0)
				multi /= 10.0; 
		}
		switch(type) {
			case 1 :			//반올림
				return Math.round(value * multi)/ multi;	//리턴받는 쪽에서 int형으로 형변환 필요
			case 2 :					//올림
				return Math.ceil(value * multi)/ multi;		
			case 3 :					//버림
				return Math.floor(value * multi)/ multi;	
			default :					//아무것도 아닐때
				return value ;
		}
	}

	public static String decimal_ctl1(double value, int place, int type) { //place 값이 변경할 값의 자리수를 벗어날때 처리 추가해야함()
		return Double.toString(decimal_ctl(value, place, type));
	}

	/** Double형 숫자를 받아서 소수점자리 여부에 따라 소숫점 자릿수 설정하기 
	    기존의 FormatNum 함수를 수정함*/
	public static String FormatNum(double dNum, int digit)
	{
		NumberFormat myFormat = NumberFormat.getInstance();
		String sSosu = Double.toString(dNum);		
		int nCnt = 0;		
		if (sSosu.equals("0.0") || digit == 0)
		{//값이 0 이거나 소스에서의 자릿수를 0으로 하였으면 소숫점자릿수는 무조건 0이다.
			myFormat.setMaximumFractionDigits(0);
			myFormat.setMinimumFractionDigits(0);
			return myFormat.format(dNum);
		}
		else
		{			
			nCnt = sSosu.substring(sSosu.indexOf(".")+1,sSosu.length()).length();
			if (nCnt == 1)
			{//소수점자릿수가 1개일경우
				if (sSosu.substring(sSosu.length()-1,sSosu.length()).equals("0"))
				{//끝자리가 0 일때는 자릿수는 0(더블형을 스트링으로 전환시에 정수일지라도 소수점이 기본으로 붙는다.)
					digit = 0;						
				}
				else
				{//끝자리가 0이 아니라면 소숫점이 있다는 애기, 즉 자릿수를 잡아줘야 한다. 
				 //단, 실제 소숫점자릿수는 상관없이 각 소스상에서의 자릿수를 기준으로 한다. 
					if (digit > 0)
						digit = 1; 
				}
			}
			else if (nCnt == 2)
			{
				if (digit > 1)					
					digit = 2;
			}
			else if (nCnt > 2)
			{
				if (digit > 2)					
					digit = 3;
			}
			myFormat.setMaximumFractionDigits(digit);
			myFormat.setMinimumFractionDigits(digit);
			return myFormat.format(dNum);
		}
	}
	
	public static String delComma(String commaVal){
		return commaVal.replaceAll(",", "");
	}	

}
