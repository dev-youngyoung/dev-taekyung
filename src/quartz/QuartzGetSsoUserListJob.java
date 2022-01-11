package quartz;

import nicelib.groupware.SsoUserList;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class QuartzGetSsoUserListJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		
		System.out.println("[QuartzGetSsoUserListJob] Quartz SsoUser List Job Start");
		
		//SSO 회원리스트
		SsoUserList ssoUserList = new SsoUserList();
		try {
			ssoUserList.updateSsoUserInfoList();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("[QuartzGetSsoUserListJob] Quartz SsoUser List Job End");
	}
}