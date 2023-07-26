import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http2;






class ApiService {



  ///dipkai
  ///
  ///
  String address = 'https://mita.balifoam.com/mobile/flutter';


  Future<dynamic> getNewRequestData({List pathList,String idAsset, String problem, String idUser})async{

    var request = http2.MultipartRequest('POST', Uri.parse('$address/service_CM.php'));
    request.fields['password'] = 'BFNMAdmin2015';
    request.fields['id_asset'] = idAsset;
    request.fields['problem'] = problem;
    request.fields['requestor_id'] = idUser;
    request.fields['count'] = pathList.length.toString();
    for(int i=0; i<pathList.length; i++){
      request.files.add(await http2.MultipartFile.fromPath('image$i', pathList[i]));
    }

    var res = await request.send();

    final response = await http2.Response.fromStream(res);
    String jSonData = response.body;
    var decodeData = jsonDecode(jSonData);
    return decodeData;

  }

  Future<dynamic> getNewRequestMaintenance({String idAsset, String currentKm, String idUser})async{

    var request = http2.MultipartRequest('POST', Uri.parse('$address/service_PM.php'));
    request.fields['password'] = 'BFNMAdmin2015';
    request.fields['id_asset'] = idAsset;
    request.fields['current_km'] = currentKm;
    request.fields['requestor_id'] = idUser;

    var res = await request.send();

    final response = await http2.Response.fromStream(res);
    String jSonData = response.body;
    var decodeData = jsonDecode(jSonData);
    return decodeData;




  }

  Future<dynamic> getNewRequestOtherData({List pathList, String problem, String idUser, String type, String location})async{

    var request = http2.MultipartRequest('POST', Uri.parse('$address/service_other.php'));
    request.fields['password'] = 'BFNMAdmin2015';
    request.fields['problem'] = problem;
    request.fields['requestor_id'] = idUser;
    request.fields['type'] = type;
    request.fields['location'] = location;
    request.fields['count'] = pathList.length.toString();
    for(int i=0; i<pathList.length; i++){
      request.files.add(await http2.MultipartFile.fromPath('image$i', pathList[i]));
    }

    var res = await request.send();

    final response = await http2.Response.fromStream(res);
    String jSonData = response.body;
    var decodeData = jsonDecode(jSonData);
    return decodeData;

  }


  Future<dynamic> addCaseImage({List pathList,String idCase, String idUser})async{

    var request = http2.MultipartRequest('POST', Uri.parse('$address/add_image.php'));
    request.fields['password'] = 'BFNMAdmin2015';
    request.fields['id_request'] = idCase;
    request.fields['requestor_id'] = idUser;
    request.fields['count'] = pathList.length.toString();
    for(int i=0; i<pathList.length; i++){
      request.files.add(await http2.MultipartFile.fromPath('image$i', pathList[i]));
    }

    var res = await request.send();

    final response = await http2.Response.fromStream(res);


    String jSonData = response.body;
    var decodeData = jsonDecode(jSonData);
    return decodeData;

  }

  ///simpan foto mesin
  Future<String> saveAssetPicture({String path, String idAsset})async{

    var request = http2.MultipartRequest('POST', Uri.parse('$address/save_asset_image.php'));
    request.fields['password'] = 'BFNMAdmin2015';
    request.fields['id_asset'] = idAsset;
    request.files.add(await http2.MultipartFile.fromPath('image', path));


    var res = await request.send();

    final response = await http2.Response.fromStream(res);


    String jSonData = response.body;
    var decodeData = jsonDecode(jSonData);
    return decodeData;

  }

  ///simpan foto yg punya mesin
  Future<String> saveUserPicture({String path, String idAsset})async{

    var request = http2.MultipartRequest('POST', Uri.parse('$address/save_user_profile_image.php'));
    request.fields['password'] = 'BFNMAdmin2015';
    request.fields['id_asset'] = idAsset;
    request.files.add(await http2.MultipartFile.fromPath('image', path));


    var res = await request.send();

    final response = await http2.Response.fromStream(res);


    String jSonData = response.body;
    var decodeData = jsonDecode(jSonData);
    return decodeData;


  }

  ///simpan foto user
  Future<String> saveProfilePicture({String path, String idUser, String name})async{

    var request = http2.MultipartRequest('POST', Uri.parse('$address/save_profile_image.php'));
    request.fields['password'] = 'BFNMAdmin2015';
    request.fields['id_user'] = idUser;
    request.fields['name'] = name;
    request.files.add(await http2.MultipartFile.fromPath('image', path));


    var res = await request.send();
    final response = await http2.Response.fromStream(res);


    String jSonData = response.body;
    var decodeData = jsonDecode(jSonData);
    return decodeData;


  }

  Future<String> saveCarouselImage({List pathList})async{

    var request = http2.MultipartRequest('POST', Uri.parse('$address/save_carousel_image.php'));
    request.fields['password'] = 'BFNMAdmin2015';

    request.fields['count'] = pathList.length.toString();
    for(int i=0; i<pathList.length; i++){
      request.files.add(await http2.MultipartFile.fromPath('image$i', pathList[i]));
    }

    //request.files.add(await http2.MultipartFile.fromPath('image$i', pathList[0]));



    var res = await request.send();

    return res.reasonPhrase;




  }



  ///






/*

  Future<List<Assets>> getAssetsPreview(category) async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',
      'category': category,

    };
    Response res = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/load_data_asset.php'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Assets> assets = body.map((dynamic item) => Assets.fromJson(item)).toList();
      return assets;
    } else {
      throw "Failed to load cases list";
    }
  }

  Future<List<Assets>> getAssetsPreviewCategory(keyword, category) async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',
      'keyword': keyword,
      'category' : category

    };
    Response res = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/load_data_asset_category.php'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Assets> assets = body.map((dynamic item) => Assets.fromJson(item)).toList();
      return assets;
    } else {
      throw "Failed to load cases list";
    }
  }

  Future<List<Assets>> getAssetsPreviewFilter(idAsset) async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',
      'id_asset': idAsset,

    };
    Response res = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/load_data_asset_filter.php'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Assets> assets = body.map((dynamic item) => Assets.fromJson(item)).toList();
      return assets;
    } else {
      throw "Failed to load cases list";
    }
  }

  Future<List<Cases>> getCasesPreview(id_asset, keyword) async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',
      'id_asset': id_asset,
      'keyword': keyword,


    };
    Response res = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/load_data_cases.php'),

      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<Cases> cases = body.map((dynamic item) => Cases.fromJson(item)).toList();
      return cases;
    } else {
      throw "Failed to load cases list";
    }
  }


  Future<List<CaseDetail>> getCaseDetail(id_case) async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',
      'id_request': id_case,



    };
    Response res = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/load_detail_case.php'),

      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    if (res.statusCode == 200) {

      List<dynamic> body = jsonDecode(res.body);
      List<CaseDetail> caseDetail = body.map((dynamic item) => CaseDetail.fromJson(item)).toList();
      return caseDetail;
    } else {
      throw "Failed to load cases list";
    }
  }

 */
/*
  Future<List<CaseImage>> getCaseImage(id_case) async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',
      'id_request': id_case,



    };
    Response res = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/load_image_case.php'),

      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    if (res.statusCode == 200) {

      List<dynamic> body = jsonDecode(res.body);
      List<CaseImage> caseImage = body.map((dynamic item) => CaseImage.fromJson(item)).toList();
      return caseImage;
    } else {
      throw "Failed to load cases list";
    }
  }


 */
  /*
  Future<List<Checklist>> getChecklist(id_case) async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',
      'id_request': id_case,



    };
    Response res = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/load_checklist.php'),

      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    if (res.statusCode == 200) {

      List<dynamic> body = jsonDecode(res.body);
      List<Checklist> checkList = body.map((dynamic item) => Checklist.fromJson(item)).toList();
      return checkList;
    } else {
      throw "Failed to load cases list";
    }
  }

  Future<dynamic> getDetailCase(id_case) async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',
      'id_request': id_case,

    };
    Response response = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/load_detail_case.php'),

      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    try
    {
      if(response.statusCode == 200)
      {
        String jSonData = response.body;
        var decodeData = jsonDecode(jSonData);
        return decodeData;
      }
      else
      {
        return "failed";
      }
    }
    catch(exp)
    {
      return "failed";
    }
  }

  Future<List<MaintenanceStatus>> getMaintenanceStatus(id_asset) async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',
      'id_asset': id_asset,



    };
    Response res = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/load_maintenance_status.php'),

      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    if (res.statusCode == 200) {

      List<dynamic> body = jsonDecode(res.body);
      List<MaintenanceStatus> maintenanceStatus = body.map((dynamic item) => MaintenanceStatus.fromJson(item)).toList();
      return maintenanceStatus;
    } else {
      throw "Failed to load cases list";
    }
  }

   */

  /*
  Future<List<CarouselImage>> getCarouselImage() async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',
    };
    Response res = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/load_image_carousel.php'),

      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    if (res.statusCode == 200) {

      List<dynamic> body = jsonDecode(res.body);
      List<CarouselImage> carouselImage = body.map((dynamic item) => CarouselImage.fromJson(item)).toList();
      return carouselImage;
    } else {
      throw "Failed to load cases list";
    }
  }


   */
  /*
  Future<List<UserImage>> getUserImage(idAsset) async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',
      'id_asset' : idAsset
    };
    Response res = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/load_image_user.php'),

      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    if (res.statusCode == 200) {

      List<dynamic> body = jsonDecode(res.body);
      List<UserImage> userImage = body.map((dynamic item) => UserImage.fromJson(item)).toList();
      return userImage;
    } else {
      throw "Failed to load cases list";
    }
  }

   */








  Future<dynamic> getAddImage({List pathList,String idCase, String idUser})async{

    var request = http2.MultipartRequest('POST', Uri.parse('http://mita.balifoam.com/mobile/flutter/add_image.php'));
    request.fields['password'] = 'BFNMAdmin2015';
    request.fields['id_request'] = idCase;
    request.fields['requestor_id'] = idUser;

    request.fields['count'] = pathList.length.toString();
    for(int i=0; i<pathList.length; i++){
      request.files.add(await http2.MultipartFile.fromPath('image$i', pathList[i]));
    }

    var res = await request.send();

    final response = await http2.Response.fromStream(res);


    String jSonData = response.body;
    var decodeData = jsonDecode(jSonData);
    return decodeData;

  }




/*
  Future<dynamic> getOrderSparepart(idCase, description) async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',

      'id_request': idCase,
      'POS_description': description,


    };
    Response response = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/res_order_sparepart.php'),

      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    try
    {
      if(response.statusCode == 200)
      {
        String jSonData = response.body;
        var decodeData = jsonDecode(jSonData);
        return decodeData;
      }
      else
      {
        return "failed";
      }
    }
    catch(exp)
    {
      return "failed";
    }
  }


 */
/*
  ///untuk perawatan
  Future<dynamic> getMaintenanceComplete(idCase, checklist, problem, solution, kelas) async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',

      'id_request': idCase,
      'checklist': checklist,
      'problem' : problem,
      'solution': solution,
      'class': kelas


    };
    Response response = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/res_maintenance_complete.php'),

      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    try
    {
      if(response.statusCode == 200)
      {
        String jSonData = response.body;
        var decodeData = jsonDecode(jSonData);
        return decodeData;
      }
      else
      {
        return "failed";
      }
    }
    catch(exp)
    {
      return "failed";
    }
  }

 */
/*
  Future<dynamic> getLastCheck(idCase, overtime, idUser) async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',

      'id_request': idCase,
      'overtime': overtime,
      'id_user': idUser,


    };
    Response response = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/res_me_check.php'),

      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    try
    {
      if(response.statusCode == 200)
      {
        String jSonData = response.body;
        var decodeData = jsonDecode(jSonData);
        return decodeData;
      }
      else
      {
        return "failed";
      }
    }
    catch(exp)
    {
      return "failed";
    }
  }


  Future<dynamic> getTest() async {
    Map<String, String> body = {
      'password': 'BFNMAdmin2015',



    };
    Response response = await post(Uri.parse('http://mita.balifoam.com/mobile/flutter/dummy3.php'),

      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),


    );

    try
    {
      if(response.statusCode == 200)
      {
        String jSonData = response.body;
        var decodeData = jsonDecode(jSonData);
        return decodeData;
      }
      else
      {
        return "failed";
      }
    }
    catch(exp)
    {
      return "failed";
    }
  }

 */




}