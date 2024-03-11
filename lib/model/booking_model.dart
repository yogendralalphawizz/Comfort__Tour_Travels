class BookingModel {
  String? id;
  String? userId;
  String? busId;
  String? transactionId;
  String? pickupAddress;
  String? gstAmount;
  String? total;
  String? dropAddress;
  String? amount;
  String? status;
  String? bookingDate;
  String? createdAt;
  String? updatedAt;
  String? platformFee;
  String? pickupTime;
  String? dropTime;
  String? type;
  String? fromCity;
  String? toCity;
  BusDetail? busDetail;
  List<PassengerDetails>? passengerDetails;

  BookingModel(
      {this.id,
        this.userId,
        this.busId,
        this.transactionId,
        this.pickupAddress,
        this.gstAmount,
        this.busDetail,
        this.total,
        this.dropAddress,
        this.amount,
        this.status,
        this.bookingDate,
        this.createdAt,
        this.updatedAt,
        this.platformFee,
        this.pickupTime,
        this.dropTime,
        this.type,
        this.fromCity,
        this.toCity,
        this.passengerDetails});

  BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    busId = json['bus_id'];
    transactionId = json['transaction_id'];
    pickupAddress = json['pickup_address'];
    gstAmount = json['gst_amount'];
    total = json['total'];
    dropAddress = json['drop_address'];
    amount = json['amount'];
    status = json['status'];
    bookingDate = json['booking_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    platformFee = json['platform_fee'];
    pickupTime = json['pickup_time'];
    dropTime = json['drop_time'];
    type = json['type'];
    fromCity = json['fromCity'];
    toCity = json['toCity'];
    busDetail = json['bus_datails']!=null?BusDetail.fromJson(json['bus_datails']):null;
    if (json['passenger_details'] != null) {
      passengerDetails = <PassengerDetails>[];
      json['passenger_details'].forEach((v) {
        passengerDetails!.add(new PassengerDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['bus_id'] = this.busId;
    data['transaction_id'] = this.transactionId;
    data['pickup_address'] = this.pickupAddress;
    data['gst_amount'] = this.gstAmount;
    data['total'] = this.total;
    data['drop_address'] = this.dropAddress;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['booking_date'] = this.bookingDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['platform_fee'] = this.platformFee;
    data['pickup_time'] = this.pickupTime;
    data['drop_time'] = this.dropTime;
    data['type'] = this.type;
    data['fromCity'] = this.fromCity;
    data['toCity'] = this.toCity;
    if (this.passengerDetails != null) {
      data['passenger_details'] =
          this.passengerDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PassengerDetails {
  String? id;
  String? bookingId;
  String? name;
  String? gender;
  String? age;
  String? seatNo;
  String? createdAt;
  String? updatedAt;
  String? otp;

  PassengerDetails(
      {this.id,
        this.bookingId,
        this.name,
        this.gender,
        this.age,
        this.seatNo,
        this.createdAt,
        this.updatedAt,
        this.otp});

  PassengerDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    name = json['name'];
    gender = json['gender'];
    age = json['age'];
    seatNo = json['seat_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['seat_no'] = this.seatNo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['otp'] = this.otp;
    return data;
  }
}
class BusDetail {
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
  String? holiday;
  String? createdAt;
  String? driverId;
  String? driverName;
  String? driverMobile;

  BusDetail(
      {this.id,
        this.driverMobile,
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
        this.driverName});

  BusDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverMobile = json['mobile_number'];
    name = json['name'];
    busType = json['bus_type'];
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
    holiday = json['holiday'];
    createdAt = json['created_at'];
    driverId = json['driver_id'];
    driverName = json['driver_name'];
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
    data['driver_name'] = this.driverName;
    return data;
  }
}
