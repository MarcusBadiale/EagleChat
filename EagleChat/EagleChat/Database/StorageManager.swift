//
//  StorageManager.swift
//  EagleChat
//
//  Created by Marcus Vinicius Vieira Badiale on 18/05/21.
//

import Foundation
import FirebaseStorage

extension StorageManager {
    typealias UploadPictureCompletion = (Result<String, StorageErrors>) -> Void
}

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public func uploadProfilePicture(
        with data: Data,
        filename: String,
        completion: @escaping UploadPictureCompletion
    ) {
        storage.child("images/\(filename)").putData(data, metadata: nil) { [weak self] metaData, error in
            guard error == nil else {
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self?.storage.child("images/\(filename)").downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("Downloaded url", urlString)
                completion(.success(urlString))
            }
        }
    }
}

extension StorageManager {
    enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
}