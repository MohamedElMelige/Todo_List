
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';
import 'package:to_do_list/shared/cubit/states.dart';

Widget defultFormField({
  required TextEditingController controller,
  required TextInputType type,
  var onSubmit,
  var onChange,
  required var validat,
  required String label,
  required IconData prefix,
  var onTap,
  IconData? suffix,
  bool isPassword = false,
  bool isClickable = true,
}) =>
    TextFormField(
      onTap: onTap,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      controller: controller,
      validator: validat,
      enabled: isClickable,
      obscureText: isPassword,
      decoration: InputDecoration(
        suffix: suffix != null ? Icon(suffix) : null,
        labelText: label,
        border: OutlineInputBorder(),
        prefix: Icon(prefix),
      ),
      keyboardType: type,
    );

Widget biuldTaskItem(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id:  model['id']);
  },
  child:   Padding(
  
        padding: const EdgeInsets.all(20.0),
  
        child: Row(
  
          children: [
  
            CircleAvatar(
  
              radius: 40,
  
              child: Text('${model['time']}'),
  
            ),
  
            SizedBox(
  
              width: 20,
  
            ),
  
            Expanded(
  
              child: Column(
  
                mainAxisSize: MainAxisSize.min,
  
                children: [
  
                  Text(
  
                    '${model['title']}',
  
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  
                  ),
  
                  Text('${model['date']}',
  
                      style: TextStyle(
  
                        color: Colors.grey,
  
                      )),
  
                ],
  
              ),
  
            ),
  
            SizedBox(
  
              width: 20,
  
            ),
  
            IconButton(
  
                onPressed: () {
  
                  AppCubit.get(context).updateData(status: 'done', id: model['id']);
  
                },
  
                icon: Icon(
  
                  Icons.check_box,
  
                  color: Colors.green,
  
                )),
  
            IconButton(
  
                onPressed: () {
  
                  AppCubit.get(context).updateData(status: 'archive', id: model['id']);
  
                },
  
                icon: Icon(
  
                  Icons.archive,
  
                  color: Colors.black45,
  
                )),
  
          ],
  
        ),
  
      ),
);

Widget tasksBuilder({required List<Map> tasks})=> ConditionalBuilder(
  condition: tasks.length > 0  ,
  builder:(context)=> BlocConsumer<AppCubit, AppStates>(
    builder: (BuildContext context, state) {
      return ListView.separated(
          itemBuilder: (context, index) =>
              biuldTaskItem(tasks[index],context),
          separatorBuilder: (context, index) => Container(
            width: double.infinity,
            height: 1,
          ),
          itemCount: tasks.length);
    },
    listener: (BuildContext context, Object? state) {},
  ),
  fallback: (context)=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,size: 100,color: Colors.black45,),
        Text('No Tasks Yet, Please Add Some Tasks',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
      ],
    ),
  ),
);
