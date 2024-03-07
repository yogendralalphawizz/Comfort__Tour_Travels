class WalletDataModel {
  String? responseCode;
  String? tatalBalance;
  String? msg;
  List<Data>? data;

  WalletDataModel({this.responseCode, this.tatalBalance, this.msg, this.data});

  WalletDataModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    tatalBalance = json['tatal_balance'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['tatal_balance'] = this.tatalBalance;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? userId;
  String? userType;
  String? amount;
  String? transactionId;
  String? createdAt;
  String? updatedAt;
  String? refferalStatus;
  String? level;
  String? refferalId;
  String? status;

  Data(
      {this.id,
        this.userId,
        this.userType,
        this.amount,
        this.transactionId,
        this.createdAt,
        this.updatedAt,
        this.refferalStatus,
        this.level,
        this.refferalId,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userType = json['user_type'];
    amount = json['amount'];
    transactionId = json['transaction_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    refferalStatus = json['refferal_status'];
    level = json['level'];
    refferalId = json['refferal_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_type'] = this.userType;
    data['amount'] = this.amount;
    data['transaction_id'] = this.transactionId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['refferal_status'] = this.refferalStatus;
    data['level'] = this.level;
    data['refferal_id'] = this.refferalId;
    data['status'] = this.status;
    return data;
  }
}
