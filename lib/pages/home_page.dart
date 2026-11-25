
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = AuthService();
  late Future<UserModel> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = _auth.getUser();
  }

  // Logout function
  Future<void> _logout() async {
    await _auth.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (_) => false,
    );
  }

  // Navigation function
  void _goTo(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // USER INFORMATION
            FutureBuilder<UserModel>(
              future: _futureUser,
              builder: (context, snap) {

                if (snap.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snap.hasError) {
                  return Column(
                    children: [
                      Text(snap.error.toString()),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _logout,
                        child: const Text('Kembali ke Login'),
                      ),
                    ],
                  );
                }

                final user = snap.data!;

                return Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.account_circle,
                          size: 65,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 10),

                        Text(
                          'Halo, ${user.name}',
                          style: Theme.of(context)
                              .textTheme.headlineSmall,
                        ),

                        const SizedBox(height: 5),

                        Text(user.email),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            // OLD HOMEPAGE MENU
            const Text(
              'Routes or Home Pages',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // ABOUT
            _menuButton(
              title: 'About',
              icon: Icons.info,
              onPressed: () => _goTo('/about'),
            ),

            // EXPANDED
            _menuButton(
              title: 'Sized Expanded',
              icon: Icons.expand,
              onPressed: () => _goTo('/sizeExpanded'),
            ),

            // GRID
            _menuButton(
              title: 'List Grid',
              icon: Icons.grid_view,
              onPressed: () => _goTo('/gridbasic'),
            ),

            // FORMULIR
            _menuButton(
              title: 'Formulir',
              icon: Icons.edit_document,
              onPressed: () => _goTo('/formulir'),
            ),

            // STADIUM
            _menuButton(
              title: 'Stadium Home',
              icon: Icons.stadium,
              onPressed: () => _goTo('/stadium-home'),
            ),

            // ALBUM
            _menuButton(
              title: 'Album',
              icon: Icons.photo_album,
              onPressed: () => _goTo('/albumpage'),
            ),

            // POST
            _menuButton(
              title: 'Post Page',
              icon: Icons.article,
              onPressed: () => _goTo('/postpage'),
            ),
            // ARTICLE LIST
            _menuButton(
              title: 'Article List',
              icon: Icons.list,
              onPressed: () => _goTo('/article-list'),
            ),
            // ARTICLE FORM
            _menuButton(
              title: 'Article Form',
              icon: Icons.add,
              onPressed: () => _goTo('/article-form'),
            ),

            const SizedBox(height: 20),

            // LOGOUT BUTTON
            ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable menu button
  Widget _menuButton({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
