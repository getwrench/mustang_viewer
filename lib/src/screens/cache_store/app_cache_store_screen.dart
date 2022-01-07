import 'package:flutter/material.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:mustang_viewer/src/screens/cache_store/app_cache_store_service.dart';
import 'package:mustang_viewer/src/screens/shared_services/next_search_index_action.dart';
import 'package:mustang_viewer/src/screens/shared_services/previous_search_index_action.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_indicator.dart';
import 'package:mustang_viewer/src/shared_widgets/model_view.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';

import 'app_cache_store_state.state.dart';

class AppCacheStoreScreen extends StatefulWidget {
  const AppCacheStoreScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AppCacheStoreScreen> createState() => _AppCacheStoreScreenState();
}

class _AppCacheStoreScreenState extends State<AppCacheStoreScreen> {
  final ScrollController dataViewScrollController = ScrollController();
  final TextEditingController dataViewSearchTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StateProvider<AppCacheStoreState>(
      state: AppCacheStoreState(),
      child: Builder(
        builder: (BuildContext context) {
          AppCacheStoreState? state =
              StateConsumer<AppCacheStoreState>().of(context);

          if (state!.appCacheStore.busy) {
            const Scaffold(
              body: AppProgressIndicator(),
            );
          }

          if (state.appCacheStore.errorMsg.isNotEmpty) {
            Text(state.appCacheStore.errorMsg);
          }

          return _body(state, context);
        },
      ),
    );
  }

  Widget _body(AppCacheStoreState state, BuildContext context) {
    String storeData = state.appCacheStore.data;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (state.appCacheStore.data == '{}')
              showInputDialog(context, state),
            if (storeData != '{}')
              Expanded(
                child: ModelView(
                  storeData,
                  state.appCacheStore.modelDataSearchText,
                  AppCacheStoreService().onChangeModelViewSearch,
                  dataViewScrollController,
                  state.appCacheStore.modelDataSearchTextIndices.toList(),
                  state.appCacheStore.selectedModelDataSearchTextIndex,
                  AppCacheStoreService().onNavigateModelViewSearchMatches,
                  NextSearchIndexAction(
                      AppCacheStoreService().onNavigateModelViewSearchMatches),
                  PreviousSearchIndexAction(
                      AppCacheStoreService().onNavigateModelViewSearchMatches),
                  dataViewSearchTextController,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget showInputDialog(BuildContext context, AppCacheStoreState state) {
    if (state.appCacheStore.data == '{}') {
      return AlertDialog(
        content: Column(
          children: [
            TextFormField(
              onChanged: (String appPkgName) {
                AppCacheStoreService().updateAppPkgName(appPkgName);
              },
              decoration: const InputDecoration(
                hintText: AppConstants.pkgNameHintText,
              ),
            ),
            TextFormField(
              onChanged: (String storeName) {
                AppCacheStoreService().updateStoreName(storeName);
              },
              decoration: const InputDecoration(
                hintText: AppConstants.boxNameHintText,
              ),
            ),
            Row(
              children: [
                const Text(AppConstants.runningOnOS),
                DropdownButton<String>(
                  value: state.appCacheStore.osType,
                  items: AppConstants.osTypes.map(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (String? value) {
                    AppCacheStoreService().updateOSType(value!);
                  },
                ),
              ],
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
              AppCacheStoreService().fetchCacheData();
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
