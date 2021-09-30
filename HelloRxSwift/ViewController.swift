//
//  ViewController.swift
//  HelloRxSwift
//
//  Created by Kamlesh on 11/01/21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  
  let disposeBag = DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()

  }

  
  @IBAction func applyFilter(){
    
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let photoVC = segue.destination as? PhotosCollectionViewController else {
     return
    }
    photoVC.selectedPhotos.subscribe(onNext:{[weak self] image in
      self?.imageView.image = image
    }).disposed(by: disposeBag)
  }
  
}

