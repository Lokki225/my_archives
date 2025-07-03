import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/home/domain/entities/folder_entity.dart';
import '../../../features/home/presentation/bloc/folder_bloc.dart';
import '../../../injection_container.dart';
import 'view_folders_widget.dart';

class FoldersHorizontalSelector extends StatefulWidget {
  final List<Folder> folders;
  const FoldersHorizontalSelector({super.key, required this.folders});

  @override
  State<FoldersHorizontalSelector> createState() => _FoldersHorizontalSelectorState();
}

class _FoldersHorizontalSelectorState extends State<FoldersHorizontalSelector> {
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: EdgeInsets.all(5),
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.deepPurple),
        child: Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            ViewFoldersWidget(),
            ...(
                widget.folders.map(
                        (folder) => Container(
                      height: 100,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurple.shade200,
                          boxShadow: [
                            BoxShadow(
                              color: folder.getColorFromHexaString(folder.color).withAlpha(75),
                              spreadRadius: 5,
                            )
                          ]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Center(child: Image.asset(
                            'lib/assets/images/folder_cover.png',
                            width: 40,
                            height: 40,
                          ),),
                          Text(folder.title, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                )
            )
          ],
        ),
      ),
    );
  }
}
