var __certlist = function( SANDBOX ) {
    function CertList( Param ) {
        this._certviewlist = null;
        this._certviewlistcnt = -1;
        this._certselectedrow = null;
        this._certrowcnt = -1;
		this._certcolcnt = -1;
        this._certtabidx = -1;

		this._listtype = Param.listtype;
        this._bodyid = Param.bodyid;
		this._rowid = Param.rowid;
		this._imgid = Param.imgid;
		this._eleid = Param.eleid;
				
		this._device = Param.device;
    }
    
    CertList.prototype = {			
        getViewList: function() {
            return this._certviewlist;
        },
        
        getViewListCnt: function() {
            return this._certviewlistcnt;
        },
        
        getRowCnt: function() {
            return this._certrowcnt;
        },
        
        getColCnt: function() {
            return this._certcolcnt;
        },
        
        setTabIdx: function( tabidx ) {
            this._certtabidx = tabidx;
        },
        
        getTabIdx: function() {
            return this._certtabidx;
        },

		getListTypeID: function() {
			return this._listtype;
		},

		getBodyID: function() {
			return this._bodyid;
		},

		getRowID: function() {
			return this._rowid;
        },

		getImgID: function() {
			return this._imgid;
        },

		getEleID: function() {
			return this._eleid;
        },
        
		getDevice: function() {
			return this._device;
        },  
        
		setDevice: function( device ) {
			this._device = device;
        },               
        
        getSelectedIndex: function( obj ) {
            
            if ( !obj ) {
                return -1;
            }

			this._certselectedrow = obj;
            
            var cnt = this._certselectedrow.childNodes.length;
            return this._certselectedrow.childNodes[ cnt - 1 ].firstChild.nodeValue;
        },
        
        drawListBody: function( list, listlen ) {
            
            this._certviewlist = list;
            this._certviewlistcnt = listlen;
			
			this._certrowcnt = this._certviewlistcnt;
			this._certcolcnt = 5;
            
            var bodyObj = document.getElementById(this._bodyid);			
			var ulObj = document.createElement('ul');
            bodyObj.appendChild(ulObj);
			
            for (var y = 0; y < this._certrowcnt; y++) {
/*				
				<li>
                	<div class="us-layout-list-cert">
						<p class="us-cert-icon">
							<img id="" />
						</p>
                        <div class="us-layout-cert-info">
                        	<p>
                        		<span id=""> </span> / 
                        		<span id=""> </span> 
                        		<span id=""> </span>
                        	</p>
                            <p class="us-cert-info-data">
                            	<span id=""> </span>
                            </p>
                            <p class="us-cert-info-name">
                            	<span id=""> </span>
                            </p>
                        </div>
                    </div>
                </li>
*/               
                var liObj = document.createElement('li');
                liObj.setAttribute('id', this._rowid + (y + 1), 0);
                //liObj.setAttribute('aria-selected', 'false', 0);
                ulObj.appendChild(liObj);

				var olDivObj = document.createElement('div');
				olDivObj.className = 'm-us-layout-list-cert';
				liObj.appendChild(olDivObj);

				var pForStatusImgObj = document.createElement('p');
				pForStatusImgObj.className = 'm-us-cert-icon';
				olDivObj.appendChild(pForStatusImgObj);

				var imgObj = document.createElement('img');
				imgObj.setAttribute('id', this._imgid + (y + 1), 0);
				pForStatusImgObj.appendChild(imgObj);

				var dtDivObj = document.createElement('div');
				dtDivObj.className = 'm-us-layout-cert-info';
				olDivObj.appendChild(dtDivObj);

				var pForTypeNDateObj = document.createElement('p');
				dtDivObj.appendChild(pForTypeNDateObj);

				var spanForType = document.createElement('span');
				spanForType.setAttribute('id', this._eleid + (y + 1) + '-1', 0);
				pForTypeNDateObj.appendChild(spanForType);

                var txtObj = document.createTextNode(' / ');
				pForTypeNDateObj.appendChild(txtObj);

				var spanForDtT = document.createElement('span');
				spanForDtT.setAttribute('id', this._eleid + (y + 1) + '-2', 0);
				pForTypeNDateObj.appendChild(spanForDtT);

				var spanForDtD = document.createElement('span');
				spanForDtD.setAttribute('id', this._eleid + (y + 1) + '-3', 0);
				pForTypeNDateObj.appendChild(spanForDtD);

				var pForSjObj = document.createElement('p');
				pForSjObj.className = 'm-us-cert-info-data';
				dtDivObj.appendChild(pForSjObj);

				var spanForSj = document.createElement('span');
				spanForSj.setAttribute('id', this._eleid + (y + 1) + '-4', 0);
				pForSjObj.appendChild(spanForSj);

				var pForIsObj = document.createElement('p');
				pForIsObj.className = 'm-us-cert-info-name';
				dtDivObj.appendChild(pForIsObj);

				var spanForIs = document.createElement('span');
				spanForIs.setAttribute('id', this._eleid + (y + 1) + '-5', 0);
				pForIsObj.appendChild(spanForIs);
                
                if ( 0 === y ) {
                    liObj.setAttribute('tabindex', this._certtabidx, 0);
                }
            }
         
            return true;
        },
        
        listClear: function() {
            var bodyObj = document.getElementById(this._bodyid);
            var ulNodeObj = bodyObj.getElementsByTagName('ul');
            
            this._certselectedrow = null;
            this._certviewlist = null;
            this._certviewlistcnt = -1;
            
            if ( bodyObj && ulNodeObj ) {
                bodyObj.removeChild( ulNodeObj[ 0 ] );
            } else {
                return false;
            }
            
            return true;
        }
    }
    
    return function( Param ) {
        
        var listobj = new CertList({
					listtype: 	Param.listtype,
                    bodyid: 	Param.bodyid,
					rowid: 		Param.rowid,
					imgid: 		Param.imgid,
					eleid: 		Param.eleid,
					device:		Param.device,
					confirm: 	Param.confirm,
					cancel: 	Param.cancel
                });

		var listtype = listobj.getListTypeID();
		
		/* for orientation */
        var perEv = window.onorientationchange;    
		var bodyid = listobj.getBodyID();
		
		function certlistHeight()	{
			if( 768 > document.documentElement.clientWidth ){
				if( 90 == window.orientation || -90 == window.orientation ) {
					document.getElementById(bodyid).style.height = 100 + 'px';
				} else if( 0 == window.orientation || 180 == window.orientation ) {
					document.getElementById(bodyid).style.height = 220 + 'px';			
				}
			}
		}
		
		certlistHeight();
		
		function certlistHeightEvent() {
		    certlistHeight();
		    
		    if ( perEv ) {
                        perEv();
                    }
		}
		
		window.addEventListener('orientationchange', certlistHeightEvent);
		/* for orientation */
        
        function setTabIndex( tabidx ) {
            if ( 0 <= tabidx ) {
                listobj.setTabIdx( tabidx );
            }
        }
        
        function putImgforCertsList( obj, status ) {
            if ( 0 === status ) {
                obj.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_cert_valid_small.png', 0);  //test code
            } else if ( 1 === status ) {
                obj.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_cert_valid_1_month_small.png', 0);  //test code
            } else if ( 2 === status ) {
                obj.setAttribute('src', SANDBOX.ESVS.SRCPath + 'unisignweb/rsrc/img/mobile/m_cert_invalid_small.png', 0);  //test code
            } else {
                return;
            }
			
            obj.setAttribute('align', 'middle', 0);
            obj.setAttribute('alt', '', 0);
        }
                
        function putData() {
            var viewList = listobj.getViewList();       
            var colCnt = listobj.getColCnt();
            var viewListCnt = listobj.getViewListCnt(); 
            var rowID = listobj.getRowID();
			var imgID = listobj.getImgID();
            var eleID = listobj.getEleID();
                
            for (var y = 0; y < viewListCnt; y++) {
                var row = document.getElementById(rowID + (y + 1));
				var img = document.getElementById(imgID + (y + 1));

				putImgforCertsList( img, viewList[ y ][ 6/*expStateValue*/ ] );
                
                var x = 0;
                for (; x < colCnt; x++) {
                    var ele = document.getElementById(eleID + (y + 1) + '-' + (x + 1));
                    ele.appendChild(document.createTextNode(viewList[ y ][ x ]));
                }
                
                if ( 'mobilecertselect' == listtype ) {
                    row.onclick = function() {                      
                        var _this = this;
                        var _index = listobj.getSelectedIndex( _this );
                        
                        var UI = SANDBOX.loadUI('certpassword');
                        var Dialog = UI({
                            type: null,
                            args: {
                                type: 'Base64',
                                idx: _index,
                                cert: SANDBOX.certsList.list[ _index - 1 ].cert
                            },
                            onConfirm: function( index, password ) {
                                Dialog.dispose(); 
                                Param.confirm( index, password );
                                //_this.focus();
                            },
                            onCancel: function() {
                                Dialog.dispose();
                                //Param.cancel();
                                //_this.focus();
                            },
                            onTerminate: function() {
                                Dialog.dispose();
                                Param.cancel();
                                //_this.focus();
                            }
                        });
                        Dialog.show();
                    };
                } else if ( 'mobilecertmanage' == listtype ) {
                    row.onclick = function() {                      
                        var _this = this;
                        var _index = listobj.getSelectedIndex( _this );
                        var UI = SANDBOX.loadUI('certmanagesub');
                        var Dialog = UI({
                            type: null,
                            args: {
                                type: 'Base64',
                                device : listobj.getDevice(),
                                idx: _index,
                                cert: SANDBOX.certsList.list[ _index - 1 ].cert
                            },
                            onConfirm: function( fRedraw ) {
                                //Dialog.dispose(); 
                                Param.confirm( fRedraw );
                                //_this.focus();
                            },
                            onCancel: function() {
                                Dialog.dispose();
                                //Param.cancel();
                                //_this.focus();
                            }
                        });
                        Dialog.show();
                    };
                } else {}
				
                row.style.cursor = 'pointer';
                
                var hiddenele = document.createElement('div');  // for real index
                hiddenele.setAttribute('id', eleID + (y + 1) + '-' + (x + 1), 0);
                hiddenele.style.display = 'none';
                hiddenele.appendChild(document.createTextNode(viewList[ y ][ x ]));
                row.appendChild(hiddenele);
            }
        }
        
        return {
            
            drawList: function( datalist, datalistcnt, tabindex ) {
                
                if ( 0 > tabindex ) {
                    return false;
                }
                
                setTabIndex( tabindex );
                
                if ( 0 >= datalistcnt ) {
                    listobj.drawListBody( null, -1 );
                } else if ( 0 < datalistcnt && datalist ) {
                    listobj.drawListBody( datalist, datalistcnt );
                    putData();
                } else {
                    return false;
                }
                    
                return true;
            },
            
            redrawList: function( newdatalist, newdatalistcnt, device ) {
                listobj.listClear();        
                
            	// 모바일용으로 사용
            	if (device)
            		listobj.setDevice(device);                

                if ( 0 >= newdatalistcnt ) {
                    listobj.drawListBody( null, -1 );
                } else if ( 0 < newdatalistcnt && newdatalist ) {
                    listobj.drawListBody( newdatalist, newdatalistcnt );
                    putData();
                } else {
                    return false;
                }
                
                return true;
            },
            
            clearList: function() {
                listobj.listClear();
                return true;
            }
        };
    }
};
