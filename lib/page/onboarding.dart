import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:stgrowgrow/page/welcome.dart';



class onboarding extends StatelessWidget{



  List<PageViewModel>getPages(){
    return [
      PageViewModel(
        image: Center(child: Image.asset("images/secretary.png",height: 175.0)
        ),
        title: "First page",
        body: '당신의 포트폴리오를 작성해보세요',
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(color: Colors.orange),
          bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
        ),
      ),

      PageViewModel(
        image: Center(child: Image.asset("images/relationship.png",height: 175.0)
        ),
        title: "Second page",
        body: '영감을 주는 사람들과 교류하세요',
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(color: Colors.orange),
          bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
        ),
      ),

      PageViewModel(
        image: Center(child: Image.asset("images/support.png",height: 175.0)
        ),
        title: "Third page",
        body: '새로운 프로젝트를 같이 만들어나가요',
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(color: Colors.orange),
          bodyTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: IntroductionScreen(
            done: Text(
              'Done',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            skip: Text('skip',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onDone: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (_)=> Welcomepage(),
              ),);
            },
            onSkip:(){
              Navigator.push(context, MaterialPageRoute(
                builder: (_)=> Welcomepage() ,
              ),);



            } ,
            next:Text('next',
              style: TextStyle(
                color: Colors.black,
              ) ,
            ),

            pages: getPages(),
            globalBackgroundColor: Colors.white,
            showSkipButton: true,
            dotsDecorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),


            ),

          )
      ),

    );
  }

}