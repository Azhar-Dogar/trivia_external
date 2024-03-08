import 'package:equatable/equatable.dart';

import '../../models/category_model.dart';
import '../models/game_model2.dart';
import '../models/tap_model.dart';

class CategoryState extends Equatable {
  GameModel2? currentGame;
  List<TapModel> tapResults;
  List<CategoryModel> categories;
  List<CategoryModel> jumpingCategories;
  List<CategoryModel> finalCategories;
  late double bottomPosition;
  late double leftPosition;
  bool isStart;

  CategoryState(
      {required this.isStart,
      required this.currentGame,
      required this.tapResults,
      required this.categories,
      required this.finalCategories,
      required this.jumpingCategories,
      required this.leftPosition,
      required this.bottomPosition});

  CategoryState copyWith({
    bool? isStart,
    List<CategoryModel>? categories,
    List<CategoryModel>? testCategories,
    List<CategoryModel>? jumpingCategories,
    List<CategoryModel>? finalCategories,
    double? bottomPosition,
    GameModel2? currentGame,
    List<TapModel>? tapResults,
    double? leftPosition,
  }) {
    return CategoryState(
        isStart: isStart ?? this.isStart,
        tapResults: tapResults ?? this.tapResults,
        finalCategories: finalCategories ?? this.finalCategories,
        bottomPosition: bottomPosition ?? this.bottomPosition,
        currentGame: currentGame ?? this.currentGame,
        leftPosition: leftPosition ?? this.leftPosition,
        categories: categories ?? this.categories,
        jumpingCategories: jumpingCategories ?? this.jumpingCategories);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        categories,
        currentGame,
        leftPosition,
        tapResults,
        isStart,
        finalCategories,
        bottomPosition,
        jumpingCategories
      ];
}
