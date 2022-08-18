
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/model_bottomsheet.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class Archived_Screen extends StatelessWidget {
  const Archived_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, AppStates state){
      },
      builder: (BuildContext context, AppStates state){
        var tasks = AppCubit.get(context).archiveTasks;

        return noitemshow(
            tasks: tasks);
      },

    );
  }
}
