//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Dmitrii on 19.09.2023.
//

import ImageFeed
import Foundation


final class WebViewControllerSpy: WebViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}

