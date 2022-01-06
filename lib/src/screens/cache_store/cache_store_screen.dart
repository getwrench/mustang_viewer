import 'package:flutter/material.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:mustang_viewer/src/screens/cache_store/cache_store_service.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_indicator.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';

import 'cache_store_state.state.dart';

class CacheStoreScreen extends StatelessWidget {
  const CacheStoreScreen({
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
    if (state.cacheStore.cacheModelData == '{}') {
      return AlertDialog(
        content: Column(
          children: [
            TextFormField(
              onChanged: (String appPkgName) {
                CacheStoreService().updateAppPkgName(appPkgName);
              },
              decoration: const InputDecoration(
                hintText: AppConstants.pkgNameHintText,
              ),
            ),
            TextFormField(
              onChanged: (String hiveBoxName) {
                CacheStoreService().updateHiveBoxName(hiveBoxName);
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
            child: const Text(AppConstants.close),
            hoverColor: Theme.of(context).colorScheme.primary,
          ),
          MaterialButton(
            onPressed: () {
              CacheStoreService().fetchStoreData();
            },
            child: const Text(AppConstants.fetch),
            hoverColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
