class Counter{
  int? id;
  String? nama;
  int? total;

  Counter({
    required this.nama,
    required this.total,
  });

  Counter.withId({
    required this.id,
    required this.nama,
    required this.total,
  });

  Map<String,dynamic> toMap(){
    final map=Map<String,dynamic>();
    if(id!=null){
      map['id']=id;
    }
    map['nama']=nama;
    map['total']=total;
    return map;
  }

  factory Counter.fromMap(Map<String,dynamic> map){
    return Counter.withId(
      id:map['id'],
      nama:map['nama'],
      total:map['total'],
    );
  }
}