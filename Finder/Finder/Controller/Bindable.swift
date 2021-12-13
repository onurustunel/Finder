//
//  Bindable.swift
//  Finder
//
//  Created by Onur Ustunel on 14.12.2021.
//

import Foundation
class Bindable<K> {
    var value: K? {
        didSet {
            observer?(value)
        }
    }
    var observer: ((K?) -> ())?
    func assignValue(observer: @escaping (K?) -> ()) {
        self.observer = observer
    }
}
