import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mustang_viewer/src/models/app_event.model.dart';
import 'package:mustang_viewer/src/shared_widgets/event_text.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_date_time.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';

class AppState extends StatelessWidget {
  const AppState(
    this.stateMap,
    this.onTap,
    this.scrollController,
    this.selectedModel,
    this.scroll, {
    Key? key,
  }) : super(key: key);

  final Map<String, AppEvent> stateMap;
  final void Function(String modelName) onTap;
  final ScrollController scrollController;
  final String selectedModel;
  final bool scroll;

  @override
  Widget build(BuildContext context) {
    if (scroll) {
      SchedulerBinding.instance?.addPostFrameCallback(
        (_) => scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: AppStyles.duration500ms),
          curve: Curves.easeIn,
        ),
      );
    }
    List<String> items = stateMap.keys.toList();
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(AppStyles.padding8),
          child: Text(
            AppConstants.liveAppState,
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Scrollbar(
            isAlwaysShown: true,
            controller: scrollController,
            child: ListView.separated(
              controller: scrollController,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final String modelName = items[index];
                AppEvent appEvent = stateMap[modelName]!;
                return ListTile(
                  dense: true,
                  onTap: () => onTap(modelName),
                  title: EventText(
                    rowNum: index + 1,
                    ts: AppDateTime.timeForDateTime(
                      DateTime.fromMillisecondsSinceEpoch(appEvent.timestamp),
                    ),
                    modelName: modelName,
                    selected: modelName == selectedModel,
                  ),
                );
              },
              separatorBuilder: (_, __) => const Divider(),
            ),
          ),
        ),
      ],
    );
  }
}
