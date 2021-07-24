
// class Firebasedata {
//   Firebasedata(
//       {required this.id,
//       required this.fastname,
//       required this.lastname,
//       required this.username,
//       required this.email,
//       required this.profileImageurl});

//   String id;
//   String fastname;
//   String lastname;
//   String username;
//   String email;
//   String profileImageurl;

//   factory Firebasedata.fromMap(Map<String, dynamic> doc, String id) {
//     return Firebasedata(
//       id: id,
//       fastname: doc["fastname"] ?? '',
//       lastname: doc["lastname"] ?? '',
//       username: doc["username"] ?? '',
//       email: doc["email"] ?? '',
//       profileImageurl: doc["profile-imageurl"] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "fastname": fastname,
//         "lastname": lastname,
//         "username": username,
//         "email": email,
//         "profile-imageurl": profileImageurl,
//       };
// }
