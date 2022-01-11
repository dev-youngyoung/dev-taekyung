package quartz;

import nicelib.groupware.CustomerList;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class QuartzGetCustomerListJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		
		System.out.println("[QuartzGetCustomerListJob] Quartz Customer List Job Start");
		
		// 거래처 목록 갱신 프로세스 추가
		/*CustomerList customerList = new CustomerList();
		boolean result = customerList.getCustomerList();
		
		System.out.println("[QuartzGetCustomerListJob] Quartz Customer List Job result : " + result);*/
		
		System.out.println("[QuartzGetCustomerListJob] Quartz Customer List Job End");
	}
}