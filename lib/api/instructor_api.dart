import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/tourist_api.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

import '../model/route.dart';

class InstructorApi {
  static final _crudApi = BaseCRUDApi(
      singleApiName: "tourist",
      multiApiName: "tourists",
      toMap: TouristApi.toMap,
      fromJSON: TouristApi.fromJSON);

  InstructorApi._internal();

  factory InstructorApi() {
    return InstructorApi._internal();
  }

  Future<List<Tourist>?> getAll() async {
    return _crudApi.getAllByUrl("search/instructors");
  }

  Future<List<Tourist>?> getAllTrainers() async {
    return _crudApi.getAllByUrl("search/instructors/trainers");
  }

  Future<List<Tourist>?> getAllSportsmen() async {
    return _crudApi.getAllByUrl("search/instructors/sportsmen");
  }

  Future<List<Tourist>?> findAllCandidates() async {
    return _crudApi.getAllByUrl("search/instructors/candidates");
  }

  Future<List<Tourist>?> findByRoutes({required List<RouteTrip> routes}) async {
    String ids = routes
        .sublist(1)
        .fold(routes[0].id.toString(), (prev, curr) => "$prev,${curr.id}");
    return _crudApi.getAllByUrl('search/instructors/routes?routeIds=$ids');
  }

  Future<List<Tourist>?> findByTripsCount(int tripsCount) async {
    return _crudApi
        .getAllByUrl("search/instructors/byTripsCount?value=$tripsCount");
  }

  Future<List<Tourist>?> findByTripId(int tripId) async {
    return _crudApi.getAllByUrl("search/instructors/trip/$tripId");
  }

  Future<List<Tourist>?> findByPlaceId(int placeId) async {
    return _crudApi.getAllByUrl("search/instructors/place/$placeId");
  }

  Future<List<Tourist>?> findBySkillCategory(SkillCategory category) async {
    return _crudApi.getAllByUrl(
        "search/instructors/category/${category.string.toUpperCase()}");
  }
}
