//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 07.08.2025.
//

final class CategoryViewModel {
    private let store: TrackerCategoryStore
    var onCategoriesChanged: (([TrackerCategory]) -> Void)?
    var onSelectionChanged: ((TrackerCategory?) -> Void)?

    private(set) var categories: [TrackerCategory] = []
    private(set) var selectedCategory: TrackerCategory?

    init(store: TrackerCategoryStore, selectedCategory: TrackerCategory? = nil) {
        self.store = store
        self.selectedCategory = selectedCategory
        store.delegate = self
        categories = store.categories
    }

    var numberOfCategories: Int {
        return categories.count
    }

    func categoryTitle(at index: Int) -> String {
        return categories[index].title
    }

    func selectCategory(at index: Int) {
        selectedCategory = categories[index]
        onSelectionChanged?(selectedCategory)
    }

    func addCategory(title: String) {
        try? store.addNewCategory(with: title)
    }
    
    func deleteCategory(at index: Int) {
        let category = categories[index]
        store.deleteCategory(with: category.title)
    }
    
    func updateCategoryTitle(at index: Int, newTitle: String) {
        let category = categories[index]
        store.updateCategoryTitle(oldTitle: category.title, newTitle: newTitle)
    }
}

extension CategoryViewModel: CategoryStoreDelegate {
    func storeDidUpdateCategories() {
        categories = store.categories
        onCategoriesChanged?(categories)
    }
}
