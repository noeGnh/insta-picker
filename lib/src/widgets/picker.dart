import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_picker/src/models/folder-model.dart';
import 'package:insta_picker/src/providers/picker-provider.dart';
import 'package:provider/provider.dart';

class Picker extends StatelessWidget {
  final title;

  Picker({this.title});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PickerProvider>(
      create: (_) => PickerProvider(),
      child: _PickerView(title: title,),
    );
  }
}

class _PickerView extends StatefulWidget {
  final title;

  _PickerView({Key key, this.title}) : super(key: key);

  @override
  _PickerViewState createState() => _PickerViewState();
}

class _PickerViewState extends State<_PickerView> {

  PickerProvider pickerProvider;

  @override
  void initState() {
    super.initState();

    pickerProvider =  Provider.of<PickerProvider>(context, listen: false);
    pickerProvider.getImagesPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.clear),
                    SizedBox(width: 10),
                    Consumer<PickerProvider>(
                        builder: (ctx, provider, child){

                          return DropdownButtonHideUnderline(
                              child: DropdownButton<FolderModel>(
                                items: provider.getItems(),
                                onChanged: (FolderModel folder) => provider.onFolderSelected(folder),
                                value: provider.selectedFolder,
                              )
                          );

                        }
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Suivant', style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ),
            Divider(),
            Container(
                height: MediaQuery.of(context).size.height * 0.45,
                child: Consumer<PickerProvider>(
                  builder: (ctx, provider, child){

                    return provider.image != null ?
                    Image.file(File(provider.image),
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width
                    ) : Container();

                  }
                ),
            ),
            Divider(),
                Consumer<PickerProvider>(
                  builder: (ctx, provider, child){

                    return provider.selectedFolder == null && provider.selectedFolder.files.length < 1
                        ? Container()
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.38,
                            child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4, crossAxisSpacing: 4, mainAxisSpacing: 4
                                ),
                                itemBuilder: (_, i) {
                                  var file = provider.selectedFolder.files[i];
                                  return GestureDetector(
                                    child: Image.file(
                                      File(file),
                                      fit: BoxFit.cover,
                                    ),
                                    onTap: () {
                                      provider.image = file;
                                    },
                                  );
                                },
                                itemCount: provider.selectedFolder.files.length
                            ),
                        );

                  }
                ),
          ],
        )
      ),
    );
  }

}

