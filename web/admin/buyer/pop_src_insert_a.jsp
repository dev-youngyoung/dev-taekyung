<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page import="  java.util.ArrayList
			 	  ,nicelib.db.DataSet
				  ,nicelib.util.Util
				  ,nicelib.db.DataObject
				  ,nicelib.db.DB
				  ,java.net.URLDecoder
"%>
<%@ include file = "../../../inc/funUtil.inc" %>
<%
	
	Util u = new Util(request, response, out);
	
	String grid = u.request("grid");
	if(!grid.equals("")){
		grid = URLDecoder.decode(grid,"UTF-8");
	}
	
	DataSet data = u.grid2dataset(grid);
	
	try{
		
		String	sMemberNo	= u.request("member_no");	// ȸ����ȣ
	
		DataObject dItem = new DataObject("tcb_src_adm");
		
		int iItemCnt	=	dItem.getOneInt(	"select count(*) icnt \n" 
																		+	" from tcb_src_adm \n"
																		+	"where member_no = '"+sMemberNo+"'");
		
		DB db = new DB();
		db.setCommand("update tcb_member set src_depth='03' where member_no = '"+sMemberNo+"' ", null);
		if(iItemCnt > 0)
		{
			db.setCommand(	"delete from tcb_src_adm \n"
										+	" where member_no = '"+sMemberNo+"'", null);
		}
		
		String 	sLSrcNm		=	"";	//	��з���
		String	sMSrcNm		=	"";	//	�ߺз���
		String	sSSrcNm		=	"";	//	�Һз���
		String	sSrcNm		=	"";	//	�з���
		
		String 	_sLSrcNm	=	"";	//	��з���
		String	_sMSrcNm	=	"";	//	�ߺз���
		String	_sSSrcNm	=	"";	//	�Һз���
	
		int			iLSrcCd	=	0;	//	��з��ڵ�
		int			iMSrcCd	=	0;	//	�ߺз��ڵ�
		int			iSSrcCd	=	0;	//	�Һз��ڵ�
		int			iDepth		=	0;	//	DEPTH
		
		ArrayList	alLSrcCd	=	null;	//	��з��ڵ�	
		ArrayList	alMSrcCd	=	null;	//	�ߺз��ڵ�	 
		ArrayList	alSSrcCd	=	null;	//	�Һз��ڵ�
		ArrayList	alDepth		=	null;	//	DEPTH
		ArrayList	alSrcNm		=	null;	//	�з���
		
		System.out.println("realGrid.getRowCnt["+data.size()+"]"); 

		int i=0;
		
		while(data.next()){
			
			if(i == 0)
			{
				alLSrcCd	=	new ArrayList();	//	��з��ڵ�
				alMSrcCd	=	new ArrayList();	//	�ߺз��ڵ�
				alSSrcCd	=	new ArrayList();	//	�Һз��ڵ�
				alDepth		=	new ArrayList();	//	DEPTH				
				alSrcNm		=	new ArrayList();	//	DEPTH				
			}
		
			_sLSrcNm	=	data.getString("l_src_nm");
			_sMSrcNm	=	data.getString("m_src_nm");
			_sSSrcNm	=	data.getString("s_src_nm");
			
			if(!sLSrcNm.equals(_sLSrcNm))
			{
				/* ��з� */
				sLSrcNm	=	_sLSrcNm;
				iLSrcCd++;
				iMSrcCd	=	0;
				iSSrcCd	=	0;
				iDepth	=	1;
				sSrcNm	=	sLSrcNm;
				
				alLSrcCd.add(iLSrcCd+"");
				alMSrcCd.add(iMSrcCd+"");
				alSSrcCd.add(iSSrcCd+"");
				alSrcNm.add(sSrcNm);
				alDepth.add(iDepth+"");
				
				/* �ߺз� */
				sMSrcNm	=	_sMSrcNm;
				iMSrcCd++;
				iSSrcCd	=	0;
				iDepth	=	2;
				sSrcNm	=	sMSrcNm;
				
				alLSrcCd.add(iLSrcCd+"");
				alMSrcCd.add(iMSrcCd+"");
				alSSrcCd.add(iSSrcCd+"");
				alSrcNm.add(sSrcNm);
				alDepth.add(iDepth+"");
				
				/* �Һз� */
				sSSrcNm	=	_sSSrcNm;
				iSSrcCd++;
				iDepth	=	3;
				sSrcNm	=	sSSrcNm;
				
				alLSrcCd.add(iLSrcCd+"");
				alMSrcCd.add(iMSrcCd+"");
				alSSrcCd.add(iSSrcCd+"");
				alSrcNm.add(sSrcNm);
				alDepth.add(iDepth+"");
			}else
			{
				if(!sMSrcNm.equals(_sMSrcNm))
				{
					/* �ߺз� */
					sMSrcNm	=	_sMSrcNm;
					iMSrcCd++;
					iSSrcCd	=	0;
					iDepth	=	2;
					sSrcNm	=	sMSrcNm;
					
					alLSrcCd.add(iLSrcCd+"");
					alMSrcCd.add(iMSrcCd+"");
					alSSrcCd.add(iSSrcCd+"");
					alSrcNm.add(sSrcNm);
					alDepth.add(iDepth+"");
					
					/* �Һз� */
					sSSrcNm	=	_sSSrcNm;
					iSSrcCd++;
					iDepth	=	3;
					sSrcNm	=	sSSrcNm;
					
					alLSrcCd.add(iLSrcCd+"");
					alMSrcCd.add(iMSrcCd+"");
					alSSrcCd.add(iSSrcCd+"");
					alSrcNm.add(sSrcNm);
					alDepth.add(iDepth+"");
				}else
				{
					/* �Һз� */
					sSSrcNm	=	_sSSrcNm;
					iSSrcCd++;
					iDepth	=	3;
					sSrcNm	=	sSSrcNm;
					
					alLSrcCd.add(iLSrcCd+"");
					alMSrcCd.add(iMSrcCd+"");
					alSSrcCd.add(iSSrcCd+"");
					alSrcNm.add(sSrcNm);
					alDepth.add(iDepth+"");
				}
			}
			
			i++;
			
		}
		
		String	sLSrcCd		=	"";	//	��з��ڵ�
		String	sMSrcCd		=	"";	//	�ߺз��ڵ�
		String	sSSrcCd		=	"";	//	�Һз��ڵ�
		String	sSrcCd		=	"";	//	�з��ڵ�
		
		String	_sLSrcCd	=	"";	//	��з��ڵ�
		String	_sMSrcCd	=	"";	//	�ߺз��ڵ�
		String	_sSSrcCd	=	"";	//	�Һз��ڵ�
		
		for(int j=0; j < alDepth.size(); j++)
		{
			sLSrcCd	=	"000";
			sMSrcCd	=	"000";
			sSSrcCd	=	"000";
			
			_sLSrcCd		=	alLSrcCd.get(j).toString();		//	��з��ڵ�
			_sMSrcCd		=	alMSrcCd.get(j).toString();		//	�ߺз��ڵ�
			_sSSrcCd		=	alSSrcCd.get(j).toString();		//	�Һз��ڵ�
			
			sLSrcCd	=	sLSrcCd.substring(0,3-(_sLSrcCd.length()))+_sLSrcCd;
			sMSrcCd	=	sMSrcCd.substring(0,3-(_sMSrcCd.length()))+_sMSrcCd;
			sSSrcCd	=	sSSrcCd.substring(0,3-(_sSSrcCd.length()))+_sSSrcCd;
			
			sSrcCd	=	sLSrcCd	+	sMSrcCd	+	sSSrcCd;
			
			dItem = new DataObject("tcb_src_adm");
			dItem.item("member_no",	sMemberNo);
			dItem.item("src_cd", 		sSrcCd);
			dItem.item("l_src_cd",	sLSrcCd);
			dItem.item("m_src_cd", 	sMSrcCd);
			dItem.item("s_src_cd", 	sSSrcCd);
			dItem.item("src_nm", 		alSrcNm.get(j).toString());
			dItem.item("depth",			new Integer(alDepth.get(j).toString()));	//	DEPTH
			db.setCommand(dItem.getInsertQuery(), dItem.record);
		}
		
		db.executeArray();
		
		out.print("1");
		
	}catch(Exception e){
		out.print("0");
		return;
	}
%>