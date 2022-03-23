import 'dart:io';

void main() {
  performTask();
}

void performTask() async {
  task1();
  String data= await task2();
  task3(data);
}

void task1() {
  String task = 'this is task1';
  print(task);
}

Future<String> task2() async {
  Duration threeSeconds = Duration(seconds: 3);
  await Future.delayed(threeSeconds, () {
    String task = 'this is task2';
    print(task);
    print("INI DI EKSEKUSI NANTI TERAKHIR");
  });
  print("HALLO HALLO");
  return "Total data pada task 2 adalah 20";
}

void task3(String task2Data) {
  String task = 'this is task3';
  print(task +" "+ task2Data);
}
