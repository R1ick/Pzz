//
//  UIViewExt.swift
//  PzzApp
//
//  Created by Ярослав Антонович on 23.04.2022.
//

import UIKit

extension UIView {
   func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}
