import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/shared/componants/componants.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';
import 'package:to_do_list/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {
          if (state is InsertDatabaseState) {
            Navigator.pop(context);
          }  
        },
        builder: (BuildContext context, Object? state) => Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(AppCubit.get(context)
                .appbar[AppCubit.get(context).currentIndex]),
            centerTitle: true,
          ),
          body: ConditionalBuilder(
            condition: state is! GetLoadingDatabaseState,
            builder: (context)=>AppCubit.get(context).screen[AppCubit.get(context).currentIndex],
            fallback: (context)=>Center(child: CircularProgressIndicator(),),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (AppCubit.get(context).togle) {
                if (formKey.currentState!.validate()) {
                  AppCubit.get(context).insertToDatabase(title: titleController.text, time: timeController.text, date: dateController.text);
                }
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet((BuildContext context) {
                      return Container(
                        width: double.infinity,
                        height: 360,
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defultFormField(
                                  prefix: Icons.title,
                                  controller: titleController,
                                  label: 'Task Title',
                                  type: TextInputType.text,
                                  validat: (val) {
                                    if (val!.isEmpty) {
                                      return 'Title is empty';
                                    } else {
                                      return null;
                                    }
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                              defultFormField(
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context);
                                      print(value.format(context));
                                    });
                                  },
                                  prefix: Icons.watch_later_outlined,
                                  controller: timeController,
                                  label: 'Task Time',
                                  type: TextInputType.datetime,
                                  validat: (val) {
                                    if (val!.isEmpty) {
                                      return 'Time is empty';
                                    } else {
                                      return null;
                                    }
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                              defultFormField(
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2021-10-01'))
                                        .then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                      print(DateFormat.yMMMd().format(value));
                                    });
                                  },
                                  prefix: Icons.calendar_today,
                                  controller: dateController,
                                  label: 'Task Date',
                                  type: TextInputType.datetime,
                                  validat: (val) {
                                    if (val!.isEmpty) {
                                      return 'Date is empty';
                                    } else {
                                      return null;
                                    }
                                  }),
                            ],
                          ),
                        ),
                      );
                    })
                    .closed
                    .then((value) {
                      AppCubit.get(context)
                          .changeIconState(isShow: false, icon: Icons.edit);
                    });
                AppCubit.get(context)
                    .changeIconState(isShow: true, icon: Icons.add);
              }
            },
            child: Icon(AppCubit.get(context).febIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: AppCubit.get(context).currentIndex,
            onTap: (index) {
              AppCubit.get(context).changeIndex(index);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive), label: 'Archived'),
            ],
          ),
        ),
      ),
    );
  }

  void deleteDatabase() {}
}

