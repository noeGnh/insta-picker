import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_picker/src/models/folder_model.dart';
import 'package:insta_picker/src/providers/picker_provider.dart';
import 'package:provider/provider.dart';

class Picker extends StatefulWidget {
  final title;

  Picker({Key key, this.title}) : super(key: key);

  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {

  PickerProvider pickerProvider;

  @override
  void initState() {
    super.initState();

    pickerProvider =  Provider.of<PickerProvider>(context, listen: false);
    pickerProvider.getImagesPath();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PickerProvider>(
      create: (_) => PickerProvider(),
      child: Scaffold(
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
      ),
    );
  }

}

