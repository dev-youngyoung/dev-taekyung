var __certpassword = function( SANDBOX ) {
    var ConstructScreen = function( Param ) {   
        var __UIElement = {
            __Layout: function() {
                var req;
    
                if ( window.XMLHttpRequest ) {
                    req = new window.XMLHttpRequest;
                } else {
                    req = new ActiveXObject('MSXML2.XMLHTTP.3.0');
                }
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/layout/mobile/m_certpassword.html?version=' + SANDBOX.ver, false);
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
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/lang/password_' + SANDBOX.ESVS.Language + '.js?version=' + SANDBOX.ver, false);
                req.send(null);
                
                return req.responseText;
            }
        };
        
        var __TabIndex = SANDBOX.ESVS.TabIndex;
		var __certType = Param.args.type;
		var __certIdx = Param.args.idx;
		var __userCert = Param.args.cert;
		var __NumOfTimes = 0;  // Number of times to input wrong password
        
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
        
        function PressEnterOnPWBox( e ) {
            if ( !e ) {
                return false;
            }
            
            var evt = e || window.event;
            var keyCode = evt.which || evt.keyCode;
            
            if ( 13 == keyCode ) {
                var confirmBtn = document.getElementById('m-us-password-confirm-btn');
                confirmBtn.click();
            }
        }

		function ViewCert( obj ) {
            if ( !obj ) {
                return false;
            }
            
            var __this = obj;
            
            var UI = SANDBOX.loadUI('certview');
            var Dialog = UI({
                type: null,
                args: {
                    type: 	__certType,
                    idx: 	__certIdx,
                    cert: 	__userCert
                },
                onConfirm: function() {
                    Dialog.dispose(); 
                    __this.focus();
                },
                onCancel: function() {
                    Dialog.dispose(); 
                    __this.focus();
                }
                
            });
            Dialog.show();
            
            return true;
        }
        
        function WindowConfirm( textObj ) {
            if ( !textObj ) {
                return false;
            }
            
            var __text = textObj;
            
            var passwdText = document.getElementById('m-us-input-cert-password-textbox');
            if ( !passwdText.value ) {
                SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_ERROR_PLEASE_INPUT_PASSWORD);
                passwdText.focus();
                return false;
            }
            
            if ( !SANDBOX.certsList || !SANDBOX.PFUC ) {
                SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_ERROR_NO_SELECTED_CERT);
                return false;
            }
            
            function CheckNumOfTimes() {
               __NumOfTimes++;
                    
               if ( __NumOfTimes >= SANDBOX.ESVS.LimitNumOfTimesToTryToInputPW ) {
                   SANDBOX.uiUtil().msgBox( __text.IDS_MSGBOX_ERROR_OVER_NUMBER_OF_ALLOWED_BEFORE + SANDBOX.ESVS.LimitNumOfTimesToTryToInputPW + __text.IDS_MSGBOX_ERROR_OVER_NUMBER_OF_ALLOWED_AFTER );
                   Param.onTerminate();
               } else {
                   passwdText.value = '';
                   passwdText.focus();
               }
            }
            
            var selectedCertIdx = parseInt(__certIdx);
            var pri = null; 
            try {
                pri = SANDBOX.usWebToolkit.pkcs8.encryptedPrivateKeyFromBase64( SANDBOX.PFUC[selectedCertIdx].signpri );
            } catch (e) {
                console.log('***** encryptedPrivateKeyFromBase64 error *****');  // for debug
                console.log('Err Code : ', e.code, '\nErr Msg : ', e.message);  // for debug
            }

            var bRv = false;
            try {
                bRv = SANDBOX.usWebToolkit.pkcs8.checkUserCertPassword(pri, passwdText.value);
            } catch (e) {
                console.log('***** CheckUserCertPassword error *****');  // for debug
                console.log('Err Code : ', e.code, '\nErr Msg : ', e.message);  // for debug
            } finally {
                pri = '';
            }

			if ( false === bRv ) {
				SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_ERROR_PASSWORD_IS_NOT_MATCHED);
                CheckNumOfTimes();
			} else {
            	Param.onConfirm( __certIdx, passwdText.value );
			}
			
            passwdText.value = '';
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
            
            var titleLbl = document.getElementById('m-us-lbl-cert-password-title');
            titleLbl.appendChild(document.createTextNode(__lang.IDS_PASSWORD));

			SANDBOX.usWebToolkit.x509Certificate.parser( __userCert, __certType);     
            var oid = SANDBOX.usWebToolkit.x509Certificate.getCertificatePoliciesOid();
            var subject = SANDBOX.usWebToolkit.x509Certificate.getSubjectName();
            var expDate = SANDBOX.usWebToolkit.x509Certificate.getNotAfter();
			var issuer = SANDBOX.certUtil().getIssuerName(oid);
			
            if ( 'undefined' == issuer ) {
                issuer = SANDBOX.certUtil().getO(subject);
            }
			
			var certIssuer = issuer;
			var certSubjectName = SANDBOX.certUtil().getCN(subject);
			var certType = SANDBOX.certUtil().getCertType(oid);
            var certExpDate = SANDBOX.certUtil().getLocalDate(expDate);
            var certStatus = SANDBOX.certUtil().getExpirationStateValue(expDate);
           
            var certImg = document.getElementById('m-us-img-cert-password');
            if ( 0 === certStatus ) {
                certImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_cert_valid_small.png', 0);  //test code
            } else if ( 1 === certStatus ) {
                certImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_cert_valid_1_month_small.png', 0);  //test code
            } else if ( 2 === certStatus ) {
                certImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_cert_invalid_small.png', 0);  //test code
            } else {
                return;
            }

			var certInf = document.getElementById('m-us-div-cert-password-info');
			var spanNodes = certInf.getElementsByTagName("span");
			spanNodes[0].appendChild(document.createTextNode(certSubjectName));
			spanNodes[1].appendChild(document.createTextNode(__lang.IDS_CERT_ISSUER));
			spanNodes[2].appendChild(document.createTextNode(certIssuer));
			spanNodes[3].appendChild(document.createTextNode(__lang.IDS_CERT_CLASSIFY));
			spanNodes[4].appendChild(document.createTextNode(certType));
			spanNodes[5].appendChild(document.createTextNode(__lang.IDS_CERT_EXPIRATION_DAY));
			spanNodes[6].appendChild(document.createTextNode(certExpDate));
			           
            var notiLbl = document.getElementById('m-us-lbl-cert-password-pw');
            notiLbl.appendChild(document.createTextNode(__lang.IDS_CERT_PASSWORD));

			var notiSubLbl = document.getElementById('m-us-lbl-cert-password-sub-notice');
            notiSubLbl.appendChild(document.createTextNode(__lang.IDS_CERT_PASSWORD_SUB_NOTICE));
			            
            var pwTextBox = document.getElementById('m-us-input-cert-password-textbox');
            pwTextBox.setAttribute('tabindex', __TabIndex, 0);
            pwTextBox.onkeydown = function(e){ PressEnterOnPWBox(e?e:event); };
            
            var certViewBtn = document.getElementById('m-us-cert-password-view-btn');
            certViewBtn.setAttribute('value', __lang.IDS_CERT_VIEW, 0);
            certViewBtn.setAttribute('title', __lang.IDS_CERT_VIEW + __lang.IDS_BUTTON, 0);
            certViewBtn.setAttribute('tabindex', __TabIndex + 1, 0);
            certViewBtn.onclick = function(){ ViewCert( this ) };
            
            var certCancelBtn = document.getElementById('m-us-cert-password-ccl-btn');
            certCancelBtn.setAttribute('value', __lang.IDS_CERT_CANCEL, 0);
            certCancelBtn.setAttribute('title', __lang.IDS_CERT_CANCEL + __lang.IDS_BUTTON, 0);
            certCancelBtn.setAttribute('tabindex', __TabIndex + 2, 0);
            certCancelBtn.onclick = function(){ WindowExit(); };

			var certConfirmBtn = document.getElementById('m-us-cert-password-cfrm-btn');
            certConfirmBtn.setAttribute('value', __lang.IDS_CERT_CONFIRM, 0);
            certConfirmBtn.setAttribute('title', __lang.IDS_CERT_CONFIRM + __lang.IDS_BUTTON, 0);
            certConfirmBtn.setAttribute('tabindex', __TabIndex + 3, 0);
            certConfirmBtn.onclick = function(){ WindowConfirm( __lang ); };

			var closeImg = document.getElementById('m-us-cert-password-cls-btn-img');
            closeImg.setAttribute('alt', __lang.IDS_PASSWORD_CLOSE, 0);
            closeImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_x-btn.png', 0);
			
            var closeBtn = document.getElementById('m-us-cert-password-cls-btn');
            closeBtn.setAttribute('tabindex', __TabIndex + 4, 0);
            closeBtn.onclick = function(){ WindowExit(); };

            return document.getElementById('m-us-div-cert-password');
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
            onCancel: Param.onCancel,
            onTerminate: Param.onTerminate
        });
        win.style.zIndex = layerLevel + 1;
        SANDBOX.ESVS.TargetObj.insertBefore(overlay, SANDBOX.ESVS.TargetObj.firstChild);  //for test
        
        /* for orientation */
        var perEv = window.onorientationchange;
        /* for orientation */
       
        function firstFocus() {
            var inputs = win.getElementsByTagName("input");
            
            if ( 0 < inputs.length ) {
                for ( var i = 0; i < inputs.length; i++ ) {
                    if ( 'm-us-input-cert-password-textbox' == inputs[ i ].id ) {
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
                setTimeout( function(){ firstFocus(); }, 10 );
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
