import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mustang_viewer/src/models/app_event.model.dart';
import 'package:mustang_viewer/src/shared_widgets/event_text.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_date_time.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';

class AppStateTimeline extends StatelessWidget {
  const AppStateTimeline(
    this.events,
    this.onTap,
    this.scrollController,
    this.selectedEventIndex,
    this.scroll,
    this.onSearch, {
    Key? key,
  }) : super(key: key);

  final List<AppEvent> events;
  final void Function(int eventIndex) onTap;
  final ScrollController scrollController;
  final int selectedEventIndex;
  final bool scroll;
  final void Function(String) onSearch;

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
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: AppConstants.search,
              ),
              onChanged: onSearch,
            ),
          ),
        ),
        Expanded(
          child: Scrollbar(
            isAlwaysShown: true,
            controller: scrollController,
            child: ListView.separated(
              controller: scrollController,
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) {
                AppEvent appEvent = events[index];
                return ListTile(
                  dense: true,
                  onTap: () => onTap(index),
                  title: EventText(
                    rowNum: index + 1,
                    ts: AppDateTime.timeForDateTime(
                      DateTime.fromMillisecondsSinceEpoch(appEvent.timestamp),
                    ),
                    modelName: appEvent.modelName,
                    selected: index == selectedEventIndex,
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
