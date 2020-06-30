package nicelib.util;

import crosscert.CCTsp;
import nicelib.db.DataSet;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class Tsa {

	String ServerCertDN = "cn=나이스디앤알,ou=서버,ou=한국전자인증,ou=AccreditedCA,o=CrossCert,c=KR";
    String ServerCertPwd = "ekzb096094$";//다큐096094$

    /**
     * TSA요청
     * @param originData
     * @return DataSet - gentime, hashvalue
     */
    public DataSet tsaRequest(String originData) {
        DataSet result = null;
        try {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA);
            Date c_date = new Date();
            String c_time = formatter.format(c_date);
            long start = System.currentTimeMillis();//시작시간 : 1970년부터 현재까지 걸린시간은 1/1000초(밀리초)로 반환

            int nRet;
            CCTsp cCCTsp = new CCTsp();

            //라이센스 경로설정(2.1)
            //cCCTsp.SetConfPath("C:/testfile");

            nRet = cCCTsp.GetTimeStampToken(originData.getBytes(),
                    originData.getBytes().length,
                    ServerCertDN.getBytes(),
                    ServerCertDN.getBytes().length,
                    ServerCertPwd.getBytes(),
                    ServerCertPwd.getBytes().length,
                    0);

            if (nRet != 0) {
                System.out.println("GetTimeStampToken  실패  " + nRet);
                System.out.println("GetTimeStampToken Class errmessage ==> : " + cCCTsp.errmessage);
                System.out.println("GetTimeStampToken Class errdetailmessage ==> : " + cCCTsp.errdetailmessage);
            } else {
                System.out.println("타임스탬프 요청  성공 : " + nRet);
                System.out.println("DB에 저장해야 할 타임스템스 토큰  : " + new String(cCCTsp.contentbuf));
                long end = 0;
                Date f_date = new Date();
                String f_time = formatter.format(f_date);
                //System.out.println("최종시간: " + f_time);
                end = System.currentTimeMillis();     //끝시간
                long total = 0;
                total = end - start;
                String str = total + "";
                if (str.length() == 3) {
                    String sec = "0";
                    String sec2 = str.substring(0);
                    //System.out.println("응답시간: "+sec+"초" + sec2 );
                } else if (str.length() == 4) {
                    String sec = str.substring(0, 1);
                    String sec2 = str.substring(1);
                    //System.out.println("응답시간: "+sec+"초" + sec2 );
                } else if (str.length() == 5) {
                    String sec = str.substring(0, 2);
                    String sec2 = str.substring(2);
                    //System.out.println("응답시간: "+sec+"초" + sec2 );
                }

                // 타임스탬프 검증하기.....
                nRet = cCCTsp.VerifyTimeStampToken(originData.getBytes(),
                        originData.getBytes().length,
                        cCCTsp.contentbuf,
                        cCCTsp.contentlen,
                        1);
                if (nRet != 0) {
                    System.out.println("VerifyTimeStampToken  검증실패  " + nRet);
                    System.out.println("VerifyTimeStampToken Class errmessage ==> : " + cCCTsp.errmessage);
                    System.out.println("VerifyTimeStampToken Class errdetailmessage ==> : " + cCCTsp.errdetailmessage);
                    //return;
                } else {
                    System.out.println("VerifyTimeStampToken 검증 성공 : " + nRet);
                    //System.out.println("GetTimeStampTokenInfo  길이  " + cCCTsp.contentlen);
                    nRet = cCCTsp.GetTimeStampTokenInfo(cCCTsp.contentbuf,
                            cCCTsp.contentlen,
                            1);
                    if (nRet != 0) {
                        System.out.println("GetTimeStampTokenInfo  토큰정보추출실패  " + nRet);
                        System.out.println("GetTimeStampTokenInfo Class errmessage ==> : " + cCCTsp.errmessage);
                        System.out.println("GetTimeStampTokenInfo Class errdetailmessage ==> : " + cCCTsp.errdetailmessage);
                        //return;
                    } else {
                        System.out.println("GetTimeStampTokenInfo 토큰정보추출 성공 : " + nRet);
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
            System.out.println("tsaRequest 에러 : " + e.getMessage());
            return null;
        }

        return result;
    }
}
