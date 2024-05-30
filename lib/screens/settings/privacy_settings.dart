import 'package:flutter/material.dart';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  bool switch1 = false;
  bool switch2 = false;
  bool switch3 = false;
  bool switch4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Settings', style: Theme.of(context).textTheme.displayMedium,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Hide Phone Contacts', style: Theme.of(context).textTheme.bodyMedium,),
              onTap: (){
                setState(() {
                  if(switch1==true){
                    switch1=false;
                  }
                  else{
                    switch1=true;
                  }
                });
              },
              trailing: Switch(
                value: switch1,
                onChanged: (value){
                  setState(() {
                    switch1=value;
                  });
                }
              ),
            ),
            ListTile(
              title: Text('Hide users within 10km of distance', style: Theme.of(context).textTheme.bodyMedium,),
              onTap: (){
                setState(() {
                  if(switch2==true){
                    switch2=false;
                  }
                  else{
                    switch2=true;
                  }
                });
              },
              trailing: Switch(
                  value: switch2,
                  onChanged: (value){
                    setState(() {
                      switch2=value;
                    });
                  }
              ),
            ),
            ListTile(
              title: Text('Hide from all', style: Theme.of(context).textTheme.bodyMedium,),
              onTap: (){
                setState(() {
                  if(switch3==true){
                    switch3=false;
                  }
                  else{
                    switch3=true;
                  }
                });
              },
              trailing: Switch(
                  value: switch3,
                  onChanged: (value){
                    setState(() {
                      if(switch3==true){
                        switch3=false;
                      }
                      else{
                        switch3=true;
                      }
                    });
                  }
                ),
            ),
            ListTile(
              title: Text('Profile visible to only members club', style: Theme.of(context).textTheme.bodyMedium,),
              onTap: (){
                setState(() {
                  if(switch4==true){
                    switch4=false;
                  }
                  else{
                    switch4=true;
                  }
                });
              },
              trailing: Switch(
                  value: switch4,
                  onChanged: (value){
                    setState(() {
                      switch4=value;
                    });
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
