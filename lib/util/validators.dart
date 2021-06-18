import 'package:flutter/material.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:validators2/validators.dart';

String? notEmptyValidator(String value, BuildContext context) =>
    value.isEmpty ? context.getString("missing_value") : null;

String? emailValidator(String value, BuildContext context) =>
    isEmail(value) ? null : context.getString("invalid_email");

String? passwordValidator(String value, BuildContext context) =>
    isLength(value, 6) ? null : context.getString("user_password_requirement");
