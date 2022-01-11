package quartz;

import nicelib.groupware.KUserList;
import nicelib.groupware.Ncomt005UserList;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class QuartzGetNcomt005UserListJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		
		System.out.println("[QuartzGetNcomt005UserListJob] Quartz ncomt005User List Job Start");
		
		//NCOMT005  회원리스트
		Ncomt005UserList ncomt005UserList = new Ncomt005UserList();
		try {
			ncomt005UserList.updateNcomt005UserInfoList();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println("[QuartzGetNcomt005UserListJob] Quartz ncomt005User List Job End");
	}
}