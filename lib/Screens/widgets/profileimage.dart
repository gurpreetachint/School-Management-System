import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String routeName;
  final String imgSrc;
  final String heading;
  final String subHeading;

  const ProfileCard(
      {Key? key,
      this.routeName = '/home',
      this.imgSrc = 'cards.png',
      this.heading = 'Heading',
      this.subHeading = 'SubHeading'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // overlayColor: MaterialStateProperty.all(Colors.cyan),
      focusColor: Colors.white,
      borderRadius: BorderRadius.circular(24),
      splashColor: Colors.white,
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width * 0.12,
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // gradient: RadialGradient(colors: const [Colors.transparent, Colors.purpleAccent]),
            image: DecorationImage(
                image: AssetImage('assets/images/$imgSrc'),
                fit: BoxFit.cover,
                opacity: 0.8),

          ),
        ),
      ),
    );
  }
}
