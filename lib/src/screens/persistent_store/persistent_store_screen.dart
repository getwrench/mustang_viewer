import 'package:flutter/material.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:mustang_viewer/src/screens/persistent_store/persistent_store_service.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_indicator.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';

import 'persistent_store_state.state.dart';

class PersistentStoreScreen extends StatelessWidget {
  const PersistentStoreScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return StateProvider<PersistentStoreState>(
      state: PersistentStoreState(),
      child: Builder(
        builder: (BuildContext context) {
          PersistentStoreState? state =
              StateConsumer<PersistentStoreState>().of(context);

          if (state!.persistentStore.busy) {
            const Scaffold(
              body: AppProgressIndicator(),
            );
          }

          if (state.persistentStore.errorMsg.isNotEmpty) {
            Text(state.persistentStore.errorMsg);
          }

          return _body(state, context, controller);
        },
      ),
    );
  }

  Widget _body(
    PersistentStoreState state,
    BuildContext context,
    TextEditingController controller,
  ) {
    String storeData = state.persistentStore.persistentModelData;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            showInputDialog(context, state),
            if (storeData.isNotEmpty) Text(storeData)
          ],
        ),
      ),
    );
  }

  Widget showInputDialog(BuildContext context, PersistentStoreState state) {
    if (state.persistentStore.persistentModelData.length == 2) {
      return AlertDialog(
        content: Column(
          children: [
            TextFormField(
              onChanged: (String appPkgName) {
                PersistentStoreService().updateAppPkgName(appPkgName);
              },
              decoration: const InputDecoration(
                hintText: AppConstants.pkgNameHintText,
              ),
            ),
            TextFormField(
              onChanged: (String hiveBoxName) {
                PersistentStoreService().updateHiveBoxName(hiveBoxName);
              },
              decoration: const InputDecoration(
                hintText: AppConstants.boxNameHintText,
              ),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
            hoverColor: Theme.of(context).colorScheme.primary,
          ),
          MaterialButton(
            onPressed: () {
              PersistentStoreService().fetchStoreData();
            },
            child: const Text('Fetch'),
            hoverColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
