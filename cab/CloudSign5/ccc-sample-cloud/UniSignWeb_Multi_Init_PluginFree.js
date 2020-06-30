//document.writeln("<object id='unisignwebplugin' type='application/x-unisignwebplugin' width='0px' height='0px'> </object>");
document.writeln("<iframe  src='http://testca.crosscert.com/pftest/' name='hsmiframe' id='hsmiframe' style='visibility:hidden;position:absolute'></iframe>");
document.writeln("<div id='ESignWindow'></div>");


var unisign = UnisignWeb({
    Mode: 2,
    
    PKI: 'NPKI',
    SRCPath: '/cab/CloudSign5/CC_WSTD_home/',
    Language: 'ko-kr',
    TargetObj: document.getElementById('ESignWindow'),
    TabIndex: 1000,
    LimitNumOfTimesToTryToInputPW: 3,
 
    Media: {'defaultdevice':'cloudsign', 'list':'cloudsign'},/* plugin-free mode(Mode:2) media list */ // sharestorage, cloudsign
 //   Media: {'defaultdevice':'webstorage', 'list':'webstorage|cloudsign|touchsign|smartsign|websectoken|websofttoken'},/* plugin-free mode(Mode:2) media list */ // sharestorage, cloudsign
    
    //Policy: '1.2.410.200004.5.4.1.1|1.2.410.200004.5.1.1.5',
    //ShowExpiredCerts: false,
    
    //CMPIP: 'testca.crosscert.com',  //CMP IP
    CMPURL: 'http://203.248.34.63:18080/',
    SHARESTORAGE: 'http://testca.crosscert.com/pftest/',
        
    LimitMinNewPWLen: 8,
    LimitMaxNewPWLen: 64,
    LimitNewPWPattern: 0,  
    ChangePWByNPKINewPattern: true,
    
	// 사업자버머용 + 개인범용 + 은행(인터넷뱅킹용)
    Policy: '1.2.410.200004.5.2.1.1|1.2.410.200004.5.1.1.7|1.2.410.200005.1.1.5|1.2.410.200004.5.4.1.2|1.2.410.200012.1.1.3|1.2.410.200004.5.2.1.2|1.2.410.200004.5.1.1.5|1.2.410.200005.1.1.1|1.2.410.200004.5.4.1.1|1.2.410.200012.1.1.1|1.2.410.200005.1.1.4',

    // time license 
    License:"Ez46NDotAyAxKTU3ID0nORMeGhQaDQMAEQlkenJ5anV7ZHpjZXB9f2Z8eHV1e2J2PxYsITwwNjExPj1tJiE+YXJgeH1jbXV8ZWh7c3ZgYXF7fHxnfXV2digZDAURG2MXex81O2sadhgiL3oNLxQLD3MeIh0lIRYDLAEjIDADEHE0HiUWOA4vEy4AIwp1ARBxORwMZ2EOPAFhOAoVDjQSdBUjI2c+MTQabAIoewgDCxRzBHgxEgkcEDYVYhc3L2t1dCQ+KSIGBxFnHysFBggaM3MhIxkldi0jJz0uGzEfaigPISEWIyUCEAIoeg4WPyc1ABs5KyQsdGQ9OgYvDB0nJCUlNjgrFhMifx4vKyklawYWGBw6ZyJqIQErPwl9HjwsNT83G2cCLDA5PQEBASQEbnQ0NxVqFAgLDQE5cTdlBxwgfR5ubg=="
    //License: 'FjwmADokKwUxLgovLCs9MT+VnuLqg7mSjoyHgrAyBhYUFw0QHwpoZWN9e3RyeGRwcmF8fmFzdGdkdHt7ORphdXJnfmJgczkfPg0xDRELKwg5EwIJKwkXNR19ESAcAmokGxUIfB4FFgsbBDoTIDY3cDFqFxB8NAsLDgE+dTE+YzQbIC1gKyQgNWAvJhEKDRsyBWt2AgIlBmU1PyN2FD87BhIfZAIAez0oDh4oEAI4Enc3HjU5ByQxKiJ/JHIoFjwHBxYhZhE6IRQ1eAwIfAg1KREFB2QHAi8TFiYFLC85MAQgJCQ/YAcpAyQcIyAOGx8LFyMdZzAHHDAnFCUhMnNu'
});