//
//  Pet.swift
//  feifanliuLab2
//
//  Created by labuser on 9/23/18.
//  Copyright © 2018 MRounds. All rights reserved.
//

import Foundation

class pet{
    var happiness:Int
    var foodlevel:Int
    var pettype:type
    var timeplayed:Int
    var timefed:Int
    enum type{
        case dog
        case cat
        case bird
        case bunny
        case fish
    }
//feed pet
func feed(){
    if(foodlevel < 10){
        foodlevel += 1
        timefed += 1
    }
}
// play with pet
func play(){
    if(foodlevel > 0 && happiness < 10){
    happiness += 1
    foodlevel -= 1
    timeplayed += 1
    }
}
//init
init(type:type){
    self.pettype = type
    self.foodlevel = 0
    self.happiness = 0
    self.timeplayed = 0
    self.timefed = 0
    }
}
