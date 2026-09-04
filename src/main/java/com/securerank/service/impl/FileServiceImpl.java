package com.securerank.service.impl;

import com.securerank.dto.response.ApiResponse;
import com.securerank.dto.response.FileMetadataResponse;
import com.securerank.dto.response.KeyRequestResponse;
import com.securerank.dto.response.SearchResultResponse;
import com.securerank.entity.*;
import com.securerank.repository.FileKeyRepository;
import com.securerank.repository.KeyRequestRepository;
import com.securerank.repository.UploadedFileRepository;
import com.securerank.repository.UserRepository;
import com.securerank.service.FileService;
import com.securerank.util.AESCryptoUtils;
import com.securerank.util.TFIDFUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class FileServiceImpl implements FileService {

    private final UploadedFileRepository uploadedFileRepository;
    private final FileKeyRepository fileKeyRepository;
    private final KeyRequestRepository keyRequestRepository;
    private final UserRepository userRepository;
    private final AESCryptoUtils aesCryptoUtils;
    private final TFIDFUtils tfidfUtils;

    @Override
    @Transactional
    public ApiResponse uploadFile(MultipartFile file, String label, String keywords, String ownerEmail) {
        try {
            User owner = userRepository.findByEmail(ownerEmail)
                    .orElseThrow(() -> new RuntimeException("Owner not found: " + ownerEmail));

            byte[] originalBytes = file.getBytes();
            String masterKey = aesCryptoUtils.generateMasterKey();
            byte[] encryptedBytes = aesCryptoUtils.encrypt(originalBytes, masterKey);

            String textContent = "";
            try {
                textContent = new String(originalBytes, StandardCharsets.UTF_8);
            } catch (Exception ignored) {
            }

            String indexVector = tfidfUtils.buildIndexVector(textContent, keywords);
            String trapdoorKey = aesCryptoUtils.generateTrapdoor(keywords != null && !keywords.isEmpty() ? keywords : file.getOriginalFilename());

            UploadedFile uploadedFile = UploadedFile.builder()
                    .filename(file.getOriginalFilename())
                    .label(label)
                    .fileType(file.getContentType())
                    .fileSize(file.getSize())
                    .encryptedBytes(encryptedBytes)
                    .encryptedSummary(keywords)
                    .indexVector(indexVector)
                    .trapdoorKey(trapdoorKey)
                    .owner(owner)
                    .build();

            UploadedFile savedFile = uploadedFileRepository.save(uploadedFile);

            FileKey fileKey = FileKey.builder()
                    .file(savedFile)
                    .masterKey(masterKey)
                    .build();
            fileKeyRepository.save(fileKey);

            log.info("Uploaded and encrypted file: {} (ID: {}) for owner: {}", savedFile.getFilename(), savedFile.getId(), ownerEmail);

            return ApiResponse.builder()
                    .success(true)
                    .message("File uploaded, encrypted with AES-256, and indexed successfully!")
                    .build();
        } catch (Exception e) {
            log.error("File upload failed: {}", e.getMessage());
            return ApiResponse.builder()
                    .success(false)
                    .message("Upload failed: " + e.getMessage())
                    .build();
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<FileMetadataResponse> getMyFiles(String ownerEmail) {
        User owner = userRepository.findByEmail(ownerEmail)
                .orElseThrow(() -> new RuntimeException("Owner not found: " + ownerEmail));

        return uploadedFileRepository.findByOwnerOrderByUploadedAtDesc(owner)
                .stream()
                .map(f -> FileMetadataResponse.builder()
                        .id(f.getId())
                        .filename(f.getFilename())
                        .label(f.getLabel())
                        .fileType(f.getFileType())
                        .fileSize(f.getFileSize())
                        .ownerName(f.getOwner().getName())
                        .ownerEmail(f.getOwner().getEmail())
                        .uploadedAt(f.getUploadedAt())
                        .build())
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<SearchResultResponse> searchFiles(String query, String consumerEmail) {
        if (query == null || query.trim().isEmpty()) {
            return Collections.emptyList();
        }

        List<String> keywords = Arrays.stream(query.toLowerCase().split("[,\\s]+"))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .collect(Collectors.toList());

        List<UploadedFile> allFiles = uploadedFileRepository.findAll();
        long totalDocs = allFiles.size();

        User consumer = consumerEmail != null ? userRepository.findByEmail(consumerEmail).orElse(null) : null;

        List<SearchResultResponse> results = new ArrayList<>();

        for (UploadedFile file : allFiles) {
            double score = tfidfUtils.calculateRelevanceScore(file.getIndexVector(), keywords, totalDocs);
            if (score > 0.0) {
                String requestStatus = null;
                if (consumer != null) {
                    Optional<KeyRequest> reqOpt = keyRequestRepository.findByFileAndConsumer(file, consumer);
                    if (reqOpt.isPresent()) {
                        requestStatus = reqOpt.get().getStatus().name();
                    }
                }

                results.add(SearchResultResponse.builder()
                        .id(file.getId())
                        .filename(file.getFilename())
                        .label(file.getLabel())
                        .fileType(file.getFileType())
                        .fileSize(file.getFileSize())
                        .ownerEmail(file.getOwner().getEmail())
                        .score(score)
                        .keyRequestStatus(requestStatus)
                        .uploadedAt(file.getUploadedAt())
                        .build());
            }
        }

        // Rank by score descending
        results.sort((a, b) -> Double.compare(b.getScore(), a.getScore()));

        for (int i = 0; i < results.size(); i++) {
            results.get(i).setRank(i + 1);
        }

        return results;
    }

    @Override
    @Transactional
    public ApiResponse requestFileKey(Long fileId, String consumerEmail) {
        User consumer = userRepository.findByEmail(consumerEmail)
                .orElseThrow(() -> new RuntimeException("Consumer not found: " + consumerEmail));

        UploadedFile file = uploadedFileRepository.findById(fileId)
                .orElseThrow(() -> new RuntimeException("File not found with ID: " + fileId));

        Optional<KeyRequest> existing = keyRequestRepository.findByFileAndConsumer(file, consumer);
        if (existing.isPresent()) {
            RequestStatus status = existing.get().getStatus();
            if (status == RequestStatus.PENDING) {
                return ApiResponse.builder().success(false).message("Key request already submitted and is pending approval.").build();
            } else if (status == RequestStatus.APPROVED) {
                return ApiResponse.builder().success(true).message("Key request was already approved! You can download the file.").build();
            }
        }

        KeyRequest request = existing.orElseGet(() -> KeyRequest.builder()
                .file(file)
                .consumer(consumer)
                .status(RequestStatus.PENDING)
                .build());

        request.setStatus(RequestStatus.PENDING);
        keyRequestRepository.save(request);

        log.info("Consumer {} requested key for file ID {}", consumerEmail, fileId);

        return ApiResponse.builder()
                .success(true)
                .message("Key request submitted to Admin successfully!")
                .build();
    }

    @Override
    @Transactional(readOnly = true)
    public List<KeyRequestResponse> getMyKeyRequests(String consumerEmail) {
        User consumer = userRepository.findByEmail(consumerEmail)
                .orElseThrow(() -> new RuntimeException("Consumer not found: " + consumerEmail));

        return keyRequestRepository.findByConsumerOrderByRequestedAtDesc(consumer)
                .stream()
                .map(req -> {
                    String masterKey = null;
                    if (req.getStatus() == RequestStatus.APPROVED) {
                        masterKey = fileKeyRepository.findByFile(req.getFile())
                                .map(FileKey::getMasterKey)
                                .orElse(null);
                    }

                    return KeyRequestResponse.builder()
                            .requestId(req.getId())
                            .fileId(req.getFile().getId())
                            .filename(req.getFile().getFilename())
                            .label(req.getFile().getLabel())
                            .ownerEmail(req.getFile().getOwner().getEmail())
                            .consumerName(req.getConsumer().getName())
                            .consumerEmail(req.getConsumer().getEmail())
                            .status(req.getStatus())
                            .masterKey(masterKey)
                            .requestedAt(req.getRequestedAt())
                            .approvedAt(req.getApprovedAt())
                            .build();
                })
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public byte[] downloadAndDecryptFile(Long fileId, String userEmail) {
        UploadedFile file = uploadedFileRepository.findById(fileId)
                .orElseThrow(() -> new RuntimeException("File not found with ID: " + fileId));

        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found: " + userEmail));

        boolean isOwner = file.getOwner().getId().equals(user.getId());
        boolean isAdmin = user.getRole() == Role.ROLE_ADMIN || user.getRole() == Role.ROLE_PKG;

        if (!isOwner && !isAdmin) {
            KeyRequest request = keyRequestRepository.findByFileAndConsumer(file, user)
                    .orElseThrow(() -> new AccessDeniedException("Access Denied: You have not requested access to this file."));

            if (request.getStatus() != RequestStatus.APPROVED) {
                throw new AccessDeniedException("Access Denied: Key request is not approved yet.");
            }
        }

        FileKey fileKey = fileKeyRepository.findByFile(file)
                .orElseThrow(() -> new RuntimeException("Master decryption key not found for file ID: " + fileId));

        log.info("Decrypting and serving file: {} for user: {}", file.getFilename(), userEmail);
        return aesCryptoUtils.decrypt(file.getEncryptedBytes(), fileKey.getMasterKey());
    }

    @Override
    @Transactional(readOnly = true)
    public UploadedFile getFileById(Long fileId) {
        return uploadedFileRepository.findById(fileId)
                .orElseThrow(() -> new RuntimeException("File not found with ID: " + fileId));
    }
}
