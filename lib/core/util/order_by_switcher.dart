
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/core/constants/constants.dart';

import '../../features/home/presentation/bloc/archive_bloc.dart';

void orderBySwitcher(String selectedOption, BuildContext context) {
  switch (selectedOption) {
    case 'All':
      context.read<ArchiveBloc>().add(FetchArchivesEvent(sortOption: SortingOption.all));
      break;
    case 'Last Added':
      context.read<ArchiveBloc>().add(FetchArchivesEvent(sortOption: SortingOption.lastAddedFirst));
      break;
    case 'Last Updated':
      context.read<ArchiveBloc>().add(FetchArchivesEvent(sortOption: SortingOption.lastUpdatedFirst));
      break;
    case 'Title Asc':
      context.read<ArchiveBloc>().add(FetchArchivesEvent(sortOption: SortingOption.titleAZ));
      break;
    case 'Title Desc':
      context.read<ArchiveBloc>().add(FetchArchivesEvent(sortOption: SortingOption.titleZA));
      break;
  }
}