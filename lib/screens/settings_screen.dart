import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coin/blocs/expense_bloc.dart';
import 'package:flutter_coin/blocs/expense_event.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.currency_exchange),
          title: const Text('Currency'),
          subtitle: const Text(r'USD ($)'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement currency selection
          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          trailing: Switch(
            value: false, // TODO: Implement notification settings
            onChanged: (value) {},
          ),
        ),
        ListTile(
          leading: const Icon(Icons.backup),
          title: const Text('Export Data'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement data export
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: const Text('Clear All Data'),
          textColor: Colors.red,
          iconColor: Colors.red,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Clear All Data'),
                content: const Text(
                  'Are you sure you want to delete all expenses? This action cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<ExpenseBloc>().add(ClearExpenses());
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All data has been cleared'),
                        ),
                      );
                    },
                    child: const Text(
                      'Clear',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          subtitle: const Text('Version 1.0.0'),
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'Flutter Coin',
              applicationVersion: '1.0.0',
              applicationIcon: const FlutterLogo(size: 64),
              children: const [
                Text(
                  'A simple expense tracking app built with Flutter.',
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
