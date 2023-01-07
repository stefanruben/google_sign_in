import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_flutter/screens/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shimmer/shimmer.dart';

void main() async{
  await Hive.initFlutter();
  final myBox = await Hive.openBox('mybox');
  runApp(MyApp());
}

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  //final Box box = Hive.box('mybox');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Sign In',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  GoogleSignInAccount? _currentUser;
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animationController!.repeat();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
        if(_currentUser!=null){
          print(_currentUser!.email);
          final Box box = Hive.box('mybox');
          box.put('email', _currentUser!.email);
          //print(box.values);
        }
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      if (kDebugMode) {
        print("error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: Text(_currentUser != null ? 'To Do List App' : 'Login'),
        //title: Text('Google Sign In'),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: 
      _currentUser != null?
        _currentUser != null? Home(nama: _currentUser!.email) : const MyHomePage()
      
          : 
          
        Stack(
          children: [
            //mainAxisAlignment: MainAxisAlignment.center
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
              child: const Text('Welcome to To Do Apps', style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),),
            ),
            SizedBox(height: 10, width: 10,
              
              // child: 
              //   Image.network("https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png"),
               
            ), 
            Container(
              margin: EdgeInsets.only(top: 150, left: 30, right: 30),
              
              child: Shimmer.fromColors(
                child: Image.network("https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png"), 
                baseColor: Colors.blueAccent, 
                highlightColor: Colors.grey[300]!)
              
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width:20,
                        child: ElevatedButton.icon(
                          label: const Text('Sign in with google', style: TextStyle(fontSize: 18),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, elevation: 20, minimumSize: const Size(50, 50), 
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder( //to set border radius to button
                                borderRadius: BorderRadius.circular(30)
                            ),
                          ),
                          onPressed: (() async {
                            await _handleSignIn();
                            
                          }), 
                          icon: Image.network("https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png", height: 20, width: 20,),
                           
                        ),
                      )
                    )
                  ],
                ),
                
              ],
            )
          ],
        )
        
    );
  }
}