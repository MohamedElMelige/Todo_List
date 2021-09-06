import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/shared/componants/componants.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';
import 'package:to_do_list/shared/cubit/states.dart';

class Tasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tasks=AppCubit.get(context).newTasks;
    return  BlocConsumer<AppCubit, AppStates>(
        builder: (BuildContext context, state) {
          return tasksBuilder(tasks: tasks);
        },
        listener: (BuildContext context, Object? state) {},
      );
  }
}
