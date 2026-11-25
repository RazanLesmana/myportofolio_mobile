import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';
import '../services/api_client.dart';
import '../services/auth_state.dart';
import '../widgets/auth_guard.dart';
import '../widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});
  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '',
      description = '',
      techStack = '',
      projectUrl = '',
      imageUrl = '';
  bool busy = false;
  Future<void> _submit() async {
    if (busy || !_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => busy = true);
    try {
      if (!await ensureLoggedIn(context) || !mounted) return;
      final token = context.read<AuthState>().token!;
      final project = await context.read<ApiClient>().createProject(
        Project(
          title: title,
          description: description,
          techStack: techStack,
          projectUrl: projectUrl,
          projectImageUrl: imageUrl,
        ),
        token: token,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Proyek tersimpan'),
          content: Text(project.title),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) _formKey.currentState!.reset();
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        await logoutWithFeedback(context);
        if (mounted) await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan proyek: $e')));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget _field(
    String label,
    ValueChanged<String> save, {
    bool url = false,
    bool optional = false,
  }) {
    return TextFormField(
      enabled: !busy,
      decoration: InputDecoration(labelText: label),
      keyboardType: url ? TextInputType.url : null,
      onSaved: (v) => save(v!.trim()),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) return optional ? null : '$label tidak boleh kosong!';
        if (url) {
          final uri = Uri.tryParse(text);
          if (uri == null ||
              !{'http', 'https'}.contains(uri.scheme) ||
              uri.host.isEmpty) {
            return 'Masukkan URL HTTP atau HTTPS yang valid';
          }
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tambah Proyek')),
    drawer: const LeftDrawer(),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field('Nama proyek', (v) => title = v),
          _field('Deskripsi proyek', (v) => description = v),
          _field('Tech stack', (v) => techStack = v),
          _field('Project URL', (v) => projectUrl = v, url: true),
          _field(
            'Project Image URL (opsional)',
            (v) => imageUrl = v,
            url: true,
            optional: true,
          ),
          ElevatedButton(
            onPressed: busy ? null : _submit,
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}
