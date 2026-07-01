class DonationSearchObject {
  String? userFullName;

  double? minAmount;
  double? maxAmount;

  int? transactionStatus;

  String? sortBy;

  int page;
  int pageSize;

  DonationSearchObject({
    this.userFullName,
    this.minAmount,
    this.maxAmount,
    this.transactionStatus,
    this.sortBy,
    this.page = 1,
    this.pageSize = 10,
  });

  Map<String, dynamic> toJson() {
    return {
      "userFullName": userFullName,
      "minAmount": minAmount,
      "maxAmount": maxAmount,
      "transactionStatus":transactionStatus,
      "sortBy": sortBy,
      "page": page,
      "pageSize": pageSize,
      "includeTotalCount": true,
    };
  }
}