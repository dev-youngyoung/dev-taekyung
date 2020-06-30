var USING_CUSTOM_IMAGE = 0;
var CUSTOM_IMAGE_URL = "";
var USING_TouchEnKey = "1";
var USING_isVM = 1; // 0 = false, 1 = true;
var USING_check_TouchEnKey = 0;
var isKeyUpCheck = "0"; // "0" = notload , "1" = new version , "2" = old version //20150216

var TouchEnKey_CLSID		= "clsid:6CE20149-ABE3-462E-A1B4-5B549971AA38";
var TouchEnKey_CODEBASE_x64 = "";
var TouchEnKey_CODEBASE_x86 = "";
var TouchEnKey_VERSION 		= "3,1,0,36";

var Multi_InstallBinary_x86	= "C:/Users/hello/workspace/woricapital_TouchEnKey/WebContent/TouchEnKey/module/TouchEnkey3.1.0.33_32k.cab";
var Multi_InstallBinary_x64	= "C:/Users/hello/workspace/woricapital_TouchEnKey/WebContent/TouchEnKey/module/TouchEnkey3.1.0.33_64k.cab";
var Multi_Version 			= "3.1.0.29";

var TouchEnKey_Installpage	= "/TouchEnKey/installpage/install.html"; // ��ġ������ ��� ������Ʈ ���� ������Ʈ ��ġ �������� ����

var TouchEnKey_baseType = "id";

var TouchEnKeyCert = "-----BEGIN CERTIFICATE-----MIIDSzCCAjOgAwIBAgIJAOYjCX4wgWIVMA0GCSqGSIb3DQEBCwUAMGcxCzAJBgNVBAYTAktSMR0wGwYDVQQKExRSYW9uU2VjdXJlIENvLiwgTHRkLjEaMBgGA1UECxMRUXVhbGl0eSBBc3N1cmFuY2UxHTAbBgNVBAMTFFJhb25TZWN1cmUgQ28uLCBMdGQuMB4XDTEzMTIzMDAxNTAxMloXDTIzMTIyODAxNTAxMlowRzELMAkGA1UEBhMCS1IxGzAZBgNVBAoTElJhb25TZWN1cmUgQ28uLEx0ZDEbMBkGA1UEAxMSUmFvblNlY3VyZSBDby4sTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsXWsBJXwRwoTwGbSwYZbyGWJsdNg8JM6lZ15hVMzRrz7epFAHqX0xcigLcLUTNoLmnegcn1Kvq96zxMyn8A7YJt1bjx2lHOwF5BC+yDVSeylKcsa4HUQ7gUUswzR7K+Ck3tUFklNp+CnsT/uq5s8lixWddepvhmqRCuBhSRoNDpw/KY8x5ZK8VByoRI8mIouwTTaMTT8BD0XV55YN6JR2QkE9doANlinByG2SLcI8zQFw5D2J+gnX006gNYmjqk4FXBQZNMsGP5o2CdOuor39j17jkhdzi6iJ0W87/7LbWaVh462ULuCN/iT5kbLSToeL4lAiUdhJKVTpK5n4AooLwIDAQABoxowGDAJBgNVHRMEAjAAMAsGA1UdDwQEAwIF4DANBgkqhkiG9w0BAQsFAAOCAQEAlh7htO04E4as1OiLRVBpwnBEFgYtDNq9dyb8KbBI/fqa3ny6xf8Fg+RIgHjP1d//hAe/9tXNDapJ9tC//5ikpCNTTsE4fVGLb0nfimSA4ZrqXL8p2METZ36oymxoxl1vL30FmmOst0TfgcF5YM9C+4wNsXq8qj+JtRejrImEjA7oW6pJOcnWutjrXlFKEDYHYymWfOiZqHQtWBwCv8P8PjD8jRJxPpKLpfsQU6MatAHXNsuYc0orUsG6wUxjwTTorBlSnjBnXeFsUK5UXaWK81tnN57dw2pT8OZoZw2JwCxCED6o+U8uqgZfioK4DTByHxdkssoOhjyot+0hYEGa9A==-----END CERTIFICATE-----";

var ServKeyForSending = null;

var TouchEn_BaseBRW = {
    ua      : navigator.userAgent.toLowerCase(),
    ie      : navigator.appName == 'Microsoft Internet Explorer',
    ie_		: navigator.userAgent.match('MSIE') == 'MSIE',
    ns      : navigator.appName == 'Netscape',
    ff      : navigator.userAgent.match('Firefox') == 'Firefox',
    sf      : navigator.userAgent.match('Safari') == 'Safari',
    op      : navigator.userAgent.match('Opera') == 'Opera',
    cr      : navigator.userAgent.match('Chrome') == 'Chrome',
    win     : navigator.platform.match('Win') == 'Win',
    mac     : navigator.userAgent.match('Mac') == 'Mac',
    linux   : navigator.userAgent.match('Linux') == 'Linux',
    ie11	: navigator.userAgent.match('Trident/7.0') == 'Trident/7.0'
};

var getPluginType = {
    TouchEn_FFMIME      : ((TouchEn_BaseBRW.win) && (TouchEn_BaseBRW.ff ||TouchEn_BaseBRW.op)),
    TouchEn_SFMIME      : ((TouchEn_BaseBRW.win) && (TouchEn_BaseBRW.sf ||TouchEn_BaseBRW.cr)),
  	TouchEn_ACTIVEX   	: (TouchEn_BaseBRW.win && ( TouchEn_BaseBRW.ie || TouchEn_BaseBRW.ie11 || TouchEn_BaseBRW.ie_)),
    TouchEn_NPRUNTIME   : (TouchEn_BaseBRW.win && ((TouchEn_BaseBRW.ff || TouchEn_BaseBRW.sf || TouchEn_BaseBRW.cr) || TouchEn_BaseBRW.op)),
    TouchEn_OtherNP     : (TouchEn_BaseBRW.win && (TouchEn_BaseBRW.cr || TouchEn_BaseBRW.op)),
    TouchEn_OtherOS     : (TouchEn_BaseBRW.mac || TouchEn_BaseBRW.linux)
};

if(getPluginType.TouchEn_ACTIVEX){
     if(navigator.cpuClass.toLowerCase() == "x64")   {
            Multi_InstallBinary = Multi_InstallBinary_x64;
        } else {
            Multi_InstallBinary = Multi_InstallBinary_x86;
    }
}else if(getPluginType.TouchEn_NPRUNTIME){
    Multi_InstallBinary = Multi_InstallBinary_x86;
}else{
    Multi_InstallBinary = Multi_InstallBinary_x86;       
}

function downloadBinary() {
	//location.href = Multi_InstallBinary; 20141203 �ּ�ó��
}

function checkTouchEnKeyMime() {
	if (getPluginType.TouchEn_NPRUNTIME) {
		var CKmType = navigator.plugins["TouchEn Key for Multi-Browser"];
		if (CKmType == undefined) {
			return false;
		} else {
			return true;
		}
	}
}

function PrintTouchEnKeyActiveXTag() {
    if(USING_TouchEnKey == "1") {
        var Str="";

        Str+= '<object classid="' + TouchEnKey_CLSID + '"';
        if(navigator.cpuClass.toLowerCase() == "x64") {
        	Str+= '\n\t codebase="' + TouchEnKey_CODEBASE_x64 + '#version=' + TouchEnKey_VERSION + '"';
        } else {
        	Str+= '\n\t codebase="' + TouchEnKey_CODEBASE_x86 + '#version=' + TouchEnKey_VERSION + '"';
        }
        Str+= '\n\tvspace="0" hspace="0" width="0" id="TouchEnKey" style="display:none;">';
        Str+= '\n\t <PARAM name="PKI" value="TouchEnKeyEx">';
        Str+= '\n\t <PARAM name="DefaultEnc" value="Off">';//E2E��� Defualt ����
        Str+= '\n\t <PARAM name="DefaultPaste" value="On>';//�ٿ��ֱ� ��뿩��
        Str+= '\n\t <PARAM name="ClearBufferOnEmpty" value="true">';//���ۿ� ����� ��ȣȭ ������ �ڵ� ���� ����
        Str+= '\n\t <PARAM name="IDBase" value="On">';//ID ����� ����� �������� �Ǵ�       
        Str+= '\n\t <PARAM name="Verify" value="0">';//Ű���庸�� ���۽� ���Ἲ �˻�(0,1,2)
        if(USING_CUSTOM_IMAGE) {
            Str+= '\n\t <PARAM name="ImageURL" value="' + CUSTOM_IMAGE_URL + '">';
        }

        Str+= '</object>';
        document.write(Str);
    }
}

function PrintTouchEnKeyEmbedTag() {

    if(USING_TouchEnKey == "1") {
        var Str="";
        Str+= '<EMBED id="TouchEnKey" type="application/ClientKeeperKeyPro" width=0 height=0 ';
        if(USING_CUSTOM_IMAGE) {
            Str+= 'ImageURL="' + CUSTOM_IMAGE_URL + '" ';
        }
        Str+= 'PKI="TouchEnKeyEx"';
        Str+= 'TKFieldNotCheckPrefix="transkey_Tk_|transkey_"';
        Str+= 'RefreshSession="true"';
        Str+= 'DefaultPaste="on"';
        Str+= 'GenerateEvent="on"';
        Str+= 'IDBase="on"';
        Str+= 'Verify="0"'; 
        Str+= '>';
        Str+= '</EMBED>';
        Str+= '<NOEMBED>no TouchEn Key</NOEMBED>';

        document.write(Str);
    }
}

function PrintTouchEnKeyTag() {
    if(getPluginType.TouchEn_ACTIVEX) {
        PrintTouchEnKeyActiveXTag();
    } else if(getPluginType.TouchEn_NPRUNTIME) {
        var mTypeRet = checkTouchEnKeyMime();
        if(mTypeRet) {
            PrintTouchEnKeyEmbedTag();
        } else {
        	location.href = TouchEnKey_Installpage;
        }
    }
}


function XecureCK_UIEevents(frm,ele,event,keycode) {
	TouchEnKey_UIEevents(frm,ele,event,keycode);
}

function TouchEnKey_UIEevents(frm,ele,event,keycode) { // 20150216
 	var obj;
    var e;
    try {
        if(isKeyUpCheck=="0"){
        	if (document.getElementById("TouchEnKey").IsKeyup()) {
        		isKeyUpCheck = "1";
        	}
    	}
    } catch(e) {
        isKeyUpCheck = "2";
    }
	if (isKeyUpCheck=="1") {
	    try {
    		obj = document.activeElement;
    		e = event.replace("on", "");		
    		triggerEvent(obj, e, keycode);
		} catch(e){
		}
	} else {
    try {
        obj = document.activeElement;
        if(document.createEvent) {
            if(window.KeyEvent) {
                e = document.createEvent('KeyEvents');
                e.initKeyEvent(event, true, true, window, false, false, false, false, keycode, 0);
            } else {
                e = document.createEvent('UIEvents');
                e.initUIEvent(event, true, true, window, 1);
    	        e.keyCode = keycode;
            }
            obj.dispatchEvent(e);
            } else {
            e = document.createEventObject();
            e.keyCode = keycode;
            obj.fireEvent(event, e);
            }
        } catch(e) {
        }  
    }
}

function triggerEvent(el,eventName,keycode){

	var htmlEvents = {
		onkeydown:1,
		onkeypress:1,
		onkeyup:1
	}
    var event;
    if(document.createEvent){
        event = document.createEvent('HTMLEvents');
        event.initEvent(eventName,true,true);
    }else if(document.createEventObject){// IE < 9
        event = document.createEventObject();
        event.eventType = eventName;
    }
    event.eventName = eventName;
		event.keyCode = keycode;
		event.which = keycode;
	
    if(el.dispatchEvent){
        el.dispatchEvent(event);
    }else if(el.fireEvent && htmlEvents['on'+eventName]){
        el.fireEvent('on'+event.eventType,event);
    }else if(el[eventName]){
        el[eventName]();
    }else if(el['on'+eventName]){
        el['on'+eventName]();
    }
}

function TouchEnkey_GetVariable(name) {
    if(name == "SR") {
     return TNK_SR;
    }
}

function DrawHiddenElements(frm) {
	if (frm.hid_key_data == null && frm.hid_enc_data == null) {
		var newEle = document.createElement("input");
	    newEle.type = "hidden";
	    newEle.name = "hid_key_data";
	    newEle.id = "hid_key_data";
	    newEle.value = "";
	    frm.appendChild(newEle);
	
	    var newEle = document.createElement("input");
	    newEle.type = "hidden";
	    newEle.name = "hid_enc_data";
	    newEle.id = "hid_enc_data";
	    newEle.value = "";
	    frm.appendChild(newEle);
	  }
}


function GetEncDataFun(keyData, frm, ele) {
    return document.getElementById('TouchEnKey').GetEncData(keyData, frm, ele);
}

function findElementByName(form, eleName) {
    if(eleName == null) {
        return null;
    }

    var findEle = null;
    var len = form.elements.length;
    for(var i=0; i<len; i++) {
        if(eleName == form.elements[i].name) {
            return form.elements[i];
        }
    }
}

/* ID type function */

function GetEncDataCert() {
    if(TouchEnKeyCert != "undefined"){
	    return document.getElementById("TouchEnKey").GetEncData(TouchEnKeyCert, "", "");
	}
}

function GetEncDataById(ObjId) {
    if(ObjId != "undefined" && ObjId != null){
        return document.getElementById("TouchEnKey").GetEncData("", "",  ObjId);
    }
}

function TouchEnKeyClearById(ObjId) {
    if(ObjId != "undefined" && ObjId != null){
	    document.getElementById("TouchEnKey").Clear("", ObjId, 0);
	}
}

function TouchEnKey_IsVM(){
  try{
    if(USING_isVM){
        var tmp = false;
        if (isInstalledTouchEnKey()){
          if(getPluginType.TouchEn_ACTIVEX){
                //tmp = document.getElementById("TouchEnKey").isVM(); 20141209
          }else if(getPluginType.TouchEn_NPRUNTIME){
            tmp = document.getElementById("TouchEnKey").IsVM();
          }
        }else{
          return false;
        }
        return tmp;
    }else{
        return false;
    }
  }catch(e){
    return false;
  }
}

function TouchEnKeyEnqueueListById(ObjId) {
    if(getPluginType.TouchEn_ACTIVEX) {
    	document.getElementById("TouchEnKey").EnqueueList("", ObjId);
    }else if(getPluginType.TouchEn_NPRUNTIME) {
      if(!TouchEnKey_IsVM()){
      		var tmp = document.getElementById(ObjId);
         	if(tmp.addEventListener){
             tmp.addEventListener("focus", CK_Start, false);       //w3c
             tmp.addEventListener("blur", CK_Stop, false);     //w3c
             tmp.addEventListener("click", CK_Click, false);       //w3c
             tmp.addEventListener("mouseup", CK_Click, false);     //w3c
             tmp.addEventListener("keydown", CK_KeyDown, false); //w3c ff/safari/chrome
             tmp.addEventListener("keypress", CK_KeyDown, false);      //w3c opera
         } else if(x[i].attachEvent) {
             tmp.attachEvent("onfocus", CK_Start);                 //msdom
             tmp.attachEvent("onblur", CK_Stop);                   //msdom
         }
       }                 
    }
}

function TouchEnKey_Clear(frmName, eleName) {
   if (isInstalledTouchEnKey()) {
      if (getPluginType.TouchEn_ACTIVEX){
         document.getElementById("TouchEnKey").Clear(frmName,eleName,0);
      } else if (getPluginType.TouchEn_NPRUNTIME){
         document.getElementById("TouchEnKey").Clear(frmName,eleName);
      }
   } else {
      return false;
   }
}


/* ID type function */


function makeEncData(frm) {
	if(navigator.platform.match('Win') != 'Win'){
		return true;
	}
	if (navigator.userAgent.indexOf("Opera") > -1 && navigator.userAgent.indexOf("Version/12.") > -1 ){
		return true;
	} 
	try{
		var encFieldCnt = 0;
		var fieldCnt = 0;
		var cipherEncText = "";
		var checkE2E = false;
		var elelength = frm.elements.length;
		
		var name = new Array(elelength);
		var value = new Array(elelength);
		
	  for (var j=0;j < elelength;j++)
	  {
	      if(frm.elements[j].tagName == "INPUT" && 
	    		  (frm.elements[j].type == "text" || frm.elements[j].type == "password") && 
	    		  (frm.elements[j].getAttribute("data-enc")=="on"||frm.elements[j].getAttribute("enc")=="on"))
	      {	
	    	checkE2E = true;
	      	name[encFieldCnt] = "E2E_" + frm.elements[j].id;
	      	value[encFieldCnt] = GetEncDataFun("", frm.name, frm.elements[j].id);
//	      	alert("val = " + GetEncDataFun("", frm.name, frm.elements[j].id));
	      	e2eEle = findElementByName(frm, name[encFieldCnt]);
	      			if( e2eEle == null ) {
							var newEle = document.createElement("input");
							newEle.type = "hidden";
							newEle.name = name[encFieldCnt];
							newEle.value = value[encFieldCnt];
							frm.appendChild(newEle);
					}
					else {
							e2eEle.value = value[encFieldCnt];
					}
					encFieldCnt++;
	      }
	  }
	  	if(checkE2E){
			for (i = 0; i < encFieldCnt; i++) {
				if (value[i] != "undefined") {
					cipherEncText += name[i];
					cipherEncText += "=";	
					cipherEncText += value[i];
					cipherEncText += "%TK%";
				}
			}
		
			DrawHiddenElements(frm); 
			frm.hid_key_data.value = GetEncDataFun(TouchEnKeyCert, "", "");
//			alert("cipher = " + cipherEncText);
			frm.hid_enc_data.value = cipherEncText;
		}
		return true;                       
	} 
	catch(e) 
	{
		return false;
	}
}

var CK_objFocused;
function CK_Start(nsEvent) {
    if(!getPluginType.TouchEn_NPRUNTIME) return;

    var theEvent;
    var inputObj;

    if(nsEvent.type == "text" || nsEvent.type == "password") {
        inputObj = nsEvent;
    } else {
        theEvent = nsEvent ? nsEvent : window.event;
        inputObj = theEvent.target ? theEvent.target : theEvent.srcElement;
    }

    try {
        document.getElementById('TouchEnKey').StartCK(inputObj);
        CK_objFocused = inputObj;
        CK_OP_IsStart = true;  
    } catch(e) {
    }
}

function CK_Stop() {
    if(!getPluginType.TouchEn_NPRUNTIME) return;

    try {
        document.getElementById('TouchEnKey').StopCK();
        CK_OP_IsStart = false;
    } catch(e) {
    }
}

function CK_PatchKey() {
    if(!getPluginType.TouchEn_NPRUNTIME) return;

    try {
        document.getElementById('TouchEnKey').PatchKey(CK_objFocused);
    } catch(e) {
    }
}

function CK_Blur() {
    if(!getPluginType.TouchEn_NPRUNTIME) return;

    try {
        CK_objFocused.blur();
    } catch(e) {
    }
}

function CK_Click(nsEvent) {
    var theEvent;
    var inputObj;

    if(nsEvent.type == "text" || nsEvent.type == "password") {
        inputObj = nsEvent;
    } else {
        theEvent = nsEvent ? nsEvent : window.event;
        inputObj = theEvent.target ? theEvent.target : theEvent.srcElement;
    }

}
function CK_KeyDown(nsEvent) {
    var theEvent;
    var inputObj;

    if(nsEvent.type == "text" || nsEvent.type == "password") {
        inputObj = nsEvent;
    } else {
        theEvent = nsEvent ? nsEvent : window.event;
        inputObj = theEvent.target ? theEvent.target : theEvent.srcElement;
    }

    if((typeof(inputObj.getAttribute("enc")) == "undefined") ||
    		((inputObj.getAttribute("enc") != "on") && (inputObj.getAttribute("data-enc") != "on")) ) return;//20151019 HJM ���� �߰�

    if((theEvent.keyCode >= 35 && theEvent.keyCode <= 40)||(theEvent.keyCode == 46)) {
        if(theEvent.preventDefault) theEvent.preventDefault();
        if(theEvent.stopPropagation) theEvent.stopPropagation();

        theEvent.returnValue = false;
        theEvent.cancelBubble = true;

        return;
    }
}


function TouchEnKey_ApplySecurity() {
    if(!getPluginType.TouchEn_NPRUNTIME) return;
    
    if (TouchEnKey_baseType == "id") {
    	try {            
            var x=document.getElementsByTagName("input");
                      for(var i=0;i<x.length;i++) {
                         if(x[i].tagName == "INPUT" && (x[i].type == "text" || x[i].type == "password")) {
                             if(x[i].addEventListener){
                                 x[i].addEventListener("focus", CK_Start, false);       //w3c
                                 x[i].addEventListener("blur", CK_Stop, false);     //w3c
                                 x[i].addEventListener("click", CK_Click, false);       //w3c
                                 x[i].addEventListener("mouseup", CK_Click, false);     //w3c
                                 x[i].addEventListener("keydown", CK_KeyDown, false); //w3c ff/safari/chrome
                                 x[i].addEventListener("keypress", CK_KeyDown, false);      //w3c opera
               
                             } else if(x[i].attachEvent) {
                                 x[i].attachEvent("onfocus", CK_Start);                 //msdom
                                 x[i].attachEvent("onblur", CK_Stop);                   //msdom
                             }
                        }
                 }
        } catch(e) {
        }

    } else {
    
	    try {
	        for(var i=0;i<document.forms.length;i++) {
	            for(var j=0;j < document.forms[i].elements.length;j++) {
	                if(document.forms[i].elements[j].tagName == "INPUT" && (document.forms[i].elements[j].type == "text" || document.forms[i].elements[j].type == "password")) {
	                    if(document.forms[i].elements[j].addEventListener){
	                        document.forms[i].elements[j].addEventListener("focus", CK_Start, false);       //w3c
	                        document.forms[i].elements[j].addEventListener("blur", CK_Stop, false);     //w3c
	                        document.forms[i].elements[j].addEventListener("click", CK_Click, false);       //w3c
	                        document.forms[i].elements[j].addEventListener("mouseup", CK_Click, false);     //w3c
	                        document.forms[i].elements[j].addEventListener("keydown", CK_KeyDown, false);       //w3c ff/safari/chrome
	                        document.forms[i].elements[j].addEventListener("keypress", CK_KeyDown, false);      //w3c opera
	
	                    } else if(document.forms[i].elements[j].attachEvent) {
	                        document.forms[i].elements[j].attachEvent("onfocus", CK_Start);                 //msdom
	                        document.forms[i].elements[j].attachEvent("onblur", CK_Stop);                   //msdom
	                    }
	                }
	            }
	        }
	    } catch(e) {
	    }
    }
}

function TouchEnKey_ReScan() {
    if(USING_TouchEnKey == 1) {
        if(getPluginType.TouchEn_ACTIVEX) {
            var obj = document.getElementById("TouchEnKey");
            obj.ReScanDocument();
        } else {
            TouchEnKey_ApplySecurity();
        }
    }
}

function TouchEnKey_EnqueueList(frmName, eleName) {
  document.TouchEnKey.EnqueueList(frmName, eleName);
}


function TouchEnKey_InvalidateSession() {
	if (isInstalledTouchEnKey()) {
		if (getPluginType.TouchEn_ACTIVEX){
			document.getElementById('TouchEnKey').InvalidateSession();
		} else if (getPluginType.TouchEn_NPRUNTIME) {
			document.getElementById('TouchEnKey').InvalidateSession();
		}
	} else {
		return false;
	}
}

function GetKeyStateCheck(keyname){
	return document.getElementById('TouchEnKey').GetKeyState(keyname);
}

function isInstalledTouchEnKey() {
	var installed = false;
    if(!getPluginType.TouchEn_NPRUNTIME) {
        if(document.TouchEnKey==null || typeof(document.TouchEnKey) == "undefined" || document.TouchEnKey.object == null) {
            installed = false;
        } else {
             installed = true; 
        }
    } else {

        if(checkTouchEnKeyMime()) {
            try {
                IsNeedUpdate = document.getElementById('TouchEnKey').NeedUpdate(Multi_Version);
                if(IsNeedUpdate==false) {
                     installed = true;
                } else {
                    installed = false;
                }
            } catch(e) {
                installed = false;
            }
        } else {
            installed = false;
        }
    }
 
    return installed;
}

if (!TouchEn_BaseBRW.win) {

} else {

	if(navigator.userAgent.indexOf("Opera") > -1 && navigator.userAgent.indexOf("Version/12") > -1){
	} else {
		PrintTouchEnKeyTag();
		
		if(isInstalledTouchEnKey()) {
		} else {
			location.href = TouchEnKey_Installpage;
		}
	}
}