var __certview = function( SANDBOX ) {
    var ConstructScreen = function( Param ) {   
        var __UIElement = {
            __Layout: function() {
                var req;
    
                if ( window.XMLHttpRequest ) {
                    req = new window.XMLHttpRequest;
                } else {
                    req = new ActiveXObject('MSXML2.XMLHTTP.3.0');
                }
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/layout/mobile/m_certview.html?version=' + SANDBOX.ver, false);
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
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/lang/certview_' + SANDBOX.ESVS.Language + '.js?version=' + SANDBOX.ver, false);
                req.send(null);
                
                return req.responseText;
            }
        };
        
        var __ListUI = null;
        var __DetailList = null;
        var __ViewList = null;
        var __TabIndex = SANDBOX.ESVS.TabIndex;

        var console = window.console || { log: function() {} };  // for debug
        
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
            // 2013.11.18
            __DetailList.restoreOnMouseEvent();
            // 2013.11.18
            
            Param.onConfirm();
        }
        
        function WindowExit() {
            // 2013.11.18
            __DetailList.restoreOnMouseEvent();
            // 2013.11.18
            
            Param.onCancel();
        }
        
        function ViewContent( index ) {
            var _index = parseInt(index);
            var simpleView = document.getElementById('m-us-view-simple');
            var detailView = document.getElementById('m-us-view-detail');
            var cpsBtn = document.getElementById('m-us-view-cert-cps-btn');
            var confirmBtn = document.getElementById('m-us-view-cert-confirm-btn');
            var closeBtn = document.getElementById('m-us-view-cls-img-btn');
            
            if ( 0 === _index ) {  // simple view
                simpleView.style.display = 'block';
                detailView.style.display = 'none';
                cpsBtn.style.display = 'inline';
                
                __DetailList.clearList();
                
                cpsBtn.setAttribute('tabindex', __TabIndex + 3, 0);
                confirmBtn.setAttribute('tabindex', __TabIndex + 4, 0);
                closeBtn.setAttribute('tabindex', __TabIndex + 5, 0);
            } else if ( 1 === _index ) {  // detail view
                simpleView.style.display = 'none';
                detailView.style.display = 'block';
                cpsBtn.style.display = 'none';
                
                __DetailList.redrawList(__ViewList.list, __ViewList.list.length);
                
                cpsBtn.removeAttribute('tabindex');
                confirmBtn.setAttribute('tabindex', __TabIndex + 4, 0);
                closeBtn.setAttribute('tabindex', __TabIndex + 5, 0);
            }
        }
        
        function RollOver( els, obj ) {
            if( 0 == els.length || !obj ) {
                return;
            }
            
            var _els = els;
            var _obj = obj;
            
            for( n in _els ) {
                if( typeof _els[n] == "object" ) {
                    if( _els[n] == _obj ) {
                        var ocss = _els[n].className;
                        _els[n].className = ocss + " " + _els[n].getAttribute("overcss");
                    } else {
                        _els[n].className = _els[n].getAttribute("outcss");
                    }
                }
            }
        }
        
        function TabController( e, obj ) {
            var evt = e || window.event;
            var target = evt.target || evt.srcElement;
            //var outer = obj.getElementsByTagName('li');
            //var tabs = obj.getElementsByTagName('div');
            var tabs = obj.getElementsByTagName('a');
            var simpleViewTab = document.getElementById('m-us-view-tab-simple');
            var detailViewTab = document.getElementById('m-us-view-tab-detail');
            
            for( n in tabs ) {
                if( target == tabs[n] ) {
                    if ( isNaN(n) ) {  // for IE
                        if ( n == 'm-us-view-tab-simple' ) {
                            n = 0;
                        } else {  //m-us-view-tab-detail
                            n = 1;
                        }
                    }

                    if ( n == 0 ) {
                        simpleViewTab.className = 'm-us-view-tab-tag active';
                        detailViewTab.className = 'm-us-view-tab-tag';
                    } else {
                        simpleViewTab.className = 'm-us-view-tab-tag';
                        detailViewTab.className = 'm-us-view-tab-tag active';
                    }
                    
                    ViewContent( n );
                    //RollOver( outer, outer[n] );
                    break;
                }
            }
        }
        
        function PressEnterOnTab( e, obj ) {
            if ( !e || !obj ) {
                return false;
            }
            
            var evt = e || window.event;
            var keyCode = evt.which || evt.keyCode;
            
            if ( 13 == keyCode ) {
                TabController(e, obj);
            }
            
            return true;
        }
        
        function MakeDetailViewList( fieldList ) {
            
            var viewList = null;
            
            var _fieldList = fieldList;
            var _fieldListCnt = fieldList.length;
            
            var certVer = SANDBOX.usWebToolkit.x509Certificate.getVersion();
            var certSerialNumber = SANDBOX.usWebToolkit.x509Certificate.getSerialNumber();
            var certSignAlgo = SANDBOX.usWebToolkit.x509Certificate.getSignAlgo();
            var certIssuer = SANDBOX.usWebToolkit.x509Certificate.getIssuerName();
            var certValidateFrom = SANDBOX.certUtil().getLocalDateNTime(SANDBOX.usWebToolkit.x509Certificate.getNotBefore());
            var certValidateTo = SANDBOX.certUtil().getLocalDateNTime(SANDBOX.usWebToolkit.x509Certificate.getNotAfter());
            var certSubject = SANDBOX.usWebToolkit.x509Certificate.getSubjectName();
            var certPublicKey = SANDBOX.usWebToolkit.x509Certificate.getPublickey();
            var certAuthorityKeyIndentifier = SANDBOX.usWebToolkit.x509Certificate.getAuthorityKeyIndentifier();
            var certSubjectKeyIndentifier = SANDBOX.usWebToolkit.x509Certificate.getSubjectKeyIdentifier();
            var certKeyUsage = SANDBOX.usWebToolkit.x509Certificate.getKeyUsage();
            var certPolicy = SANDBOX.usWebToolkit.x509Certificate.getCertificatePoliciesOid();
            var certSubjectAltName = SANDBOX.usWebToolkit.x509Certificate.getSubjectAltName();
            var certAuthorityInfoAccess = SANDBOX.usWebToolkit.x509Certificate.getAuthorityInfoAccess();
            var certCRLDistributionPoints = SANDBOX.usWebToolkit.x509Certificate.getcRLDistributionPoints();
            var certCPS = SANDBOX.usWebToolkit.x509Certificate.getCertificatePoliciesCPS();
            var certPurpose = SANDBOX.usWebToolkit.x509Certificate.getCertificatePoliciesUserNotice();
            var certSignature = SANDBOX.usWebToolkit.x509Certificate.getSignature();
            
            var valueListArr = new Array();
            valueListArr[ 0 ] = certVer;
            valueListArr[ 1 ] = certSerialNumber;
            valueListArr[ 2 ] = certSignAlgo;
            valueListArr[ 3 ] = certIssuer;
            valueListArr[ 4 ] = certValidateFrom;
            valueListArr[ 5 ] = certValidateTo;
            valueListArr[ 6 ] = certSubject;
            valueListArr[ 7 ] = certPublicKey;
            valueListArr[ 8 ] = certAuthorityKeyIndentifier;
            valueListArr[ 9 ] = certSubjectKeyIndentifier;
            valueListArr[ 10 ] = certKeyUsage;
            valueListArr[ 11 ] = certPolicy;
            valueListArr[ 12 ] = certSubjectAltName;
            valueListArr[ 13 ] = certAuthorityInfoAccess;
            valueListArr[ 14 ] = certCRLDistributionPoints;
            valueListArr[ 15 ] = certCPS;
            valueListArr[ 16 ] = certPurpose;
            valueListArr[ 17 ] = certSignature;
            
            var listArr = new Array();
            for(var i = 0; i < valueListArr.length; i++) {
                //var struct = new Object();
                var struct = new Array();
                struct[0/*field*/] = _fieldList[ i ].field;  // cert type
                struct[1/*value*/] = valueListArr[ i ];  // cert value
                listArr[i] = struct;
            }
            
            viewList = {list:listArr};
            return viewList;
        }
        
        function DrawDetailListTitle( titleList, fieldList ) {
            
            __ViewList = MakeDetailViewList( fieldList );
            
            __ListUI = SANDBOX.loadUI('gridlist');
            __DetailList = __ListUI({
                type:           'detailslist',
                tblid:          'm-us-view-tbl-list',
                tbltitleid:     'm-us-view-tbl-list-th',
                titlelistid:    'm-us-view-grid-head-div',
                titlerowid:     'm-us-view-list-title-row',
                titleelementid: 'm-us-view-list-title-element',
                titledividerid: null,
                titlelistcn:    'm-us-layout-view-grid-head-div',
                titlerowcn:     'm-us-layout-view-grid-head-row',
                titleelementcn: 'm-us-layout-view-grid-row-title-element',
                titledividercn: null,
                tblbodyid:      'm-us-view-tbl-list-td',
                datalistid:     'm-us-view-grid-body-div',
                datarowid:      'm-us-view-list-body-row',
                dataelementid:  'm-us-view-list-data-element',
                datalistcn:     'm-us-layout-view-grid-body-div',
                datarowcn:      'm-us-layout-view-grid-body-row',
                dataelementcn:  'm-us-layout-view-grid-row-data-element',
                dataselectcn:   'm-us-layout-view-grid-row-data-selected-element',
                
                textboxid:      'm-us-view-detail-text-box'
            });
            
            __DetailList.drawTitle( titleList, titleList.length, __TabIndex + 3, false );
        }
        
        function DrawDetailListView( titleList, fieldList ) {
            
            var viewList = MakeDetailViewList( fieldList );
            
            __ListUI = SANDBOX.loadUI('gridlist');
            __DetailList = __ListUI({
                type:           'detailslist',
                tblid:          'm-us-view-tbl-list',
                tbltitleid:     'm-us-view-tbl-list-th',
                titlelistid:    'm-us-view-grid-head-div',
                titlerowid:     'm-us-view-list-title-row',
                titleelementid: 'm-us-view-list-title-element',
                titlelistcn:    'm-us-layout-view-grid-head-div',
                titlerowcn:     'm-us-layout-view-grid-head-row',
                titleelementcn: 'm-us-layout-view-grid-row-title-element',
                tblbodyid:      'm-us-view-tbl-list-td',
                datalistid:     'm-us-view-grid-body-div',
                datarowid:      'm-us-view-list-body-row',
                dataelementid:  'm-us-view-list-data-element',
                datalistcn:     'm-us-layout-view-grid-body-div',
                datarowcn:      'm-us-layout-view-grid-body-row',
                dataelementcn:  'm-us-layout-view-grid-row-data-element',
                dataselectcn:   'm-us-layout-view-grid-row-data-selected-element',
                
                textboxid:      'm-us-view-detail-text-box'
            });
            
            __DetailList.drawList( titleList, titleList.length, viewList.list, viewList.list.length, __TabIndex + 3 );
        }
        
        function PutUserCertInfo( certType, certIdx, userCert, textobj ) {
            if ( !certType || 0 >= certIdx || !userCert || !textobj ) {
                return false;  // error code
            }
            
            var certStatusImg = document.getElementById('m-us-view-cert-status-img');
            var certStatusMsg = document.getElementById('m-us-view-cert-status-msg');
            
            var result = -1;
            var errCode = 0;
            var errMsg = null;
            
            if (0x02 & (0xFF & SANDBOX.ESVS.Mode)) {
                var caCerts = null;
                try {
                    // verify certificate
                    var caStore = SANDBOX.usWebToolkit.pki.createCaStore();
                    
                    caCerts = SANDBOX.PFSH.GetCACerts();
                    for (var key in caCerts){
                        caCert = caCerts[key];
                        caStore.addCertificate(SANDBOX.usWebToolkit.pki.certificateFromBase64(caCert)); 
                    }

                    var certificate = SANDBOX.usWebToolkit.pki.certificateFromBase64(userCert);
                    SANDBOX.usWebToolkit.pki.verifyCertificateChain(caStore, certificate,
                            function(vfd, depth, chain) {
                                if(vfd === true) {
                                    result = 0;
                                    console.log('*** [Plugin Free] VerifyCertBasicAndChain return Verify Success!(depth : '+depth+')');
                                }else{
                                    result = -1;
                                    console.log('*** [Plugin Free] VerifyCertBasicAndChain return Verify Fail!(depth : '+depth+', errMessage : '+chain+')');
                                    if (chain != null && chain != undefined && chain.indexOf("Certificate is not valid yet or has expired") >= 0){
                                        errCode = 3005;
                                    }else{
                                        errCode = -1;
                                    }
                                    errMsg = chain;
                                }            
                          });
                    
                } catch( e ) {
                    console.log('***** [Plugin Free] VerifyCertBasicAndChain exception *****');  // for debug
                    errCode = e.code;
                    errMsg = e.message;
                    console.log('e.code : ', e.code , 'e.message : ', e.message, 'e.detail : ', e.detail);  // for debug
                    SANDBOX.uiUtil().errMsgBox(e.message, e.code);
                    // return error
                }
            }
            
            if ( 0 === result ) {  // valid status
                certStatusImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_cert_valid_small.png', 0);
                certStatusMsg.appendChild(document.createTextNode(textobj.IDS_CERT_STATUS_VALID));
            } else {  // invalid status - need detail error codes 
                certStatusImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_cert_invalid_small.png', 0);
                switch ( errCode ) {
                    case 3005 :
                        certStatusMsg.appendChild(document.createTextNode(textobj.IDS_CERT_STATUS_EXPIRED));
                        break;
                    default:
                        certStatusMsg.appendChild(document.createTextNode(textobj.IDS_CERT_STATUS_INVALID));
                        break;
                }
            }
            
            SANDBOX.usWebToolkit.x509Certificate.parser( userCert, certType );
            
            var subjectCN = document.getElementById('m-us-view-cert-subject-name-data');
            subjectCN.appendChild(document.createTextNode(SANDBOX.certUtil().getCN(SANDBOX.usWebToolkit.x509Certificate.getSubjectName())));
            
            var issuerCN = document.getElementById('m-us-view-cert-issuer-name-data');
            issuerCN.appendChild(document.createTextNode(SANDBOX.certUtil().getCN(SANDBOX.usWebToolkit.x509Certificate.getIssuerName())));
            
            var from = document.getElementById('m-us-view-cert-validity-date-from');
            from.appendChild(document.createTextNode(SANDBOX.certUtil().getLocalDate(SANDBOX.usWebToolkit.x509Certificate.getNotBefore())));
            
            var to = document.getElementById('m-us-view-cert-validity-date-to');
            to.appendChild(document.createTextNode(SANDBOX.certUtil().getLocalDate(SANDBOX.usWebToolkit.x509Certificate.getNotAfter())));
            
            var certPurpose = document.getElementById('m-us-view-cert-purpose');
            var certPurposeText = SANDBOX.usWebToolkit.x509Certificate.getCertificatePoliciesUserNotice();
            if ( null != certPurposeText ) {
                certPurpose.appendChild(document.createTextNode(certPurposeText));
            }
            
            var cpsBtn = document.getElementById('m-us-view-cert-cps-btn');
            cpsBtn.onclick = function(){ 
                var url = SANDBOX.usWebToolkit.x509Certificate.getCertificatePoliciesCPS();
                
                if ( 'firefox' == SANDBOX.browserName ) {
                    window.open( url, 'cps_url', 'scrollbars=1' );
                } else {
                    window.open( url );
                }
            
                this.focus();
            };
            
            return true;
        }
        
        function WindowGenerate() {
            var __form = eval(__UIElement.__Layout);
            var __lang = eval((eval(__UIElement.__Lang))());
            
            var certType = Param.args.type;
            var certIdx = Param.args.idx;
            var userCert = Param.args.cert;
            
            // should be changed asap
            UILoad( __form() );
            // should be changed asap
            
            var titleLbl = document.getElementById('m-us-view-lbl-title');
            titleLbl.appendChild(document.createTextNode(__lang.IDS_CERT_VIEW));
            
            var tab = document.getElementById('m-us-view-tab');
            tab.onclick = function(e){ TabController(e?e:event, this); };
            tab.onkeydown = function(e){ PressEnterOnTab(e?e:event, this); };
            
            var simpleViewTab = document.getElementById('m-us-view-tab-simple');
            simpleViewTab.setAttribute('tabindex', __TabIndex, 0);
            simpleViewTab.appendChild(document.createTextNode(__lang.IDS_CERT_SIMPLE_VIEW));
            
            var simpleView = document.getElementById('m-us-view-simple');
            simpleView.setAttribute('tabindex', __TabIndex + 1, 0);
            
            var detailViewTab = document.getElementById('m-us-view-tab-detail');
            detailViewTab.appendChild(document.createTextNode(__lang.IDS_CERT_DETAIL_VIEW));
            detailViewTab.setAttribute('tabindex', __TabIndex + 2, 0);
                
            var certInfoMenu = document.getElementById('m-us-view-cert-info');
            certInfoMenu.appendChild(document.createTextNode(__lang.IDS_CERT_INFO));
            
            var subjectNameMenu = document.getElementById('m-us-view-cert-subject-name');
            subjectNameMenu.appendChild(document.createTextNode(__lang.IDS_CERT_SUBJECT_NAME));
            
            var issuerNameMenu = document.getElementById('m-us-view-cert-issuer-name');
            issuerNameMenu.appendChild(document.createTextNode(__lang.IDS_CERT_ISSUER_NAME));
            
            var validityDateMenu = document.getElementById('m-us-view-cert-validity-date');
            validityDateMenu.appendChild(document.createTextNode(__lang.IDS_CERT_VALIDITY_DATE));
        
            var cpsBtn = document.getElementById('m-us-view-cert-cps-btn');
            cpsBtn.setAttribute('value', __lang.IDS_CERT_SUPPLEMENT_INFO, 0);
            cpsBtn.setAttribute('title', __lang.IDS_CERT_SUPPLEMENT_INFO + __lang.IDS_BUTTON, 0);
            cpsBtn.style.display = 'none';
            
            var confirmBtn = document.getElementById('m-us-view-cert-confirm-btn');
            confirmBtn.setAttribute('value', __lang.IDS_CERT_CONFIRM, 0);
            confirmBtn.setAttribute('title', __lang.IDS_CERT_CONFIRM + __lang.IDS_BUTTON, 0);
            confirmBtn.onclick = function(){ WindowExit(); };
            
            var closeBtn = document.getElementById('m-us-view-cls-img-btn');
            closeBtn.setAttribute('alt', __lang.IDS_CERT_VIEW_CLOSE, 0);
            closeBtn.onclick = function(){ WindowExit(); };
            
            var closeImg = document.getElementById('m-us-view-cls-btn-img');
            closeImg.setAttribute('alt', __lang.IDS_CERT_VIEW_CLOSE, 0);
            closeImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_x-btn.png', 0);

            PutUserCertInfo(certType, certIdx, userCert, __lang);
        
            var titleList = [{title:__lang.IDS_CERT_FIELD}, {title:__lang.IDS_CERT_VALUE}];
            var fieldList = [{field:__lang.IDS_CERT_VERSION}, 
                            {field:__lang.IDS_CERT_SERIAL_NUMBER}, 
                            {field:__lang.IDS_CERT_SIGN_ALGOLISM}, 
                            {field:__lang.IDS_CERT_ISSUER}, 
                            {field:__lang.IDS_CERT_VALIDATE_FROM},
                            {field:__lang.IDS_CERT_VALIDATE_TO}, 
                            {field:__lang.IDS_CERT_SUBJECT}, 
                            {field:__lang.IDS_CERT_PUBLIC_KEY}, 
                            {field:__lang.IDS_CERT_AUTHORITY_KEY_IDENTIFIER}, 
                            {field:__lang.IDS_CERT_SUBJECT_KEY_IDENTIFIER},
                            {field:__lang.IDS_CERT_KEY_USAGE}, 
                            {field:__lang.IDS_CERT_POLICY}, 
                            {field:__lang.IDS_CERT_SUBJECT_ALT_NAME}, 
                            {field:__lang.IDS_CERT_AUTHORITY_INFO_ACCESS}, 
                            {field:__lang.IDS_CERT_CRL_DISTRIBUTE_POINTS},
                            {field:__lang.IDS_CERT_CPS},
                            {field:__lang.IDS_CERT_PURPOSE},
                            {field:__lang.IDS_CERT_SIGNATURE}];
                            
            DrawDetailListTitle( titleList, fieldList );
            ViewContent(0);
            
            return document.getElementById('m-us-div-cert-view');
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
        SANDBOX.ESVS.TargetObj.insertBefore( overlay, SANDBOX.ESVS.TargetObj.firstChild);  //for test
        
        /* for orientation */
        var perEv = window.onorientationchange;
        /* for orientation */
       
        function fisrtFocus() {
            //var divs = win.getElementsByTagName("div");
            var as = win.getElementsByTagName("a");
            
            if ( 0 < as.length ) {
                for ( var i = 0; i < as.length; i++ ) {
                    if ( 'm-us-view-tab-simple' == as[ i ].id ) {
                        as[ i ].focus();
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
