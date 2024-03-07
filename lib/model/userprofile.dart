/// error : false
/// message : "User Found"
/// data : {"username":"surendra","email":"ffff@gmail.com","mobile":"9632580741","address":"india ","profile_pic":"https://developmentalphawizz.com/bus_booking/uploads/profile_pics/"}

class UserProfile {
  Userprofile({
      bool? error, 
      String? message, 
      Data? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  UserProfile.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
  UserProfile copyWith({  bool? error,
  String? message,
  Data? data,
}) => Userprofile(  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// username : "surendra"
/// email : "ffff@gmail.com"
/// mobile : "9632580741"
/// address : "india "
/// profile_pic : "https://developmentalphawizz.com/bus_booking/uploads/profile_pics/"

class Data {
  Data({
      String? username, 
      String? email, 
      String? mobile, 
      String? address,
    String? state,
    String? city,
      String? profilePic,}){
    _username = username;
    _email = email;
    _mobile = mobile;
    _address = address;
    _city = city;
    _state = state;
    _profilePic = profilePic;
}

  Data.fromJson(dynamic json) {
    _username = json['username'];
    _email = json['email'];
    _mobile = json['mobile'];
    _address = json['address'];
    _city = json['city'];
    _state = json['state'];
    _profilePic = json['profile_pic'];
  }
  String? _state;
  String? _city;
  String? _username;
  String? _email;
  String? _mobile;
  String? _address;
  String? _profilePic;
Data copyWith({  String? username,
  String? email,
  String? mobile,
  String? address,
  String? state,
  String? city,
  String? profilePic,
}) => Data(  username: username ?? _username,
  email: email ?? _state,
  state: state ?? _email,
  city: city ?? _city,
  mobile: mobile ?? _mobile,
  address: address ?? _address,
  profilePic: profilePic ?? _profilePic,
);
  String? get username => _username;
  String? get email => _email;
  String? get city => _city;
  String? get state => _state;
  String? get mobile => _mobile;
  String? get address => _address;
  String? get profilePic => _profilePic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['email'] = _email;
    map['mobile'] = _mobile;
    map['address'] = _address;
    map['state'] = _state;
    map['city'] = _city;
    map['profile_pic'] = _profilePic;
    return map;
  }

}