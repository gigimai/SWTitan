/*
 The MIT License (MIT)

 Copyright (c) 2015-present Badoo Trading Limited.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

import Foundation
import Chatto
import ChattoAdditions

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

func createTextMessageModel(uid: String, text: String, isIncoming: Bool) -> TextMessageModel {
    let messageModel = createMessageModel(uid, isIncoming: isIncoming, type: TextMessageModel.chatItemType)
    let textMessageModel = TextMessageModel(messageModel: messageModel, text: text)
    return textMessageModel
}

func createMessageModel(uid: String, isIncoming: Bool, type: String) -> MessageModel {
    let senderId = isIncoming ? "1" : "2"
    let messageStatus = isIncoming || arc4random_uniform(100) % 3 == 0 ? MessageStatus.Success : .Failed
    let messageModel = MessageModel(uid: uid, senderId: senderId, type: type, isIncoming: isIncoming, date: NSDate(), status: messageStatus)
    return messageModel
}

func createPhotoMessageModel(uid: String, image: UIImage, size: CGSize, isIncoming: Bool) -> PhotoMessageModel {
    let messageModel = createMessageModel(uid, isIncoming: isIncoming, type: PhotoMessageModel.chatItemType)
    let photoMessageModel = PhotoMessageModel(messageModel: messageModel, imageSize:size, image: image)
    return photoMessageModel
}

class FakeMessageFactory {
    static let demoTexts = [
        "Good choice.",
        "Where do you want to go?",
        "Are you going alone?",
        "I don't five a fuck",
        "Well, fuck you,too"
    ]
    
    static let demoAnswers = [
        "Hello" : ["How are you today?"],
        "Captain America" : ["Awesome. I guarantee you're gonna have a good time. #teamIronMan","Which theater do you want to go?"],
        "BHD" : ["Good choice. But which BHD?"],
        "Bitexco" : ["I've heard that's a good theater. Here is what we found"]
    ]

    class func createChatItem(uid: String) -> MessageModelProtocol {
        let isIncoming: Bool = arc4random_uniform(100) % 2 == 0
        return self.createChatItem(uid, isIncoming: isIncoming)
    }

    class func createChatItem(uid: String, isIncoming: Bool) -> MessageModelProtocol {
        return self.createTextMessageModel(uid, isIncoming: isIncoming)
    }
    
    class func createGreetingMessage() -> TextMessageModel {
        let text = "Hello \(UIDevice.currentDevice().name). I am Jarvis, your personal movie finding assistant. How can I help you?"
        return SWTitan.createTextMessageModel("", text: text, isIncoming: true)
    }

    class func createTextMessageModel(uid: String, isIncoming: Bool) -> TextMessageModel {
        let maxText = self.demoTexts.randomItem()
        return SWTitan.createTextMessageModel(uid, text: maxText, isIncoming: isIncoming)
    }
    
    class func createAnswerForKey(keyword : String, uid: Int) -> [TextMessageModel] {
        guard let answers = self.demoAnswers[insensitive: keyword] else {
            return [SWTitan.createTextMessageModel("\(uid)", text: "Sorry. I don't understand", isIncoming: true)]
        }
        var mutableUid = uid - 1
        return answers.map { (answer) in
            mutableUid += 1
            return SWTitan.createTextMessageModel("\(mutableUid)", text: answer, isIncoming: true)
            
        }
    }
    
    class func createTextMessageModel(uid: String, text: String, isIncoming: Bool) -> TextMessageModel {
        return SWTitan.createTextMessageModel(uid, text: text, isIncoming: isIncoming)
    }

    class func createPhotoMessageModel(uid: String, isIncoming: Bool) -> PhotoMessageModel {
        var imageSize = CGSize.zero
        switch arc4random_uniform(100) % 3 {
        case 0:
            imageSize = CGSize(width: 400, height: 300)
        case 1:
            imageSize = CGSize(width: 300, height: 400)
        case 2:
            fallthrough
        default:
            imageSize = CGSize(width: 300, height: 300)
        }

        var imageName: String
        switch arc4random_uniform(100) % 3 {
        case 0:
            imageName = "pic-test-1"
        case 1:
            imageName = "pic-test-2"
        case 2:
            fallthrough
        default:
            imageName = "pic-test-3"
        }
        return SWTitan.createPhotoMessageModel(uid, image: UIImage(named: imageName)!, size: imageSize, isIncoming: isIncoming)
    }
}

extension TextMessageModel {
    static var chatItemType: ChatItemType {
        return "text"
    }
}

extension PhotoMessageModel {
    static var chatItemType: ChatItemType {
        return "photo"
    }
}

class TutorialMessageFactory {
    static let messages = [
        ("text", "Welcome to Chatto! A lightweight Swift framework to build chat apps"),
        ("text", "It calculates sizes in the background for smooth pagination and rotation, and it can deal with thousands of messages with a sliding data source"),
        ("text", "Along with Chatto there's ChattoAdditions, with bubbles and the input component"),
        ("text", "This is a TextMessageCollectionViewCell. It uses UITextView with data detectors so you can interact with urls: https://github.com/badoo/Chatto, phone numbers: 07400000000, dates: 3 jan 2016 and others"),
        ("image", "pic-test-1"),
        ("image", "pic-test-2"),
        ("image", "pic-test-3"),
        ("text", "Those were some PhotoMessageCollectionViewCell. With some fake data transfer"),
        ("text", "Both Text and Photo cells inherit from BaseMessageCollectionViewCell which adds support for a failed icon and a timestamp you can reveal by swiping from the right"),
        ("text", "Each message is paired with a Presenter. Each presenter is responsible to present a message by managing a corresponding UICollectionViewCell. New types of messages can be easily added by creating new types of presenters!"),
        ("text", "Messages have different margins and only some bubbles show a tail. This is done with a decorator that conforms to ChatItemsDecoratorProtocol"),
        ("text", "Failed/sending status are completly separated cells. This helps to keep cells them simpler. They are generated with the decorator as well, but other approaches are possible, like being returned by the DataSource or using more complex cells"),
        ("text", "More info on https://github.com/badoo/Chatto. We are waiting for your pull requests!"),
    ]

    static func createMessages() -> [MessageModelProtocol] {
        var result = [MessageModelProtocol]()
        for (index, message) in self.messages.enumerate() {
            let type = message.0
            let content = message.1
            let isIncoming: Bool = arc4random_uniform(100) % 2 == 0

            if type == "text" {
                result.append(createTextMessageModel("tutorial-\(index)", text: content, isIncoming: isIncoming))
            } else {
                let image = UIImage(named: content)!
                result.append(createPhotoMessageModel("tutorial-\(index)", image:image, size: image.size, isIncoming: isIncoming))
            }
        }
        return result
    }
}

extension Dictionary where Key : StringLiteralConvertible {
    subscript(insensitive key : Key) -> Value? {
        get {
            let searchKey = String(key).lowercaseString
            for k in self.keys {
                let lowerK = String(k).lowercaseString
                if searchKey == lowerK {
                    return self[k]
                }
            }
            return nil
        }
    }
}
