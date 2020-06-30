var __certissue = function( SANDBOX ) {
    var ConstructScreen = function( Param ) {
        var __UIElement = {
            __Layout: function() {
                var req;
    
                if ( window.XMLHttpRequest ) {
                    req = new window.XMLHttpRequest;
                } else {
                    req = new ActiveXObject('MSXML2.XMLHTTP.3.0');
                }
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/layout/mobile/m_certissue.html?version=' + SANDBOX.ver, false);
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
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/lang/certissue_' + SANDBOX.ESVS.Language + '.js?version=' + SANDBOX.ver, false);
                req.send(null);
                
                return req.responseText;
            }
        };
        
        var __TabIndex = SANDBOX.ESVS.TabIndex;
        
        function WindowConfirm( textObj ) {
            if ( !textObj ) {
                return false;
            }
            
            var __text = textObj;
            
            var refnumTextbox = document.getElementById('m-us-cert-issue-ref-number-textbox');
            var authcodeTextbox = document.getElementById('m-us-cert-issue-auth-code-textbox');
            
            if ( !refnumTextbox.value ) {
                SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_ERROR_PLEASE_INPUT_REF_NUM);
                refnumTextbox.focus();
                return false;
            }
            
            if ( !authcodeTextbox.value ) {
                SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_ERROR_PLEASE_INPUT_AUTH_CODE);
                authcodeTextbox.focus();
                return false;
            }
            
            Param.onConfirm( refnumTextbox.value, authcodeTextbox.value );
            return true;
        }
        
        function WindowExit() {
            Param.onCancel();
        }
        
        function WindowGenerate() {
            var __form = eval(__UIElement.__Layout);
            var __lang = eval((eval(__UIElement.__Lang))());
            
            var UITarget = SANDBOX.ESVS.TargetObj;  // for test
            UITarget.innerHTML = __form();
            
            var titleLbl = document.getElementById('m-us-cert-issue-lbl-title');
            titleLbl.appendChild(document.createTextNode(__lang.IDS_CERT_ISSUE));
            
            var closeImg = document.getElementById('m-us-cert-issue-cls-btn-img');
            closeImg.setAttribute('alt', __lang.IDS_CERT_ISSUE_CLOSE, 0);
            closeImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_x-btn.png', 0);
            
            var notiLbl = document.getElementById('m-us-cert-issue-notice-lbl');
            notiLbl.appendChild(document.createTextNode(__lang.IDS_CERT_ISSUE_NOTICE));
            
            var refnumLbl = document.getElementById('m-us-cert-issue-ref-number-lbl');
            refnumLbl.appendChild(document.createTextNode(__lang.IDS_CERT_ISSUE_REF_NUM));
            
            var refnumTextbox = document.getElementById('m-us-cert-issue-ref-number-textbox');
            refnumTextbox.setAttribute('tabindex', __TabIndex, 0);
            
            var authcodeLbl = document.getElementById('m-us-cert-issue-auth-code-lbl');
            authcodeLbl.appendChild(document.createTextNode(__lang.IDS_CERT_ISSUE_AUTH_CODE));
            
            var authcodeTextbox = document.getElementById('m-us-cert-issue-auth-code-textbox');
            authcodeTextbox.setAttribute('tabindex', __TabIndex + 1, 0);
            
            var confirmBtn = document.getElementById('m-us-cert-issue-confirm-btn');
            confirmBtn.setAttribute('value', __lang.IDS_CONFIRM, 0);
            confirmBtn.setAttribute('title', __lang.IDS_CONFIRM + __lang.IDS_BUTTON, 0);
            confirmBtn.setAttribute('tabindex', __TabIndex + 2, 0);
            confirmBtn.onclick = function(){ WindowConfirm(__lang); };
            
            var closeBtn = document.getElementById('m-us-cert-issue-cls-img-btn');
            closeBtn.setAttribute('tabindex', __TabIndex + 3, 0);
            closeBtn.onclick = function(){ WindowExit(); };

            return document.getElementById('m-us-div-cert-issue');
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
        SANDBOX.ESVS.TargetObj.insertBefore(overlay, SANDBOX.ESVS.TargetObj.firstChild);  //for test
        
        /* for orientation */
        var perEv = window.onorientationchange;
        /* for orientation */
       
        function fisrtFocus() {
            var inputs = win.getElementsByTagName("input");
            
            if ( 0 < inputs.length ) {
                for ( var i = 0; i < inputs.length; i++ ) {
                    if ( 'm-us-cert-issue-ref-number-textbox' == inputs[ i ].id ) {
                        inputs[ i ].focus();
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
               
                var parent = win.parentNode;
                parent.removeChild(win);
                overlay.parentNode.removeChild(overlay);
                SANDBOX.uiLayerLevel -= 10;
                SANDBOX.ESVS.TabIndex -= 30;
            }
        };
    }
};
