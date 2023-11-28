//
//  ViewController.swift
//  GLRender
//
//  Created by yxibng on 2023/11/17.
//

import UIKit
import CoreMedia

class ViewController: UIViewController {

    

    @IBOutlet weak var renderView: GLRenderView!
    lazy var  camService = CameraFeedService.init(previewView: self.view)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camService.startLiveCameraSession { cameraConfiguration in
            print(cameraConfiguration)
        }
        
        camService.delegate = self
        
    }


}


extension ViewController : CameraFeedServiceDelegate {
    func didOutput(sampleBuffer: CMSampleBuffer, orientation: UIImage.Orientation) {
        
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return  }
        let videoFrame = GLVideoFrame.init(pixelBuffer: pixelBuffer, rotation: GLVideoRotation0)
        DispatchQueue.main.async {
            self.renderView .renderVideoFrame(videoFrame)
        }
    }
    
    func didEncounterSessionRuntimeError() {
        
    }
    
    func sessionWasInterrupted(canResumeManually resumeManually: Bool) {
        
    }
    
    func sessionInterruptionEnded() {
        
    }
}
