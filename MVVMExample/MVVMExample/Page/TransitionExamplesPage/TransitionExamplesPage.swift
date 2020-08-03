//
//  TransitionExamplesPage.swift
//  MVVMExample
//
//  Created by pham.minh.tien on 5/14/20.
//  Copyright © 2020 Sun*. All rights reserved.
//

import UIKit
import MVVM

class TransitionExamplesPage: BasePage {

    @IBOutlet private weak var flipBtn: UIButton!
    @IBOutlet private weak var zoomBtn: UIButton!
    @IBOutlet private weak var clockBtn: UIButton!
    @IBOutlet private weak var circleBtn: UIButton!
    @IBOutlet private weak var crossFadeBtn: UIButton!
    @IBOutlet private weak var rectangleBtn: UIButton!
    @IBOutlet private weak var multiCirleBtn: UIButton!
    @IBOutlet private weak var tiledFlipBtn: UIButton!
    @IBOutlet private weak var imageRepeatingBtn: UIButton!
    @IBOutlet private weak var multiFlipBtn: UIButton!
    @IBOutlet private weak var angleLineBtn: UIButton!
    @IBOutlet private weak var straightLineBtn: UIButton!
    
    @IBOutlet private weak var collidingDiamondsBtn: UIButton!
    @IBOutlet private weak var shrinkingGrowingBtn: UIButton!
    @IBOutlet private weak var splitFromCenterBtn: UIButton!
    @IBOutlet private weak var swingInRetroBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        guard let viewModel = viewModel as? TransitionExamplesPageViewModel else {
            return
        }
        
        viewModel.rxPageTitle ~> self.rx.title => disposeBag
        flipBtn.rx.bind(to: viewModel.flipAction, input: ())
        zoomBtn.rx.bind(to: viewModel.zoomAction, input: ())
        clockBtn.rx.bind(to: viewModel.clockAction, input: ())
        circleBtn.rx.bind(to: viewModel.circleAction, input: ())
        crossFadeBtn.rx.bind(to: viewModel.crossAndFadeAction, input: ())
        rectangleBtn.rx.bind(to: viewModel.rectangularAction, input: ())
        multiCirleBtn.rx.bind(to: viewModel.multiCircleAction, input: ())
        tiledFlipBtn.rx.bind(to: viewModel.tiledFlipAction, input: ())
        imageRepeatingBtn.rx.bind(to: viewModel.imageRepeatingAction, input: ())
        multiFlipBtn.rx.bind(to: viewModel.multiFlipAction, input: ())
        angleLineBtn.rx.bind(to: viewModel.angleLineAction, input: ())
        straightLineBtn.rx.bind(to: viewModel.straightLineAction, input: ())
        collidingDiamondsBtn.rx.bind(to: viewModel.collidingDiamondsAction, input: ())
        shrinkingGrowingBtn.rx.bind(to: viewModel.shrinkingGrowingAction, input: ())
        splitFromCenterBtn.rx.bind(to: viewModel.splitFromCenterAction, input: ())
        swingInRetroBtn.rx.bind(to: viewModel.swingInAction, input: ())
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
