package quartz;

import nicelib.groupware.SellerList;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class QuartzGetSellerListJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		
		System.out.println("[QuartzGetSellerListJob] Quartz Seller List Job Start");
		
		//영업시스템(판매처)
		SellerList selList = new SellerList();
		try {
			selList.updateSellerInfoList();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("[QuartzGetSellerListJob] Quartz Seller List Job End");
	}
}