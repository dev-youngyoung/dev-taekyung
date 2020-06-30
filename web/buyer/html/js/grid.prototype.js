var MGRID = function(id,template_id, chgValues) {
    if(!document.getElementById(id)) {
        alert("MGRID ERROR - TABLE Element not found.");
        return;
    }
    this.element = document.getElementById(id).getElementsByTagName("tbody")[0];
    if(!this.element) {
        alert("MGRID ERROR - TBODY Element not found.");
        return;
    }
    if(template_id){
        if(!document.getElementById(template_id)) {
            alert("MGRID ERROR - TEMPLATE TABLE Element not found.");
            return;
        }
    }

    this.rowIndex = -1;
    this.rowAlign = "center";
    this.cellAligns = new Array();
    this.cellClassName = "";
    this.cellClassNames = new Array();
    this.cells = new Array();
    this.useActiveColor = false;
    this.rowActiveColor = "#D9FFD9";
    this.rowNormalColor = "#ffffff";
    this.callbackInsert = "";
    this.callbackDelete = "";
    this.callbackSwap = "";
    if(template_id != null){
        this.setTemplate(template_id,chgValues);
    }
}
MGRID.prototype.addRow = function(rowIndex, data) { //rowIndex is null or num, data is null or array
    if(!data && this.cells.length == 0) {
        alert("MGRID ERROR - Celldata is not exists.");
        return;
    }
    var row = this.element.insertRow( (rowIndex + "" == "undefined"|| rowIndex==null) ? this.element.rows.length : rowIndex);
    row.style.textAlign = this.rowAlign;
    var rowData = data ? data : this.cells;
    for(var i=0; i<rowData.length; i++) {
        var cell = row.insertCell(i);
        cell.className = this.cellClassName;
        cell.innerHTML = rowData[i];
        if(this.cellAligns && this.cellAligns.length > 0) cell.style.textAlign = this.cellAligns[i];
        if(this.cellClassNames && this.cellClassNames.length > 0) cell.className = this.cellClassNames[i];
        if(this.useActiveColor) {
            var obj = this;
            for(var j=0; j<cell.children.length; j++) {
                if(window.attachEvent)
                    cell.children[j].attachEvent(
                        "onfocus"
                        , function() { obj.setActiveColor(obj.findRow(event.srcElement).rowIndex); }
                    );
                if(window.addEventListener)
                    cell.children[j].addEventListener(
                        "focus"
                        , function() { obj.setActiveColor(obj.findRow(this).rowIndex); }
                        , false
                    );
            }
        }
    }
    this.rowIndex = row.rowIndex;
    if(this.useActiveColor) this.setActiveColor(this.rowIndex);
    if(this.callbackInsert) eval(this.callbackInsert + "(" + this.rowIndex + ")");
}
MGRID.prototype.delRow = function(rowIndex) {
    try {
        this.element.deleteRow(rowIndex - 1);
        if(this.useActiveColor) this.setActiveColor(-1);
        if(this.callbackDelete) eval(this.callbackDelete + "()");
    } catch(e) {}
}
MGRID.prototype.clear = function(el) {
    try {
        var cnt = this.element.rows.length;
        for(var i=0; i<cnt; i++){
            this.element.deleteRow(0);
        }
    } catch(e) {}
}
MGRID.prototype.swapRow = function(fromElement, toElement) {
    try {
        var clone = toElement.cloneNode(true);
        var parent = toElement.parentNode;
        fromElement = parent.replaceChild(clone, fromElement);
        parent.replaceChild(fromElement, toElement);
        parent.replaceChild(toElement, clone);
        clone = null;
        if(this.useActiveColor) this.setActiveColor(toElement.rowIndex);
        if(this.callbackSwap) eval(this.callbackSwap + "(" + toElement.rowIndex + ")");
    } catch(e) {}
}
MGRID.prototype.findRow = function(el) {
    try {
        var row = el.parentNode;
        while(row.parentNode) {
            if(row.tagName.toLowerCase() == "tr" && row.parentNode == this.element) return row;
            row = row.parentNode;
        }
    } catch(e) {}
    return null;
}

MGRID.prototype.add = function(el) {
    var row = this.findRow(el);
    this.addRow(row.rowIndex);
}
MGRID.prototype.del = function(el) {
    var row = this.findRow(el);
    this.delRow(row.rowIndex);
}
MGRID.prototype.up = function(el) {
    var row = this.findRow(el);
    this.swapRow(row.previousSibling, row);
}
MGRID.prototype.down = function(el) {
    var row = this.findRow(el);
    this.swapRow(row.nextSibling, row);
}
MGRID.prototype.setActiveColor = function(rowIndex) {
    for(var i=0; i<this.element.rows.length; i++) {
        if(i == rowIndex - 1) this.element.rows[i].style.backgroundColor = this.rowActiveColor;
        else this.element.rows[i].style.backgroundColor = this.rowNormalColor;
    }
}

MGRID.prototype.setTemplate = function(template_id, chgValues) { //rowIndex is null or num, data is null or array
    var table = document.getElementById(template_id);
    var row = table.rows[0];
    var cells = new Array(row.cells.length);
    var aligns = new Array(row.cells.length);
    for(var i = 0 ; i < cells.length; i ++){
        if(chgValues){
            for(var j = 0 ; j< chgValues.length; j ++){
                var chg = chgValues[j].split("=>");
                var html = row.cells[i].innerHTML;
                html = html.replaceAll("[["+chg[0]+"]]",chg[1]);
                cells[i] = html;
            }
        }else{
            cells[i]= row.cells[i].innerHTML;
        }
        aligns = row.cells[i].align;
    }
    this.cells = cells;
    this.cellAligns = aligns;
}


function table2array(tableId, chgValues){
    var table = document.getElementById(tableId);
    var row = table.rows[0];
    var arr = new Array(row.cells.length);
    for(var i = 0 ; i < arr.length; i ++){
        if(chgValues){
            var html = row.cells[i].innerHTML;
            for(var j = 0 ; j< chgValues.length; j ++){
                var chg = chgValues[j].split("=>");
                html = html.replaceAll("[["+chg[0]+"]]",chg[1]);
                arr[i] = html;
            }
        }else{
            arr[i]= row.cells[i].innerHTML;
        }
    }
    return arr;
}