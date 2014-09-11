//
//  ColorViewController.swift
//  ElevenChat
//
//  Created by Cameron Dershem on 9/10/14.
//  Copyright (c) 2014 Cameron Dershem. All rights reserved.
//

import UIKit

class ColorViewController : UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println(self.title)
    }
}

class PinkViewController : ColorViewController {
    
}
class BlueViewController : ColorViewController {
    
}

class GreenViewController : ColorViewController {
    
}