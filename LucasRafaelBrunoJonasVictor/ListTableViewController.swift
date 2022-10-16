//
//  TableViewController.swift
//  ToyList
//
//  Created by Jonas Rodrigues de Oliveira on 15/10/22.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit
import Firebase

final class ListTableViewController: UITableViewController {

	// MARK: - Properties
	private let collection = "toyList"
	private var toyList: [ToyItem] = []
	private lazy var firestore: Firestore = {
		let settings = FirestoreSettings()
		settings.isPersistenceEnabled = true
		
		let firestore = Firestore.firestore()
		firestore.settings = settings
		return firestore
	}()
	var firestoreListener: ListenerRegistration!
	
	
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sair",
														   style: .plain,
														   target: self,
														   action: #selector(logout))
		
		loadToyList()
    }
	
	// MARK: - Methods
	@objc private func logout() {
		do {
			guard let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
				return
			}
			navigationController?.viewControllers = [loginViewController]
		}
	}
	
	private func loadToyList() {
		firestoreListener = firestore
							.collection(collection)
							.order(by: "name", descending: false)
							.addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, error in
								if let error = error {
									print(error)
								} else {
									guard let snapshot = snapshot else { return }
									print("Total de brinquedos atualizados:", snapshot.documentChanges.count)
									if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
										self.showItemsFrom(snapshot: snapshot)
									}
								}
							})
	}
	
	private func showItemsFrom(snapshot: QuerySnapshot) {
		toyList.removeAll()
		for document in snapshot.documents {
			let id = document.documentID
			let data = document.data()
			let name = data["name"] as? String ?? "---"
			let phone = data["phone"] as? String ?? "---"
			let toyItem = ToyItem(id: id, name: name, phone: phone)
			toyList.append(toyItem)
		}
		tableView.reloadData()
	}
	
	private func showAlertForItem(_ item: ToyItem?) {
		let alert = UIAlertController(title: "Qual Brinquedo gostaria de doar?", message: "Informe o nome do brinquedo e seu telefone de contato", preferredStyle: .alert)
		
		alert.addTextField { textField in
			textField.placeholder = "Nome do brinquedo"
			textField.text = item?.name
		}
		alert.addTextField { textField in
			textField.placeholder = "Telefone do doador"
			textField.keyboardType = .numberPad
			textField.text = item?.phone.description
		}
		
		let okAction = UIAlertAction(title: "OK", style: .default) { _ in
			guard let name = alert.textFields?.first?.text,
                  let phone = alert.textFields?.last?.text else {return}
			
			let data: [String: Any] = [
				"name": name,
				"phone": phone
			]
			
			if let item = item {
				//Edição
				self.firestore.collection(self.collection).document(item.id).updateData(data)
			} else {
				//Criação
				self.firestore.collection(self.collection).addDocument(data: data)
			}
		}
		
		let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
		
		alert.addAction(okAction)
		alert.addAction(cancelAction)
		
		present(alert, animated: true, completion: nil)
	}

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return toyList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let toyItem = toyList[indexPath.row]
		cell.textLabel?.text = toyItem.name
		cell.detailTextLabel?.text = "\(toyItem.phone)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let toyItem = toyList[indexPath.row]
		showAlertForItem(toyItem)
    }
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let toyItem = toyList[indexPath.row]
			firestore.collection(collection).document(toyItem.id).delete()
		}
	}
    
    // MARK: - IBActions
    @IBAction func addItem(_ sender: Any) {
		showAlertForItem(nil)
    }
}


