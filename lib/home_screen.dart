

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

import 'constants/my_colors.dart';
import 'models/model_bottomsheet.dart';

class Home_Screen extends StatelessWidget
{
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formkey=GlobalKey<FormState>();
  var tittlecontroller=TextEditingController();
  var timecontroller=TextEditingController();
  var dateController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child:  BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, AppStates state) {

          if( state is AppinsertDataBase)
          {
            Navigator.pop(context);
          }

        },

        builder: (BuildContext context,AppStates state)
        {
          AppCubit cubit=  AppCubit.get(context);
          return  Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[  cubit.currentIndexx],
              ),

            ),
            //cubit.screens[cubit.currentIndexx],
            body:
            ConditionalBuilder(
              condition: state is! AppgetDataLoadingmDatabase,
              builder: (context) =>  cubit.screens[ cubit.currentIndexx],
              fallback: (context) =>Center(child:  CircularProgressIndicator()) ,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed:()
              {
                if(cubit.isBottomSheetShow){
                  if(formkey.currentState!.validate())
                  {
                    cubit.insertDataBase(
                        title: tittlecontroller.text,
                        time: timecontroller.text,
                        date: dateController.text
                    );
                  }
                }
                else{
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                      color: grey,
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FieldWidget(
                                controller:tittlecontroller,
                                validate: (String? value)
                                {
                                  if(value!.isEmpty){
                                    return'title must be not empty';
                                  }
                                  return null;
                                },
                                type:TextInputType.text ,
                                iconData:Icons.title,
                                labelText:'Task Title',
                              ),
                              SizedBox(
                                height: 14.0,
                              ),
                              FieldWidget(
                                controller:timecontroller,
                                validate: (String? value)
                                {
                                  if(value!.isEmpty){
                                    return'time must be not empty';
                                  }
                                  return null;
                                },
                                ontap: () {
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                      .then((value){
                                    timecontroller.text=value!.format(context).toString();
                                    print(value.format(context));
                                  });
                                },
                                type:TextInputType.datetime ,
                                iconData:Icons.watch_later,
                                labelText:'Task Time',
                              ),
                              SizedBox(
                                height: 14.0,
                              ),
                              FieldWidget(
                                controller:dateController,
                                iconData: Icons.date_range,
                                type: TextInputType.datetime,
                                labelText: "Date",
                                ontap: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate:DateTime.now() ,
                                      firstDate: DateTime(2010),
                                      lastDate:DateTime(2025))
                                      .then((value){
                                    dateController.text=DateFormat.yMMMd().format(value!);
                                  });
                                },
                                validate:(value)
                                {
                                  if (value == null || value.isEmpty)
                                  {
                                    return'Date Title must not  be empty';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    elevation: 20.0,
                    backgroundColor: Colors.white60,
                  ).closed.then((value) {
                    cubit.changeisBottomSheetShow(
                        isBtmSheetShow:false ,
                        icon: Icons.edit);

                  });
                  cubit.changeisBottomSheetShow(
                      isBtmSheetShow:true ,
                      icon: Icons.add);
                  tittlecontroller.clear();
                  timecontroller.clear();
                  dateController.clear();

                }
              },
              child:  Icon(
                cubit.iconData,
              ),
            ),
            bottomNavigationBar:BottomNavigationBar(
              type:BottomNavigationBarType.fixed,
              currentIndex:   cubit.currentIndexx ,
              onTap: (index)
              {
                AppCubit.get(context).changeIndex(index);
              },
              items:
              const [
                BottomNavigationBarItem(
                    icon:Icon(
                        Icons.list),
                    label: 'Tasks'),
                BottomNavigationBarItem(
                    icon:Icon(
                        Icons.check_circle_outline),
                    label: 'Done'),
                BottomNavigationBarItem(
                    icon:Icon(
                        Icons.archive),
                    label: 'Archived'),
              ],

            ) ,
          );
        },

      ),
    );
  }
  // Future<String> getName()async
  // {
  //   return "Amina";
  // }


}
