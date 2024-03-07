class UserModel {
  String? username;
  String? email;
  String? mobile;
  String? address;
  String? city;
  String? state;
  String? profilePic;

  UserModel(
      {this.username,
        this.email,
        this.mobile,
        this.address,
        this.city,
        this.state,
        this.profilePic});

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}
