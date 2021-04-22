import 'dart:convert';
import 'dart:developer';

import 'package:fire_notifications_new/data/dtos/account_dto.dart';
import 'package:fire_notifications_new/data/dtos/objects_request_dto.dart';
import 'package:fire_notifications_new/data/utils/wsdl_helper.dart';
import 'package:fire_notifications_new/domain/services/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

class DataUserService implements UserService {
  static DataUserService _instance = DataUserService._internal();
  DataUserService._internal();
  factory DataUserService() => _instance;

  @override
  Future<void> authenticate(
      {required String url, required String username, required String password}) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    String sourceString = "$username:$password";
    var bytes = utf8.encode(sourceString);
    var encoded = base64.encode(bytes);

    String accountStr = '$url@@$encoded@@$username';

    List<String>? existing = preferences.getStringList('accounts');

    if (existing == null) {
      existing = [accountStr];
    } else {
      dynamic accountIsExists = existing.contains(accountStr);
      if (accountIsExists) {
        throw new Exception('Данный источник был подключен ранее');
      }

      existing.add(accountStr);
    }

    preferences.setStringList('accounts', existing);

    try {
      await WSDLHelper(endpoint: url, token: encoded).post(new ObjectsRequestDto().toXml(), 'GetObjects');
      preferences.setBool('isAuth', true);
    } catch (e, stacktrace) {
      throw e;
    }
  }

  static Future<List<AccountDto>> getAccounts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    List<String>? accounts = preferences.getStringList('accounts');
    if (accounts == null) return [];

    List<AccountDto> result = [];
    for (final acc in accounts) {
      dynamic arr = acc.split('@@');
      result.add(new AccountDto(url: arr[0], token: arr[1], name: arr[2] ?? null));
    }

    return result;
  }

  static Future<List<AccountDto>> removeAccount(AccountDto account) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<AccountDto> accounts = await DataUserService.getAccounts();
    accounts.removeWhere((element) => element.token == account.token);

    await preferences.setStringList('accounts', accounts.map((e) => '${e.url}@@${e.token}@@${e.name}').toList());

    List<AccountDto> newAccountsList = await DataUserService.getAccounts();
    return newAccountsList;
  }

  @override
  Future<bool> isAuthenticated() async {
    List<dynamic> accs = await DataUserService.getAccounts();
    return accs.isNotEmpty;
  }
}
