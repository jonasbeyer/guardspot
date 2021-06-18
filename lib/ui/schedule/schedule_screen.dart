import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/schedule_entry.dart';
import 'package:guardspot/ui/common/card/flat_card.dart';
import 'package:guardspot/ui/common/widgets/content_loading_error.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/project/view/schedule/schedule_entry_item.dart';
import 'package:guardspot/ui/schedule/schedule_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late ScheduleViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.fetchSchedule();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: 600,
        child: ViewSchedule(
          scheduleEntries: _viewModel.data,
        ),
      ),
    );
  }
}

class ViewSchedule extends StatelessWidget {
  final Stream<List<ScheduleEntry>> scheduleEntries;
  final EdgeInsets padding;
  final bool shrinkWrap;

  ViewSchedule({
    required this.scheduleEntries,
    this.padding = const EdgeInsets.all(16.0),
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return TypedStreamBuilder(
      stream: scheduleEntries,
      errorWidget: ContentLoadingNetworkError(),
      builder: (List<ScheduleEntry> scheduleEntries) => scheduleEntries.isEmpty
          ? _buildPlaceholder(context)
          : _buildSchedule(context, scheduleEntries),
    );
  }

  Widget _buildSchedule(BuildContext context, List<ScheduleEntry> entries) {
    ThemeData themeData = Theme.of(context);
    return GroupedListView<ScheduleEntry, DateTime>(
      padding: padding,
      elements: entries,
      groupBy: (ScheduleEntry entry) => DateTime(
        entry.startsAt!.year,
        entry.startsAt!.month,
        entry.startsAt!.day,
      ),
      shrinkWrap: shrinkWrap,
      groupSeparatorBuilder: (DateTime date) => Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: FlatCard(
          child:
              Text("date_long", style: TextStyles.secondarySubtitle(themeData))
                  .t(context, arguments: {"date": date}),
        ),
      ),
      separator: SizedBox(height: 16.0),
      itemBuilder: (context, element) => ScheduleEntryItem(element),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return ContentLoadingError(
      icon: Icon(Icons.calendar_today),
      message: Text("no_schedule_entry_hint").t(context),
    );
  }
}
