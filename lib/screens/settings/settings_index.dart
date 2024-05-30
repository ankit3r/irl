import 'package:flutter/material.dart';
import 'package:irl/screens/settings/privacy_settings.dart';

class SettingsIndex extends StatefulWidget {
  const SettingsIndex({super.key});

  @override
  State<SettingsIndex> createState() => _SettingsIndexState();
}

class _SettingsIndexState extends State<SettingsIndex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings', style: Theme.of(context).textTheme.displayMedium,),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Divider(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            ListTile(
              title: const Text('Privacy Settings'),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const PrivacySettings()));
              },
              trailing: const Icon(Icons.navigate_next_rounded, size: 30,),
            )
          ],
        ),
      ),
    );
  }
}