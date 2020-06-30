package nicelib.util;

import crosscert.CCTsp;
import nicelib.db.DataSet;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class Tsa {

	String ServerCertDN = "cn=���̽���ؾ�,ou=����,ou=�ѱ���������,ou=AccreditedCA,o=CrossCert,c=KR";
    String ServerCertPwd = "ekzb096094$";//��ť096094$

    /**
     * TSA��û
     * @param originData
     * @return DataSet - gentime, hashvalue
     */
    public DataSet tsaRequest(String originData) {
        DataSet result = null;
        try {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA);
            Date c_date = new Date();
            String c_time = formatter.format(c_date);
            long start = System.currentTimeMillis();//���۽ð� : 1970����� ������� �ɸ��ð��� 1/1000��(�и���)�� ��ȯ

            int nRet;
            CCTsp cCCTsp = new CCTsp();

            //���̼��� ��μ���(2.1)
            //cCCTsp.SetConfPath("C:/testfile");

            nRet = cCCTsp.GetTimeStampToken(originData.getBytes(),
                    originData.getBytes().length,
                    ServerCertDN.getBytes(),
                    ServerCertDN.getBytes().length,
                    ServerCertPwd.getBytes(),
                    ServerCertPwd.getBytes().length,
                    0);

            if (nRet != 0) {
                System.out.println("GetTimeStampToken  ����  " + nRet);
                System.out.println("GetTimeStampToken Class errmessage ==> : " + cCCTsp.errmessage);
                System.out.println("GetTimeStampToken Class errdetailmessage ==> : " + cCCTsp.errdetailmessage);
            } else {
                System.out.println("Ÿ�ӽ����� ��û  ���� : " + nRet);
                System.out.println("DB�� �����ؾ� �� Ÿ�ӽ��۽� ��ū  : " + new String(cCCTsp.contentbuf));
                long end = 0;
                Date f_date = new Date();
                String f_time = formatter.format(f_date);
                //System.out.println("�����ð�: " + f_time);
                end = System.currentTimeMillis();     //���ð�
                long total = 0;
                total = end - start;
                String str = total + "";
                if (str.length() == 3) {
                    String sec = "0";
                    String sec2 = str.substring(0);
                    //System.out.println("����ð�: "+sec+"��" + sec2 );
                } else if (str.length() == 4) {
                    String sec = str.substring(0, 1);
                    String sec2 = str.substring(1);
                    //System.out.println("����ð�: "+sec+"��" + sec2 );
                } else if (str.length() == 5) {
                    String sec = str.substring(0, 2);
                    String sec2 = str.substring(2);
                    //System.out.println("����ð�: "+sec+"��" + sec2 );
                }

                // Ÿ�ӽ����� �����ϱ�.....
                nRet = cCCTsp.VerifyTimeStampToken(originData.getBytes(),
                        originData.getBytes().length,
                        cCCTsp.contentbuf,
                        cCCTsp.contentlen,
                        1);
                if (nRet != 0) {
                    System.out.println("VerifyTimeStampToken  ��������  " + nRet);
                    System.out.println("VerifyTimeStampToken Class errmessage ==> : " + cCCTsp.errmessage);
                    System.out.println("VerifyTimeStampToken Class errdetailmessage ==> : " + cCCTsp.errdetailmessage);
                    //return;
                } else {
                    System.out.println("VerifyTimeStampToken ���� ���� : " + nRet);
                    //System.out.println("GetTimeStampTokenInfo  ����  " + cCCTsp.contentlen);
                    nRet = cCCTsp.GetTimeStampTokenInfo(cCCTsp.contentbuf,
                            cCCTsp.contentlen,
                            1);
                    if (nRet != 0) {
                        System.out.println("GetTimeStampTokenInfo  ��ū�����������  " + nRet);
                        System.out.println("GetTimeStampTokenInfo Class errmessage ==> : " + cCCTsp.errmessage);
                        System.out.println("GetTimeStampTokenInfo Class errdetailmessage ==> : " + cCCTsp.errdetailmessage);
                        //return;
                    } else {
                        System.out.println("GetTimeStampTokenInfo ��ū�������� ���� : " + nRet);
                        System.out.println("[gentime]      " + cCCTsp.gentime);
                        System.out.println("[hashvalue] " + cCCTsp.hashvalue);
                        /*
                        System.out.println("[policy]       " + cCCTsp.policy);
                        System.out.println("[serialnumber] " + cCCTsp.serialnumber);
                        System.out.println("[hashalgorism] " + cCCTsp.hashalgorithm);
                        */
                        result = new DataSet();
                        result.addRow();
                        result.put("gentime", cCCTsp.gentime);
                        result.put("hashvalue", cCCTsp.hashvalue);
                        result.put("serialnumber", cCCTsp.serialnumber);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("tsaRequest ���� : " + e.getMessage());
            return null;
        }

        return result;
    }
}
