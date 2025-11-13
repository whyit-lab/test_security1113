package com.kt.arcus.common.controller;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;
import java.util.regex.Pattern;

import com.kt.arcus.common.util.MediaUtils;
import com.kt.arcus.common.util.ArcusConstants;
import com.kt.arcus.common.util.CommonFunctions;
import com.kt.arcus.common.util.UploadFileUtils;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/upload/*")
public class UploadController {
    
    private static final Logger logger = LoggerFactory.getLogger(UploadController.class);

    private static final Pattern relPathPattern = Pattern.compile("\\.\\.\\/");
    
    private String uploadPath = ArcusConstants.ARCUS_UPLOAD_PATH;
    
    @RequestMapping(value = "/uploadForm", method = RequestMethod.GET)
    public String uploadFormGET() {
        return "/upload/uploadForm";
    }
    
    //Post 방식 파일 업로드
    @RequestMapping(value = "/uploadForm", method = RequestMethod.POST)
    public String uploadFormPOST(MultipartFile file, Model model) throws Exception {
        logger.info("uploadFormPost");
        
        if(file != null) {
            logger.info("originalName:" + file.getOriginalFilename());
            logger.info("size:" + file.getSize());
            logger.info("ContentType:" + file.getContentType());
        
            String savedName = uploadFile(file.getOriginalFilename(), file.getBytes());
            model.addAttribute("savedName", savedName);
        }
        
        return "/upload/uploadForm";
    }
    
    //업로드된 파일을 저장하는 함수
    private String uploadFile(String originalName, byte[] fileDate) throws IOException {
        // Validate the original filename to prevent directory traversal and absolute paths
        if (originalName.contains("..") || originalName.contains("/") || originalName.contains("\\")) {
            logger.warn("Invalid filename for upload: {}", originalName);
            throw new IllegalArgumentException("Invalid filename");
        }
        UUID uid = UUID.randomUUID();
        
        String savedName = uid.toString() + "_" + originalName;
        File target = new File(uploadPath, savedName);
        
        //org.springframework.util 패키지의 FileCopyUtils는 파일 데이터를 파일로 처리하거나, 복사하는 등의 기능이 있다.
        FileCopyUtils.copy(fileDate, target);
        
        return savedName;
    }
    
    // //Ajax 파일 업로드
    // @RequestMapping(value="/uploadAjax", method = RequestMethod.GET)
    // public String uploadAjaxGET() {
        // 	return "/upload/uploadAjax";
        // }
        
    //Ajax 파일 업로드 produces는 한국어를 정상적으로 전송하기 위한 속성
    @ResponseBody
    @RequestMapping(value="/uploadAjax", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
    public ResponseEntity<String> uploadAjaxPOST(MultipartFile file) throws Exception {
        
        logger.info("originalName:" + file.getOriginalFilename());
        logger.info("size:" + file.getSize());
        logger.info("contentType:" + file.getContentType());
        
        //String savedName = uploadFile(file.getOriginalFilename(), file.getBytes()); // hjchoi 이 부분은 원본 참조문서 부터 주석임
        
        //HttpStatus.CREATED : 리소스가 정상적으로 생성되었다는 상태코드.
        //return new ResponseEntity<>(file.getOriginalFilename(), HttpStatus.CREATED);
        return new ResponseEntity<>(UploadFileUtils.uploadFile(uploadPath, file.getOriginalFilename(), file.getBytes()), HttpStatus.CREATED);
    }
    
    //화면에 저장된 파일을 보여주는 컨트롤러 /년/월/일/파일명 형태로 입력 받는다.
    // displayFile?fileName=/년/월/일/파일명
    @ResponseBody
    @RequestMapping(value="/displayFile", method = RequestMethod.GET)
    public ResponseEntity<byte[]> displayFile(String fileName) throws Exception {
        if (relPathPattern.matcher(fileName).find())
            throw new Exception("Invalid Access");
        if (fileName == null)
            throw new Exception("null fileName");

        InputStream in = null;
        ResponseEntity<byte[]> entity = null;
        
        try {
            String formatName = fileName.substring(fileName.lastIndexOf(".")+1);
            MediaType mType = MediaUtils.getMediaType(formatName);
            HttpHeaders headers = new HttpHeaders();

            String path = uploadPath + CommonFunctions.safeFileName(fileName);
            if (! CommonFunctions.isSafePath(path)) {
                logger.error("UploadController.displayFile, " + fileName);
                return new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
            }

            in = new FileInputStream(path);
            
            if(mType != null) {
                headers.setContentType(mType);
            }else {
                fileName = fileName.substring(fileName.indexOf("_")+1);
                headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
                headers.add("Content-Disposition", "attachment; filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");
            }// else
            
            entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
        } catch(IOException e) {
            logger.error("UploadController.displayFile, " + fileName);
            e.printStackTrace();
            entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
        } finally {
            if (null != in)
                in.close();
        }
        
        return entity;
    }// displayFile
    
    //업로드된 파일 삭제 처리
    @ResponseBody
    @RequestMapping(value="/deleteFile", method = RequestMethod.POST)
    public ResponseEntity<String> deleteFile(String fileName) throws Exception {
        if (fileName == null || fileName.isEmpty())
            throw new Exception("Invalid File Access");
        // Universal validation: reject dangerous file names
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\"))
            throw new Exception("Invalid File Name");

        String formatName = fileName.substring(fileName.lastIndexOf(".")+1);
        MediaType mType = MediaUtils.getMediaType(formatName);
        
        if(mType != null) {
            String front = fileName.substring(0, 12);
            String end = fileName.substring(14);
            String combined = front + end;
            if (combined.contains("..") || combined.contains("/") || combined.contains("\\")) {
                throw new Exception("Invalid File Name");
            }
            // Robust path validation: ensure deletion target is inside uploadPath
            File deleteTarget = new File(uploadPath, combined.replace('/', File.separatorChar)).getCanonicalFile();
            File uploadDir = new File(uploadPath).getCanonicalFile();
            if (!deleteTarget.getPath().startsWith(uploadDir.getPath()))
                throw new Exception("Invalid File Access " + deleteTarget.getPath());
            deleteTarget.delete();
        }//if
        
        return new ResponseEntity<String>("deleted", HttpStatus.OK);
    }
}
    