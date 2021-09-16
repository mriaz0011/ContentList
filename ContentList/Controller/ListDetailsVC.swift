//
//  ListDetailsVC.swift
//  ContentList
//
//  Created by Muhammad Riaz on 15/09/2021.
//

import UIKit

class ListDetailsVC: UIViewController {
    
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleBody: UILabel!
    
    var mListId: Int?
    private var itemDetails: Item?
    private let contentManager = ContentManager()
    
    class var storyboardName: String {
        return "Main"
    }
    class var vcIdentifier: String {
        return "ListDetailsVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleTitle.showAnimatedGradientSkeleton()
        articleBody.showAnimatedGradientSkeleton()
        
        guard let id =  mListId else {
            return
        }
        contentManager.fetchDetails(byItem: id) { [weak self] (result) in
            guard let this = self else { return }
            this.handleResult(result)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func handleResult(_ result: Result<ContentDetailsData, Error>) {
        switch result {
        case .success(let data):
            updateView(with: data)
        case .failure(let error):
            handleError(error)
            print(error)
        }
    }
    
    private func updateView(with data: ContentDetailsData) {
        itemDetails = data.item
        guard let details = itemDetails else {
            return
        }
        let itemModel = ContentDetailsModel(item: details)
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.articleTitle.hideSkeleton()
            this.articleBody.hideSkeleton()
            this.articleTitle.text = itemModel.articleTitle
            this.articleBody.text = itemModel.articleBody
        }
    }
    
    private func handleError(_ error: Error) {
        
        print(error.localizedDescription)
    }
}
