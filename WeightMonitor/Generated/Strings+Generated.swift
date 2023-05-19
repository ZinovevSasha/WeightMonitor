// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Strings {
  public enum Creation {
    /// Add
    public static let add = Strings.tr("Localizable", "creation.add", fallback: "Add")
    /// Add weight
    public static let addWeigtTitle = Strings.tr("Localizable", "creation.addWeigtTitle", fallback: "Add weight")
    /// Date
    public static let date = Strings.tr("Localizable", "creation.date", fallback: "Date")
    /// Enter weight
    public static let enterWeight = Strings.tr("Localizable", "creation.enterWeight", fallback: "Enter weight")
    /// Today
    public static let today = Strings.tr("Localizable", "creation.today", fallback: "Today")
  }
  public enum WeightHistory {
    /// Changes
    public static let change = Strings.tr("Localizable", "weightHistory.change", fallback: "Changes")
    /// Current weight
    public static let currentWeight = Strings.tr("Localizable", "weightHistory.currentWeight", fallback: "Current weight")
    /// Date
    public static let date = Strings.tr("Localizable", "weightHistory.date", fallback: "Date")
    /// History
    public static let history = Strings.tr("Localizable", "weightHistory.history", fallback: "History")
    /// Localizable.strings
    ///   WeightMonitor
    /// 
    ///   Created by Александр Зиновьев on 15.05.2023.
    public static let newWeightRecord = Strings.tr("Localizable", "weightHistory.newWeightRecord", fallback: "Added a new dimension")
    /// Weight Monitor
    public static let title = Strings.tr("Localizable", "weightHistory.title", fallback: "Weight Monitor")
    /// Weight
    public static let weigth = Strings.tr("Localizable", "weightHistory.weigth", fallback: "Weight")
    public enum UnitSystem {
      /// English system of measures
      public static let imperial = Strings.tr("Localizable", "weightHistory.unitSystem.imperial", fallback: "English system of measures")
      /// Metric system
      public static let metric = Strings.tr("Localizable", "weightHistory.unitSystem.metric", fallback: "Metric system")
      /// Unknown unit system
      public static let unknown = Strings.tr("Localizable", "weightHistory.unitSystem.unknown", fallback: "Unknown unit system")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
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
