<%@ page contentType="text/html;charset=utf-8"%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<title></title>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript" src="./jsustoolkit/toolkit/util.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/md5.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/sha1.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/sha256.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/aes.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/seed.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/asn1.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/jsbn.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/prng.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/random.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/oids.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/rsa.js"></script>
<script type="text/javascript" src="./jsustoolkit/crypto/hmac.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/pki.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/pkcs5.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/pkcs8.js"></script>
<script type="text/javascript" src="./jsustoolkit/toolkit/x509Certificate.js"></script>
<script type="text/javascript" src="./functions2.js"></script>
<script type="text/javascript">
    function rvCallback(errCode, errMessage, data1, data2) {
        console.info("**** callback result ****");
        console.info("errCode : ", errCode);
        console.info("errMessage : ", errMessage);
        console.info("data : ", data1);
        // console.info("data2 : ", data2);
        // ----------------------------------------- /
        document.getElementById('err').value = "errCode : " + errCode
                + "\n\nerrMessage : " + errMessage;
        document.getElementById('data').value = "data : " + data1;
    };
</script>
</head>
<body>
    <div style="height: 100px">무설치기반 PC-클라이언트 연계 테스트</div>
    <div align="center">
        <table>
            <tr>
                <td>요청 데이터</td>
                <td>응답 데이터</td>
            </tr>
            <tr>
                <td><textarea id="reqData" style="width: 500px; height: 100px"></textarea></td>
                <td><textarea id="resData" style="width: 500px; height: 100px"></textarea></td>
            </tr>
            <tr>
                <td>인증서 데이터</td>
                <td>Signature 데이터</td>
            </tr>
            <tr>
                <td><textarea id="certData" style="width: 500px; height: 100px"></textarea></td>
                <td><textarea id="signature" style="width: 500px; height: 100px"></textarea></td>
            </tr>
            <tr>
                <td>콜백 코드|메세지</td>
                <td>콜백 결과값</td>
            </tr>
            <tr>
                <td><textarea id="err" style="width: 500px; height: 100px"></textarea></td>
                <td><textarea id="data" style="width: 500px; height: 100px"></textarea></td>
            </tr>
            <!-- Added -->
            <tr>
                <td>R Value</td>
                <td>주민등록번호 또는 사업자번호</td>
            </tr>
            <tr>
                <!-- <td><textarea id="vidr" style="width: 500px; height: 100px">71A16AC904F97F209395C43CCCFCBD35BBDD5D5029EA69686DABFEBF2A48FA45</textarea></td> -->
                <!-- <td><textarea id="idn" style="width: 500px; height: 100px">1234561234567</textarea></td> -->
                <td><textarea id="vidr" style="width: 500px; height: 100px"></textarea></td>
                <td><textarea id="idn" style="width: 500px; height: 100px">8411091460014</textarea></td>
            </tr>
            <!-- 
            <tr>
                <td>VID 검증 인증서</td>
                <td>VID 검증 결과</td>
            </tr>
            <tr>
                <td><textarea id="signCert" style="width: 500px; height: 100px">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</textarea></td>
                <td><textarea id="signCert" style="width: 500px; height: 100px"></textarea></td>
                <td><textarea id='verifyValue' style="width: 500px; height: 100px"></textarea></td>
            </tr>
            <tr>
                <td>파싱 대상 인증서</td>
                <td>파싱 결과 데이터</td>
            </tr>
            <tr>
                <td><textarea id="base64Cert" style="width: 500px; height: 100px">MIIE1TCCA72gAwIBAgIUNtkEFAQSaqAPN4SKtDnu8yXSBB8wDQYJKoZIhvcNAQEFBQAwTjELMAkGA1UEBhMCS1IxDzANBgNVBAoMBlRFU1RDQTEZMBcGA1UECwwQVEVTVEFjY3JlZGl0ZWRDQTETMBEGA1UEAwwKSUMtQkFTRS0wMDAeFw0wNTAxMDEwMTA2MjZaFw0xMDEyMzEwMTA0NTJaMFwxCzAJBgNVBAYTAktSMQ0wCwYDVQQFEwQxMjM0MQ8wDQYDVQQKDAZURVNUQ0ExGTAXBgNVBAsMEFRFU1RBY2NyZWRpdGVkQ0ExEjAQBgNVBAMMCUVDLVJETi0wMTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAnutnouTiMugc0ShGlJZL2mRWYxL20O1N28xeLgF5hc2+R0H/SVXr97en3xmF9zrUIFKWTqlEou94YM5C+OM9GQWf+OAzVP/dQcAz68dM8mgnGNdZJ0ec7iKAOrBXlqUEImipxtdCZQJ3w43cAsqTcVFBSUnXHJyodFiK5xqE6mcCAwEAAaOCAh8wggIbMGkGA1UdIwRiMGCAFM7AkTwQ/HJMI0/oZASHGzDqRiveoUSkQjBAMQswCQYDVQQGEwJLUjENMAsGA1UECgwES0lTQTENMAsGA1UECwwES0NBQzETMBEGA1UEAwwKUkMtQkFTRS0wMIICUAUwHQYDVR0OBBYEFFgkJLcHDxKD7/H2pDbbTWvqVfhUMA4GA1UdDwEB/wQEAwIGwDAyBgNVHREEKzApoCcGCSqDGoyaRAoBAaAaMBgMFu2FjOyKpO2KuDMyODDsgqzsmqnsnpAwgYMGA1UdIAEB/wR5MHcwdQYJKoMajJpEAohXMGgwMAYIKwYBBQUHAgIwJB4ix3QAIMd4yZ3BHLKUACDRTMKk0rgAIMd4yZ3BHMeFssiy5DA0BggrBgEFBQcCARYoaHR0cDovL3d3dy5yb290Y2Eub3Iua3IvcmNhL3Rlc3RjcHMuaHRtbDB7BgNVHR8EdDByMHCgbqBshmpsZGFwOi8vYWN0ZXhhbS5yb290Y2Eub3Iua3I6Mzg5L0NOPUNSTC1CQVNFLTAwLE9VPVRFU1RBY2NyZWRpdGVkQ0EsTz1URVNUQ0EsQz1LUj9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0MEgGCCsGAQUFBwEBBDwwOjA4BggrBgEFBQcwAYYsaHR0cDovL2FjdGV4YW0ucm9vdGNhLm9yLmtyOjE0MjAzL09DU1BTZXJ2ZXIwDQYJKoZIhvcNAQEFBQADggEBAJTE5qp8Vqn9WsmTJ9cs67W8iqBWXic07P7LZDtnZ8xAx27L6s49DnKqme7LiJQNMkoPsyyigiVdo62tRrnrjitwBlb1Dmsqr8tyX02LE4BoullpjI1DdmAo8vxVXnlDZkRjHDTidZ6X1+5JGX6Agb2XDzI6SHK2jMf4vmaP+47KOHId5doOrQooh54ZsLbfyxX3i9JkqEARZwqMmW9e09RH9sC0AYssli+AAg5C0bedSW0mCmIAMz+ppzKEyqqqCqazwZRD9wwnTaIWmFTASP1b9/c0aWYL2ZmgZo9gNF5n1bm7EczLs/fMqk7zlJHwckqyRZ/OWRWjUPM2DABFUlo=</textarea></td>
                <td><textarea id="base64Cert" style="width: 500px; height: 100px"></textarea></td>
                <td><textarea id="parsingCert" style="width: 500px; height: 100px"></textarea></td>
            </tr>
             -->
            <!-- // Added -->
        </table>

        userID : <input type="text" id="userID" name="userID" value="01097636332" /><br /> <br /> inputValue : <input type="text" id="inputValue" name="inputValue" value="this is plainText." /><br /> <br /> <!-- pinData : <input type="text" id="pinData" name="pinData" value="" /><br /> <br /> -->

        <!-- 1. reqGetCert(phoneNumber, rvCallback) -->
        <button type="button" class="us-layout-sectoken-select-cls-btn" onClick="reqGetCert(userID.value, rvCallback);">reqGetCert</button>
        <button type="button" class="us-layout-sectoken-select-cls-btn" onClick="reqGetCertR(1, rvCallback);">reqGetCertR</button>
        <button type="button" class="us-layout-sectoken-select-cls-btn" onClick="reqVerifyVID(1, idn.value, rvCallback);">reqVerifyVID</button>
        <button type="button" class="us-layout-sectoken-select-cls-btn" onClick="reqGetCertOID(1, rvCallback);">reqGetCertOID</button>
        <button type="button" class="us-layout-sectoken-select-cls-btn" onClick="reqGetCertExpirationDate(1, rvCallback);">reqGetCertExpirationDate</button>
        <!-- <button type="button" class="us-layout-sectoken-select-cls-btn" onClick="reqCertParsing(1);">reqCertParsing</button> -->
        <!-- 2. reqGenSign(index, pinValue, phoneNumber, plainText, rvCallback) -->
        <!-- <button type="button" class="us-layout-sectoken-select-cls-btn" onClick="reqGenSign(1, pinData.value, userID.value, inputValue.value, rvCallback);">reqGenSign</button> -->
        <!-- 3. reqGenSignNonVerifyPin(index, phoneNumber, plainText, rvCallback) -->
        <button type="button" class="us-layout-sectoken-select-cls-btn" onClick="reqGenSignNonVerifyPin(1, inputValue.value, rvCallback);">reqGenSignNonVerifyPin</button>
        <!-- COMMENT : 티모넷 중계서버 암/복호화 테스트 -->
        <!-- <button type="button" class="us-layout-sectoken-select-cls-btn" onClick="test();">test</button> -->
    </div>
</body>
<script type="text/javascript">
    function test() {
        // ------------------------------------------------
        var data = "this is plainText.";
        console.info("data : ", data);
        
        var hashAlgo = "sha256";
        
        var md = crosscert.md.algorithms[hashAlgo].create();
        md.start();
        md.update(data);
        var hData = md.digest();
        
        console.info("hData : ", hData.toHex());
        
        var inputBytes = crosscert.util.createBuffer();
        var EMPadding = crosscert.util
                .hexToBytes("0001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF003031300D060960864801650304020105000420");
        inputBytes.putBytes(EMPadding);
        inputBytes.putBytes(hData.getBytes());
        console.info("inputBytes : ", inputBytes.toHex());
        // ------------------------------------------------
        
        var inputValue = inputBytes.getBytes();
        var phoneNumber = "01079796540";
        
        var md = crosscert.md.algorithms[hashAlgo].create();
        md.start();
        md.update(phoneNumber);
        
        var hPN = md.digest().getBytes();
        var symmkey = hPN.substring(0, 16);
        var symmiv = hPN.substring(16, 32);
        var symmAlgo = "aes";
        
        console.info("symmkey : ", crosscert.util.bytesToHex(symmkey));
        console.info("symmiv : ", crosscert.util.bytesToHex(symmiv));
        
        var cipher = crosscert.cipher.algorithms[symmAlgo].startEncrypting(
                symmkey, symmiv);
        cipher.update(inputValue);
        cipher.finish(hashPadding);
        // cipher.finish(noPadding);
        
        var encrypt = cipher.output.toHex();
        console.info("encrypt : ", encrypt);
        
        var encValue = cipher.output.getBytes();
        console.info("base64 encValue ", crosscert.util.encode64(encValue));
        
        var cipher = crosscert.cipher.algorithms[symmAlgo].startDecrypting(
                symmkey, symmiv);
        cipher.update(encValue);
        cipher.finish(hashPadding);
        // cipher.finish(noPadding);
        
        var decrypt = cipher.output.toHex();
        console.info("decrypt : ", decrypt);
    };
    
    function hashPadding(blockSize, input, decrypt) {
        if (!decrypt) {
            input.putByte(0x80);
            var padding = (input.length() == blockSize) ? 0
                    : (blockSize - input.length());
            input.fillWithByte(0x00, padding);
        }
        return true;
    };
    
    function noPadding(blockSize, input, decrypt) {
        if (!decrypt) {
            /* var padding = (input.length() == blockSize) ?
              0 : (blockSize - input.length());
            input.fillWithByte(0x00, padding); */
        }
        return true;
    };
</script>
</html>

