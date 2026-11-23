import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _institution = '';
  String? _level;
  String? _status;
  String _program = '';
  String _startYear = '';

  void _showSummary() {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text('Ringkasan Edukasi'),
        content: Text(
          [
            'Nama institusi: $_institution',
            'Jenjang: $_level',
            'Status pendidikan: $_status',
            if (_level == 'Perguruan Tinggi' && _program.isNotEmpty)
              'Program studi: $_program',
            if (_startYear.isNotEmpty) 'Tahun masuk: $_startYear',
          ].join('\n'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tambah Edukasi'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama institusi',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) => (value ?? '').trim().isEmpty
                    ? 'Masukkan nama institusi.'
                    : null,
                onSaved: (value) => _institution = value!.trim(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Jenjang',
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
                items: const ['SMP', 'SMA', 'Perguruan Tinggi']
                    .map(
                      (level) =>
                          DropdownMenuItem(value: level, child: Text(level)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _level = value),
                validator: (value) => value == null ? 'Pilih jenjang.' : null,
              ),
              if (_level == 'Perguruan Tinggi') ...[
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Program studi (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => _program = (value ?? '').trim(),
                ),
              ],
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Status pendidikan',
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
                items: const ['Sedang ditempuh', 'Selesai', 'Pindah sekolah']
                    .map(
                      (status) =>
                          DropdownMenuItem(value: status, child: Text(status)),
                    )
                    .toList(),
                onChanged: (value) => _status = value,
                validator: (value) =>
                    value == null ? 'Pilih status pendidikan.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tahun masuk (opsional)',
                  hintText: 'Contoh: 2025',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final year = (value ?? '').trim();
                  if (year.isEmpty) return null;
                  if (!RegExp(r'^[1-9][0-9]{3}$').hasMatch(year)) {
                    return 'Gunakan empat digit untuk tahun masuk.';
                  }
                  return null;
                },
                onSaved: (value) => _startYear = value!.trim(),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _showSummary,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
