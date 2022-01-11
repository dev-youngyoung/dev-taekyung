$(document).ready(function(){
	AOS.init();
	topBtn();
	topFixed();
	gnbToggle();
	familyToggle();
	sideHover();
	breadcrumbToggle();
	AutoHeigh();
	parallax();
	gnbfixed();
});

// Top btn Action
function topBtn(){
	var scrollTop = $(".top-btn");
	$(scrollTop).click(function() {
		$('html, body').animate({
			scrollTop: 0
		}, 800);
		return false;
	});
}

// header scroll
function topFixed(){
	var showStaticMenuBar = false;

	$(window).scroll(function () {
		if (showStaticMenuBar == false) {
			if ($(window).scrollTop() >= 36) {
				$('.top-btn').fadeIn(300);
				showStaticMenuBar = true;
			}
		}
		else {
			if ($(window).scrollTop() < 36) {
				$('.top-btn').fadeOut(300);
				showStaticMenuBar = false;
			}
		}
	});
}

function hideExclude(excludeClass) {
	$(".dashboard__search__type").children().each(function() {
		$(this).hide();
	});
	$("." + excludeClass).show();
}


function gnbfixed(){
	var showStaticMenuBar = false;

	$(window).scroll(function () {
		if (showStaticMenuBar == false) {
			if ($(window).scrollTop() >= 1) {
				$('header').addClass('header--fixed');
				showStaticMenuBar = true;
			}
		}
		else {
			if ($(window).scrollTop() < 1) {
				$('header').removeClass('header--fixed');
				showStaticMenuBar = false;
			}
		}
	});
}

function ajaxLink(href,type,idx){
	$.ajax({
		type: type,
		url: href,
		data : idx,
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		beforeSend : function(jqXHR){
			jqXHR.overrideMimeType("application/x-www-form-urlencoded; charset=UTF-8");
		},
		success : function(data) {
			$('body').find('.layerpop').remove().end().append(data);
			$('body').addClass('fixed');
		}
	});
}

function ajaxClose(a){
	$(a).fadeOut(500,function(){$(this).remove()});
	$('body').removeClass('fixed');
}

//es6
//select value show hide
function showDiv(target, element){
	document.getElementsByClassName(target)[0].style.display = element.value === target ? 'block' : 'none';
}

// toggle display
function toggleDisplay(element){
	let target = document.querySelector(element).style;
	(function(style) {
		style.display = style.display === 'block' ? '' : 'block';
	})(target);
}

// GNB action
function gnbToggle(){
	let btn = $('.gnb-depth1 > li');
	let target = $('.gnb-depth2');
	let innerBtn = $('.depth2-close');

	btn.click(function() {
		target.toggle();
	});
	innerBtn.click(function() {
		target.hide();
	});
}

// family action
function familyToggle(){
	let btn = $('.footer-family button');
	let target = $('.footer-family');

	btn.click(function() {
		target.toggleClass('active');
	});
}

// main side
function sideHover(){
	let target = $('.main-side');

	target.hover(
		function() {
			$(this).addClass( "active" );
		}, function() {
			$(this).removeClass( "active" );
		}
	);
}

// breadcrumb action
function breadcrumbToggle(){
	let showStaticMenuBar = false;
	let btn = $('.breadcrumb-list li p');
	let target = $('.menu');

	// btn.click(function() {
	// 	$(this).next().toggle();
	// });
	btn.mouseover(function(){
		$(this).next().addClass('active');
	}).mouseout(function(){
		$(this).next().removeClass('active');
	});
	target.mouseover(function(){
		$(this).addClass('active');
	}).mouseout(function(){
		$(this).removeClass('active');
	});


	$(window).scroll(function () {
		if (showStaticMenuBar == false) {
			if ($(window).scrollTop() >= 367) {
				$('.breadcrumb-block').addClass('breadcrumb-block--fixed');
				showStaticMenuBar = true;
			}
		}
		else {
			if ($(window).scrollTop() < 367) {
				$('.breadcrumb-block').removeClass('breadcrumb-block--fixed');
				showStaticMenuBar = false;
			}
		}
	});
}

function AutoHeigh(){
	if($(".auto-height").length !== 0) {
		let autoHeight = $('.auto-height').height();
		let target = $('.auto-height-target');

		target.css('height' ,  autoHeight );
		$(window).resize(function() {
			target.css('height' ,  autoHeight );
		});
	}
}

function parallax(){
	$(window).scroll(function () {
		var scrolled = $(window).scrollTop();
		$('.parallax-bg').css('top',(scrolled*0.7)+'px');
	});
}

function mobileChkGo(url){
	if(isMobile()){
		alert("모바일 브라우져에서는 해상도에 따라 서비스 이용이 어려우 실 수 있습니다.\n\nPC상에서 이용을 권장합니다.");
	}
	location.href=url;
}

function isMobile() {
	var filter = "win16|win32|win64|mac";
	if(navigator.platform){
		if(filter.indexOf(navigator.platform.toLowerCase()) > -1 ){
			return false;
		}else{
			return true;
		}
	}
}


//개인정보 보호정책
function fPopupPrivacy(){
	window.open("/web/buyer/html/main/privacy_pop.html", "privacy", "left=0,top=0,width=700,height=700,scrollbars=yes");
	return;
}
