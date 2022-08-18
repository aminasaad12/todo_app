import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constants/my_colors.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget FieldWidget({
  TextEditingController? controller,
  required TextInputType  type,
  String? hintText,
  String? labelText,
  required IconData iconData,
  required String? Function(String?)? validate,
  String? Function(String?)?onChanged ,
  String? Function(String?)?onFieldSubmitted ,
  VoidCallback? ontap ,
  IconData? suffixIcon,
  VoidCallback? onPressedfun,
  bool obscureText = false,
  bool isenabled=true,


})=> Container(
  child:TextFormField(
    controller:controller,
    keyboardType:type,
    onChanged: onChanged,
    onFieldSubmitted:onFieldSubmitted,
    validator: validate,
    obscureText:obscureText,
    onTap: ontap,
    enabled:isenabled ,
    style: TextStyle(color: green),
    cursorColor: green,
    decoration: InputDecoration(
        hintText:hintText,
        hintStyle: new TextStyle(
          color: green,
        ),
        labelText:labelText,
        labelStyle: new TextStyle(
          color: const Color(0xFF424242),
        ),
        border:OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        focusedBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide:
          BorderSide(
              color: green,width: 1),
        ),
        prefixIcon: Icon(
          iconData,
          color: Colors.grey,
        ),
        suffixIcon: IconButton(
          onPressed:onPressedfun,
          icon: Icon(
            suffixIcon,
            color: Colors.grey,
          ),
        )
    ),
  ),
);

Widget tasksmodelscreen(Map model,context) =>Dismissible(
  key: Key (model['id'].toString()),
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: green,
            radius: 45.0,
            child: Text(
             '${model['time']}' ,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: white
                ),
            ),
          ) ,
          SizedBox(
            width: 13.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                 '${model['title']}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    color: grey,
                  ),),
  
  
              ],
            ),
          ),
          SizedBox(
            width: 13.0,
          ),
          IconButton(
              onPressed: ()
              {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
              icon:Icon(
                  Icons.check_box,
                color: grey,
  
              ) ),
          IconButton(
              onPressed: ()
              {
                AppCubit.get(context).updateData(
                  status: 'archived',
                  id: model['id'],
                );
              },
              icon:Icon(
                  Icons.archive,
                color: grey,
              ) ),
  
        ],
      ),
    ),
  ),
  onDismissed: (dirction)
  {
AppCubit.get(context).deleteData(id:model['id'] );
  },
);

Widget noitemshow({

  required List<Map> tasks,

}) =>ConditionalBuilder(

  condition: tasks.length>0,
  fallback: (BuildContext context) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              color: grey,
              size: 44.0,),
            Text(
              'no item ,please add some item',
              style: TextStyle(
                fontSize: 18.0,
                color: grey,
              ),
            ),
          ],
        ),
      ),
  builder: (BuildContext context) {
    return ListView.separated(
        itemBuilder: (context,index) =>tasksmodelscreen(tasks[index],context),

        separatorBuilder: (context,index) => Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: Container(
            height: 1.0,
            color: grey,
          ),
        ),
        itemCount: tasks.length);
  },

);