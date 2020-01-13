//
//  SendMemeCollectionController.swift
//  ImageMeme
//
//  Created by Cristhian Recalde on 1/11/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class SendMemeCollectionController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let width = SendMemeCollectionController.getCoordSize(frameSize: view.frame.size.width)
        
        flowLayout.itemSize = CGSize(width: width, height: 150)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let memeDetail = self.memes[indexPath.row]
        cell.imageViewDetail.image = memeDetail.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    private static func getCoordSize(frameSize: CGFloat) -> CGFloat {
        let minItemSize: CGFloat = 150
        let numberOfCell = frameSize / minItemSize
        return floor((numberOfCell / floor(numberOfCell)) * minItemSize)
    }
}
