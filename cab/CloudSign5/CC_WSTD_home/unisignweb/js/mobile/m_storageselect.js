var __storageselect = function( SANDBOX ) {
    var ConstructScreen = function( Param ) {   
        var __UIElement = {
            __Layout: function() {
                var req;
    
                if ( window.XMLHttpRequest ) {
                    req = new window.XMLHttpRequest;
                } else {
                    req = new ActiveXObject('MSXML2.XMLHTTP.3.0');
                }
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/layout/mobile/m_storageselect.html?version=' + SANDBOX.ver, false);
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
                
                req.open('GET', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/lang/storageselect_' + SANDBOX.ESVS.Language + '.js?version=' + SANDBOX.ver, false);
                req.send(null);
                
                return req.responseText;
            }
        };
        
        var __lang = eval((eval(__UIElement.__Lang))());
        var __TabIndex = SANDBOX.ESVS.TabIndex;
        var __SelectedDevice = SANDBOX.CONST.__USFB_M_DISK.device;
        var __SelectedDrive = 0;

        //if (SANDBOX.ESVS.Media != null && SANDBOX.ESVS.Media.defaultdevice != null){
        //    __SelectedDevice = SANDBOX.uiUtil().getMediaDevice( SANDBOX.ESVS.Media.defaultdevice );
        //}else{
            //if ( (0x02 == SANDBOX.ESVS.Mode) ) {    /* plugin free mode */             
                __SelectedDevice = SANDBOX.CONST.__PF_M_LS.device;
            //}
        //}
        
        function UILoad( form ) {
            if ( !form ) {
                alert('UI load error.');
                return false;
            }
            
            //test code
            if ( 'CERT_STORAGE' === Param.type ) {
                SANDBOX.ESVS.TargetObj.innerHTML = form;
            } else {  // CERT_COPY & CERT_IMPORT
                var topElement = document.createElement('div');
                document.body.insertBefore( topElement, document.body.firstChild );
                topElement.innerHTML = form;
            }
            
            return true;
        }

        /*****   plugin free   *****/
        function OnClickLS( obj, textObj ) {
        	if ( !obj || !textObj ) {
                return false;
            }
			
            var __this = obj;
			var __text = textObj;

			__this.focus();
			
            __SelectedDevice = SANDBOX.CONST.__PF_M_LS.device;
			
			WindowConfirm( __text );
			
			return true;
        }
        
        function OnClickSS( obj, textObj ) {
        	if ( !obj || !textObj ) {
                return false;
            }
			
            var __this = obj;
			var __text = textObj;

			__this.focus();
			
            __SelectedDevice = SANDBOX.CONST.__PF_M_SS.device;
			
			WindowConfirm( __text );
			
			return true;
        }        
        /*****   plugin free   *****/
        
        //지?�되지 ?�는 ?�?�매체인 경우
        function OnClickETC( obj, textObj ) {
            if ( !obj || !textObj ) {
                return false;
            }
            
            var __this = obj;
            var __text = textObj;

            SANDBOX.uiUtil().msgBox(__text.IDS_MSGBOX_NOT_SUPPORTED_MEDIA);
            
            return true;
        }
        
        function WindowConfirm( textObj ) {
            if ( SANDBOX.CONST.__USFB_M_DISK.device > __SelectedDevice ) {
                SANDBOX.uiUtil().msgBox(textObj.IDS_MSGBOX_ERROR_PLEASE_SELECT_STORAGE);
                return false;
            } 
            
            if ( (SANDBOX.CONST.__USFB_M_DISK.device === __SelectedDevice || SANDBOX.CONST.__USFB_M_HSMKEY.device === __SelectedDevice) && 1 > __SelectedDrive ) {
                SANDBOX.uiUtil().msgBox(textObj.IDS_MSGBOX_ERROR_PLEASE_SELECT_STORAGE);
                return false;
            }
            
            if ( 'CERT_COPY' == Param.type ) {
                if ( Param.args.sourceDevice === __SelectedDevice && Param.args.sourceDrive === __SelectedDrive ) {
                    SANDBOX.uiUtil().msgBox(textObj.IDS_MSGBOX_ERROR_WARNING_SAME_STORAGE);
                    return false;
                }
            }
            
            if ( 'CERT_COPY' === Param.type || 'CERT_IMPORT' === Param.type || 'CERT_STORAGE' === Param.type ) {
                if ( SANDBOX.CONST.__USFB_M_SMARTCARD.device === __SelectedDevice && 0 === __SelectedDrive ) {
                    if ( !confirm( textObj.IDS_CONFIRMBOX_WARNING_CHANGE_CERT ) ) {
                        return false;
                    }
                }
            }
            
            Param.onConfirm( __SelectedDevice, __SelectedDrive );
            return true;
        }
        
        function ChangeButtonStyle( obj ) {
            if ( !obj ) {
                return false;
            }
            
            var __this = obj;
            var mediaList = SANDBOX.ESVS.Media.list.split('|');
            for (var i=0; i < mediaList.length; i++){
                var mediaName = mediaList[i];
                var mediaInfo = SANDBOX.CONST.medias[mediaName];
                if (mediaInfo == undefined || mediaInfo == null){
                    continue;
                }
                
                var button = document.getElementById('m-us-btn-storage-'+mediaInfo.name);
                if (button != undefined && button != null){
                    if (button.className != 'm-us-layout-storage-btn-none'){  /* diabled???�태가 ?�닌 경우�?*/
                        if ( __this === button ) {
                            button.className = 'm-us-layout-storage-btn-on';
                            button.focus();
                        } else {
                            button.className = 'm-us-layout-storage-btn-off';
                        }
                        //button.className = 'm-us-layout-storage-btn-none';
                    }
                }
            }
            
            return true;
        }

        /* ?�??매체 버튼 ?�성 �?비활?�화 처리 */
        function displayMediaButton( deviceBtnInfo ) {
            if ( deviceBtnInfo == null || deviceBtnInfo == undefined ) {
                return false;
            }
            
            var isHidden = !SANDBOX.uiUtil().isItSupportingThisStorage(deviceBtnInfo);  /* 지?�되???�?�매체인지 ?�인 */
            if (isHidden == false && SANDBOX.ESVS.Media != null && SANDBOX.ESVS.Media.list != null){
                if ( SANDBOX.ESVS.Media.list.indexOf(deviceBtnInfo.name) < 0 ) {
                    isHidden = true;
                }
            }
        
            if ( isHidden ){
                /* show/hide 처리 */
                return false;
            }else{
//              <li id="us-storage-btn-li-removable">
//                  <button id="m-us-btn-storage-removable" class="m-us-layout-storage-btn-off" type="button">
//                      <span class="m-us-drive-select"><img id="m-us-img-storage-drive" /></span>
//                      <span class="m-us-img-storage"><img id="m-us-img-storage-removable" /></span>
//                      <span id="m-us-lbl-storage-removable" class="m-us-layout-lbl-storage"></span>
//                  </button>
//              </li>
                var ul = document.getElementById('m-us-btn-storage-btn-list');
                
                var li = document.createElement('li');
                li.setAttribute('id', "m-us-storage-btn-li-"+deviceBtnInfo.name, 0);
                li.setAttribute('mediaIndex', deviceBtnInfo.mediaIndex, 0);
                if (deviceBtnInfo.mediaIndex == 5){
                    li.className = 'line-first';
                }
                if ('hidden' === deviceBtnInfo.visibility){
                    li.style.display = 'none';
                    li.style.visibility = 'hidden';
                }else{
                    li.style.display = 'block';
                    li.style.visibility = 'visible';
                }
                
                // 버튼?�그 부�?출력
                var button = document.createElement('button');
                button.setAttribute('type', 'button', 0);
                button.setAttribute('id', 'm-us-btn-storage-'+deviceBtnInfo.name, 0);
                button.setAttribute('title', deviceBtnInfo.label, 0);
                button.setAttribute('tabindex', deviceBtnInfo.tabIndex, 0);         
                if ( deviceBtnInfo.disabled ) {    /* plugin free mode */             
                    button.onclick = function(){ /* SANDBOX.uiUtil().msgBox( __lang.IDS_MSGBOX_NOT_SUPPORTED_MEDIA ); */ };
                    //button.setAttribute('disabled', 'disabled', 0);
                    button.className = 'm-us-layout-storage-btn-none';
                } else {
                    button.onclick = deviceBtnInfo.onclick;
                    if ( deviceBtnInfo.device === __SelectedDevice) {
                        button.className = 'm-us-layout-storage-btn-on';
                        button.focus();
                    } else {
                        button.className = 'm-us-layout-storage-btn-off';
                    }
                }
                li.appendChild(button);
                
                // +?�시 ?��?지 부�?출력
                if ('harddisk' !== deviceBtnInfo.name && 'webstorage' !== deviceBtnInfo.name){
                    var plusImgSpan = document.createElement('span');
                    plusImgSpan.className = 'm-us-drive-select';
//                  var plusImg = document.createElement('img');
//                  plusImg.setAttribute('id', 'm-us-img-storage-drive', 0);
//                  plusImgSpan.appendChild(plusImg);
                    button.appendChild(plusImgSpan);
                }
                
                // 매체 ?��?지 부�?출력
                var imgSpan = document.createElement('span');
                imgSpan.className = 'm-us-img-storage';
                var btnImg = document.createElement('img');
                btnImg.setAttribute('id', 'm-us-img-storage-'+deviceBtnInfo.name, 0);
                btnImg.setAttribute('alt', deviceBtnInfo.label, 0);
                if ( deviceBtnInfo.disabled ) {    /* plugin free mode */             
                    btnImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_media_'+deviceBtnInfo.name+'_d.png', 0);
                } else {
                    btnImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_media_'+deviceBtnInfo.name+'.png', 0);
                }
                imgSpan.appendChild(btnImg);
                button.appendChild(imgSpan);

                // 매체명칭 ?�벨 부�?출력
                var lblSpan = document.createElement('span');
                lblSpan.setAttribute('id', 'm-us-lbl-storage-'+deviceBtnInfo.name, 0);
                lblSpan.className = 'm-us-layout-lbl-storage';
                lblSpan.appendChild(document.createTextNode( deviceBtnInfo.label ));
                button.appendChild(lblSpan);
                
                li.appendChild(button);
                
                ul.appendChild(li);
            }
            
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
            
            var titleLbl = document.getElementById('m-us-storage-select-lbl-title');
            titleLbl.appendChild(document.createTextNode(__lang.IDS_STORAGE_SELECTION));
            
            var closeImg = document.getElementById('m-us-storage-select-cls-btn-img');
            closeImg.setAttribute('alt', __lang.IDS_STORAGE_SELECTION_CLOSE, 0);
            closeImg.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_x-btn.png', 0);
            
            var notiLbl = document.getElementById('m-us-storage-select-notice-lbl');
            if ( 'CERT_STORAGE' === Param.type ) {
                notiLbl.appendChild(document.createTextNode(__lang.IDS_SAVE_NOTICE));
            } else {  // CERT_COPY & CERT_IMPORT
                notiLbl.appendChild(document.createTextNode(__lang.IDS_COPY_NOTICE));
            }
            
            
            // ?�?�매�?버튼 출력
            var mediaCnt = 0;
            var mediaList = SANDBOX.ESVS.Media.list.split('|');
            for (var i=0; i < mediaList.length; i++){
                var mediaName = mediaList[i];

                /* // TODO : ?�?�매�?추�????�정?�야??부�?*/
                var mediaInfo = SANDBOX.CONST.medias[mediaName];
                if (mediaInfo != undefined && mediaInfo != null){
                    switch ( mediaInfo.device ) {
                        case SANDBOX.CONST.__PF_M_LS.device :
                            // localstorage button 출력
                            //mediaInfo.name = SANDBOX.CONST.__PF_M_LS.name;
                            //mediaInfo.device = SANDBOX.CONST.__PF_M_LS.device;
                            mediaInfo.label = __lang.IDS_STORAGE_LS;
                            mediaInfo.disabled = (0x01 == SANDBOX.ESVS.Mode || ('CERT_COPY' == Param.type));    /* if plugin free mode or CERT_COPY is diasbled  */
                            mediaInfo.onclick = function(){ OnClickLS(this, __lang); ChangeButtonStyle(this); };
                            break;
                       	case SANDBOX.CONST.__PF_M_SS.device :
							// localstorage button 출력
							//mediaInfo.name = SANDBOX.CONST.__PF_M_LS.name;
							//mediaInfo.device = SANDBOX.CONST.__PF_M_LS.device;
							mediaInfo.label = __lang.IDS_STORAGE_SS;
							mediaInfo.disabled = (0x01 == SANDBOX.ESVS.Mode || ('CERT_COPY' == Param.type));	/* if plugin free mode or CERT_COPY is diasbled  */
							mediaInfo.onclick = function(){ OnClickSS(this, __lang); ChangeButtonStyle(this); };
							break;
                        case SANDBOX.CONST.__PF_M_TOUCHSIGN.device :
                            // ?�치?�인 button 출력
                            //mediaInfo.name = SANDBOX.CONST.__PF_M_TOUCHSIGN.name;
                            //mediaInfo.device = SANDBOX.CONST.__PF_M_TOUCHSIGN.device;
                            mediaInfo.label = __lang.IDS_STORAGE_TOUCHSIGN;
                            mediaInfo.disabled = true;  /* if plugin free mode is diasbled */
                            mediaInfo.onclick = function(){ /* OnClickETC(this, __lang); */ /* ChangeButtonStyle(this); */ };
                            break;
                        case SANDBOX.CONST.__PF_M_SMARTSIGN.device :
                            // ?�치?�인 button 출력
                            //mediaInfo.name = SANDBOX.CONST.__PF_M_SMARTSIGN.name;
                            //mediaInfo.device = SANDBOX.CONST.__PF_M_SMARTSIGN.device;
                            mediaInfo.label = __lang.IDS_STORAGE_SMARTSIGN;
                            mediaInfo.disabled = true;  /* if plugin free mode is diasbled */
                            mediaInfo.onclick = function(){ /* OnClickETC(this, __lang); */ /* ChangeButtonStyle(this); */ };
                            break;
                        case SANDBOX.CONST.__PF_M_WEBSECTOKEN.device :
                            // ?�치?�인 button 출력
                            //mediaInfo.name = SANDBOX.CONST.__PF_M_WEBSECTOKEN.name;
                            //mediaInfo.device = SANDBOX.CONST.__PF_M_WEBSECTOKEN.device;
                            mediaInfo.label = __lang.IDS_STORAGE_WEBSECTOKEN;
                            mediaInfo.disabled = true;  /* if plugin free mode is diasbled */
                            mediaInfo.onclick = function(){ /* OnClickETC(this, __lang); */ /* ChangeButtonStyle(this); */ };
                            break;
                        case SANDBOX.CONST.__PF_M_WEBSOFTTOKEN.device :
                            // ?�치?�인 button 출력
                            //mediaInfo.name = SANDBOX.CONST.__PF_M_WEBSOFTTOKEN.name;
                            //mediaInfo.device = SANDBOX.CONST.__PF_M_WEBSOFTTOKEN.device;
                            mediaInfo.label = __lang.IDS_STORAGE_WEBSOFTTOKEN;
                            mediaInfo.disabled = true;  /* if plugin free mode is diasbled */
                            mediaInfo.onclick = function(){ /* OnClickETC(this, __lang); */ /* ChangeButtonStyle(this); */ };
                            break;
                        default :
                            // localstorage button 출력
                            mediaInfo.label = __lang.IDS_STORAGE_ETC;
                            mediaInfo.disabled = true;  /* if plugin free mode is diasbled */
                            mediaInfo.onclick = function(){ /* OnClickETC(this, __lang); */ /* ChangeButtonStyle(this); */ };
                            break;
                    }
                    
                    mediaInfo.tabIndex = __TabIndex;
                    mediaInfo.mediaIndex = ( mediaCnt + 1 );
                    mediaInfo.visibility = 'visible';
                    
                    //?�?�매�?버튼 출력
                    if ( displayMediaButton( mediaInfo ) ){
                        __TabIndex++; 
                        mediaCnt++;

                        // 첫번�??�?�매체버?�에 ?�커???�정
                        if (mediaCnt == 1) {
                            var button = document.getElementById('m-us-btn-storage-' + mediaInfo.name);
                            button.focus();
                        }
                    };
                }
            }
            
            var warningLbl = document.getElementById('m-us-storage-select-warning-lbl');
            warningLbl.appendChild(document.createTextNode(__lang.IDS_WARNING));
            
            var cancelBtn = document.getElementById('m-us-storage-select-cancel-btn');
            cancelBtn.setAttribute('value', __lang.IDS_CANCEL, 0);
            cancelBtn.setAttribute('title', __lang.IDS_CANCEL + __lang.IDS_BUTTON, 0);
            cancelBtn.setAttribute('tabindex', __TabIndex++, 0);
            cancelBtn.onclick = function(){ WindowExit(); };
            
            var closeBtn = document.getElementById('m-us-storage-select-cls-img-btn');
            closeBtn.setAttribute('tabindex', __TabIndex++, 0);
            closeBtn.onclick = function(){ WindowExit(); };

            return document.getElementById('m-us-div-storage-select');
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
       
        function firstFocus() {
            var mediaList = SANDBOX.ESVS.Media.list.split('|');
            for (var i=0; i < mediaList.length; i++){
                var mediaName = mediaList[i];
                var mediaInfo = SANDBOX.CONST.medias[mediaName];
                if (mediaInfo == undefined || mediaInfo == null){
                    continue;
                }
                
                var button = document.getElementById('m-us-btn-storage-'+mediaInfo.name);
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
               
                if ( 'CERT_STORAGE' === Param.type ) {
                    var parent = win.parentNode;
                    parent.removeChild(win);
                } else {  // CERT_COPY & CERT_IMPORT
                    var body = win.parentNode.parentNode;
                    body.removeChild(win.parentNode);                   
                }

                overlay.parentNode.removeChild(overlay);
                SANDBOX.uiLayerLevel -= 10;
                SANDBOX.ESVS.TabIndex -= 30;
            }
        };
    }
};
