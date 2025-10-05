import 'package:english_learning_app/models/course_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    Key? key,
    required this.course,
  }): super(key: key);
  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: (){
      //   Get.toNamed('/song', arguments: song);
      // },

      child: Container(
        margin: EdgeInsets.only(right: 10),
        child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: MediaQuery.of(context).size.width* 0.45,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(course.courseImage),
                        fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.circular(16.0)
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.37,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0.0)
                ),

              ),
            ]
        ),
      ),
    );
  }

}