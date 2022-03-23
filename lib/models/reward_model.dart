class Reward{
  int? id;
  String? nama;
  int? req_poin;
  int? completed;

  Reward({
    required this.nama,
    required this.req_poin,
    required this.completed
  });

  Reward.withId({
    required this.id,
    required this.nama,
    required this.req_poin,
    required this.completed,
  });

  Map<String,dynamic> toMap(){
    final map=Map<String,dynamic>();
    if(id!=null){
      map['id']=id;
    }
    map['nama']=nama;
    map['req_poin']=req_poin;
    map['completed']=completed;

    return map;
  }

  factory Reward.fromMap(Map<String,dynamic> map){
    return Reward.withId(
      id:map['id'],
      nama:map['nama'],
      req_poin:map['req_poin'],
      completed:map['completed'],
    );
  }
}