package quartz;

import nicelib.groupware.KUserList;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class QuartzGetKUserListJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		
		System.out.println("[QuartzGetKUserListJob] Quartz kUser List Job Start");
		
		//K_USER_INFO 회원리스트
		KUserList kUserList = new KUserList();
		try {
			kUserList.updateKUserInfoList();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("[QuartzGetKUserListJob] Quartz kUser List Job End");
	}
}