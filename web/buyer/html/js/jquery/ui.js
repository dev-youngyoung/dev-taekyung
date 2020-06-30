$(document).ready(function() {
    ui._init();
});


var ui = (function() {
    _init = function() {
        
        if($('.page-gnb').length>0){
        	this.gnb._init('.page-gnb > li','.page-gnb-depth2');
        }else{
        	this.gnb._init('.page-gnb2 > li','.page-gnb-depth2');
        }
        /*
        $('.text-cut').each(function(index, el) {
            $(this).css('width', $(this).parent('td').width());
        });
        */
        //this.gnb._init('.depth3','.depth4');
        //this.toolTip._init();
       // this.modal._init();
        //this.subNavFix._init();
    }
    return {
        _init : _init
    }
})();


ui.gnb = (function() {
    var _init = function(upDepth,downDepth) {
        var depth1 = $(upDepth);
        var depth2 = $(downDepth);
        depth1.each(function(index, val) {
             $(this).hover(function() {
                 if (!depth1.hasClass('is-active')) {
                	 var menu_cnt = $(this).find('div > ul > li > a').length;
                	 if(menu_cnt > 0){
                		$(this).addClass('is-active');
                    	depth2.stop().slideUp(300,'easeOutSine').eq(index).stop().slideDown(300,'easeInOutQuad');
                	 }else{
                		 $(this).find("a").attr("href","javascript:alert('로그인 후 이용하세요.');");
                	 }
                 }
             }, function() {
                 depth2.stop().slideUp(300,'easeOutSine');
                 $(this).removeClass('is-active')
             });
        });
    }
    return {
        _init: _init
    }

})();

ui.subNavFix = (function(){
    var nav = $('.page-sub-nav');
    var topDist = 304;//$('.page-header').outerHeight() + $('.page-visual').outerHeight();

    var _init = function() {
        $(window).scroll(function () {
            var scroll = $(this).scrollTop();
            if (scroll > topDist) {
                $(nav).addClass('fixed');
            } else {
                $(nav).removeClass('fixed');
            }
        });
    }
    return {
        _init: _init
    }
})();

ui.toolTip = (function(){
    var target = $('.text-cut');
    var _init = function() {
        target.each(function(index, el) {
            $(this).attr('title', '').tooltip({
                content: $(this).text()
            })
        });
    }
    return {
        _init: _init
    }
})();

ui.modal = (function(element){
    var element = $(element);
    var _init = function(element) {
        $('.common-layer-close').on('click', function(event) {
            event.preventDefault();
            close();
        });
    }
    var open = function(element) {
        element.remodal().open();
    }
    var close = function(element) {
        element.remodal().close();
    }
    return {
        _init: _init,
        open: open,
        close: close
    }
})();
