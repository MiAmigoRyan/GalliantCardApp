
class Cards {

  String _id = 'null';
  String _name = 'null';
  String _description = 'null';

  Cards({required String id, required String name, required String description});

  String get id => _id;
  set id(String newId){
    if (newId.isNotEmpty){
      _id=newId;
    }
  }

  String get name => _name;
  set name(String newName){
    if(newName.isNotEmpty){
      _name=newName;
    }
  }

  String get description => _description;
  set description(String newDesc){
    if(newDesc.isNotEmpty){
     description=newDesc;
    }
  }
}