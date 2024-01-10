//
//  UIViewController+Preview.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

#if DEBUG
import SwiftUI

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}

extension UIView {
    private struct Preview: UIViewRepresentable {
        let view: UIView
        
        func makeUIView(context: Context) -> some UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {
            
        }
    }
    
    func toPreview() -> some View {
        Preview(view: self)
    }
}
#endif
