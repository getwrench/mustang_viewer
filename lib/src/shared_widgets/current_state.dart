import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';
import 'package:mustang_viewer/src/utils/event_view.dart';

class CurrentState extends StatelessWidget {
  const CurrentState(
    this.data,
    this.onTap, {
    Key? key,
  }) : super(key: key);

  final Map<String, String> data;
  final void Function(String modelName) onTap;

  @override
  Widget build(BuildContext context) {
    List<String> items = data.keys.toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppStyles.padding8),
          child: Text(
            AppConstants.liveAppState,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final String modelName = data.keys.first;
                EventView eventView =
                    EventView.fromJson(jsonDecode(data.values.first));
                return ListTile(
                  onTap: () => onTap(modelName),
                  title: Text(modelName),
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
