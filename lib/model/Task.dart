class Task {
  final int id;
  final String name;
  final String note;
  final String type;
  final String status;
  final String startTime;

  final String endTime;
  static final columns = [
    "id",
    "name",
    "note",
    "type",
    "status",
    "start_time",
    "end_time"
  ];
  Task(this.id, this.name, this.note, this.type, this.status, this.startTime,
      this.endTime);
  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(data['id'], data['name'], data['note'], data['type'],
        data['status'], data['start_time'], data['end_time']);
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "note": note,
        "status": status,
        "type": type,
        "start_time": startTime,
        "end_time": endTime
      };
}
