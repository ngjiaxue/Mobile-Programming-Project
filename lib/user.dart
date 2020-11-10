class User {
  String _name, _email, _phone, _address,  _credit;
  double _latitude, _longitude;

  User(String name, String email, String phone, String address, double latitude,
      double longitude, String credit) {
    this._name = name;
    this._email = email;
    this._phone = phone;
    this._address = address;
    this._latitude = latitude;
    this._longitude = longitude;
    this._credit = credit;
  }

  getName() {
    return this._name;
  }

  getEmail() {
    return this._email;
  }

  getPhone() {
    return this._phone;
  }

  getAddress() {
    return this._address;
  }

  getLatitude() {
    return this._latitude;
  }

  getLongitude() {
    return this._longitude;
  }

  getCredit() {
    return this._credit;
  }

  void setName(String name) {
    this._name = name;
  }

  void setEmail(String email) {
    this._email = email;
  }

  void setPhone(String phone) {
    this._phone = phone;
  }

  void setAddress(String address) {
    this._address = address;
  }

  void setLatitude(double latitude) {
    this._latitude = latitude;
  }

  void setLongitude(double longitude) {
    this._longitude = longitude;
  }

  void setCredit(String credit) {
    this._credit = credit;
  }
}
