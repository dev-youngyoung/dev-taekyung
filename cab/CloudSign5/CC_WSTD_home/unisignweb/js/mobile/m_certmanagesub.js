var __certmanagesub = function( SANDBOX ) {
    var ConstructScreen = function( Param ) {   
        var __UIElement = {
            __Layout: function() {
                var req;
    
                if ( window.XMLHttpRequest ) {
                    req = new window.XMLHttpRequest;
                } else {
                    req = new ActiveXObject('MSXML2.XMLHTTP.3.0');
                }
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/layout/mobile/m_certmanagesub.html?version=' + SANDBOX.ver, false);
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
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/lang/certmanage_' + SANDBOX.ESVS.Language + '.js?version=' + SANDBOX.ver, false);
                req.send(null);
                
                return req.responseText;
            }
        };
                
        var __TabIndex = SANDBOX.ESVS.TabIndex;
        var __certType = Param.args.type;
        var __certIdx = Param.args.idx;
        var __CurrentDevice = Param.args.device;
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
        
        function ViewCert( obj ) {
            if ( !obj ) {
                return false;
            }
            
            var __this = obj;
            
            var UI = SANDBOX.loadUI('certview');
            var Dialog = UI({
                type: null,
                args: {
                    type:   __certType,
                    idx:    __certIdx,
                    cert:   __userCert
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
        
        function ChangePW( obj, textObj ) {
            if ( !obj || !textObj ) {
                return false;
            }
            
            var __this = obj;
            var __text = textObj;
            
            var UI = SANDBOX.loadUI('changepassword');
            Dialog = UI({
                type: null,
                args: null,
                onConfirm: function( pw, newPW ) {
                    if ( null == pw || 0 >= pw.length || null == newPW || 0 >= newPW.length ) {
                        return false;
                    }
                    
                    try {
                        var selectedCertIdx = parseInt(__certIdx);
                        var jsonUserCert = SANDBOX.PFUC[selectedCertIdx];
                        
                        var new_signPriB64, new_kmPriB64;
                        new_signPriB64 = new_kmPriB64 = null;
                        
                        var priKeyBin = SANDBOX.usWebToolkit.pkcs8.encryptedPrivateKeyFromBase64( jsonUserCert.signpri );
                        var bRv = SANDBOX.usWebToolkit.pkcs8.checkUserCertPassword(priKeyBin, pw);
                        if ( false === bRv ) {
                            priKeyBin = null;
                            var err = { code : -1, message : __text.IDS_MSGBOX_PW_ERROR_INPUT_WRONG_PASSWORD };
                            throw err;
                        } else {
                            new_signPriB64 = SANDBOX.usWebToolkit.pkcs8.changePassword(priKeyBin, pw, newPW, 'Base64');
                        }
                        priKeyBin = null;

                        if ( 'undefined' !== typeof(jsonUserCert.kmcert) ){
                            priKeyBin = SANDBOX.usWebToolkit.pkcs8.encryptedPrivateKeyFromBase64( jsonUserCert.kmpri );
                            var bRv = SANDBOX.usWebToolkit.pkcs8.checkUserCertPassword(priKeyBin, pw);
                            if ( false === bRv ) {
                                priKeyBin = null;
                                var err = { code : -1, message : __text.IDS_MSGBOX_PW_ERROR_INPUT_WRONG_PASSWORD };
                                throw err;
                            } else {
                                new_kmPriB64 = SANDBOX.usWebToolkit.pkcs8.changePassword(priKeyBin, pw, newPW, 'Base64');
                            }
                        }
                        priKeyBin = null;
                       
                       
                        var new_JsonUserCert = {};
                        new_JsonUserCert['signcert'] = jsonUserCert.signcert;
                        new_JsonUserCert['signpri'] = new_signPriB64;
                        if( null !== new_kmPriB64 ) {
                            new_JsonUserCert['kmcert'] = jsonUserCert.kmcert;
                            new_JsonUserCert['kmpri'] = new_kmPriB64;
                        }                        
                        
                        if ( SANDBOX.CONST.__PF_M_LS.device === __CurrentDevice ) {
	                        try {
	                            SANDBOX.PFSH.SaveUserCert(jsonUserCert.ca, new_JsonUserCert, /*pw*/document.domain, false);
	                            jsonUserCert = new_JsonUserCert = null;
	                            
	                            Param.onConfirm( true );
	                            
	                            SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_CERT_CHANGE_PW_SUCCESS);
	                        } catch (e) {
	                            console.log('***** SANDBOX.PFSH.SaveUserCert *****');  // for debug
	                            console.log('e.code : ', e.code , 'e.message : ', e.message, 'e.detail : ', e.detail);  // for debug
	
	                            switch ( e.code ) {
	                                //case '115010' : // SetP12OnMemory error code
	                                case 10000000 :
	                                    if ( 0 <= (e.detail).indexOf('115010') ) {
	                                        SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_PW_ERROR_PASSWORD_IS_NOT_MATCHED);
	                                    } else {
	                                        SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_CHANGE_PW_ERROR, e.detail);   
	                                    }
	                                    break;
	
	                                default :
	                                    SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_CHANGE_PW_ERROR, e.code);
	                                    break;
	                            }
	                        } finally {}
	                    }  // SANDBOX.CONST.__PF_M_LS.device === __CurrentDevice
	                    else if ( SANDBOX.CONST.__PF_M_SS.device === __CurrentDevice ) {
								SANDBOX.CCPFSH().SaveUserCert(jsonUserCert.ca, new_JsonUserCert, false, function(rv) {
										if ( rv == 0 ) {
											jsonUserCert = new_JsonUserCert = null;
								
											Param.onConfirm( true );
	                            			SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_CERT_CHANGE_PW_SUCCESS);
										}		
										else
											SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_CHANGE_PW_ERROR, rv);		
											
					                    pw = newPW = '';
					                    
					                    Dialog.dispose();
					                    setTimeout(function(){ __this.focus(); }, 10);																	
								});	                    	
	                    }
                        
                        
                    } catch (e) {
                        console.log('***** ChangePW error *****');  // for debug
                        console.log('Err Code : ', e.code, '\nErr Msg : ', e.message);  // for debug
                        SANDBOX.uiUtil().errMsgBox(e.message, e.code);
                    }

					if ( SANDBOX.CONST.__PF_M_LS.device === __CurrentDevice ) {
	                    pw = newPW = '';
	                    
	                    Dialog.dispose();
	                    setTimeout(function(){ __this.focus(); }, 10);
	                }
                },
                onCancel: function() {
                    Dialog.dispose();
                    setTimeout(function(){ __this.focus(); }, 10);
                }
            });
            Dialog.show();
            
            return true;
        }
        
        function DeleteCert( obj, textObj ) {
            if ( !obj || !textObj ) {
                return false;
            }
            
            var __this = obj;
            var __text = textObj;
            
            if ( confirm(__text.IDS_CONFIRMBOX_WARNING_DELETE_CERT) ) {
                var UI = SANDBOX.loadUI('password');               
                Dialog = UI({
                    type: null,
                    args: null,
                    onConfirm: function( pw ) {
                        if ( null == pw || 0 >= pw.length ) {
                            return false;
                        }
                        
                        try {
                            var selectedCertIdx = parseInt(__certIdx);
                            var pri = SANDBOX.usWebToolkit.pkcs8.encryptedPrivateKeyFromBase64( SANDBOX.PFUC[selectedCertIdx].signpri );
                            var bRv = SANDBOX.usWebToolkit.pkcs8.checkUserCertPassword(pri, pw);
                            pri = '';

                            if ( false === bRv ) {
                                SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_PW_ERROR_INPUT_WRONG_PASSWORD);
                            } else {
                            	if ( __CurrentDevice == SANDBOX.CONST.__PF_M_LS.device ) {
	                                try {
	                                    SANDBOX.PFSH.DeleteUserCertByIndex(selectedCertIdx, document.domain/* pw */);
	                                    Param.onConfirm( true );
	                                    SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_CERT_DELETE_SUCCESS);
	                                } catch (e) {
	                                    console.log('***** DeleteUserCertByIndex error *****');  // for debug
	                                    console.log('e.code : ', e.code , 'e.message : ', e.message, 'e.detail : ', e.detail);  // for debug
	                                    SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_DELETE_ERROR, e.code);
	                                }
	                            }
	                            else if ( __CurrentDevice == SANDBOX.CONST.__PF_M_SS.device ){
										SANDBOX.CCPFSH().DeleteUserCertByIndex(selectedCertIdx, function(rv, rvMsg) {
													if (rv == 0)	{	
													    Param.onConfirm( true );
		                                   				SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_CERT_DELETE_SUCCESS);
		                                   			}
		                                   			else {
		                                   				SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_DELETE_ERROR, rv);
		                                   			}
		                                   			
							                        pw = '';
							                        
							                        Dialog.dispose();
							                        setTimeout(function(){ __this.focus(); }, 10);		                                   			
											});	                            	
	                            }
                            }
                        } catch (e) {
                            console.log('***** CheckUserCertPassword error *****');  // for debug
                            console.log('Err Code : ', e.code, '\nErr Msg : ', e.message);  // for debug
                            SANDBOX.uiUtil().errMsgBox(e.message, e.code);
                        }
    
    					if ( __CurrentDevice == SANDBOX.CONST.__PF_M_LS.device ) {
	                        pw = '';
	                        
	                        Dialog.dispose();
	                        setTimeout(function(){ __this.focus(); }, 10);
	                    }
                    },
                    onCancel: function() {
                        Dialog.dispose();
                        setTimeout(function(){ __this.focus(); }, 10);
                    }
                });
                Dialog.show();
            } else {
                __this.focus();
            }
            
            return true;
        }
        
		function ExportPFX( obj, textObj ) {
			if ( !obj || !textObj ) {
				return false;
			}
			
			var __this = obj;
			var __text = textObj;
					
			var savedPath = null;
			var certPutOutBtn = document.getElementById('m-us-cert-manage-sub-put-cert-out-btn');
			
			var UI = SANDBOX.loadUI('password');
			Dialog = UI({
				type: null,
				args: null,
				onConfirm: function( pw ) {
					var selectedCertIdx = parseInt(__certIdx);
						
					if ( !SANDBOX.PFUC ) {
						pw = '';
						console.log('[error] SANDBOX.PFUC is null');  // for debug
						return false;
					}
					
					try {
						var pri = SANDBOX.usWebToolkit.pkcs8.encryptedPrivateKeyFromBase64( SANDBOX.PFUC[selectedCertIdx].signpri );
						var bRv = SANDBOX.usWebToolkit.pkcs8.checkUserCertPassword(pri, pw);
						pri = '';
						console.log('ExportPFX : bRv=', bRv);  // for debug

						if ( false === bRv ) {
							SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_PW_ERROR_INPUT_WRONG_PASSWORD);
						} else {
							if ( __CurrentDevice == SANDBOX.CONST.__PF_M_LS.device )	{
								var jsonRv = SANDBOX.PFSH.GetP12ForBuToPc(selectedCertIdx, pw, 'binary');
								var p12bin = jsonRv.p12;
								var dn = jsonRv.dn;
								var fileName = SANDBOX.certUtil().getCN(dn) + '.p12';
								console.log('ExportPFX : fileName=', fileName);  // for debug
								
								SANDBOX.fileUtil().save( fileName/*string type*/, p12bin/*binary type*/ );
								p12bin = dn = jsonRv = null;
							}			
							// 공용스토리지						
							else if ( __CurrentDevice == SANDBOX.CONST.__PF_M_SS.device )	{
								SANDBOX.CCPFSH().GetP12ForBuToPc(selectedCertIdx, pw, 'base64', function(rv, rvMsg, dn, p12Base64) {
												if ( rv == 0 )	{		
													var p12der = SANDBOX.usWebToolkit.util.decode64(p12Base64);
													// array 만들기
													var arr = new Array(p12der.length);
													for (var i = 0; i < p12der.length; i++) {
														arr[i] = p12der.charCodeAt(i);
													}
													
													var p12bin = new Uint8Array(arr);
													// 		    			
													var fileName = SANDBOX.certUtil().getCN(dn) + '.p12';
													console.log('ExportPFX : fileName=', fileName);  // for debug
													console.log('ExportPFX : binary =', p12bin);  // for debug
													
													SANDBOX.fileUtil().save( fileName/*string type*/, p12bin/*binary type*/ );						    					
												}
												else {
													
												}
																
												pw = '';
												Dialog.dispose();
												SANDBOX.uiUtil().loadingBox(false, "us-div-list-load");
												setTimeout(function(){ certPutOutBtn.focus(); }, 10);
											});
							}
						}
					} catch (e) {
						console.log('***** CheckUserCertPassword error *****');  // for debug
						console.log('Err Code : ', e.code, '\nErr Msg : ', e.message);  // for debug
						SANDBOX.uiUtil().errMsgBox(e.message, e.code);
					} finally {
					}

					if ( __CurrentDevice != SANDBOX.CONST.__PF_M_SS.device )	{
						pw = '';
						Dialog.dispose();
						SANDBOX.uiUtil().loadingBox(false, "us-div-list-load");
						setTimeout(function(){ certPutOutBtn.focus(); }, 10);
					}
				},
				onCancel: function() {
					Dialog.dispose();
					SANDBOX.uiUtil().loadingBox(false, "us-div-list-load");
					setTimeout(function(){ certPutOutBtn.focus(); }, 10);
				}
			});
			Dialog.show();

			return true;
		}        
        
        function ExportCert( obj, textObj ) {
            if ( !obj || !textObj ) {
                return false;
            }
            
            var __this = obj;
            var __text = textObj;
            
            var jsonRv = null;
            var p12key = null;
            var strp12 = null;
            
            function Export() {
	            try {
	                var forcallbrowser = 'default';
	                if ( 'android' === SANDBOX.osName ) {
	                    if ( 'android samsung' === SANDBOX.browserName || 'android lg' === SANDBOX.browserName || 'android browser' === SANDBOX.browserName ) {
	                        forcallbrowser = 'default';     
	                    } else if ( 'android chrome' === SANDBOX.browserName ) {
	                        forcallbrowser = 'chrome';
	                    }
	                } else if ( 'ios' == SANDBOX.osName ) {
	                    if ( 'ios safari' === SANDBOX.browserName ) {
	                        forcallbrowser = 'default';
	                    } else if ( 'ios chrome' === SANDBOX.browserName ) {
	                        forcallbrowser = 'googlechrome';
	                    }
	                }
	                
	                var forresultpage = window.location.href.split(/[?#]/)[0];
	                var lastIndex = forresultpage.lastIndexOf('/');
	                var subUrl = forresultpage.substr(0, lastIndex + 1);
	                forresultpage = subUrl + SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/layout/mobile/w2a/m_exportcertresult.html';
	                
	                UniSignW2A.backupStore(/*result page url*/forresultpage, 
	                    /*default, android -> chrome, ios -> googlechrome*/forcallbrowser, 
	                    strp12, 
	                    p12key, 
	                    /* 0 -> get, 1 -> post*/'0', 
	                    'recall'
	                );
	            } catch (e) {
	                alert('failure\ne : ' + e);  // test message
	            }
	            
	            return true;            	
            }
            
            if ( __CurrentDevice == SANDBOX.CONST.__PF_M_LS.device )	{
	            try {
	                jsonRv = SANDBOX.PFSH.GetP12ForBuToMo(/*idx*/parseInt(__certIdx), /*encoding*/'hex');
	                p12key = jsonRv.key;
	                strp12 = jsonRv.p12;
	                
	                Export();
	            } catch (e) {
	                console.log('***** GetP12ForBuToMo error *****');  // for debug
	                console.log('e.code : ', e.code , 'e.message : ', e.message, 'e.detail : ', e.detail);  // for debug
	                SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_EXPORT_ERROR, e.code);
	                
	                return false;
	            }            	
            }
            else if ( __CurrentDevice == SANDBOX.CONST.__PF_M_SS.device )	{
            	SANDBOX.CCPFSH().GetP12ForBuToMo(parseInt(__certIdx), 'hex', function(rv, rvMsg, key, p12) {
            		if (rv != 0) {
            			SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_EXPORT_ERROR, rv);
            			return false;
            		}
            		else	{
		                p12key = key;
		                strp12 = p12;
	            		
	            		Export();
            		}
            	});
            }
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
            
            var titleLbl = document.getElementById('m-us-lbl-cert-manage-sub-title');
            titleLbl.appendChild(document.createTextNode(__lang.IDS_CERT_MANAGEMENT));

            if ( null !== __certIdx && null !== __userCert ) {
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
           
            var certImg = document.getElementById('m-us-img-cert-manage-sub');
            if ( 0 === certStatus ) {
                certImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_cert_valid_small.png', 0);  //test code
            } else if ( 1 === certStatus ) {
                certImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_cert_valid_1_month_small.png', 0);  //test code
            } else if ( 2 === certStatus ) {
                certImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_cert_invalid_small.png', 0);  //test code
            } else {
                return;
            }

            var certInf = document.getElementById('m-us-div-cert-manage-sub-info');
            var spanNodes = certInf.getElementsByTagName("span");
            spanNodes[0].appendChild(document.createTextNode(certSubjectName));
            spanNodes[1].appendChild(document.createTextNode(__lang.IDS_CERT_ISSUER));
            spanNodes[2].appendChild(document.createTextNode(certIssuer));
            spanNodes[3].appendChild(document.createTextNode(__lang.IDS_CERT_CLASSIFY));
            spanNodes[4].appendChild(document.createTextNode(certType));
            spanNodes[5].appendChild(document.createTextNode(__lang.IDS_CERT_EXPIRATION_DAY));
            spanNodes[6].appendChild(document.createTextNode(certExpDate));
            }
            
            var certViewBtn = document.getElementById('m-us-cert-manage-sub-cert-view-btn');
            certViewBtn.setAttribute('value', __lang.IDS_CERT_VIEW, 0);
            certViewBtn.setAttribute('title', __lang.IDS_CERT_VIEW + __lang.IDS_BUTTON, 0);
            certViewBtn.setAttribute('tabindex', __TabIndex, 0);
            certViewBtn.onclick = function(){ ViewCert( this ) };
            
            var pwChangeBtn = document.getElementById('m-us-cert-manage-sub-pw-change-btn');
            pwChangeBtn.setAttribute('value', __lang.IDS_PW_CHANGE, 0);
            pwChangeBtn.setAttribute('title', __lang.IDS_PW_CHANGE + __lang.IDS_BUTTON, 0);
            pwChangeBtn.setAttribute('tabindex', __TabIndex + 1, 0);
            pwChangeBtn.onclick = function(){ ChangePW( this, __lang ) };
            
            var certCopyBtn = document.getElementById('m-us-cert-manage-sub-cert-copy-btn');
            certCopyBtn.setAttribute('value', __lang.IDS_CERT_COPY, 0);
            certCopyBtn.setAttribute('title', __lang.IDS_CERT_COPY + __lang.IDS_BUTTON, 0);
            certCopyBtn.setAttribute('tabindex', __TabIndex + 2, 0);
            certCopyBtn.onclick = function(){ /*CopyCert(this, __lang);*/ };
            // temporary codes - It should be removed
            certCopyBtn.readOnly = true;
            certCopyBtn.disabled = true;
            // temporary codes - It should be removed
            
            var certDeleteBtn = document.getElementById('m-us-cert-manage-sub-cert-delete-btn');
            certDeleteBtn.setAttribute('value', __lang.IDS_CERT_DELETE, 0);
            certDeleteBtn.setAttribute('title', __lang.IDS_CERT_DELETE + __lang.IDS_BUTTON, 0);
            certDeleteBtn.setAttribute('tabindex', __TabIndex + 3, 0);
            certDeleteBtn.onclick = function(){ DeleteCert(this, __lang); };
            
            var certPutOutBtn = document.getElementById('m-us-cert-manage-sub-put-cert-out-btn');
            certPutOutBtn.setAttribute('value', __lang.IDS_CERT_PUT_OUT, 0);
            certPutOutBtn.setAttribute('title', __lang.IDS_CERT_PUT_OUT + __lang.IDS_BUTTON, 0);
            certPutOutBtn.setAttribute('tabindex', __TabIndex + 4, 0);
            certPutOutBtn.onclick = function(){ ExportPFX(this, __lang); }; // ExportCert(this, __lang); };      // test
            
            var certCancelBtn = document.getElementById('m-us-cert-manage-sub-ccl-btn');
            certCancelBtn.setAttribute('value', __lang.IDS_CERT_CANCEL, 0);
            certCancelBtn.setAttribute('title', __lang.IDS_CERT_CANCEL + __lang.IDS_BUTTON, 0);
            certCancelBtn.setAttribute('tabindex', __TabIndex + 5, 0);
            certCancelBtn.onclick = function(){ WindowExit(); };

            var closeImg = document.getElementById('m-us-cert-manage-sub-cls-btn-img');
            closeImg.setAttribute('alt', __lang.IDS_PASSWORD_CLOSE, 0);
            closeImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_x-btn.png', 0);
            
            var closeBtn = document.getElementById('m-us-cert-manage-sub-cls-btn');
            closeBtn.setAttribute('tabindex', __TabIndex + 7, 0);
            closeBtn.onclick = function(){ WindowExit(); };

            return document.getElementById('m-us-div-cert-manage-sub');
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
                    if ( 'm-us-cert-manage-sub-cert-view-btn' == inputs[ i ].id ) {
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
