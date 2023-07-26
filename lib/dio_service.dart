import 'dart:convert';

import 'package:dio/dio.dart';

class DioService{


  String address = 'https://mita.balifoam.com/mobile/flutter';


  ///terpakai
  Future<dynamic>getCaseDetail(idCase)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idCase,

      };
      var response = await Dio().post('$address/load_detail_case.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getAssetDetail(idAsset)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_asset': idAsset

      };
      var response = await Dio().post('$address/load_data_detail_asset.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getAssetDetailSearch(idAsset, keyword)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_asset': idAsset,
        'keyword': keyword

      };
      var response = await Dio().post('$address/load_data_detail_asset_search.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getAssetListCategory(category)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'category': category

      };
      var response = await Dio().post('$address/load_data_asset_category.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getAssetListCategorySearch(category, keyword)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'category': category,
        'keyword' : keyword

      };
      var response = await Dio().post('$address/load_data_asset_category_search.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }


  Future<dynamic>getPreviewOutstanding()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',



      };
      var response = await Dio().post('$address/load_preview_data_outstanding.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>getTechResponse(idAsset, idCase, idUser)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_asset': idAsset,
        'id_request': idCase,
        'id_tech': idUser,

      };
      var response = await Dio().post('$address/res_tech_response.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>getOrderSparepart(idCase, description)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idCase,
        'POS_description': description,

      };
      var response = await Dio().post('$address/res_order_sparepart.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>getServiceComplete(idCase, solution)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idCase,
        'solution': solution,


      };
      var response = await Dio().post('$address/res_repair_complete.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>getMaintenanceComplete(idCase, checklist, problem, solution, kelas)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idCase,
        'checklist': checklist,
        'problem' : problem,
        'solution': solution,
        'class': kelas


      };
      var response = await Dio().post('$address/res_maintenance_complete.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>getSparepartReceive(idCase)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idCase,

      };
      var response = await Dio().post('$address/res_sparepart_receive.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>getLastCheck(idCase, overtime, idUser)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idCase,
        'overtime': overtime,
        'id_user': idUser,


      };
      var response = await Dio().post('$address/res_me_check.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>getUserApprove(idCase, idAsset, rating, idUser)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idCase,
        'id_asset': idAsset,
        'rating': rating,
        'id_user': idUser


      };
      var response = await Dio().post('$address/res_user_approve.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }
  Future<dynamic>getUserApproveAll(rating,idUser)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'rating': rating,
        'id_user': idUser


      };
      var response = await Dio().post('$address/res_user_approve_all.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>getUserToken(token, idUser)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_user' : idUser,
        'token': token,

      };
      var response = await Dio().post('$address/save_token.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>checkProfilePicture(idUser)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015x',
        'id_user' : idUser,


      };
      var response = await Dio().post('$address/check_profile_picture.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      var data = jsonDecode(response.data);
      var sts =response.statusCode;
      return [data,sts];
/*
      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

 */



    } catch (e) {
//      print(e.toString());

    }
  }

  Future<dynamic>loadDataGenset()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',



      };
      var response = await Dio().post('$address/load_data_genset.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>getPemanasanGenset(idCase, step, idUser)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idCase,
        'step' : step,
        'id_tech' : idUser,




      };
      var response = await Dio().post('$address/res_pemanasan_genset.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>loadEmployeeDetail(category, keyword)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'category': category,
        'keyword' : keyword,




      };
      var response = await Dio().post('$address/load_data_employee.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>loadEmployeeCategory()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',

      };
      var response = await Dio().post('$address/load_data_category_employee.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>updateUserName(idAsset, userName)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_asset': idAsset,
        'name': userName

      };
      var response = await Dio().post('$address/update_data_asset_user.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>updateDetailAsset(idAsset, manufacture, model, no)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_asset': idAsset,
        'new_manufacture': manufacture,
        'new_model': model,
        'new_no': no


      };
      var response = await Dio().post('$address/update_asset_detail.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>loadMyRequest(userId, userLevel)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'user_id': userId,
        'user_level' : userLevel




      };
      var response = await Dio().post('$address/load_my_request.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }


  Future<dynamic>checkMesinProduksi(kelas)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'kelas': kelas,



      };
      var response = await Dio().post('$address/report/report_mesin_produksi.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>updateAsuransi(idAsset, dateExpire, userId, insuranceName, insuranceNo, type)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_asset': idAsset,
        'date_expire':dateExpire,
        'user_id': userId,
        'insurance_name':insuranceName,
        'insurance_no':insuranceNo,
        'type': type




      };
      var response = await Dio().post('$address/update_data_asuransi.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>progressMaintenance()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',



      };
      var response = await Dio().post('$address/load_maintenance_progress.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>loadReportMesin()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',



      };
      var response = await Dio().post('$address/report/load_report.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>createReportMesin(kelas, idUser)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'kelas': kelas,
        'id_user':idUser



      };
      var response = await Dio().post('$address/report/create_data_report_mesin.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>createPdfReportMesin(idReport)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_report':idReport



      };
      var response = await Dio().post('$address/report/create_pdf_report_mesin.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>approveDataReportMesin(idUser,idReport)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_user':idUser,
        'id_report':idReport



      };
      var response = await Dio().post('$address/report/approve_data_report_mesin.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>approvePdfReportMesin(idReport)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_report':idReport



      };
      var response = await Dio().post('$address/report/approve_pdf_report_mesin.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }


  Future<dynamic>createReportApar(idUser)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_user':idUser

      };
      var response = await Dio().post('$address/report/create_data_report_apar.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>createPdfReportApar(idReport)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_report':idReport



      };
      var response = await Dio().post('$address/report/create_pdf_apar.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>createReportHydrant(idUser)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_user':idUser

      };
      var response = await Dio().post('$address/report/create_data_report_hydrant.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>createPdfReportHydrant(idReport)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_report':idReport



      };
      var response = await Dio().post('$address/report/create_pdf_hydrant.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>approveDataReportHydrant(idUser,idReport)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_user':idUser,
        'id_report':idReport



      };
      var response = await Dio().post('$address/report/approve_data_report_hydrant.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>approvePdfReportHydrant(idReport)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_report':idReport



      };
      var response = await Dio().post('$address/report/approve_pdf_hydrant.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }


  Future<dynamic>requestPemanasanGenset()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015'

      };
      var response = await Dio().post('$address/add_pemanasan_genset.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }

  Future<dynamic>checkVersion()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',

      };
      var response = await Dio().post('$address/check_version.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }
  Future<dynamic>loadUserLinked(keyword,uid)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'keyword': keyword,
        'uid': uid

      };
      var response = await Dio().post('$address/load_user_linked.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }
  Future<dynamic>updateUserLinked(uid, idAsset)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'uid': uid,
        'id_asset': idAsset

      };
      var response = await Dio().post('$address/update_user_linked.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);

    }
  }







  Future<dynamic>sendNotificationCM(step,type,kelas,uid, idCase)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'step': step,
        'type': type,
        'class': kelas,
        'user_uid':uid,
        'id_request':idCase


      };
      var response = await Dio().post('$address/notification/notification.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
///tidak perlu di ambil
      /*
      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

       */


    } catch (e) {
      print(e);
    }
  }
  Future<dynamic>sendNotificationPM(step,type,kelas,idCase)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'step': step,
        'type': type,
        'class': kelas,
        'id_request':idCase


      };
      var response = await Dio().post('$address/notification/notificationPM.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      ///tidak perlu di ambil
      /*
      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

       */


    } catch (e) {
      print(e);
    }
  }
  Future<dynamic>sendNotificationOther(step,idCase)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'step': step,
        'id_request':idCase


      };
      var response = await Dio().post('$address/notification/other_notification.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      ///tidak perlu di ambil
      /*
      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

       */


    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>sendNotificationReport(group, title)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'divisi': group,
        'title': title


      };
      var response = await Dio().post('$address/notification/report_notification.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      ///tidak perlu di ambil
      /*
      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

       */


    } catch (e) {
      print(e);
    }
  }


  Future<dynamic>getMaintenanceType(idAsset)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_asset': idAsset,

      };
      var response = await Dio().post('$address/find_checklist_type.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getUserLevel(uid)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'uid': uid,

      };
      var response = await Dio().post('$address/find_user_level.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }


  ///






  Future<dynamic>getAssetProfile(idAsset)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_asset': idAsset,

      };
      var response = await Dio().post('$address/load_asset_profile.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getNextService(idAsset, based)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_asset': idAsset,
        'based' : based

      };
      var response = await Dio().post('$address/find_next_service.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getRoutineUpdate(idAsset)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_asset' : idAsset


      };
      var response = await Dio().post('$address/find_insurance_data.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }



  Future<dynamic>getCaseStep(idCase)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idCase,

      };
      var response = await Dio().post('$address/get_step.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getCategory(idCase)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idCase,

      };
      var response = await Dio().post('$address/find_maintenance_category.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getCaseOutstanding()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        //'id_request': idCase,

      };
      var response = await Dio().post('$address/load_data_outstanding.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getOutstandingCount()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        //'id_request': idCase,

      };
      var response = await Dio().post('$address/outstanding_count.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getCountThisMonth()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        //'id_request': idCase,

      };
      var response = await Dio().post('$address/count_this_month.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>findIdAsset(idAsset)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_asset': idAsset,

      };
      var response = await Dio().post('$address/find_id_asset.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>findIdAssetfromIdCase(idCase)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idCase,

      };
      var response = await Dio().post('$address/find_id_asset_from_request.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }



  Future<dynamic>getPreviewOutstandingPM()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015'


      };
      var response = await Dio().post('$address/load_preview_data_outstanding_PM.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getPreviewOutstandingIT()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015'


      };
      var response = await Dio().post('$address/load_preview_data_outstanding_IT.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getUserOperasionalCar(uid)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'uid': uid


      };
      var response = await Dio().post('$address/find_user_operasional.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getUserEkspedisiCar()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',



      };
      var response = await Dio().post('$address/find_user_ekspedisi.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getNextScheduleCount()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',



      };
      var response = await Dio().post('$address/find_next_schedule_maintenance.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getNextScheduleITCount()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',



      };
      var response = await Dio().post('$address/find_next_schedule_it.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getEDPData(keyword)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'keyword': keyword,
        //'id_request': idCase,

      };
      var response = await Dio().post('$address/load_detail_data_edp.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getOutstandingData(keyword)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'keyword': keyword,
        //'id_request': idCase,

      };
      var response = await Dio().post('$address/load_detail_data_outstanding.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>loadCategoryOutstanding()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',


      };
      var response = await Dio().post('$address/load_category_data_outstanding.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>loadCategoryOutstandingPM()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',


      };
      var response = await Dio().post('$address/load_category_data_outstanding_PM.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }


  Future<dynamic>getPMData(keyword)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'keyword': keyword,
        //'id_request': idCase,

      };
      var response = await Dio().post('$address/load_detail_data_outstanding_PM.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getPMITData()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        //'id_request': idCase,

      };
      var response = await Dio().post('$address/load_detail_data_outstanding_IT.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getReminderData()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        //'id_request': idCase,

      };
      var response = await Dio().post('$address/find_reminder_doc.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getAssetCount()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        //'id_request': idCase,

      };
      var response = await Dio().post('$address/find_assets_count.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }




  Future<dynamic>getUser(idUser)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_user': idUser,

      };
      var response = await Dio().post('$address/load_user.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }


  Future<dynamic>loadMaintenanceStatus(idAsset)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_asset': idAsset

      };
      var response = await Dio().post('$address/load_maintenance_status.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>carouselFavourite(url, status)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'url': url,
        'status': status

      };
      var response = await Dio().post('$address/carousel_fav.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>carouselDelete(url)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'url': url

      };
      var response = await Dio().post('$address/carousel_delete.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>loadCarouselAll()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015'


      };
      var response = await Dio().post('$address/load_image_carousel_setting.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>loadCarouselImage()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015'


      };
      var response = await Dio().post('$address/load_image_carousel.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>loadOtherRequest(keyword)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'keyword': keyword


      };
      var response = await Dio().post('$address/load_data_other_request.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>loadImageOtherRequest(idRequest)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idRequest


      };
      var response = await Dio().post('$address/load_image_request_other.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>checkUserId(idAsset)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_asset': idAsset


      };
      var response = await Dio().post('$address/check_userId.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>setHoldMaintenance(idRequest)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idRequest


      };
      var response = await Dio().post('$address/request_it_hold.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>setContinueMaintenance(idRequest)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idRequest


      };
      var response = await Dio().post('$address/request_it_continue.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getCaseImage(idRequest)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idRequest


      };
      var response = await Dio().post('$address/load_image_case.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);


        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>confirmOtherRequest(idRequest, rating)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'id_request': idRequest,
        'rating': rating


      };
      var response = await Dio().post('$address/res_user_approve_other.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>loadTankInfo(name)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'name': name,


      };
      var response = await Dio().post('$address/tank/load_tank_info.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>updateTankInfo(val, item)async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',
        'val': val,
        'item': item


      };
      var response = await Dio().post('$address/tank/edit_tank_info.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }

  Future<dynamic>getUserLoc()async{
    try {
      Map<String, String> body = {
        'password': 'BFNMAdmin2015',



      };
      var response = await Dio().post('$address/load_user_location.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }


/*
  Future<dynamic>getNewRequestData(keyword, List pathList, file)async{
    try {
      String fileName = file.path.split('/').last;
      Map<String, dynamic> body = {
        'password': 'BFNMAdmin2015',
        'keyword': keyword,
        'id_asset': idAsset,
        "file": await MultipartFile.fromFile(file.path),

      for(int i=0; i<pathList.length; i++){
        'image$i': await MultipartFile.fromFile(pathList[i].path),
        //request.files.add(await http2.MultipartFile.fromPath('image$i', pathList[i]));
      }


      };
      var response = await Dio().post('$address/load_data_cases.php',
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response != null && response.statusCode == 200) {

        var data = jsonDecode(response.data);

        return data;

      }

    } catch (e) {
      print(e);
    }
  }


   */




}