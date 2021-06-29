import 'package:dosomething/service/web_api_implementation.dart';
import 'package:flutter/material.dart';

enum ViewModelStatus {
  idle, busy, error
}

class AbstractViewModel extends ChangeNotifier {
  ViewModelStatus status = ViewModelStatus.idle;

  void setStatus(ViewModelStatus status) {
    this.status = status;

    notifyListeners();
  }
}