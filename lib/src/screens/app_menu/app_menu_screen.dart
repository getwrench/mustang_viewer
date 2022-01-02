import 'package:flutter/material.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_indicator.dart';
import 'package:mustang_viewer/src/shared_widgets/menu_item.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_routes.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';
import 'package:mustang_viewer/src/utils/dialog_util.dart';

import 'app_menu_service.dart';
import 'app_menu_state.state.dart';

class AppMenuScreen extends StatelessWidget {
  const AppMenuScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateProvider<AppMenuState>(
      state: AppMenuState(),
      child: Builder(
        builder: (BuildContext context) {
          AppMenuState? state = StateConsumer<AppMenuState>().of(context);

          if (state?.appMenu.busy ?? false) {
            return const AppProgressIndicator();
          }

          if (state?.appMenu.errorMsg.isNotEmpty ?? false) {
            Text(state?.appMenu.errorMsg ?? AppConstants.unknownError);
          }

          return _body(state, context);
        },
      ),
    );
  }

  Widget _body(AppMenuState? state, BuildContext context) {
    return Container(
      width: AppStyles.width50,
      decoration: const BoxDecoration(
        color: Colors.black12,
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                MenuItem(
                  tooltipMessage: AppConstants.home,
                  onPress: () {
                    AppMenuService().updateIndex(0);
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.memory,
                    );
                  },
                  active: state!.appMenu.activeIndex == 0,
                  buttonIcon: const Icon(Icons.home),
                ),
                MenuItem(
                  tooltipMessage: AppConstants.diff,
                  onPress: () {
                    AppMenuService().updateIndex(1);
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.diff,
                    );
                  },
                  active: state.appMenu.activeIndex == 1,
                  buttonIcon: const Icon(Icons.call_split),
                ),
              ],
            ),
          ),
          MenuItem(
            tooltipMessage: AppConstants.disconnect,
            onPress: () => _disconnect(context, state),
            buttonIcon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }

  Future<void> _disconnect(
    BuildContext context,
    AppMenuState state,
  ) async {
    DialogUtil.show(context);
    await AppMenuService().disconnect();
    Navigator.pop(context);
    if (state.appMenu.errorOnEvent.isNotEmpty) {
      DialogUtil.showMessage(context, state.appMenu.errorOnEvent);
    }
    AppMenuService().clearConnectScreen();
    Navigator.pushReplacementNamed(context, AppRoutes.connect);
  }
}
