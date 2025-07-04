
import 'package:dartz/dartz.dart';
import 'package:my_archives/features/home/domain/repositories/folder_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/archive_entity.dart';

class GetRelatedArchives{
  final FolderRepository repo;

  GetRelatedArchives({required this.repo});

  Future<Either<Failure, List<Archive>>> call(int folderId) async{
    return await repo.getFolderRelatedArchives(folderId);
  }
}