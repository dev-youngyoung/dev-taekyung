var __certprocessing = function( SANDBOX ) {
    var ResultText = null;
    var ConstructScreen = function( Param ) {
        var __UIElement = {
            __Layout: function() {
                var req;
    
                if ( window.XMLHttpRequest ) {
                    req = new window.XMLHttpRequest;
                } else {
                    req = new ActiveXObject('MSXML2.XMLHTTP.3.0');
                }
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/layout/mobile/m_certprocessing.html?version=' + SANDBOX.ver, false);
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
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/lang/certprocessing_' + SANDBOX.ESVS.Language + '.js?version=' + SANDBOX.ver, false);
                req.send(null);
                
                return req.responseText;
            }
        };
        
        function WindowGenerate() {
            var __form = eval(__UIElement.__Layout);
            var __lang = eval((eval(__UIElement.__Lang))());
            ResultText = __lang; 
            
            var UITarget = SANDBOX.ESVS.TargetObj;  // for test
            UITarget.innerHTML = __form();
            
            var processingText = document.getElementById('m-us-cert-processing-text');
            if ( 'CERT_ISSUE' == Param.type ) {
                processingText.appendChild(document.createTextNode(__lang.IDS_CERT_ISSUING));
            } else if ( 'CERT_RENEWAL' == Param.type ) {
                processingText.appendChild(document.createTextNode(__lang.IDS_CERT_RENEWING));
            } else if ( 'CERT_REVOCATION' == Param.type ) {
                processingText.appendChild(document.createTextNode(__lang.IDS_CERT_REVOKING));
            } else if ( 'CERT_SOE' == Param.type ) {
                processingText.appendChild(document.createTextNode(__lang.IDS_CERT_SOEING));
            }
            
            return document.getElementById('m-us-div-cert-processing');
        }
        
        return WindowGenerate();
    };
    
    return function( Param ) {
        var layerLevel = SANDBOX.uiLayerLevel;
        var overlay = SANDBOX.uiUtil().getOverlay(layerLevel/*, SANDBOX.browserName, SANDBOX.browserVersion*/);
        overlay.style.cursor = 'wait';
        
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
            },
            
            hide: function() {
                overlay.style.display = 'none';
                win.style.display = 'none';
            },
            
            dispose: function( rv, errcode, errmsg, callback ) {
                var msg = null;
                
                if ( 'CERT_ISSUE' == Param.type ) {
                    if ( 0 != rv ) {
                        switch ( errcode ) {
                            default:
                                msg = ResultText.IDS_MSGBOX_CERT_ISSUE_ERROR + '<br><br>' + errmsg + '<br><br>Error Code [ ' + errcode + ' ]';
                                break;
                        }
                    } else {
                        msg = ResultText.IDS_MSGBOX_CERT_ISSUED;
                    }
                } else if ( 'CERT_RENEWAL' == Param.type ) {
                    if ( 0 != rv ) {
                        switch ( errcode ) {
                            default:
                                msg = ResultText.IDS_MSGBOX_CERT_RENEW_DENIED_ERROR + '<br><br>' + errmsg + '<br><br>Error Code [ ' + errcode + ' ]';
                                break;  
                        }
                    } else {
                        msg = ResultText.IDS_MSGBOX_CERT_RENEWED;
                    }
                } else if ( 'CERT_REVOCATION' == Param.type ) {
                    if ( 0 != rv ) {
                        switch ( errcode ) {
                            default:
                                msg = ResultText.IDS_MSGBOX_CERT_REVOKE_DENIED_ERROR + '<br><br>' + errmsg + '<br><br>Error Code [ ' + errcode + ' ]';
                                break;  
                        }
                    } else {
                        msg = ResultText.IDS_MSGBOX_CERT_REVOKED;
                    }
                } else if ( 'CERT_SOE' == Param.type ) {
                    if ( 0 != rv ) {
                        switch ( errcode ) {
                            default:
                                msg = ResultText.IDS_MSGBOX_CERT_SOE_DENIED_ERROR + '<br><br>' + errmsg + '<br><br>Error Code [ ' + errcode + ' ]';
                                break;  
                        }
                    } else {
                        msg = ResultText.IDS_MSGBOX_CERT_SOEED;
                    }
                }
                
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
                
                if ( msg ) {
                    var UI = SANDBOX.loadUI('notice');
                    var Dialog = UI({
                        type: null,
                        args: {
                            msg: msg
                        },
                        onConfirm: function() {
                            Dialog.dispose();
                            callback();
                        },
                        onCancel: function() {
                            Dialog.dispose();
                            callback();
                        }
                    });
                    Dialog.show();
                }
            }
        };
    }
};
