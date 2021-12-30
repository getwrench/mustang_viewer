import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/difference.model.dart';

import 'difference_service.service.dart';
import 'difference_state.dart';

@ScreenService(screenState: $DifferenceState)
class DifferenceService {
  Future<void> memoizedGetData() {
    Difference difference = WrenchStore.get<Difference>() ?? Difference();
    if (difference.clearScreenCache) {
      clearMemoizedScreen(reload: false);
      difference = difference.rebuild(
        (b) => b..clearScreenCache = false,
      );
      updateState1(difference, reload: false);
    }
    return memoizeScreen(getData);
  }

  Future<void> getData({
    bool showBusy = true,
  }) async {
    Difference difference = WrenchStore.get<Difference>() ?? Difference();
    if (showBusy) {
      difference = difference.rebuild(
        (b) => b
          ..busy = true
          ..errorMsg = '',
      );
      updateState1(difference);
    }
    // Add API calls here, if any
    difference = difference.rebuild((b) => b..busy = false);
    updateState1(difference);
  }

  void clearCacheAndReload({bool reload = true}) {
    clearMemoizedScreen(reload: reload);
  }
}
