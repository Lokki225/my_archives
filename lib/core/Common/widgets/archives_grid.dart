import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/core/constants/constants.dart';
import '../../../features/home/presentation/bloc/archive_bloc.dart';
import '../../../injection_container.dart';

class ArchivesGrid extends StatefulWidget {
  final BuildContext homeContext;
  const ArchivesGrid({super.key, required this.homeContext});

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
    return BlocListener<ArchiveBloc, ArchiveState>(
      listener: (BuildContext context, ArchiveState state) {
        if (state is ArchiveError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
          context.read<ArchiveBloc>().add(ResetArchiveToInitialStateEvent());
        }
        if (state is ArchiveInitial) {
          context.read<ArchiveBloc>().add(FetchArchivesEvent());
        }
      },
      child: BlocBuilder<ArchiveBloc, ArchiveState>(
        builder: (context, ArchiveState state) {
          if(state is ArchiveLoading){
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if(state is ArchiveLoaded && state.archives.isNotEmpty){
            return GridView.builder(
              shrinkWrap: true,
              itemCount: state.archives.length,
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
                      Navigator.pushNamed(context, '/ArchiveDetailScreen', arguments: state.archives[index]);
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
                              state.archives[index].title,
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

          if (state is ArchiveLoaded && state.archives.isEmpty){
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  'You have no created any archive yet !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                  )
                )
              )
            );
          }

          return Container();
        }
      ),
    );
  }
}
