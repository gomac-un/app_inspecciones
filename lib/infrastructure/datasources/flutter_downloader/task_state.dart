import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_state.freezed.dart';

@freezed
class TaskState with _$TaskState {
  factory TaskState({
    required String id,
    required DownloadTaskStatus status,
    required int progress,
  }) = _Task;
}
