
import '../constants/constants.dart';

String statusToString(TableChangeStatus status) {
  switch (status) {
    case TableChangeStatus.created:
      return 'Created';
    case TableChangeStatus.modified:
      return 'Modified';
    case TableChangeStatus.deleted:
      return 'Deleted';
  }
}