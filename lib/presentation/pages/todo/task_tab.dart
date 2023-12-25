import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rxdart/subjects.dart';
import 'package:untitled_2/model/use_cases/task/my_task.dart';
import 'package:untitled_2/presentation/pages/todo/edit_todo_task_page.dart';
import 'package:untitled_2/presentation/widgets/smart_refresher_custom.dart';
import 'package:untitled_2/presentation/widgets/task_item_tile.dart';

final jumpTopScrollProvider =
    Provider<PublishSubject<bool>>((ref) => PublishSubject());

class TaskTab extends StatefulHookConsumerWidget {
  const TaskTab({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<TaskTab> createState() => _State();
}

class _State extends ConsumerState<TaskTab>
    with AutomaticKeepAliveClientMixin<TaskTab> {
  @override
  bool get wantKeepAlive => true;

  final _refreshController = RefreshController();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isLoading = useState(false);
    final items = ref.watch(myTaskProvider);
    useEffect(
      () {
        StreamSubscription<bool>? jumpTopScrollDisposer;
        Future(() async {
          jumpTopScrollDisposer =
              ref.read(jumpTopScrollProvider).listen((value) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
            }
          });
          isLoading.value = true;
          await ref.read(myTaskProvider.notifier).fetch();
          isLoading.value = false;
        });
        return () {
          jumpTopScrollDisposer?.cancel();
        };
      },
      const [],
    );

    return Scaffold(
      body: Scrollbar(
        controller: _scrollController,
        child: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: true,
          header: const SmartRefreshHeader(),
          footer: const SmartRefreshFooter(),
          onRefresh: () async {
            isLoading.value = true;
            await ref.read(myTaskProvider.notifier).fetch();
            isLoading.value = false;
            _refreshController.refreshCompleted();
          },
          onLoading: () async {
            isLoading.value = true;
            await ref.read(myTaskProvider.notifier).fetchMore();
            isLoading.value = false;
            _refreshController.loadComplete();
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
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    final data = items[index];
                    return TaskItemTile(
                      // key: UniqueKey(),
                      data,
                      onTap: () async {
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditTodoTaskPage(
                                    data: data,
                                  )),
                        );
                      },
                    );
                  },
                  itemCount: items.length,
                ),
        ),
      ),
    );
  }
}
