//
//  ProfileController.swift
//  MyMovieApp
//
//  Created by Macbook on 8/5/24.
//

import UIKit
import SDWebImage

final class ProfileController: UIViewController  {
    
    //MARK: - UI Components
    private let profileFotoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.fill"))
        iv.backgroundColor = .white
        iv.tintColor = .black
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.red.cgColor
        return iv
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        ip.allowsEditing = false
        ip.mediaTypes = ["public.image", "public.movie"]
        return ip
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Loading"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Loading"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let chosenLanguageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "You need to set language"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - languageButton button config
    private lazy var languageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(languageButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let languageButtonTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Language"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemBackground
        return label
    }()
    
    private let languageButtonArrowImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "arrowRight")
        return image
    }()
    
    //MARK: - Terms & Conditions button config
    private lazy var termsConditionsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(termsConditionsButtonPressed), for: .touchUpInside)
        return button
    }()
    // функция обработки нажатия на кнопку Terms & Conditions
    @objc private func termsConditionsButtonPressed(sender: UIButton) {
        sender.alpha = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1.0
        }
        let secondDestinationVC = TermsController()
        navigationController?.pushViewController(secondDestinationVC, animated: true)
    }
    
    private let termsConditionsButtonTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Terms & Conditions"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemBackground
        return label
    }()
    
    private let termsConditionsButtonArrowImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "arrowRight")
        return image
    }()
    
    //MARK: - signOutButton button config
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(signOutButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let signOutButtonTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Sign Out"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemBackground
        return label
    }()
    
    private let signOutButtonArrowImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "figure.walk.departure")
        image.tintColor = .systemBackground
        return image
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupNavigationBar()
        self.setupUI()
    
        //MARK: - Fetch Users
        DataBaseManager.shared.fetchUser { [weak self] user, _  in
            guard let self = self else { return }
            guard let user = user else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.userNameLabel.text = user.username
                self.emailLabel.text = user.email
                guard let url = URL(string: user.avatar) else { return }
                self.profileFotoImageView.sd_setImage(with: url)
                
                guard let imageData = UserDefaults.standard.value(forKey: "avatar") as? Data else { return }
            }
        }
    }
    
    //MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .gray
        var image = UIImage(named: .homeLeftBarButton)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.app"), style: .plain, target: self, action: #selector(didTapDismiss))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Profile"
    }
    
    private func handlePhoto(_ info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            UserDefaults.standard.register(defaults: ["avatar":image.jpegData(compressionQuality: 100)!])
            UserDefaults.standard.set(image.jpegData(compressionQuality: 100), forKey: "avatar")
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.profileFotoImageView.image = image
            }
            
            let pressedImage = image.jpegData(compressionQuality: 0.1 /*compressionQuality*/)
            
            guard let imageData = pressedImage else { return }
            
            StorageManager.shared.uploadProfilePicture(with: imageData, fileName: image.description) { [weak self] results in
                guard let self = self else { return }
                
                switch results {
                case .success(let imageUrl):
                    guard let url = URL(string: imageUrl) else { return }
                    
                    //SAVE IMAGE TO LOCAL STORAGE
                    DispatchQueue.main.async { [weak self] in
                        self?.profileFotoImageView.sd_setImage(with: url)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - UImagePicker Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.mediaType] as? String == "public.image" {
            //pass handle photo function
            self.handlePhoto(info)
        } else {
            print("Can't choose mediatype")
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Selectors
    //MARK: - функция обработки нажатия на кнопку выбора языка
    
    @objc private func languageButtonPressed(sender: UIButton) {
        sender.alpha = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1.0
        }
        let destinationVC = LanguageController()
        destinationVC.delegate = self
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc private func didTapImageView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.present(self.imagePickerController, animated: true)
        }
    }
    
    // функция обработки нажатия на кнопку signOutButton( здесь ничего не происходит кроме визуального эффекта)
    @objc private func signOutButtonPressed(sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "avatar")
        
        AuthManager.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showLogoutErrorAlert(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
            // MARK: - UserDefaults, signOut Setting
            UserDefaults.standard.set(true, forKey: "signOut")
        }
        sender.alpha = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1.0
        }
    }
    
    @objc private func didTapDismiss() {
        dismiss(animated: true)
    }
    
    //MARK: - LAYOUT
    
    private func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        profileFotoImageView.addGestureRecognizer(tap)
        
        self.profileFotoImageView.layer.cornerRadius = 40
        
        self.view.addSubview(profileFotoImageView)
        self.view.addSubview(userNameLabel)
        self.view.addSubview(emailLabel)
        self.view.addSubview(chosenLanguageLabel)
        
        self.view.addSubview(languageButton)
        self.languageButton.addSubview(languageButtonTitleLabel)
        self.languageButton.addSubview(languageButtonArrowImage)
        
        self.view.addSubview(termsConditionsButton)
        self.termsConditionsButton.addSubview(termsConditionsButtonTitleLabel)
        self.termsConditionsButton.addSubview(termsConditionsButtonArrowImage)
        
        self.view.addSubview(signOutButton)
        self.signOutButton.addSubview(signOutButtonTitleLabel)
        self.signOutButton.addSubview(signOutButtonArrowImage)
        
        NSLayoutConstraint.activate([
            profileFotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileFotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileFotoImageView.heightAnchor.constraint(equalToConstant: 80),
            profileFotoImageView.widthAnchor.constraint(equalToConstant: 80),
            
            userNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            userNameLabel.leadingAnchor.constraint(equalTo: profileFotoImageView.trailingAnchor, constant: 24),
            
            emailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            
            chosenLanguageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chosenLanguageLabel.bottomAnchor.constraint(equalTo:  languageButton.topAnchor, constant: -15),
            
            //MARK: - languageButton button config
            languageButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 100),
            languageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            languageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            languageButton.heightAnchor.constraint(equalToConstant: 56),
            
            languageButtonTitleLabel.leadingAnchor.constraint(equalTo: languageButton.leadingAnchor, constant: 24),
            languageButtonTitleLabel.centerYAnchor.constraint(equalTo: languageButton.centerYAnchor),
            
            languageButtonArrowImage.trailingAnchor.constraint(equalTo: languageButton.trailingAnchor, constant: -24),
            languageButtonArrowImage.centerYAnchor.constraint(equalTo: languageButton.centerYAnchor),
            //MARK: - Terms & Conditions button config
            termsConditionsButton.topAnchor.constraint(equalTo: languageButton.bottomAnchor, constant: 240),
            termsConditionsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            termsConditionsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            termsConditionsButton.heightAnchor.constraint(equalToConstant: 56),
            
            termsConditionsButtonTitleLabel.leadingAnchor.constraint(equalTo: termsConditionsButton.leadingAnchor, constant: 24),
            termsConditionsButtonTitleLabel.centerYAnchor.constraint(equalTo: termsConditionsButton.centerYAnchor),
            
            termsConditionsButtonArrowImage.trailingAnchor.constraint(equalTo: termsConditionsButton.trailingAnchor, constant: -24),
            termsConditionsButtonArrowImage.centerYAnchor.constraint(equalTo: termsConditionsButton.centerYAnchor),
            //MARK: - Sign out button config
            signOutButton.topAnchor.constraint(equalTo: termsConditionsButton.bottomAnchor, constant: 28),
            signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signOutButton.heightAnchor.constraint(equalToConstant: 56),
            
            signOutButtonTitleLabel.leadingAnchor.constraint(equalTo: signOutButton.leadingAnchor, constant: 24),
            signOutButtonTitleLabel.centerYAnchor.constraint(equalTo: signOutButton.centerYAnchor),
            
            signOutButtonArrowImage.trailingAnchor.constraint(equalTo: signOutButton.trailingAnchor, constant: -24),
            signOutButtonArrowImage.centerYAnchor.constraint(equalTo: signOutButton.centerYAnchor),
        ])
    }
}

extension ProfileController: LangugeSelectionDelegate {
    
    func didSelectLanguage(_ name: String?) {
        guard let name = name else { return }
        self.languageButtonTitleLabel.textColor = .white
        self.languageButtonTitleLabel.text = name
    }
}
