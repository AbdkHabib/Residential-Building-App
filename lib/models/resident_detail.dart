enum UserTableKeys {
  id, payment_year, amount, payment_date, payment_details,apartment_id
}

class ResidentDetail {
  late int id;
  //عدد افراد الاسرة
  // late int numPeople;
  //نوع السكن
  // late String accommodationType;
  //المبلغ المسدد
  late num amount;
  //عن اي شهر في السنة
  late String paymentYear;
  // في اي يوم دفع المبلغ
  late String paymentDate;
  //تفاصيل الدفعة
  late String paymentDetails;

  late int apartmentId;

  static const tableName = 'resident';

  ResidentDetail();

  ResidentDetail.fromMap(Map<String, dynamic> rowMap) {
    id = rowMap[UserTableKeys.id.name];
    amount = rowMap[UserTableKeys.amount.name];
    paymentDate = rowMap[UserTableKeys.payment_date.name];
    paymentYear = rowMap[UserTableKeys.payment_year.name];
    paymentDetails = rowMap[UserTableKeys.payment_details.name];
    apartmentId = rowMap[UserTableKeys.apartment_id.name];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String,dynamic>{};
    // map[UserTableKeys.numPeople.name] = numPeople;
    map[UserTableKeys.amount.name] = amount;
    map[UserTableKeys.payment_date.name] = paymentDate;
    map[UserTableKeys.payment_year.name] = paymentYear;
    map[UserTableKeys.payment_details.name] = paymentDetails;
    map[UserTableKeys.apartment_id.name] = apartmentId;
    return map;
  }
}
