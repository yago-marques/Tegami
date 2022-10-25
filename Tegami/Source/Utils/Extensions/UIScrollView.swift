//
//  UIScrollView.swift
//  GhibliAPP
//
//  Created by Yago Marques on 21/09/22.
//

import UIKit

extension UIScrollView {
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: true)
    }

    func moveToTop() {
        let bottomOffset = CGPoint(x: 0, y: 0)
        setContentOffset(bottomOffset, animated: true)
    }
}
