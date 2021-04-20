/*mport 'package:flutter/material.dart';
import 'package:zaanassh/services/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatefulWidget {
  final bool fromProfilePage;
  ProfilePicture({@required this.fromProfilePage});
  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  Future<File> profileImage;
  Image image;
  //pick an image
  pickImage(ImageSource source) {
    setState(() {
     PickedFile profileImage = ImagePicker.getImage(source: source);
    });
    if (profileImage != null) {
      loadImageFromPreferences();
    }
  }

  loadImageFromPreferences() {
    SharedPrefferencesServices().getImageFromPreferences().then((value) {
      if (value == null) {
        return null;
      } else {
        setState(() {
          image = SharedPrefferencesServices().imageFromBase64String(value);
        });
      }
    });
  }

  Widget imageFormGallery() {
    return FutureBuilder(
        future: profileImage,
        builder: (context, AsyncSnapshot<File> snapshot) {
          print("Snap data is $snapshot");
          if (snapshot.data == null) {
            return Container(
              width: MediaQuery.of(context).size.width / 3.5,
              height: MediaQuery.of(context).size.height / 5.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    "https://www.dpair.com/wp-content/uploads/2017/03/Facebook-Blank-Photo.jpg",
                  ),
                ),
              ),
              child: Text("Pick an image from gallery.Tap here.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.amber[900])),
              alignment: Alignment.center,
            );
          }
          SharedPrefferencesServices.saveImageToPrefferences(
              SharedPrefferencesServices()
                  .base64String(snapshot.data.readAsBytesSync()));
          return Image.file(snapshot.data);
        });
  }

  @override
  void initState() {
    loadImageFromPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.fromProfilePage)
        ? Positioned(
            top: MediaQuery.of(context).size.width / 7,
            right: MediaQuery.of(context).size.width / 3.2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () async {
                    pickImage(ImageSource.gallery);
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      height: MediaQuery.of(context).size.height / 5.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                      ),
                      child: (image == null) ? imageFormGallery() : image),
                )
              ],
            ),
          )
        : CircleAvatar(
            radius: MediaQuery.of(context).size.width / 5.5,
            backgroundColor: Colors.grey[500].withOpacity(0.5),
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width / 6,
              child: ClipOval(
                child: Container(
                  child: MaterialButton(
                    onPressed: () async {
                      pickImage(ImageSource.gallery);
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        height: MediaQuery.of(context).size.height / 5.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            25.0,
                          ),
                        ),
                        child: (image == null) ? imageFormGallery() : image),
                  ),
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.width / 3,
                ),
              ),
            ),
          );
  }
}
*-*/
