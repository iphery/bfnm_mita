import 'package:flutter/foundation.dart';
import 'package:mita/api_service.dart';
import 'package:mita/model/assets.dart';
import 'package:mita/model/carousel_image.dart';
import 'package:mita/dio_service.dart';


class AssetProvider with ChangeNotifier{

  Assets asset;
  String category;
  String picture;
  String selectedIdCase;
  String selectedIdAsset;
  String selectedIdCaseOther;
  dynamic data;
  dynamic userData;
  String userLevel;
  String userName;
  String userDivisi;
  dynamic carouselUrl;
  dynamic carouselImages;
  dynamic otherRequest;
  dynamic caseImage;


DioService dioService = DioService();
  ApiService service = ApiService();
  List<CarouselImage> carouselImageList = [];
  List<Assets> assetPreviewList = [];
  List<Assets> assetPreviewListAll = [];
  // List<CaseImage> casesImageList = [];



  getPictureChecked(linkUrl){
    this.picture = linkUrl;
    notifyListeners();
  }

  getSelectedAsset(asset){
    this.asset = asset;

    notifyListeners();
  }

  getSelectedIdCase(id){
    this.selectedIdCase = id;
    notifyListeners();

  }

  getSelectedIdCaseOther(id){
    this.selectedIdCaseOther = id;
    notifyListeners();
  }

  getSelectedIdAsset(id){
    this.selectedIdAsset = id;
    notifyListeners();
  }



  getSelectedCategory(category){
    this.category = category;
    notifyListeners();
  }

  getUserLevel(level){
    this.userLevel = level;
    notifyListeners();
  }

  getUserName(name){
    this.userName = name;
    notifyListeners();
  }

  getUserDivisi(divisi){
    this.userDivisi = divisi;
    notifyListeners();
  }

  Future loadUser(idUser) {

    var data =dioService.getUser(idUser);
    data.then((value) {
      this.userData = value;
      notifyListeners();
    });
    return data;
  }

  Future loadCarouselImages() {

    var data =dioService.loadCarouselImage();
    data.then((value) {
      this.carouselImages = value;
      notifyListeners();
    });
    return data;
  }



  Future loadOtherRequest(keyword){
    var data =dioService.loadOtherRequest(keyword);
    data.then((value) {
      this.otherRequest = value;
      notifyListeners();
    });
    return data;
  }



  /*
  Future loadCarouselImage() {
    Future<List<CarouselImage>> futureCarouselImage = service.getCarouselImage();
    futureCarouselImage.then((carouselImage) {

        this.carouselImageList = carouselImage;
        notifyListeners();

    });
    return futureCarouselImage;
  }


   */
  /*
  Future loadUserImage(idAsset) {
    Future<List<UserImage>> futureUserImage = service.getUserImage(idAsset);
    futureUserImage.then((userImage) {

      this.userImageList = userImage;
      notifyListeners();

    });
    return futureUserImage;
  }

  Future loadList(keyword, category) {
    Future<List<Assets>> futureAssets = service.getAssetsPreviewCategory(keyword, category);
    futureAssets.then((assetsList) {

        this.assetPreviewList = assetsList;
        notifyListeners();

    });
    return futureAssets;
  }

  Future loadListAll(category) {
    Future<List<Assets>> futureAssets = service.getAssetsPreview(category);
    futureAssets.then((assetsList) {

      this.assetPreviewListAll = assetsList;
      notifyListeners();

    });
    return futureAssets;
  }

  Future loadCaseList(id_asset, keyword) {
    Future<List<Cases>> futureCases = service.getCasesPreview(id_asset, keyword);
    futureCases.then((casesList) {

        this.casesPreviewList = casesList;
        notifyListeners();

    });
    return futureCases;
  }

   */

/*

  Future loadCaseImage(idCase){
    var data =dioService.getCaseImage(idCase);
    data.then((value) {
      this.caseImage = value;

      notifyListeners();
    });

    return data;
  }


  Future loadChecklist(id_case){
    Future<List<Checklist>> futureChecklist = service.getChecklist(id_case);
    futureChecklist.then((checkList) {

      this.checkListList = checkList;
      notifyListeners();

    });
    return futureChecklist;
  }

  Future loadMaintenanceStatus(id_asset) {
    Future<List<MaintenanceStatus>> futureMaintenanceStatus = service.getMaintenanceStatus(id_asset);
    futureMaintenanceStatus.then((maintenanceStatus) {

        this.maintenanceStatusList = maintenanceStatus;
        notifyListeners();

    });
    return futureMaintenanceStatus;
  }

  Future loadCaseDetail(id_case) {
    Future<List<CaseDetail>> futureCaseDetail = service.getCaseDetail(id_case);
    futureCaseDetail.then((caseDetail) {

        this.casesDetailList = caseDetail;
      notifyListeners();
    });
    return futureCaseDetail;
  }

  Future loadCaseDetails(idCase){
    var data =dioService.getCaseDetail(idCase);
    data.then((value) {
      this.data = value;
      notifyListeners();
    });
    return data;
  }


 */
  Future loadCarouselAll(){
    var data =dioService.loadCarouselAll();
    data.then((value) {
      this.carouselUrl = value;
      notifyListeners();
    });
    return data;
  }










}