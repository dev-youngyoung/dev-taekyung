var __certmanage = function( SANDBOX ) {
    var ConstructScreen = function( Param ) {   
        var __UIElement = {
            __Layout: function() {
                var req;
    
                if ( window.XMLHttpRequest ) {
                    req = new window.XMLHttpRequest;
                } else {
                    req = new ActiveXObject('MSXML2.XMLHTTP.3.0');
                }
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/layout/mobile/m_certmanage.html?version=' + SANDBOX.ver, false);
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
        
        var __lang = eval((eval(__UIElement.__Lang))());
		
        var __ListUI = null;
        var __CertsList = null;

        var __TabIndex = SANDBOX.ESVS.TabIndex;
        var __CurrentDevice = SANDBOX.CONST.__PF_M_LS.device;
        var __CurrentDrive = 0;
        
        //if (SANDBOX.ESVS.Media != null && SANDBOX.ESVS.Media.defaultdevice != null){
        //    __CurrentDevice = SANDBOX.uiUtil().getMediaDevice( SANDBOX.ESVS.Media.defaultdevice );
        //}else{
        //    //if ( (0x02 & (0xFF & SANDBOX.ESVS.Mode)) ) {    /* plugin free mode */
        //    if ( (0x02 == SANDBOX.ESVS.Mode) ) {    /* plugin free mode */             
        //        __CurrentDevice = SANDBOX.CONST.__PF_M_LS.device;
        //    }
        //}
        
        var console = window.console || { log: function() {} };  // for debug
        
        function MakeCertViewList( textObj ) {
            if ( !SANDBOX.certsList || !textObj ) {
                return null;
            }
            
            var __text = textObj;
            
            var viewList = null;
            var certsList = SANDBOX.certsList;
            var certsCnt = certsList.list.length;
            
            var listArr = new Array();
            var listArrIndex = 0;
            
            for(var i = 0; i < certsCnt; i++) {
                SANDBOX.usWebToolkit.x509Certificate.parser( certsList.list[i].cert, 'Base64');
                 
                var oid = SANDBOX.usWebToolkit.x509Certificate.getCertificatePoliciesOid();
                var subject = SANDBOX.usWebToolkit.x509Certificate.getSubjectName();
                var expDate = SANDBOX.usWebToolkit.x509Certificate.getNotAfter();
                var expState = SANDBOX.usWebToolkit.x509Certificate.getNotAfter();
                var realIndex = certsList.list[i].index;
                
                var issuer = SANDBOX.certUtil().getIssuerName(oid);
                if ( 'undefined' == issuer ) {
                    issuer = SANDBOX.certUtil().getO(subject);
                }
                
                var struct = new Array();
                struct[0/*type*/] = SANDBOX.certUtil().getCertType(oid);                            // cert type
                struct[1/*text*/] = __text.IDS_CERT_EXPIRATION_DAY + ' ';                           // text
                struct[2/*expDate*/] = SANDBOX.certUtil().getLocalDate(expDate);                    // cert expiration date
                struct[3/*subject*/] = SANDBOX.certUtil().getCN(subject);                           // cert subject
                struct[4/*issuer*/] = issuer;                                                       // cert issuer
                struct[5/*realIndex*/] = realIndex;                                                 // cert index in list
                struct[6/*expStateValue*/] = SANDBOX.certUtil().getExpirationStateValue(expState);  // cert validity state value
                
                listArr[ listArrIndex++ ] = struct;
            }
            
            viewList = {list:listArr};
            return viewList;
        }
        
        function GetCerts( device, drive, textObj, pin ) {
            if ( SANDBOX.CONST.__USFB_M_DISK.device > device || 0 > drive || !textObj ) {
                return -1;
            }
            
            var __device = device;
            var __drive = drive;
            var __text = textObj;
            
            var nCertsCnt = 0;
            var rv = 0;
            
            __CurrentDrive = __drive;
            
            if ( SANDBOX.certsList ) {
                SANDBOX.certsList = null;
            }
            
            if ( (SANDBOX.CONST.__PF_M_LS.device === __device) && (0x02 & (0xFF & SANDBOX.ESVS.Mode)) ) {
                if ( !SANDBOX.PFSH ) {
                    // unsupport html5 storage
                    // display error popup
                    return -1;
                }

                try {
                    SANDBOX.PFSH.SelectStorage(/*Local Storage*/1); 
                } catch( e ) {
                    // initialize storage error
                    console.log('***** Plugin Free SelectStorage error *****');  // for debug
                    console.log('e.code : ', e.code , 'e.message : ', e.message, 'e.detail : ', e.detail);  // for debug
                }

                try {
                    SANDBOX.PFSH.LoadAllCerts(/*pw*/document.domain);
                } catch( e ) {
                    if ( 30100000 === e.code ) {
                        SANDBOX.PFSH.InstallCACerts(/*pw*/document.domain);
                        SANDBOX.PFSH.LoadAllCerts(/*pw*/document.domain);
                    } else {
                        console.log('***** Plugin Free LoadAllCerts error *****');  // for debug
                        console.log('e.code : ', e.code , 'e.message : ', e.message, 'e.detail : ', e.detail);  // for debug
                    }
                }

                var userCerts = null;
                try {
                    userCerts = SANDBOX.PFSH.GetUserCerts(/*pw*/document.domain);
                    SANDBOX.PFUC = userCerts;
                } catch( e ) {
                    console.log('***** Plugin Free GetUserCerts error *****');  // for debug
                    console.log('e.code : ', e.code , 'e.message : ', e.message, 'e.detail : ', e.detail);  // for debug
                }
                
                if ( userCerts ) {
                    nCertsCnt = userCerts.length - 1;
                }
                console.log('***** Plugin Free *****');  // for debug
                console.log('user certificate counts : ', nCertsCnt );  // for debug
                
                if ( 0 < nCertsCnt ) {
                    var listArr = new Array();
                    for (var i = 0; i < nCertsCnt; i++) {
                        var index = i + 1;
                        var struct = new Object();
                        struct['index'] = index;
                        struct['cert'] = userCerts[index].signcert;
                        listArr[i] = struct;
                    }

                    SANDBOX.certsList = {list:listArr};
                } else {
                    SANDBOX.certsList = null;
                    rv = 0;
                }
            }            
            else {
                
            }
            
            return rv;
        }
        
        function GetCertsNDrawList( device, drive, textObj, pin )	{
            __CurrentDevice = device;
            
            if ( SANDBOX.certsList ) {
                SANDBOX.certsList = null;
            }
                    	
			SANDBOX.CCPFSH().GetCCStorageHandler(SANDBOX.ESVS.EncAlgo, SANDBOX.ESVS.HashAlgo, SANDBOX.ESVS.PKI, function (rv, otStorageHandler) {
				if (rv == 0) {
						SANDBOX.CCPFSH().GetCertificateList(function(rv, userCerts) {
								if (rv == 0 ) {
									var nCertsCnt = 0;
									SANDBOX.PFUC = userCerts;
									
									if ( userCerts ) {
										nCertsCnt = userCerts.length - 1;
									}
									
									console.log('***** Plugin Free *****');  // for debug
									console.log('user certificate counts : ', nCertsCnt );  // for debug
									
									if ( 0 < nCertsCnt ) {
										var listArr = new Array();
										for (var i = 0; i < nCertsCnt; i++) {
											var index = i + 1;
											var struct = new Object();
											struct['index'] = index;
											struct['cert'] = userCerts[index].signcert;
											listArr[i] = struct;
										}
					
										SANDBOX.certsList = {list:listArr};				
									}		
																	
									var viewList = MakeCertViewList( textObj );							
									if ( viewList ) {
										__CertsList.redrawList( viewList.list, viewList.list.length, __CurrentDevice );
									} else {
										__CertsList.redrawList( null, 0, __CurrentDevice );
									}	
									return true;									
								}
								else	
									return false;
							});
					
				}
			});        	
        }        
        
        function ShowSoftwareVersion( obj ) {
            if ( !obj ) {
                return false;
            }
            
            var __this = obj;
            
            var UI = SANDBOX.loadUI('swinfo');
            var Dialog = UI({
                type: null,
                args: null,
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

        /*****   plugin free   *****/
        function GetCertsFromDevice( device, obj, textObj ) {
            if ( !obj || !textObj ) {
                return false;
            }
            
            var __this = obj;
            var __text = textObj;
            
            __CurrentDevice = device;
            __CurrentDrive = 0;
            
            if ( SANDBOX.certsList ) {
                SANDBOX.certsList = null;
            }
            
            __CertsList.redrawList( null, -1, __CurrentDevice );
            
            if (SANDBOX.CONST.__PF_M_LS.device == device)	{                 
	            var errCode = GetCerts( device, 0, __text, '' );
	            if ( 0 != errCode ) {
	                SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_COMMON_ERROR_GET_CERT, errCode);
	                __CertsList.redrawList( null, 0, __CurrentDevice );
	                return false;
	            }
	            
	            var viewList = MakeCertViewList( textObj );
	            if ( viewList ) {
	                __CertsList.redrawList( viewList.list, viewList.list.length, __CurrentDevice );
	            } else {
	                __CertsList.redrawList( null, 0, __CurrentDevice );
	            }
	        }
	        else if (SANDBOX.CONST.__PF_M_SS.device == device)	{      
            	GetCertsNDrawList( device, 0, __text, '' );
            }
            
            return true;
        }
        /*****   plugin free   *****/
        
        function GetCertsFromETC( obj, textObj ) {
            if ( !obj || !textObj ) {
                return false;
            }
            
            var __this = obj;
            var __text = textObj;

            SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_NOT_SUPPORTED_MEDIA);
            
            return true;
        }
        
        function DrawCertsListView( textObj ) {
            if ( !textObj ) {
                return false;
            }
            
            var __text = textObj;
            
            var errCode = GetCerts( __CurrentDevice, 0, __text, '' );
            if ( 0 != errCode ) {
                SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_COMMON_ERROR_GET_CERT, errCode);
                //return false;
            }
           
            var viewList = MakeCertViewList( textObj );
            
            __ListUI = SANDBOX.loadUI('certlist');
            __CertsList = __ListUI({
                listtype    : 'mobilecertmanage',
                bodyid      : 'm-us-div-cert-manage-list-inner',
                rowid       : 'm-us-mobile-cert-manage-cert-list-row',
                imgid       : 'm-us-mobile-cert-manage-cert-status-img',
                eleid       : 'm-us-mobile-cert-manage-cert-data-element',
                device 		: __CurrentDevice,
                
                confirm     : function( fRedraw ) {
                    if ( fRedraw ) {
                    	if ( SANDBOX.CONST.__PF_M_LS.device == __CurrentDevice )	{
	                         GetCertsNDrawList( __CurrentDevice, 0, __text , '' );
	                        
	                        var viewList = MakeCertViewList( __text );
	                        if ( viewList ) {
	                            __CertsList.redrawList( viewList.list, viewList.list.length, __CurrentDevice );
	                        } else {
	                            __CertsList.redrawList( null, 0, __CurrentDevice );
	                        }                   		
                    	}
                    	else if ( SANDBOX.CONST.__PF_M_SS.device == __CurrentDevice )	{
                    		GetCertsNDrawList( __CurrentDevice, 0, __text, '' );
                    	}
                    }
                },
                cancel      : function() {
                    
                }
            });
                        
            if ( viewList ) {
                __CertsList.drawList( viewList.list, viewList.list.length, __TabIndex++ );
            } else {
                __CertsList.drawList( null, 0, __TabIndex++ );
            }

            return true;
        }
        
        
		// test
		function CallPFXImportFunc( textObj ) {
			if ( null == textObj ) {
				return false;
			}

			var __text = textObj;
			
			var fileSearchHidden = document.getElementById('m-us-cert-manage-file-search-hidden');
			
			if ( 'safari' == SANDBOX.browserName && 6.0 > parseFloat(SANDBOX.browserVersion) ) {
				SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_SEARCH_CERT_GUIDE_FOR_SAFARI);
				return false;
			}
			
			if ( ('opera' == SANDBOX.browserName) 
				|| ('safari' == SANDBOX.browserName/* && 6.0 <= parseFloat(SANDBOX.browserVersion)*/) 
				|| ('msie' == SANDBOX.browserName && 8 === parseInt(SANDBOX.browserVersion)) ) {  // IE 8.0
				fileSearchHidden.style.display = 'block';
			}			
			fileSearchHidden.value = '';
	
			if ( '' != fileSearchHidden.value ) {  // for IE
				var onchangeFunc = fileSearchHidden.onchange;
				var parent = fileSearchHidden.parentNode;
				parent.removeChild(fileSearchHidden);
				
				fileSearchHidden = document.createElement('input');
				fileSearchHidden.setAttribute('type', 'file', 0);
				fileSearchHidden.setAttribute('accept', 'application/x-pkcs12', 0);
				fileSearchHidden.setAttribute('id', 'm-us-cert-manage-file-search-hidden', 0);
				fileSearchHidden.className = 'm-us-layout-cert-manage-file-search-hidden';
				fileSearchHidden.onchange = onchangeFunc;
				
				parent.appendChild(fileSearchHidden);
			}
			fileSearchHidden.click();

			return true;
		}

		function IsPFX( fileName, textObj ) {
			if ( null == fileName || 0 >= fileName.length || null == textObj ) {
				return false;
			}
			
			var __text = textObj;
			
			if ( 0 < fileName.length && -1 < fileName.indexOf('.') ) {
				var strArr = fileName.split('.');
				var fileExt = strArr[ strArr.length - 1 ].toLowerCase();
				
				if ( 'pfx' != fileExt && 'p12' != fileExt ) {
					SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_FILE_ERROR_NOT_PFX);
					return false;
				}
			} else {
				SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_FILE_ERROR_READ);
				return false;
			}
			
			return true;
		}	

		function ImportPFX( obj, textObj ) {
			if ( !obj || !textObj ) {
				return false;
			}
			
			var __this = obj;
			var __text = textObj;
			
			var fileFullPath = null;
			var fileB64Bin = null;
			
			var certGetBtn = document.getElementById('m-us-cert-manage-get-cert-btn');
			
			if ( 'opera' == SANDBOX.browserName || 'safari' == SANDBOX.browserName ) {
				__this.style.display = 'none';
			}
					
			if ( window.FileReader ) { // IE 10.0 ~, FireFox 3.6 ~, Chrome 6.0 ~, Opera 11.1 ~, Safari 6.0 ~
				var files = __this.files;
				
				if ( 0 < files.length ) {
					var file = files[0];
						
					if ( true == IsPFX( file.name, __text ) ) {
						var reader = new FileReader();
						
						if ( reader.readAsBinaryString ) {
                            reader.readAsBinaryString(file);
                            reader.addEventListener( 'load', function() {
                                var buf = reader.result;
                                var bufLen = buf.length;
                                
                                if ( file.size === bufLen ) {
                                    fileB64Bin = SANDBOX.usWebToolkit.util.encode64(buf, bufLen);
                                } else {
                                    SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_FILE_ERROR_READ);
                                    return false;
                                }
                            });
                        } else {
                            reader.readAsArrayBuffer(file);
                            reader.addEventListener( 'load', function() {
                                var arrBuf = reader.result;
                                var arrBufLen = arrBuf.byteLength;
                                
                                function ArrayBufferToString(buffer) {
                                    return BinaryToString(String.fromCharCode.apply(null, Array.prototype.slice.apply(new Uint8Array(buffer))));
                                }
                                
                                function BinaryToString(binary) {
                                    var error;

                                    try {
                                        return decodeURIComponent(escape(binary));
                                    } catch (_error) {
                                        error = _error;
                                        if (error instanceof URIError) {
                                            return binary;
                                        } else {
                                            throw error;
                                        }
                                    }
                                }
                                
                                var buf = null;
                                try {
                                    buf = ArrayBufferToString(arrBuf);
                                } catch (e) {
                                    SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_FILE_ERROR_READ);
                                    return false;
                                }
                                
                                var bufLen = buf.length;
                                
                                if ( file.size === bufLen ) {
                                    fileB64Bin = SANDBOX.usWebToolkit.util.encode64(buf, bufLen);
                                } else {
                                    SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_FILE_ERROR_READ);
                                    return false;
                                }
                            });
                        }
				   } else {
				   		setTimeout(function(){ certGetBtn.focus(); }, 10);
				   		return false;
				   }
			     } else {
			     	//SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_FILE_ERROR_READ);
			     	setTimeout(function(){ certGetBtn.focus(); }, 10);
			     	return false;
			     }
			} else {
				if ( 'msie' == SANDBOX.browserName && (8 === parseInt(SANDBOX.browserVersion)) ) {  // IE 8.0
					var mainwin = document.getElementById('us-div-cert-manage');
					mainwin.onselectstart = function(){ return true; };
					{
						__this.select();
						fileFullPath = document.selection.createRange().text;
						__this.style.display = 'none';
					}
					mainwin.onselectstart = function(){ return false; };
				} else if ( 'msie' == SANDBOX.browserName && (9 === parseInt(SANDBOX.browserVersion)) ) {  // IE 9.0
					fileFullPath = __this.value;
					
					if ( -1 < fileFullPath.indexOf('fakepath') ) {
						SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_SEARCH_CERT_GUIDE_FOR_IE9);
						setTimeout(function(){ certGetBtn.focus(); }, 10);
						return false;
					}
				} else {
					fileFullPath = __this.value;
					console.log('file full path : ', fileFullPath);  // for debug
				}
				
				if ( false == IsPFX( fileFullPath, __text ) ) {
					setTimeout(function(){ certGetBtn.focus(); }, 10);
			   		return false;
			    }
			}

			function RedrawListByResult( result, device, drive, pin ) {
				if ( 0 === result ) {
					SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_CERT_IMPORT_SUCCESS);				
					GetCertsFromDevice(__CurrentDevice, this, __text);
				} else {
                	switch ( result ) {	
						case 48230000 :
							SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_PW_ERROR_INPUT_WRONG_SEC_TOKEN_PIN);
							break;

						case 48250000 :
							SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_PW_ERROR_SEC_TOKEN_PIN_LOCKED);
							break;
							
						case 48430000 :
							SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_HSM_ERROR_CERT_ALREADY_EXISTS);
							break;

						case 48440000 :
							SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_HSM_ERROR_MEMORY_TOO_SMALL);
							break;
							
						case 48460000 :
                            SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_HSM_ERROR_UNSUPPORT_KEY_LENGTH);
                            break;

						case 49000004 :
							SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_PW_ERROR_INPUT_WRONG_SAVE_TOKEN_PIN);
							break;

						case 49000005 :
							SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_PW_ERROR_SAVE_TOKEN_PIN_LOCKED);
							break;
							
						case 41230000 :						    
						    var latestCertExpDate = SANDBOX.plugin().GetLastErrorMessage();
                            var latestCertExpLocalDate = SANDBOX.certUtil().getLocalDate(latestCertExpDate);
                            console.log('latestCertExpLocalDate : ', latestCertExpLocalDate);  // for debug
                            
                            var errMsg = __text.IDS_MSGBOX_CERT_COPY_ERROR_NEWEST_CERT + '\n\n' 
                                        + __text.IDS_NEWEST_CERT_EXPIRATION_DATE + latestCertExpLocalDate;
                                         
                            SANDBOX.uiUtil().msgBox(errMsg);
						    break;

						default :
							var errCode = 0;
							if ( SANDBOX.CONST.__PF_M_LS.device === device ) {
								errCode = result;
							} 							
							switch ( errCode ) {
							    case 3509 :
                                    SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_PW_ERROR_INPUT_WRONG_PASSWORD);
                                    break;
                                    
                                default :
                                    SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_IMPORT_ERROR, errCode);
                                    break;
							}
							break;
					}
				}
			}
			
			function ImportSS( fileB64Bin, pw, device, drive, SSDialog ) {
					SANDBOX.CCPFSH().SetP12OnMemory(fileB64Bin, pw, function(rv, rvMsg, certsInfo) {
						if (rv == 0) {
								var index = certsInfo.index;
								var jsonUserCert = certsInfo.aluc[index];
								
								SANDBOX.usWebToolkit.x509Certificate.parser( jsonUserCert.signcert, 'Base64');
								var oid = SANDBOX.usWebToolkit.x509Certificate.getCertificatePoliciesOid();
								var ca = SANDBOX.certUtil().getIssuerEnName(oid);
								
								SANDBOX.CCPFSH().SaveUserCert(ca, jsonUserCert, true, function(rv) {
									pw = '';
									SSDialog.dispose();
																		
									if (rv == 0) 	{
										RedrawListByResult(rv, device, drive, '');
									}
									else {
										SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_IMPORT_ERROR, rvMsg);	
									}
									setTimeout(function(){ certGetBtn.focus(); }, 10);									
								});											
						}
						else {
							switch (rv) {
								//case '115010' :	// SetP12OnMemory error code
								case 10000000 :
									if ( 0 <= (rvMsg).indexOf('115010') ) {
										SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_PW_ERROR_PASSWORD_IS_NOT_MATCHED);
									} else {
										SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_IMPORT_ERROR, rvMsg);	
									}
									break;
								//case 31080000 :	// SaveUserCert error code // original certificate is latest
									//SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_IMPORT_ERROR, e.code);
								//	break;
								default :
									SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_IMPORT_ERROR, rv);
									break;
							}
							pw = '';
							SSDialog.dispose();
							setTimeout(function(){ certGetBtn.focus(); }, 10);								
																		
						}
					
					});				
			}
			
			var UI = SANDBOX.loadUI('password');
			Dialog = UI({
				type: null,
				args: null,
				onConfirm: function( pw ) {
					Dialog.dispose();
					
					var SSUI = SANDBOX.loadUI('storageselect');
					SSDialog = SSUI({
						type: 'CERT_IMPORT',
						args: null,
						onConfirm: function( device, drive ) {
							if ( SANDBOX.CONST.__PF_M_SS.device === device && SANDBOX.CCPFSH() ) {
								SANDBOX.CCPFSH().IsCCPFSHAvailable(function(rv) {
									if ( rv == 0 ) 
										ImportSS(fileB64Bin, pw, device, drive, SSDialog);		
									else	{
										SANDBOX.CCPFSH().GetCCStorageHandler(SANDBOX.ESVS.EncAlgo, SANDBOX.ESVS.HashAlgo, SANDBOX.ESVS.PKI, function (rv, otStorageHandler) {											
											if ( rv == 0 )
												ImportSS(fileB64Bin, pw, device, drive, SSDialog);	
											else	{
												pw = '';
												SSDialog.dispose();
												setTimeout(function(){ certGetBtn.focus(); }, 10);													
												SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_IMPORT_ERROR, rv);
											}
										});									
									}
								});
							} else if ( SANDBOX.CONST.__PF_M_LS.device === device ) {
								if ( !SANDBOX.PFSH ) {
									// unsupport html5 storage
									// display error popup
									SANDBOX.uiUtil().msgBox('unsupport html5 storage');
									return false;
								}
								
								var rv = 0;
								try {
									var rJson = SANDBOX.PFSH.SetP12OnMemory(fileB64Bin, pw);
									var index = rJson.index;
									var jsonUserCert = rJson.aluc[index];
									
									SANDBOX.usWebToolkit.x509Certificate.parser( jsonUserCert.signcert, 'Base64');
									var oid = SANDBOX.usWebToolkit.x509Certificate.getCertificatePoliciesOid();
									var ca = SANDBOX.certUtil().getIssuerEnName(oid);
									
									SANDBOX.PFSH.SaveUserCert(ca, jsonUserCert, /*pw*/document.domain, true);
								} catch (e) {
									console.log('***** SANDBOX.PFSH.SaveUserCert *****');  // for debug
									console.log('e.code : ', e.code , 'e.message : ', e.message, 'e.detail : ', e.detail);  // for debug
										
									rv = e.code;
									switch (e.code) {
										//case '115010' :	// SetP12OnMemory error code
										case 10000000 :
											if ( 0 <= (e.detail).indexOf('115010') ) {
											SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_PW_ERROR_PASSWORD_IS_NOT_MATCHED);
											} else {
												SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_IMPORT_ERROR, e.detail);	
											}
											break;
										//case 31080000 :	// SaveUserCert error code // original certificate is latest
											//SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_IMPORT_ERROR, e.code);
										//	break;
										default :
											SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_CERT_IMPORT_ERROR, e.code);
											break;
									}
								}
								
								RedrawListByResult(rv, device, drive, '');

								pw = '';
								SSDialog.dispose();
								setTimeout(function(){ certGetBtn.focus(); }, 10);	
							} 
						},
						onCancel: function() {
							pw = '';
							SSDialog.dispose();
							setTimeout(function(){ certGetBtn.focus(); }, 10);
						}
					});
					SSDialog.show();
				},
				onCancel: function() {
					Dialog.dispose();
					setTimeout(function(){ certGetBtn.focus(); }, 10);
				}
			});
			Dialog.show();
			
			return true;
		}		
		
		
		// test end        
        
        function ImportCert( obj, textObj ) {
            if ( !obj || !textObj ) {
                return false;
            }
            
            var __this = obj;
            var __text = textObj;
           
            try {
                var forrecallbrowser = 'default'; 
                if ( 'android' === SANDBOX.osName ) {
                    if ( 'android samsung' === SANDBOX.browserName || 'android lg' === SANDBOX.browserName || 'android browser' === SANDBOX.browserName ) {
                        forrecallbrowser = 'default';     
                    } else if ( 'android chrome' === SANDBOX.browserName ) {
                        forrecallbrowser = 'chrome';
                    }
                } else if ( 'ios' == SANDBOX.osName ) {
                    if ( 'ios safari' === SANDBOX.browserName ) {
                        forrecallbrowser = 'default';
                    } else if ( 'ios chrome' === SANDBOX.browserName ) {
                        forrecallbrowser = 'googlechrome';
                    }
                }
                
                var forresultpage = window.location.href.split(/[?#]/)[0];
                var lastIndex = forresultpage.lastIndexOf('/');
                var subUrl = forresultpage.substr(0, lastIndex + 1);
                forresultpage = subUrl + SANDBOX.ESVS.SRCPath + 'proxy.html'; // 'unisignweb/rsrc/layout/mobile/w2a/m_importcertresult.html';
                
                UniSignW2A.backupLoad(/*result page url*/forresultpage, 
                    /*default, android -> chrome, ios -> googlechrome*/forrecallbrowser, 
                    /* 0 -> get, 1 -> post*/'0', 
                    'recall'
                );
            } catch (e) {
                alert('failure\ne : ' + e);  // test message
            } 
            
            return true;
        }
        
        function ChangeButtonStyle( obj ) {
            if ( !obj ) {
                return false;
            }

            var __this = obj;

            displayMediaAllStorage( __this, __lang, 'close' );
            
            var mediaList = SANDBOX.ESVS.Media.list.split('|');
			
            for ( var i = 0; i < mediaList.length; i++ ) {
                var mediaName = mediaList[i];
                var mediaInfo = SANDBOX.CONST.medias[mediaName];
				
                if (mediaInfo == undefined || mediaInfo == null) {
                    continue;
                }
                
                var button = document.getElementById('m-us-cert-manage-btn-' + mediaInfo.name);
                if ( button != undefined && button != null ) {
                    if (button.className != 'm-us-layout-storage-btn-none') {
                        if ( __this === button ) {
                            button.className = 'm-us-layout-storage-btn-on';
                            button.focus();
                        } else {
                            button.className = 'm-us-layout-storage-btn-off';
                        }
                        //button.className = 'us-layout-storage-btn-none';
                    }
                }
            }

            return true;
        }

        function displayMediaButton( deviceBtnInfo ) {
            if ( null == deviceBtnInfo || undefined == deviceBtnInfo ) {
                return false;
            }
            
            var isHidden = !SANDBOX.uiUtil().isItSupportingThisStorage(deviceBtnInfo);
            if ( isHidden == false && null != SANDBOX.ESVS.Media && null != SANDBOX.ESVS.Media.list ) {
                if ( 0 > SANDBOX.ESVS.Media.list.indexOf(deviceBtnInfo.name) ) {
                    isHidden = true;
                }
            }
        
            if ( isHidden ) {
                return false;
            } else {
//                <li id="us-cert-manage-storage-btn-li-removable">
//                  <button id="us-cert-manage-btn-removable" class="us-layout-storage-btn-off" type="button">
//                      <span class="us-drive-select"><img id="us-cert-manage-img-drive" /></span>
//                      <span class="us-img-storage"><img id="us-cert-manage-img-removable" /></span>
//                      <span id="us-cert-manage-lbl-removable" class="us-layout-lbl-storage"></span>
//                  </button>
//              </li>
                var ul = document.getElementById('m-us-cert-manage-storage-btn-list');
                
                var li = document.createElement('li');
                li.setAttribute('id', "m-us-cert-manage-storage-btn-li-"+deviceBtnInfo.name, 0);
                li.setAttribute('mediaIndex', deviceBtnInfo.mediaIndex, 0);
                if ( 5 == deviceBtnInfo.mediaIndex ) {
                    li.className = 'line-first';
                }
                if ('hidden' === deviceBtnInfo.visibility) {
                    li.style.display = 'none';
                    li.style.visibility = 'hidden';
                } else {
                    li.style.display = 'block';
                    li.style.visibility = 'visible';
                }
                
                var button = document.createElement('button');
                button.setAttribute('type', 'button', 0);
                button.setAttribute('id', 'm-us-cert-manage-btn-' + deviceBtnInfo.name, 0);
                button.setAttribute('title', deviceBtnInfo.label, 0);
                button.setAttribute('tabindex', deviceBtnInfo.tabIndex, 0);         
                if ( deviceBtnInfo.disabled ) {    /* plugin free mode */             
                    button.onclick = function() { /* SANDBOX.uiUtil().msgBox( __lang.IDS_MSGBOX_NOT_SUPPORTED_MEDIA ); */ };
                    button.className = 'm-us-layout-storage-btn-none';
                } else {
                    button.onclick = deviceBtnInfo.onclick;
                    if ( deviceBtnInfo.device === __CurrentDevice ) {
                        button.className = 'm-us-layout-storage-btn-on';
                        button.focus();
                    } else {
                        button.className = 'm-us-layout-storage-btn-off';
                    }
                }
                li.appendChild(button);
                
                if ('harddisk' !== deviceBtnInfo.name && 'webstorage' !== deviceBtnInfo.name) {
                    var plusImgSpan = document.createElement('span');
                    plusImgSpan.className = 'm-us-drive-select';
                    button.appendChild(plusImgSpan);
                }
                
                var imgSpan = document.createElement('span');
                imgSpan.className = 'm-us-img-storage';
                var btnImg = document.createElement('img');
                btnImg.setAttribute('id', 'm-us-cert-manage-img-' + deviceBtnInfo.name, 0);
                btnImg.setAttribute('alt', deviceBtnInfo.label, 0);
                if ( deviceBtnInfo.disabled ) {    /* plugin free mode */             
                    btnImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_media_'+deviceBtnInfo.name+'_d.png', 0);
                } else {
                    btnImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_media_'+deviceBtnInfo.name+'.png', 0);
                }
                imgSpan.appendChild(btnImg);
                button.appendChild(imgSpan);

                var lblSpan = document.createElement('span');
                lblSpan.setAttribute('id', 'm-us-cert-manage-lbl-' + deviceBtnInfo.name, 0);
                lblSpan.className = 'm-us-layout-lbl-storage';
                lblSpan.appendChild(document.createTextNode( deviceBtnInfo.label ));
                button.appendChild(lblSpan);               
                li.appendChild(button);         
                ul.appendChild(li);
            }
            
            return true;
        }

        function displayMediaAllStorage( obj, textObj, showType ) {
            var __text = textObj;

            if (showType == 'no_more') {
                SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_NOT_MORE_MEDIA);
            } else {
                var div = document.getElementById('m-us-cert-manage-storage-wrap');

                if (showType == 'open') {
                    div.className = "m-us-layout-storage-more-wrap"; 
                    
                    var moreBtn = document.getElementById('m-us-cert-manage-storage-more-btn');
                    moreBtn.setAttribute('title', (__text.IDS_STORAGE_MORE_VIEW + __text.IDS_STORAGE_MORE_VIEW_HIDDEN + __text.IDS_BUTTON), 0);
                    moreBtn.onclick = function(){ displayMediaAllStorage(this, __text, 'close'); };
                    
                    var moreBtnImg = document.getElementById('m-us-cert-manage-storage-more-btn-img');
                    moreBtnImg.setAttribute('alt', (__text.IDS_STORAGE_MORE_VIEW + __text.IDS_STORAGE_MORE_VIEW_HIDDEN), 0);
                    moreBtnImg.setAttribute('src', SANDBOX.ESVS.SRCPath + "unisignweb/rsrc/img/mobile/m_media_more_btn_close.png", 0);
                } else {
                    div.className = "m-us-layout-storage-wrap"; 

                    var moreBtn = document.getElementById('m-us-cert-manage-storage-more-btn');
                    moreBtn.setAttribute('title', (__text.IDS_STORAGE_MORE_VIEW + __text.IDS_STORAGE_MORE_VIEW_SHOW + __text.IDS_BUTTON), 0);
                    moreBtn.onclick = function(){ displayMediaAllStorage(this, __text, 'open'); };
                    
                    var moreBtnImg = document.getElementById('m-us-cert-manage-storage-more-btn-img');
                    moreBtnImg.setAttribute('alt', (__text.IDS_STORAGE_MORE_VIEW + __text.IDS_STORAGE_MORE_VIEW_SHOW), 0);
                    moreBtnImg.setAttribute('src', SANDBOX.ESVS.SRCPath + "unisignweb/rsrc/img/mobile/m_media_more_btn_open.png", 0);
                }
                
                var mediaList = SANDBOX.ESVS.Media.list.split('|');
                for ( var i = 0; i < mediaList.length; i++ ) {
                    var mediaName = mediaList[i];
                    var mediaInfo = SANDBOX.CONST.medias[mediaName];
                    if (mediaInfo == undefined || mediaInfo == null) {
                        continue;
                    }
                    
                    var li = document.getElementById("m-us-cert-manage-storage-btn-li-" + mediaInfo.name);
                    if (li != undefined && li != null) {
                        var mediaIndex = li.getAttribute('mediaIndex');
                        if (showType == 'open') {
                            li.style.display = 'block';
                            li.style.visibility = 'visible';
                        } else {
                            if ( mediaIndex > 4 ) {
                                li.style.display = 'none';
                                li.style.visibility = 'hidden';
                            }else{
                                li.style.display = 'block';
                                li.style.visibility = 'visible';
                            }
                        }                   
                        
                        if ( mediaIndex == 1 ) {
                            var button = document.getElementById('m-us-cert-manage-btn-' + mediaInfo.name);
                            button.focus();
                            //break;
                        }
                    }
                }
            }
            
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
            
            var titleLbl = document.getElementById('m-us-cert-manage-lbl-title');
            titleLbl.appendChild(document.createTextNode(__lang.IDS_CERT_MANAGEMENT));
            
            var mediaCnt = 0;
            var mediaList = SANDBOX.ESVS.Media.list.split('|');
            
            for ( var i = 0; i < mediaList.length; i++ ) {
                var mediaName = mediaList[i];
                var mediaInfo = SANDBOX.CONST.medias[mediaName];
                
                if ( null != mediaInfo && undefined != mediaInfo ) {
                    switch ( mediaInfo.device ) {
                        case SANDBOX.CONST.__PF_M_LS.device :
                            // localstorage button display
                            mediaInfo.label = __lang.IDS_STORAGE_LS;
                            mediaInfo.disabled = (0x01 == SANDBOX.ESVS.Mode);   /* if plugin free mode is diasbled */
                            mediaInfo.onclick = function(){ GetCertsFromDevice(SANDBOX.CONST.__PF_M_LS.device, this, __lang); ChangeButtonStyle(this); };
                            break;
                        case SANDBOX.CONST.__PF_M_SS.device :
                            // localstorage button display
                            mediaInfo.label = __lang.IDS_STORAGE_SS;
                            mediaInfo.disabled = (0x01 == SANDBOX.ESVS.Mode);   /* if plugin free mode is diasbled */
                            mediaInfo.onclick = function(){ GetCertsFromDevice(SANDBOX.CONST.__PF_M_SS.device, this, __lang); ChangeButtonStyle(this); };
                            break;                            
                        case SANDBOX.CONST.__PF_M_TOUCHSIGN.device :
                            // touch sign button display
                            mediaInfo.label = __lang.IDS_STORAGE_TOUCHSIGN;
                            mediaInfo.disabled = true;  /* if plugin free mode is diasbled */
                            mediaInfo.onclick = function(){ /* GetCertsFromETC(this, __lang); */ /* ChangeButtonStyle(this); */ };
                            break;
                        case SANDBOX.CONST.__PF_M_SMARTSIGN.device :
                            // smart sign button display
                            mediaInfo.label = __lang.IDS_STORAGE_SMARTSIGN;
                            mediaInfo.disabled = true;  /* if plugin free mode is diasbled */
                            mediaInfo.onclick = function(){ /* GetCertsFromETC(this, __lang); */ /* ChangeButtonStyle(this); */ };
                            break;
                        case SANDBOX.CONST.__PF_M_WEBSECTOKEN.device :
                            // web security token button display
                            mediaInfo.label = __lang.IDS_STORAGE_WEBSECTOKEN;
                            mediaInfo.disabled = true;  /* if plugin free mode is diasbled */
                            mediaInfo.onclick = function(){ /* GetCertsFromETC(this, __lang); */ /* ChangeButtonStyle(this); */ };
                            break;
                        case SANDBOX.CONST.__PF_M_WEBSOFTTOKEN.device :
                            // web soft security token button display
                            mediaInfo.label = __lang.IDS_STORAGE_WEBSOFTTOKEN;
                            mediaInfo.disabled = true;  /* if plugin free mode is diasbled */
                            mediaInfo.onclick = function(){ /* GetCertsFromETC(this, __lang); */ /* ChangeButtonStyle(this); */ };
                            break;
                        default :
                            // disable
                            mediaInfo.label = __lang.IDS_STORAGE_ETC;
                            mediaInfo.disabled = true;  /* if plugin free mode is diasbled */
                            mediaInfo.onclick = function(){ /* GetCertsFromETC(this, __lang); */ /* ChangeButtonStyle(this); */ };
                            break;
                    }
                    
                    mediaInfo.tabIndex = __TabIndex;
                    mediaInfo.mediaIndex = ( mediaCnt + 1 );
                    if ( 4 < mediaInfo.mediaIndex ) {
                        mediaInfo.visibility = 'hidden';
                    } else {
                        mediaInfo.visibility = 'visible';
                    }
                    
                    if ( displayMediaButton( mediaInfo ) ){
                        __TabIndex++; 
                        mediaCnt++;
                    };
                }
            }
            
            var moreBtn = document.getElementById('m-us-cert-manage-storage-more-btn');
            if ( null != moreBtn && undefined != moreBtn ) {
                moreBtn.setAttribute('title', (__lang.IDS_STORAGE_MORE_VIEW + __lang.IDS_STORAGE_MORE_VIEW_SHOW + __lang.IDS_BUTTON), 0);
                if ( 4 < mediaCnt ) {
                    moreBtn.style.display = 'block';
                    moreBtn.style.visibility = 'visible';
                    moreBtn.setAttribute('tabindex', __TabIndex++, 0);
                    moreBtn.onclick = function(){ displayMediaAllStorage(this, __lang, 'open'); /* ChangeButtonStyle(this); */ };
                } else {
                    moreBtn.setAttribute('disabled', 'disabled', 0);
                    moreBtn.style.display = 'none';
                    moreBtn.style.visibility = 'hidden';
                    moreBtn.onclick = function(){ displayMediaAllStorage(this, __lang, 'no_more'); /* ChangeButtonStyle(this); */ };
                }
                
                var moreBtnImg = document.getElementById('m-us-cert-manage-storage-more-btn-img');
                moreBtnImg.setAttribute('alt', (__lang.IDS_STORAGE_MORE_VIEW + __lang.IDS_STORAGE_MORE_VIEW_SHOW), 0);
                moreBtnImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_media_more_btn_open.png', 0);
            }

            DrawCertsListView(__lang);
            
            var certGetBtn = document.getElementById('m-us-cert-manage-sub-get-cert-btn');
            certGetBtn.setAttribute('value', __lang.IDS_CERT_GET, 0);
            certGetBtn.setAttribute('title', __lang.IDS_CERT_GET + __lang.IDS_BUTTON, 0);
            certGetBtn.setAttribute('tabindex', __TabIndex++, 0);
            certGetBtn.onclick = function(){ CallPFXImportFunc(__lang); }; // test ImportCert(this, __lang); };
            
            // test
			var fileSearchHidden = document.getElementById('m-us-cert-manage-file-search-hidden');
			fileSearchHidden.onchange = function(){ ImportPFX(this, __lang); };            
            
            var swInfoBtn = document.getElementById('m-us-cert-manage-sw-info-btn');
            swInfoBtn.setAttribute('value', __lang.IDS_SW_INFO, 0);
            swInfoBtn.setAttribute('title', __lang.IDS_SW_INFO + __lang.IDS_BUTTON, 0);
            swInfoBtn.setAttribute('tabindex', __TabIndex++, 0);
            swInfoBtn.onclick = function(){ ShowSoftwareVersion(this); };
            
            var noticeLbl = document.getElementById('m-us-cert-manage-lbl-notice');
            noticeLbl.appendChild(document.createTextNode(__lang.IDS_NOTICE));
            
            var closeImgBtn = document.getElementById('m-us-cert-manage-cls-img-btn');
            closeImgBtn.setAttribute('tabindex', __TabIndex++, 0);
            closeImgBtn.onclick = function(){ WindowExit(); };
            
            var closeImg = document.getElementById('m-us-cert-manage-cls-btn-img');
            closeImg.setAttribute('alt', __lang.IDS_CLOSE_CERT_MANAGEMENT_CLOSE, 0);
            closeImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_cert_close_btn.png', 0);

            return document.getElementById('m-us-div-cert-manage');
        }
        
        return WindowGenerate();
    };
    
    return function( Param ) {
        var win = ConstructScreen({
            type: Param.type,
            args: Param.args,
            onConfirm: Param.onConfirm,
            onCancel: Param.onCancel
        });
        
        var layerLevel = SANDBOX.uiLayerLevel;
        var overlay = SANDBOX.uiUtil().getOverlay(layerLevel/*, SANDBOX.browserName, SANDBOX.browserVersion*/);
        win.style.zIndex = layerLevel + 1;
        document.body.insertBefore( overlay, document.body.firstChild );  // for test
        
        /* for orientation */
        var perEv = window.onorientationchange;
        /* for orientation */
       
        function firstFocus() {
            var mediaList = SANDBOX.ESVS.Media.list.split('|');
            for (var i=0; i < mediaList.length; i++){
                var mediaName = mediaList[i];
                var mediaInfo = SANDBOX.CONST.medias[mediaName];
                if (mediaInfo == undefined || mediaInfo == null){
                    continue;
                }
                
                var button = document.getElementById('m-us-cert-manage-btn-' + mediaInfo.name);
                if (button != undefined && button != null){
                    button.focus();
                    break;
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
               
                var parent = win.parentNode;
                parent.removeChild(win);
                overlay.parentNode.removeChild(overlay);
                SANDBOX.uiLayerLevel -= 10;
                SANDBOX.ESVS.TabIndex -= 30;
            }
        };
    };
};
