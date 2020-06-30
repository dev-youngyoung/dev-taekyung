$(document).ready(function(){
	HeightAuto();
	gnb();
});

// Height Auto
function HeightAuto(){
	$('.HeightAuto').css('height' ,  $(window).height() );
	$(window).resize(function() {
		$('.HeightAuto').css('height' ,  $(window).height() );
	});
}

function gnb(){
	if($(".gnb").length !== 0) {
		$( ".gnb .item01" ).hover(function() {
			$('.gnb-contents .item01').toggleClass("active");
			$(this).siblings().toggleClass("off");
			$('.gnb-contents .base').toggleClass("active");
		});
		$( ".gnb .item02" ).hover(function() {
			$('.gnb-contents .item02').toggleClass("active");
			$(this).siblings().toggleClass("off");
			$('.gnb-contents .base').toggleClass("active");
		});
		$( ".gnb .item03" ).hover(function() {
			$('.gnb-contents .item03').toggleClass("active");
			$(this).siblings().toggleClass("off");
			$('.gnb-contents .base').toggleClass("active");
		});
		$( ".gnb .item04" ).hover(function() {
			$('.gnb-contents .item04').toggleClass("active");
			$(this).siblings().toggleClass("off");
			$('.gnb-contents .base').toggleClass("active");
		});
	}
}
