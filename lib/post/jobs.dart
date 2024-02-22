import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  final CollectionReference _jobs = FirebaseFirestore.instance.collection('jobs');
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Save functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          DropdownButton<String>(
            value: _selectedCategory,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
            items: ['All', 'Development', 'Design', 'Marketing']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _jobs.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final jobs = snapshot.data!.docs
                    .where((doc) =>
                        (_selectedCategory == 'All' || doc['category'] == _selectedCategory) &&
                        doc['title'].toLowerCase().contains(_searchController.text.toLowerCase()))
                    .map((doc) {
                  final data = doc.data()! as Map<String, dynamic>;
                  return Job(
                    id: doc.id,
                    title: data['title'],
                    company: data['company'],
                    location: data['location'],
                    category: data['category'],
                    description: data['description'],
                  );
                }).toList();

                return ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final job = jobs[index];
                    return ListTile(
                      leading: const Icon(Icons.work),
                      title: Text(job.title),
                      subtitle: Text('${job.company} - ${job.location}'),
                      trailing: const Icon(Icons.favorite_border),
                      onTap: () {
                        // Navigate to job details page
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String category;
  final String description;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.category,
    required this.description,
  });
}