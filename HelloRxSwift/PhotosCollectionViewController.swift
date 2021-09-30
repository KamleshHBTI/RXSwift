//
//  PhotosCollectionViewController.swift
//  PhotosCollectionViewController
//
//  Created by Kamlesh on 25/09/21.
//

import Foundation
import UIKit
import Photos
import RxSwift
class PhotosCollectionViewController:UICollectionViewController{
  
  @IBOutlet weak var photoCollectionView: UICollectionView!
  
  private var images = [PHAsset]()
  
  private let selectedPhotoSubject = PublishSubject<UIImage>()
  var selectedPhotos: Observable<UIImage>{
    return selectedPhotoSubject.asObservable()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    populatePhotos()
  }
  
  private func populatePhotos(){
    PHPhotoLibrary.requestAuthorization { [weak self] status in
      if status == .authorized{
        //access the photos from libraray
        let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        assets.enumerateObjects{ (object, count, stop) in
          self?.images.append(object)
        }
        self?.images.reverse()
        
        DispatchQueue.main.async {
          self?.photoCollectionView.reloadData()
        }
      }
    }
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photocell", for: indexPath) as? PhotoCell else {
      fatalError()
    }
    let assest = images[indexPath.row]
    let size = CGSize(width: 100, height: 100)
    if let image = getImageFromAssest(assest, size){
      cell.imageView.image = image
    }
    return cell
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedAssest = images[indexPath.row]
    let size = CGSize(width: 300, height: 300)

    if let image = getImageFromAssest(selectedAssest, size){
      selectedPhotoSubject.onNext(image)
      dismiss(animated: true, completion: nil)
    }
  }
  
  private func getImageFromAssest(_ assest: PHAsset, _ size: CGSize) -> UIImage?{
    let manager = PHImageManager.default()
    var photoImage:UIImage?
     manager.requestImage(for: assest, targetSize: size, contentMode: .aspectFill, options: nil) { image, info in
       guard let info = info else { return}
       let isDegratedImage = info["PHImageResultIsDegradedKey"] as! Bool
       if isDegratedImage{
         if let image = image {
           photoImage =  image
         }
       }
    }
    return photoImage
  }
}


