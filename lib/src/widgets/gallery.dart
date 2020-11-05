import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_picker/src/models/folder_model.dart';
import 'package:insta_picker/src/models/options_model.dart';
import 'package:insta_picker/src/providers/gallery_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

Options options;

class Gallery extends StatelessWidget {

  Gallery({@required Options galleryViewOptions}){ options = galleryViewOptions; }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GalleryProvider>(
      create: (_) => GalleryProvider(),
      child: GalleryView(),
    );
  }

}

class GalleryView extends StatefulWidget {
  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> with AutomaticKeepAliveClientMixin{
  GalleryProvider galleryProvider;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    galleryProvider =  Provider.of<GalleryProvider>(context, listen: false);
    galleryProvider.getImagesPath();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Consumer<GalleryProvider>(
            builder: (ctx, provider, child){

              return provider.folders != null ? DropdownButtonHideUnderline(
                  child: DropdownButton<FolderModel>(
                    items: provider.getItems(),
                    onChanged: (FolderModel folder) => provider.onFolderSelected(folder),
                    value: provider.selectedFolder,
                  )
              ) : Container();

            }
        ),
        leading: GestureDetector(
          child: Icon(
            Icons.clear,
            color: options.iconsColor,
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
                color: options.iconsColor,
              ),
            ),
            onTap: (){
              Navigator.pop(context, galleryProvider.image != null ? File(galleryProvider.image) : null);
            },
          )
        ],
        backgroundColor: options.appBarColor,
      ),
      body: SafeArea(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Consumer<GalleryProvider>(
                    builder: (ctx, provider, child){

                      return provider.image != null ?
                        Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width,
                          child: PhotoView(
                            imageProvider: FileImage(File(provider.image)),
                            backgroundDecoration: const BoxDecoration(color: Colors.white),
                          ),
                        ) : Container();

                    }
                ),
              ),
              Divider(),
              Consumer<GalleryProvider>(
                  builder: (ctx, provider, child){

                    return provider.selectedFolder != null && provider.selectedFolder.files.length > 0
                      ? Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.42,
                            child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4, crossAxisSpacing: 4, mainAxisSpacing: 4
                                ),
                                itemBuilder: (_, i) {
                                  var file = provider.selectedFolder.files[i];
                                  return file != null ? GestureDetector(
                                    child: Image.file(
                                      File(file),
                                      fit: BoxFit.cover,
                                    ),
                                    onTap: () {
                                      provider.image = file;
                                    },
                                  ) : Container();
                                },
                                itemCount: provider.selectedFolder.files.length
                        ),
                      ) : Container();

                  }
              ),
            ],
          )
      ),
    );
  }
}

