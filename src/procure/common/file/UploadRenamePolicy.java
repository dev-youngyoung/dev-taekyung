package procure.common.file;

import com.oreilly.servlet.multipart.FileRenamePolicy;
import java.io.*;
import java.util.Date;
import java.text.SimpleDateFormat;

public class UploadRenamePolicy  implements FileRenamePolicy {
     public File rename(File f) {
    	 
    	 /*
          long currentTime = System.currentTimeMillis();
          SimpleDateFormat simDf = new SimpleDateFormat("yyyyMMddHHmmss");
          int randomNumber = (int)(Math.random()*100000);
    
          String uniqueFileName = "" + randomNumber + simDf.format(new Date(currentTime));
		*/
          String name = f.getName();
          String body = null;
          String ext = null;

          int dot = name.lastIndexOf(".");
          if (dot != -1) {
               body = name.substring(0, dot);
               ext = name.substring(dot);  // includes "."
               
               // 2015.01.20 해킹방지 shryu
               if(ext.equals(".jsp") || ext.equals(".sh") || ext.equals(".csh") || ext.equals(".exe")) ext = ".xxx";
          }
          else {
               body = name;
               ext = "";
          }
        	  
         // String tempName = uniqueFileName + ext;
          String tempName = body + ext;
          f = new File(f.getParent(), tempName);
          if (createNewFile(f)) {
               return f;
          }

          int count = 0;
          while (!createNewFile(f) && count < 9999) {
               count++;
               //String newName = uniqueFileName + "_" + count + ext;
               String newName = body + "_" + count + ext;
               f = new File(f.getParent(), newName);
          }

          return f;
     }

     private boolean createNewFile(File f) {
          try {
               return f.createNewFile();
          }
          catch (IOException ignored) {
               return false;
          }
     }
}
