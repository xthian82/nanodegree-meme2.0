//
//  MemeCollectionViewController.swift
//  ImageMeme
//
//  Created by Cristhian Jesus Recalde Franco on 1/6/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
}
