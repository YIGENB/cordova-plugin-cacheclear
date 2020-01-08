package com.android.plugins;
 
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
 
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
 
import java.io.File;
import java.math.BigDecimal;
/**
 * 缓存清理插件
 */
public class Cacheclear extends CordovaPlugin {
 
  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    if (action.equals("deleteFileCache")) {
      this.deleteFileCache(callbackContext);
      return true;
    } else if (action.equals("getCacheSize")) {
      this.getCacheSize(callbackContext);
      return true;
    }
    return false;
  }
 
  /**
   * 缓存清理
   *
   * @param callbackContext
   * @return
   */
  private void deleteFileCache(CallbackContext callbackContext) {
    File cacheDic = cordova.getActivity().getCacheDir();
    File cacheDic1 = cordova.getActivity().getExternalCacheDir();
    try {
      deleteFilesByDirectory(cacheDic);
      deleteFilesByDirectory(cacheDic1);
      callbackContext.success("缓存清理成功");
    } catch (Exception e) {
      e.getCause();
      callbackContext.error("缓存清理失败");
    }
  }
 
  /**
   * * 删除方法 这里只会删除某个文件夹下的文件，如果传入的directory是个文件，将不做处理 * *
   *
   * @param directory
   */
  private static void deleteFilesByDirectory(File directory) {
    File[] fileList = directory.listFiles();
    for (int i = 0; i < fileList.length; i++) {
      // 如果下面还有文件
      if (fileList[i].isDirectory()) {
        deleteFilesByDirectory(fileList[i]);
      } else {
        fileList[i].delete();
      }
    }
    /*if (directory != null && directory.exists() && directory.isDirectory()) {
      for (File item : directory.listFiles()) {
        item.delete();
      }
    }*/
  }
 
  /**
   * 获取格式化后文件大小
   *
   * @param
   * @return
   * @throws Exception
   */
  public void getCacheSize(CallbackContext callbackContext) {
    File file = cordova.getActivity().getCacheDir();
    File file1 = cordova.getActivity().getExternalCacheDir();
    try {
      String fileSize = getFormatSize(getFolderSize(file)+getFolderSize(file1));
      callbackContext.success(fileSize);
    } catch (Exception e) {
      callbackContext.error("获取缓存长度失败");
    }
  }
 
  /**
   * 获取文件大小
   *
   * @param file
   * @return
   * @throws Exception
   */
  public long getFolderSize(File file) {
    long size = 0;
    File[] fileList = file.listFiles();
    for (int i = 0; i < fileList.length; i++) {
      // 如果下面还有文件
      if (fileList[i].isDirectory()) {
        size = size + getFolderSize(fileList[i]);
      } else {
        size = size + fileList[i].length();
      }
    }
    return size;
  }
 
  /**
   * 格式化长度
   *
   * @param size
   * @return
   */
  public static String getFormatSize(double size) {
    double kiloByte = size / 1024;
    if (kiloByte < 1) {
//      return size + "Byte";
      return "0KB";
    }
 
    double megaByte = kiloByte / 1024;
    if (megaByte < 1) {
      BigDecimal result1 = new BigDecimal(Double.toString(kiloByte));
      return result1.setScale(2, BigDecimal.ROUND_HALF_UP)
        .toPlainString() + "KB";
    }
 
    double gigaByte = megaByte / 1024;
    if (gigaByte < 1) {
      BigDecimal result2 = new BigDecimal(Double.toString(megaByte));
      return result2.setScale(2, BigDecimal.ROUND_HALF_UP)
        .toPlainString() + "MB";
    }
 
    double teraBytes = gigaByte / 1024;
    if (teraBytes < 1) {
      BigDecimal result3 = new BigDecimal(Double.toString(gigaByte));
      return result3.setScale(2, BigDecimal.ROUND_HALF_UP)
        .toPlainString() + "GB";
    }
    BigDecimal result4 = new BigDecimal(teraBytes);
    return result4.setScale(2, BigDecimal.ROUND_HALF_UP).toPlainString()
      + "TB";
  }
}