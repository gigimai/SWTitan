//
//  ChatBotsViewController.swift
//  SWTitan
//
//  Created by MaiMai on 5/14/16.
//  Copyright © 2016 MaiMai. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions

class ChatBotsViewController: ChatViewController {
    
    init(dataSource: FakeDataSource) {
        self.dataSource = dataSource
        messageSender = dataSource.messageSender
        super.init(nibName: String(self.dynamicType), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        super.chatItemsDecorator = ChatItemsDemoDecorator()
        dataSource.delegate = self
        navigationController?.navigationBarHidden = false
        title = "Jarvis"
        chatDataSource = dataSource
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dataSource.greeting()
    }
    
    var messageSender = FakeMessageSender()
    var dataSource: FakeDataSource!
    
    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender)
    }()

    @objc
    private func addRandomIncomingMessage() {
        self.dataSource.addRandomIncomingMessage()
    }
    
    var chatInputPresenter: ChatInputBarPresenter!
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        self.configureChatInputBar(chatInputView)
        self.chatInputPresenter = ChatInputBarPresenter(chatInputView: chatInputView, chatInputItems: self.createChatInputItems())
        return chatInputView
    }
    
    func configureChatInputBar(chatInputBar: ChatInputBar) {
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonTitle = NSLocalizedString("Send", comment: "")
        appearance.textPlaceholder = NSLocalizedString("Type a message", comment: "")
        chatInputBar.setAppearance(appearance)
    }
    
    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        return [
            TextMessageModel.chatItemType: [
                TextMessagePresenterBuilder(
                    viewModelBuilder: TextMessageViewModelDefaultBuilder(),
                    interactionHandler: TextMessageHandler(baseHandler: self.baseMessageHandler)
                )
            ],
            PhotoMessageModel.chatItemType: [
                PhotoMessagePresenterBuilder(
                    viewModelBuilder: FakePhotoMessageViewModelBuilder(),
                    interactionHandler: PhotoMessageHandler(baseHandler: self.baseMessageHandler)
                )
            ],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()]
        ]
    }
    
    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        return items
    }
    
    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }

}
