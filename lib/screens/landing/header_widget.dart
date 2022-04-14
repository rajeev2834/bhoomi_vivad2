import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../utils/size_config.dart';

class HeaderWidget extends StatelessWidget {
  double _height = 31 * SizeConfig.heightMultiplier;

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.widthMultiplier * 100;
    return Container(
      child: Stack(
        children: <Widget>[
          ClipPath(
            child: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.4),
                      Theme.of(context).primaryColorLight.withOpacity(0.4),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            clipper: new ShapeClipper([
              Offset(width / 5, _height),
              Offset(width / 10 * 5,
                  _height - (7.5 * SizeConfig.heightMultiplier)),
              Offset(
                  width / 5 * 4, _height + (2.5 * SizeConfig.heightMultiplier)),
              Offset(width, _height - (2.25 * SizeConfig.heightMultiplier))
            ]),
          ),
          ClipPath(
            child: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.4),
                      Theme.of(context).primaryColorLight.withOpacity(0.4),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            clipper: new ShapeClipper([
              Offset(width / 3, _height + (2.5 * SizeConfig.heightMultiplier)),
              Offset(width / 10 * 8,
                  _height - (7.5 * SizeConfig.heightMultiplier)),
              Offset(
                  width / 5 * 4, _height - (7.5 * SizeConfig.heightMultiplier)),
              Offset(width, _height - (2.5 * SizeConfig.heightMultiplier))
            ]),
          ),
          ClipPath(
            child: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorLight,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            clipper: new ShapeClipper([
              Offset(width / 5, _height),
              Offset(width / 2, _height - (5 * SizeConfig.heightMultiplier)),
              Offset(
                  width / 5 * 4, _height - (10 * SizeConfig.heightMultiplier)),
              Offset(width, _height - (2.5 * SizeConfig.heightMultiplier))
            ]),
          ),
          Visibility(
            visible: true,
            child: Container(
              height: _height - (5 * SizeConfig.heightMultiplier),
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 2.5 * SizeConfig.heightMultiplier,
                  ),
                  padding: EdgeInsets.only(
                    left: 5.0,
                    top: 2.5 * SizeConfig.heightMultiplier,
                    right: 5.0,
                    bottom: 2.5 * SizeConfig.heightMultiplier,
                  ),
                  child: Image.asset(
                    'assets/images/BhoomiBank.png',
                    width: 15 * SizeConfig.heightMultiplier,
                    height: 15 * SizeConfig.heightMultiplier,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  List<Offset> _offsets = [];

  ShapeClipper(this._offsets);

  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height - (2.5 * SizeConfig.heightMultiplier));

    // path.quadraticBezierTo(size.width/5, size.height, size.width/2, size.height-40);
    // path.quadraticBezierTo(size.width/5*4, size.height-80, size.width, size.height-20);

    path.quadraticBezierTo(
        _offsets[0].dx, _offsets[0].dy, _offsets[1].dx, _offsets[1].dy);
    path.quadraticBezierTo(
        _offsets[2].dx, _offsets[2].dy, _offsets[3].dx, _offsets[3].dy);

    // path.lineTo(size.width, size.height-20);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
