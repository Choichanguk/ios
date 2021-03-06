//
//  EditProfileViewController.swift
//  PlaySound
//
//  Created by james on 2021/09/16.
//

import UIKit
import Kingfisher
import Toast_Swift

class EditProfileViewController: UIViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    let profileImgSrc: String = API.IMAGE_URL + UserData.shared.userProfileImageSrc!
    
    var profileImgManager = ProfileImgManager()
    
    var originalImage: UIImage?
    var changedImage: UIImage?
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImgManager.delegate = self
        // Do any additional setup after loading the view.
        viewSetting()
        
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        picker.delegate = self
        
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        //profileImage.image = UserData.shared.userProfileImage
        
        guard let url = URL(string: self.profileImgSrc) else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        profileImage.kf.setImage(with: url, options: [.processor(processor)])
        
       // profileImage.kf.setImage(with: url)
        
        originalImage = profileImage.image
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func viewSetting() {
        
        confirmBtn.layer.cornerRadius = 25
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height/2
        profileImage.layer.borderColor = UIColor.orange.cgColor
        profileImage.layer.borderWidth = 10
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let alert =  UIAlertController()
        let library =  UIAlertAction(title: "????????????", style: .default) { (action) in
            
            self.openLibrary()

        }

        let camera =  UIAlertAction(title: "?????????", style: .default) { (action) in

            self.openCamera()

        }

        let cancel = UIAlertAction(title: "??????", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

        return true
    }
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
    
    
    //confirmButtom
    @IBAction func confirmBtnTapped(_ sender: Any) {
        
        //profileImgManager.updateProfileImg(userProfile: <#T##UIImage#>)
        //????????? ???????????? ?????????????????? ????????????.
        let changedImage = profileImage.image
        
        if originalImage!.isEqual(changedImage) {
            
            self.view.makeToast("???????????? ???????????? ???????????????")
            
        } else {
            
            profileImgManager.updateProfileImg(userProfile: changedImage!)
            
        }
        
        
    }
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = image
            
            print("????????? ?????? : \(image)")
            //UserData??? ???????????? ????????????. x -> ??????????????? ?????? ????????????.
            //UserData.shared.userProfileImage = image
            print(info)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: ProfileImgManagerDelegate {
    
    func didUpdateProfileImg() {
        
        self.view.makeToast("???????????? ?????? ???????????????")
        NotificationCenter.default.post(name: NSNotification.Name("UpdateProfileImage"), object: nil, userInfo: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func didNotUpdateProfileImg() {
        print("????????? ???????????? ??????")
    }
    
    
}
