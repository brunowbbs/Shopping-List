//
//  LoginViewController.swift
//  ShoppingList
//
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var labelCopyright: UILabel!
    @IBOutlet weak var buttonSignup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = Auth.auth().currentUser{
            guard let ListTableViewController = storyboard?.instantiateViewController(withIdentifier: "ListTableViewController") else {return}
            
            navigationController?.pushViewController(ListTableViewController, animated: false)
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: textFieldEmail.text!, password: textFieldPassword.text!){ result, error in
            guard let user = result?.user else {return}
            self.updateUserAndProceed(user: user);
            
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: textFieldEmail.text!, password: textFieldPassword.text!){ result, error in
            if let error  = error{
                /*let authErrorCode = AuthErrorCode(_nsError:error._code);
                switch authErrorCode{
                case .emailAlreadyInUse: print("Este email já está em uso.");
                case . weakPassword: print("A senha escolhida é muito fraca");
                default: print(authErrorCode);
                }*/
                print(error);
            }else{
                print("Usuário criado com sucesso");
                if let user = result?.user{
                    self.updateUserAndProceed(user:user);
                }
                
                
            }
        }
    }
    
    
    func updateUserAndProceed(user:User){
        if textFieldName.text!.isEmpty{
            gotoMainScreen();
        }else{
            let request = user.createProfileChangeRequest();
            request.displayName = textFieldName.text!;
            request.commitChanges{ error in
                self.gotoMainScreen();
            }
        }
    }
    
    func gotoMainScreen(){
        guard let ListTableViewController = storyboard?.instantiateViewController(withIdentifier: "ListTableViewController") else {return}
        
        show(ListTableViewController, sender: nil);
    }
    
}

