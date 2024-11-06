//
//  PageViewController.swift
//  HiSwift
//
//  Created by Bob on 2024/11/6.
//

import SwiftUI
import UIKit

struct PageViewController<Page: View>: UIViewControllerRepresentable{
 
    var pages: [Page]
    @Binding var currentPage: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        uiViewController.setViewControllers(
//            [UIHostingController(rootView: pages[0])], direction: .forward, animated: true
            [context.coordinator.controllers[currentPage]], direction: .forward, animated: true
        )
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else{
                return nil
            }
            
            if 0 == index {
                return controllers.last
            }
            
            return controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else{
                return nil
            }
            
            if index + 1 == controllers.count {
                return controllers.first
            }
            
            return controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
            if completed,
               let visible = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: visible){
                parent.currentPage = index
            }
        }
        
        var parent: PageViewController
        var controllers = [UIViewController]()
        init(parent: PageViewController) {
            self.parent = parent
            controllers = parent.pages.map{
                UIHostingController(rootView: $0)
            }
        }
        
        
    }
}
