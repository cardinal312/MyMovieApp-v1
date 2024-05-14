//
//  ChatController.swift
//  MyMovieApp
//
//  Created by Macbook on 7/5/24.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SDWebImage

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

struct Sender: SenderType {
    var photoURL: String?
    var senderId: String
    var displayName: String
}

final class ChatController: MessagesViewController {
    
    
    //MARK: - Variables
    private var messages: [Message] = []
    let dataBaseManger = DataBaseManager.shared
    
    var chatID: String?
    var otherId: String?
    var avatar: String?
    let selfSender = Sender(senderId: "1", displayName: "Cardinal")
    let otherSender = Sender(senderId: "2", displayName: "")

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMessagesCollectionView()
        
        // search if chatID == nil or not
        
        if chatID == nil {
            dataBaseManger.getConvoId(otherId: otherId ?? "") { [weak self] chatId in
                    
                    self?.chatID = chatId
                self?.getMessages(convoId: chatId)
            }
        }
    }
    
    func getMessages(convoId: String) {
            dataBaseManger.getAllMessages(chatId: convoId) { [weak self] messages in
                DispatchQueue.main.async {
                    self?.messages = messages

                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                }
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        //MARK: - Custom UITabbar Overrides
        guard let tb = navigationController?.tabBarController as? MainTabBarControllerViewController else { return }
        navigationController?.navigationBar.tintColor = .gray
        tb.customBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let tb = navigationController?.tabBarController as? MainTabBarControllerViewController else { return }
        tb.customBar.isHidden = false
        navigationController?.navigationBar.tintColor = .white
    }
}

extension ChatController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    //MARK: - Message Collection View Base Methods
    var currentSender: MessageKit.SenderType {
        selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
        
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        self.messages.count
        
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let url = URL(string: avatar ?? "") else { return }
        avatarView.sd_setImage(with: url)
        avatarView.tintColor = .red
    }
}

extension ChatController: InputBarAccessoryViewDelegate {
    
    //MARK: - Send messages
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let msg = Message(sender: selfSender, messageId: "", sentDate: Date(), kind: .text(text))
        messages.append(msg)
        
        dataBaseManger.sendMessage(otherId: self.otherId ?? "", convoId: self.chatID, text: text) { [weak self] convoId in
            
            DispatchQueue.main.async { [weak self] in
                inputBar.inputTextView.text = nil
                self?.messagesCollectionView.reloadDataAndKeepOffset()
            }
            
            self?.chatID = convoId
            
        }
    }
    
    //MARK: - Setup MessagesCollectionView
    
    private func setupMessagesCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        // messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        messageInputBar.inputTextView.dataDetectorTypes = .link
        messageInputBar.inputTextView.dataDetectorTypes = .phoneNumber
        messageInputBar.inputTextView.autocapitalizationType = .none
        messageInputBar.inputTextView.indicatorStyle = .default
        messageInputBar.inputTextView.textColor = .gray
        messagesCollectionView.keyboardDismissMode = .onDrag
        messageInputBar.inputTextView.placeholder = "Enter message"
        messageInputBar.isTranslucent = true
        showMessageTimestampOnSwipeLeft = true
        messageInputBar.inputTextView.isScrollEnabled = true
    }
}
    
//    extension ChatController: MessageCellDelegate {
//        
//        func didTapBackground(in cell: MessageKit.MessageCollectionViewCell) {
//            //
//        }
//        
//        func didTapMessage(in cell: MessageKit.MessageCollectionViewCell) {
//            //
//        }
//        
//        func didTapAvatar(in cell: MessageKit.MessageCollectionViewCell) {
//            //
//        }
//        
//        func didTapCellTopLabel(in cell: MessageKit.MessageCollectionViewCell) {
//            //
//        }
//        
//        func didTapCellBottomLabel(in cell: MessageKit.MessageCollectionViewCell) {
//            //
//        }
//        
//        func didTapMessageTopLabel(in cell: MessageKit.MessageCollectionViewCell) {
//            //
//        }
//        
//        func didTapMessageBottomLabel(in cell: MessageKit.MessageCollectionViewCell) {
//            //
//        }
//        
//        func didTapAccessoryView(in cell: MessageKit.MessageCollectionViewCell) {
//            //
//        }
//        
//        func didTapImage(in cell: MessageKit.MessageCollectionViewCell) {
//            //
//        }
//        
//        func didTapPlayButton(in cell: MessageKit.AudioMessageCell) {
//            //
//        }
//        
//        func didStartAudio(in cell: MessageKit.AudioMessageCell) {
//            //
//        }
//        
//        func didPauseAudio(in cell: MessageKit.AudioMessageCell) {
//            //
//        }
//        
//        func didStopAudio(in cell: MessageKit.AudioMessageCell) {
//            //
//        }
//    }
//}
