//
//  ViewController.swift
//  AmazonS3Upload
//
//  Created by Maxim on 12/18/16.
//  Copyright © 2016 maximbilan. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore
import PromiseKit

class ViewController: UIViewController {
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func uploadButtonAction(_ sender: UIButton) {
        uploadButton.isHidden = true
        activityIndicator.startAnimating()
        
        let accessKey = "YOUR_IAM_USER_ACCESSKEY"
        let secretKey = "YOUR_IAM_USER_SECRETKEY"
        let S3BucketName = "YOUR_S3_BUCKETNAME"
        let remoteName = "test.jpg"
        let region = AWSRegionType.USWest1 //Your S3 Bucket's region, PLEASE CHECK IT CORRECTLY
        
        let uploader = S3Uploader(accessKey: accessKey, secretKey: secretKey, bucketName: S3BucketName, region: region)
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteName)
        let image = UIImage(named: "test")
        let data = image!.jpegData(compressionQuality: 0.9)
        do {
            try data?.write(to: fileURL)
        }
        catch {}
        
        let progressBlock: AWSS3TransferUtilityProgressBlock = {(task, progress) in
            print(progress)
        }
        
        firstly {
            uploader.upload(localFileURL: fileURL, progressBlock: progressBlock)
            }
            .done { (publicUrl) in
                print(publicUrl)
            }
            .catch { (error) in
                print(error)
                
            }
            .finally {
                DispatchQueue.main.async {
                    self.uploadButton.isHidden = false
                    self.activityIndicator.stopAnimating()
                }
        }
    }
    
}

