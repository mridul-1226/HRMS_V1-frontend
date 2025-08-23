import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/core/routes/auth_routes.dart';
import 'package:hrms/core/services/secure_storage_service.dart';
import 'package:hrms/features/auth/domain/entities/company.dart';

part 'org_detail_event.dart';
part 'org_detail_state.dart';

class OrgDetailBloc extends Bloc<OrgDetailEvent, OrgDetailState> {
  OrgDetailBloc() : super(OrgDetailInitial()) {
    on<OrgDetailStoreEvent>((event, emit) async {
      emit(OrgDetailStoring());
      try {
        final securedStorage = getIt<SecureStorageService>();
        final endpoint =
            '${dotenv.env['BASE_URL']}${AuthRoutes.companyDetails}';
        final token = await securedStorage.readData(LocalStorageKeys.token);
        final res = await Dio().post(
          endpoint,
          data: {
            'ownerName': event.company.companyName,
            'email': event.company.email,
            'industry': event.company.industry,
            'size': event.company.size,
            'address': event.company.address,
            'countryCode': event.company.countryCode,
            'phone': event.company.phone,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        if(res.statusCode != 200) {
          throw Exception('Failed to store organization details: ${res.data}');
        }

        if(res.data['success'] != true) {
          throw Exception(res.data['error'] ?? 'Unknown error occurred');
        }

        log(res.data.toString());
        emit(OrgDetailStored('Organization details stored successfully.'));
      } catch (e) {
        emit(OrgDetailError('Failed to store organization details.'));
      }
    });
  }
}
