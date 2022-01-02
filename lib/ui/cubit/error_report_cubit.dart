// Copyright (C) 2022 Yaroslav Pronin <proninyaroslav@mail.ru>
//
// This file is part of Blink Comparison.
//
// Blink Comparison is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Blink Comparison is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Blink Comparison.  If not, see <http://www.gnu.org/licenses/>.

import 'package:blink_comparison/core/crash_report/crash_report_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'error_report_cubit.freezed.dart';

@freezed
class ErrorReportState with _$ErrorReportState {
  const factory ErrorReportState.initial() = ErrorReportStateInitial;

  const factory ErrorReportState.inProgress() = ErrorReportStateInProgress;

  const factory ErrorReportState.success() = ErrorReportStateSuccess;

  const factory ErrorReportState.emailUnsupported() =
      ErrorReportStateEmailUnsupported;
}

@injectable
class ErrorReportCubit extends Cubit<ErrorReportState> {
  final CrashReportManager _reportManager;

  ErrorReportCubit(this._reportManager)
      : super(const ErrorReportState.initial());

  Future<void> sendReport({
    required Object error,
    StackTrace? stackTrace,
    String? message,
  }) async {
    emit(const ErrorReportState.inProgress());
    final res = await _reportManager.sendReport(
      CrashInfo(
        error: error,
        stackTrace: stackTrace,
        message: message,
      ),
    );
    emit(
      res.when(
        success: () => const ErrorReportState.success(),
        emailUnsupported: () => const ErrorReportState.emailUnsupported(),
      ),
    );
  }
}
