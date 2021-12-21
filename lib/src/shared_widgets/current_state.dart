import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mustang_viewer/src/shared_widgets/event_text.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_date_time.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';
import 'package:mustang_viewer/src/utils/event_view.dart';

class CurrentState extends StatelessWidget {
  const CurrentState(
    this.data,
    this.onTap,
    this.scrollController,
    this.selectedModel,
    this.scroll, {
    Key? key,
  }) : super(key: key);

  final Map<String, String> data;
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
    List<String> items = data.keys.toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppStyles.padding8),
          child: Text(
            AppConstants.liveAppState,
            style: Theme.of(context).textTheme.subtitle2,
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
                EventView eventView =
                    EventView.fromJson(jsonDecode(data[modelName] ?? '{}'));
                return ListTile(
                  dense: true,
                  onTap: () => onTap(modelName),
                  title: EventText(
                    rowNum: index + 1,
                    ts: AppDateTime.timeForDateTime(
                      DateTime.fromMillisecondsSinceEpoch(eventView.timestamp),
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
