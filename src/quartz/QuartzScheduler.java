package quartz;

import static org.quartz.CronScheduleBuilder.dailyAtHourAndMinute;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.SimpleScheduleBuilder.simpleSchedule;
import static org.quartz.TriggerBuilder.newTrigger;
import static org.quartz.CronScheduleBuilder.cronSchedule;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.Trigger;
import org.quartz.impl.StdSchedulerFactory;

public class QuartzScheduler implements ServletContextListener {

	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		// TODO Auto-generated method stub
	}

	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		try {
			SchedulerFactory schedulerFactory = new StdSchedulerFactory();
			Scheduler scheduler = schedulerFactory.getScheduler();
			
			//공급처(구매시스템) 리스트 갱신 잡 (오전 2시)
			JobDetail supplierJob = newJob(QuartzGetSupplierListJob.class)
					.withIdentity("supplierJob", "group1")
					.build();
			
			Trigger supplierTrigger = newTrigger()
			    .withIdentity("supplierTrigger", "group1")
			    .withSchedule(cronSchedule("0 0 2 * * ? *"))
			    .forJob(supplierJob)
			    .build();
			
			//판매처(영업시스템) 리스트 갱신 잡 (오전 2시 30분)
			JobDetail sellerJob = newJob(QuartzGetSellerListJob.class)
					.withIdentity("sellerJob", "group2")
					.build();
			
			Trigger sellerTrigger = newTrigger()
				    .withIdentity("sellerTrigger", "group2")
				    .withSchedule(cronSchedule("0 30 2 * * ? *"))
				    .forJob(sellerJob)
				    .build();
			
			//SSO 리스트 갱신 잡 (오전 3시)
			JobDetail ssoUserJob = newJob(QuartzGetSsoUserListJob.class)
					.withIdentity("ssoUserJob", "group3")
					.build();
			
			Trigger ssoUserTrigger = newTrigger()
				    .withIdentity("ssoUserTrigger", "group3")
				    .withSchedule(cronSchedule("0 0 3 * * ? *"))
				    .forJob(ssoUserJob)
				    .build();
			
			//K_USER_INFO 리스트 갱신 잡 (오전 3시 30분)
			JobDetail kUserJob = newJob(QuartzGetKUserListJob.class)
					.withIdentity("kUserJob", "group4")
					.build();
			
			Trigger kUserTrigger = newTrigger()
				    .withIdentity("kUserTrigger", "group4")
				    .withSchedule(cronSchedule("0 30 3 * * ? *"))
				    .forJob(kUserJob)
				    .build();

			//NCOMT005 리스트 갱신 잡 (오전4시 00분)
			JobDetail ncomt005UserJob = newJob(QuartzGetNcomt005UserListJob.class)
					.withIdentity("ncomt005UserJob", "group5")
					.build();
			
			Trigger ncomt005UserTrigger = newTrigger()
				    .withIdentity("ncomt005UserTrigger", "group5")
				    .withSchedule(cronSchedule("0 0 4 * * ? *"))
				    .forJob(ncomt005UserJob)
				    .build();

			scheduler.scheduleJob(supplierJob, supplierTrigger);
			scheduler.scheduleJob(sellerJob, sellerTrigger);
			scheduler.scheduleJob(ssoUserJob, ssoUserTrigger);
			scheduler.scheduleJob(kUserJob, kUserTrigger);
			scheduler.scheduleJob(ncomt005UserJob, ncomt005UserTrigger);
			
			scheduler.start();
			
		} catch (SchedulerException se) {
			se.printStackTrace();
		}
	}
}