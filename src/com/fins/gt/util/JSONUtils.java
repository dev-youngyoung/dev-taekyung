package com.fins.gt.util;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.fins.org.json.JSONArray;
import com.fins.org.json.JSONException;
import com.fins.org.json.JSONObject;


public class JSONUtils {
	public static JSONObject Bean2JSONObject(Object bean){
		return Bean2JSONObject(bean, BeanUtils.getCacheGetterMethodInfo(bean.getClass()));
	}
	
	public static JSONObject Bean2JSONObject(Object bean, Object[] methodInfo ){
		JSONObject jsonObj=null;
		if (bean==null){
			jsonObj=new JSONObject(bean);
		}else{
			jsonObj = new JSONObject(
					bean,
					(String[]) methodInfo[0],
					(Method[]) methodInfo[1]);
		}
		return jsonObj;
	}
	
	public static Object JSONObject2Bean(JSONObject jsonObj, Class beanClass){
		Object[] methodInfo=BeanUtils.getCacheSetterMethodInfo(beanClass);
		return JSONObject2Bean(jsonObj,beanClass,methodInfo);
	}
	public static Object JSONObject2Bean(JSONObject jsonObj, Class beanClass,Object[] methodInfo){
		Object bean=null;
		try {
			bean = beanClass.newInstance();
		} catch (Exception e1) {
			jsonObj = null;
		}
		if (jsonObj==null) return null;
		
		String[] methodNames=(String[])methodInfo[0];
		Method[] methods=(Method[])methodInfo[1];
		Class[] paramTypes=(Class[])methodInfo[2];
		for (int i=0;i<methods.length;i++){
				try {
					Class paramType=paramTypes[i];
					Object[] param=null;
					if (paramType.equals(String.class)){
						param= new Object[]{ jsonObj.getString(methodNames[i]) };
					}else if (paramType.equals(Integer.class)){
						param= new Object[]{ new Integer(jsonObj.getInt(methodNames[i])) };
					}else if (paramType.equals(Long.class)){
						param= new Object[]{ new Long(jsonObj.getLong(methodNames[i])) };
					}else if (paramType.equals(Double.class)){
						param= new Object[]{ new Double(jsonObj.getDouble(methodNames[i])) };
					}else if (paramType.equals(Boolean.class)){
						param= new Object[]{ new Boolean(jsonObj.getBoolean(methodNames[i])) };
					}else{
						param= new Object[]{ jsonObj.get(methodNames[i]) };
					}

					methods[i].invoke(bean, param);
				} catch (Exception e) {
					LogHandler.error(methodNames[i] + "  "+e.getMessage());
				} 
		}
		return bean;
	}
	
	public static JSONArray BeanList2JSONArray(List list , Class beanClass){
		Object[] info = BeanUtils.getCacheGetterMethodInfo(beanClass);
		JSONArray jsonArray=new JSONArray();
		for (int i = 0,end=list.size(); i < end; i++) {
			jsonArray.put(Bean2JSONObject(list.get(i),info));
		}
		return jsonArray;
	}
	
	public static Map JSONObject2Map(JSONObject obj_JS){
		Map map=new HashMap();
		Iterator keyItr= obj_JS.keys();
		while(keyItr.hasNext()){
			String key=(String)keyItr.next();
			Object e;
			try {
				e = obj_JS.get(key);
				if (e instanceof JSONObject){
					e=JSONObject2Map((JSONObject)e);
				}
				map.put(key,e);
			} catch (JSONException e1) {}
			
		}
		
		return map;
	}


}
