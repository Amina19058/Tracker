// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Add category
  internal static let addCategoryButtonTitle = L10n.tr("Localizable", "add_category_button_title", fallback: "Add category")
  /// Cancel
  internal static let cancelButtonTitle = L10n.tr("Localizable", "cancel_button_title", fallback: "Cancel")
  /// Category
  internal static let categoryButtonTitle = L10n.tr("Localizable", "category_button_title", fallback: "Category")
  /// Enter category name
  internal static let categoryNamePlaceholder = L10n.tr("Localizable", "category_name_placeholder", fallback: "Enter category name")
  /// Habits and events can be
  /// combined by meaning
  internal static let categoryScreenStubText = L10n.tr("Localizable", "category_screen_stub_text", fallback: "Habits and events can be\ncombined by meaning")
  /// Category
  internal static let categoryTitle = L10n.tr("Localizable", "category_title", fallback: "Category")
  /// Color
  internal static let colorSectionTitle = L10n.tr("Localizable", "color_section_title", fallback: "Color")
  /// Create
  internal static let createButtonTitle = L10n.tr("Localizable", "create_button_title", fallback: "Create")
  /// Create tracker
  internal static let createTrackerTitle = L10n.tr("Localizable", "create_tracker_title", fallback: "Create tracker")
  /// Plural format key: "%#@days@"
  internal static func daysCountText(_ p1: Int) -> String {
    return L10n.tr("Localizable", "days_count_text", p1, fallback: "Plural format key: \"%#@days@\"")
  }
  /// Delete
  internal static let deleteButtonTitle = L10n.tr("Localizable", "delete_button_title", fallback: "Delete")
  /// Are you sure you don’t need this category?
  internal static let deleteCategoryAlertMessage = L10n.tr("Localizable", "delete_category_alert_message", fallback: "Are you sure you don’t need this category?")
  /// Are you sure you want to delete the tracker?
  internal static let deleteTrackerAlertMessage = L10n.tr("Localizable", "delete_tracker_alert_message", fallback: "Are you sure you want to delete the tracker?")
  /// Done
  internal static let doneButtonTitle = L10n.tr("Localizable", "done_button_title", fallback: "Done")
  /// Edit
  internal static let editButtonTitle = L10n.tr("Localizable", "edit_button_title", fallback: "Edit")
  /// Edit category
  internal static let editCategoryTitle = L10n.tr("Localizable", "edit_category_title", fallback: "Edit category")
  /// Tracker editing
  internal static let editTrackerTitle = L10n.tr("Localizable", "edit_tracker_title", fallback: "Tracker editing")
  /// Emoji
  internal static let emojiSectionTitle = L10n.tr("Localizable", "emoji_section_title", fallback: "Emoji")
  /// Irregular event
  internal static let eventButtonTitle = L10n.tr("Localizable", "event_button_title", fallback: "Irregular event")
  /// Every day
  internal static let everyDayScheduleValue = L10n.tr("Localizable", "every_day_schedule_value", fallback: "Every day")
  /// All trackers
  internal static let filterAll = L10n.tr("Localizable", "filter_all", fallback: "All trackers")
  /// Completed
  internal static let filterCompleted = L10n.tr("Localizable", "filter_completed", fallback: "Completed")
  /// Incomplete
  internal static let filterIncomplete = L10n.tr("Localizable", "filter_incomplete", fallback: "Incomplete")
  /// Trackers for today
  internal static let filterToday = L10n.tr("Localizable", "filter_today", fallback: "Trackers for today")
  /// Filters
  internal static let filtersButtonTitle = L10n.tr("Localizable", "filters_button_title", fallback: "Filters")
  /// Filters
  internal static let filtersTitle = L10n.tr("Localizable", "filters_title", fallback: "Filters")
  /// Track only what you want
  internal static let firstOnboardingTitle = L10n.tr("Localizable", "first_onboarding_title", fallback: "Track only what you want")
  /// Friday
  internal static let friday = L10n.tr("Localizable", "friday", fallback: "Friday")
  /// Fri
  internal static let fridayShort = L10n.tr("Localizable", "friday_short", fallback: "Fri")
  /// Habit
  internal static let habitButtonTitle = L10n.tr("Localizable", "habit_button_title", fallback: "Habit")
  /// Monday
  internal static let monday = L10n.tr("Localizable", "monday", fallback: "Monday")
  /// Mon
  internal static let mondayShort = L10n.tr("Localizable", "monday_short", fallback: "Mon")
  /// New category
  internal static let newCategoryTitle = L10n.tr("Localizable", "new_category_title", fallback: "New category")
  /// New irregular event
  internal static let newEventTitle = L10n.tr("Localizable", "new_event_title", fallback: "New irregular event")
  /// New habit
  internal static let newHabitTitle = L10n.tr("Localizable", "new_habit_title", fallback: "New habit")
  /// Nothing found
  internal static let nothingFound = L10n.tr("Localizable", "nothing_found", fallback: "Nothing found")
  /// Localizable.strings
  ///   Tracker
  /// 
  ///   Created by Amina Khusnutdinova on 09.08.2025.
  internal static let onboardingButtonTitle = L10n.tr("Localizable", "onboarding_button_title", fallback: "That's technology!")
  /// Saturday
  internal static let saturday = L10n.tr("Localizable", "saturday", fallback: "Saturday")
  /// Sat
  internal static let saturdayShort = L10n.tr("Localizable", "saturday_short", fallback: "Sat")
  /// Save
  internal static let saveButtonTitle = L10n.tr("Localizable", "save_button_title", fallback: "Save")
  /// Schedule
  internal static let scheduleButtonTitle = L10n.tr("Localizable", "schedule_button_title", fallback: "Schedule")
  /// Schedule
  internal static let scheduleTitle = L10n.tr("Localizable", "schedule_title", fallback: "Schedule")
  /// Search
  internal static let searchFieldPlaceholder = L10n.tr("Localizable", "search_field_placeholder", fallback: "Search")
  /// Even if it’s not liters of water and yoga
  internal static let secondOnboardingTitle = L10n.tr("Localizable", "second_onboarding_title", fallback: "Even if it’s not liters of water and yoga")
  /// Average value
  internal static let statisticsAverageAmount = L10n.tr("Localizable", "statistics_average_amount", fallback: "Average value")
  /// Best period
  internal static let statisticsBestPeriod = L10n.tr("Localizable", "statistics_best_period", fallback: "Best period")
  /// Trackers completed
  internal static let statisticsCompletedTrackers = L10n.tr("Localizable", "statistics_completed_trackers", fallback: "Trackers completed")
  /// Perfect days
  internal static let statisticsPerfectDays = L10n.tr("Localizable", "statistics_perfect_days", fallback: "Perfect days")
  /// There is nothing to analyze yet
  internal static let statisticsScreenStubText = L10n.tr("Localizable", "statistics_screen_stub_text", fallback: "There is nothing to analyze yet")
  /// Statistics
  internal static let statisticsTitle = L10n.tr("Localizable", "statistics_title", fallback: "Statistics")
  /// Sunday
  internal static let sunday = L10n.tr("Localizable", "sunday", fallback: "Sunday")
  /// Sun
  internal static let sundayShort = L10n.tr("Localizable", "sunday_short", fallback: "Sun")
  /// Thursday
  internal static let thursday = L10n.tr("Localizable", "thursday", fallback: "Thursday")
  /// Thu
  internal static let thursdayShort = L10n.tr("Localizable", "thursday_short", fallback: "Thu")
  /// Limit of 38 characters
  internal static let trackerNameLimitErrorMessage = L10n.tr("Localizable", "tracker_name_limit_error_message", fallback: "Limit of 38 characters")
  /// Enter tracker name
  internal static let trackerNamePlaceholder = L10n.tr("Localizable", "tracker_name_placeholder", fallback: "Enter tracker name")
  /// What will we track?
  internal static let trackersScreenStubText = L10n.tr("Localizable", "trackers_screen_stub_text", fallback: "What will we track?")
  /// Trackers
  internal static let trackersTitle = L10n.tr("Localizable", "trackers_title", fallback: "Trackers")
  /// Tuesday
  internal static let tuesday = L10n.tr("Localizable", "tuesday", fallback: "Tuesday")
  /// Tue
  internal static let tuesdayShort = L10n.tr("Localizable", "tuesday_short", fallback: "Tue")
  /// Wednesday
  internal static let wednesday = L10n.tr("Localizable", "wednesday", fallback: "Wednesday")
  /// Wed
  internal static let wednesdayShort = L10n.tr("Localizable", "wednesday_short", fallback: "Wed")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
