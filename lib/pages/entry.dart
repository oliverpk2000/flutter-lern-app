class Entry {
  late int minutes;
  late DateTime date;
  late String subject;

  Entry(this.minutes, this.date, this.subject);

  Entry.defaultEntry() {
    subject = "";
    minutes = -1;
    date = DateTime.now();
  }

  Entry.fromCsvString(String csvString) {
    var args = csvString.split(";");
    subject = args[0];
    minutes = int.tryParse(args[1])!;
    date = DateTime.parse(args[2]);
  }

  String toCsvString() {
    var csvString = "$subject;$minutes;$date";
    return csvString;
  }

  @override
  String toString() {
    return toCsvString();
  }
}
