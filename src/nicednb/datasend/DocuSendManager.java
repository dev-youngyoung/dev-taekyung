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
	private	String	sVendCd		=	"";	//	전송업체사업자번호
	private	String	sVendIpAddr	=	"";	//	전송업체IP
	private	String	sRegDate	=	"";	//	조회요청일자
	private	String	sErrMag		=	"";	//	에러메시지		
	
	/**
	 * 파라메타 값 받기
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
				throw new Exception("사업자번호가 전송되지 않았습니다.");
			}
			
			if(!_sVendIpAddr.equals(""))
			{
				this.setVendIpAddr(Security.AESdecrypt(_sVendIpAddr));
			}else
			{
				throw new Exception("전송IP가 전송되지 않았습니다.");
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
	 * 수신사업자 전송여부 체크
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
				throw new Exception("해당 사업자["+this.getVendCd()+"]의 접속정보가 나이스다큐에 등록되어 있지 않습니다.");
			}else
			{
				if(!dsv.getString("vend_use_yn").equals("Y"))
				{
					bChk	=	false;
					throw new Exception("해당 사업자["+this.getVendCd()+"]는 접속허용이 되어 있지 않습니다.");
				}
				
				if(!this.getVendIpAddr().equals(dsv.getString("vend_ip_addr")))
				{
					bChk	=	false;
					throw new Exception("등록된 해당 사업자["+this.getVendCd()+"]의 IP["+dsv.getString("vend_ip_addr")+"]와 전송된 IP["+this.getVendIpAddr()+"]가 일치하지 않습니다.");
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