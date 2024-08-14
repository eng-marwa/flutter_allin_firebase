class AppUser {
  String name = '';
  String phone = '';
  String email = '';
  String uid = '';
  String address = '';
  String? pic;

  AppUser(this.name, this.phone, this.email, this.uid, this.address,
      [this.pic]);

  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'email': email,
        'uid': uid,
        'address': address,
        'pic': pic
      };

  AppUser.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    phone = map['phone'];
    email = map['email'];
    uid = map['uid'];
    address = map['address'];
    pic = map['pic'];
  }

  @override
  String toString() {
    return 'AppUser{name: $name, phone: $phone, email: $email, uid: $uid, address: $address,}';
  }
}
