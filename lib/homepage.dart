import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePageState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageState> {
  late List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse("https://reqres.in/api/users?page=1"));
    if (response.statusCode == 200) {
      setState(() {
        final Map<String, dynamic> data = Map<String, dynamic>.from(json.decode(response.body));
        users = List<Map<String, dynamic>>.from(data['data']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: users.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tabs', style: TextStyle(color: Colors.orange)),
          backgroundColor: Colors.lightGreenAccent,
          bottom: TabBar(
            indicatorColor: Colors.orange,
            indicatorWeight: 4,
            labelStyle: TextStyle(color: Colors.cyanAccent),
            tabs: [
              for (var user in users) Text(user['first_name'].toString()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (var user in users)
              Container(
                color: Colors.lightGreenAccent,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Image.network(user['avatar'].toString()),
                    SizedBox(height: 20),
                    Text('Id = ${user['id']}'),
                    Text('Email = ${user['email']}'),
                    Text('First Name = ${user['first_name']}'),
                    Text('Last Name = ${user['last_name']}'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
