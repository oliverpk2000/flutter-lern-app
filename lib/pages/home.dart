import 'package:flutter/material.dart';
import 'package:flutter_lern_app/pages/entry.dart';
import 'package:flutter_lern_app/pages/entryCreator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final String title;

  const Home({super.key, required this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState(){
    readEntryData("entries");
  }

  List<Entry> entries = [];

  @override
  Widget build(BuildContext context) {
    //var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
              onPressed: () {
                getModalBottomSheet(context);
              },
              icon: const Icon(Icons.add_circle_outline)),
        ],
      ),
      body: (entries.isEmpty)
          ? (const Text(
              "study some",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ))
          : Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              entries.map((e) => e.subject).toSet().length,
                          itemBuilder: (context, index) {
                            var subjects =
                                entries.map((e) => e.subject).toSet();
                            Map<String, int> subjectMap = {};
                            for (var element in entries) {
                              var minutesForSubject = entries
                                  .where((e) => element.subject == e.subject)
                                  .map((element) => element.minutes)
                                  .reduce((min1, min2) => min1 + min2);
                              subjectMap.putIfAbsent(
                                  element.subject, () => minutesForSubject);
                            }
                            return Container(
                              margin: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Text(
                                      "${subjects.elementAt(index)} (${subjectMap[subjects.elementAt(index)]!.toString()})"),
                                  SizedBox(
                                    width: 300,
                                    height: 20,
                                    child: LinearProgressIndicator(
                                      value: subjectMap[
                                              subjects.elementAt(index)]! /
                                          subjectMap.entries
                                              .map((e) => e.value.toDouble())
                                              .reduce((value, element) =>
                                                  value + element),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries.elementAt(index);
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                        ),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.lightBlue, width: 2)),
                            child: Text(
                              "${entry.minutes}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(entry.subject),
                          subtitle:
                              Text(DateFormat('yyyy/MM/dd').format(entry.date)),
                          trailing: IconButton(
                            onPressed: () {
                              removeEntry(index);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getModalBottomSheet(context);
        },
        child: const Icon(Icons.add_circle_outline),
      ),
    );
  }

  Future<void> getModalBottomSheet(context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return EntryCreator(addEntry: (entry) async {
          entry.date = (await setEntryDate(context))!;
          addEntry(entry);
          Navigator.pop(context);
        });
      },
    );
  }

  Future<DateTime?> setEntryDate(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime.now());
  }

  void addEntry(Entry entry) {
    setState(() {
      print("added: $entry");
      entries.add(entry);
      writeEntryData("entries");
    });
  }

  void removeEntry(int index) {
    setState(() {
      print("removed: ${entries[index]}");
      entries.removeAt(index);
      writeEntryData("entries");
    });
  }

  readEntryData(String key) async {
    print("reading data");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? entriesAsString = prefs.getStringList(key);
    entries = [];
    if (entriesAsString != null) {
      for (var csvString in entriesAsString) {
        Entry entry = Entry.fromCsvString(csvString);
        entries.add(entry);
      }
    }
  }

  writeEntryData(String key) async {
    print("writing data");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> entriesAsCSV = entries.map((e) => e.toCsvString()).toList();
    await prefs.setStringList(key, entriesAsCSV);
  }
}
