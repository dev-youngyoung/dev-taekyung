// AS-IS 계약서 function
function fnContAmt_Check(cont_amt, cont_attr1, cont_attr2, cont_attr3, form){
	
	var	form1 = form;
	
	var amt = trimComma(fnCheckNull(cont_amt));
	var attr1 = trimComma(fnCheckNull(cont_attr1));
	var attr2 = trimComma(fnCheckNull(cont_attr2));
	var attr3 = trimComma(fnCheckNull(cont_attr3));
	
	if(amt == "" || amt == null || amt == 0){
		alert("계약금을 먼저 입력 하세요.");
		cont_amt.focus();
		return makeCommaObj(cont_attr1);
	}
	
	var sum = eval(attr1) + eval(attr2) + eval(attr3);
	
	if(amt < sum){
		alert("입력하신 중도금 합계가 계약금을 초과 하였습니다. 다시 입력 하여 주십시요.");
		cont_attr1.value = "";
		cont_attr1.focus();
		return;
	}
	
	return makeCommaObj(cont_attr1); 
}

/**
 *	100,000 식의 쉼표 단위 붙이기
 *
 */
function makeCommaObj(numObj)
{
	if (numObj.value != "") {
		var numvalue = 1 * numObj.value;
		numObj.value = makeComma(numvalue);
	}
}

/**
 *  문자열에서 Comma(,) 삭제
 *
 */
function trimCommaObj(inStringObj) 
{
	inStringObj.value = trimComma(inStringObj.value);
}

/**
 *	100,000 식의 쉼표 단위 붙이기
 *
 */
function makeComma(num)
{
	if (num < 0) { num *= -1; var minus = true}
	else var minus = false
	
	var dotPos = (num+"").split(".")
	var dotU = dotPos[0]
	var dotD = dotPos[1]
	var commaFlag = dotU.length%3

	if(commaFlag) {
		var out = dotU.substring(0, commaFlag) 
		if (dotU.length > 3) out += ","
	}
	else var out = ""

	for (var i=commaFlag; i < dotU.length; i+=3) {
		out += dotU.substring(i, i+3) 
		if( i < dotU.length-3) out += ","
	}

	if(minus) out = "-" + out
	if(dotD) return out + "." + dotD
	else return out 
}

//숫자만 입력 가능
function chkNumKeyPress() {
	if (event.keyCode < 48 || event.keyCode > 57) {
		return false;
	} else {
		return true;
	}
}

function fnCheckNull(number){
	if(number == null || number.value == "" || number.value == " " ||  number.value == null){
		return "0";
	}
	return number.value;
}