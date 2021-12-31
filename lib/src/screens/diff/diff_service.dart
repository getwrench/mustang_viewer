import 'package:mustang_core/mustang_core.dart';
import 'package:mustang_viewer/src/models/diff.model.dart';

import 'diff_service.service.dart';
import 'diff_state.dart';

@ScreenService(screenState: $DiffState)
class DifferenceService {
  Future<void> memoizedGetData() {
    Diff diff = WrenchStore.get<Diff>() ?? Diff();
    if (diff.clearScreenCache) {
      clearMemoizedScreen(reload: false);
      diff = diff.rebuild(
        (b) => b..clearScreenCache = false,
      );
      updateState1(diff, reload: false);
    }
    return memoizeScreen(getData);
  }

  Future<void> getData({
    bool showBusy = true,
  }) async {
    Diff diff = WrenchStore.get<Diff>() ?? Diff();
    if (showBusy) {
      diff = diff.rebuild(
        (b) => b
          ..busy = true
          ..errorMsg = '',
      );
      updateState1(diff);
    }
    // Add API calls here, if any
    diff = diff.rebuild((b) => b..busy = false);
    updateState1(diff);
  }

  void clearCacheAndReload({bool reload = true}) {
    clearMemoizedScreen(reload: reload);
  }
}
