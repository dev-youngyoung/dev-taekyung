package procure.common.utils;

import java.text.*;
/**
 *<pre>
 *
 * ���ϸ� : NumUtil
 * ��   �� : ���� ���� ó�� ��ƿ
 *	���� �ۼ���	: 2000. 06. 08
 * Comments	: ���� ���� ��ƿ
 * @version	: 1.0
 * ��������		: 
 *
 *</pre>
 */

public class NumUtil
{
	/**	Null�� 0���� �ٲ۴�	*/
	public static Double Null2Zero(Double pValue)
	{
		Double zValue = new Double(0);
		if (pValue == null)
			return  zValue;
		else
		   return pValue;
	}


	/** ������ �տ� 0 SET. */
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

	/** ���ڿ� �޸� �ֱ� */
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


	/** Double�� ���ڸ� �޾Ƽ� ������ */
	public static double dDivide(double dNum1,double dNum2)
	{
		if (dNum1==0.0) return 0.0;
		return dNum1/dNum2;
	}


	//double�� �ڸ����� ���� �ݿø�, �ø�, ����
	public static double decimal_ctl(double value, int place, int type) { //place ���� ������ ���� �ڸ����� ����� ó�� �߰��ؾ���()
		if(value == 0)
			return 0 ;

		double multi = 1 ;
		if(place < 0 ) {		//�Ҽ��� ����
			place = place+1 ;
			while (place++ < 0) 
				multi *= 10.0; 
		}else{					//�Ҽ��� �̻�
			while (place-- > 0)
				multi /= 10.0; 
		}
		switch(type) {
			case 1 :			//�ݿø�
				return Math.round(value * multi)/ multi;	//���Ϲ޴� �ʿ��� int������ ����ȯ �ʿ�
			case 2 :					//�ø�
				return Math.ceil(value * multi)/ multi;		
			case 3 :					//����
				return Math.floor(value * multi)/ multi;	
			default :					//�ƹ��͵� �ƴҶ�
				return value ;
		}
	}

	public static String decimal_ctl1(double value, int place, int type) { //place ���� ������ ���� �ڸ����� ����� ó�� �߰��ؾ���()
		return Double.toString(decimal_ctl(value, place, type));
	}

	/** Double�� ���ڸ� �޾Ƽ� �Ҽ����ڸ� ���ο� ���� �Ҽ��� �ڸ��� �����ϱ� 
	    ������ FormatNum �Լ��� ������*/
	public static String FormatNum(double dNum, int digit)
	{
		NumberFormat myFormat = NumberFormat.getInstance();
		String sSosu = Double.toString(dNum);		
		int nCnt = 0;		
		if (sSosu.equals("0.0") || digit == 0)
		{//���� 0 �̰ų� �ҽ������� �ڸ����� 0���� �Ͽ����� �Ҽ����ڸ����� ������ 0�̴�.
			myFormat.setMaximumFractionDigits(0);
			myFormat.setMinimumFractionDigits(0);
			return myFormat.format(dNum);
		}
		else
		{			
			nCnt = sSosu.substring(sSosu.indexOf(".")+1,sSosu.length()).length();
			if (nCnt == 1)
			{//�Ҽ����ڸ����� 1���ϰ��
				if (sSosu.substring(sSosu.length()-1,sSosu.length()).equals("0"))
				{//���ڸ��� 0 �϶��� �ڸ����� 0(�������� ��Ʈ������ ��ȯ�ÿ� ���������� �Ҽ����� �⺻���� �ٴ´�.)
					digit = 0;						
				}
				else
				{//���ڸ��� 0�� �ƴ϶�� �Ҽ����� �ִٴ� �ֱ�, �� �ڸ����� ������ �Ѵ�. 
				 //��, ���� �Ҽ����ڸ����� ������� �� �ҽ��󿡼��� �ڸ����� �������� �Ѵ�. 
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
