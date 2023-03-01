import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/widgets/admin_drawer_navigation.dart';
import 'package:flutter/material.dart';

class SuperAdminScreen extends StatefulWidget {
  const SuperAdminScreen({Key? key}) : super(key: key);

  @override
  State<SuperAdminScreen> createState() => _SuperAdminScreenState();
}

class _SuperAdminScreenState extends State<SuperAdminScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Usuários Registrados", style: AppTheme.typo.title)),
        drawer: adminDrawerNavigation(context),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('USUARIOS')
                        .where('tipo', isNotEqualTo: 'super_admin')
                        .orderBy('tipo', descending: false)
                        .orderBy('name', descending: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        final data = snapshot.data!.docs;

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.size,
                          itemBuilder: (context, index) {
                            final userPhoto = data[index]['url_photo'];
                            final userName = data[index]['name'];
                            final userEmail = data[index]['email'];
                            final userType = data[index]['tipo'];

                            var isAdmin = userType == 'admin' ? true : false;

                            return SwitchListTile(
                              contentPadding: const EdgeInsets.all(5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              title: Text(userName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(userEmail),
                              secondary: CircleAvatar(
                                radius: 25,
                                backgroundImage: userPhoto == ''
                                    ? const AssetImage(
                                        'lib/assets/img/user-default.jpg')
                                    : NetworkImage(userPhoto) as ImageProvider,
                              ),
                              value: isAdmin,
                              onChanged: (bool value) {
                                setState(() {
                                  isAdmin = value;

                                  isAdmin
                                      ? data[index]
                                          .reference
                                          .update({'tipo': 'admin'})
                                      : data[index]
                                          .reference
                                          .update({'tipo': 'user'});
                                });
                              },
                            );
                          },
                        );
                      }
                    }),
              ],
            )));
  }
}
