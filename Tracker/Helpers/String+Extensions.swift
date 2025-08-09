//
//  String+Extensions.swift
//  Tracker
//
//  Created by Amina Khusnutdinova on 27.05.2025.
//

extension String {
    enum Labels {
        static let onboardingButtonTitle = "Вот это технологии!"
        static let firstOnboardingTitle = "Отслеживайте только то, что хотите"
        static let secondOnboardingTitle = "Даже если это не литры воды и йога"

        static let trackersTitle = "Трекеры"
        static let statisticsTitle = "Статистика"
        static let createTrackerTitle = "Создание трекера"
        
        static let newHabitTitle = "Новая привычка"
        static let newEventTitle = "Новое нерегулярное событие"

        static let searchFieldPlaceholder = "Поиск"
        static let trackersScreenStubText = "Что будем отслеживать?"
        
        static let habitButtonTitle = "Привычка"
        static let eventButtonTitle = "Нерегулярное событие"
        
        static let trackerNamePlaceholder = "Введите название трекера"
        static let categoryButtonTitle = "Категория"
        static let scheduleButtonTitle = "Расписание"
        static let createButtonTitle = "Создать"
        static let cancelButtonTitle = "Отмена"
        
        static let scheduleTitle = "Расписание"
        static let doneButtonTitle = "Готово"
        
        static let categoryTitle = "Категория"
        static let addCategoryButtonTitle = "Добавить категорию"
        
        static let categoryScreenStubText = "Привычки и события можно\nобъединить по смыслу"
        
        static let newCategoryTitle = "Новая категория"
        static let categoryNamePlaceholder = "Введите название категории"
        
        static let editCategoryTitle = "Редактирование категории"
        static let editButtonTitle = "Редактировать"
        static let deleteButtonTitle = "Удалить"
        static let deleteCategoryAlertMessage = "Эта категория точно не нужна?"
    }
            
    enum TabBar {
        static let trackersTitle = String.Labels.trackersTitle
        static let trackersOnImage = "trackers_bar_on"
        static let trackersOffImage = "trackers_bar_off"
        
        static let statisticsTitle = String.Labels.statisticsTitle
        static let statisticsOnImage = "statistics_bar_on"
        static let statisticsOffImage = "statistics_bar_off"
    }
    
    enum Trackers {
        static let starStubImage = "star_stub"
    }
    
    enum AccessibilityIdentifiers {
        static let trackersTitleLabel = "TrackersTitleLabel"
        static let searchBar = "SearchBar"
        static let stubImage = "StarImage"
        static let stubLabel = "StubLabel"
    }
}


extension String {
    static func pluralizeDay(_ count: Int) -> String {
        switch count % 10 {
        case 1 where count % 100 != 11: return "день"
        case 2...4 where !(12...14).contains(count % 100): return "дня"
        default: return "дней"
        }
    }
}
