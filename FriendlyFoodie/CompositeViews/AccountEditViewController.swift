//
//  PlaceInfoInputViewController.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/15.
//

import UIKit
import MapKit

// Edit view for the user's account
class AccountEditViewController: UIViewController {

    // Necessary variables
    var accountToEdit: AccountData? = nil
    var parentView : ProfileViewController? = nil
    
    // IBOutlet connections
    @IBOutlet weak var FirstNameInput: UITextField!
    @IBOutlet weak var LastNameInput: UITextField!
    @IBOutlet weak var ShortDescriptionInput: UITextView!
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ShortDescriptionInput.text = ""
        ShortDescriptionInput.layer.borderWidth = 1
        ShortDescriptionInput.layer.borderColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1.0).cgColor
        EditButton.addTarget(self,
                               action: #selector(handleClickSubmitButton),
                               for: .touchDown)
        CancelButton.addTarget(self,
                               action: #selector(handleClickCancelButton),
                               for: .touchDown)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FirstNameInput.text = accountToEdit?.first_name ?? ""
        LastNameInput.text = accountToEdit?.last_name ?? ""
        ShortDescriptionInput.text = accountToEdit?.description ?? ""
    }

    // Handle submitting for new information for the user
    @objc func handleClickSubmitButton() {
        
        guard let first_name = FirstNameInput.text,
              let last_name = LastNameInput.text,
              let description = ShortDescriptionInput.text,
              let account_id  = accountToEdit?.id else {
            print("Invalid inputs")
            return
        }
              
        if (first_name == "" || last_name == "")  {
            let alert = UIAlertController(title: "Input Error", message: "Name fields cannot be blank", preferredStyle: .alert)
            alert.addAction(UIAlertAction( title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        guard let newAccountData =  AccountDataManager.sharedInstance.editMyAccount(account_id: account_id, first_name: first_name, last_name: last_name, description: description) else {
            return
        }
        parentView?.updateProfileView(account: newAccountData)
        dismiss(animated: true, completion: nil)
    }
    
    // Handle click cancel and dismiss
    @objc func handleClickCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
