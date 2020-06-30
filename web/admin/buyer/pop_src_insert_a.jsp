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
		
		String	sMemberNo	= u.request("member_no");	// 회원번호
	
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
		
		String 	sLSrcNm		=	"";	//	대분류명
		String	sMSrcNm		=	"";	//	중분류명
		String	sSSrcNm		=	"";	//	소분류명
		String	sSrcNm		=	"";	//	분류명
		
		String 	_sLSrcNm	=	"";	//	대분류명
		String	_sMSrcNm	=	"";	//	중분류명
		String	_sSSrcNm	=	"";	//	소분류명
	
		int			iLSrcCd	=	0;	//	대분류코드
		int			iMSrcCd	=	0;	//	중분류코드
		int			iSSrcCd	=	0;	//	소분류코드
		int			iDepth		=	0;	//	DEPTH
		
		ArrayList	alLSrcCd	=	null;	//	대분류코드	
		ArrayList	alMSrcCd	=	null;	//	중분류코드	 
		ArrayList	alSSrcCd	=	null;	//	소분류코드
		ArrayList	alDepth		=	null;	//	DEPTH
		ArrayList	alSrcNm		=	null;	//	분류명
		
		System.out.println("realGrid.getRowCnt["+data.size()+"]"); 

		int i=0;
		
		while(data.next()){
			
			if(i == 0)
			{
				alLSrcCd	=	new ArrayList();	//	대분류코드
				alMSrcCd	=	new ArrayList();	//	중분류코드
				alSSrcCd	=	new ArrayList();	//	소분류코드
				alDepth		=	new ArrayList();	//	DEPTH				
				alSrcNm		=	new ArrayList();	//	DEPTH				
			}
		
			_sLSrcNm	=	data.getString("l_src_nm");
			_sMSrcNm	=	data.getString("m_src_nm");
			_sSSrcNm	=	data.getString("s_src_nm");
			
			if(!sLSrcNm.equals(_sLSrcNm))
			{
				/* 대분류 */
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
				
				/* 중분류 */
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
				
				/* 소분류 */
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
					/* 중분류 */
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
					
					/* 소분류 */
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
					/* 소분류 */
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
		
		String	sLSrcCd		=	"";	//	대분류코드
		String	sMSrcCd		=	"";	//	중분류코드
		String	sSSrcCd		=	"";	//	소분류코드
		String	sSrcCd		=	"";	//	분류코드
		
		String	_sLSrcCd	=	"";	//	대분류코드
		String	_sMSrcCd	=	"";	//	중분류코드
		String	_sSSrcCd	=	"";	//	소분류코드
		
		for(int j=0; j < alDepth.size(); j++)
		{
			sLSrcCd	=	"000";
			sMSrcCd	=	"000";
			sSSrcCd	=	"000";
			
			_sLSrcCd		=	alLSrcCd.get(j).toString();		//	대분류코드
			_sMSrcCd		=	alMSrcCd.get(j).toString();		//	중분류코드
			_sSSrcCd		=	alSSrcCd.get(j).toString();		//	소분류코드
			
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