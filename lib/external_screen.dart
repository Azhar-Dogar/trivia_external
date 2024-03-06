import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_external/categories/category_bloc.dart';
import 'package:trivia_external/categories/category_state.dart';
import 'package:trivia_external/models/category_model.dart';
import 'package:trivia_external/models/tap_model.dart';
import 'package:utility_extensions/extensions/context_extensions.dart';

class ExternalScreen extends StatefulWidget {
  const ExternalScreen({super.key});

  @override
  State<ExternalScreen> createState() => _ExternalScreenState();
}

class _ExternalScreenState extends State<ExternalScreen> {
  late double width, height;
  double? bottomPosition;
  double? leftPosition;
  bool isJumping = false;
  late CategoryState categoryState;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    context.read<CategoryBloc>().cancelStreams();
  }

  @override
  Widget build(BuildContext context) {
    width = context.width;
    height = context.height;
    bottomPosition ??= 20;
    leftPosition ??= width * 0.01;
    return Scaffold(
      // floatingActionButton: ElevatedButton(
      //     onPressed: () {
      //       if (!isJumping) {
      //         jumpFunction();
      //       }
      //     },
      //     child: const Text("Jump")),
      body: BlocBuilder<CategoryBloc, CategoryState>(
          buildWhen: (previous, current) => previous != current,
          builder: (BuildContext context, catState) {
            categoryState = catState;
            // List<CategoryModel> gameCategories = [];
            // if (catState.currentGame != null) {
            //   for (var element in catState.currentGame!.categories) {
            //     CategoryModel? categoryModel = catState.categories
            //         .where((element1) => element == element1.id)
            //         .firstOrNull;
            //     if (categoryModel != null) {
            //       gameCategories.add(categoryModel);
            //     }
            //   }
            // }
            return (categoryState.currentGame != null)
                ? Column(
                    children: [
                      Stack(children: [
                        Column(
                          children: [
                            const Image(
                                image:
                                    AssetImage("assets/images/background.png")),
                            Image(
                              image:
                                  const AssetImage("assets/images/track.png"),
                              width: width,
                              height: 200,
                              fit: BoxFit.fitHeight,
                            )
                          ],
                        ),
                        if (categoryState
                            .currentGame!.categories.isNotEmpty) ...[
                          for (var e = 0;
                              e < categoryState.currentGame!.categories.length;
                              e++)
                            character(
                                catState.bottomPosition + e * 100,
                                categoryState.currentGame!.categories[e],
                                "assets/images/char_1.png")
                        ]
                      ]),
                      Expanded(
                        child: Container(
                          color: const Color(0xff009145),
                        ),
                      )
                    ],
                  )
                : const CircularProgressIndicator();
          }),
    );
  }

  Widget character(double bottomPosition, String e, String image) {
    CategoryModel? categoryModel = categoryState.finalCategories
        .where((element) => element.id == e)
        .firstOrNull;
    // print(categoryModel.tapCount);
    return AnimatedPositioned(
        duration: const Duration(milliseconds: 50),
        bottom: bottomPosition,
        left: (categoryModel != null) ? categoryModel.tapCount.toDouble() : 0,
        // transform: M,
        child: const Image(
          image: AssetImage("assets/images/char_1.png"),
          width: 30,
        ));
  }
}
