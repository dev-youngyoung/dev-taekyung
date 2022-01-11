package nicelib.groupware;

import nicelib.db.DataObject;

/**
 * 거래처 목록 처리를 위한 클래스
 * @author sjlee
 */
public class CustomerList {
	
	public boolean getCustomerList() {
		
		boolean result = false;
		
		System.out.println("[CustomerList][getCustomerList] getCustomerList Start");
		
		DataObject customerDao = new DataObject("if_mmbat100");
		boolean delResult = customerDao.deleteAll();
		
		System.out.println("[CustomerList][getCustomerList] delete all data from if_mmbat100 : " + delResult);
		
		if (delResult) {
			
		}
		
		System.out.println("[CustomerList][getCustomerList] getCustomerList result : " + result);
		
		System.out.println("[CustomerList][getCustomerList] getCustomerList End");
		
		return result;
	}
}