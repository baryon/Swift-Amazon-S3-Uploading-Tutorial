//
//  S3Uploader.swift
//  AmazonS3Upload
//
//  Created by Long Li on 2019/01/29.
//  Copyright © 2019 ChainBow.io. All rights reserved.
//

import Foundation
import AWSS3
import AWSCore
import PromiseKit

class S3Uploader {
    
    let bucketName: String!
    
    init(accessKey: String, secretKey: String, bucketName: String, region: AWSRegionType) {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region:region, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        self.bucketName = bucketName
    }
    
    func upload(localFileURL: URL, progressBlock: AWSS3TransferUtilityProgressBlock? = nil) -> Promise<String> {
        let transfer = AWSS3TransferUtility.default()
        
        return Promise { seal in
            
            let completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock = { (task, error) -> Void in
                if let error = error {
                    print("Failed with error: \(error)")
                    seal.reject(error)
                }else{
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(self.bucketName).appendingPathComponent(localFileURL.lastPathComponent)
                    if let absoluteString = publicURL?.absoluteString {
                        print("Uploaded to:\(absoluteString)")
                        seal.fulfill(absoluteString)
                    }
                    
                }
            }
            
            
            let expression = AWSS3TransferUtilityUploadExpression()
            
            expression.progressBlock = progressBlock
            
            transfer.uploadFile(localFileURL, bucket: self.bucketName, key: localFileURL.lastPathComponent, contentType: "image/jpeg", expression: expression, completionHandler: completionHandler)
                .continueWith { (task) -> AnyObject? in
                    if let error = task.error {
                        print("Error: \(error.localizedDescription)")
                        seal.reject(error)
                    }
                    
                    if let _ = task.result {
                        
                        print("Upload Starting!")
                    }
                    
                    return nil;
            }
            
        }
        
    }
    
}
