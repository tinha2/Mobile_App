//
//  ResultViewController.swift
//  DeepSocial
//
//  Created by Chung BD on 4/13/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import SnapKit
import Segmentio

class ResultViewController: UIViewController {
    
    enum Tag:Int {
        case imageViewOfImageExtraction = 10
    }
    
    enum Padding:CGFloat {
        case normal = 8
    }

//    var tblEntities:UITableView = UITableView(frame: CGRect.zero, style: .plain)
//    var tblCategories:UITableView = UITableView(frame: CGRect.zero, style: .plain)
//    var tblSentences:UITableView = UITableView(frame: CGRect.zero, style: .plain)
    var tblsCategory:[UITableView] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    var segmentView: Segmentio!
    
    var segmentItems:[SegmentioItem] = []
    
    var safeAnnotationCellIdentifier:String = "safeAnnotationCellIdentifier"
    
    var entities:[NLEntity] = []
    var categories:[NLCategory] = []
    var sentences:[NLSentence] = []
    
    var sections:[EntitySection] = []
    var categoriesHeader:[UIView] = []
    
    var labels:[CVLabel] = []
    var webDections:CVWebDetection = CVWebDetection()
    var textAnnotation:[CVTextAnnotation] = []
    var safeAnnotations:[CVSafeSearchAnnotation] = []
    var dominantColors:[CVDominantColor] = []
    
    var transcripts:[CSConfidence] = []
    
    let contentHeaderTag = 10
    var indexOfPage:Int = 0
    
    var sizeOfImageHeader:(widthImageView: CGFloat,heightImageView: CGFloat,widthImage: CGFloat, heightImage: CGFloat) = (0,0,0,0)
    
    var feature:FeatureItem?
    
    var featureType:Feature {
        if let featureType = feature?.feature {
            return featureType
        }
        
        return Feature.text
    }
    
    static func initiate(json:[String:Any],featureValue:FeatureItem) -> ResultViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {

            switch featureValue.feature {
            case .text:
                let entities = json["entities"] as? [[String: Any]] ?? []
                resultVC.entities = entities.compactMap(NLEntity.init).sorted { $0.name < $1.name }
                
                let categories = json["categories"] as? [[String: Any]] ?? []
                resultVC.categories = categories.compactMap(NLCategory.init).sorted { $0.name < $1.name }
                
                let sentences = json["sentences"] as? [[String: Any]] ?? []
                
                var sentencesOutput:[NLSentence] = sentences.compactMap(NLSentence.init)
                
                if let entireDocumentJson = json["documentSentiment"] as? [String:Any],
                    let entireDocumentSentiment = NLSentiment(json: entireDocumentJson) {
                    let entireDocument = NLSentence(content: "Entire Document", sentiment: entireDocumentSentiment)
                    sentencesOutput.insert(entireDocument, at: 0)
                }
                
                resultVC.sentences = sentencesOutput
            
            case .image:
                let labelAnnotations = json["labelAnnotations"] as? [CommonDic] ?? []
                resultVC.labels = labelAnnotations.compactMap(CVLabel.init).sorted { $0.score > $1.score }
                
                if let webDetection = CVWebDetection(json: json) {
                    resultVC.webDections = webDetection
                }
                
                if let safeSearchAnnotation = json["safeSearchAnnotation"] as? [String:String] {
                    resultVC.safeAnnotations = CVSafeSearchAnnotation.initiateWithDictionary(annotations: safeSearchAnnotation)
                }
                
                if let textAnnotationsJson = json["textAnnotations"] as? [CommonDic] {
                    resultVC.textAnnotation = textAnnotationsJson.compactMap(CVTextAnnotation.init).sorted { $0.description < $1.description }
                } 
                
                if let imagePropertiesAnnotationJson = json["imagePropertiesAnnotation"] as? CommonDic,
                    let dominantColorsJson = imagePropertiesAnnotationJson["dominantColors"] as? CommonDic,
                    let colors = dominantColorsJson["colors"] as? [CommonDic] {
                    resultVC.dominantColors = colors.compactMap(CVDominantColor.init).sorted { $0.pixelFraction > $1.pixelFraction }
                }

            case .voiceToText:
                let alternatives = json["alternatives"] as? [CommonDic] ?? []
                resultVC.transcripts = alternatives.compactMap(CSConfidence.init).sorted { $0.confidence > $1.confidence }
                
            case .textToSpeech:
                break
            }
            resultVC.feature = featureValue
            return resultVC
        }
        
        return ResultViewController()
    }
    
    static func initiateForTesting(withFeature item:FeatureItem) -> ResultViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
            switch item.feature {
            case .text:
                resultVC.entities = NLEntity.initiateForTesting()
                
                resultVC.categories = NLCategory.initiateForTesting()
                
                resultVC.sentences = NLSentence.initiateForTesting()
            case .image:
                if let webDetection = CVWebDetection.initiateForTesting() {
                    resultVC.webDections = webDetection
                }
                
                resultVC.labels = CVLabel.initiateForTesting()
                resultVC.textAnnotation = CVTextAnnotation.initiateForTesting()
                resultVC.safeAnnotations = CVSafeSearchAnnotation.initiateForTesting()
                resultVC.dominantColors = CVDominantColor.initiateForTesting()
                
            case .voiceToText:
                resultVC.transcripts = CSConfidence.initiateForTesting()
            case .textToSpeech:
                break
            }
            resultVC.feature = item
            return resultVC
        }
        
        return ResultViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Result"
        
        
        switch featureType {
            case .text:
                let groupEntities = entities.group { $0.type }
                
                for (key,entities) in groupEntities  {
                    let section = EntitySection(name: key, entities: entities)
                    sections.append(section)
                }
            case .image(let image):
                if let nonnill = image {
                    let widthCell:CGFloat = view.bounds.width
                    let widthImageView:CGFloat = widthCell - Padding.normal.rawValue*2
                    let ratioImage = nonnill.size.height/nonnill.size.width
                    let heightImageView:CGFloat = ratioImage*widthImageView
                    
                    sizeOfImageHeader = (widthImageView: widthImageView,heightImageView: heightImageView,widthImage: nonnill.size.width,heightImage:nonnill.size.height)
                }
            default:
                break
        }

        
        
        // Do any additional setup after loading the view.
        setupSubViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let contentSize = CGSize(width: scrollView.frame.width*CGFloat(featureType.attributes.count), height: scrollView.frame.height)
        scrollView.contentSize = contentSize
        
        categoriesHeader.forEach { (view) in
            UIManager.addShawdow(to: view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupSegmentView(view: segmentView, items: segmentItems)
        segmentView.selectedSegmentioIndex = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private function
    func setupSubViews() {
        
        // add two tableview

        
        segmentView = initSegmentView()
        view.addSubview(segmentView)
        
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.snp.makeConstraints { [unowned self](make) in

            make.top.equalTo(self.topLayoutGuide.snp.bottom)

            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        segmentView.valueDidChange = { [unowned self](_,idx:Int) in
            let offset:CGFloat = CGFloat(idx) * self.scrollView.frame.width
            self.scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
        
        scrollView.delegate = self
        scrollView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(segmentView.snp.bottom)
        }
        
        setupScrollableContent()
    }
    
    func setupScrollableContent() {
        let contentView = UIView()
        contentView.backgroundColor = COLOR_MAIN
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.equalTo(scrollView)
            make.width.equalTo(view).multipliedBy(featureType.attributes.count)
        }
    

        for idx in 0..<featureType.attributes.count {
            let attribute = featureType.attributes[idx]
            
            //set up segment View
            var segmentItem = SegmentioItem(title: attribute.segmentTitle, image: nil)
            
            
            switch attribute {
            case .GCConfidence:
                if transcripts.count == 0 {
                    segmentItem.title = "No matching"
                }
            default:
                break
            }
            segmentItems.append(segmentItem)
            
            // set up table view
            let tbl = UITableView(frame: CGRect.zero, style: .plain)
            
            tbl.delegate = self
            tbl.dataSource = self
            
            let nibEntity = UINib(nibName: "EntityCell", bundle: nil)
            tbl.register(nibEntity, forCellReuseIdentifier: EntityCell.indetifier)
            
            let nibSentiment = UINib(nibName: "SentenceCell", bundle: nil)
            tbl.register(nibSentiment, forCellReuseIdentifier: SentenceCell.indetifier)
            
            let nibLabel = UINib(nibName: "CVLabelCell", bundle: nil)
            tbl.register(nibLabel, forCellReuseIdentifier: CVLabelCell.indetifier)
            
            let nibWeb = UINib(nibName: "CVWebCell", bundle: nil)
            tbl.register(nibWeb, forCellReuseIdentifier: CVWebCell.indetifier)
            
            let nibConfidence = UINib(nibName: "ConfidenceCell", bundle: nil)
            tbl.register(nibConfidence, forCellReuseIdentifier: ConfidenceCell.indetifier)
            
            let nibEntitySentiment = UINib(nibName: "EntitySentimentCell", bundle: nil)
            tbl.register(nibEntitySentiment, forCellReuseIdentifier: EntitySentimentCell.indetifier)
            
            let nibDetectedText = UINib(nibName: "DetectedTextCell", bundle: nil)
            tbl.register(nibDetectedText, forCellReuseIdentifier: DetectedTextCell.indetifier)
            
            tbl.sectionHeaderHeight = UITableViewAutomaticDimension
            tbl.estimatedSectionHeaderHeight = attribute.estimatedHeightOfHeadeView

            
            tbl.rowHeight = UITableViewAutomaticDimension
            tbl.estimatedRowHeight = attribute.estimateRowHeight
            
            tbl.tableFooterView = UIView()
            contentView.addSubview(tbl)
            
            tbl.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                
                if idx == 0 {
                    make.left.equalToSuperview()
                    make.width.equalTo(self.scrollView)
                } else {
                    make.left.equalTo(tblsCategory[idx-1].snp.right)
                    make.width.equalTo(tblsCategory[idx-1])
                }
            }
            
            print("\(#function) idx \(idx) tlb \(tbl)")
            tblsCategory.append(tbl)
        }
        
        
        
    
        segmentView.selectedSegmentioIndex = 0
    }
    
    func initSegmentView() -> Segmentio {
        let segmentView = Segmentio(frame: CGRect.zero)
        
        return segmentView
    }
    
    func setupSegmentView(view:Segmentio,items:[SegmentioItem]) {
        
        
        let indicatorOptions = SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 3, color: .orange)
        
        let horizontalSeparatorOpt = SegmentioHorizontalSeparatorOptions(type: .none, height: 0, color: .white)
        
        let verticalSeparatorOpt = SegmentioVerticalSeparatorOptions(ratio: 0.8, color: .clear)
        
        let defaultState:SegmentioState = SegmentioState(backgroundColor: .white, titleFont: UIFont.boldSystemFont(ofSize: 15), titleTextColor: COLOR_MAIN)
        
        let selectedState:SegmentioState = SegmentioState(backgroundColor: COLOR_MAIN, titleFont: UIFont.boldSystemFont(ofSize: 15), titleTextColor: UIColor.white)
        
        let states:SegmentioStates = SegmentioStates(defaultState,selectedState,SegmentioState())
        
        let options = SegmentioOptions(backgroundColor: UIColor.white,
                                       segmentPosition: .dynamic,
                                       indicatorOptions: indicatorOptions,
                                       horizontalSeparatorOptions: horizontalSeparatorOpt,
                                       verticalSeparatorOptions: verticalSeparatorOpt,
                                       labelTextAlignment: .center,
                                       segmentStates: states,
                                       animationDuration: 0.3)
        
        view.setup(content: items, style: SegmentioStyle.onlyLabel, options: options)
    }
    
    // Actions && Seclector
    @IBAction func changingValue_segmentView(_ sender: Any) {
        let offset:CGFloat = CGFloat(segmentView.selectedSegmentioIndex) * scrollView.frame.width
        scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
    
    
    @objc func endScrollingAnimation(_ scrollView:UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        print("Offset 3: \(scrollView.contentOffset.x)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ResultViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let indexAtt = tblsCategory.index(of: tableView) else {
            return 0
        }
        
        let attribute = featureType.attributes[indexAtt]
        

        switch attribute {
            case .NLEntity:
                return sections.count
            case .NLCategory:
                
                return categories.count
            case .NLSentence:
                return 2
            case .CVLabel,.GCConfidence:
                return 1
            case .CVWebDectection:
                return 2
            case .CVSafeSearchAnnotation:
                return 1
            case .CVTextAnnotation:
                return 1
            case .CVImageProperties:
                return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let indexAtt = tblsCategory.index(of: tableView) else {
            return 0
        }
        
        let attribute = featureType.attributes[indexAtt]
        
        print("\(#function) idx \(indexAtt) tlb \(tableView) \(attribute)")

        switch attribute {
        case .NLEntity:
            let sectionInfor = sections[section]
            return sectionInfor.cells.count
        case .NLSentence:
            switch section {
                case 0:
                    return sentences.count
                case 1:
                    return entities.count
                default:
                    return 0
            }
        case .CVLabel:
            return labels.count
        case .CVWebDectection:
            switch section {
            case 0:
                return webDections.webEntities.count
            case 1:
                if webDections.matchingPage.count > 0 {
                    return webDections.matchingPage.count
                } else {
                    return webDections.visuallySimilarImages.count
                }
                
            default:
                return 0
            }
        case .CVSafeSearchAnnotation:
            return safeAnnotations.count
        case .GCConfidence:
            return transcripts.count
        case .CVTextAnnotation:
            return textAnnotation.count
        case .CVImageProperties:
            return dominantColors.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let indexAtt = tblsCategory.index(of: tableView) else {
            return UITableViewCell()
        }
        
        let attribute = featureType.attributes[indexAtt]
        
        switch attribute {
        case .NLEntity:
            if let cell = tableView.dequeueReusableCell(withIdentifier: EntityCell.indetifier) as? EntityCell {
                let sectionInfor = sections[indexPath.section]
                let entity = sectionInfor.cells[indexPath.row]
                cell.selectionStyle = .none
                cell.updateUI(entity: entity)
                return cell
            }
        case .NLSentence:

            switch indexPath.section {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: SentenceCell.indetifier) as? SentenceCell {
                    let sentence = sentences[indexPath.row]
                    cell.selectionStyle = .none
                    
                    if indexPath.row == 0 {
                        cell.updateUI(sentence: sentence,isEntireDocument: true)
                    } else {
                        cell.updateUI(sentence: sentence)
                    }
                    
                    return cell
                }
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: EntitySentimentCell.indetifier) as? EntitySentimentCell {
                    let entity = entities[indexPath.row]
                    cell.selectionStyle = .none
                    cell.updateUI(withEntity: entity, index: indexPath.row)
                    return cell
                }
            default:
                break
            }
        case .CVLabel,.CVImageProperties:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CVLabelCell.indetifier) as? CVLabelCell {
                
                cell.selectionStyle = .none
                switch attribute {
                    case .CVLabel:
                        let label = labels[indexPath.row]
                        cell.updateUI(withAnnotation: label)
                    case .CVImageProperties:
                        let dominant = dominantColors[indexPath.row]
                        cell.updateUI(withDominantColor: dominant)
                    default:
                        break
                }
                
                return cell
            }
        case .CVWebDectection:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CVWebCell.indetifier) as? CVWebCell {
                cell.selectionStyle = .none
                switch indexPath.section {
                case 0:
                    let entity = webDections.webEntities[indexPath.row]
                    cell.updateUI(withModel: entity)
                case 1:
                    if webDections.matchingPage.count > 0 {
                        let matchingPage = webDections.matchingPage[indexPath.row]
                        cell.updateUI(withMatchingPage: matchingPage.url)

                    } else {
                        let similarImageURL = webDections.visuallySimilarImages[indexPath.row]
                        cell.updateUI(withMatchingPage: similarImageURL)
                    }
                default:
                    break
                }
                
                return cell
            }
        case .GCConfidence:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ConfidenceCell.indetifier) as? ConfidenceCell {
                let transcript = transcripts[indexPath.row]
                cell.selectionStyle = .none
                cell.updateUI(withContent: transcript.transcript, confidence: transcript.confidence)
                return cell
            }
        case .CVTextAnnotation:
            if let cell = tableView.dequeueReusableCell(withIdentifier: DetectedTextCell.indetifier) as? DetectedTextCell {
                
                cell.selectionStyle = .none
                
                let annotaion = textAnnotation[indexPath.row]
                
                cell.updateContent(withAnnotation: annotaion)
                
                return cell
            }
        case .CVSafeSearchAnnotation:
            var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: safeAnnotationCellIdentifier)
            if (cell == nil) {
                cell = UITableViewCell(style: .value2,
                                       reuseIdentifier: safeAnnotationCellIdentifier)
            }
            let annotation = safeAnnotations[indexPath.row]
            
            cell?.selectionStyle = .none
            cell?.textLabel?.text = annotation.feature.capitalized
            cell?.detailTextLabel?.textAlignment = .right
            cell?.detailTextLabel?.text = annotation.likelihood.description
            
            return cell!
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let indexAtt = tblsCategory.index(of: tableView) else {
            return nil
        }
        
        let attribute = featureType.attributes[indexAtt]

        switch attribute {
        case .NLEntity:
            let sectionInfor = sections[section]
            
            let contentView = UIView()
            contentView.backgroundColor = sectionInfor.color
            let lblTitle = UILabel()
            lblTitle.font = UIFont.boldSystemFont(ofSize: 17)
            lblTitle.text = sectionInfor.name
            lblTitle.textColor = .white
            contentView.addSubview(lblTitle)
            
            lblTitle.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().offset(-8)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
            }
            
            return contentView
        case .NLCategory:
            let category = categories[section]
            
            let coverView = UIView()
            coverView.backgroundColor = .white
            
            let contentView = UIView()
            contentView.backgroundColor = .white
            contentView.tag = contentHeaderTag
            coverView.addSubview(contentView)
            categoriesHeader.append(contentView)
            
            contentView.snp.makeConstraints({ (make) in
                make.top.equalToSuperview().offset(8)
                make.left.equalToSuperview().offset(8)
                make.right.equalToSuperview().offset(-8)
                make.bottom.equalToSuperview().offset(-8)
            })
            
            let lblName = UILabel()
            lblName.font = UIFont.boldSystemFont(ofSize: 17)
            lblName.text = category.name
            lblName.numberOfLines = 2
            
            contentView.addSubview(lblName)
            
            lblName.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(16)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
            }
            
            let lblConfidence = UILabel()
            lblConfidence.font = UIFont.systemFont(ofSize: 17)
            lblConfidence.text = "Confidence: \(category.confidence)"
            contentView.addSubview(lblConfidence)
            
            lblConfidence.snp.makeConstraints({ (make) in
                make.top.equalTo(lblName.snp.bottom)
                make.left.right.equalTo(lblName)
                make.bottom.equalToSuperview()
            })
            
            return coverView
        case .CVTextAnnotation:
            print("Chung 1")
            
            let contentView = UIView()
            contentView.backgroundColor = UIColor.white
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = feature?.getImage()
            imageView.tag = Tag.imageViewOfImageExtraction.rawValue
            
            contentView.addSubview(imageView)
            
            let edgeInset:UIEdgeInsets = UIEdgeInsetsMake(Padding.normal.rawValue, Padding.normal.rawValue, Padding.normal.rawValue, Padding.normal.rawValue)
            
            imageView.snp.makeConstraints { [unowned self](make) in
                make.edges.equalToSuperview().inset(edgeInset)
                make.height.equalTo(self.sizeOfImageHeader.heightImageView)
            }
            
            return contentView

        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let indexAtt = tblsCategory.index(of: tableView) else {
            return nil
        }
        
        let attribute = featureType.attributes[indexAtt]
        
        if attribute.titlesOfSections.count > 0 {
            return attribute.titlesOfSections[section]
        } else {
            return nil
        }
    }
}

extension ResultViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        guard let indexAtt = tblsCategory.index(of: tableView) else {
//            return 0
//        }
//
//        let attribute = featureType.attributes[indexAtt]
//
//        switch attribute {
//        case .CVTextAnnotation:
//            return sizeOfImageHeader.heightCell
//        default:
//            return attribute.estimatedHeightOfHeadeView
//        }
//    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let indexAtt = tblsCategory.index(of: tableView) else {
            return
        }
        
        let attribute = featureType.attributes[indexAtt]
        
        switch attribute {
        case .CVTextAnnotation:
            if let imageView = view.viewWithTag(Tag.imageViewOfImageExtraction.rawValue) {
                for annotation in textAnnotation {
                    let colorAnnotation = UIColor.random
                    let transformedList = transformToDisplayOnImageView(withList: annotation.boundingPoly)
                    for idx in 0..<(transformedList.count-1) {
                        drawLine(onLayer: imageView.layer, fromPoint: transformedList[idx], toPoint: transformedList[idx+1], color: colorAnnotation)
                    }
                }
            }
        default:
            break
        }

    }
    
    func drawLine(onLayer layer: CALayer, fromPoint start: CGPoint, toPoint end: CGPoint, color:UIColor) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.strokeColor = color.cgColor
        layer.addSublayer(line)
    }
    
    func transformToDisplayOnImageView(withList list:[CGPoint]) -> [CGPoint] {
        var listOfPointsClosed:[CGPoint] = []
    
        for pts in list {
            let transformPts = CGPoint(x: pts.x*sizeOfImageHeader.widthImageView/sizeOfImageHeader.widthImage, y: pts.y*sizeOfImageHeader.heightImageView/sizeOfImageHeader.heightImage)
            listOfPointsClosed.append(transformPts)
        }
        
        listOfPointsClosed.append(listOfPointsClosed[0])
        
        return listOfPointsClosed
    }
    
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.subviews.forEach { (subView) in
//
//        }
//    }
}

extension ResultViewController:UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(UIScrollViewDelegate.scrollViewDidEndScrollingAnimation), with: nil, afterDelay: 0.3)
        if Int(scrollView.contentOffset.x) != 0 {
            indexOfPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        }
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        segmentView.selectedSegmentioIndex = indexOfPage
    }
}

