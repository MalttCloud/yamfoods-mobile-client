import 'package:flutter/material.dart';

enum FeedbackType {
  complaint,
  suggestion,
  compliment,
  bugReport,
  featureRequest,
  support,
  other,
}

extension FeedbackTypeExtension on FeedbackType {
  /// Value expected by the backend API.
  String get apiValue => switch (this) {
        FeedbackType.complaint => 'complaint',
        FeedbackType.suggestion => 'suggestion',
        FeedbackType.compliment => 'compliment',
        FeedbackType.bugReport => 'bug_report',
        FeedbackType.featureRequest => 'feature_request',
        FeedbackType.support => 'support',
        FeedbackType.other => 'other',
      };

  /// Human-friendly label.
  String get label => switch (this) {
        FeedbackType.complaint => 'Report a problem',
        FeedbackType.suggestion => 'Suggest improvement',
        FeedbackType.compliment => 'Positive feedback',
        FeedbackType.bugReport => 'Report a bug',
        FeedbackType.featureRequest => 'Request new feature',
        FeedbackType.support => 'Need help',
        FeedbackType.other => 'Other feedback',
      };

  /// Optional UI hint color.
  Color get color => switch (this) {
        FeedbackType.complaint => Colors.redAccent,
        FeedbackType.suggestion => Colors.blueAccent,
        FeedbackType.compliment => Colors.green,
        FeedbackType.bugReport => Colors.orange,
        FeedbackType.featureRequest => Colors.purple,
        FeedbackType.support => Colors.teal,
        FeedbackType.other => Colors.grey,
      };
}

extension FeedbackTypeStringExtension on String {
  FeedbackType toFeedbackType() {
    switch (toLowerCase()) {
      case 'complaint':
        return FeedbackType.complaint;
      case 'suggestion':
        return FeedbackType.suggestion;
      case 'compliment':
        return FeedbackType.compliment;
      case 'bug_report':
      case 'bugreport':
      case 'bug-report':
        return FeedbackType.bugReport;
      case 'feature_request':
      case 'featurerequest':
      case 'feature-request':
        return FeedbackType.featureRequest;
      case 'support':
        return FeedbackType.support;
      case 'other':
      default:
        return FeedbackType.other;
    }
  }
}

