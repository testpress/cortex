import 'package:core/data/data.dart';
import 'chapters_filter_tab_bar.dart';

/// A ruleset that dynamically controls which curriculum filters are visible
/// based on the tenant/client configuration.
class ChaptersFilterRules {
  /// Resolves the list of visible filters given the current client configuration.
  static List<CurriculumFilter> getVisibleFilters() {
    return CurriculumFilter.values.where((filter) {
      return isFilterVisible(filter);
    }).toList();
  }

  static bool isFilterVisible(CurriculumFilter filter) {
    // Hide extra filtering chips (Assessments and Tests) whenever the dedicated Exam tab is enabled.
    if (AppConfig.showExamTab) {
      if (filter == CurriculumFilter.assessment || filter == CurriculumFilter.test) {
        return false;
      }
    }
    return true;
  }
}
