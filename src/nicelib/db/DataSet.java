package nicelib.db;

import java.util.*;
import javax.servlet.jsp.JspWriter;

public class DataSet extends Object implements java.io.Serializable {

    private JspWriter out = null;
    private boolean debug = false;
    private Vector rows = null;
    private int idx = -1;
    public String[] columns;
    public int[] types;
    public int sortType = -1;

    public DataSet() {
        rows = new Vector();
    }

    public void setDebug(JspWriter out) {
        this.out = out;
        this.debug = true;
    }

    public int size() {
        if(rows != null) return rows.size();
        else return 0;
    }

    public boolean next() {
        if(rows == null || rows.size() <= (idx + 1)) return false;

        idx = idx + 1;
        return true;
    }

    public void move(int id) {
        idx = id;
    }

    public int getIndex() {
        return idx;
    }

    public int addRow() {

        rows.addElement(new Hashtable());
        idx++;

        return idx;
    }

    public int addRow(Hashtable map) {

        rows.addElement(map.clone());
        idx++;

        return idx;
    }

    public void removeRow(){
        if(idx>0){
            rows.remove(idx);
            idx--;
        }
    }

    public void removeAll() {
        rows.removeAllElements();
        idx = -1;
    }

    public boolean prev() {
        idx = idx - 1;
        if(idx < 0) {
            idx = 0;
            return false;
        } else {
            return true;
        }
    }

    public boolean first() {
        idx = -1;
        return true;
    }

    public boolean last() {
        idx = this.size() - 1;
        return true;
    }

    public void put(String name, int i) {
        this.put(name, "" + i);
    }

    public void put(String name, double d) {
        this.put(name, "" + d);
    }

    public void put(String name, boolean b) {
        this.put(name, "" + b);
    }

    public void put(String name, Object value) {
        if(value == null) value = "";
        ((Hashtable)rows.get(idx)).put(name, value);
    }

    public String getString(String name) {
        if(rows == null) return null;
        String ret = "";
        try {
            ret = ((Hashtable)rows.get(idx)).get(name).toString();
        } catch(Exception e) {}

        return ret;
    }

    public int getInt(String name) {
        if(rows == null) return 0;
        int ret = 0;
        try {
            ret = Integer.parseInt(getString(name));
        } catch(Exception e) {}

        return ret;
    }

    public long getLong(String name) {
        if(rows == null) return 0;
        long ret = 0;
        try {
            ret = Long.parseLong(getString(name));
        } catch(Exception e) {}

        return ret;
    }

    public double getDouble(String name) {
        if(rows == null) return 0.0;
        double ret = 0.0;
        try {
            ret = Double.parseDouble(getString(name));
        } catch(Exception e) {}

        return ret;
    }

    public Date getDate(String name) {
        if(rows == null) return null;
        Date ret = null;
        try {
            ret = (Date)((Hashtable)rows.get(idx)).get(name);
        } catch(Exception e) {}

        return ret;
    }

    public DataSet getDataSet(String name) {
        if(rows == null) return null;
        DataSet ret = null;
        try {
            ret = (DataSet)((Hashtable)rows.get(idx)).get(name);
        } catch(Exception e) {}

        return ret;
    }

    public Vector getRows() {
        return rows;
    }


    public Hashtable getRow() {
        if(idx > -1) {
            return (Hashtable)((Hashtable)rows.get(idx)).clone();
        } else {
            return null;
        }
    }

    public boolean setRow(Hashtable data) {
        if(idx > -1) {
            rows.set(idx, data);
            return true;
        }else {
            return false;
        }
    }

    public String toString() {
        if(rows != null) {
            return rows.toString();
        } else {
            return "";
        }
    }

    public DataSet getCloneDataSet() {
        DataSet ds = new DataSet();
        ds.rows = (Vector)rows.clone();
        return ds;
    }

    public void removeColumn(String keys) {
        int pos = idx;
        idx = -1;
        while(next()) {
            String[] arrKey = keys.split(",");
            for(int i = 0 ; i < arrKey.length; i++) {
                Hashtable row = getRow();
                row.remove(arrKey[i].trim());
                setRow(row);
            }
        }
        idx = pos;
    }

}