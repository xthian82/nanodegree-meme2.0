//
//  SendMemesTableController.swift
//  ImageMeme
//
//  Created by Cristhian Recalde on 1/11/20.
//  Copyright © 2020 Cristhian Recalde. All rights reserved.
//

import UIKit

class SendMemesTableController: UITableViewController {
    
    var memes: [Meme]! {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeDetailCell")!
        let memeDetail = self.memes[indexPath.row]
           
        // Set the name and image
    
        cell.textLabel?.text = "\(memeDetail.topText.prefix(25)) ... \(memeDetail.bottomText.prefix(25))"
        cell.imageView?.image = memeDetail.memedImage
           
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = ""
            //detailTextLabel.text = "\(memeDetail.topText.prefix(10)) ... \(memeDetail.bottomText.prefix(10))"
        }
           
        return cell
    }
      
    //TODO
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }*/
}
