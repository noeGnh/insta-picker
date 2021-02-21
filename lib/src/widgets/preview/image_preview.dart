import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_picker/insta_picker.dart';
import 'package:insta_picker/src/models/file_model.dart';
import 'package:insta_picker/src/providers/image_preview_provider.dart';
import 'package:provider/provider.dart';

Options options;

class ImagePreview extends StatelessWidget {

  final List<FileModel> files;
  final bool showAddButton;

  ImagePreview({@required Options imagePreviewOptions, @required this.showAddButton, this.files}){
    options = imagePreviewOptions;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImagePreviewProvider>(
        create: (_) => ImagePreviewProvider(),
        child: ImagePreviewContent(files: this.files, showAddButton: this.showAddButton),
    );
  }

}

class ImagePreviewContent extends StatefulWidget {
  final List<FileModel> files;
  final bool showAddButton;

  ImagePreviewContent({Key key, this.files, this.showAddButton}) : super(key: key);

  @override
  _ImagePreviewContentState createState() => _ImagePreviewContentState();
}

class _ImagePreviewContentState extends State<ImagePreviewContent> {
  ImagePreviewProvider _imagePreviewProvider;

  Widget _getItemCard(int index){
    return Card(
      child: Stack(
        children: [
          Image.file(
            File(_imagePreviewProvider.files.elementAt(index).filePath),
            fit: BoxFit.contain,
          ),
          Positioned(
              bottom: 10,
              right: 0,
              left: 0,
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            color: options.customizationOptions.bgColor,
                            shape: BoxShape.circle
                        ),
                        child: Icon(
                          Icons.photo_filter_sharp,
                          color: options.customizationOptions.iconsColor,
                          size: 32,
                        ),
                        alignment: Alignment.center,
                        width: 54,
                      ),
                      onTap: (){
                        _imagePreviewProvider.addFilter(context, _imagePreviewProvider.files.elementAt(index), options);
                      },
                    ),
                    SizedBox(width: 30,),
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            color: options.customizationOptions.bgColor,
                            shape: BoxShape.circle
                        ),
                        child: Icon(
                          Icons.edit,
                          color: options.customizationOptions.iconsColor,
                          size: 32,
                        ),
                        alignment: Alignment.center,
                        width: 54,
                      ),
                      onTap: (){
                        _imagePreviewProvider.edit(_imagePreviewProvider.files.elementAt(index), options);
                      },
                    ),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _imagePreviewProvider =  Provider.of<ImagePreviewProvider>(context, listen: false);
    _imagePreviewProvider.files = widget.files;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: options.customizationOptions.bgColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Aperçu', style: TextStyle(color: options.customizationOptions.textColor),),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: options.customizationOptions.iconsColor,
          ),
          onTap: (){
            Navigator.pop(context, null);
          },
        ),
        actions: [
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.check,
                color:options.customizationOptions.iconsColor,
              ),
            ),
            onTap: (){
              _imagePreviewProvider.submit(context);
            },
          )
        ],
        backgroundColor: options.customizationOptions.appBarColor,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 80),
        alignment: Alignment.center,
        child: Consumer<ImagePreviewProvider>(
            builder: (ctx, provider, child){

              int itemCount = widget.showAddButton ? provider.files.length + 1 : provider.files.length;

              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: itemCount,
                  itemBuilder: (ctx, i) {

                    if (i == provider.files.length && widget.showAddButton) {
                      return Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Center(
                              child: GestureDetector(
                                child: Icon(
                                  Icons.add_circle,
                                  color: options.customizationOptions.iconsColor,
                                  size: 128,
                                ),
                                onTap: (){
                                  Navigator.pop(context, null);
                                },
                              ),
                            ),
                          )
                      );
                    }

                    return itemCount <= 1 ? Container(
                      color: options.customizationOptions.bgColor,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: _getItemCard(i),
                    ) : _getItemCard(i);

                  }
              );

            }
        )
      ),
    );
  }
}