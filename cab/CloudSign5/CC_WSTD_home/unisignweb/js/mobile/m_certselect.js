var __certselect = function( SANDBOX ) {
    var ConstructScreen = function( Param ) {
        var __UIElement = {
            __Layout: function() {
                var req;
    
                if ( window.XMLHttpRequest ) {
                    req = new window.XMLHttpRequest;
                } else {
                    req = new ActiveXObject('MSXML2.XMLHTTP.3.0');
                }
                
                var url = 'unisignweb/rsrc/layout/mobile/m_certselect.html?version=' + SANDBOX.ver;
                req.open('GET', SANDBOX.ESVS.SRCPath + url, false);
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
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/lang/certselect_' + SANDBOX.ESVS.Language + '.js?version=' + SANDBOX.ver, false);
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
        
        // TODO: setting default media
        //if (SANDBOX.ESVS.Media != null && SANDBOX.ESVS.Media.defaultdevice != null){
        //    __CurrentDevice = SANDBOX.uiUtil().getMediaDevice( SANDBOX.ESVS.Media.defaultdevice );
        //} else {
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
            
            // filtering by subject dn
            var AllowedDN = Param.args.dn;
            // filtering by subject dn
            
            // filtering by certificate policy
            var AllowedPolicies = null;
            
            if ( null != SANDBOX.ESVS.Policy ) {
                if( -1 != SANDBOX.ESVS.Policy.indexOf('|') ) {
                    AllowedPolicies = SANDBOX.ESVS.Policy.split('|');
                } else {
                    AllowedPolicies = new Array();
                    AllowedPolicies[ 0 ] = SANDBOX.ESVS.Policy;
                }
            }
            // filtering by certificate policy
            
            // filtering by organization name  
            var OrganizationNames = null;
            
            if ( null != SANDBOX.ESVS.Organization ) {
                if( -1 != SANDBOX.ESVS.Organization.indexOf('|') ) {
                    OrganizationNames = SANDBOX.ESVS.Organization.split('|');
                } else {
                    OrganizationNames = new Array();
                    OrganizationNames[ 0 ] = SANDBOX.ESVS.Organization;
                }
            }
            // filtering by organization name
            
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
                
                // filtering by subject dn
                if ( null != AllowedDN && ('DIGITAL_SIGNATURE_P1' == Param.type || 'DIGITAL_SIGNATURE_P7' == Param.type || 'DIGITAL_SIGNATURE_P7_EXT' == Param.type) ) {
                    if ( subject.toLowerCase() != AllowedDN.toLowerCase() ) {
                        continue;
                    }
                }
                // filtering by subject dn
                
                // filtering by certificate policy
                if ( null != SANDBOX.ESVS.Policy ) {
                    for(var y = 0; y < AllowedPolicies.length; y++) {
                        if ( AllowedPolicies[ y ] == oid ) {
                            break;
                        }
                    }
                    
                    if ( AllowedPolicies.length <= y ) {
                        continue;
                    }
                }
                // filtering by certificate policy
                
                // filtering by organization name
                if ( null != SANDBOX.ESVS.Organization && ('CERT_RENEWAL' == Param.type || 'CERT_REVOCATION' == Param.type || 'CERT_SOE' == Param.type) ) {
                    for(var y = 0; y < OrganizationNames.length; y++) {
                        if ( OrganizationNames[ y ].toLowerCase() == SANDBOX.certUtil().getO(subject).toLowerCase() ) {
                            break;
                        }
                    }
                    
                    if ( OrganizationNames.length <= y ) {
                        continue;
                    }
                }
                // filtering by organization name
                
                // filtering by certificate expiration date
                if ( !SANDBOX.ESVS.ShowExpiredCerts && ('DIGITAL_SIGNATURE_P1' == Param.type || 'DIGITAL_SIGNATURE_P7' == Param.type || 'DIGITAL_SIGNATURE_P7_EXT' == Param.type) ) {
                    if ( 2/*invalid*/ === SANDBOX.certUtil().getExpirationStateValue(expState) ) {
                        continue;
                    }
                }
                // filtering by certificate expiration date
                
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
										__CertsList.redrawList( viewList.list, viewList.list.length );
									} else {
										__CertsList.redrawList( null, 0 );
									}	
									return true;									
								}
								else
									return false;
							});
					
				}
			});        	
        }

        function ProposalCert( obj ) {
            if ( !obj ) {
                return false;
            }

            var __this = obj;

            var url = 'https://raadmin.crosscert.com/customer/tk/Main.jsp?';
                
            if ( 'firefox' == SANDBOX.browserName ) {
                window.open( url, 'crosscert_url', 'scrollbars=1' );
            } else {
                window.open( url );
            }
            
            __this.focus();
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
            
            __CertsList.redrawList( null, -1 );
                        
            if (SANDBOX.CONST.__PF_M_LS.device == device)	{            
	            var errCode = GetCerts( device, 0, __text, '' );
	            if ( 0 != errCode ) {
	                SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_COMMON_ERROR_GET_CERT, errCode);
	                __CertsList.redrawList( null, 0 );
	                return false;
	            }
            
	            var viewList = MakeCertViewList( textObj );
	            if ( viewList ) {
	                __CertsList.redrawList( viewList.list, viewList.list.length );
	            } else {
	                __CertsList.redrawList( null, 0 );
	            }
            
            	return true;
            }
            else if (SANDBOX.CONST.__PF_M_SS.device == device)	{ 
            	GetCertsNDrawList( device, 0, __text, '' );    
            }
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

        function ExtractCertFromPFX( b64P12, pw, textObj ) {  // plugin free function
            if ( !b64P12 || !pw || !textObj ) {
                return false;
            }

            var __text = textObj;

            var index = 0;
            var jsonCert = {};
            try {
                var rJson = SANDBOX.PFSH.SetP12OnMemory(b64P12, pw);
                index = rJson.index;
                SANDBOX.PFUC = jsonCert = rJson.aluc;
            } catch (e) {
                console.log('***** Plugin Free SetP12OnMemory error *****');  // for debug
                console.log('e.code : ', e.code , 'e.message : ', e.message, 'e.detail : ', e.detail);  // for debug

                switch (e.code) {
                    //case '115010' :   // SetP12OnMemory error code
                    case 10000000 :
                        if ( 0 <= (e.detail).indexOf('115010') ) {
                            SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_PW_ERROR_PASSWORD_IS_NOT_MATCHED);
                        } else {
                            SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_COMMON_ERROR_GET_CERT, e.detail);  
                        }
                        break;
                    //case 31080000 :   // SaveUserCert error code // original certificate is latest
                    //  SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_COMMON_ERROR_GET_CERT, e.code);
                    //  break;
                    default :
                        SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_COMMON_ERROR_GET_CERT, e.code);
                        break;
                }

                return false;
            }

            if ( SANDBOX.certsList ) {
                SANDBOX.certsList = null;
            }
            
            var listArr = new Array();
            var struct = new Object();
            var viewList = null;
            
            struct['index'] = index;
            struct['cert'] = jsonCert[index].signcert;
            listArr[0] = struct;
            SANDBOX.certsList = {list:listArr};
            
            viewList = MakeCertViewList( textObj );
            if ( viewList ) {
                __CertsList.redrawList( viewList.list, viewList.list.length );
                FillPWBox( pw );
                pw = '';
                
                return true;
            } else {
                SANDBOX.certsList = null;
                __CertsList.redrawList( null, -1 );
                ClearPWBox();
                pw = '';
                        
                return false;
            }
        }

        function GetCertFromPFX( index, pw, textObj ) {
            if ( null == pw || 0 >= pw.length || null == textObj ) {
                return false;
            }
            
            var __text = textObj;

            if ( SANDBOX.certsList ) {
                SANDBOX.certsList = null;
            }
            
            if ( 0 < index ) {
                var listArr = new Array();
                var struct = new Object();
                var viewList = null;
                
                struct['index'] = index;
                struct['cert'] = SANDBOX.plugin().GetUserSignCertFromCertList(index);
                listArr[0] = struct;
                SANDBOX.certsList = {list:listArr};
                
                viewList = MakeCertViewList( textObj );
                if ( viewList ) {
                    __CertsList.redrawList( viewList.list, viewList.list.length );
                    FillPWBox( pw );
                    pw = '';
                    
                    return true;
                } else {
                    // display error msg
                }
            } else {
                var errCode = SANDBOX.plugin().GetLastErrorCode();
                var errMsg = SANDBOX.plugin().GetLastErrorMessage();
                console.log('***** GetCertFromPFX *****');  // for debug
                console.log('Err Code : ', errCode, '\nErr Msg : ', errMsg);  // for debug
                        
                switch ( errCode ) {
                    case 43010000 :
                        SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_PW_ERROR_PASSWORD_IS_NOT_MATCHED);
                        break;
                        
                    default :
                        SANDBOX.uiUtil().errMsgBox(__text.IDS_MSGBOX_COMMON_ERROR_GET_CERT, errCode);
                        break;
                }
            }

            if ( SANDBOX.certsList ) {
                SANDBOX.certsList = null;
            }
            
            __CertsList.redrawList( null, -1 );
            ClearPWBox();
            pw = '';
                    
            return false;
        }
        
        function GetCertFromPFXByPath( pfxPath, pw, textObj ) {
            if ( null == pfxPath || 0 >= pfxPath.length || null == pw || 0 >= pw.length || null == textObj ) {
                return false;
            }
            
            var __text = textObj;
            var rv = false;
            
            if ( SANDBOX.plugin().valid ) {
                var index = SANDBOX.plugin().GetPfxCertList(pfxPath, pw);
                rv = GetCertFromPFX(index, pw, __text);
            } else {
                SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_PLUGIN_ERROR_UNLOAD);
            }
            pw = '';
            
            return rv;
        }
        
        function GetCertFromPFXByB64Binary( pfxBinary, pw, textObj ) {
            if ( null == pfxBinary || 0 >= pfxBinary.length || null == pw || 0 >= pw.length || null == textObj ) {
                return false;
            }
            
            var __text = textObj;
            var rv = false;
            
            if ( (0x01 & (0xFF & SANDBOX.ESVS.Mode)) && SANDBOX.CONST.__PF_M_LS.device !== __CurrentDevice ) {
                if ( SANDBOX.plugin().valid ) {
                    var index = SANDBOX.plugin().GetPfxCertListString(pfxBinary, pw);
                        rv = GetCertFromPFX(index, pw, __text);
                } else {
                    SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_PLUGIN_ERROR_UNLOAD);
                }
            } else {  //if ( 0x02 & (0xFF & SANDBOX.ESVS.Mode) )
                rv = ExtractCertFromPFX(pfxBinary, pw, textObj);
            }
            pw = '';
            
            return rv;
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
        
        function CallFileSearchFunc( textObj ) {
            if ( null == textObj ) {
                return false;
            }

            var __text = textObj;
            
            var fileSearchHidden = document.getElementById('m-us-file-search-hidden');
            
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
                fileSearchHidden.setAttribute('id', 'm-us-file-search-hidden', 0);
                fileSearchHidden.className = 'm-us-layout-file-search-hidden';
                fileSearchHidden.onchange = onchangeFunc;
                
                parent.appendChild(fileSearchHidden);
            }
            
            fileSearchHidden.click();
            return true;
        }
        
        function SearchPFX( obj, textObj ) {
            if ( !obj || !textObj ) {
                return false;
            }
            
            var __this = obj;
            var __text = textObj;
            
            var fileFullPath = null;
            var fileB64Bin = null;
            
            var confirmBtn = document.getElementById('m-us-confirm-btn');
            var certSearchBtn = document.getElementById('m-us-cert-search-btn');
            
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
                         setTimeout(function(){ certSearchBtn.focus(); }, 10);
                         return false;
                     }
                 } else {
                     //SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_FILE_ERROR_READ);
                     setTimeout(function(){ certSearchBtn.focus(); }, 10);
                     return false;
                 }
            } else {
                if ( 'msie' == SANDBOX.browserName && (8 === parseInt(SANDBOX.browserVersion)) ) {  // IE 8.0
                    var mainwin = document.getElementById('m-us-div-cert-select');
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
                        setTimeout(function(){ certSearchBtn.focus(); }, 10);
                        return false;
                    }
                } else {
                    fileFullPath = __this.value;
                    console.log('file full path : ', fileFullPath);  // for debug
                }
                
                if ( false == IsPFX( fileFullPath, __text ) ) {
                    setTimeout(function(){ certSearchBtn.focus(); }, 10);
                    return false;
                }
            }
            
            var UI = SANDBOX.loadUI('password');
            Dialog = UI({
                type: null,
                args: null,
                onConfirm: function( pw ) {
                    var rv = false; 
                    
                    if ( null != fileFullPath ) {
                        rv = GetCertFromPFXByPath(fileFullPath, pw, __text);
                    } else {  // null != fileB64Bin
                        rv = GetCertFromPFXByB64Binary(fileB64Bin, pw, __text);
                    }

                    pw = '';
                    Dialog.dispose();
                    
                    if ( true === rv ) {
                        setTimeout(function(){ confirmBtn.focus(); }, 10);
                    } else {
                        setTimeout(function(){ certSearchBtn.focus(); }, 10);
                    }
                },
                onCancel: function() {
                    Dialog.dispose();
                    setTimeout(function(){ certSearchBtn.focus(); }, 10);
                }
            });
            Dialog.show();
            
            return true;
        }
        
        function WindowConfirm( textObj, index, password ) {
            if ( !textObj || 0 > index || !password || 1 > password.length ) {
                return false;
            }
            
            var __text = textObj;
                
            if ( 'DIGITAL_SIGNATURE_P7' === Param.type ) {
				var theCert = SANDBOX.PFUC[index].signcert;				
				if ( !theCert || 0 >= theCert.length ) {
					SANDBOX.uiUtil().errMsgBox( __text.IDS_MSGBOX_SIGN_ERROR, -1 );
					return false;
				}
						
				var theCertAttrs = SANDBOX.certUtil().getTheCertAttributes( theCert, 'Base64' );
						//
						            	
                Param.onConfirm(__text.IDS_MSGBOX_SIGN_ERROR, theCertAttrs, index, password, __CurrentDevice);
            } 
			else if ( 'CERT_RENEWAL' == Param.type ) {				
				var theCert = SANDBOX.PFUC[index].signcert;	
				if ( !theCert || 0 >= theCert.length ) {
					SANDBOX.uiUtil().errMsgBox( __text.IDS_MSGBOX_RENEW_ERROR, -1 );
					return false;
				}					

				SANDBOX.usWebToolkit.x509Certificate.parser( theCert, 'Base64' );
				
				var theExpDate = SANDBOX.usWebToolkit.x509Certificate.getNotAfter();
				if ( !theExpDate || 0 >= theExpDate.length ) {
					SANDBOX.uiUtil().errMsgBox( __text.IDS_MSGBOX_RENEW_ERROR, -2 );
					return false;
				}
				
				Param.onConfirm( theExpDate, __text.IDS_CONFIRMBOX_CERT_RENEWAL, __CurrentDevice, __CurrentDrive, index, password );
							
			}             
            else if ( 'CERT_REVOCATION' === Param.type ) {
                Param.onConfirm(__text.IDS_CONFIRMBOX_CERT_REVOCATION, index, password, __CurrentDevice, __CurrentDrive);
            } else if ( 'VID_VERIFICATION' === Param.type ) {
                Param.onConfirm(index, password, __text.IDS_MSGBOX_VID_SUCCESS_VERIFICATION, __text.IDS_MSGBOX_VID_ERROR_VERIFICATION, 'PFS');
            } else {
                Param.onConfirm();
            }

            password = '';
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
				listtype	: 'mobilecertselect',
                bodyid 		: 'm-us-div-list-inner',
				rowid 		: 'm-us-mobile-cert-list-row',
				imgid   	: 'm-us-mobile-cert-status-img',
				eleid   	: 'm-us-mobile-cert-data-element',
				
				confirm 	: function( index, password ) {
					WindowConfirm( __text, index, password );
				},
				cancel 		: function() {
					WindowExit();
				}
            });
                        
            if ( viewList ) {
                __CertsList.drawList( viewList.list, viewList.list.length, __TabIndex++ );
            } else {
                __CertsList.drawList( null, 0, __TabIndex++ );
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
			
            for ( var i = 0; i < mediaList.length; i++) {
                var mediaName = mediaList[i];
                var mediaInfo = SANDBOX.CONST.medias[mediaName];
				
                if ( mediaInfo == undefined || mediaInfo == null ) {
                    continue;
                }
                
                var button = document.getElementById('m-us-btn-' + mediaInfo.name);
                if ( button != undefined && button != null ) {
                    if ( button.className != 'm-us-layout-storage-btn-none' ) {
                        if ( __this === button ) {
                            button.className = 'm-us-layout-storage-btn-on';                          
                            button.focus();  // IE 8?�서 버그 발생 - ?�인 ?�요 
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
//              <li>
//                  <button id="m-us-btn-harddisk" class="m-us-layout-storage-btn-off" type="button">
//                      <span class="m-us-drive-select"><img id="m-us-img-drive" /></span>
//                      <span class="m-us-img-storage"><img id="m-us-img-harddisk" /></span>
//                      <span id="m-us-lbl-harddisk" class="m-us-layout-lbl-storage"></span>    
//                  </button>
//              </li>
                var ul = document.getElementById('m-us-storage-btn-list');
                
                var li = document.createElement('li');
                li.setAttribute('id', "m-us-storage-btn-li-"+deviceBtnInfo.name, 0);
                li.setAttribute('mediaIndex', deviceBtnInfo.mediaIndex, 0);
                if ( 5 == deviceBtnInfo.mediaIndex ) {
                    li.className = 'line-first';
                }
                if ('hidden' === deviceBtnInfo.visibility){
                    li.style.display = 'none';
                    li.style.visibility = 'hidden';
                }else{
                    li.style.display = 'block';
                    li.style.visibility = 'visible';
                }
                
                var button = document.createElement('button');
                button.setAttribute('type', 'button', 0);
                button.setAttribute('id', 'm-us-btn-'+deviceBtnInfo.name, 0);
                button.setAttribute('title', deviceBtnInfo.label, 0);
                button.setAttribute('tabindex', deviceBtnInfo.tabIndex, 0);         
                if ( deviceBtnInfo.disabled ) {    /* plugin free mode */             
                    button.onclick = function(){ /* SANDBOX.uiUtil().msgBox( __lang.IDS_MSGBOX_NOT_SUPPORTED_MEDIA ); */ };
                    button.className = 'm-us-layout-storage-btn-none';
                } else {
                    button.onclick = deviceBtnInfo.onclick;
                    if ( deviceBtnInfo.device === __CurrentDevice ) {
                        button.className = 'm-us-layout-storage-btn-on';
                        button.focus();  // IE 8?�서 버그 발생 - ?�인 ?�요
                    } else {
                        button.className = 'm-us-layout-storage-btn-off';
                    }
                }
                li.appendChild(button);
                
                if ('harddisk' !== deviceBtnInfo.name && 'webstorage' !== deviceBtnInfo.name){
                    var plusImgSpan = document.createElement('span');
                    plusImgSpan.className = 'm-us-drive-select';
                    button.appendChild(plusImgSpan);
                }
                
                var imgSpan = document.createElement('span');
                imgSpan.className = 'm-us-img-storage';
                var btnImg = document.createElement('img');
                btnImg.setAttribute('id', 'm-us-img-'+deviceBtnInfo.name, 0);
                btnImg.setAttribute('alt', deviceBtnInfo.label, 0);
                if ( deviceBtnInfo.disabled ) {    /* plugin free mode */             
                    btnImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_media_'+deviceBtnInfo.name+'_d.png', 0);
                } else {
                    btnImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_media_'+deviceBtnInfo.name+'.png', 0);
                }
                imgSpan.appendChild(btnImg);
                button.appendChild(imgSpan);

                var lblSpan = document.createElement('span');
                lblSpan.setAttribute('id', 'm-us-lbl-'+deviceBtnInfo.name, 0);
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

            if ( showType == 'no_more' ) {
                SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_NOT_MORE_MEDIA);
            } else {
                var div = document.getElementById('m-us-storage-wrap');
				
                if (showType == 'open') {
                    div.className = "m-us-layout-storage-more-wrap"; 
                    
                    var moreBtn = document.getElementById('m-us-storage-more-btn');
                    moreBtn.setAttribute('title', (__text.IDS_STORAGE_MORE_VIEW + __text.IDS_STORAGE_MORE_VIEW_HIDDEN + __text.IDS_BUTTON), 0);
                    moreBtn.onclick = function(){ displayMediaAllStorage(this, __text, 'close'); /* ChangeButtonStyle(this); */ };
                    
                    var moreBtnImg = document.getElementById('m-us-storage-more-btn-img');
                    moreBtnImg.setAttribute('alt', (__text.IDS_STORAGE_MORE_VIEW + __text.IDS_STORAGE_MORE_VIEW_HIDDEN), 0);
                    moreBtnImg.setAttribute('src', SANDBOX.ESVS.SRCPath + "unisignweb/rsrc/img/mobile/m_media_more_btn_close.png", 0);
                } else {
                    div.className = "m-us-layout-storage-wrap"; 

                    var moreBtn = document.getElementById('m-us-storage-more-btn');
                    moreBtn.setAttribute('title', (__text.IDS_STORAGE_MORE_VIEW + __text.IDS_STORAGE_MORE_VIEW_SHOW + __text.IDS_BUTTON), 0);
                    moreBtn.onclick = function(){ displayMediaAllStorage(this, __text, 'open'); /* ChangeButtonStyle(this); */ };
                    
                    var moreBtnImg = document.getElementById('m-us-storage-more-btn-img');
                    moreBtnImg.setAttribute('alt', (__text.IDS_STORAGE_MORE_VIEW + __text.IDS_STORAGE_MORE_VIEW_SHOW + __text.IDS_BUTTON), 0);
                    moreBtnImg.setAttribute('src', SANDBOX.ESVS.SRCPath + "unisignweb/rsrc/img/mobile/m_media_more_btn_open.png", 0);
                }
                
                var mediaList = SANDBOX.ESVS.Media.list.split('|');
                for ( var i = 0; i < mediaList.length; i++ ) {
                    var mediaName = mediaList[i];
                    var mediaInfo = SANDBOX.CONST.medias[mediaName];
                    if ( mediaInfo == undefined || mediaInfo == null ) {
                        continue;
                    }
                    
                    var li = document.getElementById("m-us-storage-btn-li-" + mediaInfo.name);
                    if ( li != undefined && li != null ) {
                        var mediaIndex = li.getAttribute('mediaIndex');
                        if ( showType == 'open' ) {
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
                            var button = document.getElementById('m-us-btn-'+mediaInfo.name);
                            button.focus();  // IE 8
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

            var titleLbl = document.getElementById('m-us-lbl-title');
            titleLbl.appendChild(document.createTextNode(__lang.IDS_CERT_SELECTION/* + ' ' + __lang.IDS_CERT_SELECTION_PURPOSE_SIGN*/));
            
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
                    }else{
                        mediaInfo.visibility = 'visible';
                    }
                    
                    if ( displayMediaButton( mediaInfo ) ) {
                        __TabIndex++; 
                        mediaCnt++;
                    };
                }
            }
            
            var moreBtn = document.getElementById('m-us-storage-more-btn');
            if ( null != moreBtn && undefined != moreBtn ) {
                moreBtn.setAttribute('title', (__lang.IDS_STORAGE_MORE_VIEW + __lang.IDS_STORAGE_MORE_VIEW_SHOW + __lang.IDS_BUTTON), 0);
                if ( 4 < mediaCnt ) {
                    moreBtn.style.display = 'block';
                    moreBtn.style.visibility = 'visible';
                    moreBtn.setAttribute('tabindex', __TabIndex++, 0);
                    moreBtn.onclick = function() { displayMediaAllStorage(this, __lang, 'open'); /* ChangeButtonStyle(this); */ };
                } else {
                    moreBtn.setAttribute('disabled', 'disabled', 0);
                    moreBtn.style.display = 'none';
                    moreBtn.style.visibility = 'hidden';
                    moreBtn.onclick = function() { displayMediaAllStorage(this, __lang, 'no_more'); /* ChangeButtonStyle(this); */ };
                }
                
                var moreBtnImg = document.getElementById('m-us-storage-more-btn-img');
                moreBtnImg.setAttribute('alt', (__lang.IDS_STORAGE_MORE_VIEW + __lang.IDS_STORAGE_MORE_VIEW_SHOW), 0);
                moreBtnImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_media_more_btn_open.png', 0);
            }
         
            DrawCertsListView(__lang);
            
            var fileSearchHidden = document.getElementById('m-us-file-search-hidden');
            fileSearchHidden.onchange = function(){ SearchPFX(this, __lang); };
            
            var certSearchBtn = document.getElementById('m-us-cert-search-btn');
            certSearchBtn.setAttribute('value', __lang.IDS_CERT_SEARCH, 0);
            certSearchBtn.setAttribute('title', __lang.IDS_CERT_SEARCH + __lang.IDS_BUTTON, 0);
			certSearchBtn.setAttribute('tabindex', __TabIndex++, 0);
            certSearchBtn.onclick = function(){ CallFileSearchFunc(__lang); };
            // temporary codes - It should be removed
            certSearchBtn.readOnly = true;
            certSearchBtn.disabled = true;
            // temporary codes - It should be removed

            var certProposalBtn = document.getElementById('m-us-cert-proposal-btn');
            certProposalBtn.setAttribute('value', __lang.IDS_CERT_PROPOSAL, 0);
            certProposalBtn.setAttribute('title', __lang.IDS_CERT_PROPOSAL + __lang.IDS_BUTTON, 0);
			certProposalBtn.setAttribute('tabindex', __TabIndex++, 0);
            certProposalBtn.onclick = function(){ ProposalCert(this); };
      
            var noticeLbl = document.getElementById('m-us-lbl-notice');
            noticeLbl.appendChild(document.createTextNode(__lang.IDS_NOTICE));
            
            var closeImgBtn = document.getElementById('m-us-cls-img-btn');
            closeImgBtn.setAttribute('tabindex', __TabIndex++, 0);
            closeImgBtn.onclick = function(){ WindowExit(); };
            
            var closeImg = document.getElementById('m-us-cls-btn-img');
            closeImg.setAttribute('alt', __lang.IDS_CLOSE_CERT_SELECTION_CLOSE, 0);
            closeImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_cert_close_btn.png', 0);
                
            return document.getElementById('m-us-div-cert-select');
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
                
                var button = document.getElementById('m-us-btn-' + mediaInfo.name);
                if (button != undefined && button != null){
                    button.focus();  // IE 8
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
