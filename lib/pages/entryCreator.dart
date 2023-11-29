import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lern_app/pages/entry.dart';

class EntryCreator extends StatefulWidget {
  static const List<String> subjectList = [
    "DBI",
    "SYP",
    "BWM",
    "POS",
    "NSCS",
    "D",
    "NW",
    "RK",
    "ETH",
    "GGP",
    "E",
    "WMC",
    "AM",
    "DSAI",
    "BESP"
  ];
  final void Function(Entry) addEntry;

  const EntryCreator({super.key, required this.addEntry});

  @override
  State<EntryCreator> createState() => _EntryCreatorState();
}

class _EntryCreatorState extends State<EntryCreator> {
  Entry entry = Entry.defaultEntry();

  @override
  void initState() {
    super.initState();
    entry.subject = EntryCreator.subjectList.elementAt(0);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width / 2;
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: screenWidth,
            child: DropdownButtonFormField(
              value: entry.subject,
              items: [
                for (var subject in EntryCreator.subjectList)
                  DropdownMenuItem(value: subject, child: Text(subject))
              ],
              onChanged: (value) {
                entry.subject = value!;
              },
            ),
          ),
          const Text('minutes'),
          SizedBox(
            width: 100,
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                setState(() {
                  entry.minutes = int.tryParse(value) ?? -1;
                });
              },
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: (entry.minutes < 20 || entry.minutes > 240)
                ? Colors.grey
                : Theme.of(context).primaryColorDark,
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: (entry.minutes < 20 || entry.minutes > 240)
                  ? null
                  : () => widget.addEntry(entry),
            ),
          )
        ],
      ),
    );
  }
}
