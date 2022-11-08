//
//  ViewController.swift
//  demoZalo
//
//  Created by Huy on 02/11/2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import CoreLocation

class ViewController: MessagesViewController, MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate, InputBarAccessoryViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{
    
    let locationMangger = CLLocationManager()
    
    var isFisrtUser: Bool = true
    
    var messages: [ChatMessage] = []
    
    let nkSender = Sender(senderId: "firstUser", displayName: "Huy Hoang")
    let secondSender = Sender(senderId: "secondUser", displayName: "Anh Tu")

    override func viewDidLoad() {
        super.viewDidLoad()
        locationMangger.delegate = self
        navigationItem.title = currentSender.displayName
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        locationMangger.distanceFilter = 15
        locationMangger.desiredAccuracy = kCLLocationAccuracyBest
        locationMangger.requestAlwaysAuthorization()
        locationMangger.startUpdatingLocation()
       
        
    }
    
    var currentSender: SenderType {
        if isFisrtUser {
            return nkSender
        }
        return secondSender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let tempMessage = ChatMessage(sender: currentSender, messageId: "1", sentDate: .now, kind: .text(inputBar.inputTextView.text))
        messages.append(tempMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        
    }
    
//    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
//        <#code#>
//    }
//
//    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
//        <#code#>
//    }
//
//    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
//        <#code#>
//    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
            avatarView.image = UIImage(named: "Pic1")
    }
    

    @IBAction func btnPicturePress(_ sender: UIButton) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
        let tempMessage = ChatMessage(sender: currentSender, messageId: "1", sentDate: .now, kind: .photo(Media(placeholderImage: image, size: CGSize(width: 200, height: 150))))
        messages.append(tempMessage)
        messagesCollectionView.reloadData()
        }
    }
    
    @IBAction func btnSwitchUserPress(_ sender: UIButton) {
        if isFisrtUser{
            isFisrtUser = false
            navigationItem.title = currentSender.displayName
            messagesCollectionView.reloadData()
        }
        else {
            isFisrtUser = true
            navigationItem.title = currentSender.displayName
            messagesCollectionView.reloadData()
        }
    }
}

public struct Sender: SenderType {
    public let senderId: String
    public let displayName: String
}

struct ChatMessage: MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    }
struct Media: MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
}
struct Location: LocationItem {
    var location: CLLocation
    var size: CGSize
}


