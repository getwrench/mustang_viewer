import 'package:flutter/material.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:mustang_viewer/src/screens/persistent_store/persistent_store_service.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_indicator.dart';

import 'cache_store_state.state.dart';

class PersistentStoreScreen extends StatelessWidget {
  const PersistentStoreScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return StateProvider<CacheStoreState>(
      state: CacheStoreState(),
      child: Builder(
        builder: (BuildContext context) {
          CacheStoreState? state = StateConsumer<CacheStoreState>().of(context);

          if (state!.cacheStore.busy) {
            const Scaffold(
              body: AppProgressIndicator(),
            );
          }

          if (state.cacheStore.errorMsg.isNotEmpty) {
            Text(state.cacheStore.errorMsg);
          }

          return _body(state, context, controller);
        },
      ),
    );
  }

  Widget _body(
    CacheStoreState state,
    BuildContext context,
    TextEditingController controller,
  ) {
    String storeData = state.cacheStore.cacheModelData;
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

  Widget showInputDialog(BuildContext context, CacheStoreState state) {
    print('---${state.cacheStore.cacheModelData}');
    if (state.cacheStore.cacheModelData.length == 2) {
      return AlertDialog(
        content: TextFormField(
          onChanged: (String hiveBoxName) {
            PersistentStoreService().updateHiveBoxName(hiveBoxName);
          },
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
