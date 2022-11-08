import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extensiona_if/theme/app_theme.dart';
import 'package:extensiona_if/widgets/admin_drawer_navigation.dart';
import 'package:flutter/material.dart';

class SuperAdminScreen extends StatefulWidget {
  const SuperAdminScreen({Key key}) : super(key: key);

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
        title: Text("Usuários Registrados", style: AppTheme.typo.title)
      ),
        drawer: AdminDrawerNavigation(context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('USUARIOS')
                        .where('tipo', isNotEqualTo: 'super_admin')
                        .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    final _data = snapshot.data.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.size,
                      itemBuilder: (context, index) {
                        final userPhoto = _data[index]['url_photo'];
                        final userName = _data[index]['name'];
                        final userEmail = _data[index]['email'];
                        final userType = _data[index]['tipo'];

                        var _isAdmin = userType == 'admin' ? true : false;

                        return SwitchListTile(
                          contentPadding: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          title: Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(userEmail),
                          secondary: CircleAvatar(
                            radius: 25,
                            backgroundImage: userPhoto == ''
                                ? const AssetImage('lib/assets/img/user-default.jpg')
                                : NetworkImage(userPhoto),
                          ),
                          value: _isAdmin,
                          onChanged: (bool value) {
                            setState(() {
                              _isAdmin = value;

                              _isAdmin ? _data[index].reference.update({'tipo' : 'admin'}) :
                              _data[index].reference.update({'tipo' : 'user'});
                            });
                          },

                        );
                      },
                    );
                  }
                }),
          ],
        )
      )
    );
  }
}
