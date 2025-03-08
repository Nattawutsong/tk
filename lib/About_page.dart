import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประเภทแมลง'),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('insectspecies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data?.docs ?? [];

          if (data.isEmpty) {
            return Center(child: Text('ไม่มีข้อมูล'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final doc = data[index];
              final nameTh = doc['Name_th'] ?? 'ไม่มีข้อมูล';
              final nameEd = doc['Name_ed'] ?? 'ไม่มีข้อมูล';
              final about = doc['About'] ?? 'ไม่มีข้อมูล';
              final img = doc['img'] ?? '';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiseaseDetailPage(doc: doc),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    title: Text(
                      '$nameTh ($nameEd)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(about, maxLines: 2, overflow: TextOverflow.ellipsis),
                    leading: img.isNotEmpty
                        ? Image.network(
                      img,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DiseaseDetailPage extends StatelessWidget {
  final DocumentSnapshot doc;

  DiseaseDetailPage({required this.doc});

  @override
  Widget build(BuildContext context) {
    final nameTh = doc['Name_th'] ?? 'ไม่มีข้อมูล';
    final nameEd = doc['Name_ed'] ?? 'ไม่มีข้อมูล';
    final about = doc['About'] ?? 'ไม่มีข้อมูล';
    final img = doc['img'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('$nameTh'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            img.isNotEmpty
                ? Image.network(img, width: double.infinity, fit: BoxFit.cover)
                : Container(height: 200, color: Colors.grey[200]),
            SizedBox(height: 16),
            Text(
              '$nameTh ($nameEd)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'ข้อมูลเกี่ยวกับ: \n$about',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}