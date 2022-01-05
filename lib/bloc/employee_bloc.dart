// 1. Import File
// 2. Create List
// 3. Create Stream Controller
// 4. Create getter for stream
// 5.  Create Constructor (eg. add data)
// 6. Core Function
// 7. dispose

import 'package:bloc_demo/modal/employee.dart';
import 'dart:async';

class EmployeeBloc {
  List<Employee> employeeList = [
    Employee(id: 1, empName: "Nirmal Sorathiya", salary: 10000),
    Employee(id: 2, empName: "Rajni Kheni", salary: 20000),
    Employee(id: 3, empName: "Kartik Sonani", salary: 30000),
    Employee(id: 4, empName: "Keval Tilavat", salary: 40000),
    Employee(id: 5, empName: "Hritik Roshan", salary: 50000),
  ];

  // Create Stream Controller

  final employeeStreamController = StreamController<List<Employee>>();
  final empSalaryIncrementStreamController = StreamController<Employee>();
  final empSalaryDecrementtStreamController = StreamController<Employee>();

  //Create getter
  // * Sink Add Data
  // * Stream Get Data
  Stream<List<Employee>> get empStream => employeeStreamController.stream;
  StreamSink<List<Employee>> get empSink => employeeStreamController.sink;
  StreamSink<Employee> get empSalaryIncrementSink =>
      empSalaryIncrementStreamController.sink;
  StreamSink<Employee> get empSalaryDecrementSink =>
      empSalaryDecrementtStreamController.sink;

  EmployeeBloc() {
    employeeStreamController.add(employeeList);
    empSalaryIncrementStreamController.stream.listen(increment);
    empSalaryDecrementtStreamController.stream.listen(decrement);
  }

  increment(Employee emp) {
    double salary = emp.salary!;
    double incrementSalary = salary + salary * 20 / 100;
    employeeList[emp.id! - 1].salary = incrementSalary;
    empSink.add(employeeList);
  }

  decrement(Employee emp) {
    double salary = emp.salary!;
    double decrementSalary = salary - salary * 20 / 100;
    employeeList[emp.id! - 1].salary = decrementSalary;
    empSink.add(employeeList);
  }

  void dispose() {
    employeeStreamController.close();
    empSalaryIncrementStreamController.close();
    empSalaryDecrementtStreamController.close();
  }
}
