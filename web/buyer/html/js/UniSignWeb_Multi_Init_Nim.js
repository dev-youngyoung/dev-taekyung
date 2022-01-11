document.writeln("<iframe  src='https://127.0.0.1:14461/' name='hsmiframe' id='hsmiframe' style='visibility:hidden;position:absolute'></iframe>");

if(document.body){
	var winTarget = document.createElement('div');
	winTarget.id = 'ESignWindow';
	document.body.appendChild( winTarget, document.body.firstChild );
}else{
	document.writeln('<div id="ESignWindow"></div>');
}




var all_policies = "";
all_policies +="1.2.410.200004.5.2.1.1"    + "|";          // 한국정보인증               법인
all_policies +="1.2.410.200004.5.1.1.7"    + "|";          // 한국증권전산               법인, 단체, 개인사업자
all_policies +="1.2.410.200005.1.1.5"      + "|";          // 금융결제원                 법인, 임의단체, 개인사업자
all_policies +="1.2.410.200004.5.3.1.1"    + "|";          // 한국전산원                 기관(국가기관 및 비영리기관)
all_policies +="1.2.410.200004.5.3.1.2"    + "|";          // 한국전산원                 법인(국가기관 및 비영리기관을  제외한 공공기관, 법인)
all_policies +="1.2.410.200004.5.4.1.2"    + "|";          // 한국전자인증               법인, 단체, 개인사업자
all_policies +="1.2.410.200012.1.1.3"      + "|";          // 한국무역정보통신           법인
all_policies +="1.2.410.200004.5.5.1.2"    + "|";          // 이니텍                    법인
all_policies +="1.2.410.200004.5.4.2.369"  + "|";          // 나이스디앤비전용           법인
all_policies +="1.2.410.200004.5.2.1.2"    + "|";          // 한국정보인증               개인
all_policies +="1.2.410.200004.5.1.1.5"    + "|";          // 한국증권전산               개인
all_policies +="1.2.410.200005.1.1.1"      + "|";          // 금융결제원                 개인
all_policies +="1.2.410.200004.5.3.1.9"    + "|";          // 한국전산원                 개인
all_policies +="1.2.410.200004.5.4.1.1"    + "|";          // 한국전자인증               개인
all_policies +="1.2.410.200012.1.1.1"      + "|";          // 한국무역정보통신           개인
all_policies +="1.2.410.200012.1.1.1"      + "|";          // 한국무역정보통신           개인
all_policies +="1.2.410.200004.5.5.1.1"    + "|";          // 이니텍                    개인
all_policies +="1.2.410.200005.1.1.6.8"    + "|";          // 세금계산서전용
all_policies +="1.2.410.200005.1.1.4"+ "|";// 은행용


var comp_policies = "";
comp_policies +="1.2.410.200004.5.2.1.1"    + "|";          // 한국정보인증               법인
comp_policies +="1.2.410.200004.5.1.1.7"    + "|";          // 한국증권전산               법인, 단체, 개인사업자
comp_policies +="1.2.410.200005.1.1.5"      + "|";          // 금융결제원                 법인, 임의단체, 개인사업자
comp_policies +="1.2.410.200004.5.3.1.1"    + "|";          // 한국전산원                 기관(국가기관 및 비영리기관)
comp_policies +="1.2.410.200004.5.3.1.2"    + "|";          // 한국전산원                 법인(국가기관 및 비영리기관을  제외한 공공기관, 법인)
comp_policies +="1.2.410.200004.5.4.1.2"    + "|";          // 한국전자인증               법인, 단체, 개인사업자
comp_policies +="1.2.410.200012.1.1.3"      + "|";          // 한국무역정보통신           법인
comp_policies +="1.2.410.200004.5.5.1.2"    + "|";          // 이니텍                    법인
comp_policies +="1.2.410.200004.5.4.2.369"  + "|";          // 나이스디앤비전용           법인
comp_policies +="1.2.410.200012.5.6.1.81"   + "|";          // 한국무역전자인증1
comp_policies +="1.2.410.200012.5.6.1.82"   + "|";          // 한국무역전자인증2
comp_policies +="1.2.410.200004.5.4.2.503"  + "|";          // 농심 전용인증서


var person_policies = "";
person_policies +="1.2.410.200004.5.2.1.2"    + "|";          // 한국정보인증               개인
person_policies +="1.2.410.200004.5.1.1.5"    + "|";          // 한국증권전산               개인
person_policies +="1.2.410.200005.1.1.1"      + "|";          // 금융결제원                 개인
person_policies +="1.2.410.200004.5.3.1.9"    + "|";          // 한국전산원                 개인
person_policies +="1.2.410.200004.5.4.1.1"    + "|";          // 한국전자인증               개인
person_policies +="1.2.410.200012.1.1.1"      + "|";          // 한국무역정보통신           개인
person_policies +="1.2.410.200004.5.5.1.1"    + "|";          // 이니텍                    개인

// MODE 4 = NIM, nim + webstorage = 6
var unisign = UnisignWeb({
    Mode: 4,

    PKI: 'NPKI',
    SRCPath: '/cab/CrossCert/CC_WSTD_home/',
    DebugConsole: true, //개발자 도구 실행 여부  (default: true)
    Language: 'ko-kr',
    TargetObj: document.getElementById('ESignWindow'),
    TabIndex: 1000,
    LimitNumOfTimesToTryToInputPW: 3,

    /*저장매체 추가시 수정해야될 부분 */
    //Media: {'defaultdevice':'harddisk', 'list':'removable|sectoken|savetoken|mobilephone|harddisk'},/* plugin mode(Mode:1) media list */
    //Media: {'defaultdevice':'webstorage', 'list':'webstorage|touchsign|smartsign|websectoken|websofttoken'},/* plugin-free mode(Mode:2) media list */
    //Media: {'defaultdevice':'harddisk', 'list':'mobiletoken|sectoken|mobilephone|removable|harddisk'},/* all media(Mode:3) list */
    Media: {'defaultdevice':'harddisk', 'list':'harddisk|removable|sectoken'},/* all media(Mode:3) list */

    // 사업자용 인증서만 보이도록 설정
    Policy: comp_policies,

    //ShowExpiredCerts: false, 만료인증서 표시 여부

    CMPIP: 'testca.crosscert.com',  //CMP IP
    //CMPIP: '211.180.234.216',  //CMP IP
    CMPPort: 4502,  //CMP Port

    LimitMinNewPWLen: 8,
    LimitMaxNewPWLen: 64,
    LimitNewPWPattern: 0,  //0 : 제한 없음, 1 : 영문,숫자 혼합, 2 : 영문,숫자,특수문자 혼합
    CertRequestPageEnable: 1,  // 0 : disable, 1 : enable, 설정하지 않으면 enable
    NimCheckURL : "javascript:try{OpenWindows('/cab/CrossCert/CC_WSTD_home/install/Obj_check.jsp','Obj_check',1000,700);}catch(e){alert('팝업이 차단되었습니다.\n\n팝업을 허용 후 공인인증서모듈을 설치 하세요.');}" //설치페이지 URL설정
});



function setUniSign(gubun){
    var jsonConfigInfo;
    if(gubun=="comp"){
        //Comp
        jsonConfigInfo =
            {
                Policy: comp_policies
            };
    }else if(gubun=="person"){
        //Person
        jsonConfigInfo =
            {
                Policy: person_policies
            };
    }else if(gubun=="all"){
        //Person
        jsonConfigInfo =
            {
                Policy: all_policies
            };
    }

    unisign.SetConfigInfo(jsonConfigInfo);

    var top = (window.innerHeight/2 - 590/2);
    var left = (window.innerWidth/2 - 590/2);
    unisign.SetOptions("popup", (top+","+left+", overlay=true"));
    unisign.SetMobileTokenEnvInfo("303010001", "0003", "www.crosscert.com", "service.smartcert.kr", "443", "http://download.smartcert.kr");
    unisign.SetUBIKeyEnvInfo("1,3,0,7", "CROSSCERT|http://www.ubikey.co.kr/infovine/download.html", "CROSSCERT|NULL", "http://www.ubikey.co.kr/infovine/download.html");			
}
