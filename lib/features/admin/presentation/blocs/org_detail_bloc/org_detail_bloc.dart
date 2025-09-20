import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hrms/core/config/local_storage_keys.dart';
import 'package:hrms/core/di/get_it.dart';
import 'package:hrms/core/services/shared_pref_service.dart';
import 'package:hrms/features/admin/domain/repositories/company_repository.dart';
import 'package:hrms/features/auth/data/models/company_model.dart';
import 'package:hrms/features/auth/domain/entities/company.dart';
import 'package:hrms/features/admin/domain/use_cases/store_company_details_usecase.dart';

part 'org_detail_event.dart';
part 'org_detail_state.dart';

class OrgDetailBloc extends Bloc<OrgDetailEvent, OrgDetailState> {
  final StoreCompanyDetailsUseCase storeCompanyDetailsUseCase =
      StoreCompanyDetailsUseCase(getIt<CompanyRepository>());

  OrgDetailBloc() : super(OrgDetailInitial()) {
    on<OrgDetailStoreEvent>((event, emit) async {
      emit(OrgDetailStoring());
      try {
        final res = await storeCompanyDetailsUseCase(event.company);
        final company = CompanyModel.fromJson(res['company_detail']);
        final prefs = getIt<SharedPrefService>();

        log(company.toJson().toString());

        await prefs.setString(LocalStorageKeys.companyName, company.companyName);
        await prefs.setString(LocalStorageKeys.companyId, company.companyId);
        await prefs.setString(LocalStorageKeys.companyLogo, company.logo ?? '');
        await prefs.setString(LocalStorageKeys.companyIndustry, company.industry ?? '');
        await prefs.setString(LocalStorageKeys.companySize, company.size ?? '');
        await prefs.setString(LocalStorageKeys.companyAddress, company.address ?? '');
        await prefs.setString(LocalStorageKeys.companyPhone, company.phone ?? '');
        await prefs.setString(LocalStorageKeys.companyTaxId, company.taxId ?? '');
        await prefs.setString(LocalStorageKeys.companyWebsite, company.website ?? '');
        await prefs.setString(LocalStorageKeys.countryCode, company.countryCode ?? '+91');
        await prefs.setString(LocalStorageKeys.phone, company.phone ?? '');
        emit(OrgDetailStored('Organization details stored successfully.'));
      } catch (e) {
        emit(OrgDetailError('Failed to store organization details.'));
      }
    });
  }
}
