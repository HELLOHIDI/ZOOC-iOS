//
//  ZoocWebViewController.swift
//  ZOOC
//
//  Created by 장석우 on 2023/10/06.
//

import UIKit
import WebKit

import SnapKit

final class ZoocWebViewController: UIViewController {

    // MARK: - Properties
    
    private let url: String
    private let callBackHandlerName: String
    
    //MARK: - UI Components
    
    private var webView: WKWebView?
    private let indicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Lifecycle
    
    //TODO: 접속할 URL과 콜백핸들러 변수명을 생성시에 주입 시켜줘야해.
    init(url: String, callBackHandlerName: String) {
        self.url = url
        self.callBackHandlerName = callBackHandlerName
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        view.backgroundColor = .white
        setAttributes()
        setContraints()
    }

    private func setAttributes() {
        let contentController = WKUserContentController()
        
        //TODO: 우리가 정할 콜백 핸들러 함수명 적는 곳. JS에서 작성한 함수와 아래 name의 문자열 값이 똑같아야 userContentController 함수가 실행됨.
        contentController.add(self, name: callBackHandlerName)

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView?.navigationDelegate = self

        //TODO: 해당 코드에 URL 작성해야함.
        guard let url = URL(string: url),
            let webView = webView else { return }
        
        
        let request = URLRequest(url: url)
        webView.load(request)
        indicator.startAnimating()
    }

    private func setContraints() {
        guard let webView = webView else { return }
        view.addSubview(webView)

        webView.addSubview(indicator)

        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension ZoocWebViewController: WKScriptMessageHandler {
    
    //TODO: 콜백핸들러함수명에 해당하는 함수가 JSd에서 실행되었을 때 아래 함수가 발동돼.
    //TODO: 만약 너가 콜백핸들러에 데이터를 전달했다면 meesage.body에 값이 실려 올거야. 형태는 JSON으로 주고받을거야.
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: Any] {
            let data1 = data["우리가 정할"] as? String ?? ""
            let data2 = data["키값들"] as? String ?? ""
        }
        
        //TODO: 일단 callBackHandler가 실행됐을 때 body값에 상관 없이 뒤로가기(popViewController)를 실행하는 걸로 했어.
        self.navigationController?.popViewController(animated: true)
    }
}

extension ZoocWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}

