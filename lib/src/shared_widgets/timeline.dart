import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mustang_viewer/src/shared_widgets/event_text.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_date_time.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';
import 'package:mustang_viewer/src/utils/event_view.dart';

class Timeline extends StatelessWidget {
  const Timeline(
    this.data,
    this.onTap,
    this.scrollController,
    this.selectedEventIndex,
    this.scroll,
    this.onDropdownChange,
    this.selectedModelName, {
    Key? key,
  }) : super(key: key);

  final List<String> data;
  final void Function(int eventIndex) onTap;
  final ScrollController scrollController;
  final int selectedEventIndex;
  final bool scroll;
  final void Function(String?) onDropdownChange;
  final String selectedModelName;

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
    List<String> dropdownItems = [
      'All',
    ];

    for (String entry in data) {
      EventView eventView = EventView.fromJson(jsonDecode(entry));
      if (!dropdownItems.contains(eventView.label)) {
        dropdownItems.add(eventView.label);
      }
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(AppStyles.padding8),
          child: Text(
            AppConstants.timeline,
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppStyles.padding8,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DropdownButtonFormField<String>(
              items: dropdownItems
                  .map(
                    (e) => DropdownMenuItem<String>(
                      child: Text(e),
                      value: e,
                    ),
                  )
                  .toList(),
              value: selectedModelName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: onDropdownChange,
            ),
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
                if (selectedModelName == eventView.label) {
                  return ListTile(
                    dense: true,
                    onTap: () => onTap(index),
                    title: EventText(
                      rowNum: index + 1,
                      ts: AppDateTime.timeForDateTime(
                        DateTime.fromMillisecondsSinceEpoch(
                            eventView.timestamp),
                      ),
                      modelName: eventView.label,
                      selected: index == selectedEventIndex,
                    ),
                  );
                } else if (selectedModelName == 'All') {
                  return ListTile(
                    dense: true,
                    onTap: () => onTap(index),
                    title: EventText(
                      rowNum: index + 1,
                      ts: AppDateTime.timeForDateTime(
                        DateTime.fromMillisecondsSinceEpoch(
                            eventView.timestamp),
                      ),
                      modelName: eventView.label,
                      selected: index == selectedEventIndex,
                    ),
                  );
                }
                return Container();
              },
              separatorBuilder: (_, __) =>  Container(),
            ),
          ),
        ),
      ],
    );
  }
}
