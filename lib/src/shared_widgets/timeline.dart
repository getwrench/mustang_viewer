import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';
import 'package:mustang_viewer/src/utils/event_view.dart';

class Timeline extends StatelessWidget {
  const Timeline(
    this.data,
    this.onTap, {
    Key? key,
  }) : super(key: key);

  final List<BuiltMap<String, String>> data;
  final void Function(int eventIndex) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppStyles.padding8),
          child: Text(
            AppConstants.timeline,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: ListView.separated(
              shrinkWrap: true,
              reverse: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final String modelName = data[index].keys.first;
                EventView eventView =
                    EventView.fromJson(jsonDecode(data[index].values.first));
                return ListTile(
                  dense: true,
                  onTap: () => onTap(index),
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
