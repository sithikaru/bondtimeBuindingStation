class FeedbackModel {
  final String feedbackText;
  final int rating;

  FeedbackModel({
    required this.feedbackText,
    required this.rating,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      feedbackText: json['feedbackText'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedbackText': feedbackText,
      'rating': rating,
    };
  }
}
