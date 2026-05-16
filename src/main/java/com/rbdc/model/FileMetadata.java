package com.rbdc.model;

import java.sql.Timestamp;

public class FileMetadata {

    private int fileId;
    private String fileName;
    private String ownerEmail;
    private String contentType;
    private long fileSize;
    private Timestamp uploadDate;
    private String secretKey;

    public FileMetadata() {

    }

    public FileMetadata(int fileId, String fileName,
                        String ownerEmail,
                        String contentType,
                        long fileSize,
                        Timestamp uploadDate,
                        String secretKey) {

        this.fileId = fileId;
        this.fileName = fileName;
        this.ownerEmail = ownerEmail;
        this.contentType = contentType;
        this.fileSize = fileSize;
        this.uploadDate = uploadDate;
        this.secretKey = secretKey;
    }

    public int getFileId() {
        return fileId;
    }

    public void setFileId(int fileId) {
        this.fileId = fileId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getOwnerEmail() {
        return ownerEmail;
    }

    public void setOwnerEmail(String ownerEmail) {
        this.ownerEmail = ownerEmail;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public long getFileSize() {
        return fileSize;
    }

    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }

    public Timestamp getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(Timestamp uploadDate) {
        this.uploadDate = uploadDate;
    }

    public String getSecretKey() {
        return secretKey;
    }

    public void setSecretKey(String secretKey) {
        this.secretKey = secretKey;
    }
}