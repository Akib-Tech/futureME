import 'package:flutter/material.dart';

class TextData {
  static const backgroundColor = 0xFFFEF6F2;
  static const uiHeadingColor = 0xFF2A0E5D;
  static const uiHeadingColorSmall=0xFF6D5D78;
  static const uiFontFamily = "R.font.bricolage_grotesque";
  static const uiFontFamilySmall = "R.font.rubik";
  static const grad1= 0xFF2B0B78;
  static const containerColor =0xFF8B7D92;


  static Widget customButton({
     String? content,
     double? width,
     EdgeInsets? contentPadding,
     VoidCallback? onpressed,
     Color? color,
     BorderRadius? borderRadius,
     double? fontSize,
     Color? textColor,
    }){
   return GestureDetector(
    onTap: onpressed ?? (){},
    child:  Container(
    width:  width ?? 345,
    padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    decoration: ShapeDecoration(
        color: color ?? const Color(0xFF2B0B78) /* ui-action-primary */,
        shape: RoundedRectangleBorder(
            borderRadius:borderRadius ?? BorderRadius.circular(100),
        ),
    ),
    child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
            Text(
                content ?? "",
                style: TextStyle(
                    color: textColor ?? Colors.white /* ui-text-inverse */,
                    fontSize:  fontSize ?? 16,
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

  static Widget pageName({
    double? width,
    String? content,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
    String? fontFamily,
    FontWeight? fontWeight
    }){
    return SizedBox(
    width: width ?? 345,
    child: Text(
        content ?? "",
        textAlign:textAlign ?? TextAlign.center,
        style: TextStyle(
            color: color ?? Color(uiHeadingColor) /* ui-text-heading */,
            fontSize:fontSize ?? 28,
            fontFamily: fontFamily ?? uiFontFamily,
            fontWeight: fontWeight ?? FontWeight.w600,
            height: 1.21,
        ),
    ),
);
  }

  static Widget centerText({
    String? content,
    double? width,
    Color? color,
    double? fontSize,
    String? fontFamily,
    FontWeight? fontWeight,
    }){
    return SizedBox(
    width: width ?? 345,
    child: Text(
        content ?? "",
                textAlign: TextAlign.center,
        style: TextStyle(
            color: color ?? const Color(uiHeadingColorSmall) /* ui-text-secondary */,
            fontSize:fontSize ?? 16,
            fontFamily: fontFamily ?? uiFontFamilySmall,
            fontWeight:fontWeight ?? FontWeight.w400,
            height: 1.50,
            letterSpacing: -0.16,
        ),
    ),
);
  }


  static Widget leftLightText({
    String? content,
    double? width,
    Color? color,
    double? fontSize,
    String? fontFamily,
    FontWeight? fontWeight,
    }){
    return SizedBox(
    width: width ?? 345,
    child: Text(
        content ?? "",
                textAlign: TextAlign.left,
        style: TextStyle(
            color:  color ?? const Color(uiHeadingColorSmall) /* ui-text-secondary */,
            fontSize: 16,
            fontFamily: fontFamily ?? uiFontFamilySmall,
            fontWeight: fontWeight ?? FontWeight.w400,
            height: 1.50,
            letterSpacing: -0.16,
        ),
    ),
);
  }

static Widget linkText({String? content}){
    return leftLightText(
      content: content ?? "",
       color: Color(uiHeadingColor)
    );
}

static Widget leftBoldText({String? content}){
    return leftLightText(
      content:content,
     fontWeight: FontWeight.w600);
}

 static Widget gap({double? width , double? height}){
        return SizedBox(
          height: height ?? 20,
          width: width ?? 20,
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
padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
decoration: ShapeDecoration(
color: Colors.white /* ui-surface-card */,
shape: RoundedRectangleBorder(
side: BorderSide(
width: 1,
color: const Color(0xFFE9DCD7) /* ui-border-default */,
),
borderRadius: BorderRadius.circular(14),
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

static Widget checkIconText(String text){
    
        return SizedBox(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline_outlined,
                color: Color(0xFF6D5D78),
                ),
                SizedBox(width:5),
                Expanded(
                  child:TextData.leftBoldText(content:text),
                )
                
              ],
            ),
            );
}

}