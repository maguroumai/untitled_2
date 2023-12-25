import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rxdart/subjects.dart';
import 'package:untitled_2/core/custom_hooks/use_refresh_controller.dart';
import 'package:untitled_2/core/router/router.dart';
import 'package:untitled_2/core/widgets/smart_refresher_custom.dart';
import 'package:untitled_2/features/todo/use_cases/task/my_task.dart';
import 'package:untitled_2/features/todo/widgets/task_item_tile.dart';

final jumpTopScrollProvider =
    Provider<PublishSubject<bool>>((ref) => PublishSubject());

class TaskTab extends HookConsumerWidget {
  const TaskTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final refreshController = useRefreshController();
    final isLoading = useState(false);

    final controller = ref.watch(myTaskControllerProvider.notifier);
    final asyncValue = ref.watch(myTaskControllerProvider);

    useEffect(
      () {
        StreamSubscription<bool>? jumpTopScrollDisposer;
        Future(() async {
          jumpTopScrollDisposer =
              ref.read(jumpTopScrollProvider).listen((value) {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
            }
          });
        });
        return () {
          jumpTopScrollDisposer?.cancel();
        };
      },
      const [],
    );

    return Scaffold(
      body: asyncValue.when(
        data: (items) {
          return SmartRefresher(
            header: const SmartRefreshHeader(),
            footer: const SmartRefreshFooter(),
            enablePullUp: true,
            scrollController: scrollController,
            controller: refreshController,
            physics: const BouncingScrollPhysics(),
            onRefresh: () {
              ref.invalidate(myTaskControllerProvider);
              refreshController.refreshCompleted();
            },
            onLoading: () async {
              await controller.fetchMore();
              refreshController.loadComplete();
            },
            child: items.isEmpty
                ? Center(
                    child: isLoading.value
                        ? const CupertinoActivityIndicator()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4)
                                .copyWith(bottom: 80),
                            child: const Text(
                              'やる事はまだありません',
                              textAlign: TextAlign.center,
                            ),
                          ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      final data = items[index];
                      return TaskItemTile(
                        // key: UniqueKey(),
                        data,
                        onTap: () {
                          EditTodoRouteData($extra: data).push(context);
                        },
                      );
                    },
                    itemCount: items.length,
                  ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        },
        loading: () => const Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
