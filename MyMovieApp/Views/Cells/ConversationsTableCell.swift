//
//  ConversationsTableCell.swift
//  MyMovieApp
//
//  Created by Macbook on 10/5/24.
//

import UIKit

final class ConversationsTableCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "ConversationsTableCell"
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 0.2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.8
        view.layer.cornerRadius = 12
        return view
    }()
    
    
    private let userImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.fill"))
        iv.backgroundColor = .white
        iv.tintColor = .black
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.red.cgColor
        return iv
    }()
    
    private lazy var userInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.text = "Loading"
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    // MARK: - Cell Methods
    public func configure(with model: CurrentUser) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.userInfoLabel.text = "\(model.username)"
            guard let url = URL(string: model.avatar) else { return }
            self.userImageView.sd_setImage(with: url)
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .systemBackground
        
        self.userImageView.layer.cornerRadius = 33.333
        
        self.contentView.addSubview(containerView)
        self.containerView.addSubview(userImageView)
        self.containerView.addSubview(userInfoLabel)
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            self.containerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            self.containerView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            self.containerView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            
            self.userImageView.heightAnchor.constraint(equalToConstant: 70),
            self.userImageView.widthAnchor.constraint(equalToConstant: 70),
            self.userImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 30),
            self.userImageView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            
            self.userInfoLabel.leadingAnchor.constraint(equalTo: self.userImageView.trailingAnchor, constant: 40),
            self.userInfoLabel.centerYAnchor.constraint(equalTo: self.userImageView.centerYAnchor)
        ])
    }
}
