import 'package:unknown_note_flutter/enums/enum_emotion.dart';
import 'package:unknown_note_flutter/mixins/mock_throw_exception_mixin.dart';
import 'package:unknown_note_flutter/models/diary/diary_model.dart';
import 'package:unknown_note_flutter/models/res/res_model.dart';
import 'package:unknown_note_flutter/repository/interface/interface_dude_diary_repository.dart';

class MockDudeDiaryRepository
    with MockThrowExceptionMixin
    implements IDudeDiaryRepository {
  final int delay;
  final int? errorCode;

  MockDudeDiaryRepository({
    this.delay = 1000,
    this.errorCode,
  });

  @override
  Future<ResModel<DiaryModel>> getDiary({
    required EEmotion emotion,
    required int page,
  }) async {
    await Future.delayed(Duration(milliseconds: delay));

    return mockedResponse<ResModel<DiaryModel>>(
      () {
        var resTmp = ResModel<DiaryModel>(
          code: 1000,
          data: DiaryModel(
            id: page,
            content: 'diary $page',
            isOpen: true,
            emotion: emotion,
            time: DateTime.now(),
            userId: 1,
          ),
        ).toJson(
          (diary) => diary.toJson(),
        );

        var resModel = ResModel<DiaryModel>.fromJson(
          resTmp,
          (json) => DiaryModel.fromJson(json),
        );

        return resModel;
      },
      errorCode: errorCode,
    );
  }

  @override
  Future<ResModel<List<DiaryModel>>> getDiaryCal({
    required int year,
    required int month,
  }) async {
    await Future.delayed(Duration(milliseconds: delay));

    return mockedResponse<ResModel<List<DiaryModel>>>(
      () {
        var resTmp = ResModel<List<DiaryModel>>(
          code: 1000,
          data: [
            DiaryModel(
              id: 1,
              content: 'diary 1',
              isOpen: true,
              emotion: EEmotion.happy,
              time: DateTime(year, month, 1, 13, 09),
              userId: 1,
            ),
            DiaryModel(
              id: 2,
              content: 'diary 2',
              isOpen: true,
              emotion: EEmotion.sad,
              time: DateTime(year, month, 9, 13, 09),
              userId: 2,
            ),
            DiaryModel(
              id: 3,
              content: 'diary 3',
              isOpen: true,
              emotion: EEmotion.love,
              time: DateTime(year, month, 21, 13, 09),
              userId: 3,
            ),
          ],
        ).toJson(
          (diaryList) => diaryList.map((diary) => diary.toJson()).toList(),
        );

        var res = ResModel<List<DiaryModel>>.fromJson(
          resTmp,
          (json) => (json as List<dynamic>)
              .map((diary) => DiaryModel.fromJson(diary))
              .toList(),
        );

        return res;
      },
      errorCode: errorCode,
    );
  }

  @override
  Future<ResModel<void>> postDiary({
    required DiaryModel diary,
  }) async {
    await Future.delayed(Duration(milliseconds: delay));

    return mockedResponse<ResModel<void>>(
      () {
        var resTmp = ResModel<void>(code: 1000).toJson((p0) => null);

        var res = ResModel<void>.fromJson(resTmp, (json) {});

        return res;
      },
      errorCode: errorCode,
    );
  }

  @override
  Future<ResModel<void>> patchDiary({
    required DiaryModel diary,
  }) async {
    await Future.delayed(Duration(milliseconds: delay));

    return mockedResponse<ResModel<void>>(
      () {
        var resTmp = ResModel<void>(code: 1000).toJson((p0) => null);

        var res = ResModel<void>.fromJson(resTmp, (json) {});

        return res;
      },
      errorCode: errorCode,
    );
  }
}
