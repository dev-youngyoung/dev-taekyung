package nicelib.sap;

import nicelib.db.DataSet;

import com.sap.mw.jco.IFunctionTemplate;
import com.sap.mw.jco.IRepository;
import com.sap.mw.jco.JCO;

/**
 * @author sjlee
 * SAP 연동을 위한 클래스
 */
public class InvestConsultSap {
	
	/**
	 * 투자품의 내역 리스트 조회
	 * @param userId
	 * @param formId
	 * @return
	 */
	public DataSet getInvestConsultSapList(String userId, String formId) throws Exception {
		
		System.out.println("[InvestConsultSap][getInvestConsultSapList] START");
		

		System.out.println("[InvestConsultSap][getInvestConsultSapList] userId : " + userId);
		System.out.println("[InvestConsultSap][getInvestConsultSapList] formId : " + formId);
		
		DataSet investConsultList = null;
		
		JcoCaller jcoCaller = new JcoCaller();
		IRepository repository = jcoCaller.getRepository();
		
		IFunctionTemplate ftemplate = repository.getFunctionTemplate("ZIM_GET_ECONT_DRAFTER");
		JCO.Function function = new JCO.Function(ftemplate);
		JCO.Client client = jcoCaller.getClient();
		
		function.getImportParameterList().setValue(userId, "I_EMPNO");
		function.getImportParameterList().setValue(formId, "I_FRMID");
		
		try {
			client.execute(function);

			String rtnFlag = function.getExportParameterList().getString("E_RESULT");
			System.out.println("[InvestConsultSap][getInvestConsultSapList] rtnFlag : " + rtnFlag);
			
			JCO.Table table = function.getTableParameterList().getTable("T_DATA");
			System.out.println("[InvestConsultSap][getInvestConsultSapList] table rows count : " + table.getNumRows());
			
			investConsultList = new DataSet();
			for (int i=0; i<table.getNumRows(); i++) {
				table.setRow(i);
				investConsultList.addRow();
				System.out.println("[InvestConsultSap][getInvestConsultSapList] table row : " + (i+1));
				for (JCO.FieldIterator it = table.fields(); it.hasMoreElements();) {
			        JCO.Field field = it.nextField();
			        System.out.println("[InvestConsultSap][getInvestConsultSapList] " + field.getName() + " : " + field.getString());
		        	if ("POSID".equals(field.getName())) investConsultList.put("posId", field.getString()); // contPosId
			        if ("SEQ".equals(field.getName())) investConsultList.put("seq", field.getString()); // contSeq
			        if ("ITEM".equals(field.getName())) investConsultList.put("item", field.getString()); // contNameSub
			        if ("SDATE".equals(field.getName())) investConsultList.put("sDate", field.getString()); // contDateFrom
				}
			}
		} catch (Exception e) {
			System.out.println("[InvestConsultSap][getInvestConsultSapList] Exception : " + client + " : " + e);
			throw e;
		} finally {
			System.out.println("[InvestConsultSap][getInvestConsultSapList] Finally step 1 : " + client);

			if (client != null) {
				System.out.println("[InvestConsultSap][getInvestConsultSapList] Finally step 2 : " + client);
				System.out.println("[InvestConsultSap][getInvestConsultSapList] Client : " + client.getClient());
				System.out.println("[InvestConsultSap][getInvestConsultSapList] Client User : " + client.getUser());
				System.out.println("[InvestConsultSap][getInvestConsultSapList] Client Language : " + client.getLanguage());
				System.out.println("[InvestConsultSap][getInvestConsultSapList] Client ASHost : " + client.getASHost());
				System.out.println("[InvestConsultSap][getInvestConsultSapList] Client SystemNumber : " + client.getSystemNumber());
				
				JCO.releaseClient(client);
				JCO.removeClientPool("R3");		
				
				System.out.println("[InvestConsultSap][getInvestConsultSapList] Finally step 3 : " + client);
			}
		}

		System.out.println("[InvestConsultSap][getInvestConsultSapList] END");
		
		return investConsultList;
	}
	
	/**
	 * 투자품의 내역 상세 조회
	 * @param investNo
	 * @param investSeq
	 * @param formId
	 * @return
	 */
	public DataSet getInvestConsultSapDetail(String investNo, String investSeq, String formId) throws Exception {
		
		System.out.println("[InvestConsultSap][getInvestConsultSapDetail] START");
		
		DataSet investConsultDetail = null;
		
		JcoCaller jcoCaller = new JcoCaller();
		IRepository repository = jcoCaller.getRepository();
		
		IFunctionTemplate ftemplate	= repository.getFunctionTemplate("ZIM_ECONTRACT");
		JCO.Function function = new JCO.Function(ftemplate);
		JCO.Client client = jcoCaller.getClient();

		function.getImportParameterList().setValue(investNo, "I_POSID");
		function.getImportParameterList().setValue(Integer.parseInt(investSeq), "I_SEQ");
		function.getImportParameterList().setValue(formId, "I_FRMID");
		
		try {
			client.execute(function);
			
			String rtnFlag = function.getExportParameterList().getString("E_RESULT");
			System.out.println("[InvestConsultSap][getInvestConsultSapDetail] rtnFlag : " + rtnFlag);

			JCO.Table table = function.getTableParameterList().getTable("T_DATA");
			System.out.println("[InvestConsultSap][getInvestConsultSapDetail] table rows count : " + table.getNumRows());
			
			investConsultDetail = new DataSet();
			for (int i = 0; i<table.getNumRows(); i++) {
				table.setRow(i);
				investConsultDetail.addRow();
				System.out.println("[InvestConsultSap][getInvestConsultSapDetail] table row : " + (i+1));
				for (JCO.FieldIterator it = table.fields(); it.hasMoreElements();) {
			        JCO.Field field = it.nextField();
			        System.out.println("[InvestConsultSap][getInvestConsultSapList] " + field.getName() + " : " + field.getString());
			        // 공사도급계약서
			        if (formId.equals("1")) {
						String name = field.getName();
						if ("POSID".equals(name)) {
							investConsultDetail.put("posId", field.getString()); // contPosId
						} else if ("SEQ".equals(name)) {
							investConsultDetail.put("seq", field.getString()); // contSeq
						} else if ("ITEM".equals(name)) {
							investConsultDetail.put("item", field.getString()); // contNameSub
						} else if ("EMPNO".equals(name)) {
							investConsultDetail.put("empNo", field.getString()); // contIputEmpNo
						} else if ("LIFNR".equals(name)) {
							investConsultDetail.put("lifnr", field.getString()); // contSuplCode
						} else if ("LIFNRT".equals(name)) {
							investConsultDetail.put("lifnrt", field.getString()); // contSuplName
						} else if ("STCD2".equals(name)) {
							investConsultDetail.put("stcd2", field.getString()); // contBizNo
						} else if ("TARGET".equals(name)) {
							investConsultDetail.put("target", field.getString()); // contAttr0101
						} else if ("PLACE".equals(name)) {
							investConsultDetail.put("place", field.getString()); // contDeliPlace
						} else if ("PLACE2".equals(name)) {
							investConsultDetail.put("place2", field.getString()); // contDeliFacto
						} else if ("PERIOD".equals(name)) {
							investConsultDetail.put("period", field.getString()); // contAttr0102
						} else if ("SDATE".equals(name)) {
							investConsultDetail.put("sdate", field.getString()); // contDateFrom
						} else if ("EDATE".equals(name)) {
							investConsultDetail.put("edate", field.getString()); // contDateTo
						} else if ("TOTAL".equals(name)) {
							investConsultDetail.put("total", field.getString()); // contAmt
						} else if ("DEPOSIT".equals(name)) {
							investConsultDetail.put("deposit", field.getString()); // contGuarAmt
						} else if ("DEFACT".equals(name)) {
							investConsultDetail.put("defact", field.getString()); // contWarrDate
						} else if ("DEF_RATE".equals(name)) {
							investConsultDetail.put("def_rate", field.getString()); // contWarrPer
						} else if ("DEFER".equals(name)) {
							investConsultDetail.put("defer", field.getString()); // contDelayRate
						} else if ("RATE_BE".equals(name)) {
							investConsultDetail.put("rate_be", field.getString()); // contPrepPaymRete
						} else if ("AMT_BE".equals(name)) {
							investConsultDetail.put("amt_be", field.getString()); // contAttr0106
						} else if ("RATE_01".equals(name)) {
							investConsultDetail.put("rate_01", field.getString()); // contAttr0108
						} else if ("RATE1_01".equals(name)) {
							investConsultDetail.put("rate1_01", field.getString()); // contAttr0107
						} else if ("AMT_01".equals(name)) {
							investConsultDetail.put("amt_01", field.getString()); // contAttr0109
						} else if ("RATE_02".equals(name)) {
							investConsultDetail.put("rate_02", field.getString()); // contAttr0111
						} else if ("RATE1_02".equals(name)) {
							investConsultDetail.put("rate1_02", field.getString()); // contAttr0110
						} else if ("AMT_02".equals(name)) {
							investConsultDetail.put("amt_02", field.getString()); // contAttr0112
						} else if ("RATE_03".equals(name)) {
							investConsultDetail.put("rate_03", field.getString()); // contAttr0114
						} else if ("RATE1_03".equals(name)) {
							investConsultDetail.put("rate1_03", field.getString()); // contAttr0113
						} else if ("AMT_03".equals(name)) {
							investConsultDetail.put("amt_03", field.getString()); // contAttr0115
						}
			        } else {	
			        	// 설비제작계약서
						String name = field.getName();
						if ("POSID".equals(name)) {
							investConsultDetail.put("posId", field.getString()); // contPosId
						} else if ("SEQ".equals(name)) {
							investConsultDetail.put("seq", field.getString()); // contSeq
						} else if ("ITEM".equals(name)) {
							investConsultDetail.put("item", field.getString()); // contNameSub
						} else if ("EMPNO".equals(name)) {
							investConsultDetail.put("empNo", field.getString()); // contIputEmpNo
						} else if ("LIFNR".equals(name)) {
							investConsultDetail.put("lifnr", field.getString()); // contSuplCode
						} else if ("LIFNRT".equals(name)) {
							investConsultDetail.put("lifnrt", field.getString()); // contSuplName
						} else if ("STCD2".equals(name)) {
							investConsultDetail.put("stcd2", field.getString()); // contBizNo
						} else if ("TARGET".equals(name)) {
							investConsultDetail.put("target", field.getString()); // contAttr0201
						} else if ("PLACE".equals(name)) {
							investConsultDetail.put("place", field.getString()); // contDeliPlace
						} else if ("TOTAL".equals(name)) {
							investConsultDetail.put("total", field.getString()); // contAmt
						} else if ("DEPOSIT".equals(name)) {
							investConsultDetail.put("deposit", field.getString()); // contGuarAmt
						} else if ("DEFACT".equals(name)) {
							investConsultDetail.put("defact", field.getString()); // contWarrDate
						} else if ("DEF_RATE".equals(name)) {
							investConsultDetail.put("def_rate", field.getString()); // contWarrPer
						} else if ("DEFER".equals(name)) {
							investConsultDetail.put("defer", field.getString()); // contDelayRate
						} else if ("RATE_BE".equals(name)) {
							investConsultDetail.put("rate_be", field.getString()); // contPrepPaymRete
						} else if ("AMT_BE".equals(name)) {
							investConsultDetail.put("amt_be", field.getString()); // contAttr0213
						} else if ("RATE_01".equals(name)) {
							investConsultDetail.put("rate_01", field.getString()); // contAttr0216
						} else if ("RATE1_01".equals(name)) {
							investConsultDetail.put("rate1_01", field.getString()); // contAttr0218
						} else if ("AMT_01".equals(name)) {
							investConsultDetail.put("amt_01", field.getString()); // contAttr0217
						} else if ("RATE_02".equals(name)) {
							investConsultDetail.put("rate_02", field.getString()); // contAttr0219
						} else if ("RATE1_02".equals(name)) {
							investConsultDetail.put("rate1_02", field.getString()); // contAttr0221
						} else if ("AMT_02".equals(name)) {
							investConsultDetail.put("amt_02", field.getString()); // contAttr0220
						} else if ("RATE_03".equals(name)) {
							investConsultDetail.put("rate_03", field.getString()); // contAttr0222
						} else if ("RATE1_03".equals(name)) {
							investConsultDetail.put("rate1_03", field.getString()); // contAttr0224
						} else if ("AMT_03".equals(name)) {
							investConsultDetail.put("amt_03", field.getString()); // contAttr0223
						} else if ("RATE_00".equals(name)) {
							investConsultDetail.put("rate_00", field.getString()); // contAttr0214
						} else if ("AMT_00".equals(name)) {
							investConsultDetail.put("amt_00", field.getString()); // contAttr0215
						} else if ("RATE_ED".equals(name)) {
							investConsultDetail.put("rate_ed", field.getString()); // contAttr0225
						} else if ("AMT_ED".equals(name)) {
							investConsultDetail.put("amt_ed", field.getString()); // contAttr0226
						} else if ("C_FDATE".equals(name)) {
							investConsultDetail.put("c_fdate", field.getString()); // contDateFrom
						} else if ("C_TDATE".equals(name)) {
							investConsultDetail.put("c_tdate", field.getString()); // contDateTo
						} else if ("R_FDATE".equals(name)) {
							investConsultDetail.put("r_fdate", field.getString()); // contAttr0206
						} else if ("R_TDATE".equals(name)) {
							investConsultDetail.put("r_tdate", field.getString()); // contAttr0207
						} else if ("V_FDATE".equals(name)) {
							investConsultDetail.put("v_fdate", field.getString()); // contAttr0208
						} else if ("V_TDATE".equals(name)) {
							investConsultDetail.put("v_tdate", field.getString()); // contAttr0209
						} else if ("STANDA".equals(name)) {
							investConsultDetail.put("standa", field.getString()); // contAttr0202
						} else if ("CONDI".equals(name)) {
							investConsultDetail.put("condi", field.getString()); // contAttr0203
						}
			        }
				}
			}
		}  catch (Exception e) {
			System.out.println("[InvestConsultSap][getInvestConsultSapDetail] Exception : " + client + " : " + e);
			throw e;
		} finally {
			System.out.println("[InvestConsultSap][getInvestConsultSapDetail] Finally step 1 : " + client);

			if (client != null) {
				System.out.println("[InvestConsultSap][getInvestConsultSapDetail] Finally step 2 : " + client);
				System.out.println("[InvestConsultSap][getInvestConsultSapDetail] Client : " + client.getClient());
				System.out.println("[InvestConsultSap][getInvestConsultSapDetail] Client User : " + client.getUser());
				System.out.println("[InvestConsultSap][getInvestConsultSapDetail] Client Language : " + client.getLanguage());
				System.out.println("[InvestConsultSap][getInvestConsultSapDetail] Client ASHost : " + client.getASHost());
				System.out.println("[InvestConsultSap][getInvestConsultSapDetail] Client SystemNumber : " + client.getSystemNumber());
				
				JCO.releaseClient(client);
				JCO.removeClientPool("R3");		
				
				System.out.println("[InvestConsultSap][getInvestConsultSapDetail] Finally step 3 : " + client);
			}
		}
		
		System.out.println("[InvestConsultSap][getInvestConsultSapDetail] END");
		
		return investConsultDetail;
	}
}