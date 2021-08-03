# Accura Qatar iOS SDK - OCR, Face Match & Liveness Check
iOS Qatar SDK - OCR &amp; Face Match <br/><br/>
Accura Qatar is used for Optical character recognition.<br/><br/>
Accura Face Match is used for Matching 2 Faces. Source and Target. It matches the User Image from a Selfie vs User Image in document.<br/><br/>
Accura Authentication is used for your customer verification and authentication.Unlock the True Identity of Your Users with 3D Selfie Technology<br/><br/>


Below steps to setup AccuraQatar SDK's to your project.

### Download

1. install Git LFS using `install git-lfs` command

2. git clone `https://github.com/accurascan/Qatar-IOS-SDK.git`

3. After completing git clone then install pod using `pod install` command

4. Once installation is done open `AccuraQatarDemo.xcworkspace` in xcode

## 1. Setup Accura Qatar

Step 1: Add license file in to your project. <br />        
            - key.license // for Accura Qatar <br />
            Generate your Accura license from https://accurascan.com/developer/sdk-license<br />
            
Step 2: Add `AccuraQatar.framework` (Xcode compatible version 12.0.1)into your project root directory

Step 3: add in `Appdelegate.swift` file  <br />

```
let accuracamerawrapper = AccuraCameraWrapper()
func applicationWillEnterForeground(_ application: UIApplication) {
	accuracamerawrapper?.refreshPreview()
}
```
Step 4 : To initialize sdk on app start:

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
 
 Some customized function below. Call this function after initialize sdk
    
 * Set Blur Percentage to allow blur on document
```
// 0 for clean document and 100 for Blurry document
accuraCameraWrapper?.setBlurPercentage(int /*blurPercentage*/70); 
```

* Set Blur Face Percentage to allow blur on detected Face
```
// 0 for clean face and 100 for Blurry face
accuraCameraWrapper?.setFaceBlurPercentage(int /*faceBlurPercentage*/90);
```
    
* Set Glare Percentage to detect Glare on document
```
// Set min and max percentage for glare
accuraCameraWrapper?.setGlarePercentage(int /*minPercentage*/6, int /*maxPercentage*/98);
```

* Set Photo Copy to allow photocopy document or not
```
// Set allow photocopy document or not
accuraCameraWrapper?.setCheckPhotoCopy(bool /*isCheckPhotoCopy*/false);
```
    
* Set Hologram detection to verify the hologram on the face
```
// true to check hologram on face
accuraCameraWrapper?.setHologramDetection(bool /*isDetectHologram*/true);
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
accuraCameraWrapper?.setMotionThreshold(int /*setMotionThreshold*/4);
```

* Set API data
    Make sure to call this function after loadEngine(..).
```
self.accuraCameraWrapper?.setAPIData("your server url", apiKey: "your server api key")
```

Step 5 : Set CameraView

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
    //Set minimum frame for frontside scan
    //call this function before start camera
    accuraCameraWrapper?.setMinFrameForValidate(3) // Supports only odd number values
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

override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    // Make sure call this function when view will disappear
    accuraCameraWrapper?.closeOCR()
}
    
    
extension ViewController: VideoCameraWrapperDelegate{
    
	// it calls continues when scan cards
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
    
    //it calls when detect fields from card while scanning
    func recognizeProcess(_ requiredFields: NSMutableArray!, recognizedFields: NSMutableArray!) {
      // requiredFields :- Array of required fields to scanned card
      // recognizedFields :- Array of recognized fields fields to scanned card
    }

	func reco_msg(_ messageCode: String!) {
   		var message = String()
    	if messageCode == ACCURA_ERROR_CODE_MOTION {
        	message = "Keep Document Steady"
    	} else if messageCode == ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME {
        	message = "Bring card near to frame"
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
    	} else if messageCode == ACCURA_ERROR_CODE_WRONG_SIDE {
			message = "Scanning wrong side of Document"
		} else if messageCode == ACCURA_ERROR_CODE_IMAGE_ROTATE {
			message = "Document is upside down. Place it properly"
		} else if messageCode == ACCURA_ERROR_CODE_RETRYING {
            message = "Retrying..."
        } else if messageCode == ACCURA_ERROR_CODE_MOVE_CARD {
            message = "Move your phone/card a little"
        } else {
        	message = ""
    	}
    	print(message)
	}
    
    //it calls when get Error from API
    func onAPIError(_ message: String!) {
        GlobalMethods.showAlertView(message, with: self)
    }

```
## 2. Setup Accura liveness
Contact to connect@accurascan.com to get Url for liveness
            
Step 1: Open camera for liveness Detectcion.
```
//set liveness url
Liveness.setLivenessURL(livenessURL: "Your URL")
    
// To customize your screen theme and feed back messages
Liveness.setBackGroundColor(backGroundColor: "#C4C4C5")
Liveness.setCloseIconColor(closeIconColor: "#000000")
Liveness.setFeedbackBackGroundColor(feedbackBackGroundColor: "#C4C4C5")
Liveness.setFeedbackTextColor(feedbackTextColor: "#000000")
Liveness.setFeedbackTextSize(feedbackTextSize: 18)
Liveness.setFeedBackframeMessage(feedBackframeMessage: "Frame Your Face")
Liveness.setFeedBackAwayMessage(feedBackAwayMessage: "Move Phone Away")
Liveness.setFeedBackOpenEyesMessage(feedBackOpenEyesMessage: "Keep Your Eyes Open")
Liveness.setFeedBackCloserMessage(feedBackCloserMessage: "Move Phone Closer")
Liveness.setFeedBackCenterMessage(feedBackCenterMessage: "Center Your Face")
Liveness.setFeedbackMultipleFaceMessage(feedBackMultipleFaceMessage: "Multiple face detected")
Liveness.setFeedBackFaceSteadymessage(feedBackFaceSteadymessage: "Keep Your Head Straight")
Liveness.setFeedBackBlurFaceMessage(feedBackBlurFaceMessage: "Blur detected over face")
Liveness.setFeedBackGlareFaceMessage(feedBackGlareFaceMessage: "Glare detected")
Liveness.setFeedBackLowLightMessage(feedBackLowLightMessage: "Low light detected")

// 0 for clean face and 100 for Blurry face
Liveness.setBlurpercentage(blurPercentage: 80) // set blur percentage -1 to remove this filter

// Set min and max percentage for glare
Liveness.setGlarepercentage(glareMin: 6, glareMax: 98) //set glaremin -1 to remove this filter

// Set Low light threshhold
Liveness.setLowLightThreshHold(lowLightThreshhold: 10)
    
```
Step 2: Handle Accura liveness Result
```
func LivenessData(stLivenessValue: String, livenessImage: UIImage, status: Bool, errorMessage: String, APIErrorMessage: String) {
    // stlivenessValue:- liveness score
    // livenessImage:- face image
    // status:- if status is true to success otherwise fails
    // errorMessage:- shows liveness failure message
    // APIErrorMessage:- get error from API Response
    
}
```

## 3. Setup Accura Face Match
            
Step 1: Add licence file in to your project.<br />
            - accuraface.license // for Accura Face Match <br />
            Generate your Accura licence from https://accurascan.com/developer/sdk-license  
            
Step 2: Implement face match code manually to your activity.
 
Important Grant Camera Permission.
    
```
/*
*	FaceMatch SDK method to check if engine is initiated or not
*	Return: true or false
*/
let fmInit = EngineWrapper.isEngineInit()
if !fmInit{
 	// FaceMatch SDK method initiate SDK engine
    EngineWrapper.faceEngineInit()
}
/*
*	Facematch SDK method to get SDK engine status after initialization
*	Return: -20 = Face Match license key not found, -15 = Face Match license is invalid.
*/
let fmValue = EngineWrapper.getEngineInitValue() //get engineWrapper load status
if fmValue == -20{
	GlobalMethods.showAlertView("key not found", with: self)
}else if fmValue == -15{
	GlobalMethods.showAlertView("License Invalid", with: self)
}
//Detect face from Document scanning image
let faceRegion = EngineWrapper.detectSourceFaces(imagePhoto)

//Detect face from selfie camera image
let face2 = EngineWrapper.detectTargetFaces(livenessImage, feature1: faceRegion?.feature) 

// get FaceMatch Score from document Face image and selfie camera image
let fm_Score = EngineWrapper.identify(faceRegion?.feature, featurebuff2: face2?.feature)
let twoDecimalPlaces = String(format: "%.2f", fmSore*100) //Match score Convert Float Value
lableMatchRate.text = "Match Score : \(twoDecimalPlaces) %" 
```

Step 3: Close faceEngine On View Disappear
```
EngineWrapper.faceEngineClose()
```




