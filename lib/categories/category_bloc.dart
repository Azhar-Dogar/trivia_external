import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/category_model.dart';
import '../models/game_model2.dart';
import '../models/tap_model.dart';
import 'category_state.dart';

class CategoryBloc extends Cubit<CategoryState> {
  CategoryBloc()
      : super((CategoryState(
    isStart: false,
            categories: const [],
            testCategories: const [],
            jumpingCategories: const [],
            bottomPosition: 0,
            tapResults: const [],
            currentGame: null,
            leftPosition: 0, finalCategories: []))) {
    getNGames();
    getTapResults();
    getCategories();
  }

  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");
  CollectionReference games = FirebaseFirestore.instance.collection("newGames");

  Future<void> getCategories() async {
    categoriesStream = categories.snapshots().listen((event) {
      List<CategoryModel> categories = [];
      for (var element in event.docs) {
        categories.add(
            CategoryModel.fromJson(element.data() as Map<String, dynamic>));
      }
      List<CategoryModel> gameCategories = [];
      if(state.currentGame != null){
        for (var element in categories) {
        if(state.currentGame!.categories.contains(element.id)){
          gameCategories.add(element);
        }
      }}
      List<CategoryModel> tempList = [];
      for (var element in gameCategories) {
        List<TapModel> catTaps = state.tapResults
            .where((element1) => element.id == element1.categoryId)
            .toList();
        int taps = 0;
        for (var element in catTaps) {
          taps = element.tapCount;
        }
        CategoryModel tempCat = element;
        tempCat.tapCount = taps;
        tempList.add(tempCat);
      }
      emit(state.copyWith(testCategories: tempList,categories: gameCategories));
     state.testCategories.forEach((element) {
       print(element.tapCount);
       print("get categories");
     });
    });
  }

  manageCategories(List<TapModel> tapResults) async {
    print("in manage");
    List<CategoryModel> tempList = [];
    for (var element in state.categories) {
      List<TapModel> catTaps = tapResults
          .where((element1) => element.id == element1.categoryId)
          .toList();
      int taps = 0;
      for (var element in catTaps) {
        taps = element.tapCount;
      }
      CategoryModel tempCat = element;
      tempCat.tapCount = taps;
      tempList.add(tempCat);
    }
    emit(state.copyWith(testCategories: tempList));
    print(tempList.first.tapCount);
  }

  categoriesAnimation(List<CategoryModel> categories) async {
    emit(state.copyWith(isStart: true));
     categories.forEach((element) async {
      print(element.tapCount);
      print("element taps");
        CategoryModel? tempModel = state.jumpingCategories
          .where((jumpCat) => element.id == jumpCat.id)
          .firstOrNull;
      int diff = element.tapCount;
      if (tempModel != null) {
        diff = element.tapCount - tempModel.tapCount;
        }
      double percentValue = diff / 6;
      for (var e = 0; e < 6; e++) {
        state.finalCategories
            .removeWhere((element1) => element1.id == element.id);
      List<CategoryModel> fTemp = state.finalCategories;
        CategoryModel fModel = element;
        if (tempModel != null) {
          fModel.tapCount =
              (tempModel.tapCount + percentValue * (e + 1)).toInt();
          } else {
          fModel.tapCount = (percentValue * (e + 1)).toInt();
        }
        fTemp.add(fModel);
        await Future.delayed(const Duration(milliseconds: 100));
        if (e > 2) {
          emit(state.copyWith(
            bottomPosition: state.bottomPosition - 3,finalCategories: fTemp
          ));
        } else {
          emit(state.copyWith(
            bottomPosition: state.bottomPosition + 3,finalCategories: fTemp
          ));
        }
      }
    }
    );
    emit(state.copyWith(jumpingCategories: state.testCategories));
  // }
  }
  StreamSubscription<DocumentSnapshot<Object?>>? gameStream;
  StreamSubscription<QuerySnapshot<Object?>>? categoriesStream;
  StreamSubscription<QuerySnapshot<Object?>>? tapStream;
  CollectionReference newGames =
  FirebaseFirestore.instance.collection("newGames");

  void getNGames() async {
    gameStream = newGames.doc("Ag5qPTkx2NJanYP0P6Xq").snapshots().listen((element) async {
      GameModel2? gameModel;
      if(element.exists){
        gameModel = GameModel2.fromMap(element.data() as Map<String,dynamic>);
      }
      emit(state.copyWith(currentGame: gameModel));
      // if(state.currentGame != null && !state.isStart){
      //   categoriesAnimation();
      // }
    });
  }
  CategoryModel getCategoryByID(String id) {
    return state.categories.where((element) => element.id == id).first;
  }
  getTapResults() async {
   tapStream = games
        .doc("Ag5qPTkx2NJanYP0P6Xq")
        .collection("tapResults")
        .snapshots()
        .listen((event) async {
         await Future.delayed(const Duration(seconds: 5));
      List<TapModel> tapResults = [];
      for (var element in event.docs) {
       tapResults.add(TapModel.fromJson(element.data()));
      }
      List<CategoryModel> temp = getCatTaps(tapResults);
      emit(state.copyWith(tapResults: tapResults,testCategories: temp));
      // if(!state.isStart)
      categoriesAnimation(temp);
    });
  }
  List<CategoryModel> getCatTaps(List<TapModel> tapsList){
    List<CategoryModel> tempList = [];
    for (var element in state.categories) {
      List<TapModel> catTaps = tapsList
          .where((element1) => element.id == element1.categoryId)
          .toList();
      int taps = 0;
      for (var element in catTaps) {
        taps = element.tapCount;
      }
      CategoryModel tempCat = element;
      tempCat.tapCount = taps;
      tempList.add(tempCat);
    }
    return tempList;
  }

 cancelStreams(){
    gameStream?.cancel();
    categoriesStream?.cancel();
    tapStream?.cancel();
 }
}
