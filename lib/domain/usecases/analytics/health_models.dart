/// Composite financial health assessment.
class FinancialHealthScore {
  final int overallScore;
  final List<HealthPillar> pillars;
  final PriorityLadderStep? currentStep;
  final List<PriorityLadderStep> allSteps;

  const FinancialHealthScore({
    required this.overallScore,
    required this.pillars,
    required this.currentStep,
    required this.allSteps,
  });
}

/// Individual health dimension with score and guidance.
class HealthPillar {
  final String name;
  final int score;
  final double weight;
  final String status;
  final String nextAction;
  final String? detail;

  const HealthPillar({
    required this.name,
    required this.score,
    required this.weight,
    required this.status,
    required this.nextAction,
    this.detail,
  });
}

/// A step in the financial priority ladder.
class PriorityLadderStep {
  final int order;
  final String title;
  final String description;
  final bool isComplete;
  final bool isCurrent;
  final double? progressPercent;

  const PriorityLadderStep({
    required this.order,
    required this.title,
    required this.description,
    required this.isComplete,
    required this.isCurrent,
    this.progressPercent,
  });
}
