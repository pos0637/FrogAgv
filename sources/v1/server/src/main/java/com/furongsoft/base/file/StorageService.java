package com.furongsoft.base.file;

import com.furongsoft.base.exceptions.BaseException;
import com.furongsoft.base.file.entities.Attachment;
import com.furongsoft.base.file.mappers.AttachmentDao;
import com.furongsoft.base.misc.SnowflakeIdWorker;
import com.furongsoft.base.misc.StringUtils;
import com.furongsoft.base.misc.Tracker;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.io.Serializable;

/**
 * 文件存储服务
 *
 * @author Alex
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class StorageService {
    private final AttachmentDao attachmentDao;

    @Value("${upload.url}")
    private String uploadUrl;

    @Value("${upload.path}")
    private String uploadPath;

    @Value("${upload.file-type}")
    private String uploadType;

    @Autowired
    public StorageService(AttachmentDao attachmentDao) {
        this.attachmentDao = attachmentDao;
    }

    /**
     * 上传文件
     *
     * @param file 文件
     * @return 文件索引
     * @throws BaseException 异常
     */
    public Attachment uploadFile(MultipartFile file) throws BaseException {
        String[] imageTypes = uploadType.split(",");
        Attachment attachment = new Attachment("", "", "", 0, "", 0, "");

        String fileName = file.getOriginalFilename().toLowerCase();
        String suffixName = fileName.substring(fileName.lastIndexOf("."));
        String newName = SnowflakeIdWorker.getInstance().nextId() + suffixName;
        if (StringUtils.isNullOrEmpty(fileName) || StringUtils.isNullOrEmpty(suffixName)) {
            throw new BaseException("上传文件名不能为空/后缀名为空");
        }

        boolean check = false;
        for (String type : imageTypes) {
            if (type.equals(suffixName)) {
                check = true;
                break;
            }
        }

        if (!check) {
            throw new BaseException("文件上传类型不正确。");
        }

        // 文件名规则: 父路径 + UUID + 扩展名
        try {
            File parent = new File(uploadPath);
            File target = new File(String.format("%s/%s", parent.getAbsolutePath(), newName));
            if (!target.getParentFile().exists()) {
                if (!target.getParentFile().mkdirs()) {
                    throw new BaseException.UploadFileFailException();
                }
            }

            file.transferTo(target);
        } catch (IllegalStateException | IOException e) {
            Tracker.error(e);
            throw new BaseException.UploadFileFailException();
        }

        attachment.setName(newName);
        attachment.setType(suffixName);
        attachment.setSize(file.getSize());
        attachment.setHash("");
//        attachment.setUrl(DataMemoryManager.getInstance().getConfig().getAttachmentServer() + newName);
        attachment.setShowName(fileName);
        attachmentDao.insert(attachment);
        return attachment;
    }

    /**
     * 上传本地文件
     *
     * @param file 本地文件路径
     * @return 上传实体类
     */
    public Attachment uploadLocalFile(File file) {
        Attachment attachment = new Attachment("", "", "", 0, "", 0, "");
        String fileName = file.getName();
        String suffixName = fileName.substring(fileName.lastIndexOf("."));
        String newName = SnowflakeIdWorker.getInstance().nextId() + suffixName;

        // 文件名规则: 父路径 + UUID + 扩展名
        try {
            File parent = new File(uploadPath);
            File target = new File(String.format("%s/%s", parent.getAbsolutePath(), newName));
            if (!target.getParentFile().exists()) {
                if (!target.getParentFile().mkdirs()) {
                    throw new BaseException.UploadFileFailException();
                }
            }

            file.renameTo(target);
        } catch (IllegalStateException e) {
            Tracker.error(e);
            throw new BaseException.UploadFileFailException();
        }

        attachment.setName(newName);
        attachment.setType(suffixName);
        attachment.setSize(file.length());
        attachment.setHash("");
        attachment.setShowName(fileName);
        attachmentDao.insert(attachment);
        return attachment;
    }

    /**
     * 根据文件名称获取索引
     *
     * @param name 文件名称
     * @return 索引
     * @throws BaseException 异常
     */
    public Serializable getFileId(String name) throws BaseException {
        if (StringUtils.isNullOrEmpty(name)) {
            return null;
        }

        Attachment attachment = attachmentDao.selectOne(new Attachment(name));
        if (attachment == null) {
            throw new BaseException.IllegalArgumentException();
        }

        return attachment.getId();
    }

    /**
     * 获取文件URL地址
     *
     * @param request 请求
     * @param name    文件名
     * @return 文件URL地址
     */
    public String getUrl(HttpServletRequest request, String name) {
        if (StringUtils.isNullOrEmpty(name)) {
            return "";
        }

        return String.format("%s://%s:%s%s/%s", request.getScheme(), request.getServerName(), request.getServerPort(), uploadUrl, name);
    }

    /**
     * 根据索引查询文件全路径
     *
     * @param id 索引
     * @return 全路径
     */
    public String getFullPath(Serializable id) {
        if (StringUtils.isNullOrEmpty(id)) {
            return "";
        }
        return attachmentDao.selectFullPath(id);
    }
}
