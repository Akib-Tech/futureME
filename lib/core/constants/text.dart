import 'package:flutter/material.dart';

class TextData {
  static const backgroundColor = 0xFFFEF6F2;
  static const uiHeadingColor = 0xFF2A0E5D;
  static const uiHeadingColorSmall=0xFF6D5D78;
  static const uiFontFamily = "R.font.bricolage_grotesque";
  static const uiFontFamilySmall = "R.font.rubik";
  static const grad1= 0x2B0B78;


  static Widget customButton({required String content,required VoidCallback onpressed}){
   return GestureDetector(
    onTap: onpressed,
    child:  Container(
    width: 345,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    decoration: ShapeDecoration(
        color: const Color(0xFF2B0B78) /* ui-action-primary */,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
        ),
    ),
    child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
            Text(
                content,
                style: TextStyle(
                    color: Colors.white /* ui-text-inverse */,
                    fontSize: 16,
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                ),
            ),
        ],
    ),
)
   );

  }

  static Widget pageName(String content){
    return SizedBox(
    width: 345,
    child: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: const Color(0xFF2A0E5D) /* ui-text-heading */,
            fontSize: 28,
            fontFamily: 'Bricolage Grotesque',
            fontWeight: FontWeight.w600,
            height: 1.21,
        ),
    ),
);
  }

  static Widget centerText(String content){
    return SizedBox(
    width: 345,
    child: Text(
        content,
                textAlign: TextAlign.center,
        style: TextStyle(
            color: const Color(0xFF6D5D78) /* ui-text-secondary */,
            fontSize: 16,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w400,
            height: 1.50,
            letterSpacing: -0.16,
        ),
    ),
);
  }

 static Widget gap(double? width , double? height){
        return SizedBox(
          height: height,
          width: width,
        );
 }

  static Widget tagText(String content){
    return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
    decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
        ),
    ),
    child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
            Text(
                 content,
                style: TextStyle(
                    color: const Color(0xFF2B0B78) /* ui-action-secondaryText */,
                    fontSize: 16,
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                ),
            ),
        ],
    ),
);
  } 

static Widget generalText(String? content){
  return  Text(content!,
  style: TextStyle(
color: const Color(0xFF211431) /* ui-text-primary */,
fontSize: 16,
fontFamily: 'Rubik',
fontWeight: FontWeight.w400,
height: 1.38,
));
}

  static Widget roundedContainer(List<Widget>? contents){
      return Container(
width: double.infinity,
padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
decoration: ShapeDecoration(
color: Colors.white /* ui-surface-card */,
shape: RoundedRectangleBorder(
side: BorderSide(
width: 1,
color: const Color(0xFFE9DCD7) /* ui-border-default */,
),
borderRadius: BorderRadius.circular(32),
),
shadows: [
BoxShadow(
color: Color(0x59CFB2A4),
blurRadius: 8,
offset: Offset(0, 4),
spreadRadius: 0,
)
],
),
child: Column(children: contents ?? [ Text("")])
  
  );
  
}

}