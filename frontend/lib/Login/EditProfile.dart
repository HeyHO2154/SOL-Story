
// 미사용
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final String title;
  final List<String> items;
  final String currentName;
  final String currentJob;

  EditProfile({
    required this.title,
    required this.items,
    required this.currentName,
    required this.currentJob,
  });

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late Map<String, TextEditingController> _controllers;
  late TextEditingController _nameController;
  late TextEditingController _jobController;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (var item in widget.items)
        item.split(':')[0]: TextEditingController(text: item.split(':')[1].trim())
    };
    _nameController = TextEditingController(text: widget.currentName);
    _jobController = TextEditingController(text: widget.currentJob);
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    _nameController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text(
          '프로필 수정',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (widget.title == '개인 정보') // 이름 수정 필드 추가
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: '이름',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            if (widget.title == '기타 정보') // 직업 수정 필드 추가
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _jobController,
                  decoration: InputDecoration(
                    labelText: '직업',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ...widget.items.map((item) {
              final key = item.split(':')[0];
              final controller = _controllers[key];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: controller!,
                  decoration: InputDecoration(
                    labelText: key,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: key == '나이' ? TextInputType.number : TextInputType.text,
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final updatedData = {
                    for (var entry in _controllers.entries)
                      entry.key: entry.value.text,
                    '이름': _nameController.text,
                    '직업': _jobController.text,
                  };
                  Navigator.pop(context, updatedData);
                },
                child: Text('저장'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
