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

public class FakeMessageSender {

    public var onMessageChanged: ((message: MessageModelProtocol) -> Void)?
    public var messageSuccess:((message: MessageModelProtocol) -> Void)?
    
    
    public func sendMessages(messages: [MessageModelProtocol]) {
        messages.forEach(self.handleMessageStatus)
    }

    public func sendMessage(message: MessageModelProtocol) {
        message.status = .Sending
        let delaySeconds: Double = Double(arc4random_uniform(1200)) / 1000.0
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delaySeconds * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.updateMessage(message, status: .Success)
        }
    }

    private func handleMessageStatus(message: MessageModelProtocol) {
        switch message.status {
        case .Success:
            self.updateMessage(message, status: .Success)
        case .Failed:
            self.updateMessage(message, status: .Sending)
        case .Sending:
            break
        }
    }

    private func updateMessage(message: MessageModelProtocol, status: MessageStatus) {
        if message.status != status {
            message.status = status
            self.notifyMessageChanged(message)
        }
    }

    private func notifyMessageChanged(message: MessageModelProtocol) {
        self.onMessageChanged?(message: message)
        if message.status == .Success {
            self.messageSuccess?(message: message)
        }
    }
}
