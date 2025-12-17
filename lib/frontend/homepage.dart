import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mydiary/models/mydairy.dart';
import 'package:mydiary/databasehelper.dart';
import 'package:mydiary/frontend/newdiaryscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double width, height;
  List<MyDiary> mydiary = [];
  String status = "Loading...";
  int curpageno = 1;
  int limit = 5;
  int pages = 1;

  Color priColor = const Color.fromARGB(255, 116, 144, 227);
  Color secColor = const Color.fromARGB(255, 245, 178, 107);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: priColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewDariy()),
          );
          loadData();
        },
        backgroundColor: secColor,
        elevation: 4,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white, size: 32),
      ),

      body: Column(
        children: [
          //Header
          SafeArea(
            child: Container(
              padding: const EdgeInsets.only(bottom: 5),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      'My Diary',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    child: IconButton(
                      onPressed: loadData,
                      icon: Icon(Icons.refresh, size: 28, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Main Area Page
          Expanded(
            child: Container(
              width: width,
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              decoration: BoxDecoration(
                color: Color(0xFFF5F7FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              //Search Bar
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width * 0.88,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26.withValues(alpha: 0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: showSearchDialog,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: Colors.blueGrey,
                                size: 30,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
                                    'Search...',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //ListView (Display Data MyDiary)
                  Expanded(
                    child: mydiary.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.folder_open_rounded,
                                    color: secColor,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: mydiary.length,
                            itemBuilder: (_, index) {
                              final item = mydiary[index];
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  0,
                                  20,
                                  20,
                                ),
                                child: InkWell(
                                  onTap: () => showDetailDialog(item),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: secColor.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    //Thumbnail
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: width * 0.25,
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: loadImage(item.image),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        // Display diary title and date
                                        SizedBox(
                                          width: width * 0.45,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.diaryTitles,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  height: 1,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                item.date,
                                                style: TextStyle(fontSize: 17),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              20,
                                              0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () =>
                                                      editDiary(item),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: () =>
                                                      deleteDiary(item),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          //Page Control
          if (mydiary.isNotEmpty)
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: curpageno > 1
                          ? () {
                              curpageno--;
                              loadData();
                            }
                          : null,
                    ),
                    Text(
                      "Page $curpageno of $pages",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: curpageno < pages
                          ? () {
                              curpageno++;
                              loadData();
                            }
                          : null,
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

//Function
  Future<void> loadData() async {
    setState(() {
      status = "Loading...";
      mydiary = [];
    });

    final total = await DatabaseHelper().getTotalCount();
    pages = (total / limit).ceil();

    if (curpageno > pages && pages > 0) {
      curpageno = pages;
    } else if (pages == 0) {
      curpageno = 1;
    }

    int offset = (curpageno - 1) * limit;
    mydiary = await DatabaseHelper().getMyDiarysPaginated(limit, offset);

    if (mydiary.isEmpty) status = "No record found. Add one to get started.";
    setState(() {});
  }

  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Search Diary',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: priColor,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Type a Title',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: priColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          String search = searchController.text.trim();
                          if (search.isEmpty) {
                            loadData();
                          } else {
                            loadSearchData(search);
                          }
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDetailDialog(MyDiary item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.diaryTitles,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      letterSpacing: 1.2,
                    ),
                  ),
                  // Image Preview
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: loadImage(item.image),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    'Note Descriptions',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  Text(
                    item.diaryNotes,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade900),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Date',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  Text(
                    item.date,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade900),
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: priColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "CLOSE",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget loadImage(String image) {
    if (image == "") {
      return const Icon(
        Icons.image_not_supported_rounded,
        size: 60,
        color: Colors.grey,
      );
    }

    final file = File(image);
    return file.existsSync()
        ? Image.file(file, fit: BoxFit.cover)
        : const Icon(Icons.broken_image, size: 60, color: Colors.grey);
  }

  void deleteDiary(MyDiary diary) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Diary'),
          content: const Text(
            'Are you sure you want to delete this diary? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => deleteDiaryQuery(diary),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void deleteDiaryQuery(MyDiary diary) async {
    await DatabaseHelper().deleteMyDiary(diary.diaryId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Diary Delete Successfully',
          style: TextStyle(fontSize: 15),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
    loadData();
  }

  void loadSearchData(String search) async {
    mydiary = await DatabaseHelper().searchMyDiary(search.trim());
    if (mydiary.isEmpty) {
      status = "No diary match your search";
    } else {
      status = "";
    }
    setState(() {});
  }

  void editDiary(MyDiary item) {
    TextEditingController titleController = TextEditingController(
      text: item.diaryTitles,
    );
    TextEditingController noteController = TextEditingController(
      text: item.diaryNotes,
    );

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit Diary',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: priColor,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.edit),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: noteController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Diary Descriptions',
                    prefixIcon: Icon(Icons.edit),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: priColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          if (titleController.text.isEmpty ||
                              noteController.text.isEmpty)
                            return;
                          item.diaryTitles = titleController.text.trim();
                          item.diaryNotes = noteController.text.trim();
                          await DatabaseHelper().updateMyDiary(item);

                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Updated successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                          loadData();
                        },
                        child: const Text('Update'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
