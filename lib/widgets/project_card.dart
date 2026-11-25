import '../widgets/auth_guard.dart';
import '../services/auth_state.dart';
import '../screens/project_list_screen.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // Menggunakan warna sekunder dari skema tema aplikasi.
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // Aksi ketika kartu ditekan oleh pengguna.
        onTap: () async {
          if (item.name == 'Logout') {
            if (context.read<AuthState>().isLoggedIn) {
              await logoutWithFeedback(context);
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Belum login')));
            }
            return;
          }
          if (item.name == 'Tambah Proyek' &&
              (!await ensureLoggedIn(context) || !context.mounted)) {
            return;
          }
          if (!context.mounted) return;
          final page = switch (item.name) {
            'Tambah Proyek' => const ProjectFormPage(),
            'Lihat Proyek' => const ProjectListScreen(),
            _ => const EducationFormPage(),
          };
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
