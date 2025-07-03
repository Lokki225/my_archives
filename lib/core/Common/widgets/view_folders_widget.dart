import 'package:flutter/material.dart';

class ViewFoldersWidget extends StatefulWidget {
  const ViewFoldersWidget({super.key});

  @override
  State<ViewFoldersWidget> createState() => _ViewFolderState();
}

class _ViewFolderState extends State<ViewFoldersWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        // redirect to new folder screen
        await Navigator.pushNamed(context, '/FoldersScreen');
      },
      child: Container(
        height: 100,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.tealAccent.shade700,
          boxShadow: [
            BoxShadow(
              color: Colors.tealAccent.withAlpha(50),
              spreadRadius: 5,
            )
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Center(child: Icon(Icons.remove_red_eye_rounded, size: 30, color: Theme.of(context).primaryColor),),
            Text("View All", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
