
import UIKit
import AVFoundation
class QRCodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var Square: UIImageView!
    @IBOutlet weak var Menu: UIBarButtonItem!
    var Video = AVCaptureVideoPreviewLayer()
    //creating session
    let session = AVCaptureSession()
    override func viewDidLoad() {
        super.viewDidLoad()
        ScanQRCode()
        OpenSideMenu()
    }
    
    func ScanQRCode(){
        //Define capture device
        let CaptureDevice =  AVCaptureDevice.default(for:AVMediaType.video)
        do{
            let input = try AVCaptureDeviceInput(device:CaptureDevice!)
            session.addInput(input)
        }catch{
            print("Some Error occured")
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        Video = AVCaptureVideoPreviewLayer(session: session)
        Video.frame = view.layer.bounds
        view.layer.addSublayer(Video)
        Square.layer.borderWidth = 2
        Square.layer.borderColor = UIColor.blue.cgColor
        self.view.bringSubviewToFront(Square)
        session.startRunning()
    }
    
   @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0{
            if let objects = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if objects.type == AVMetadataObject.ObjectType.qr{
                    let alert = UIAlertController(title: "QR Code", message: objects.stringValue, preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "Retake", style: UIAlertAction.Style.default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
                        UIPasteboard.general.string = objects.stringValue
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
}


//for side menu revealviewcontroller
extension QRCodeViewController:SWRevealViewControllerDelegate{
    func OpenSideMenu()  {
        //Actions for the SideMenu.
        Menu.target = revealViewController()
        Menu.action = #selector(SWRevealViewController.revealToggle(_:))
        //set the delegate to teh SWRevealviewcontroller
        revealViewController().delegate = self
        self.revealViewController().rearViewRevealWidth = 150
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    //for dissable homescreen
    public func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        let tagId = 112151
        if revealController.frontViewPosition == FrontViewPosition.right {
            let lock = self.view.viewWithTag(tagId)
            UIView.animate(withDuration: 0.25, animations: {
                lock?.alpha = 0
            }, completion: {(finished: Bool) in
                lock?.removeFromSuperview()
            })
            lock?.removeFromSuperview()
        } else if revealController.frontViewPosition == FrontViewPosition.left {
            let lock = UIView(frame: self.view.bounds)
            lock.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            lock.tag = tagId
            lock.alpha = 0
            lock.backgroundColor = UIColor.black
            lock.addGestureRecognizer(UITapGestureRecognizer(target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
            self.view.addSubview(lock)
            UIView.animate(withDuration: 0.75, animations: {
                lock.alpha = 0.333})
        }}
}
