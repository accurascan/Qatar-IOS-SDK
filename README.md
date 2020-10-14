# Accura Qatar iOS SDK - OCR, Face Match & Liveness Check
iOS Qatar SDK - OCR &amp; Face Match <br/><br/>
Accura Qatar is used for Optical character recognition.<br/><br/>
Accura Face Match is used for Matching 2 Faces. Source and Target. It matches the User Image from a Selfie vs User Image in document.<br/><br/>
Accura Authentication is used for your customer verification and authentication.Unlock the True Identity of Your Users with 3D Selfie Technology<br/><br/>


Below steps to setup Accura SDK's to your project.


## 1. Setup Accura Qatar

Step 1: Add licence file in to your project. <br />        
            - key.licence // for Accura Qatar <br />
            Generate your Accura licence from https://accurascan.com/developer/sdk-license<br />
            
Step 2: Add 'AccuraQatar.framework' into your project root directory
            
Step 3: Add AccuraQatarSDK.swift file in your projrct.<br /> 

Step 4: Appdelegate.swift file in add <br />

```
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        AccuraQatarSDK.configure()
        
        return true
   }
```
Step 5 : To initialize sdk on app start:

```
    import AccuraQatar
    var accuraCameraWrapper: AccuraCameraWrapper? = nil
    var arrCountryList = NSMutableArray()
    
    accuraCameraWrapper = AccuraCameraWrapper.init()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
     	let sdkModel = accuraCameraWrapper.loadEngine(your PathForDirectories)
      	if (sdkModel.i > 0) {
         	 // if sdkModel.isOCREnable then get card data
         	 if (sdkModel.isOCREnable) let countryListStr = self.videoCameraWrapper?.getOCRList();
          
         	if (countryListStr != null) {
           		for i in countryListStr!{
              		self.arrCountryList.add(i)
          		}
          	}
    	}
    }
    
 ```
 
   Some customized function below.
   Call this function after initialize sdk
    
   * Set Blur Percentage to allow blur on document
```
 		// 0 for clean document and 100 for Blurry document
     	accuraCameraWrapper?.setFaceBlurPercentage(int /*blurPercentage*/60); 
```
    
   * Set Blur Face Percentage to allow blur on detected Face
```
        // 0 for clean face and 100 for Blurry face
     	accuraCameraWrapper?.setFaceBlurPercentage(int /*faceBlurPercentage*/80);
```
    
   * Set Glare Percentage to detect Glare on document
```
   		// Set min and max percentage for glare
     	accuraCameraWrapper?.setGlarePercentage(int /*minPercentage*/6, int /*maxPercentage*/98);
```
    
   * Set Photo Copy to allow photocopy document or not
```
         // Set min and max percentage for glare
    	 accuraCameraWrapper?.setCheckPhotoCopy(bool /*isCheckPhotoCopy*/false);
```
    
   * Set Hologram detection to verify the hologram on the face
```
         // true to check hologram on face
   		 accuraCameraWrapper?.setHologramDetection(boolean /*isDetectHologram*/true);
```
   * Set light tolerance to detect light on document
```
        // 0 for full dark document and 100 for full bright document
      	accuraCameraWrapper?.setLowLightTolerance(int /*lowlighttolerance*/10);
```
   * Set motion threshold to detect motion on camera document
```
       	// 1 - allows 1% motion on document and
  		// 100 - it can not detect motion and allow document to scan.
         accuraCameraWrapper?.setMotionThreshold(int /*setMotionThreshold*/4 string /*message*/ "Keep Document Steady");
```
      
 
     
Step 6 : Set CameraView

 Important Grant Camera Permission.
   
```
 	import AccuraQatar
    import AVFoundation
    
    var accuraCameraWrapper: AccuraCameraWrapper? = nil

    override func viewDidLoad() {
    	super.viewDidLoad()
    	let status = AVCaptureDevice.authorizationStatus(for: .video)
    
   		if status == .authorized {
        	 accuraCameraWrapper = AccuraCameraWrapper.init(delegate: self, andImageView: /*setImageView*/ _imageView,andLabelMsg: */setLable*/ lblOCRMsg, andurl: */your PathForDirectories*/ NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String, cardId: /*setCardId*/ Int32(cardid!), countryID: /*setcountryid*/ Int32(countryid!), isScanOCR:/*Bool*/ isCheckScanOCR, andLabelMsgTop:/*Lable*/ _lblTitle, andcardName:/*string*/  docName)
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
        			accuraCameraWrapper = AccuraCameraWrapper.init(delegate: self, andImageView: /*setImageView*/ _imageView, andLabelMsg: */setLable*/ lblOCRMsg, andurl: */your PathForDirectories*/ NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String, cardId: /*setCardId*/ Int32(cardid!), countryID: /*setcountryid*/ Int32(countryid!), isScanOCR:/*Bool*/ isCheckScanOCR, andLabelMsgTop:/*Lable*/ _lblTitle, andcardName:/*string*/  docName)
    			} else {
    				// print("Not granted access")
    			}
    		}
    	}
    }
    
    override func viewDidAppear(_ animated: Bool) {
      	super.viewDidAppear(animated)
    	accuraCameraWrapper?.startCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        accuraCameraWrapper?.stopCamera()
        accuraCameraWrapper = nil
        super.viewWillDisappear(animated)
    }
    
    
	extension ViewController: VideoCameraWrapperDelegate{
    
   		//  it calls continues when scan cards
    	func processedImage(_ image: UIImage!) {
    		image:- image is a get camara image.
    	}
    
    	// it call when license key wrong otherwise didnt get key
    	func recognizeFailed(_ message: String!) {
    		message:- message is a set alert message.
    	}
    
    	// it calls when get MRZ data
    	func recognizeSucceed(_ scanedInfo: NSMutableDictionary!, recType: RecType, bRecDone: Bool, bFaceReplace: Bool, bMrzFirst: Bool, photoImage: UIImage, docFrontImage: UIImage!, docbackImage: UIImage!) {
   			scanedInfo :- scanedInfo is a NSMutableDictionary in get MRZ data.
    		photoImage:- photoImage in get a document face Image.
    		docFrontImage:- docFrontImage is a documant frontside image.
    		docbackImage:- docbackImage is a documant backside image.
    	}

     	//  it calls when show error messages
        func reco_msg(_ messageCode: String!) {
            var message = String()
            if messageCode == ACCURA_ERROR_CODE_MOTION {
                  message = "Keep Document Steady"
            } else if messageCode == ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME {
                  message = "Keep document in frame"
            } else if messageCode == ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME {
                  message = "Bring card near to frame"
            } else if messageCode == ACCURA_ERROR_CODE_PROCESSING {
                  message = "Processing..."
            } else if messageCode == ACCURA_ERROR_CODE_BLUR_DOCUMENT {
                  message = "Blur detect in document"
            } else if messageCode == ACCURA_ERROR_CODE_FACE_BLUR {
                  message = "Blur detected over face"
            } else if messageCode == ACCURA_ERROR_CODE_GLARE_DOCUMENT {
                  message = "Glare detect in document"
            } else if messageCode == ACCURA_ERROR_CODE_HOLOGRAM {
                  message = "Hologram Detected"
            } else if messageCode == ACCURA_ERROR_CODE_DARK_DOCUMENT {
                  message = "Low lighting detected"
            } else if messageCode == ACCURA_ERROR_CODE_PHOTO_COPY_DOCUMENT {
                  message = "Can not accept Photo Copy Document"
            } else if messageCode == ACCURA_ERROR_CODE_FACE {
                  message = "Face not detected"
            } else if messageCode == ACCURA_ERROR_CODE_MRZ {
                  message = "MRZ not detected"
            } else if messageCode == ACCURA_ERROR_CODE_PASSPORT_MRZ {
                  message = "Passport MRZ not detected"
            } else {
                  message = ""
            }
            print(message)
    	}
```
## 2. Setup Accura liveness
Contact to connect@accurascan.com to get Url for liveness
            
Step 1: Open camera for liveness Detectcion.
```
	//set liveness url
	Liveness.setLivenessURL(livenessURL: "/*Your URL*/")
    
   	// To customize your screen theme and feed back messages
    Liveness.setBackGroundColor(backGroundColor: "#C4C4C5")
    Liveness.setCloseIconColor(closeIconColor: "#000000")
    Liveness.setFeedbackBackGroundColor(feedbackBackGroundColor: "#C4C4C5")
    Liveness.setFeedbackTextColor(feedbackTextColor: "#000000")
    Liveness.setFeedbackTextSize(feedbackTextSize: 18)
    Liveness.setFeedBackframeMessage(feedBackframeMessage: "Frame Your Face")
    Liveness.setFeedBackAwayMessage(feedBackAwayMessage: "Move Phone Away")
    Liveness.setFeedBackOpenEyesMessage(feedBackOpenEyesMessage: "Keep Open Your Eyes")
    Liveness.setFeedBackCloserMessage(feedBackCloserMessage: "Move Phone Closer")
    Liveness.setFeedBackCenterMessage(feedBackCenterMessage: "Center Your Face")
    
```
Step 2: Handle Accura liveness Result
```
 	func LivenessData(stLivenessValue: String, livenessImage: UIImage, status: Bool)
```

## 3. Setup Accura Face Match
            
Step 1: Add licence file in to your project.<br />
            - accuraface.license // for Accura Face Match <br />
            Generate your Accura licence from https://accurascan.com/developer/sdk-license  
            
Step 2: Add FaceView.swift file in your project.            

Step 3: Implement face match code manually to your activity.
 
    Important Grant Camera Permission.
    
 ```
  	ImageView image1,image2;
    override func viewDidLoad() {
        super.viewDidLoad()
    	/*
         *	FaceMatch SDK method to check if engine is initiated or not
         *	Return: true or false
         */
        let fmInit = EngineWrapper.isEngineInit()
        if !fmInit{
            
            // FaceMatch SDK method initiate SDK engine
            EngineWrapper.faceEngineInit()
    	}
    }
    
    override func viewDidAppear(_ animated: Bool) {
      	super.viewDidAppear(animated)
      	/*
       	 *		Facematch SDK method to get SDK engine status after initialization
       	 *		Return: -20 = Face Match license key not found, -15 = Face Match license is invalid.
         */
      	let fmValue = EngineWrapper.getEngineInitValue() //get engineWrapper load status
      	if fmValue == -20{
     		GlobalMethods.showAlertView("key not found", with: self)
      	}else if fmValue == -15{
      		GlobalMethods.showAlertView("License Invalid", with: self)
    	}
    }
    
    /**
     * This method use calculate faceMatch score
     * Parameters to Pass: selected uiimage
     */
    func setFaceRegion(_ image: UIImage) {
        var faceRegion : NSFaceRegion?
        if(selectFirstImage){
            /*
             *	Accura Face SDK method to detect user face from document image
             *	Param: Document image
             *	Return: User Face
             */
            faceRegion = EngineWrapper.detectSourceFaces(image)
        }else{
            let face1 : NSFaceRegion? = faceView1.getFaceRegion(); // Get image data
            if (face1 == nil) {
                /*
                 *	Accura Face SDK method to detect user face from document image
                 *	Param: Document image
                 *	Return: User Face
                 */
                faceRegion = EngineWrapper.detectSourceFaces(image);
            } else {
                /*
                 *	Accura Face SDK method to detect user face from selfie or camera stream
                 *	Params: User photo, user face found in document scanning
                 *	Return: User face from user photo
                 */
                faceRegion = EngineWrapper.detectTargetFaces(image, feature1: face1?.feature);
            }
        }
        
        if (selectFirstImage){
            if (faceRegion != nil){
                image1.isHidden = true
                /*
                 *	SDK method call to draw square face around
                 *	@Params: BackImage, Front Image faceRegion Data
                 */
                faceView1.setFaceRegion(faceRegion)
                
                /*
                 *	SDK method call to draw square face around
                 *	@Params: BackImage, Front faceRegion Image
                 */
                faceView1.setImage(faceRegion?.image)
                faceView1.setNeedsDisplay()
                faceView1.isHidden = false
                imgUpload.isHidden = true
                txtUpload.isHidden = true
            }
            
            let face2 : NSFaceRegion? = faceView2.getFaceRegion(); // Get image data
            if (face2 != nil) {
                let face1 : NSFaceRegion? = faceView1.getFaceRegion(); // Get image data
                var faceRegion2 : NSFaceRegion?
                if (face1 == nil){
                    /*
                     *	Accura Face SDK method to detect user face from document image
                     *	Param: Document image
                     *	Return: User Face
                     */
                    faceRegion2 = EngineWrapper.detectSourceFaces(face2?.image)
                }else{
                    /*
                     *	Accura Face SDK method to detect user face from selfie or camera stream
                     *	Params: User photo, user face found in document scanning
                     *	Return: User face from user photo
                     */
                    faceRegion2 = EngineWrapper.detectTargetFaces(face2?.image, feature1: face2?.feature)  //Identify face in back image which found in front
                }
                
                if(faceRegion2 != nil){
                    image2.isHidden = true
                    /*
                     *	SDK method call to draw square face around
                     *	@Params: BackImage, Front Image faceRegion Data
                     */
                    faceView2.setFaceRegion(faceRegion2)
                    /*
                     *	SDK method call to draw square face around
                     *	@Params: BackImage, Front faceRegion Image
                     */
                    faceView2.setImage(faceRegion2?.image)
                    
                    faceView2.setNeedsDisplay()
                    imgUpload2.isHidden = true
                    txtUpload2.isHidden = true
                }
                
            }
        } else if(faceRegion != nil){
            image1.isHidden = true
            image2.isHidden = true
            
            /*
             *	SDK method call to draw square face around
             *	@Params: BackImage, Front Image faceRegion Data
             */
            faceView2.setFaceRegion(faceRegion)
            /*
             *	SDK method call to draw square face around
             *	@Params: BackImage, Front faceRegion Image
             */
            faceView2.setImage(faceRegion?.image)
            faceView2.setNeedsDisplay()
            imgUpload2.isHidden = true
            txtUpload2.isHidden = true
        }
        let face1:NSFaceRegion? = faceView1.getFaceRegion() // Get image data
        let face2:NSFaceRegion? = faceView2.getFaceRegion() // Get image data
        
        if ((face1?.face == 0 || face1 == nil) || (face2?.face == 0 || face2 == nil)){
            lableMatchRate.text = "Match Score : 0.0 %";
            return
        }
        arrDocument.removeAll()
        arrDocument.append(face1?.image ?? UIImage())
        arrDocument.append(face2?.image ?? UIImage())
        
        /*
         *	FaceMatch SDK method call to get FaceMatch Score
         *	@Params: FrontImage Face, BackImage Face
         *	@Return: Match Score
         */
         
        let fmSore = EngineWrapper.identify(face1?.feature, featurebuff2: face2?.feature)
        let twoDecimalPlaces = String(format: "%.2f", fmSore*100) //Match score Convert Float Value
        lableMatchRate.text = "Match Score : \(twoDecimalPlaces) %"
    }
```





