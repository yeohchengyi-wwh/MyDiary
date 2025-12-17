class MyDiary{
  int diaryId;
  String diaryTitles;
  String diaryNotes;
  String date;
  String image;

  MyDiary(
    this.diaryId, this.diaryTitles, this.diaryNotes, this.date, this.image
  );

  Map<String, dynamic> toMap() {
    return {
      'diary_id': diaryId,
      'diary_title': diaryTitles,
      'diary_notes': diaryNotes,
      'date': date,
      'image': image,
    };
  }

  factory MyDiary.fromMap(Map<String, dynamic> map) {
    return MyDiary(
      map['diary_id'] ?? 0,
      map['diary_title'] ?? '',
      map['diary_notes'] ?? '',
      map['date'] ?? '',
      map['image'] ?? '',
    );
  }
}