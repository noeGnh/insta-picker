import 'package:flutter/material.dart';
import 'package:insta_picker/src/providers/picker_provider.dart';
import 'package:insta_picker/src/widgets/gallery.dart';
import 'package:insta_picker/src/widgets/photo.dart';
import 'package:insta_picker/src/widgets/video.dart';
import 'package:provider/provider.dart';

class Picker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PickerProvider>(
      create: (_) => PickerProvider(),
      child: DefaultTabController(
        length: 3,
        child: PickerView(),
      ),
    );
  }
}

class PickerView extends StatefulWidget {
  @override
  _PickerViewState createState() => _PickerViewState();
}

class _PickerViewState extends State<PickerView> {

  PickerProvider pickerProvider;

  @override
  void initState() {
    super.initState();

    pickerProvider =  Provider.of<PickerProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
     return Consumer<PickerProvider>(
         builder : (context, provider, child){
           return Scaffold(
             body: TabBarView(
                 children: [
                   Gallery(),
                   Photo(),
                   Video()
                 ]
             ),
             bottomNavigationBar: SizedBox(
               child: TabBar(
                 tabs: [
                   Tab(text: "Galerie",),
                   Tab(text: "Photo",),
                   Tab(text: "Video",),
                 ],
                 isScrollable: false,
                 indicatorWeight: 1.5,
                 labelColor: Colors.orange,
                 indicatorColor: Colors.orange,
                 unselectedLabelColor: Colors.orange,
               ),
             ),
           );
         }
     );
  }

}

