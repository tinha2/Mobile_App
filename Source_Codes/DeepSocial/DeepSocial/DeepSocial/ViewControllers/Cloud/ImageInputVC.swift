//
//  ImageInputVC.swift
//  DeepSocial
//
//  Created by Chung BD on 5/26/18.
//  Copyright © 2018 ChungBui. All rights reserved.
//

import UIKit
import RxSwift

class ImageInputVC: InputViewController {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnProcess: UIButton!
    
    let bag = DisposeBag()
    
    var isTookPicture:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // add bar button for adding image
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchingInside_btnAddingImage(sender:)))
        navigationItem.rightBarButtonItem = addBtn
        
        btnProcess.backgroundColor = UIColor.orange
        btnProcess.setTitleColor(UIColor.white, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showOptionsForGettingImage() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionByCamera = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.openCameraPicker()
            }
            
        }
        alert.addAction(actionByCamera)
        
        let actionChooseFromLibrary = UIAlertAction(title: "Choose From Library", style: .default) { (_) in
            self.openImagePicker()
        }
        
        alert.addAction(actionChooseFromLibrary)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func openCameraPicker() -> Void {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func openImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        if let mediaTypePhotoLibrary = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
            imagePicker.mediaTypes = mediaTypePhotoLibrary
        }
        
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showAlertForInsertImage() {
        UIManager.showAlert(withViewController: self, content: "Need to insert image", type: .error)
    }
    
    func requestToMLCloud(with image:UIImage) {
        feature?.feature = Feature.image(image)
        
        #if DEV
            let resultVC = ResultViewController.initiateForTesting(withFeature: feature!)
            self.navigationController?.pushViewController(resultVC, animated: true)
        #else
        
            view.showLoading()
            guard let dataImage = UIImageJPEGRepresentation(image, 0.5) else {
                self.view.hideLoading()
                return
            }
        
            let strBase64 = dataImage.base64EncodedString(options: .lineLength64Characters)
        
            NLCloud.extractImage(withContent: strBase64)
                .debug()
                .observeOn(MainScheduler.instance)
                .do(onNext: { [unowned self] _ in self.view.hideLoading() })
                .subscribe(onNext: { [unowned self] (response:Response) in
                    switch response {
                    case .status(_,let str, _):
                        UIManager.showAlert(withViewController: self, content: str)
                    case .data(let json):
                        let resultVC = ResultViewController.initiate(json: json,featureValue: self.feature!)
                        self.navigationController?.pushViewController(resultVC, animated: true)
                        break
                    }
                })
                .disposed(by: bag)

        #endif
    }
    
    // MARK: - Actions
    @objc func touchingInside_btn(sender:UIButton) {

    }
    
    @objc func touchingInside_btnAddingImage(sender:UIBarButtonItem) {
        showOptionsForGettingImage()
    }

    @objc @IBAction func touchingInside_btnProcess(sender:UIButton) {
        #if DEV
            if let imageSample = UIImage(named: "bus.jpg") {
                requestToMLCloud(with: imageSample)
            }
        #else
        if let img = imgView.image, isTookPicture {
            requestToMLCloud(with: img)
        } else {
            showAlertForInsertImage()
        }

        #endif
        
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

extension ImageInputVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imgView.image = chosenImage
        isTookPicture = true
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
