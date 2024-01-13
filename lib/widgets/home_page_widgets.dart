import 'package:flutter/material.dart';

class HomePageWidgets {
  static Future<bool?> showExitBottomSheet(BuildContext context) async {
    return await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: buildBottomSheet(context),
        );
      },
    );
  }

  static Widget textWidgetStyles(String text) {
    return Text(
      text,
      style: const TextStyle(
        //fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Color.fromARGB(237, 255, 255, 255), fontFamily: 'Lato',
        //overflow: TextOverflow.ellipsis, // Ucinaj tekst i dodaj "..."
      ),
      textAlign: TextAlign.center,
    );
  }

  static Widget iconsStyle(var iconName) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          width: 2,
          color: const Color.fromARGB(255, 0, 0, 0),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: <Color>[
            Color(0xff556270),
            Color(0xffFF6B6B),
          ],
          tileMode: TileMode.mirror,
        ),
      ),
      child: Icon(
        iconName,
        color: const Color.fromARGB(255, 0, 0, 0),
        size: 35,
      ),
    );
  }

  static Widget buildBottomSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 24,
        ),
        Text(
          'Czy na pewno chcesz opuścić aplikacje?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Anuluj'),
            ),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Tak, zamknij'),
            ),
          ],
        ),
      ],
    );
  }

  static Future<bool> onWillPop(BuildContext context) async {
    bool? exitResult = await HomePageWidgets.showExitBottomSheet(context);
    return exitResult ?? false;
  }
}
