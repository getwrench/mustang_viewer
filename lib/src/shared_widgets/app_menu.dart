import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/shared_widgets/menu_button.dart';
import 'package:mustang_viewer/src/utils/app_routes.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';

class AppMenu extends StatelessWidget {
  const AppMenu({
    Key? key,
    required this.disconnect,
    required this.updateIndex,
    this.selectedIndex = 0,
  }) : super(key: key);

  final Future<void> Function() disconnect;

  final void Function(int index) updateIndex;

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
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
                  tooltipMessage: 'Home',
                  onPress: () {
                    updateIndex(0);
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.memory,
                    );
                  },
                  selected: selectedIndex == 0,
                  buttonIcon: const Icon(Icons.home),
                ),
                MenuButton(
                  tooltipMessage: 'Difference',
                  onPress: () {
                    updateIndex(1);
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.difference,
                    );
                  },
                  selected: selectedIndex == 1,
                  buttonIcon: const Icon(Icons.call_split),
                ),
              ],
            ),
          ),
          MenuButton(
            tooltipMessage: 'Logout',
            onPress: () => disconnect(),
            buttonIcon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
