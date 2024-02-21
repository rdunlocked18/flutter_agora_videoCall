// Future<Map<String, dynamic>> getToken(String channelName) async {
//   int userId = random(100, 999);

//   Dio dio = Dio();
//   var token = '';

//   // try {
//   var response = await dio.post(
//     AppConstants.serverUrl,
//     options: Options(contentType: 'application/json'),
//     data: {
//       'channel': channelName,
//       'uid': userId.toString(),
//     },
//   );

//   if (response.data != null) {
//     var data = jsonDecode(response.data);
//     token = data['token'];
//   }

//   return {
//     'token': token,
//     'userId': userId,
//   };
// }
