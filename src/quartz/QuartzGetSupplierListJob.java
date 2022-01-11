package quartz;

import nicelib.groupware.SupplierList;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class QuartzGetSupplierListJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		
		System.out.println("[QuartzGetSupplierListJob] Quartz Supplier List Job Start");
		
		//구매시스템(공급처) 목록 갱신
		SupplierList supList = new SupplierList();
		try {
			supList.updateSupplierInfoList();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("[QuartzGetSupplierListJob] Quartz Supplier List Job End");
	}
}