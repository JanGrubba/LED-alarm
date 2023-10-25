import 'package:led_alarm/model/event.dart';
import 'package:led_alarm/util/common_package.dart';

typedef OnChooseType(Event event, EventType mode);

class EventTypeTile extends StatelessWidget {
  final Event event;
  final OnChooseType onChoose;

  const EventTypeTile({Key? key, required this.event, required this.onChoose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color matchingColor =
        MyTextStyle.getMatchingColorByBackgroundColor(backgroundColor: Theme.of(context).primaryColor);
    return ListTile(
      leading: Text(
        AppLocalizations.of(context)!.eventType,
        style: MyTextStyle.getAppBarTextStyleWithMatchedColor(context),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            event.eventType.getTitle(context),
            style: TextStyle(
              color: matchingColor,
            ),
          ),
          SizedBox(width: 5),
          Icon(
            Icons.arrow_forward_ios,
            color: matchingColor,
          ),
        ],
      ),
      onTap: () => _showBottomMenu(context),
    );
  }

  void _showBottomMenu(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (context) {
        List<EventType> eventTypes = EventType.values;
        return Column(
          key: Key("EventTypeBottomMenu"),
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            eventTypes.length,
            (index) => _buildTile(context, eventTypes[index]),
          ),
        );
      },
    );
  }

  Widget _buildTile(BuildContext context, EventType mode) {
    bool isSelected = event.eventType == mode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        selected: isSelected,
        trailing: isSelected ? Icon(Icons.done) : SizedBox.shrink(),
        title: new Text(
          mode.getTitle(context),
        ),
        onTap: () => onChoose(event, mode),
      ),
    );
  }
}
