
  import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modeules/archived_screen.dart';
import 'package:todo_app/modeules/done_screen.dart';
import 'package:todo_app/modeules/tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>

{
  AppCubit() : super(initialState());
  static AppCubit get(context) =>BlocProvider.of(context);

  int currentIndexx =0;
  List<Widget>screens=
  [
    Tasks_Screen(),
    Done_Screen(),
    Archived_Screen(),
  ];
  List<String>titles=
  [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index )
  {
    currentIndexx=index;
    emit(AppChangeBottomNavigationBar());
  }

   Database? database;

  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archiveTasks=[];


  void createDataBase()
  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database,  version)
      {
        print('database create');

        database.execute(  'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)'
        ).then((value){
          print('table create');

        }).catchError((error){
          print('error!!!!!${error.toString()}');
        });

      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
        print('database open');

      },

    ).then((value) {
      database=value;
      emit(AppcreateDataBase());
    });
  }

   insertDataBase({
    required String title,
    required String time,
    required String date,

  })async{
      await database!.transaction((txn)async
    {
      await
      txn.rawInsert(
        'INSERT INTO Tasks(title,date,time,status)VALUES("$title","$date","$time","newTasks")'
      ).then((value){
        print("${value} inserted successfully");
        emit(AppinsertDataBase());

        getDataFromDatabase(database);
      }).catchError((error){
        print(" Error when inserted  ${error}");
      });
      return null;

    });
  }

 void getDataFromDatabase(database)
  {
    newTasks=[];
    doneTasks =[];
    archiveTasks=[];
    emit(AppgetDataLoadingmDatabase());

   database.rawQuery('SELECT * FROM tasks').then((value){

      value.forEach((element)
      {
       if(element['status'] == 'newTasks')
         newTasks.add(element);

         else if(element['status'] == 'done')
         doneTasks.add(element);

         else archiveTasks.add(element);

      });
      emit(AppgetDataFromDatabase());
    });

  }

void updateData({
    required String status,
    required int id,
  })
  {
    database!.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value)
    {
      getDataFromDatabase(database);
      emit(AppupdatetData());
    });

  }

  void deleteData({
    required int id,
  })
  {
    database!.rawDelete(
        'DELETE FROM Tasks WHERE  id = ?',
        [id]).then((value)
    {
      getDataFromDatabase(database);
      emit(AppdeletetData());
    });

  }



  bool isBottomSheetShow=false;
  IconData iconData=Icons.edit;

  void changeisBottomSheetShow({
       required bool isBtmSheetShow,
       required IconData icon,

}){
    isBottomSheetShow=isBtmSheetShow;
    iconData=icon;
    emit(AppchangeisBottomSheetShow());
  }


}