/**
* 파일명: lib.validate.js
* 설  명: 폼 체크, 값 표준화
* 작성자: jstoy project
* 날  짜: 2003-10-28
*   lainTT (2003-11-20) : FormChecker Class의 함수 prototype화 & 전역변수를 클래스 안으로...-_-;
***********************************************
*/

/**
* <pre>
* 폼 체크 trigger 함수
* </pre>
*
* @param Form Object
* @return boolean
*/
function validate(form, bCheckRecvWrite) {
    var result;
    var checker = new FormChecker(form, bCheckRecvWrite);

    result = checker.go();
    checker.destroy();
    return result;
}

function validate_init() {
    for (var i=0; i<document.forms.length; i++) {
        var formObj = document.forms[i];
        if (document.forms[i].getAttribute('VALIDATE') != null) {
            // pre_validate를 사용하지 않는다면 이 아랫줄을 주석처리합니다.
            new FormLoader(formObj);
            formObj.submitAction = formObj.onsubmit;
            formObj.onsubmit = function() {
                formObj.submitAction;
                return validate(this);
            }
        }
    }
}

FormChecker = function(form, bCheckRecvWrite) {
    /**
    * <pre>
    * 미리 정의된 에러 메시지들
    * </pre>
    */
    /*
    this.FORM_ERROR_MSG = {
       //common   : "입력하신 내용이 규칙에 어긋납니다.\n규칙에 어긋나는 내용을 바로잡아주세요.",
	   common	: "",
       required : "반드시 입력하셔야 합니다.",
       notequal : "서로 일치하지 않습니다.",
       invalid  : "입력 형식에 어긋납니다.",
	   denied   : "업로드가 제한된 파일입니다.",
       minbyte  : "길이가 {minbyte}Byte 이상이어야 합니다.",
       maxbyte  : "길이가 {maxbyte}Byte를 초과할 수 없습니다."
    }
    */
    this.FORM_ERROR_MSG = {
       //common   : "입력하신 내용이 규칙에 어긋납니다.\n규칙에 어긋나는 내용을 바로잡아주세요.",
	   common	: "",
       required : "입력하세요.",
       notequal : "서로 일치하지 않습니다.",
       invalid  : "잘못 입력하였습니다.",
	   denied   : "업로드가 제한된 파일입니다.",
       minbyte  : "{minbyte}자 이상 입력하세요.",
       maxbyte  : "{maxbyte}자 이내로 입력하세요.",
       fixbyte  : "{fixbyte}자 로 입력하세요."
    }
    this.FORM_ERROR_MSG_POSTPOSITION = {
       //common   : "입력하신 내용이 규칙에 어긋납니다.\n규칙에 어긋나는 내용을 바로잡아주세요.",
	   common	: "",
       required : "을",
       notequal : "이",
       invalid  : "을",
	   denied   : "은",
       minbyte  : "은",
       maxbyte  : "은",
       fixbyte  : "은"
    }

    /**
    * <pre>
    * 폼 체크 함수 매핑
    * </pre>
    */
    this.VALIDATE_FUNCTION = {
       email   : this.func_isValidEmail,
       phone   : this.func_isValidPhone,
       userid  : this.func_isValidUserid,
       userpw  : this.func_isValidPasswd,
       hangul  : this.func_hasHangul,
       number  : this.func_isNumeric,
       money   : this.func_isMoney,
       engonly : this.func_alphaOnly,
       date    : this.func_isValidDate,
       jumin   : this.func_isValidJumin,
       bizno   : this.func_isValidBizNo
    }

    /**
    * <pre>
    * 에러 출력 플래그
    * </pre>
    */
    this.ERROR_MODE_FLAG = {
       all         : 1,         // 전체 에러를 표시
       one         : 2,         // 처음에 걸린 에러 하나만 표시
       one_per_obj : 3          // 한 object당 처음의 에러 표시
    }

    this.form      = form;
    this.isErr     = false;
    this.errMsg    = (this.FORM_ERROR_MSG["common"] != "") ? this.FORM_ERROR_MSG["common"] + "\n\n" : "";
    this.errObj    = "";
    this.curObj    = "";
    this.errMode   = this.ERROR_MODE_FLAG["one"];  // 에러메시지 출력모드
	this.recvCheck = (bCheckRecvWrite == true) ? true : false;
}

FormChecker.prototype.go = function() {
    for (var i = 0; i < this.form.elements.length; i++) {
        var el = this.form.elements[i];
        if (el.tagName.toLowerCase() == "fieldset" || el.tagName.toLowerCase() == "object")
            continue;
        
        /*IE 10 대응 domhtml 상에 required의 문자 있으면 Y로 set해준다.*/
		var sTestHtml = el.outerHTML.toUpperCase();
		var nPos = sTestHtml.indexOf("REQUIRED");
		var nChar = sTestHtml.charAt(nPos-1);
        if(nPos>0 && nChar==' ')
        	el.setAttribute("required","Y");
        
        if (el.getAttribute("HNAME") == null || el.getAttribute("HNAME") == "")
            el.setAttribute("HNAME", el.getAttribute("NAME"));
        
		var trim    = el.getAttribute("TRIM");
        var minbyte = el.getAttribute("MINBYTE");
        var maxbyte = el.getAttribute("MAXBYTE");
        var fixbyte = el.getAttribute("FIXBYTE");
        var option  = el.getAttribute("OPTION");
        var match   = el.getAttribute("MATCH");
        var delim   = el.getAttribute("DELIM");
        var glue    = el.getAttribute("GLUE");
        var pattern = el.getAttribute("PATTERN");
		var allow = el.getAttribute("ALLOW");
		var deny = el.getAttribute("DENY");
		var func = el.getAttribute("FUNC");

        if (el.type == "text") {
            switch (trim) {
                case "ltrim": el.value = el.value.ltrim(); break;
                case "rtrim": el.value = el.value.rtrim(); break;
                case "notrim": break;
                default:      el.value = el.value.trim();  break;
            }
        }

		if( (el.getAttribute("WRITABLE") != null && this.recvCheck == true) // 수급사업자 작성 필드이고 수급사업자가 체크하는 경우
			 || (el.getAttribute("WRITABLE") == null && this.recvCheck == false) )	// 원사업자가 체크
		{
			if (el.getAttribute("REQUIRED") != null || el.getAttribute("CHK_REQUIRED") != null) {
				var bChkRequired = true;
				if(el.getAttribute("CHK_REQUIRED") != null) // 체크박스 선택에 따라 필수 체크하는 경우. 만약 체크 안되어 있으면 체크하지 않는다.
				{
					if(this.form.elements[el.getAttribute("CHK_REQUIRED")] != null)
						bChkRequired = this.form.elements[el.getAttribute("CHK_REQUIRED")].checked;
				}
				
				if(bChkRequired){
					switch (el.type) {
						case "file": case "text": case "textarea": case "password": case "hidden":
							if (el.value == null || el.value == "") this.addError(el,"required");
							break;
						case "select-one":
							if (el.options.length == 0 || el[el.selectedIndex].value == null || el[el.selectedIndex].value == "") this.addError(el,"required");
							break;
						case "radio":
						case "checkbox":
						   // var elCheck = this.form.elements[el.name];
							var elCheck = document.getElementsByName(el.name);
							for (var j = 0, isChecked = false; j < elCheck.length; j++) {
								if (elCheck[j].checked == true) isChecked = true;
							}
							if (isChecked == false) this.addError(el,"required");
							break;

						//case "checkbox":
						 //   if (el.checked == false) this.addError(el,"required");
						 //   break;
					}
				}
			}
			if (el.type == "text" || el.type == "password") {
				if (match && (el.value != this.form.elements[match].value)) {
					this.addError(el,"notequal");
				}
				if (el.value && option != null) {
					if (glue != null) {
						var _value = new Array(el.value);
						var glue_arr = glue.split(",");
						for (var j = 0; j < glue_arr.length; j++) {
							_value[j+1] = this.form.elements[glue_arr[j]].value;

						}
						var value = _value.join(delim == null ? "" : delim);
						var tmp_msg = this.VALIDATE_FUNCTION[option](el, value);
						if (tmp_msg != true) this.addError(el,tmp_msg);
					} else {
						var tmp_msg = this.VALIDATE_FUNCTION[option](el);
						if (tmp_msg != true) this.addError(el,tmp_msg);
					}
				}
				
				if (el.value && minbyte != null && el.getAttribute("REQUIRED") != null) {
					if (el.value.bytes() < parseInt(minbyte)) this.addError(el,"minbyte");
				}
				if (el.value && maxbyte != null) {
					if (el.value.bytes() > parseInt(maxbyte)) this.addError(el,"maxbyte");
				}
				if (el.value && fixbyte != null && el.getAttribute("REQUIRED")) {
					if (el.value.bytes() != parseInt(fixbyte)) this.addError(el,"fixbyte");
				}
				if (pattern != null) {
					pattern = new RegExp(pattern);
					if (!pattern.test(el.value)) this.addError(el,'invalid');
				}
			}
			if (el.type == "file") {
				if (el.value && allow != null && allow != "") {
					pattern = new RegExp("(" + allow.replaceAll(",", "|").toLowerCase() + ")$");
					if (!pattern.test(el.value.toLowerCase())) this.addError(el,'denied');
				}
				if (el.value && deny != null && deny != "") {
					pattern = new RegExp("(" + deny.replaceAll(",", "|").toLowerCase() + ")$");
					if (pattern.test(el.value.toLowerCase())) this.addError(el,'denied');
				}
			}

			if(func) {
				if(this.isErr) continue;
				var result;
				if(func.indexOf("(") > 0)
					result = eval(func);
				else
					result = eval(func + "()");
				if(result + "" == "undefined") {
					this.addError(el, "개발:[FUNC]속성 사용시 반드시 결과값(true/false)을 리턴해야 합니다.");
				}
				if(result === false) {
					return false;
					this.addError(el, "invalid");
				} else if(result !== true && result != "") {
					//this.errMsg = result;
					el.setAttribute("func_errmsg", result);
					this.addError(el, result);
				}
			}
		}
    }
    return !this.isErr;
}

FormChecker.prototype.destroy = function() {
    if (this.isErr == true) {
        alert(this.errMsg);
        if (this.errObj.getAttribute("delete") != null)
            this.errObj.value = "";
        if (this.errObj.getAttribute("select") != null)
            this.errObj.select();
        if (this.errObj.getAttribute("errfunc") != null)	// 물류 현대택배에서 사용. 필수입력 사항 없는 경우 탭이동하는 함수 호출.
            eval(this.errObj.getAttribute("errfunc"));
        if (this.errObj.getAttribute("nofocus") == null && this.errObj.type != "hidden")
            this.errObj.focus();
    }
    this.errMsg = "";
    this.errObj = "";
}

FormChecker.prototype.addError = function(el, type) {
    var pattern = /\{([a-zA-Z0-9_]+)\}/i;
    var msg = (this.FORM_ERROR_MSG[type]) ? this.FORM_ERROR_MSG[type] : type;
    var pp = this.FORM_ERROR_MSG_POSTPOSITION[type] ? this.FORM_ERROR_MSG_POSTPOSITION[type] : "은";

	if(type == "required") {
		if(el.type == "checkbox" || el.type == "radio" || el.type == "file" || el.type == "select-one") {
			msg = "선택해 주세요.";
		}
	}

	if (el.getAttribute("errmsg") != null) msg = el.getAttribute("errmsg");
    
    if (pattern.test(msg) == true) {
        while (pattern.exec(msg)) msg = msg.replace(pattern, el.getAttribute(RegExp.$1));
    }

    if (!this.errObj || this.errMode != this.ERROR_MODE_FLAG["one"]) {
        if (this.curObj == el.name && el.getAttribute("errmsg") == null) {
            if (this.errMode == this.ERROR_MODE_FLAG["all"]) {
                this.errMsg += "   - "+ msg +"\n";
			}
        } else if (this.curObj != el.name) {
            if (this.curObj) {
                    this.errMsg += "\n";
			}

			if(el.getAttribute("func_errmsg") != null) {
				this.errMsg += type;
			} else {
				if (el.getAttribute("errmsg") != null) {
					this.errMsg += el.getAttribute("errmsg");
				} else {
				//	this.errMsg += "["+ el.getAttribute("hname") +"] 항목은 "+ msg +"\n";
					this.errMsg += postposition(el.getAttribute("hname"), pp) + " " + msg +"\n";
				}
			}
			//el.style.backgroundColor = "yellow";
        }
    }

	if (!this.errObj) this.errObj = el;
    this.curObj = el.name;
    this.isErr = true;
    return;
}

/// 패턴 검사 함수들 ///
FormChecker.prototype.func_isValidEmail = function(el,value) {
   var value = value ? value : el.value;
   var pattern = /^[_a-zA-Z0-9-\.]+@[\.a-zA-Z0-9-]+\.[a-zA-Z]+$/;
   return (pattern.test(value)) ? true : "invalid";
}

FormChecker.prototype.func_isValidUserid = function(el) {
   var pattern = /^[a-zA-Z]{1}[a-zA-Z0-9_]{5,19}$/;
   return (pattern.test(el.value)) ? true : "6자이상 20자 이하,\n영문, 숫자 문자 조합만 사용할 수 있습니다.(첫글자 영문)";
}

FormChecker.prototype.func_isValidPasswd = function(el) {
	var pw = el.value;
	var alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	var number = "1234567890";
	var sChar = "-_=+\|()*&^%#@!~`?></;,.:'";

	var sChar_Count = 0;
	var alphaCheck = false;
	var numberCheck = false;

	if(8 <= pw.length && pw.length <= 20){
		for(var i=0; i<pw.length; i++){
			if(pw.charAt(i)=='$')
				return "$문자는 사용할 수 없습니다.";
			
			if(pw.charAt(i)=='\\')
				return "\\문자는 사용할 수 없습니다.";

			if(sChar.indexOf(pw.charAt(i)) != -1){
				sChar_Count++;
			}
			if(alpha.indexOf(pw.charAt(i)) != -1){
				alphaCheck = true;
			}
			if(number.indexOf(pw.charAt(i)) != -1){
				numberCheck = true;
			}
		}

		if(sChar_Count < 1 || alphaCheck != true || numberCheck != true){
			return "영문 1자, 숫자 1자, 특수문자 1자 이상으로 조합 해주세요";
		}

	}else{
		return "8자 이상 20자 미만으로 조합 해주세요";
	}
	return true;
}


FormChecker.prototype.func_hasHangul = function(el) {
   var pattern = /[가-힝]/;
  // return (pattern.test(el.value)) ? true : "반드시 한글을 포함해야 합니다";
   return (pattern.test(el.value)) ? true : "한글을 포함해야 합니다";
}

FormChecker.prototype.func_alphaOnly = function(el) {
   var pattern = /^[a-zA-Z]+$/;
   return (pattern.test(el.value)) ? true : "invalid";
}

FormChecker.prototype.func_isNumeric = function(el) {
   var pattern = /^[0-9]+$/;
  // return (pattern.test(el.value)) ? true : "반드시 숫자로만 입력해야 합니다";
   return (pattern.test(el.value)) ? true : "숫자로만 입력해야 합니다";
}

FormChecker.prototype.func_isMoney = function(el) {
   var pattern = /^[0-9\,]+$/;
  // return (pattern.test(el.value)) ? true : "반드시 숫자로만 입력해야 합니다";
   return (pattern.test(el.value)) ? true : "숫자로만 입력해야 합니다";
}

FormChecker.prototype.func_isValidJumin = function(el,value) {
    var pattern = /^([0-9]{6})-?([0-9]{7})$/;
    var num = value ? value : el.value;
    if (!pattern.test(num)) return "invalid";
    num = RegExp.$1 + RegExp.$2;

    var sum = 0;
    var last = num.charCodeAt(12) - 0x30;
    var bases = "234567892345";
    for (var i=0; i<12; i++) {
        if (isNaN(num.substring(i,i+1))) return "invalid";
        sum += (num.charCodeAt(i) - 0x30) * (bases.charCodeAt(i) - 0x30);
    }
    var mod = sum % 11;
    return ((11 - mod) % 10 == last) ? true : "invalid";
}

FormChecker.prototype.func_isValidDate = function(el,value) {
    var pattern =  /^(19|20)\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])$/;
    var num = value ? value : el.value;
    num = num.replaceAll("-","");
    return (pattern.test(num))? true:"날짜형식이 올바르지 않습니다.";
}



FormChecker.prototype.func_isValidBizNo = function(el,value) {
    var pattern = /([0-9]{3})-?([0-9]{2})-?([0-9]{5})/;
    var num = value ? value : el.value;
    if (!pattern.test(num)) return "invalid";
    num = RegExp.$1 + RegExp.$2 + RegExp.$3;
    var cVal = 0;
    for (var i=0; i<8; i++) {
        var cKeyNum = parseInt(((_tmp = i % 3) == 0) ? 1 : ( _tmp  == 1 ) ? 3 : 7);
        cVal += (parseFloat(num.substring(i,i+1)) * cKeyNum) % 10;
    }
    var li_temp = parseFloat(num.substring(i,i+1)) * 5 + "0";
    cVal += parseFloat(li_temp.substring(0,1)) + parseFloat(li_temp.substring(1,2));
    return (parseInt(num.substring(9,10)) == 10-(cVal % 10)%10) ? true : "invalid";
}

FormChecker.prototype.func_isValidPhone = function(el,value) {
    var pattern = /^([0]{1}[0-9]{1,2})-?([1-9]{1}[0-9]{2,3})-?([0-9]{4})$/;
    var num = value ? value : el.value;
    if (pattern.exec(num)) {
        if(RegExp.$1 == "010" || RegExp.$1 == "011" || RegExp.$1 == "016" || RegExp.$1 == "017" || RegExp.$1 == "018" || RegExp.$1 == "019") {
            if(!el.getAttribute("span"))
                el.value = RegExp.$1 + "-" + RegExp.$2 + "-" + RegExp.$3;
        }
        return true;
    } else {
        return "invalid";
    }
}

/**
* common prototype functions
*/
String.prototype.trim = function(str) {
    str = this != window ? this : str;
    return str.ltrim().rtrim();
}

String.prototype.ltrim = function(str) {
    str = this != window ? this : str;
    return str.replace(/^\s+/g,"");
}

String.prototype.rtrim = function(str) {
    str = this != window ? this : str;
    return str.replace(/\s+$/g,"");
}

String.prototype.bytes = function(str) {
    var len = 0;
    str = this != window ? this : str;
    for (j=0; j<str.length; j++) {
        var chr = str.charAt(j);
        len += (chr.charCodeAt() > 128) ? 2 : 1;
    }
    return len;
}

String.prototype.bytesCut = function(bytes) {
    var str = this;
    var len = 0;
    for (j=0; j<str.length; j++) {
        var chr = str.charAt(j);
        len += (chr.charCodeAt() > 128) ? 2 : 1;
        if (len > bytes) {
            str = str.substring(0, j);
            break;
        }
    }
    return str;
}

function autoNext(el, limit, next_el) {
	if(el.value.bytes() == 6) next_el.focus();
}

//출처:어떤놈의 블로그
function postposition(txt, josa)
{
	if(!txt) return "";
    var code = txt.charCodeAt(txt.length-1) - 44032;
    if (txt.length == 0) return '';
    if (code < 0 || code > 11171) return txt;
    if (code % 28 == 0) return txt + postposition.get(josa, false);
    else return txt + postposition.get(josa, true);
}
postposition.get = function (josa, jong) {
    // jong : true면 받침있음, false면 받침없음

    if (josa == '을' || josa == '를') return (jong?'을':'를');
    if (josa == '이' || josa == '가') return (jong?'이':'가');
    if (josa == '은' || josa == '는') return (jong?'은':'는');
    if (josa == '와' || josa == '과') return (jong?'와':'과');
    // 알 수 없는 조사
    return '**';
}

