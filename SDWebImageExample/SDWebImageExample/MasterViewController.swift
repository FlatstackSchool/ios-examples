//
//  MasterViewController.swift
//  SDWebImageExample
//
//  Created by Vladimir Goncharov on 16.09.15.
//  Copyright © 2015 FlatStack. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    //MARK: - Struct
    
    struct SectionItem {
        var name: String
        var urls: [String]
        
        func convertUrlsToNSURL() -> [NSURL] {
            var result: [NSURL] = []
            for url in urls {
                if let urlAsNSURL = NSURL(string: url) {
                    result.append(urlAsNSURL)
                }
            }
            return result
        }
    }
    
    //MARK: - Enums
    internal enum CellIdentifier : String {
        case Cell = "Cell"
    }
    
    internal enum SegueIdentifier : String {
        case Detail = "detail"
    }
    
    //MARK: - variables
    private lazy var objects : [SectionItem] = {
        
        return [
            SectionItem(name: "Authenticated Image",
                urls: [
                "http://www.httpwatch.com/httpgallery/authentication/authenticatedimage/default.aspx?0.35786508303135633"
                ]
            ),
            SectionItem(name: "GIF",
                urls: [
                "http://assets.sbnation.com/assets/2512203/dogflops.gif",
                "http://www.wired.com/wp-content/uploads/images_blogs/design/2013/09/1_partyanimsm2.gif",
                "http://netdna.webdesignerdepot.com/uploads/2013/07/cars.gif",
                "http://netdna.webdesignerdepot.com/uploads/2013/07/dribble_gif.gif",
                "http://netdna.webdesignerdepot.com/uploads7/50-inspiring-animated-gifs/005.gif",
                "http://netdna.webdesignerdepot.com/uploads7/50-inspiring-animated-gifs/008.gif",
                "http://netdna.webdesignerdepot.com/uploads/2013/07/bike.gif",
                "http://netdna.webdesignerdepot.com/uploads/2013/07/molly_and_ray.gif",
                "http://netdna.webdesignerdepot.com/uploads7/50-inspiring-animated-gifs/003.gif"
                ]
            ),
            SectionItem(name: "WEBP",
                urls: [
                "http://www.gstatic.com/webp/gallery/1.webp",
                "http://www.gstatic.com/webp/gallery/2.webp",
                "http://www.gstatic.com/webp/gallery/3.webp",
                "http://www.gstatic.com/webp/gallery/4.webp",
                ]
            ),
            SectionItem(name: "PNG",
                urls: [
                "http://i42.tinypic.com/156cw7c.png",
                "http://imhotour.ru/wp-content/uploads/2015/08/apple_company_icon.png",
                "http://cs6.pikabu.ru/images/big_size_comm/2015-02_4/14242646004640.png",
                "http://logovo-sakh.biz/images/shop_cat/big/1354623541.0.179839001354623541.png"
                ]
            ),
            SectionItem(name: "JPG",
                urls: [
                "http://picsfab.com/download/image/171607/160x120_.jpg",
                "http://picsfab.com/download/image/171606/160x120_.jpg",
                "http://picsfab.com/download/image/171609/160x120_.jpg",
                "http://picsfab.com/download/image/171612/160x120_.jpg",
                "http://picsfab.com/download/image/171011/160x120_.jpg",
                "http://picsfab.com/download/image/112342/160x120_.jpg",
                "http://picsfab.com/download/image/171605/160x120_.jpg",
                "http://picsfab.com/download/image/111111/160x120_.jpg",
                "http://picsfab.com/download/image/174436/160x120_.jpg",
                "http://picsfab.com/download/image/134543/160x120_.jpg",
                "http://picsfab.com/download/image/152344/160x120_.jpg",
                "http://picsfab.com/download/image/111112/160x120_.jpg",
                "http://picsfab.com/download/image/111113/160x120_.jpg",
                "http://picsfab.com/download/image/171667/160x120_.jpg",
                "http://picsfab.com/download/image/111115/160x120_.jpg",
                "http://picsfab.com/download/image/171676/160x120_.jpg",
                "http://picsfab.com/download/image/111117/160x120_.jpg",
                "http://picsfab.com/download/image/176443/160x120_.jpg",
                "http://picsfab.com/download/image/176234/160x120_.jpg",
                "http://picsfab.com/download/image/111120/160x120_.jpg",
                "http://picsfab.com/download/image/177534/160x120_.jpg",
                "http://picsfab.com/download/image/111122/160x120_.jpg",
                "http://picsfab.com/download/image/111123/160x120_.jpg",
                "http://picsfab.com/download/image/151234/160x120_.jpg",
                "http://picsfab.com/download/image/171607/160x120_.jpg",
                "http://picsfab.com/download/image/171606/160x120_.jpg",
                "http://picsfab.com/download/image/111127/160x120_.jpg",
                "http://picsfab.com/download/image/111128/160x120_.jpg",
                "http://picsfab.com/download/image/174607/160x120_.jpg",
                "http://picsfab.com/download/image/111130/160x120_.jpg",
                "http://picsfab.com/download/image/171647/160x120_.jpg",
                "http://picsfab.com/download/image/111132/160x120_.jpg",
                ]
            )
        ]
        
    }()

    //MARK: - life cycle
    override func loadView() {
        super.loadView()
        
        self.title = "SDWebImage"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear Cache", style: UIBarButtonItemStyle.Plain, target: self, action: Selector.init(stringLiteral: "flushCache"))
        
        //immediately start downloading images in JPG
        if testCustomCache == false {
            SDWebImagePrefetcher.sharedImagePrefetcher().prefetchURLs(self.objects[4].convertUrlsToNSURL())
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case SegueIdentifier.Detail.rawValue :
                let destinationViewController = segue.destinationViewController as! DetailViewController
                
                let indexPath = self.tableView.indexPathForSelectedRow!
                let url = self.objects[indexPath.section].urls[indexPath.row].stringByReplacingOccurrencesOfString("160x120", withString: "1920x1280")
                destinationViewController.imageURL = NSURL.init(string: url)
                
            default:
                break
            }
        }
        super.prepareForSegue(segue, sender: sender)
    }
    
    //MARK: - Actions
    @IBAction internal func flushCache() {
        if testCustomCache {
            SDWebImageManager.sharedManager().imageCache.clearMemory()
            SDWebImageManager.sharedManager().imageCache.clearDisk()
        } else {
            FSWebImageManager.sharedManager().imageCache.clearMemory()
            FSWebImageManager.sharedManager().imageCache.clearDisk()
        }
        
        self.tableView.reloadData()
    }
}


//MARK: - UITableViewDataSource
extension MasterViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.objects.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects[section].urls.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.Cell.rawValue, forIndexPath: indexPath) as! TableViewCell
        
        cell.rightLabelView?.text = "Image \(indexPath.row + 1)"
        
        cell.indicatorView.startAnimating()
        
        if testCustomCache {
            
            let url = NSURL.init(string: self.objects[indexPath.section].urls[indexPath.row].stringByReplacingOccurrencesOfString("160x120", withString: "1920x1280"))
            
            cell.operation =
                FSWebImageManager.sharedManager().downloadImageWithURL(url!, types:[.Original, .Thumbnail, .Blur], options : indexPath.row == 0 ? SDWebImageOptions.RefreshCached : SDWebImageOptions.init(rawValue: 0), completed: { (images, error, cacheType, finished, imageURL) -> Void in
            
                print("downloaded \(images)")
                
                if let image = images[FSImageCacheType.Thumbnail] {
                    cell.leftImageView.image = image
                    cell.leftImageView.setNeedsDisplay()
                }
                
                cell.indicatorView.stopAnimating()
            })
        } else {
            let url = NSURL.init(string: self.objects[indexPath.section].urls[indexPath.row])
            
            cell.leftImageView.sd_setImageWithURL(url, placeholderImage: UIImage.init(named: "placeholder"), options: indexPath.row == 0 ? SDWebImageOptions.RefreshCached : SDWebImageOptions.init(rawValue: 0)) { (image, error, cacheType, imageURL) -> Void in
                
                debugPrint("----------------------------------------(\(indexPath.row))")
                debugPrint("By \(imageURL)")
                if let lImage = image {
                    debugPrint("Has been downloaded image \(lImage)")
                } else {
                    debugPrint("Failed download of the image with \(error)")
                }
                debugPrint("----------------------------------------(\(indexPath.row))")
                
                cell.indicatorView.stopAnimating()
            }
        }

        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.objects[section].name
    }
}


//MARK: - UITableViewDelegate
extension MasterViewController {
    
}



