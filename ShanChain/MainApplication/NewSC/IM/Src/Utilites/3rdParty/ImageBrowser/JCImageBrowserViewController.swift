//
//  JCImageBrowserViewControllerswift
//  JChatSwift
//
//  Created by oshumini on 16/6/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

class JCImageBrowserViewController: UIViewController {
    
    var messages: [JCMessageType]?
    var conversation: JMSGConversation!
    var currentMessage: JCMessageType!
    var imageArr: [UIImage]!
    var imgCurrentIndex:Int = 0
    var chatImageMessages:[JMSGMessage]?
    
    fileprivate lazy var CellIdentifier = "JCMessageImageCollectionViewCell"
    fileprivate var imageBrowser: UICollectionView!
    fileprivate var imageMessages: [JMSGMessage]!
    fileprivate var isMessageType = false
    
    fileprivate var selectImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black        
        if let messages = messages {
            imageMessages = getImageMessages(messages)
            if imageMessages.count > 0 {
                if chatImageMessages == nil {
                    if let index = imageMessages.index(where: { (m) -> Bool in
                        m.mark == currentMessage.msgId
                    }) {
                        imgCurrentIndex = index
                    } else {
                        imgCurrentIndex = 0
                    }
                }
                isMessageType = true
            }
        }
        
        setupImageBrowser()
    }
    
    override func viewDidLayoutSubviews() {
       imageBrowser.scrollToItem(at: IndexPath(item: imgCurrentIndex, section: 0), at: .left, animated: false)
    }
    
    func getImageMessages(_ messages: [JCMessageType]) -> [JMSGMessage] {
        var imageMessages: [JMSGMessage] = []
        for message in messages {
            if message.targetType != .chatRoom{
                guard let msg = conversation.message(withMessageId: message.msgId) else {
                    continue
                }
                 msg.mark = message.msgId
                if msg.contentType == .image {
                    imageMessages.append(msg)
                }
            }else{
                
                if let tmp = chatImageMessages {
                    imageMessages = tmp
                }else {
                    let chatRoom = conversation.target as? JMSGChatRoom
                    guard let jcMessageContent =  message.content as? JCMessageImageContent else{
                        continue
                    }
                    let data = jcMessageContent.image?.jpegData(compressionQuality: 1.0)
                    
                    let jmsgMessageContent:JMSGImageContent = JMSGImageContent.init(imageData:data!)!
                    print("jmsgMessageContent mefiaID",jmsgMessageContent.mediaID ?? "defiaID nil")
                    let msg = JMSGMessage.createChatRoomMessage(with:jmsgMessageContent as JMSGAbstractContent, chatRoomId: (chatRoom?.roomID)!)
                    msg.mark = message.msgId
                    if msg.contentType == .image {
                        imageMessages.append(msg)
                    }
                }
            }
        }
        return imageMessages
    }
    
    func setupImageBrowser() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = view.frame.size
        imageBrowser = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        view.addSubview(imageBrowser)
        
        imageBrowser.backgroundColor = UIColor.clear
        imageBrowser.delegate = self
        imageBrowser.dataSource = self
        imageBrowser.minimumZoomScale = 0
        imageBrowser.isPagingEnabled = true
        imageBrowser.register(UINib(nibName: "JCMessageImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CellIdentifier)
    }
    
    func singleTapImage(_ gestureRecognizer:UITapGestureRecognizer)  {
        dismiss(animated: true, completion: nil)
    }
    
    func doubleTapImage(_ gestureRecognizer:UITapGestureRecognizer) {
        let cell = imageBrowser.cellForItem(at: currentIndex()) as! JCMessageImageCollectionViewCell
        cell.adjustImageScale()
    }
    
    
    fileprivate func currentIndex() -> IndexPath {
        let itemIndex:Int = Int(imageBrowser.contentOffset.x / imageBrowser.frame.size.width)
        return IndexPath(item: itemIndex, section: 0)
    }

}

extension JCImageBrowserViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMessageType {
            return imageMessages.count
        }
        return imageArr.count
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
//        return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
//    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath)
        if let cell = cell as? JCMessageImageCollectionViewCell {
            if isMessageType {
                cell.setMessage(imageMessages[indexPath.row])
            } else {
                cell.setImage(image: imageArr[indexPath.row])
            }
            
            cell.delegate = self
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }
}

extension JCImageBrowserViewController: JCImageBrowserCellDelegate {
    func singleTap() {
        dismiss(animated: true, completion: nil)
    }
    
    func longTap(tableviewCell cell: JCMessageImageCollectionViewCell) {
        selectImage = cell.messageImage.image
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: NSLocalizedString("sc_cancel", comment: "字符串"), destructiveButtonTitle: nil, otherButtonTitles: "保存到手机")
        actionSheet.show(in: view)
        SAIInputBarLoad()
    }
}

extension JCImageBrowserViewController: UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            view.becomeFirstResponder()
            if let image = selectImage {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer){
        if error == nil {
            MBProgressHUD_JChat.show(text: "保存成功", view: view)
        } else {
            MBProgressHUD_JChat.show(text: "保存失败，请重试", view: view)
        }
    }

}
