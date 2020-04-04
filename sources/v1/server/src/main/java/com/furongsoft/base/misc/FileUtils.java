package com.furongsoft.base.misc;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

/**
 * 文件工具类
 *
 * @author chenfuqian
 */
public class FileUtils {


    public static byte[] file2byte(String filePath) {
        byte[] buffer = null;
        FileInputStream fis = null;
        ByteArrayOutputStream bos = null;
        try {
            File file = new File(filePath);
            fis = new FileInputStream(file);
            bos = new ByteArrayOutputStream();
            byte[] b = new byte[1024];
            int n;
            while ((n = fis.read(b)) != -1) {
                bos.write(b, 0, n);
            }
            buffer = bos.toByteArray();
        } catch (FileNotFoundException e) {
            Tracker.error(e);
        } catch (IOException e) {
            Tracker.error(e);
        } finally {
            if (fis != null) {
                try {
                    fis.close();
                } catch (IOException e) {
                    Tracker.error(e);
                }
            }
            if (bos != null) {
                try {
                    bos.close();
                } catch (IOException e) {
                    Tracker.error(e);
                }
            }
        }
        return buffer;
    }

    public static String file2Base64(String filePath) {
        return Base64.getEncoder().encodeToString(file2byte(filePath));
    }

    /**
     * 图片base64 生成文件
     *
     * @param base64   图片base64
     * @param filePath 文件路径
     * @param fileName 文件名称
     * @return 是否成功
     */
    public static Boolean base64ToFile(String base64, String filePath, String fileName) {
        if ((StringUtils.isNullOrEmpty(base64)) || (StringUtils.isNullOrEmpty(filePath))) {
            return false;
        }
        File file = null;
        //创建文件目录

        File dir = new File(filePath);
        if (!dir.exists() && !dir.isDirectory()) {
            dir.mkdirs();
        }
        BufferedOutputStream bos = null;
        java.io.FileOutputStream fos = null;
        try {
            byte[] bytes = Base64.getDecoder().decode(base64);
            file = new File(filePath + "\\" + fileName);
            fos = new java.io.FileOutputStream(file);
            bos = new BufferedOutputStream(fos);
            bos.write(bytes);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (bos != null) {
                try {
                    bos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (fos != null) {
                try {
                    fos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        if ((file != null) && (file.exists())) {
            return true;
        }
        return false;
    }

    public static String remoteImageToBase64(String imgURL) {
        ByteArrayOutputStream outPut = null;
        InputStream inStream = null;
        byte[] data = new byte[1024];
        try {
            // 创建URL
            URL url = new URL(imgURL);
            outPut = new ByteArrayOutputStream();
            // 创建链接
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(10 * 1000);

            if (conn.getResponseCode() != HttpURLConnection.HTTP_OK) {
                return "fail";//连接失败/链接失效/图片不存在
            }
            inStream = conn.getInputStream();
            int len = -1;
            while ((len = inStream.read(data)) != -1) {
                outPut.write(data, 0, len);
            }

            // 对字节数组Base64编码
            return Base64.getEncoder().encodeToString(outPut.toByteArray()).replace("\r\n", "");
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (inStream != null) {
                try {
                    inStream.close();
                } catch (IOException e) {
                    Tracker.error(e);
                }
            }
            if (outPut != null) {
                try {
                    outPut.close();
                } catch (IOException e) {
                    Tracker.error(e);
                }
            }

        }
        return "fail";
    }

    public static void readLocalFiles(String filePath) {
        File file = new File(filePath);
        File[] files = file.listFiles();
        List<String> stringList = new ArrayList();
        for (File f : files) {
            stringList.add(f.getName().substring(0, f.getName().lastIndexOf(".")));
        }
    }

    public static void main(String[] agrs) {
        //System.out.println(File2Base64("C:\\Users\\dicky\\Desktop\\svg\\touxiang\\2.jpg"));
        //readLocalFiles("C:\\Users\\dicky\\Desktop\\svg\\touxiang");
    }
}
