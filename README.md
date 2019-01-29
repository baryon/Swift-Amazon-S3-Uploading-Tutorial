# How to upload a file to Amazon S3 using Swift, Support PromiseKit and Progress callback

I would like to share a simple tutorial how to upload a to <a href="https://github.com/aws/aws-sdk-ios">Amazon S3</a> in <i>iOS</i> using <i>Swift</i>. Let’s go.

![alt tag](https://raw.github.com/maximbilan/Swift-Amazon-S3-Uploading-Tutorial/master/img/img1.png)

We need to add <a href="https://github.com/aws/aws-sdk-ios">Amazon S3</a> framework to your project.<br>
In this example I will do this with helping <a href="https://cocoapods.org">Cocoapods</a>.

Create a <i>Podfile</i>:

<pre>
platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!
target 'AmazonS3Upload' do
pod 'AWSS3'
pod 'PromiseKit'
end
</pre>

Run the next command from <i>Terminal</i>:

<pre>
pod install
</pre>

Open the generated workspace. And after that we can implement uploading of files using frameworks from <i>Pods</i>.

Create an upload request:

<pre>
        let accessKey = "YOUR_IAM_USER_ACCESSKEY"
        let secretKey = "YOUR_IAM_USER_SECRETKEY"
        let S3BucketName = "YOUR_S3_BUCKETNAME"
        let region = AWSRegionType.USWest1 //Your S3 Bucket's region, PLEASE CHECK IT CORRECTLY

        let uploader = S3Uploader(accessKey: accessKey, secretKey: secretKey, bucketName: S3BucketName, region: region)
</pre>

And upload using <i>uploader</i>.

<pre>
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
                }
        }
</pre>
