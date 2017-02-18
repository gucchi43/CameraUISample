//
//  ViewController.swift
//  CameraUISample
//
//  Created by HIroki Taniguti on 2017/02/19.
//  Copyright © 2017年 HIroki Taniguti. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {


    @IBOutlet weak var cameraView: UIView!

    var captuereSession : AVCaptureSession!
    var stillImageOutput : AVCapturePhotoOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {

        captuereSession = AVCaptureSession()
        stillImageOutput = AVCapturePhotoOutput()

        // 解像度の設定
        captuereSession.sessionPreset = AVCaptureSessionPreset1920x1080

        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)

        do {
            let input = try AVCaptureDeviceInput(device: device)

            //入力
            if captuereSession.canAddInput(input){
                captuereSession.addInput(input)

                //出力
                if captuereSession.canAddOutput(stillImageOutput) {
                    captuereSession.addOutput(stillImageOutput)
                    captuereSession.startRunning() //カメラ起動

                    previewLayer = AVCaptureVideoPreviewLayer(session: captuereSession)
                    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect //アスペクトフィット
                    previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait //カメラの向き

                    cameraView.layer.addSublayer(previewLayer!)

                    // ビューのサイズの調整
                    previewLayer?.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                    previewLayer?.bounds = cameraView.frame
                }
            }
        }
        catch{
            print(error)
        }

    }

    @IBAction func takePicture(_ sender: Any) {
        // フラッシュとかカメラの細かな設定
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        // シャッターを切る
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }


    // デリゲート。カメラで撮影が完了した後呼ばれる。JPEG形式でフォトライブラリに保存。
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {

        if let photoSampleBuffer = photoSampleBuffer {
            // JPEG形式で画像データを取得
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let image = UIImage(data: photoData!)

            // フォトライブラリに保存
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

