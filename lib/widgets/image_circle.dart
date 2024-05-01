import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mi_trabajo/utils/colors.dart';
import 'package:mi_trabajo/providers/global_variables_provider.dart';
import 'package:mi_trabajo/services/media_service.dart';

class ImageCircle extends StatefulWidget {
  final String imagePath;
  final bool isRegister;
  const ImageCircle(
      {super.key, required this.imagePath, required this.isRegister});

  @override
  State<ImageCircle> createState() => _ImageCircleState();
}

class _ImageCircleState extends State<ImageCircle> {
  File? image;

  @override
  void dispose() {
    GlobalVariables.instance.disposeTemporalImage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async {
          File? imageFile = await MediaService.instance.getImageFromLibrary();
          setState(() {
            image = imageFile!;
            GlobalVariables.instance.setTemporalImage(image);
          });
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: deviceHeight * 0.22,
                width: deviceHeight * 0.22,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(500),
                    border: Border.all(
                      color: Colores.morado,
                      width: 6,
                    ),
                    image: widget.isRegister
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: image != null
                                ? FileImage(image!) as ImageProvider
                                //: NetworkImage(widget.userData.image))),
                                : AssetImage(widget.imagePath),
                          )
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: image != null
                                ? FileImage(image!) as ImageProvider
                                //: NetworkImage(widget.userData.image))),
                                : NetworkImage(widget.imagePath),
                          )),
              ),
              const Icon(
                Icons.add_a_photo_outlined,
                color: Colores.morado,
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
