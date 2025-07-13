import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/core/constants/constants.dart';
import 'package:my_archives/features/home/domain/entities/archive_entity.dart';
import '../../../features/home/presentation/bloc/archive_bloc.dart';
import '../../../injection_container.dart';

class ArchivesGrid extends StatefulWidget {
  final List<Archive> archives;
  const ArchivesGrid({super.key, required this.archives});

  @override
  State<ArchivesGrid> createState() => _ArchivesGridState();
}

class _ArchivesGridState extends State<ArchivesGrid> {
  @override
  void initState() {
    super.initState();
    context.read<ArchiveBloc>().add(FetchArchivesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.archives.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => GridTile(
        // header: ClipRRect(borderRadius: BorderRadius.circular(10), child: Container(height: 100, decoration: BoxDecoration(color: Colors.grey),)),
        child: Card(
          elevation: 5,
          color: Colors.deepPurple.shade600,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/ArchiveDetailScreen', arguments: widget.archives[index]);
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('lib/assets/images/archive_cover.png', fit: BoxFit.cover, height: 250, width: 250),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.tealAccent.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      widget.archives[index].title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
