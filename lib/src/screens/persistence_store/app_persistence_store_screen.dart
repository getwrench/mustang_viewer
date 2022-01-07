import 'package:flutter/material.dart';
import 'package:mustang_core/mustang_widgets.dart';
import 'package:mustang_viewer/src/screens/persistence_store/app_persistence_store_service.dart';
import 'package:mustang_viewer/src/screens/shared_services/previous_search_index_action.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_indicator.dart';
import 'package:mustang_viewer/src/shared_widgets/model_view.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';

import '../shared_services/next_search_index_action.dart';
import 'app_persistence_store_state.state.dart';

class AppPersistenceStoreScreen extends StatefulWidget {
  const AppPersistenceStoreScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AppPersistenceStoreScreen> createState() =>
      _AppPersistenceStoreScreenState();
}

class _AppPersistenceStoreScreenState extends State<AppPersistenceStoreScreen> {
  final ScrollController dataViewScrollController = ScrollController();
  final TextEditingController dataViewSearchTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StateProvider<AppPersistenceStoreState>(
      state: AppPersistenceStoreState(),
      child: Builder(
        builder: (BuildContext context) {
          AppPersistenceStoreState? state =
              StateConsumer<AppPersistenceStoreState>().of(context);

          if (state!.appPersistenceStore.busy) {
            const Scaffold(
              body: AppProgressIndicator(),
            );
          }

          if (state.appPersistenceStore.errorMsg.isNotEmpty) {
            Scaffold(
              body: Center(
                child: Text(state.appPersistenceStore.errorMsg),
              ),
            );
          }

          return _body(state, context);
        },
      ),
    );
  }

  Widget _body(AppPersistenceStoreState state, BuildContext context) {
    String storeData = state.appPersistenceStore.data;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          if (state.appPersistenceStore.data == '{}')
            showInputDialog(context, state),
          if (storeData != '{}')
            Expanded(
              child: ModelView(
                storeData,
                state.appPersistenceStore.modelDataSearchText,
                AppPersistenceStoreService().onChangeModelViewSearch,
                dataViewScrollController,
                state.appPersistenceStore.modelDataSearchTextIndices.toList(),
                state.appPersistenceStore.selectedModelDataSearchTextIndex,
                AppPersistenceStoreService().onNavigateModelViewSearchMatches,
                NextSearchIndexAction(AppPersistenceStoreService()
                    .onNavigateModelViewSearchMatches),
                PreviousSearchIndexAction(AppPersistenceStoreService()
                    .onNavigateModelViewSearchMatches),
                dataViewSearchTextController,
              ),
            ),
        ],
      ),
    );
  }

  Widget showInputDialog(BuildContext context, AppPersistenceStoreState state) {
    return AlertDialog(
      content: Column(
        children: [
          TextFormField(
            onChanged: (String appPkgName) {
              AppPersistenceStoreService().updateAppPkgName(appPkgName);
            },
            decoration: const InputDecoration(
              hintText: AppConstants.pkgNameHintText,
            ),
          ),
          TextFormField(
            onChanged: (String storeName) {
              AppPersistenceStoreService().updateStoreName(storeName);
            },
            decoration: const InputDecoration(
              hintText: AppConstants.boxNameHintText,
            ),
          ),
          Row(
            children: [
              const Text(AppConstants.runningOnOS),
              DropdownButton<String>(
                value: state.appPersistenceStore.osType,
                items: AppConstants.osTypes.map(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                onChanged: (String? value) {
                  AppPersistenceStoreService().updateOSType(value!);
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
            AppPersistenceStoreService().fetchStoreData();
          },
          child: const Text(AppConstants.fetch),
          hoverColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
