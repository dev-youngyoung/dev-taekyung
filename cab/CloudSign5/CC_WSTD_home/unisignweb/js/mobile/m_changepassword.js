var __changepassword = function( SANDBOX ) {
    var ConstructScreen = function( Param ) {   
        var __UIElement = {
            __Layout: function() {
                var req;
    
                if ( window.XMLHttpRequest ) {
                    req = new window.XMLHttpRequest;
                } else {
                    req = new ActiveXObject('MSXML2.XMLHTTP.3.0');
                }
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/layout/mobile/m_changepassword.html?version=' + SANDBOX.ver, false);
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
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/lang/changepassword_' + SANDBOX.ESVS.Language + '.js?version=' + SANDBOX.ver, false);
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

        function WindowConfirm( textObj ) {
            var originPWTextBox = document.getElementById('m-us-change-password-origin-textbox');
            var newPWTextBox = document.getElementById('m-us-change-password-new-first-textbox');
            var reInputPWTextBox = document.getElementById('m-us-change-password-new-second-textbox');
            
            if ( !originPWTextBox.value || !newPWTextBox.value ) {
                SANDBOX.uiUtil().msgBox(textObj.IDS_MSGBOX_ERROR_PLEASE_INPUT_PASSWORD);
                originPWTextBox.focus();
                return false;
            }
            
            if ( SANDBOX.ESVS.LimitMaxNewPWLen < newPWTextBox.value.length ) {
                SANDBOX.uiUtil().msgBox(SANDBOX.ESVS.LimitMaxNewPWLen + textObj.IDS_MSGBOX_ERROR_LONGER_THAN_LIMIT_MAX_LENGTH);
                newPWTextBox.focus();
                return false;
            }
            
            if ( newPWTextBox.value != reInputPWTextBox.value ) {
                SANDBOX.uiUtil().msgBox(textObj.IDS_MSGBOX_ERROR_PLEASE_RETRY_TO_INPUT_CORRECTLY);
                newPWTextBox.focus();
                return false;
            }
            
            var UI = SANDBOX.loadUI('passwordcheck');
            var Dialog = UI({
                type: null,
                args: {
                    pw: newPWTextBox.value
                },
                onConfirm: function() {
                    Dialog.dispose(); 
                    
            Param.onConfirm( originPWTextBox.value, newPWTextBox.value );
            newPWTextBox.value = '';
            reInputPWTextBox.value = '';
                },
                onTerminate: function() {
                    Dialog.dispose();
                    
                    Param.onCancel();
                    newPWTextBox.value = '';
                    reInputPWTextBox.value = '';
                },
                onCancel: function() {
                    Dialog.dispose();
                }
            });
            Dialog.show();
            
            return true;
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
            
            var titleLbl = document.getElementById('m-us-change-password-lbl-title');
            titleLbl.appendChild(document.createTextNode(__lang.IDS_CHANGE_PASSWORD));
            
            var closeImg = document.getElementById('m-us-change-password-cls-btn-img');
            closeImg.setAttribute('alt', __lang.IDS_CHANGE_PASSWORD_CLOSE, 0);
            closeImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_x-btn.png', 0);
            
            var lockImg = document.getElementById('m-us-change-password-lock-img');
            lockImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_password-lock-img.png', 0);
            
            var notiLbl = document.getElementById('m-us-change-password-notice-text');
            //notiLbl.appendChild(document.createTextNode(__lang.IDS_NEW_PASSWORD_NOTICE));
            notiLbl.innerHTML = __lang.IDS_CHANGE_PASSWORD_NOTICE + '<br>' + '(' + SANDBOX.ESVS.LimitMinNewPWLen + __lang.IDS_CHANGE_PASSWORD_LIMIT + ')';
            
            var originPWLbl = document.getElementById('m-us-change-password-origin-lbl');
            originPWLbl.appendChild(document.createTextNode(__lang.IDS_CHANGE_PASSWORD_ORIGIN));
            
            var originPWTextBox = document.getElementById('m-us-change-password-origin-textbox');
            originPWTextBox.setAttribute('tabindex', __TabIndex, 0);
            
            var changePWLbl = document.getElementById('m-us-change-password-new-first-lbl');
            changePWLbl.appendChild(document.createTextNode(__lang.IDS_CHANGE_PASSWORD_NEW_FIRST));
            
            var changeTextBox = document.getElementById('m-us-change-password-new-first-textbox');
            changeTextBox.setAttribute('tabindex', __TabIndex + 1, 0);
            
            var reInputPWLbl = document.getElementById('m-us-change-password-new-second-lbl');
            reInputPWLbl.appendChild(document.createTextNode(__lang.IDS_CHANGE_PASSWORD_NEW_SECOND));
            
            var reInputPWTextBox = document.getElementById('m-us-change-password-new-second-textbox');
            reInputPWTextBox.setAttribute('tabindex', __TabIndex + 2, 0);
            
            var warningLbl = document.getElementById('m-us-change-password-warning-text');
            warningLbl.appendChild(document.createTextNode(__lang.IDS_CHANGE_PASSWORD_WARNING));
            
            var confirmBtn = document.getElementById('m-us-change-password-confirm-btn');
            confirmBtn.setAttribute('value', __lang.IDS_CONFIRM, 0);
            confirmBtn.setAttribute('title', __lang.IDS_CONFIRM + __lang.IDS_BUTTON, 0);
            confirmBtn.setAttribute('tabindex', __TabIndex + 3, 0);
            confirmBtn.onclick = function(){ WindowConfirm(__lang); };
            
            var cancelBtn = document.getElementById('m-us-change-password-cancel-btn');
            cancelBtn.setAttribute('value', __lang.IDS_CANCEL, 0);
            cancelBtn.setAttribute('title', __lang.IDS_CANCEL + __lang.IDS_BUTTON, 0);
            cancelBtn.setAttribute('tabindex', __TabIndex + 4, 0);
            cancelBtn.onclick = function(){ WindowExit(); };
            
            var closeBtn = document.getElementById('m-us-change-password-cls-img-btn');
            closeBtn.setAttribute('tabindex', __TabIndex + 5, 0);
            closeBtn.onclick = function(){ WindowExit(); };
            
            return document.getElementById('m-us-div-change-password');
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
                    if ( 'm-us-change-password-origin-textbox' == inputs[ i ].id ) {
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
               
                var body = win.parentNode.parentNode;
                body.removeChild(win.parentNode);  //parent.removeChild(win);
                overlay.parentNode.removeChild(overlay);
                SANDBOX.uiLayerLevel -= 10;
                SANDBOX.ESVS.TabIndex -= 30;
            }
        };
    }
};
