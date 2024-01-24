import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showContact = false;
  bool _showEducation = false;
  bool _showEmployment = false;
  bool _showSkills = false;
  bool _showSpecialization = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage:
                      AssetImage('assets/images/profile_picture.png'),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'johndoe@example.com',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'About Me',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      initialValue:
                          'I am a software developer with experience in Flutter and Dart.',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your about me.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        // Save the about me value
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState != null) {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  // Save the profile data
                                }
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Reset the form
                              _formKey.currentState?.reset();
                            },
                            child: const Text('Reset'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Contact'),
                trailing: IconButton(
                  icon: Icon(_showContact
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down),
                  onPressed: () {
                    setState(() {
                      _showContact = !_showContact;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _showContact = !_showContact;
                  });
                },
              ),
              if (_showContact)
                const Column(
                  children: [
                    ListTile(
                      title: Text('Email'),
                      subtitle: Text('johndoe@example.com'),
                    ),
                    ListTile(
                      title: Text('Phone'),
                      subtitle: Text('(123) 456-7890'),
                    ),
                    ListTile(
                      title: Text('Address'),
                      subtitle: Text('123 Main St, Anytown, USA'),
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Education'),
                trailing: IconButton(
                  icon: Icon(_showEducation
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down),
                  onPressed: () {
                    setState(() {
                      _showEducation = !_showEducation;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _showEducation = !_showEducation;
                  });
                },
              ),
              if (_showEducation)
                const Column(
                  children: [
                    ListTile(
                      title: Text('Bachelor of Science in Computer Science'),
                      subtitle: Text('University of Anytown, 2015-2019'),
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Employment'),
                trailing: IconButton(
                  icon: Icon(_showEmployment
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down),
                  onPressed: () {
                    setState(() {
                      _showEmployment = !_showEmployment;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _showEmployment = !_showEmployment;
                  });
                },
              ),
              if (_showEmployment)
                const Column(
                  children: [
                    ListTile(
                      title: Text('Software Developer'),
                      subtitle: Text('ABC Company, 2019-Present'),
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Skills'),
                trailing: IconButton(
                  icon: Icon(_showSkills
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down),
                  onPressed: () {
                    setState(() {
                      _showSkills = !_showSkills;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _showSkills = !_showSkills;
                  });
                },
              ),
              if (_showSkills)
                const Column(
                  children: [
                    ListTile(
                      title: TextField(
                        decoration: InputDecoration(
                          labelText: 'Add a skill',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        Chip(
                          label: Text('Flutter'),
                        ),
                        Chip(
                          label: Text('Dart'),
                        ),
                        Chip(
                          label: Text('Java'),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Specialization'),
                trailing: IconButton(
                  icon: Icon(_showSpecialization
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down),
                  onPressed: () {
                    setState(() {
                      _showSpecialization = !_showSpecialization;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _showSpecialization = !_showSpecialization;
                  });
                },
              ),
              if (_showSpecialization)
                const Column(
                  children: [
                    ListTile(
                      title: TextField(
                        decoration: InputDecoration(
                          labelText: 'Add a specialization',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        Chip(
                          label: Text('Mobile Development'),
                        ),
                        Chip(
                          label: Text('Web Development'),
                        ),
                        Chip(
                          label: Text('Backend Development'),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Hotlinks'),
                onTap: () {
                  // Navigate to Hotlinks Screen
                },
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Interests'),
                onTap: () {
                  // Navigate to Interests Screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
