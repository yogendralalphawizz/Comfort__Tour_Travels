class BusStopgeModel {
  bool? status;
  List<StopageData>? data;
  String? message;

  BusStopgeModel({this.status, this.data, this.message});

  BusStopgeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <StopageData>[];
      json['data'].forEach((v) {
        data!.add(new StopageData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class StopageData {
  String? id;
  String? busId;
  String? charge;
  String? stop;
  String? stopFromtime;
  String? stopTotime;
  String? createdAt;
  String? updatedAt;
  String? name;
  Null? image;
  Null? description;
  String? countryId;
  String? stateId;
  String? sr_no;

  StopageData(
      {this.id,
        this.busId,
        this.charge,
        this.stop,
        this.stopFromtime,
        this.stopTotime,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.image,
        this.description,
        this.countryId,
        this.sr_no,
        this.stateId});

  StopageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    busId = json['bus_id'];
    charge = json['charge'];
    stop = json['stop'];
    stopFromtime = json['stop_fromtime'];
    stopTotime = json['stop_totime'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    sr_no = json['sr_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bus_id'] = this.busId;
    data['charge'] = this.charge;
    data['stop'] = this.stop;
    data['stop_fromtime'] = this.stopFromtime;
    data['stop_totime'] = this.stopTotime;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    return data;
  }
}
