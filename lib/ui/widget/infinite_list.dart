import 'package:dosomething/business_logic/view_model/infinite_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'error_message.dart';

class InfiniteList<T extends InfiniteListViewModel<E>, E> extends StatefulWidget {
  final ItemWidgetBuilder<E> itemBuilder;
  final String noItemsFoundMessage;
  final double separatorHeight;

  const InfiniteList({
    Key? key,
    required this.itemBuilder,
    this.noItemsFoundMessage = 'No Items',
    this.separatorHeight = 16.0,
  }) : super(key: key);

  @override
  _InfiniteListState createState() => _InfiniteListState<T,E>();
}

class _InfiniteListState<ViewModelType extends InfiniteListViewModel<PageItemType>, PageItemType> extends State<InfiniteList<ViewModelType, PageItemType>> {
  late final ViewModelType _model;
  final _pagingController = PagingController<String?, PageItemType>(
    firstPageKey: null,
  );

  @override
  void initState() {
    super.initState();
    _model = Provider.of<ViewModelType>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(String? pageKey) async {
    print('Fetching page $pageKey');
    try {
      final newPage = await _model.loadNext(pageKey);

      final isLastPage = newPage.nextPageKey == null;
      final newItems = newPage.itemList;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = newPage.nextPageKey;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error, s) {
      print(s);
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
      ),
      child: PagedListView.separated(
        pagingController: _pagingController,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => SizedBox(
          height: widget.separatorHeight,
        ),
        builderDelegate: PagedChildBuilderDelegate<PageItemType>(
          itemBuilder: widget.itemBuilder,
          firstPageErrorIndicatorBuilder: (context) => ErrorMessage(
            message:_pagingController.error.toString(),
          ),
          noItemsFoundIndicatorBuilder: (context) => Column(
            children: [
              Center(
                child: Text(widget.noItemsFoundMessage),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
