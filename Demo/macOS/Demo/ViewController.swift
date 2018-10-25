//
//  ViewController.swift
//  Demo
//
//  Created by Yuto Mizutani on 2018/09/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Cocoa
import JSONtoCodable

class ViewController: NSViewController {
    @IBOutlet weak var textView: NSTextView!
    @IBOutlet weak var generateButton: NSButton!

    var codable: JSONtoCodable = JSONtoCodable()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureSetting()
        self.configureView()
        self.configureAction()
    }
}

// MARK: - configure view

private extension ViewController {
    private func configureSetting() {
        self.codable.config.accessModifier = .public
    }

    private func configureView() {
        self.textView.string = """
        {
            "user": {
                "Name": "Yuto Mizutani"
            },
            "lib": {
                "lib-name": "JSONtoCodable",
                "year": 2018,
                "version": "2.1.1",
                "released": "2018-09-22"
            },
            "text": "Hello, world!!"
        }
        """
    }

    private func configureAction() {
        self.generateButton.action = #selector(self.generate)
    }
}

// MARK: - actions

private extension ViewController {
    @objc private func generate() {
        print(self.textView.string)
        guard let text = try? self.codable.generate(self.textView.string) else { return }
        self.textView.string = text
    }
}

