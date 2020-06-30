package nicednb.datasend;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import procure.common.db.SQLManager;
import procure.common.utils.Security;
import procure.common.utils.StrUtil;
import procure.common.value.DataSetValue;
import procure.common.value.QueryManager;
import procure.common.value.SQLJob;

public class DocuSendManager {
	private	String	sVendCd		=	"";	//	���۾�ü����ڹ�ȣ
	private	String	sVendIpAddr	=	"";	//	���۾�üIP
	private	String	sRegDate	=	"";	//	��ȸ��û����
	private	String	sErrMag		=	"";	//	�����޽���		
	
	/**
	 * �Ķ��Ÿ �� �ޱ�
	 * @param request
	 * @throws Exception
	 */
	public void setRequest(HttpServletRequest request) throws Exception
	{
		try {
			String	_sVendCd		=	StrUtil.chkNull(request.getParameter("vend_cd"), "");
			String	_sVendIpAddr	=	StrUtil.chkNull(request.getParameter("vend_ip_addr"), "");
			String	_sRegDate		=	StrUtil.chkNull(request.getParameter("req_date"), "");
			
			if(!_sVendCd.equals(""))
			{
				this.setVendCd(Security.AESdecrypt(_sVendCd));
			}else
			{
				throw new Exception("����ڹ�ȣ�� ���۵��� �ʾҽ��ϴ�.");
			}
			
			if(!_sVendIpAddr.equals(""))
			{
				this.setVendIpAddr(Security.AESdecrypt(_sVendIpAddr));
			}else
			{
				throw new Exception("����IP�� ���۵��� �ʾҽ��ϴ�.");
			}
			
			if(!_sRegDate.equals(""))
			{
				this.setRegDate(Security.AESdecrypt(_sRegDate));
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass().getName() + ".setRequest()] :" + e.toString());
			throw new Exception(e.toString());
		}
	}
	
	/**
	 * ���Ż���� ���ۿ��� üũ
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public boolean chkSend(HttpServletRequest request) throws Exception
	{
		boolean	bChk	=	true;
		SQLJob	sqlj	=	null;
		try {
			this.setRequest(request);
			
			sqlj = new SQLJob("send_chk.xml",true); // 107-86-24874
			sqlj.setParam("vend_cd", this.getVendCd());
			
			DataSetValue	dsv	=	sqlj.getOneRow("vend_info_chk");
			
			if(dsv == null || dsv.size() == 0)
			{
				bChk	=	false;
				throw new Exception("�ش� �����["+this.getVendCd()+"]�� ���������� ���̽���ť�� ��ϵǾ� ���� �ʽ��ϴ�.");
			}else
			{
				if(!dsv.getString("vend_use_yn").equals("Y"))
				{
					bChk	=	false;
					throw new Exception("�ش� �����["+this.getVendCd()+"]�� ��������� �Ǿ� ���� �ʽ��ϴ�.");
				}
				
				if(!this.getVendIpAddr().equals(dsv.getString("vend_ip_addr")))
				{
					bChk	=	false;
					throw new Exception("��ϵ� �ش� �����["+this.getVendCd()+"]�� IP["+dsv.getString("vend_ip_addr")+"]�� ���۵� IP["+this.getVendIpAddr()+"]�� ��ġ���� �ʽ��ϴ�.");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass().getName() + ".chkSend()] :" + e.toString());
			bChk	=	false;
			throw new Exception(e.toString());
		}finally
		{
			sqlj.close();
		}
		return	bChk;
	}
	
	public String	getVendCd()
	{
		return	this.sVendCd;
	}
	
	public void	setVendCd(String sVendCd)
	{
		this.sVendCd	=	sVendCd;
	}
	
	
	public String	getVendIpAddr()
	{
		return	this.sVendIpAddr;
	}
	
	public void	setVendIpAddr(String sVendIpAddr)
	{
		this.sVendIpAddr	=	sVendIpAddr;
	}
	
	public String	getRegDate()
	{
		return	this.sRegDate;
	}
	
	public void	setRegDate(String sRegDate)
	{
		this.sRegDate	=	sRegDate;
	}
}	