
import UIKit
import AccuraQatar
import SVProgressHUD
import Alamofire
//Define Global Key
let KEY_TITLE           =  "KEY_TITLE"
let KEY_VALUE           =  "KEY_VALUE"
let KEY_FACE_IMAGE      =  "KEY_FACE_IMAGE"
let KEY_FACE_IMAGE2     =  "KEY_FACE_IMAGE2"
let KEY_DOC1_IMAGE      =  "KEY_DOC1_IMAGE"
let KEY_DOC2_IMAGE      =  "KEY_DOC2_IMAGE"
let KEY_TITLE_FACE_MATCH           =  "KEY_TITLE_FACE_MATCH"
let KEY_VALUE_FACE_MATCH           =  "KEY_VALUE_FACE_MATCH"

struct Objects {
    var name : String!
    var objects : String!
    
    init(sName: String, sObjects: String) {
        self.name = sName
        self.objects = sObjects
    }
    
}

class ShowResultVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, LivenessData {
    
    
    //MARK:- Outlet
    @IBOutlet weak var img_height: NSLayoutConstraint!
    @IBOutlet weak var lblLinestitle: UILabel!
    @IBOutlet weak var tblResult: UITableView!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    
    @IBOutlet weak var viewTable: UIView!
    
    @IBOutlet weak var viewStatusBar: UIView!
    
    @IBOutlet weak var viewNavigationBar: UIView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    //MARK:- Variable
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var uniqStr = ""
    var mrz_val = ""
    
    var imgDoc: UIImage?
    var retval: Int = 0
    var lines = ""
    var success = false
    var isFLpershow = false
    var passportType = ""
    var country = ""
    var surName = ""
    var givenNames = ""
    var passportNumber = ""
    var passportNumberChecksum = ""
    var nationality = ""
    var birth = ""
    var birthChecksum = ""
    var sex = ""
    var expirationDate = ""
    var otherID = ""
    var expirationDateChecksum = ""
    var personalNumber = ""
    var personalNumberChecksum = ""
    var secondRowChecksum = ""
    var placeOfBirth = ""
    var placeOfIssue = ""
    var issuedate = ""
    var departmentNumber = ""
    
    var fontImgRotation = ""
    var backImgRotation = ""
    
    var photoImage: UIImage?
    var documentImage: UIImage?
    
    var isFirstTime:Bool = false
    var arrDocumentData: [[String:AnyObject]] = [[String:AnyObject]]()
    var dictDataShow: [String:AnyObject] = [String:AnyObject]()
    var appDocumentImage: [UIImage] = [UIImage]()
    var pageType: NAV_PAGETYPE = .Default
    
    var matchImage: UIImage?
    var liveImage: UIImage?
    
    let picker: UIImagePickerController = UIImagePickerController()
    var stLivenessResult: String = ""
    
    var scannedData: NSMutableDictionary = [:]
    
    var dictFaceData : NSMutableDictionary = [:]
    var dictSecurityData : NSMutableDictionary = [:]
    var dictFaceBackData : NSMutableDictionary = [:]
    var stFace : String?
    var imgViewCountryCard : UIImage?
    var imgSignature : UIImage?
    var imgViewFront : UIImage?
    var imgViewBack : UIImage?
    var arrSecurity = [String]()
    var arrSecurityTrueFalse = [String]()
    var dictScanningData:NSDictionary = NSDictionary()
    var imagePhoto : UIImage?
    var faceImage: UIImage?
    var imgCamaraFace: UIImage?
    var frontDataIndex: Int?
    var backDataIndex: Int?
    var securtiyDataIndex: Int?
    var arrFaceLivenessScor  = [Objects]()
    var stCountryCardName: String?
    var imageCountryCard: UIImage?
    var isChecktrue: Bool?
    var faceScoreData: String = ""
    var isCheckLiveNess: Bool?
    var isBackSide: Bool?
    var arrDataForntKey: [String] = []
    var arrDataForntValue: [String] = []
    var arrDataBackKey: [String] = []
    var arrDataBackValue: [String] = []
    var arrDataForntValue1: [String] = []
    var arrDataBackValue1: [String] = []
    var saveImage: UIImage?
    var ischekLivess: Bool = false
    var livenessValue: String = ""
    
    var correctPassportChecksum: String?
    var correctBirthChecksum: String?
    var correctExpirationChecksum: String?
    var correctPersonalChecksum: String?
    var correctSecondrowChecksum: String?
    
    var faceRegion: NSFaceRegion?
    var intID: Int?
    var ischeckOneTime: Bool?
    let accuracamera = AccuraCameraWrapper()
    
    //MARK:- UIViewContoller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        isCheckLiveNess = false
        ischeckOneTime = true
        viewStatusBar.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        viewNavigationBar.backgroundColor = UIColor(red: 231.0 / 255.0, green: 52.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
        
        isFirstTime = true
        
        /*
         FaceMatch SDK method to check if engine is initiated or not
         Return: true or false
         */
        let fmInit = EngineWrapper.isEngineInit()
        if !fmInit{
            
            /*
             FaceMatch SDK method initiate SDK engine
             */
            
            EngineWrapper.faceEngineInit()
        }
        
        /*
         Facematch SDK method to get SDK engine status after initialization
         Return: -20 = Face Match license key not found, -15 = Face Match license is invalid.
         */
        let fmValue = EngineWrapper.getEngineInitValue() //get engineWrapper load status
        if fmValue == -20{
            GlobalMethods.showAlertView("key not found", with: self)
        }else if fmValue == -15{
            GlobalMethods.showAlertView("License Invalid", with: self)
        }
        
        
        
        
        if pageType == .ScanOCR{
            self.faceRegion = nil;
              if (self.imagePhoto != nil){
                  self.faceRegion = EngineWrapper.detectSourceFaces(imagePhoto) //Identify face in Document scanning image
              }
            
            dictScanningData = NSDictionary(dictionary: scannedData)
            if arrDataForntKey.count != 0 && self.arrDataBackKey.count != 0{
                setFaceImage()
                for (index,dataKey) in arrDataForntKey.enumerated(){
                    if dataKey == "MRZ"{
                        arrDataForntKey.remove(at: index)
                        arrDataForntValue.remove(at: index)
                    }
                }
                for (index,dataKey) in arrDataBackKey.enumerated(){
                    if dataKey == "MRZ"{
                        arrDataBackKey.remove(at: index)
                        arrDataBackValue.remove(at: index)
                    }
                }
                for(key,value) in dictFaceData{
                    if key as? String != "Face"{
                        arrDataForntKey.append(key as! String)
                        arrDataForntValue.append(value as! String)
                    }
                }
                for(key,value) in dictFaceBackData{
                    if key as? String != "Face"{
                        arrDataBackKey.append(key as! String)
                        arrDataBackValue.append(value as! String)
                    }
                }
                for(key,value) in dictSecurityData{
                    let ansData = Objects.init(sName: key as? String ?? "", sObjects: value as? String ?? "")
                    arrSecurity.append(ansData.objects)
                }
            }else{
                setFaceImage()
                for (index,dataKey) in arrDataForntKey.enumerated(){
                    if dataKey == "MRZ"{
                        arrDataForntKey.remove(at: index)
                        arrDataForntValue.remove(at: index)
                    }
                }
                for(key,value) in dictFaceData{
                    if key as? String != "Face"{
                        arrDataForntKey.append(key as! String)
                        arrDataForntValue.append(value as! String)
                    }
                }
                
                for(key,value) in dictFaceBackData{
                    if key as? String != "Face"{
                        arrDataBackKey.append(key as! String)
                        arrDataBackValue.append(value as! String)
                    }
                }
                
                for(key,value) in dictSecurityData{
                    let ansData = Objects.init(sName: key as? String ?? "", sObjects: value as? String ?? "")
                    arrSecurity.append(ansData.objects)
                }
            }
        }else{
            dictScanningData = NSDictionary(dictionary: scannedData)
            
            if let stFontRotaion:String = dictScanningData["fontImageRotation"] as? String{
                fontImgRotation = stFontRotaion
            }
            if let stBackRotaion:String = dictScanningData["backImageRotation"] as? String{
                backImgRotation = stBackRotaion
            }
            scanMRZData()
            if let image_photoImage: Data = dictScanningData["photoImage"] as? Data {
                self.photoImage = UIImage(data: image_photoImage)
            }
            
            self.faceRegion = nil;
              if (self.photoImage != nil){
                  self.faceRegion = EngineWrapper.detectSourceFaces(photoImage) //Identify face in Document scanning image
              }
            
            
            if let image_documentFontImage: Data = dictScanningData["docfrontImage"] as? Data  {
                appDocumentImage.append(UIImage(data: image_documentFontImage)!)
            }
            
            if let image_documentImage: Data = dictScanningData["documentImage"] as? Data  {
                appDocumentImage.append(UIImage(data: image_documentImage)!)
            }
            imgDoc = documentImage
        }
        
        //**************************************************************//
        
        //Register Table cell
        self.tblResult.register(UINib.init(nibName: "UserImgTableCell", bundle: nil), forCellReuseIdentifier: "UserImgTableCell")
        
        self.tblResult.register(UINib.init(nibName: "ResultTableCell", bundle: nil), forCellReuseIdentifier: "ResultTableCell")
        
        self.tblResult.register(UINib.init(nibName: "DocumentTableCell", bundle: nil), forCellReuseIdentifier: "DocumentTableCell")
        
        self.tblResult.register(UINib.init(nibName: "DocumantVarifyCell", bundle: nil), forCellReuseIdentifier: "DocumantVarifyCell")
        
        self.tblResult.register(UINib.init(nibName: "FaceMatchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "FaceMatchResultTableViewCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ischeckOneTime = true

        Liveness.setLivenessURL(livenessURL: "Your URL")
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
        Liveness.setFeedBackLowLightMessage(feedBackLowLightMessage: "Low light detected")
        Liveness.setFeedBackBlurFaceMessage(feedBackBlurFaceMessage: "Blur detected over face")
        Liveness.setFeedBackGlareFaceMessage(feedBackGlareFaceMessage: "Glare detected")
        //Set TableView Height
        self.tblResult.estimatedRowHeight = 60.0
        self.tblResult.rowHeight = UITableView.automaticDimension
        if pageType != .ScanOCR{
            if isFirstTime{
                isFirstTime = false
                self.setData() // this function Called set data in tableView
               
            }
        }else{
            if isFirstTime{
                isFirstTime = false
            
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
//        EngineWrapper.faceEngineClose()
    }
    
    
    //MARK:- Custom Methods
    func scanMRZData(){
        if let strline: String =  dictScanningData["lines"] as? String {
            self.lines = strline
        }
        if let strpassportType: String =  dictScanningData["passportType"] as? String  {
            self.passportType = strpassportType
        }
        if let stRetval: String = dictScanningData["retval"] as? String   {
            self.retval = Int(stRetval) ?? 0
        }
        if let strcountry: String = dictScanningData["country"] as? String {
            self.country = strcountry
        }
        if let strsurName: String = dictScanningData["surName"] as? String {
            self.surName = strsurName
        }
        if let strgivenNames: String =  dictScanningData["givenNames"] as? String  {
            self.givenNames = strgivenNames
        }
        if let strpassportNumber: String = dictScanningData["passportNumber"] as? String   {
            self.passportNumber = strpassportNumber
        }
        if let strpassportType: String =  dictScanningData["passportType"] as? String {
            self.passportType = strpassportType
        }
        
        if let strpassportNumberChecksum: String = dictScanningData["passportNumberChecksum"] as? String {
            self.passportNumberChecksum = strpassportNumberChecksum
        }
        
        if let stcorrectPassportChecksum: String = dictScanningData["correctPassportChecksum"] as? String{
            self.correctPassportChecksum = stcorrectPassportChecksum
        }
        
        if let strnationality: String =  dictScanningData["nationality"] as? String  {
            self.nationality = strnationality
        }
        if let strbirth: String = dictScanningData["birth"] as? String  {
            self.birth = strbirth
        }
        
        if let strbirthChecksum: String = dictScanningData["BirthChecksum"] as? String{
            self.birthChecksum = strbirthChecksum
        }
        
        if let stcorrectBirthChecksum: String = dictScanningData["correctBirthChecksum"] as? String{
            self.correctBirthChecksum = stcorrectBirthChecksum
        }
        
        if let strsex: String =  dictScanningData["sex"] as? String {
            self.sex = strsex
        }
        if let strexpirationDate: String = dictScanningData["expirationDate"] as? String {
            self.expirationDate = strexpirationDate
        }
        
        if let strexpirationDateChecksum: String = dictScanningData["expirationDateChecksum"] as? String  {
            self.expirationDateChecksum = strexpirationDateChecksum
        }
        
        if let stcorrectExpirationChecksum: String = dictScanningData["correctExpirationChecksum"] as? String{
            self.correctExpirationChecksum = stcorrectExpirationChecksum
        }
        
        if let strpersonalNumber: String = dictScanningData["personalNumber"] as? String{
            self.personalNumber = strpersonalNumber
        }
        if let strpersonalNumberChecksum: String = dictScanningData["personalNumberChecksum"] as? String {
            self.personalNumberChecksum = strpersonalNumberChecksum
        }
        
        if let stcorrectPersonalChecksum: String = dictScanningData["correctPersonalChecksum"] as? String{
            self.correctPersonalChecksum = stcorrectPersonalChecksum
        }
        
        if let strsecondRowChecksum: String = dictScanningData["secondRowChecksum"] as? String {
            self.secondRowChecksum = strsecondRowChecksum
        }
        
        if let stcorrectSecondrowChecksum: String = dictScanningData["correctSecondrowChecksum"] as? String{
            self.correctSecondrowChecksum = stcorrectSecondrowChecksum
        }
        
        if let strplaceOfBirth: String = dictScanningData["placeOfBirth"] as? String{
            self.placeOfBirth = strplaceOfBirth
        }
        if let strplaceOfIssue: String = dictScanningData["placeOfIssue"] as? String {
            self.placeOfIssue = strplaceOfIssue
        }
        
        if let strissuedate: String = dictScanningData["issuedate"] as? String {
            self.issuedate = strissuedate
        }
        
        if let strdepartmentNumber: String = dictScanningData["departmentNumber"] as? String {
            self.departmentNumber = strdepartmentNumber
        }
    }
    
    /**
     * This method use set scanning data
     *
     */
    func setData(){
        //Set tableView Data
        for index in 0..<25 + appDocumentImage.count{
            var dict: [String:AnyObject] = [String:AnyObject]()
            switch index {
            case 0:
                dict = [KEY_FACE_IMAGE: photoImage] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 1:
                dict = [KEY_VALUE_FACE_MATCH: "0 %",KEY_TITLE_FACE_MATCH:"0 %"] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
                
            case 2:
                if lines != ""{
                    dict = [KEY_VALUE: lines] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                
                break
            case 3:
                var firstLetter: String = ""
                var strFstLetter: String = ""
                let strPassportType = passportType.lowercased()
                
                if !lines.isEmpty{
                    firstLetter = (lines as? NSString)?.substring(to: 1) ?? ""
                    strFstLetter = firstLetter.lowercased()
                }
                
                var dType: String = ""
                if strPassportType == "v" || strFstLetter == "v" {
                    dType = "VISA"
                }
                else if passportType == "p" || strFstLetter == "p" {
                    dType = "PASSPORT"
                }
                else if passportType == "d" || strFstLetter == "p" {
                    dType = "DRIVING LICENCE"
                }
                else {
                    if (strFstLetter == "d") {
                        dType = "DRIVING LICENCE"
                    } else {
                        dType = "ID"
                    }
                }
                dict = [KEY_VALUE: dType,KEY_TITLE:"Document Type"] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 4:
                if givenNames != ""{
                    dict = [KEY_VALUE: givenNames,KEY_TITLE:"First Name"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                
                break
            case 5:
                if surName != ""{
                    dict = [KEY_VALUE: surName,KEY_TITLE:"Last Name"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
               
                break
            case 6:
                if passportNumber != ""{
                    let stringWithoutSpaces = passportNumber.replacingOccurrences(of: "<", with: "")
                    dict = [KEY_VALUE: stringWithoutSpaces,KEY_TITLE:"Document No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 7:
                if passportNumberChecksum != ""{
                    dict = [KEY_VALUE: passportNumberChecksum,KEY_TITLE:"Document Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            
            case 8:
                if correctPassportChecksum != ""{
                    dict = [KEY_VALUE: correctPassportChecksum,KEY_TITLE:"Correct Document Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                
                break
                
            case 9:
                if country != ""{
                    dict = [KEY_VALUE: country,KEY_TITLE:"Country"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 10:
                if nationality != ""{
                    dict = [KEY_VALUE: nationality,KEY_TITLE:"Nationality"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 11:
                var stSex: String = ""
                if sex == "F" {
                    stSex = "FEMALE";
                }else if sex == "M" {
                    stSex = "MALE";
                } else {
                    stSex = sex
                }
                dict = [KEY_VALUE: stSex,KEY_TITLE:"Sex"] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 12:
                if birth != ""{
                    dict = [KEY_VALUE: date(toFormatedDate: birth),KEY_TITLE:"Date of Birth"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 13:
                if birthChecksum != ""{
                    dict = [KEY_VALUE: birthChecksum,KEY_TITLE:"Birth Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                
                break
             
            case 14:
                if correctBirthChecksum != ""{
                    dict = [KEY_VALUE: correctBirthChecksum,KEY_TITLE:"Correct Birth Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                
                break
                
            case 15:
                if expirationDate != ""{
                    dict = [KEY_VALUE: date(toFormatedDate: expirationDate),KEY_TITLE:"Date of Expiry"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
                
            case 16:
                if expirationDateChecksum != ""{
                    dict = [KEY_VALUE: expirationDateChecksum,KEY_TITLE:"Expiration Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
                
            case 17:
                if correctExpirationChecksum != ""{
                    dict = [KEY_VALUE: correctExpirationChecksum,KEY_TITLE:"Correct Expiration Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                
                break
            case 18:
                if issuedate != ""{
                    dict = [KEY_VALUE: date(toFormatedDate: issuedate),KEY_TITLE:"Issue Date"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
                
            case 19:
                if departmentNumber != ""{
                    dict = [KEY_VALUE: departmentNumber,KEY_TITLE:"Department No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
                
            case 20:
                if personalNumber != ""{
                    dict = [KEY_VALUE: personalNumber,KEY_TITLE:"Other ID"] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 21:
                if personalNumberChecksum != ""{
                    dict = [KEY_VALUE: personalNumberChecksum,KEY_TITLE:"Other ID Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 22:
                if correctPersonalChecksum != ""{
                    dict = [KEY_VALUE: correctPersonalChecksum,KEY_TITLE:"Correct Other ID Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
                
            case 23:
                if secondRowChecksum != ""{
                    dict = [KEY_VALUE: secondRowChecksum,KEY_TITLE:"Second Row Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
                
            case 24:
                if correctSecondrowChecksum != ""{
                    dict = [KEY_VALUE: correctSecondrowChecksum,KEY_TITLE:"Correct Second Row Check No."] as [String : AnyObject]
                    arrDocumentData.append(dict)
                }
                break
            case 25:
                dict = [KEY_DOC1_IMAGE: !appDocumentImage.isEmpty ? appDocumentImage[0] : nil] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            case 26:
                dict = [KEY_DOC2_IMAGE: appDocumentImage.count == 2 ? appDocumentImage[1] : nil] as [String : AnyObject]
                arrDocumentData.append(dict)
                break
            default:
                break
            }
        }
    }
    
    
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.jpeg(.medium)
      return imageData!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    //Remove Same Value
    func removeOldValue(_ removeKey: String){
        var removeIndex: String = ""
        if pageType != .ScanOCR{
            for (index,dict) in arrDocumentData.enumerated(){
                if dict[KEY_TITLE_FACE_MATCH] != nil{
                    if dict[KEY_TITLE_FACE_MATCH] as! String == removeKey{
                        removeIndex = "\(index)"
                    }
                }
            }
            if !removeIndex.isEmpty{ arrDocumentData.remove(at: Int(removeIndex)!)}
        }else{
            for (index,faceKey) in arrFaceLivenessScor.enumerated(){
                if faceKey.name == removeKey{
                    removeIndex = "\(index)"
                }
            }
            if !removeIndex.isEmpty{ arrFaceLivenessScor.remove(at: Int(removeIndex)!)}
        }
    }
    
    func removeOldValue1(_ removeKey: String){
        var removeIndex: String = ""
        for (index,dict) in arrDocumentData.enumerated(){
            if dict[KEY_VALUE_FACE_MATCH] != nil{
                if dict[KEY_VALUE_FACE_MATCH] as! String == removeKey{
                    removeIndex = "\(index)"
                }
            }
        }
        if !removeIndex.isEmpty{ arrDocumentData.remove(at: Int(removeIndex)!)}
    }
    
    //MARK: UIButton Method Action
    @IBAction func onCancelAction(_ sender: Any) {
        if pageType == .ScanOCR{
            removeAllData()
        }
        EngineWrapper.faceEngineClose()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Other Method
    func removeAllData(){
        dictFaceData.removeAllObjects()
        dictSecurityData.removeAllObjects()
        dictFaceBackData.removeAllObjects()
        arrSecurity.removeAll()
        arrDataForntKey.removeAll()
        arrDataBackKey.removeAll()
        arrDataForntValue.removeAll()
        arrDataBackValue.removeAll()
        arrDataForntValue1.removeAll()
        arrDataBackValue1.removeAll()
        faceScoreData = ""
        stFace = nil
        imagePhoto = nil
        imgViewBack = nil
        imgViewFront = nil
        imgCamaraFace = nil
        faceImage = nil
    }
    
    //MARK: - UITableView Delegate and Datasource Method
    func numberOfSections(in tableView: UITableView) -> Int {
        if pageType == .ScanOCR{
            return 7
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pageType == .ScanOCR{
            switch section {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return 1
            case 3:
                return arrDataForntKey.count
            case 4:
                return arrDataBackKey.count
            case 5:
                return arrDocumentData.count
            case 6:
                if imgViewBack == nil{
                    return 1
                }else{
                    return 2
                }
            default:
                return 0
            }
        }else{
            return  self.arrDocumentData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if pageType == .ScanOCR{
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserImgTableCell") as! UserImgTableCell
                cell.selectionStyle = .none
                cell.view2.isHidden = true
                cell.User_img2.isHidden = true
                cell.user_img.image = faceImage
                
                if imgCamaraFace != nil{
                    cell.view2.isHidden = false
                    cell.User_img2.isHidden = false
                    cell.User_img2.image = imgCamaraFace
                    cell.User_img2.contentMode = .scaleAspectFit
                }
                
                return cell
            }else if indexPath.section == 1{
                let cell: FaceMatchResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FaceMatchResultTableViewCell") as! FaceMatchResultTableViewCell
                cell.btnLiveness.addTarget(self, action: #selector(buttonClickedLiveness(sender:)), for: .touchUpInside)
                
                if(!isFLpershow)
                {
                    cell.constraintHeight.constant = 0
                }
                else{
                    cell.constraintHeight.constant = 85
                }
                

                if livenessValue != ""{
                    cell.lblValueLiveness.text = livenessValue
                } else {
                    cell.lblValueLiveness.text = "0.00 %"
                }
                
                if faceScoreData != ""{
                    cell.lblValueFaceMatch.text = "\(faceScoreData) %"
                } else {
                    cell.lblValueFaceMatch.text = "0.00 %"
                }
                
                
                return cell
            }else if indexPath.section == 2{
                let cell: DocumantVarifyCell = tableView.dequeueReusableCell(withIdentifier: "DocumantVarifyCell") as! DocumantVarifyCell
                if !arrSecurity.isEmpty{
                    let data = arrSecurity[indexPath.row]
                    if data == "true"{
                        cell.labelYES.text = "YES"
                        cell.labelYES.isHidden = false
                        cell.labelYES.textColor = UIColor(red: 137.0 / 255.0, green: 212.0 / 255.0, blue: 47.0 / 255.0, alpha: 1)
                    }else{
                        cell.labelYES.text = "NO"
                        cell.labelYES.isHidden = true
                        cell.labelYES.textColor = UIColor(red: 219.0 / 255.0, green: 68.0 / 255.0, blue: 55.0 / 255.0, alpha: 1)
                    }
                    
                }
                return cell
            }else if indexPath.section == 3{
                
                let cell: ResultTableCell = tableView.dequeueReusableCell(withIdentifier: "ResultTableCell") as! ResultTableCell
                
                cell.selectionStyle = .none
                
                if !arrDataForntKey.isEmpty{
                    let objDataKey = arrDataForntKey[indexPath.row]
                    let objDataValue = arrDataForntValue[indexPath.row]
                    cell.lblName.text = objDataKey.uppercased()
                    cell.lblValue.text = objDataValue
                    cell.viewImagevalueBG.isHidden = true
                    if objDataKey.contains("Sign") || objDataKey.contains("SIGN"){
                        if let decodedData = Data(base64Encoded: objDataValue, options: .ignoreUnknownCharacters) {
                            let image = UIImage(data: decodedData)
                            let attachment = NSTextAttachment()
                            attachment.image = image
                            let attachmentString = NSAttributedString(attachment: attachment)
                            cell.lblValue.attributedText = attachmentString
                        }
                        
                    }
                }
                return cell
            }
            else if indexPath.section == 4{
                let cell: ResultTableCell = tableView.dequeueReusableCell(withIdentifier: "ResultTableCell") as! ResultTableCell
                cell.selectionStyle = .none
                if !arrDataBackKey.isEmpty{
                    let objDatakey = arrDataBackKey[indexPath.row]
                    let objDataValue = arrDataBackValue[indexPath.row]
                    cell.viewImagevalueBG.isHidden = true
                    cell.lblName.text = objDatakey.uppercased()
                    cell.lblValue.text = objDataValue
                    if objDatakey.contains("Sign") || objDatakey.contains("SIGN"){
                        if let decodedData = Data(base64Encoded: objDataValue, options: .ignoreUnknownCharacters) {
                            let image = UIImage(data: decodedData)
                            cell.viewImagevalueBG.isHidden = false
                            cell.imageValue.image = image
                            cell.lblValue.text = ""
                        }
                    }
                }
                return cell
            }else if indexPath.section == 5{
                let cell: ResultTableCell = tableView.dequeueReusableCell(withIdentifier: "ResultTableCell") as! ResultTableCell
                if !arrDocumentData.isEmpty{
                    
                    let  dictResultData: [String:AnyObject] = arrDocumentData[indexPath.row]
                    
                    if indexPath.row == 0{
                        cell.lblName.text = "MRZ"
                        cell.lblValue.text = dictResultData[KEY_VALUE] as? String ?? ""
                    }else{
                        cell.lblName.text = dictResultData[KEY_TITLE] as? String ?? ""
                        cell.lblValue.text = dictResultData[KEY_VALUE] as? String ?? ""
                    }
                    
                }
                return cell
            }
                
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableCell") as! DocumentTableCell
                
                cell.selectionStyle = .none
                cell.lblDocName.font = UIFont.init(name: "Aller-Bold", size: 16)
                if indexPath.row == 0{
                    cell.lblDocName.text = "FRONT SIDE"
                    if imgViewFront != nil{
                        cell.imgDocument.image = imgViewFront!
                    }
                }else{
                    cell.lblDocName.text = "BACK SIDE"
                    if imgViewBack != nil{
                        cell.imgDocument.image = imgViewBack!
                    }
                }
                
                return cell
            }
        }
        else{
            let  dictResultData: [String:AnyObject] = arrDocumentData[indexPath.row]
            if dictResultData[KEY_FACE_IMAGE] != nil{
                //Set User Image
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserImgTableCell") as! UserImgTableCell
                cell.selectionStyle = .none
                if let imageFace: UIImage =  dictResultData[KEY_FACE_IMAGE]  as? UIImage{
                    cell.User_img2.isHidden = true
                    cell.view2.isHidden = true
                    if (UIDevice.current.orientation == .landscapeRight) {
                        cell.user_img.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
                    } else if (UIDevice.current.orientation == .landscapeLeft) {
                        cell.user_img.transform = CGAffineTransform(rotationAngle: CGFloat(-(Double.pi / 2)))
                    }
                    cell.user_img.image = imageFace
                }
                
                if imgCamaraFace != nil{
                    cell.view2.isHidden = false
                    cell.User_img2.isHidden = false
                    cell.User_img2.image = imgCamaraFace
                    cell.User_img2.contentMode = .scaleAspectFit
                }
                return cell
            }else if dictResultData[KEY_TITLE_FACE_MATCH] != nil || dictResultData[KEY_VALUE_FACE_MATCH] != nil{
                
                let cell: FaceMatchResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FaceMatchResultTableViewCell") as! FaceMatchResultTableViewCell
                if(!isFLpershow)
                {
                    cell.constraintHeight.constant = 0
                }
                else{
                    cell.constraintHeight.constant = 85
                }

                cell.btnLiveness.addTarget(self, action: #selector(buttonClickedLiveness(sender:)), for: .touchUpInside)
                
                
                if livenessValue != ""{
                    cell.lblValueLiveness.text = livenessValue
                } else {
                    cell.lblValueLiveness.text = "0.00 %"
                }
                
                if faceScoreData != ""{
                    cell.lblValueFaceMatch.text = "\(faceScoreData) %"
                } else {
                    cell.lblValueFaceMatch.text = "0.00 %"
                }
            
                return cell
            }else if dictResultData[KEY_TITLE] != nil || dictResultData[KEY_VALUE] != nil{
                //Set Document data
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableCell") as! ResultTableCell
                cell.selectionStyle = .none
                if dictResultData[KEY_TITLE] == nil && dictResultData[KEY_VALUE] != nil{
                    cell.lblValue.isHidden = false
                    cell.lblName.isHidden = false
                    
                }else{
                    cell.lblValue.isHidden = false
                    cell.lblName.isHidden = false
                }
                if dictResultData[KEY_TITLE] == nil && dictResultData[KEY_VALUE] != nil{
                    cell.lblSide.text = "MRZ"
                    cell.constarintViewHaderHeight.constant = 60
                    cell.lblName.text = "MRZ"
                    cell.lblValue.text = dictResultData[KEY_VALUE] as? String ?? ""
                }else{
                    cell.constarintViewHaderHeight.constant = 0
                    cell.lblName.text = dictResultData[KEY_TITLE] as? String ?? ""
                    cell.lblValue.text = dictResultData[KEY_VALUE] as? String ?? ""
                }
                
                return cell
            }else{
                //Set Document Images
                let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableCell") as! DocumentTableCell
                cell.selectionStyle = .none
                cell.imgDocument.contentMode = .scaleToFill
                if dictResultData[KEY_DOC1_IMAGE] != nil {
                    if pageType == .ScanAadhar || pageType == .ScanPan{
                        cell.lblDocName.text = ""
                        cell.constraintLblHeight.constant = 0
                    }else{
                        cell.lblDocName.text = "Front Side"
                        cell.constraintLblHeight.constant = 25
                    }
                    if let imageDoc1: UIImage =  dictResultData[KEY_DOC1_IMAGE]  as? UIImage{
                        cell.imgDocument.image = imageDoc1
                    }
                }
                
                if dictResultData[KEY_DOC2_IMAGE] != nil {
                    if pageType == .ScanAadhar || pageType == .ScanPan{
                        cell.lblDocName.text = ""
                        cell.constraintLblHeight.constant = 0
                    }else{
                        cell.lblDocName.text = "Back Side"
                        
                        cell.constraintLblHeight.constant = 25
                    }
                    if let imageDoc2: UIImage =  dictResultData[KEY_DOC2_IMAGE]  as? UIImage{
                        cell.imgDocument.image = imageDoc2
                    }
                }
                return cell
            }
        }
        
    }
    
    
    func getValue(stKey: String) -> String {
        if pageType == .ScanOCR{
            if !arrDocumentData.isEmpty{
                let arrResult = arrDocumentData.filter( { (details: [String:AnyObject]) -> Bool in
                    return ("\(details[KEY_TITLE] ?? "" as AnyObject)" == stKey )
                })
                
                let dictResult = arrResult.isEmpty ? [String:AnyObject]() : arrResult[0]
                var stResult: String = ""
                if dictResult[KEY_VALUE] != nil { stResult = "\(dictResult[KEY_VALUE] ?? "" as AnyObject)"  }
                else{ stResult = "" }
                return stResult
            }else{
                return ""
            }
        }else{
            let arrResult = arrDocumentData.filter( { (details: [String:AnyObject]) -> Bool in
                print(details)
                return ("\(details[KEY_TITLE] ?? "" as AnyObject)" == stKey )
            })
            print(arrResult)
            let dictResult = arrResult.isEmpty ? [String:AnyObject]() : arrResult[0]
            var stResult: String = ""
            if dictResult[KEY_VALUE] != nil { stResult = "\(dictResult[KEY_VALUE] ?? "" as AnyObject)"  }
            else{ stResult = "" }
            return stResult
        }
    }
    
    
    func getValueFace(stKey: String) -> String {
        if pageType == .ScanOCR{
            let arrResult = arrFaceLivenessScor.filter { (object) -> Bool in
                return object.name == stKey
            }
            
            let dictResult = arrResult.isEmpty ? Objects.init(sName: "", sObjects: "") : arrResult[0]
            var stResult: String = ""
            if dictResult.objects != nil { stResult = "\(dictResult.objects ?? "")"  }
            else{ stResult = "" }
            return stResult
        }else{
            let arrResult = arrDocumentData.filter( { (details: [String:AnyObject]) -> Bool in
                return ("\(details[KEY_TITLE_FACE_MATCH] ?? "" as AnyObject)" == stKey )
            })
            print(arrResult)
            let dictResult = arrResult.isEmpty ? [String:AnyObject]() : arrResult[0]
            var stResult: String = ""
            if dictResult[KEY_VALUE_FACE_MATCH] != nil { stResult = "\(dictResult[KEY_VALUE_FACE_MATCH] ?? "" as AnyObject)"  }
            else{ stResult = "" }
            return stResult
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if pageType == .ScanOCR{
            if indexPath.section == 0{
                return UITableView.automaticDimension
            }else if indexPath.section == 1{
                
                if(isFLpershow)
                {
                    return 151
                }
                return 76
            }else if indexPath.section == 2{
                if !arrSecurity.isEmpty{
                    let data = arrSecurity[indexPath.row]
                    if data == "true"{
                        return 75
                    }
                    return 0
                }
                return 0
            }else if indexPath.section == 3{
                return UITableView.automaticDimension
            }else if indexPath.section == 4{
                return UITableView.automaticDimension
            }else if indexPath.section == 5{
                return UITableView.automaticDimension
            }
            else{
                return 310.0
            }
        }else{
            let  dictResultData: [String:AnyObject] = arrDocumentData[indexPath.row]
            if dictResultData[KEY_FACE_IMAGE] != nil{
                return UITableView.automaticDimension
            }else if dictResultData[KEY_VALUE_FACE_MATCH] != nil && dictResultData[KEY_TITLE_FACE_MATCH] != nil{
                if(isFLpershow)
                {
                    return 151
                }
                return 76
            } else if dictResultData[KEY_TITLE] != nil && dictResultData[KEY_VALUE] != nil{
                return UITableView.automaticDimension
            }
            else if dictResultData[KEY_TITLE] != nil || dictResultData[KEY_VALUE] != nil{
                return UITableView.automaticDimension
            }
            else if dictResultData[KEY_DOC1_IMAGE] != nil || dictResultData[KEY_DOC2_IMAGE] != nil{
                return 310.0
            }else{
                return 0.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return CGFloat.leastNonzeroMagnitude
        }else if section == 1{
            return CGFloat.leastNonzeroMagnitude
        }else if section == 2{
            return 2
        }else if section == 3{
            return 20
        }else if section == 4{
            if !arrDataBackKey.isEmpty{
                return 20
            }else{
                return CGFloat.leastNonzeroMagnitude
            }
        }else if section == 5{
            if !arrDocumentData.isEmpty{
                return 20
            }else{
                return CGFloat.leastNonzeroMagnitude
            }
        }
        else{
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: viewTable.frame.width, height: 0))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return CGFloat.leastNonzeroMagnitude
        }else if section == 1{
            return CGFloat.leastNonzeroMagnitude
        }else if section == 2{
            return 2
        }else if section == 3{
            return 60
        }else if section == 4{
            if !arrDataBackKey.isEmpty{
                return 60
            }else{
                return CGFloat.leastNonzeroMagnitude
            }
        }else if section == 5{
            if !arrDocumentData.isEmpty{
                return 60
            }else{
                return CGFloat.leastNonzeroMagnitude
            }
        }
        else{
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 3{
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
            headerView.backgroundColor = UIColor.init(red: 237.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
            let label = UILabel()
            label.frame = CGRect.init(x: 15, y: 0, width: headerView.frame.width - 16, height: headerView.frame.height)
            label.backgroundColor = .clear
            label.text = "OCR FRONT"
            label.font = UIFont.init(name: "Aller-Bold", size: 16)
            label.textAlignment = .left
            label.textColor = UIColor(red: 47.0 / 255.0, green: 50.0 / 255.0, blue: 58.0 / 255.0, alpha: 1) // my custom colour
            headerView.addSubview(label)
            return headerView
        }else if section == 4{
            if !arrDataBackKey.isEmpty{
                let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
                headerView.backgroundColor = UIColor.init(red: 237.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
                let label = UILabel()
                label.frame = CGRect.init(x: 15, y: 0, width: headerView.frame.width - 16, height: headerView.frame.height)
                label.backgroundColor = .clear
                label.text = "OCR BACK"
                label.font = UIFont.init(name: "Aller-Bold", size: 16)
                label.textAlignment = .left
                label.textColor = UIColor(red: 47.0 / 255.0, green: 50.0 / 255.0, blue: 58.0 / 255.0, alpha: 1)// my custom colour
                headerView.addSubview(label)
                return headerView
            }else{
                let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
                return headerView
            }
        }else if section == 5{
            if !arrDocumentData.isEmpty{
                
                let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
                headerView.backgroundColor = UIColor.init(red: 237.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
                let label = UILabel()
                label.frame = CGRect.init(x: 15, y: 0, width: headerView.frame.width - 16, height: headerView.frame.height)
                label.backgroundColor = .clear
                label.text = "MRZ"
                label.font = UIFont.init(name: "Aller-Bold", size: 16)
                label.textAlignment = .left
                label.textColor = UIColor(red: 47.0 / 255.0, green: 50.0 / 255.0, blue: 58.0 / 255.0, alpha: 1) // my custom colour
                headerView.addSubview(label)
                return headerView
            }else{
                let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
                return headerView
            }
        } else {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 0))
            return headerView
        }
    }
    
    func tableViewReslut(cell: ResultTableCell, objData: String, objTrueFalse: String){
        if let decodedData = Data(base64Encoded: objData, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            let attachment = NSTextAttachment()
            attachment.image = image
            let attachmentString = NSAttributedString(attachment: attachment)
            cell.lblName.attributedText = attachmentString
        }
        let attachment1 = NSTextAttachment()
        if objTrueFalse == "true"{
            attachment1.image = UIImage(named: "tick")
        }else{
            attachment1.image = UIImage(named: "close")
        }
        let attachmentString1 = NSAttributedString(attachment: attachment1)
        cell.lblValue.attributedText = attachmentString1
    }
    func setText(cell: ResultTableCell, name: String, color: UIColor){
        cell.lblName.font = UIFont(name: name, size: 14.0)
        cell.lblValue.font = UIFont(name: name, size: 14.0)
        
        cell.lblName.textColor = color
        cell.lblValue.textColor = color
    }
    
    func resizeImage(image: UIImage, targetSize: CGRect) -> UIImage {
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        let w = image.size.width * 0.12;
        let h = image.size.height * 0.12;
        var newX = targetSize.origin.x - w
        var newY = targetSize.origin.y - h
        var newWidth = targetSize.size.width + (w * 2);
        var newHeight = targetSize.size.height + (h * 2);
        if newX < 0 {
            newX = 0
        }
        if newY < 0 {
            newY = 0
        }
        if newX + newWidth > image.size.width{
            newWidth = image.size.width - newX
        }
        if newY + newHeight > image.size.height{
            newHeight = image.size.height - newY
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        let image1: UIImage = UIImage(cgImage: imageRef)
        return image1
    }
    
    //MARK:- Custom
    func date(toFormatedDate dateStr: String?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        let date: Date? = dateFormatter.date(from: dateStr ?? "")
        dateFormatter.dateFormat = "dd-MM-yy"
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func date(to dateStr: String?) -> String? {
        // Convert string to date object
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyMMdd"
        let date: Date? = dateFormat.date(from: dateStr ?? "")
        dateFormat.dateFormat = "yyyy-MM-dd"
        if let date = date {
            return dateFormat.string(from: date)
        }
        return nil
    }
    
    func setFaceImage(){
        if(imagePhoto != nil)          {
            faceImage = imagePhoto
        }
        else{
            faceImage = UIImage(named: "default_user")
        }
        
    }
    
    @objc func buttonClickedLiveness(sender:UIButton)
    {
        Liveness.setLiveness(livenessView: self)
        
    }
    
    func LivenessData(stLivenessValue: String, livenessImage: UIImage, status: Bool) {
        isFLpershow = true
        self.livenessValue = stLivenessValue
        imgCamaraFace = livenessImage
        if status == false{
            GlobalMethods.showAlertView("Please try again", with: self)
        }
        
        if (faceRegion != nil)
        {
            /*
             FaceMatch SDK method call to detect Face in back image
             @Params: BackImage, Front Face Image faceRegion
             @Return: Face Image Frame
             */
            
            let face2 = EngineWrapper.detectTargetFaces(livenessImage, feature1: faceRegion?.feature)
            let face11 = faceRegion?.image
            /*
             FaceMatch SDK method call to get FaceMatch Score
             @Params: FrontImage Face, BackImage Face
             @Return: Match Score
             
             */
            
            let fm_Score = EngineWrapper.identify(faceRegion?.feature, featurebuff2: face2?.feature)
            if(fm_Score != 0.0){
            let data = face2?.bound
            let image = self.resizeImage(image: livenessImage, targetSize: data!)
            imgCamaraFace = image
            let twoDecimalPlaces = String(format: "%.2f", fm_Score*100) //Face Match score convert to float value
            self.removeOldValue("FACEMATCH SCORE : ")
            self.removeOldValue1("0 %")
           
            if pageType != .ScanOCR{
                let dict = [KEY_VALUE_FACE_MATCH: "\((twoDecimalPlaces))",KEY_TITLE_FACE_MATCH:"FACEMATCH SCORE : "] as [String : AnyObject]
                arrDocumentData.insert(dict, at: 1)
                faceScoreData = twoDecimalPlaces
            }else{
                 faceScoreData = twoDecimalPlaces

            }
                
                let stFaceImage = convertImageToBase64(image: image)
                let stLivenessInage = convertImageToBase64(image: livenessImage)
//                print(intID as Any)
                var dictParam: [String: String] = [String: String]()
                dictParam["kyc_id"] = "\(intID ?? 0)"
                dictParam["face_match"] = "True"
                dictParam["liveness"] = "True"
                dictParam["face_match_score"] = "\(faceScoreData)"

                dictParam["liveness_score"] = stLivenessValue
                dictParam["facematch_image"] = stFaceImage
                dictParam["liveness_image"] = stLivenessInage
                    let sharedInstance = NetworkReachabilityManager()!
                    var isConnectedToInternet:Bool {
                        return sharedInstance.isReachable
                    }

                
        }
            tblResult.reloadData()
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIImagePickerControllerInfoKeyDictionary(_ input: [String: Any]) -> [UIImagePickerController.InfoKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIImagePickerController.InfoKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
