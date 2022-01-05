import 'package:bloc_demo/bloc/employee_bloc.dart';
import 'package:bloc_demo/modal/employee.dart';
import 'package:bloc_demo/user_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? pref;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await SharedPreferences.getInstance();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue.shade900,
        appBarTheme: AppBarTheme(
          color: Colors.blue.shade900,
          centerTitle: true,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: "BlocPattern Demo",
      home: const UserDetails(),
    );
  }
}

//Employee Demo
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EmployeeBloc employeeBloc = EmployeeBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BlocPattern Demo"),
      ),
      body: SizedBox(
        child: StreamBuilder<List<Employee>>(
          stream: employeeBloc.employeeStreamController.stream,
          builder: (context, AsyncSnapshot<List<Employee>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: Text('${snapshot.data![index].id}'),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${snapshot.data![index].empName}',
                          ),
                          Text(
                            '${snapshot.data![index].salary!.ceil()}',
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              employeeBloc.empSalaryIncrementSink
                                  .add(snapshot.data![index]);
                            },
                            child: const Icon(
                              Icons.thumb_up,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              employeeBloc.empSalaryDecrementtStreamController
                                  .add(snapshot.data![index]);
                            },
                            child: const Icon(
                              Icons.thumb_down,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    employeeBloc.dispose();
    super.dispose();
  }
}
