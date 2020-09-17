//
//  TimelineCellViewModel.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 9/17/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM
import RxCocoa
import RxSwift

class TimelineCellViewModel: BaseCellViewModel {
    
    override func react() {
        super.react()
        guard let model = self.model as? ActivityModel else { return }
        
    }
    
}
