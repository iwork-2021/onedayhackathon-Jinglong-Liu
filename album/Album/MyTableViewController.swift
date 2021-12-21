//
//  MyTableViewController.swift
//  Album
//
//  Created by mac on 2021/12/22.
//

import UIKit
import CoreMedia
import CoreML
import Vision

class MyTableViewController: UITableViewController {
    
    @IBOutlet weak var result: UILabel!
    let classLabels = [
        "apple","banana","cake","candy","carrot",
        "cookie","doughnut","grape","hot dog","ice cream",
        "juice","muffin","orange","pineapple","popcorn",
        "pretzel","salad","strawberry","waffle","watermelon"
        
    ]
    
    var imageMap = [String:[UIImage]]()
    
    var imagePicked = UIImage()
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do{
            let classifier = try snacks(configuration: MLModelConfiguration())
            
            let model = try VNCoreMLModel(for: classifier.model)
            let request = VNCoreMLRequest(model: model, completionHandler: {
                [weak self] request,error in
                self?.processObservations(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
            
            
        } catch {
            fatalError("Failed to create request")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for label in classLabels{
            imageMap.updateValue([UIImage](), forKey: label)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return classLabels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MyTableViewCell
        let label = classLabels[indexPath.row]
        cell.label.text! = label
        cell.classLabel = label
        //cell.number.text! = String(imageMap[label]?.count ?? 0)
        //print(imageMap[label]?.count)
        return cell
    }
    
    
    @IBAction func pictureFromCamera(_ sender: Any) {
        presentPhotoPicker(sourceType: .camera)
    }
    
    
    @IBAction func pictureFromPhotos() {
        presentPhotoPicker(sourceType: .photoLibrary)
    }
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
          let picker = UIImagePickerController()
          picker.delegate = self
          picker.sourceType = sourceType
          present(picker, animated: true)
    }
    
    func classify(image:UIImage){
        DispatchQueue.global(qos: .userInitiated).async {
        //DispatchQueue.main.async {
            let handler = VNImageRequestHandler(cgImage: image.cgImage!)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification: \(error)")
            }
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTableView"{
            let controller = segue.destination as! PicTableViewController
            let cell = sender as! MyTableViewCell
            controller.pictures = imageMap[cell.classLabel]!
            controller.tableView.reloadData()
        }else if segue.identifier == "toCollectionView"{
            let controller = segue.destination as! MyCollectionViewController
            let cell = sender as! MyTableViewCell
            controller.pictures = imageMap[cell.classLabel]!
            controller.collectionView.reloadData()
        }
        
        //controller.reloadData()
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

extension MyTableViewController {
    func processObservations(for request: VNRequest, error: Error?) {
        if let results = request.results as? [VNClassificationObservation] {
            if results.isEmpty {
                //ignore
            } else {
                let result = results[0].identifier
                let confidence = results[0].confidence
                self.imageMap[result]?.append(self.imagePicked)
                print(result + String(format: "  %.2f%%", confidence * 100))
                DispatchQueue.main.sync{
                    self.result.text = result +  String(format: "  %.2f%%", confidence * 100)
                    print(123)
                }
                
            }
        } else if let error = error {
            print("Error: \(error.localizedDescription)")
        } else {
            print("Unknown ERROR")
        }
    }
}

extension MyTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      picker.dismiss(animated: true)

      let image = info[.originalImage] as! UIImage
      self.imagePicked = image
      classify(image: image)
  }
}
