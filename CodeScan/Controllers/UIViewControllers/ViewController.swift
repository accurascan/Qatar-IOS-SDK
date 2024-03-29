
import UIKit
import AVFoundation
import AccuraQatar

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var _viewLayer: UIView!
    @IBOutlet weak var _imageView: UIImageView!
    @IBOutlet weak var _imgFlipView: UIImageView!
    @IBOutlet weak var _lblTitle: UILabel!
    @IBOutlet weak var _constant_height: NSLayoutConstraint!
    @IBOutlet weak var _constant_width: NSLayoutConstraint!
    
    @IBOutlet weak var lblOCRMsg: UILabel!
    @IBOutlet weak var lblTitleCountryName: UILabel!
    
    @IBOutlet weak var viewStatusBar: UIView!
    @IBOutlet weak var viewNavigationBar: UIView!
    @IBOutlet weak var collcetionViewFieldList: UICollectionView!
    
    var accuraCameraWrapper: AccuraCameraWrapper? = nil
    
    var shareScanningListing: NSMutableDictionary = [:]
    var arrReuiredField = [String]()
    var arrRecognizedField = [String]()
    
    var documentImage: UIImage? = nil
    var docfrontImage: UIImage? = nil
    
    var frontImageRotation = ""
    var backImageRotation = ""
    
    var docName = "Document"
    
    
    //MARK:- Variable
    var cardid : Int? = 0
    var countryid : Int? = 0
    var imgViewCard : UIImage?
    var isCheckCard : Bool = false
    var isCheckCardMRZ : Bool = false
    var isCheckcardBack : Bool = false
    var isCheckCardBackFrint : Bool = false
    var isCheckScanOCR : Bool = false
    var arrCardSide : [String] = [String]()
    var isCardSide : Bool?
    var isBack : Bool?
    var isFront : Bool?
    var isConnection : Bool?
    var imgViewCardFront : UIImage?
    var dictSecuretyData : NSMutableDictionary = [:]
    var dictFaceDataFront: NSMutableDictionary = [:]
    var dictFaceDataBack: NSMutableDictionary = [:]
    var arrBackFrontImage : [UIImageView] = [UIImageView]()
    
    var stUrl : String?
    var arrimgCountData = [String]()
    
    var arrImageName : [String] = [String]()
    
    var dictScanningData:NSDictionary = NSDictionary()
    
    var isflipanimation : Bool?
    
    var isChangeMRZ : Bool?
    var imgPhoto : UIImage?
    
    var isCheckFirstTime : Bool?
    var mrzElementName: String = ""
    var dictScanningMRZData: NSMutableDictionary = [:]
    var setImage : Bool?
    var isFrontDataComplate: Bool?
    var isBackDataComplate: Bool?
    var stCountryCardName: String?
    var cardImage: UIImage?
    var isBackSide: Bool?
    
    var arrFrontResultKey : [String] = []
    var arrFrontResultValue : [String] = []
    var arrBackResultKey : [String] = []
    var arrBackResultValue : [String] = []
    var isCheckMRZData: Bool?
    var secondCallData: Bool?
    
    var isFirstTimeStartCamara: Bool?
    var countface = 0
//    let window = CGFloat()
    var bottomPadding = CGFloat()
    var topPadding = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let window = UIApplication.shared.windows.first
        bottomPadding = window!.safeAreaInsets.bottom
        topPadding = window!.safeAreaInsets.top
        collcetionViewFieldList.delegate = self
        collcetionViewFieldList.dataSource = self
        // Do any additional setup after loading the view.
        
        isFirstTimeStartCamara = false
        isCheckFirstTime = false
        viewStatusBar.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        viewNavigationBar.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        _imageView.layer.masksToBounds = false
        _imageView.clipsToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(ChangedOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
        var width : CGFloat = 0
        var height : CGFloat = 0
//        let window = UIApplication.shared.windows.first
        let bottomPadding = window!.safeAreaInsets.bottom
        let statusBarRect = UIApplication.shared.statusBarFrame
        width = UIScreen.main.bounds.size.width
        height = (UIScreen.main.bounds.size.height - statusBarRect.height - bottomPadding)
        width = width * 0.95
        height = height * 0.35
        _constant_width.constant = width
        _constant_height.constant = height
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        _viewLayer.layer.borderColor = UIColor.red.cgColor
        _viewLayer.layer.borderWidth = 3.0
        self._imgFlipView.isHidden = true
        if status == .authorized {
           isCheckFirstTime = true
            self.setOCRData()
            let shortTap = UITapGestureRecognizer(target: self, action: #selector(handleTapToFocus(_:)))
            shortTap.numberOfTapsRequired = 1
            shortTap.numberOfTouchesRequired = 1
            self.view.addGestureRecognizer(shortTap)
        } else if status == .denied {
            let alert = UIAlertController(title: "AccuraSdk", message: "It looks like your privacy settings are preventing us from accessing your camera.", preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "OK", style: .default) { _ in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
            alert.addAction(yesButton)
            self.present(alert, animated: true, completion: nil)
        } else if status == .restricted {
        } else if status == .notDetermined  {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                   self.isCheckFirstTime = true
                    self.isFirstTimeStartCamara = true
                    DispatchQueue.main.async {
                        self._imageView.setNeedsLayout()
                        self._imageView.layoutSubviews()
                        self.setOCRData()
                        if(self.isCheckScanOCR)
                        {

                        }
                        self.ChangedOrientation()
                        self.accuraCameraWrapper?.startCamera()
                    }
                    let shortTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapToFocus(_:)))
                    shortTap.numberOfTapsRequired = 1
                    shortTap.numberOfTouchesRequired = 1
                } else {
                    // print("Not granted access")
                }
            }
        }
         
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self._imageView.setNeedsLayout()
        self._imageView.layoutSubviews()
        self._imageView.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        countface = 0
        arrReuiredField.removeAll()
        arrRecognizedField.removeAll()
        collcetionViewFieldList.reloadData()
        self.shareScanningListing.removeAllObjects()
        isBackSide = false
        isCheckMRZData = false
         self.ChangedOrientation()
        if self.accuraCameraWrapper == nil {
                setOCRData()
        }

        if isFirstTimeStartCamara!{
            if(isCheckScanOCR)
            {

            }
          accuraCameraWrapper?.startCamera()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isFirstTimeStartCamara! && isCheckFirstTime!{
            if(isCheckScanOCR)
            {
            }
          isFirstTimeStartCamara = true
          accuraCameraWrapper?.startCamera()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        accuraCameraWrapper?.closeOCR()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        accuraCameraWrapper?.stopCamera()
        accuraCameraWrapper = nil
        _imageView.image = nil
        super.viewWillDisappear(animated)
    }
    
    @IBAction func backAction(_ sender: Any) {
        accuraCameraWrapper?.stopCamera()
        arrFrontResultKey.removeAll()
        arrBackResultKey.removeAll()
        arrFrontResultValue.removeAll()
        arrBackResultValue.removeAll()
        dictSecuretyData.removeAllObjects()
        dictFaceDataBack.removeAllObjects()
        dictFaceDataFront.removeAllObjects()
        dictScanningMRZData.removeAllObjects()
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Other Method
    func setOCRData(){
        arrFrontResultKey.removeAll()
        arrBackResultKey.removeAll()
        arrFrontResultValue.removeAll()
        arrBackResultValue.removeAll()
        dictSecuretyData.removeAllObjects()
        dictFaceDataBack.removeAllObjects()
        dictFaceDataFront.removeAllObjects()
        dictScanningMRZData.removeAllObjects()
        isCheckCard = false
        isCheckcardBack = false
        isCheckCardBackFrint = false
        isflipanimation = false
        imgPhoto = nil
        isFrontDataComplate = false
        isBackDataComplate = false
        DispatchQueue.main.async {
            self._lblTitle.text = "Scan Front Side of Document"
        }
        
        accuraCameraWrapper = AccuraCameraWrapper.init(delegate: self, andImageView: _imageView, andLabelMsg: lblOCRMsg, andurl: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String, cardId: Int32(cardid!), countryID: Int32(countryid!), isScanOCR: isCheckScanOCR, andLabelMsgTop: _lblTitle, andcardName: docName)
        accuraCameraWrapper?.setMinFrameForValidate(3)
        accuraCameraWrapper?.setMinFrameQatarName_IDNo_Validate(3)
    }
    
    @objc private func ChangedOrientation() {
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        width = UIScreen.main.bounds.size.width * 0.95
        let statusBarRect = UIApplication.shared.statusBarFrame
        height  = (UIScreen.main.bounds.size.height - (bottomPadding + topPadding + statusBarRect.height)) * 0.35
        _constant_width.constant = width
        _constant_height.constant = height
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                
            }
        }
    }
    
    
    @objc func handleTapToFocus(_ tapGesture: UITapGestureRecognizer?) {
        let acd = AVCaptureDevice.default(for: .video)
        if tapGesture!.state == .ended {
            let thisFocusPoint = tapGesture!.location(in: _viewLayer)
            let focus_x = Double(thisFocusPoint.x / _viewLayer.frame.size.width)
            let focus_y = Double(thisFocusPoint.y / _viewLayer.frame.size.height)
            if acd?.isFocusModeSupported(.autoFocus) ?? false && acd?.isFocusPointOfInterestSupported != nil {
                do {
                    try acd?.lockForConfiguration()
                    
                    if try acd?.lockForConfiguration() != nil {
                        acd?.focusMode = .autoFocus
                        acd?.focusPointOfInterest = CGPoint(x: CGFloat(focus_x), y: CGFloat(focus_y))
                        acd?.unlockForConfiguration()
                    }
                } catch {
                }
            }
        }
    }
    
    func flipAnimation() {
        self._imgFlipView.isHidden = false
        UIView.animate(withDuration: 1.5, animations: {
            UIView.setAnimationTransition(.flipFromLeft, for: self._imgFlipView, cache: true)
            AudioServicesPlaySystemSound(1315)
        }) { _ in
            self._imgFlipView.isHidden = true
        }
    }
}

extension ViewController: VideoCameraWrapperDelegate {
    func processedImage(_ image: UIImage!) {
        _imageView.image = image
    }
    
    func recognizeFailed(_ message: String!) {
        GlobalMethods.showAlertView(message, with: self)
    }
    
    
    func screenSound() {
        self.flipAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.arrRecognizedField.removeAll()
            self.arrReuiredField.removeAll()
            self.collcetionViewFieldList.reloadData()
        }
       
        self._lblTitle.text! = "Scan Back side of \(self.docName)"
    }
    
    func resultData(_ resultmodel: ResultModel!) {
        
        self.dictFaceDataFront = resultmodel.ocrFaceFrontData
        self.dictFaceDataBack = resultmodel.ocrFaceBackData
        self.dictSecuretyData = resultmodel.ocrSecurityData
        self.arrFrontResultKey = resultmodel.arrayocrFrontSideDataKey as! [String]
        self.arrFrontResultValue = resultmodel.arrayocrFrontSideDataValue as! [String]
        self.arrBackResultKey = resultmodel.arrayocrBackSideDataKey as! [String]
        self.arrBackResultValue = resultmodel.arrayocrBackSideDataValue as! [String]
        self.imgViewCardFront = resultmodel.frontSideImage
        self.imgViewCard = resultmodel.backSideImage
        self.imgPhoto = resultmodel.faceImage
       

        AudioServicesPlaySystemSound (1315);
        
        passDataOtherViewController()
    }
    
    
    func recognizeSucceed(_ scanedInfo: NSMutableDictionary!, recType: RecType, bRecDone: Bool, bFaceReplace: Bool, bMrzFirst: Bool, photoImage: UIImage, docFrontImage: UIImage!, docbackImage: UIImage!) {
        
                        
                AudioServicesPlaySystemSound(1315)
                
                self.shareScanningListing = scanedInfo
                let shareScanningListing: NSMutableDictionary = self.shareScanningListing
                self.docfrontImage = docFrontImage

                shareScanningListing["docfrontImage"] = docfrontImage?.jpegData(compressionQuality: 1.0)
                shareScanningListing["fontImageRotation"] = frontImageRotation

                let vc : ShowResultVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowResultVC") as! ShowResultVC
                vc.scannedData = shareScanningListing
                vc.stCountryCardName = stCountryCardName
                vc.imageCountryCard = cardImage
                vc.isBackSide = isBackSide
                self.navigationController?.pushViewController(vc, animated: true)
        
        }
    
    func recognizeProcess(_ requiredFields: NSMutableArray!, recognizedFields: NSMutableArray!) {
        arrReuiredField = requiredFields as! [String]
        if(recognizedFields != nil) {
            arrRecognizedField = recognizedFields as! [String]
        }
       
        collcetionViewFieldList.reloadData()
    }
 
    
    func passDataOtherViewController(){
        let vc : ShowResultVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowResultVC") as! ShowResultVC
        vc.imgViewCountryCard = self.imgViewCard
        vc.imgViewBack = self.imgViewCard
        vc.imgViewFront = self.imgViewCardFront
        vc.dictScanningData = self.dictScanningData
        vc.pageType = .ScanOCR
        vc.imagePhoto = self.imgPhoto
        vc.scannedData = dictScanningMRZData
        vc.stCountryCardName = stCountryCardName
        vc.imageCountryCard = cardImage
        vc.dictFaceData = dictFaceDataFront
        vc.dictSecurityData = dictSecuretyData
        vc.dictFaceBackData = dictFaceDataBack
        vc.arrDataForntKey = arrFrontResultKey
        vc.arrDataForntValue = arrFrontResultValue
        vc.arrDataBackKey = arrBackResultKey
        vc.arrDataBackValue = arrBackResultValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func imageRotation(rotation: String) {
        var strRotation = ""
        if UIDevice.current.orientation == .landscapeRight {
            strRotation = "Right"
        } else if UIDevice.current.orientation == .landscapeLeft {
            strRotation = "Left"
        }
        if rotation == "FrontImg" {
            frontImageRotation = strRotation
        } else if rotation == "BackImg" {
            backImageRotation = strRotation
        } else {
            frontImageRotation = strRotation
        }
    }
    
    func reco_msg(_ messageCode: String!) {
        if messageCode == ACCURA_ERROR_CODE_MOTION {
            lblOCRMsg.text = "Keep Document Steady"
        } else  if messageCode == ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME {
            lblOCRMsg.text = "Keep Qatar ID in frame"
        } else  if messageCode == ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME {
            lblOCRMsg.text = "Bring card near to frame"
        } else  if messageCode == ACCURA_ERROR_CODE_PROCESSING {
            lblOCRMsg.text = "Processing..."
        } else  if messageCode == ACCURA_ERROR_CODE_BLUR_DOCUMENT {
            lblOCRMsg.text = "Blur detect in document"
        } else  if messageCode == ACCURA_ERROR_CODE_FACE_BLUR {
            lblOCRMsg.text = "Blur detected over face"
        } else  if messageCode == ACCURA_ERROR_CODE_GLARE_DOCUMENT {
            lblOCRMsg.text = "Glare detect in document"
        } else  if messageCode == ACCURA_ERROR_CODE_HOLOGRAM {
            lblOCRMsg.text = "Hologram Detected"
        } else  if messageCode == ACCURA_ERROR_CODE_DARK_DOCUMENT {
            lblOCRMsg.text = "Low lighting detected"
        } else  if messageCode == ACCURA_ERROR_CODE_PHOTO_COPY_DOCUMENT {
            lblOCRMsg.text = "Can not accept Photo Copy Document"
        } else  if messageCode == ACCURA_ERROR_CODE_FACE {
            lblOCRMsg.text = "Face not detected"
        } else  if messageCode == ACCURA_ERROR_CODE_MRZ {
            lblOCRMsg.text = "MRZ not detected"
        } else  if messageCode == ACCURA_ERROR_CODE_PASSPORT_MRZ {
            lblOCRMsg.text = "Passport MRZ not detected"
        } else if messageCode == ACCURA_ERROR_CODE_WRONG_SIDE {
            lblOCRMsg.text = "Scanning wrong side of Document"
        } else if messageCode == ACCURA_ERROR_CODE_IMAGE_ROTATE {
            lblOCRMsg.text = "Document is upside down. Place it properly"
        } else if messageCode == ACCURA_ERROR_CODE_RETRYING {
            lblOCRMsg.text = "Retrying..."
        }else if messageCode == ACCURA_ERROR_CODE_MOVE_CARD {
            lblOCRMsg.text = "Move your phone/card a little"
        } else {
            lblOCRMsg.text = messageCode
        }
    }
    
    func onAPIError(_ message: String!) {
        GlobalMethods.showAlertView(message, with: self)
    }
    
    
    //MARK:- collcetionView Delegate & DataSource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrReuiredField.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FieldListCollectionViewCell = collcetionViewFieldList.dequeueReusableCell(withReuseIdentifier: "FieldListCollectionViewCell", for: indexPath) as! FieldListCollectionViewCell
        cell.labelFielld.text = arrReuiredField[indexPath.row]
        if(arrRecognizedField.count > 0) {
            for addedField in arrRecognizedField {
                if(addedField == arrReuiredField[indexPath.row]) {
                    cell.imageViewChecklist.image = UIImage(named: "checkbox_selected")
                    break;
                } else {
                    cell.imageViewChecklist.image = UIImage(named: "checkbox_unselect")
                }
            }
        } else {
            cell.imageViewChecklist.image = UIImage(named: "checkbox_unselect")
        }
        
        return cell
    }
    
}
