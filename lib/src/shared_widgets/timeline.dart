import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';
import 'package:mustang_viewer/src/utils/event_view.dart';

class Timeline extends StatelessWidget {
  const Timeline(
    this.data,
    this.onTap,
    this.scrollController,
    this.selectedEventIndex,
    this.scroll, {
    Key? key,
  }) : super(key: key);

  final List<String> data;
  final void Function(int eventIndex) onTap;
  final ScrollController scrollController;
  final int selectedEventIndex;
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppStyles.padding8),
          child: Text(
            AppConstants.timeline,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        Expanded(
          child: Scrollbar(
            isAlwaysShown: true,
            controller: scrollController,
            child: ListView.separated(
              controller: scrollController,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                EventView eventView =
                    EventView.fromJson(jsonDecode(data[index]));
                return ListTile(
                  dense: true,
                  selected: index == selectedEventIndex,
                  onTap: () => onTap(index),
                  title: Text(eventView.label),
                  subtitle: Text(
                    '${DateTime.fromMillisecondsSinceEpoch(eventView.timestamp)}',
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
