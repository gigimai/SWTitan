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
import Alamofire

public class FakeMessageSender {

    public var onMessageChanged: ((message: MessageModelProtocol) -> Void)?
    public var messageSuccess:((message: MessageModelProtocol, responseText: String) -> Void)?
    public var messageIsPending:(() -> Void)?
    
    public func sendMessages(messages: [MessageModelProtocol]) {
        messages.forEach(sendMessage)
    }

    public func sendMessage(message: MessageModelProtocol) {
        message.status = .Success
        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["text": ""])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    self.messageSuccess?(message: message, responseText: "This is test API call")
                case .Failure(_):
                    self.messageSuccess?(message: message, responseText: "Call failed")
                }
        }
    }
    
    public func sendMessage(message: MessageModelProtocol, textMessage: String) {
        message.status = .Success
        Alamofire.request(.GET, "http://27afa497.ngrok.io/reply", parameters: ["text": textMessage])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let JSON = response.result.value
                    print(JSON)
                    self.messageSuccess?(message: message, responseText: "This is test API call")
                case .Failure(let error):
                    self.messageSuccess?(message: message, responseText: error.localizedDescription)
                }
        }
    }
}
