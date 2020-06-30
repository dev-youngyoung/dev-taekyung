/**
* ���ϸ�: lib.validate.js
* ��  ��: �� üũ, �� ǥ��ȭ
* �ۼ���: jstoy project
* ��  ¥: 2003-10-28
*   lainTT (2003-11-20) : FormChecker Class�� �Լ� prototypeȭ & ���������� Ŭ���� ������...-_-;
***********************************************
*/

/**
* <pre>
* �� üũ trigger �Լ�
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
            // pre_validate�� ������� �ʴ´ٸ� �� �Ʒ����� �ּ�ó���մϴ�.
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
    * �̸� ���ǵ� ���� �޽�����
    * </pre>
    */
    /*
    this.FORM_ERROR_MSG = {
       //common   : "�Է��Ͻ� ������ ��Ģ�� ��߳��ϴ�.\n��Ģ�� ��߳��� ������ �ٷ�����ּ���.",
	   common	: "",
       required : "�ݵ�� �Է��ϼž� �մϴ�.",
       notequal : "���� ��ġ���� �ʽ��ϴ�.",
       invalid  : "�Է� ���Ŀ� ��߳��ϴ�.",
	   denied   : "���ε尡 ���ѵ� �����Դϴ�.",
       minbyte  : "���̰� {minbyte}Byte �̻��̾�� �մϴ�.",
       maxbyte  : "���̰� {maxbyte}Byte�� �ʰ��� �� �����ϴ�."
    }
    */
    this.FORM_ERROR_MSG = {
       //common   : "�Է��Ͻ� ������ ��Ģ�� ��߳��ϴ�.\n��Ģ�� ��߳��� ������ �ٷ�����ּ���.",
	   common	: "",
       required : "�Է��ϼ���.",
       notequal : "���� ��ġ���� �ʽ��ϴ�.",
       invalid  : "�߸� �Է��Ͽ����ϴ�.",
	   denied   : "���ε尡 ���ѵ� �����Դϴ�.",
       minbyte  : "{minbyte}�� �̻� �Է��ϼ���.",
       maxbyte  : "{maxbyte}�� �̳��� �Է��ϼ���.",
       fixbyte  : "{fixbyte}�� �� �Է��ϼ���."
    }
    this.FORM_ERROR_MSG_POSTPOSITION = {
       //common   : "�Է��Ͻ� ������ ��Ģ�� ��߳��ϴ�.\n��Ģ�� ��߳��� ������ �ٷ�����ּ���.",
	   common	: "",
       required : "��",
       notequal : "��",
       invalid  : "��",
	   denied   : "��",
       minbyte  : "��",
       maxbyte  : "��",
       fixbyte  : "��"
    }

    /**
    * <pre>
    * �� üũ �Լ� ����
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
    * ���� ��� �÷���
    * </pre>
    */
    this.ERROR_MODE_FLAG = {
       all         : 1,         // ��ü ������ ǥ��
       one         : 2,         // ó���� �ɸ� ���� �ϳ��� ǥ��
       one_per_obj : 3          // �� object�� ó���� ���� ǥ��
    }

    this.form      = form;
    this.isErr     = false;
    this.errMsg    = (this.FORM_ERROR_MSG["common"] != "") ? this.FORM_ERROR_MSG["common"] + "\n\n" : "";
    this.errObj    = "";
    this.curObj    = "";
    this.errMode   = this.ERROR_MODE_FLAG["one"];  // �����޽��� ��¸��
	this.recvCheck = (bCheckRecvWrite == true) ? true : false;
}

FormChecker.prototype.go = function() {
    for (var i = 0; i < this.form.elements.length; i++) {
        var el = this.form.elements[i];
        if (el.tagName.toLowerCase() == "fieldset" || el.tagName.toLowerCase() == "object")
            continue;
        
        /*IE 10 ���� domhtml �� required�� ���� ������ Y�� set���ش�.*/
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

		if( (el.getAttribute("WRITABLE") != null && this.recvCheck == true) // ���޻���� �ۼ� �ʵ��̰� ���޻���ڰ� üũ�ϴ� ���
			 || (el.getAttribute("WRITABLE") == null && this.recvCheck == false) )	// ������ڰ� üũ
		{
			if (el.getAttribute("REQUIRED") != null || el.getAttribute("CHK_REQUIRED") != null) {
				var bChkRequired = true;
				if(el.getAttribute("CHK_REQUIRED") != null) // üũ�ڽ� ���ÿ� ���� �ʼ� üũ�ϴ� ���. ���� üũ �ȵǾ� ������ üũ���� �ʴ´�.
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
					this.addError(el, "����:[FUNC]�Ӽ� ���� �ݵ�� �����(true/false)�� �����ؾ� �մϴ�.");
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
        if (this.errObj.getAttribute("errfunc") != null)	// ���� �����ù迡�� ���. �ʼ��Է� ���� ���� ��� ���̵��ϴ� �Լ� ȣ��.
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
    var pp = this.FORM_ERROR_MSG_POSTPOSITION[type] ? this.FORM_ERROR_MSG_POSTPOSITION[type] : "��";

	if(type == "required") {
		if(el.type == "checkbox" || el.type == "radio" || el.type == "file" || el.type == "select-one") {
			msg = "������ �ּ���.";
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
				//	this.errMsg += "["+ el.getAttribute("hname") +"] �׸��� "+ msg +"\n";
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

/// ���� �˻� �Լ��� ///
FormChecker.prototype.func_isValidEmail = function(el,value) {
   var value = value ? value : el.value;
   var pattern = /^[_a-zA-Z0-9-\.]+@[\.a-zA-Z0-9-]+\.[a-zA-Z]+$/;
   return (pattern.test(value)) ? true : "invalid";
}

FormChecker.prototype.func_isValidUserid = function(el) {
   var pattern = /^[a-zA-Z]{1}[a-zA-Z0-9_]{5,19}$/;
   return (pattern.test(el.value)) ? true : "6���̻� 20�� ����,\n����, ���� ���� ���ո� ����� �� �ֽ��ϴ�.(ù���� ����)";
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
				return "$���ڴ� ����� �� �����ϴ�.";
			
			if(pw.charAt(i)=='\\')
				return "\\���ڴ� ����� �� �����ϴ�.";

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
			return "���� 1��, ���� 1��, Ư������ 1�� �̻����� ���� ���ּ���";
		}

	}else{
		return "8�� �̻� 20�� �̸����� ���� ���ּ���";
	}
	return true;
}


FormChecker.prototype.func_hasHangul = function(el) {
   var pattern = /[��-��]/;
  // return (pattern.test(el.value)) ? true : "�ݵ�� �ѱ��� �����ؾ� �մϴ�";
   return (pattern.test(el.value)) ? true : "�ѱ��� �����ؾ� �մϴ�";
}

FormChecker.prototype.func_alphaOnly = function(el) {
   var pattern = /^[a-zA-Z]+$/;
   return (pattern.test(el.value)) ? true : "invalid";
}

FormChecker.prototype.func_isNumeric = function(el) {
   var pattern = /^[0-9]+$/;
  // return (pattern.test(el.value)) ? true : "�ݵ�� ���ڷθ� �Է��ؾ� �մϴ�";
   return (pattern.test(el.value)) ? true : "���ڷθ� �Է��ؾ� �մϴ�";
}

FormChecker.prototype.func_isMoney = function(el) {
   var pattern = /^[0-9\,]+$/;
  // return (pattern.test(el.value)) ? true : "�ݵ�� ���ڷθ� �Է��ؾ� �մϴ�";
   return (pattern.test(el.value)) ? true : "���ڷθ� �Է��ؾ� �մϴ�";
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
    return (pattern.test(num))? true:"��¥������ �ùٸ��� �ʽ��ϴ�.";
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

//��ó:����� ��α�
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
    // jong : true�� ��ħ����, false�� ��ħ����

    if (josa == '��' || josa == '��') return (jong?'��':'��');
    if (josa == '��' || josa == '��') return (jong?'��':'��');
    if (josa == '��' || josa == '��') return (jong?'��':'��');
    if (josa == '��' || josa == '��') return (jong?'��':'��');
    // �� �� ���� ����
    return '**';
}

