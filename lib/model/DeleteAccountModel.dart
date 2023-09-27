/// status : true
/// data : []
/// message : "Account deleted success"

class DeleteAccountModel {
  DeleteAccountModel({
      bool? status, 
      List<dynamic>? data, 
      String? message,}){
    _status = status;
    _data = data;
    _message = message;
}

  DeleteAccountModel.fromJson(dynamic json) {
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(v.fromJson(v));
      });
    }
    _message = json['message'];
  }
  bool? _status;
  List<dynamic>? _data;
  String? _message;
DeleteAccountModel copyWith({  bool? status,
  List<dynamic>? data,
  String? message,
}) => DeleteAccountModel(  status: status ?? _status,
  data: data ?? _data,
  message: message ?? _message,
);
  bool? get status => _status;
  List<dynamic>? get data => _data;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['message'] = _message;
    return map;
  }

}