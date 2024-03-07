class BusDetailModel {
  String? id;
  String? name;
  String? busType;
  String? seatType;
  String? type;
  String? profileImage;
  String? noOfSeat;
  String? amount;
  String? status;
  String? address;
  String? toAddress;
  String? startTime;
  String? endTime;
  String? vehicleNo;
  String? jsonData;
  dynamic? holiday;
  String? createdAt;
  String? driverId;
  String? date;
  dynamic? busDeck;
  dynamic? leftseat;
  dynamic? rightseat;
  dynamic? uperLeft;
  dynamic? uperRight;
  List<SeatDesign>? seatDesign;
  String? availableSeats;
  List<List<SeatDesign>>? seatDesignList;

  BusDetailModel(
      {this.id,
        this.name,
        this.busType,
        this.seatType,
        this.type,
        this.profileImage,
        this.noOfSeat,
        this.amount,
        this.status,
        this.address,
        this.toAddress,
        this.startTime,
        this.endTime,
        this.vehicleNo,
        this.jsonData,
        this.holiday,
        this.createdAt,
        this.driverId,
        this.date,
        this.busDeck,
        this.leftseat,
        this.rightseat,
        this.uperLeft,
        this.uperRight,
        this.seatDesign,
        this.availableSeats});

  BusDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    name = json['name'];

    busType = json['bus_type'] == null ? null : json['bus_type'];

    seatType = json['seat_type'];
    type = json['type'];
    profileImage = json['profile_image'];
    noOfSeat = json['no_of_seat'];
    amount = json['amount'];
    status = json['status'];
    address = json['address'];
    toAddress = json['to_address'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    vehicleNo = json['vehicle_no'];
    jsonData = json['json_data'];
    holiday = json['holiday'] == null ? null :json['holiday'];
    createdAt = json['created_at'];
    driverId = json['driver_id'];
    if (json['seat_design'] != null) {

      print('_________________19');

      seatDesignList = [];
      seatDesign = <SeatDesign>[];
      for(var v in json['seat_design']){
        if(v is List) {
         List<SeatDesign> seatDesign = <SeatDesign>[];
          v.forEach((p) {
            seatDesign.add(new SeatDesign.fromJson(p));
          });
         seatDesignList?.add(seatDesign.toList());
        }else{
          seatDesign!.add(new SeatDesign.fromJson(v));
        }
      }

    }
    availableSeats = json['available_seats'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['bus_type'] = this.busType;
    data['seat_type'] = this.seatType;
    data['type'] = this.type;
    data['profile_image'] = this.profileImage;
    data['no_of_seat'] = this.noOfSeat;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['address'] = this.address;
    data['to_address'] = this.toAddress;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['vehicle_no'] = this.vehicleNo;
    data['json_data'] = this.jsonData;
    data['holiday'] = this.holiday;
    data['created_at'] = this.createdAt;
    data['driver_id'] = this.driverId;
    if (this.seatDesign != null) {
      data['seat_design'] = this.seatDesign!.map((v) => v.toJson()).toList();
    }
    data['available_seats'] = this.availableSeats;
    return data;
  }
}

class SeatDesign {
  int? id;
  bool? isSelected;
  bool? isChecked;
  SeatDesign({this.id, this.isSelected,this.isChecked});

  SeatDesign.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isSelected = json['is_selected'];
    isChecked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_selected'] = this.isSelected;
    return data;
  }
}
class StationModel {
  String? title;
  String? time;

  StationModel({this.title, this.time});

  StationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['time'] = this.time;
    return data;
  }
}




