//
//  SendMemesTableController.swift
//  ImageMeme
//
//  Created by Cristhian Recalde on 1/11/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class SendMemesTableController: UITableViewController {
    
    //MARK: Properties
    let prefixSize = 25
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    //MARK: View functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView!.reloadData()
        
        let size = self.memes?.count ?? 0
        if size == 0 {
            tableView.separatorStyle = .none;
        } else {
            tableView.separatorStyle = .singleLine
        }
    }
    
    //MARK: Table functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.MemeDetailTableId.rawValue) as! MemeTableViewCell
        let memeDetail = self.memes[indexPath.row]
           
        // Set the name and image
        cell.descriptionLabel!.text = "\(memeDetail.topText.prefix(prefixSize)) ... \(memeDetail.bottomText.prefix(prefixSize))"
        cell.memedImageView!.image = memeDetail.memedImage
           
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: Constants.MemeDetailViewId.rawValue) as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
