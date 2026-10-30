import 'dart:convert';
import 'package:flutter/material.dart';
import 'api.dart';

class Appearance extends ChangeNotifier {
  double scale = 1;
  int background = 0xFFF3F6F2;
  Future<void> load() async {
    try {
      final raw = await Api.storage.read(key: 'appearance');
      if (raw != null) {
        final data = jsonDecode(raw);
        scale = (data['scale'] as num).toDouble().clamp(0.85, 1.4);
        background = data['background'] as int;
        notifyListeners();
      }
    } catch (_) {
      /* Use defaults if saved preferences cannot be read. */
    }
  }

  Future<void> save(double value, int color) async {
    await Api.storage.write(
      key: 'appearance',
      value: jsonEncode({'scale': value, 'background': color}),
    );
    scale = value;
    background = color;
    notifyListeners();
  }
}

final appearance = Appearance();

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.api, required this.user});
  final Api api;
  final Map<String, dynamic> user;
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final name = TextEditingController(text: widget.user['name']);
  late final username = TextEditingController(text: widget.user['username']);
  bool busy = false;
  void message(Object value) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  Future<void> change(double scale, int color) async {
    try {
      await appearance.save(scale, color);
    } catch (_) {
      message('Không lưu được cài đặt. Hãy thử lại.');
    }
  }

  Future<void> saveProfile() async {
    setState(() => busy = true);
    try {
      final result = await widget.api.call('PATCH', '/me', {
        'name': name.text.trim(),
        'username': username.text.trim(),
      });
      widget.user.addAll(Map<String, dynamic>.from(result));
      message('Đã cập nhật hồ sơ cá nhân');
    } catch (e) {
      message(e);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    name.dispose();
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Cài đặt')),
    body: ListenableBuilder(
      listenable: appearance,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Giao diện', style: Theme.of(context).textTheme.titleLarge),
          Text('Cỡ chữ: ${(appearance.scale * 100).round()}%'),
          Slider(
            value: appearance.scale,
            min: 0.85,
            max: 1.4,
            divisions: 11,
            label: '${(appearance.scale * 100).round()}%',
            onChanged: (v) => change(v, appearance.background),
          ),
          const Text('Màu nền'),
          Wrap(
            spacing: 10,
            children: [
              for (final entry in const {
                0xFFF3F6F2: 'Xanh dịu',
                0xFFFFF8EC: 'Kem',
                0xFFEFF5FC: 'Xanh trời',
                0xFFF8F0F6: 'Hồng nhạt',
              }.entries)
                ChoiceChip(
                  label: Text(entry.value),
                  selected: appearance.background == entry.key,
                  backgroundColor: Color(entry.key),
                  onSelected: (_) => change(appearance.scale, entry.key),
                ),
            ],
          ),
          TextButton(
            onPressed: () => change(1, 0xFFF3F6F2),
            child: const Text('Khôi phục giao diện mặc định'),
          ),
          const Divider(height: 40),
          Text('Hồ sơ cá nhân', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: name,
            maxLength: 80,
            decoration: const InputDecoration(labelText: 'Họ tên'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: username,
            maxLength: 32,
            decoration: const InputDecoration(
              labelText: 'Tên đăng nhập',
              helperText: '3–32 ký tự: chữ, số hoặc dấu gạch dưới',
            ),
          ),
          const SizedBox(height: 12),
          Text('Email đã xác minh: ${widget.user['email']}'),
          const Text('Email và vai trò không thay đổi tại đây.'),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: busy ? null : saveProfile,
            child: Text(busy ? 'Đang lưu…' : 'Lưu hồ sơ'),
          ),
        ],
      ),
    ),
  );
}
