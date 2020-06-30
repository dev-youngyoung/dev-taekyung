var __swinfo = function( SANDBOX ) {
    var ConstructScreen = function( Param ) {   
        var __UIElement = {
            __Layout: function() {
                var req;
    
                if ( window.XMLHttpRequest ) {
                    req = new window.XMLHttpRequest;
                } else {
                    req = new ActiveXObject('MSXML2.XMLHTTP.3.0');
                }
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/layout/mobile/m_notice.html?version=' + SANDBOX.ver, false);
                req.send(null);
                
                return req.responseText;
            },
            __Lang: function() {
                var req;
                
                if ( window.XMLHttpRequest ) { 
                    req = new window.XMLHttpRequest; 
                } else { 
                    req = new ActiveXObject('MSXML2.XMLHTTP.3.0'); 
                }
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/lang/swinfo_' + SANDBOX.ESVS.Language + '.js?version=' + SANDBOX.ver, false);
                req.send(null);
                
                return req.responseText;
            }
        };
        
        var __TabIndex = SANDBOX.ESVS.TabIndex;
                
        function UILoad( form ) {
            if ( !form ) {
                alert('UI load error.');
                return false;
            }
            
            var topElement = document.createElement('div');
            document.body.insertBefore( topElement, document.body.firstChild );
            topElement.innerHTML = form;
            return true;
        }
        
        function WindowConfirm() {
            Param.onConfirm();
        }
        
        function WindowExit() {
            Param.onCancel();
        }
        
        function WindowGenerate() {
            var __form = eval(__UIElement.__Layout);
            var __lang = eval((eval(__UIElement.__Lang))());
            
            // should be changed asap
            UILoad( __form() );
            // should be changed asap
            
            var titleLbl = document.getElementById('m-us-notice-lbl-title');
            titleLbl.appendChild(document.createTextNode(__lang.IDS_SW_INFO));
            
            var swInfoText = __lang.IDS_SW_NAME + ' v' + SANDBOX.ver + '<br><br>' + __lang.IDS_COPY_RIGHT;
            
            var mainLbl = document.getElementById('m-us-notice-lbl');
            mainLbl.innerHTML = swInfoText;
            mainLbl.setAttribute('tabindex', __TabIndex, 0);

            var confirmBtn = document.getElementById('m-us-notice-confirm-btn');
            confirmBtn.setAttribute('value', __lang.IDS_CONFIRM, 0);
            confirmBtn.setAttribute('title', __lang.IDS_CONFIRM + __lang.IDS_BUTTON, 0);
            confirmBtn.setAttribute('tabindex', __TabIndex + 1, 0);
            confirmBtn.onclick = function(){ WindowConfirm(); };
            
            var closeBtn = document.getElementById('m-us-notice-cls-img-btn');
            closeBtn.setAttribute('tabindex', __TabIndex + 2, 0);
            closeBtn.onclick = function(){ WindowExit(); };
            
            var closeImg = document.getElementById('m-us-notice-cls-btn-img');
            closeImg.setAttribute('alt', __lang.IDS_SW_INFO_CLOSE, 0);
            closeImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_x-btn.png', 0);
            
            return document.getElementById('m-us-div-notice');
        }
        
        return WindowGenerate();
    };
    
    return function( Param ) {
        var layerLevel = SANDBOX.uiLayerLevel;
        var overlay = SANDBOX.uiUtil().getOverlay(layerLevel/*, SANDBOX.browserName, SANDBOX.browserVersion*/);
        var win = ConstructScreen({
            type: Param.type,
            args: Param.args,
            onConfirm: Param.onConfirm,
            onCancel: Param.onCancel
        });
        win.style.zIndex = layerLevel + 1;
        SANDBOX.ESVS.TargetObj.insertBefore( overlay, SANDBOX.ESVS.TargetObj.firstChild );  //for test
        
        /* for orientation */
        var perEv = window.onorientationchange;
        /* for orientation */
       
        function fisrtFocus() {
            var ps = win.getElementsByTagName("p");
            
            if ( 0 < ps.length ) {
                for ( var i = 0; i < ps.length; i++ ) {
                    if ( 'm-us-notice-lbl' == ps[ i ].id ) {
                        ps[ i ].focus();
                    }
                }
            }
        }
        
        return {
            show: function() {
                overlay.style.display = 'block';
                
                var winHeight = SANDBOX.uiUtil().getNumSize(SANDBOX.uiUtil().getStyle(win, 'height', 'height'));
                var top;                
                if ( -1 === winHeight ) {
                    top = SANDBOX.uiUtil().getScrollTop() + (SANDBOX.uiUtil().getViewportHeight() / 6);
                } else {
                    top = SANDBOX.uiUtil().getScrollTop() + ((SANDBOX.uiUtil().getViewportHeight() - winHeight) / 3);
                }
                
                if ( 0 > top ) {
                    win.style.top = 0  + 'px';
                } else {
                    win.style.top = top  + 'px';
                }
                
                win.style.left = SANDBOX.uiUtil().getScrollLeft() + ((SANDBOX.uiUtil().getViewportWidth() - SANDBOX.uiUtil().getNumSize(SANDBOX.uiUtil().getStyle(win, 'width', 'width'))) / 2) + 'px';
                win.style.display = 'block';
                
                var verwidth = 0, verheight = 0, horwidth = 0, horheight = 0;
                if ( 0 == window.orientation || 180 == window.orientation ) {
                    verwidth = SANDBOX.uiUtil().getViewportWidth();
                    verheight = SANDBOX.uiUtil().getViewportHeight();
                } else {
                    horwidth = SANDBOX.uiUtil().getViewportWidth();
                    horheight = SANDBOX.uiUtil().getViewportHeight();
                }
         
                /* for orientation */
                window.addEventListener('orientationchange', function() {  
                    var viewWidth = 0, viewHeight = 0;
                    // chrome browser has bugs on event to rotation
                    if ( 'android chrome' == SANDBOX.browserName || 'unknown'  == SANDBOX.browserName ) {
                        if ( 0 == window.orientation || 180 == window.orientation ) {
                            if ( 0 < verwidth ) {
                                viewWidth = verwidth;
                                viewHeight = verheight;    
                            } else {
                                viewWidth = horheight + 87;
                                viewHeight = horwidth - 40;
                            }
                        } else {
                            if ( 0 < horwidth ) {
                                viewWidth = horwidth;
                                viewHeight = horheight;    
                            } else {
                                viewWidth = verheight + 87;
                                viewHeight = verwidth - 40;
                            }
                        }
                    } else {
                        viewWidth = SANDBOX.uiUtil().getViewportWidth();
                        viewHeight = SANDBOX.uiUtil().getViewportHeight();
                    }
                    
                    var winWidth = SANDBOX.uiUtil().getNumSize(SANDBOX.uiUtil().getStyle(win, 'width', 'width'));
                    if ( -1 < winWidth ) {
                        var left = SANDBOX.uiUtil().getScrollLeft() + ((viewWidth - winWidth) / 2) + 'px';
                        win.style.left = left;
                    }
                   
                    var winHeight = SANDBOX.uiUtil().getNumSize(SANDBOX.uiUtil().getStyle(win, 'height', 'height'));
                    var top;                
                    if ( -1 === winHeight ) {
                        top = SANDBOX.uiUtil().getScrollTop() + (viewHeight / 6);
                    } else {
                        top = SANDBOX.uiUtil().getScrollTop() + ((viewHeight - winHeight) / 3);
                    }
                    win.style.top = top  + 'px';
                    
                    if ( perEv ) {
                        perEv();
                    }
                });
                /* for orientation */
                
                SANDBOX.uiLayerLevel += 10;
                SANDBOX.ESVS.TabIndex += 30;
                setTimeout( function(){ fisrtFocus(); }, 10 );
            },
            
            hide: function() {
                overlay.style.display = 'none';
                win.style.display = 'none';
            },
            
            dispose: function() {
                /* for orientation */
                window.addEventListener('orientationchange', function() {
                    if ( perEv ) {
                        perEv();
                    }
                });
                /* for orientation */
               
                var body = win.parentNode.parentNode;
                body.removeChild(win.parentNode);  //parent.removeChild(win);
                overlay.parentNode.removeChild(overlay);
                SANDBOX.uiLayerLevel -= 10;
                SANDBOX.ESVS.TabIndex -= 30;
            }
        };
    }
};
