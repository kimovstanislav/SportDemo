//
//  AlertViewModel.swift
//  SportDemo
//
//  Created by Stanislav Kimov on 23.01.23.
//

import Foundation

class AlertViewModel: ObservableObject {
    @Published var showAlert = false
    var title: String = ""
    var message: String = ""

    func show(title: String, message: String) {
        self.showAlert = true
        self.title = title
        self.message = message
    }

    func hide() {
        self.showAlert = false
        self.title = ""
        self.message = ""
    }
}
