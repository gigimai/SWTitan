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

import UIKit

public class ExpandableTextView: UITextView {

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    override public var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.layoutIfNeeded() // needed?
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.removeObserver(self, forKeyPath: "contentSize")
    }

    private func commonInit() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textDidChange", name: UITextViewTextDidChangeNotification, object: self)
        self.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let textView = object as? UITextView where keyPath == "contentSize" else {
            return
        }
        
        let deadSpace = textView.bounds.size.height - textView.contentSize.height
        let inset = max(0, deadSpace/2.0)
        textView.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: 0, right: 0)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
    }

    override public func intrinsicContentSize() -> CGSize {
        return self.contentSize
    }

    override public var text: String! {
        didSet {
            self.textDidChange()
        }
    }

    func textDidChange() {
        self.scrollToCaret()
    }

    private func scrollToCaret() {
        if selectedTextRange != nil {
            var rect = caretRectForPosition(self.selectedTextRange!.end)
            rect = CGRect(origin: rect.origin, size: CGSize(width: rect.width, height: rect.height + textContainerInset.bottom))

            self.scrollRectToVisible(rect, animated: false)
        }
    }

}
