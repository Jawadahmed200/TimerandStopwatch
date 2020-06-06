import 'dart:async';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool started=true;
  bool stoped=true;
  int hour=0;
  int minute=0;
  int second=0;
  String timetodisplay="";
  int timefortimer;
  bool canceltimer=false;
  final dur =const Duration(seconds: 1);

  void start(){
    setState(() {
      started=false;
      stoped=false;
    });

    
    timefortimer=((hour*3600) + (minute*60)+second);
    
    Timer.periodic(dur, (Timer t){
      setState(() {
        if(timefortimer <1 || canceltimer==true){
          t.cancel();
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context)=>MyHomePage(),
          ));
        }
        else if(timefortimer <60){
        timetodisplay=timefortimer.toString();
        timefortimer=timefortimer-1;

        }
        else if(timefortimer < 3600){
        int m=timefortimer ~/60;
        int s=timefortimer -(60*m);
        timetodisplay=m.toString() + ":"+s.toString();
        timefortimer=timefortimer-1;
        }
        else
        {
        int h=timefortimer ~/ 3600;
        int t=timefortimer -(3600 *h);
        int m=t ~/60;
        int s=t-(60*m);
        timetodisplay=h.toString()+":"+m.toString()+":"+s.toString();
        timefortimer=timefortimer -1;
        }
      });
    });

  }

  void stop(){
    setState(() {
      started=true;
      stoped=true;
      canceltimer=true;
      timetodisplay="";
    });
  }
  
  Widget timer(){
    return Container(
      child: Column(children: <Widget>[
        Expanded(
          flex: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(bottom: 10.0),
                  child: Text("HH"),
                  ),
                  NumberPicker.integer(
                    initialValue: hour, 
                    minValue: 0, 
                    maxValue: 23,
                    listViewWidth: 60.0,
                    onChanged: (val){
                      setState(() {
                        hour=val;
                      }); 
                    }
                     )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(bottom: 10.0),
                  child: Text("MM"),
                  ),
                  NumberPicker.integer(
                    initialValue: minute, 
                    minValue: 0, 
                    maxValue: 59,
                    listViewWidth: 60.0,
                    onChanged: (val){
                      setState(() {
                        minute=val;
                      });
                    }
                     )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(bottom: 10.0),
                  child: Text("SS"),
                  ),
                  NumberPicker.integer(
                    initialValue: second, 
                    minValue: 0, 
                    maxValue: 59,
                    listViewWidth: 60.0,
                    onChanged: (val){
                      setState(() {
                        second=val;
                      });
                    }
                     )
                ],
              )
            ],
          )
        ),
        Expanded(
          flex: 1,
          child: Text("$timetodisplay",style: TextStyle(color: Colors.red , fontSize: 40.0, fontWeight: FontWeight.w500),)
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: started ? start : null,
                color: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                child: Text("Start", style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),),
              ),
              RaisedButton(
                onPressed: stoped ? null : stop,
                color: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                child: Text("Stop", style: TextStyle(fontSize: 20.0, color: Colors.white),),
              )
            ],
          )
        )
      ],),
    );
  }

  bool startispressed=true;
  bool stopispressed=true;
  bool resetispressed=true;
  String stoptimetodisplay="00:00:00";

  var swatch=Stopwatch();

  void starttimer(){
    Timer(dur, keeprunning);
  }

  void keeprunning(){
    if(swatch.isRunning){
      starttimer();
    }
    setState(() {
      stoptimetodisplay=swatch.elapsed.inHours.toString().padLeft(2,"0")+":"
                    +(swatch.elapsed.inMinutes%60).toString().padLeft(2,"0")+":"
                    +(swatch.elapsed.inSeconds%60).toString().padLeft(2,"0");
    });
  }

  void startstopwatch(){
    setState(() {
      stopispressed=false;
      startispressed=false;

    });
    swatch.start();
    starttimer();
  }
  void stopstopwatch(){
    setState(() {
      stopispressed=true;
    resetispressed=false;
    });
    swatch.stop();
  }
  void resetstopwatch(){
    setState(() {
      startispressed=true;
      stoptimetodisplay="00:00:00";
    });
    swatch.reset();
  }


  Widget stopwatch(){
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "$stoptimetodisplay",
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.w600

                ),
              ),

            ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(onPressed: stopispressed ? null : stopstopwatch,
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                        child: Text(
                          "Stop",
                          
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        ),
                        RaisedButton(onPressed: resetispressed ? null : resetstopwatch,
                        color: Colors.teal,
                        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                        child: Text(
                          "Reset",
                          
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(onPressed: startispressed ? startstopwatch : null,
                          color: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 20.0),
                          child: Text(
                            "Start",
                            
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  TabController tb;

  @override 
  void initState() { 
    tb=TabController(length: 2,vsync: this);
    super.initState();

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Watch"),
        centerTitle: true,
        bottom: TabBar(tabs: <Widget>[
          Text("Timer"),
          Text("Stopwatch"),
          
        ],
        labelStyle: TextStyle(
          fontSize: 20.0,
          
        ),
        labelPadding: EdgeInsets.only(bottom: 10.0),
        unselectedLabelColor: Colors.white60,
        controller: tb,
        ),
        
        
      ),
      body: TabBarView(children: <Widget>[
         timer(),
          stopwatch()
      ],controller: tb,),      
      
    );
  }
}

