import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('SMK Negeri 4'),
        ),
        body: TabBarView(
          children: [
            BerandaTab(),
            UsersTab(),
            ProfilTab(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.group), text: 'Users'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
          ],
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.teal,
        ),
      ),
    );
  }
}

class BerandaTab extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.assignment_turned_in, 'label': 'Attendance'},
    {'icon': Icons.grade, 'label': 'Grades'},
    {'icon': Icons.calendar_today, 'label': 'Schedule'},
    {'icon': Icons.notifications_active, 'label': 'Information'},
    {'icon': Icons.forum, 'label': 'Forum'},
    {'icon': Icons.payment, 'label': 'Payments'},
    {'icon': Icons.library_books, 'label': 'Library'},
    {'icon': Icons.bus_alert, 'label': 'Transport'},
    {'icon': Icons.health_and_safety, 'label': 'Health'},
    {'icon': Icons.contact_mail, 'label': 'Contact Us'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with title "Dashboard"
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          // Grid of menu items
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return GestureDetector(
                  onTap: () {
                    // Handle tap on the menu icon
                    print('${item['label']} tapped');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'], size: 50.0, color: Colors.teal),
                        SizedBox(height: 8.0),
                        Text(
                          item['label'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



class UsersTab extends StatelessWidget {
  Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User List',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
        ),
      ),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  title: Text(user.firstName),
                  subtitle: Text(user.email),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class ProfilTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with background image
          Stack(
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/header_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
                      // Ganti URL di atas dengan URL gambar profil yang ingin Anda gunakan.
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30), // Adjust the spacing to account for the profile picture
          // User information
          Center(
            child: Text(
              'John Doe',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              'johndoe@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: 20),
          // Biodata section with cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.teal),
                    title: Text('Nama Lengkap'),
                    subtitle: Text('John Doe'),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Icon(Icons.cake, color: Colors.teal),
                    title: Text('Tanggal Lahir'),
                    subtitle: Text('1 Januari 2000'),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Icon(Icons.phone, color: Colors.teal),
                    title: Text('Telepon'),
                    subtitle: Text('+628123456789'),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Icon(Icons.location_city, color: Colors.teal),
                    title: Text('Alamat'),
                    subtitle: Text('Jalan Kenangan No. 4, Jakarta'),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Other Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Icon(Icons.school, color: Colors.teal),
                    title: Text('Sekolah'),
                    subtitle: Text('SMK Negeri 4'),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Icon(Icons.grade, color: Colors.teal),
                    title: Text('Kelas'),
                    subtitle: Text('12 RPL 1'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class User {
  final String firstName;
  final String email;
  final String avatarUrl;

  User({required this.firstName, required this.email, required this.avatarUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      email: json['email'],
      avatarUrl: json['avatar'],
    );
  }
}
