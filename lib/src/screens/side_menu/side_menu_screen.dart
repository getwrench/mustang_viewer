import 'package:flutter/material.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:mustang_viewer/src/shared_widgets/menu_button.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_routes.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';
import 'package:mustang_viewer/src/utils/dialog_util.dart';

import 'side_menu_state.state.dart';
import 'side_menu_service.dart';

class SideMenuScreen extends StatelessWidget {
  const SideMenuScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateProvider<SideMenuState>(
      state: SideMenuState(),
      child: Builder(
        builder: (BuildContext context) {
          SideMenuState? state = StateConsumer<SideMenuState>().of(context);

          if (state?.sideMenu.busy ?? false) {
            return const CircularProgressIndicator();
          }

          if (state?.sideMenu.errorMsg.isNotEmpty ?? false) {
            Text(state?.sideMenu.errorMsg ?? 'Unknown error');
          }

          return _body(state, context);
        },
      ),
    );
  }

  Widget _body(SideMenuState? state, BuildContext context) {
    return Container(
      width: AppStyles.width50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                MenuButton(
                  tooltipMessage: AppConstants.home,
                  onPress: () {
                    SideMenuService().updateIndex(0);
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.memory,
                    );
                  },
                  selected: state!.sideMenu.activeIndex == 0,
                  buttonIcon: const Icon(Icons.home),
                ),
                MenuButton(
                  tooltipMessage: AppConstants.difference,
                  onPress: () {
                    SideMenuService().updateIndex(1);
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.difference,
                    );
                  },
                  selected: state.sideMenu.activeIndex == 1,
                  buttonIcon: const Icon(Icons.call_split),
                ),
              ],
            ),
          ),
          MenuButton(
            tooltipMessage: AppConstants.logout,
            onPress: () => _disconnect(context, state),
            buttonIcon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }

  Future<void> _disconnect(
    BuildContext context,
    SideMenuState state,
  ) async {
    DialogUtil.show(context);
    await SideMenuService().disconnect();
    Navigator.pop(context);
    if (state.sideMenu.errorOnEvent.isNotEmpty) {
      DialogUtil.showMessage(context, state.sideMenu.errorOnEvent);
    }
    SideMenuService().clearConnectScreen();
    Navigator.pushReplacementNamed(context, AppRoutes.connect);
  }
}
