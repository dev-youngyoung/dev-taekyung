document.writeln("<iframe  src='https://127.0.0.1:14461/' name='hsmiframe' id='hsmiframe' style='visibility:hidden;position:absolute'></iframe>");

if(document.body){
	var winTarget = document.createElement('div');
	winTarget.id = 'ESignWindow';
	document.body.appendChild( winTarget, document.body.firstChild );
}else{
	document.writeln('<div id="ESignWindow"></div>');
}




var all_policies = "";
all_policies +="1.2.410.200004.5.2.1.1"    + "|";          // �ѱ���������               ����
all_policies +="1.2.410.200004.5.1.1.7"    + "|";          // �ѱ���������               ����, ��ü, ���λ����
all_policies +="1.2.410.200005.1.1.5"      + "|";          // ����������                 ����, ���Ǵ�ü, ���λ����
all_policies +="1.2.410.200004.5.3.1.1"    + "|";          // �ѱ������                 ���(������� �� �񿵸����)
all_policies +="1.2.410.200004.5.3.1.2"    + "|";          // �ѱ������                 ����(������� �� �񿵸������  ������ �������, ����)
all_policies +="1.2.410.200004.5.4.1.2"    + "|";          // �ѱ���������               ����, ��ü, ���λ����
all_policies +="1.2.410.200012.1.1.3"      + "|";          // �ѱ������������           ����
all_policies +="1.2.410.200004.5.5.1.2"    + "|";          // �̴���                    ����
all_policies +="1.2.410.200004.5.4.2.369"  + "|";          // ���̽���غ�����           ����
all_policies +="1.2.410.200004.5.2.1.2"    + "|";          // �ѱ���������               ����
all_policies +="1.2.410.200004.5.1.1.5"    + "|";          // �ѱ���������               ����
all_policies +="1.2.410.200005.1.1.1"      + "|";          // ����������                 ����
all_policies +="1.2.410.200004.5.3.1.9"    + "|";          // �ѱ������                 ����
all_policies +="1.2.410.200004.5.4.1.1"    + "|";          // �ѱ���������               ����
all_policies +="1.2.410.200012.1.1.1"      + "|";          // �ѱ������������           ����
all_policies +="1.2.410.200012.1.1.1"      + "|";          // �ѱ������������           ����
all_policies +="1.2.410.200004.5.5.1.1"    + "|";          // �̴���                    ����
all_policies +="1.2.410.200005.1.1.6.8"    + "|";          // ���ݰ�꼭����
all_policies +="1.2.410.200005.1.1.4"+ "|";// �����


var comp_policies = "";
comp_policies +="1.2.410.200004.5.2.1.1"    + "|";          // �ѱ���������               ����
comp_policies +="1.2.410.200004.5.1.1.7"    + "|";          // �ѱ���������               ����, ��ü, ���λ����
comp_policies +="1.2.410.200005.1.1.5"      + "|";          // ����������                 ����, ���Ǵ�ü, ���λ����
comp_policies +="1.2.410.200004.5.3.1.1"    + "|";          // �ѱ������                 ���(������� �� �񿵸����)
comp_policies +="1.2.410.200004.5.3.1.2"    + "|";          // �ѱ������                 ����(������� �� �񿵸������  ������ �������, ����)
comp_policies +="1.2.410.200004.5.4.1.2"    + "|";          // �ѱ���������               ����, ��ü, ���λ����
comp_policies +="1.2.410.200012.1.1.3"      + "|";          // �ѱ������������           ����
comp_policies +="1.2.410.200004.5.5.1.2"    + "|";          // �̴���                    ����
comp_policies +="1.2.410.200004.5.4.2.369"  + "|";          // ���̽���غ�����           ����

var person_policies = "";
person_policies +="1.2.410.200004.5.2.1.2"    + "|";          // �ѱ���������               ����
person_policies +="1.2.410.200004.5.1.1.5"    + "|";          // �ѱ���������               ����
person_policies +="1.2.410.200005.1.1.1"      + "|";          // ����������                 ����
person_policies +="1.2.410.200004.5.3.1.9"    + "|";          // �ѱ������                 ����
person_policies +="1.2.410.200004.5.4.1.1"    + "|";          // �ѱ���������               ����
person_policies +="1.2.410.200012.1.1.1"      + "|";          // �ѱ������������           ����
person_policies +="1.2.410.200004.5.5.1.1"    + "|";          // �̴���                    ����

// MODE 4 = NIM, nim + webstorage = 6
var unisign = UnisignWeb({
    Mode: 4,

    PKI: 'NPKI',
    SRCPath: '/cab/CrossCert/CC_WSTD_home/',
    DebugConsole: true, //������ ���� ���� ����  (default: true)
    Language: 'ko-kr',
    TargetObj: document.getElementById('ESignWindow'),
    TabIndex: 1000,
    LimitNumOfTimesToTryToInputPW: 3,

    /*�����ü �߰��� �����ؾߵ� �κ� */
    //Media: {'defaultdevice':'harddisk', 'list':'removable|sectoken|savetoken|mobilephone|harddisk'},/* plugin mode(Mode:1) media list */
    //Media: {'defaultdevice':'webstorage', 'list':'webstorage|touchsign|smartsign|websectoken|websofttoken'},/* plugin-free mode(Mode:2) media list */
    //Media: {'defaultdevice':'harddisk', 'list':'mobiletoken|sectoken|mobilephone|removable|harddisk'},/* all media(Mode:3) list */
    Media: {'defaultdevice':'harddisk', 'list':'harddisk|removable|sectoken'},/* all media(Mode:3) list */

    // ����ڿ� �������� ���̵��� ����
    Policy: comp_policies,

    //ShowExpiredCerts: false, ���������� ǥ�� ����

    CMPIP: 'testca.crosscert.com',  //CMP IP
    //CMPIP: '211.180.234.216',  //CMP IP
    CMPPort: 4502,  //CMP Port

    LimitMinNewPWLen: 8,
    LimitMaxNewPWLen: 64,
    LimitNewPWPattern: 0,  //0 : ���� ����, 1 : ����,���� ȥ��, 2 : ����,����,Ư������ ȥ��
    CertRequestPageEnable: 1,  // 0 : disable, 1 : enable, �������� ������ enable
    NimCheckURL : "javascript:try{OpenWindows('/cab/CrossCert/CC_WSTD_home/install/Obj_check.jsp','Obj_check',1000,700);}catch(e){alert('�˾��� ���ܵǾ����ϴ�.\n\n�˾��� ��� �� ��������������� ��ġ �ϼ���.');}" //��ġ������ URL����
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
