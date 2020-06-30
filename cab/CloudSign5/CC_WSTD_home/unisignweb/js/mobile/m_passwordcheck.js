var __passwordcheck = function( SANDBOX ) {
    var ConstructScreen = function( Param ) {   
        var __UIElement = {
            __Layout: function() {
                var req;
    
                if ( window.XMLHttpRequest ) {
                    req = new window.XMLHttpRequest;
                } else {
                    req = new ActiveXObject('MSXML2.XMLHTTP.3.0');
                }
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/layout/mobile/m_passwordcheck.html?version=' + SANDBOX.ver, false);
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
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/lang/newpassword_' + SANDBOX.ESVS.Language + '.js?version=' + SANDBOX.ver, false);
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
        
        function CheckPattern() {
            var newPW = Param.args.pw;
            var rule1 = document.getElementById('m-us-password-check-rule1');
            var rule2 = document.getElementById('m-us-password-check-rule2');
            var rule3 = document.getElementById('m-us-password-check-rule3');
            var rule4 = document.getElementById('m-us-password-check-rule4');
            var rule5 = document.getElementById('m-us-password-check-rule5');
            
            var ref = true;
            
            /* RULE 1 */
            if ( SANDBOX.ESVS.LimitMinNewPWLen <= newPW.length ) {
                rule1.className = 'check';
            } else {
                rule1.className = '';
                ref = false;
            }
 
            /* RULE 2 */
            if ( ('NPKI' === SANDBOX.ESVS.PKI && SANDBOX.ESVS.ChangePWByNPKINewPattern) || ('NPKI' != SANDBOX.ESVS.PKI && 2 === SANDBOX.ESVS.LimitNewPWPattern) ) {
                var pattern =  /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9])/g;
                if( pattern.exec(newPW) ) {
                    rule2.className = 'check';
                } else {
                    rule2.className = '';
                    ref = false;
                }                
            } else if ( 1 === SANDBOX.ESVS.LimitNewPWPattern ) {
                var pattern =  /^(?=.*[a-zA-Z])(?=.*[0-9])/g;
                if( pattern.exec(newPW) ) {
                    rule2.className = 'check';
                } else {
                    rule2.className = '';
                    ref = false;
                }    
            }
            
            if ( 'NPKI' === SANDBOX.ESVS.PKI && SANDBOX.ESVS.ChangePWByNPKINewPattern ) {
                /* RULE 5 */
                var pattern = /['"\\|]/g;
                if( !pattern.exec(newPW) ) {
                    rule5.className = 'check';
                } else {
                    rule5.className = '';
                    ref = false;
                }
                
                if ( 2 < newPW.length ) { 
                    /* RULE 3 */
                    for ( var i = 0; i < newPW.length - 2; i++ ) {                       
                        if ( newPW.charAt(i) === newPW.charAt(i + 1) && newPW.charAt(i) === newPW.charAt(i + 2) ) {
                            rule3.className = '';
                            ref = false;
                            break;
                        } else {
                            rule3.className = 'check';
                        }
                    }
                   
                    /* RULE 4 */
                    for ( var i = 0; i < newPW.length - 2; i++ ) {                       
                        if ( newPW.charCodeAt(i) === (newPW.charCodeAt(i + 1) - 1) && newPW.charCodeAt(i) === (newPW.charCodeAt(i + 2) - 2) ) {
                            rule4.className = '';
                            ref = false;
                            break;
                        } else {
                            rule4.className = 'check';
                        }
                    }
                } else {
                    rule3.className = 'check';
                    rule4.className = 'check';
                }
            }
            
            return ref;
        }
        
        function WindowGenerate() {
            var __form = eval(__UIElement.__Layout);
            var __lang = eval((eval(__UIElement.__Lang))());
            
            // should be changed asap
            UILoad( __form() );
            // should be changed asap
            
            var titleLbl = document.getElementById('m-us-password-check-lbl-title');
            titleLbl.appendChild(document.createTextNode(__lang.IDS_PASSWORD_CHECK));
            
            var closeImg = document.getElementById('m-us-password-check-cls-btn-img');
            closeImg.setAttribute('alt', __lang.IDS_PASSWORD_CHECK_CLOSE, 0);
            closeImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_x-btn.png', 0);
            
            var rule1 = document.getElementById('m-us-password-check-rule1');
            rule1.appendChild(document.createTextNode(SANDBOX.ESVS.LimitMinNewPWLen + '' + __lang.IDS_PASSWORD_RULE1));
            
            if ( 'NPKI' === SANDBOX.ESVS.PKI && SANDBOX.ESVS.ChangePWByNPKINewPattern ) {
                var rule2 = document.getElementById('m-us-password-check-rule2');
                rule2.appendChild(document.createTextNode(__lang.IDS_PASSWORD_RULE2_ALL));
            
                var rule3 = document.getElementById('m-us-password-check-rule3');
                rule3.appendChild(document.createTextNode(__lang.IDS_PASSWORD_RULE3));
                
                var rule4 = document.getElementById('m-us-password-check-rule4');
                rule4.appendChild(document.createTextNode(__lang.IDS_PASSWORD_RULE4));
                
                var rule5 = document.getElementById('m-us-password-check-rule5');
                rule5.appendChild(document.createTextNode(__lang.IDS_PASSWORD_RULE5));
            } else {
                var rule2 = document.getElementById('m-us-password-check-rule2');
                if ( 1 === SANDBOX.ESVS.LimitNewPWPattern ) {
                    rule2.appendChild(document.createTextNode(__lang.IDS_PASSWORD_RULE2_ENGNUM));
                } else if ( 'NPKI' != SANDBOX.ESVS.PKI && 2 === SANDBOX.ESVS.LimitNewPWPattern ) {
                    rule2.appendChild(document.createTextNode(__lang.IDS_PASSWORD_RULE2_ALL));
                }
            }
            
            var notiLbl = document.getElementById('m-us-layout-password-check-text');
            notiLbl.setAttribute('tabindex', __TabIndex, 0);
            
            var confirmBtn = document.getElementById('m-us-password-check-confirm-btn');
            confirmBtn.setAttribute('value', __lang.IDS_CONFIRM, 0);
            confirmBtn.setAttribute('title', __lang.IDS_CONFIRM + __lang.IDS_BUTTON, 0);
            confirmBtn.setAttribute('tabindex', __TabIndex + 1, 0);
            
            var passFlag = CheckPattern();
            if ( passFlag ) {
                notiLbl.innerHTML = __lang.IDS_MSGBOX_NOTICE_DO_PASS_RULES;
                confirmBtn.onclick = function(){ Param.onConfirm(); };
            } else {
                notiLbl.innerHTML = __lang.IDS_MSGBOX_NOTICE_DONT_PASS_RULES;
                confirmBtn.onclick = function(){ Param.onCancel(); };
            }
            
            var closeBtn = document.getElementById('m-us-password-check-cls-btn');
            closeBtn.setAttribute('tabindex', __TabIndex + 2, 0);
            closeBtn.onclick = function(){ Param.onTerminate(); };
            
            return document.getElementById('m-us-div-password-check');
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
            onTerminate: Param.onTerminate,
            onCancel: Param.onCancel
        });
        win.style.zIndex = layerLevel + 1;
        SANDBOX.ESVS.TargetObj.insertBefore(overlay, SANDBOX.ESVS.TargetObj.firstChild);  //for test
        
        /* for orientation */
        var perEv = window.onorientationchange;
        /* for orientation */
       
        function fisrtFocus() {
            var ps = win.getElementsByTagName("p");
            
            if ( 0 < ps.length ) {
                for ( var i = 0; i < ps.length; i++ ) {
                    if ( 'm-us-layout-password-check-text' == ps[ i ].id ) {
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
               
                var parent = win.parentNode;
                parent.removeChild(win);
                overlay.parentNode.removeChild(overlay);
                SANDBOX.uiLayerLevel -= 10;
                SANDBOX.ESVS.TabIndex -= 30;
            }
        };
    }
};
