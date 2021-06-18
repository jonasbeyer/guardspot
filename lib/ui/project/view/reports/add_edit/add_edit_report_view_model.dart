import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/data/report/report_repository.dart';
import 'package:guardspot/models/report.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class AddEditReportViewModel extends ViewStateViewModel {
  BehaviorSubject<Report> initialReport = BehaviorSubject();
  BehaviorSubject<List<PlatformFile>> images = BehaviorSubject.seeded([]);

  ReportRepository _reportRepository;

  AddEditReportViewModel(this._reportRepository);

  void addImages(List<PlatformFile> files) {
    List<PlatformFile> currentImages = images.value!;
    currentImages.addAll(files);
    images.add(currentImages);
  }

  Future<void> submitReport(String message) async {
    Report report = initialReport.value!;
    List<MultipartFile>? files = images.value
        ?.map((f) => MultipartFile.fromBytes(f.bytes!, filename: f.name))
        .toList();

    Future<void> request = report.id != null
        ? _reportRepository.updateReport(report.projectId!, report.id!, message)
        : _reportRepository.createReport(
            report.projectId!,
            message,
            files: files,
          );

    emitLoading();
    try {
      await request;
      emitSuccess();
    } catch (e) {
      emitError("an_error_occurred");
    }
  }

  @override
  void dispose() {
    super.dispose();
    initialReport.close();
    images.close();
  }
}
