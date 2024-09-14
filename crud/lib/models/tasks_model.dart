class TasksModel {
  int? id;
  String? title;
  String? subTitle;
  String? description;
  int? isCompleted;
  TasksModel(this.id,
      {required this.title,
      required this.subTitle,
      required this.description,
      this.isCompleted});
  void updateModel({ required String title,
      required String subTitle,
      required String description,
      required int isCompleted}) {
    this.title = title;
    this.subTitle = subTitle;
    this.description = description;
    this.isCompleted = isCompleted;
  }
}
