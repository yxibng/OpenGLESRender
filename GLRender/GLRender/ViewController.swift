//
//  ViewController.swift
//  GLRender
//
//  Created by yxibng on 2023/11/17.
//

import UIKit
import CoreMedia

class ViewController: UIViewController {

    

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var renderView: GLRenderView!
    lazy var  camService = CameraFeedService.init(previewView: self.previewView)
    
    
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
        
        func toGLVideoRotation(orientation: UIImage.Orientation) -> GLVideoRotation {
            switch orientation {
            case .up, .upMirrored:
                return GLVideoRotation0
            case .down, .downMirrored:
                return GLVideoRotation180
            case .left, .leftMirrored:
                return GLVideoRotation270
            case .right, .rightMirrored:
                return GLVideoRotation90
            @unknown default:
                return GLVideoRotation0
            }
        }
        
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return  }
        let videoFrame = GLVideoFrame.init(pixelBuffer: pixelBuffer, rotation: toGLVideoRotation(orientation: orientation))
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
