import 'dart:developer';

import 'package:fire_notifications_new/app/pages/detail/detail_presenter.dart';
import 'package:fire_notifications_new/app/pages/pages.dart';
import 'package:fire_notifications_new/domain/entities/notification.dart' as C;
import 'package:fire_notifications_new/domain/services/objects_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class DetailController extends Controller {
  DetailPresenter _detailPresenter;

  late PageController pageController;
  int currentPageIndex = 0;

  DetailController(ObjectsService objectsService)
      : _detailPresenter = DetailPresenter(objectsService),
        pageController = PageController() {
    initListeners();
  }

  @override
  void initListeners() {
    _detailPresenter.ackOnComplete = this.ackOnComplete;

    _detailPresenter.ackOnError = (e) {
      print(e);
    };

    pageController.addListener(() {
      if (pageController.page!.round() != currentPageIndex) {
        currentPageIndex = pageController.page!.round();
        refreshUI();
      }
    });
  }

  void ack(objId, account) => _detailPresenter.sendAck(objId, account);

  void ackOnComplete() {
    refreshUI();
    Navigator.of(getContext()).pushNamed(Pages.notificationScreen);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    currentPageIndex = 0;
  }
}
