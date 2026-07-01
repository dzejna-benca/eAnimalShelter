class VolunteerActivitySearchObject {
  String? title;
  int? locationId;
  int? status;

  String? sortBy;

  int? page;
  int? pageSize;

  VolunteerActivitySearchObject({
    this.title,
    this.locationId,
    this.status,
    this.sortBy,
    this.page,
    this.pageSize,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "locationId": locationId,
      "status": status,
      "sortBy": sortBy,
      "page": page,
      "pageSize": pageSize,
      "includeTotalCount": true,
    };
  }
}