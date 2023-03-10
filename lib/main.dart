import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_flutter/models/negara.dart';
import 'package:google_sign_in_flutter/screens/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// void main() async{
//   await Hive.initFlutter();
//   final myBox = await Hive.openBox('mybox');
//   runApp(MyApp());
// }

Future<void> main() async {
  await Hive.initFlutter();
  final myBox = await Hive.openBox('mybox');
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://a047b263ee2c4752b8f4d40405fab419@o4504604965208064.ingest.sentry.io/4504631868063744';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
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
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  late Future<Negara> users;
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = false;
  bool _isLoggedIn = false;
  Map _userObj = {};


  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animationController!.repeat();
    final Box box = Hive.box('mybox');
    if(box.isNotEmpty){
      _checking = true;
    }
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
        if(_currentUser!=null){
          
          box.put('email', _currentUser!.email);
          box.put('nama', _currentUser!.displayName);
          box.put('login', 'google');
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
          //print(box.values);
        }
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }


  // _login() async {
  //   final LoginResult result = await FacebookAuth.instance.login();

  //   if (result.status == LoginStatus.success) {
  //     _accessToken = result.accessToken;

  //     final userData = await FacebookAuth.instance.getUserData();
  //     _userData = userData;
  //   } else {
  //     print(result.status);
  //     print(result.message);
  //   }
  //   setState(() {
  //     _checking = false;
  //   });
  // }

  // _logout() async {
  //   await FacebookAuth.instance.logOut();
  //   _accessToken = null;
  //   _userData = null;
  //   setState(() {});
  // }

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
        title: Text(_checking != false ? 'To Do List App' : 'Login'),
        //title: Text('Google Sign In'),
        elevation: 0.5,
        centerTitle: true,
      ),
      body: 
      _checking != false?
        _checking != false? Home() : const MyHomePage()
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
            SizedBox(height: 100, width: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
              margin: EdgeInsets.only(top: 100, left: 30, right: 30),
              
              child: Shimmer.fromColors(
                child: Image.network("https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png"), 
                baseColor: Colors.blueAccent, 
                highlightColor: Colors.grey[300]!)
              
            ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 55, bottom: 20, right: 20, left: 20),
                  child: TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
                      hintText: 'Input Name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      //border: InputBorder.,
                      hintStyle: TextStyle(color: Colors.grey)
                    ),
                  ),
                ),SizedBox(height: 10,),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20, right: 20, left: 20),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
                      hintText: 'Input Email',
                      filled: true,
                      fillColor: Colors.white,
                      //border: InputBorder.none,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      hintStyle: TextStyle(color: Colors.grey)
                    ),
                  ),
                ), 
                Container(
                  // margin: const EdgeInsets.only(
                  //   bottom: 20, right: 20, left: 20),
                  child: ElevatedButton(
                    onPressed: (){
                      final Box box = Hive.box('mybox');
                      box.put('nama', namaController.text);
                      box.put('email', emailController.text);
                      box.put('login', 'email');
                      namaController.clear();
                      emailController.clear();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                    }, 
                    child: const Text('Login', style: TextStyle(fontSize: 18),),
                  ),
                ),
                SizedBox(height: 45, child: Text('or via',),),
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: ElevatedButton.icon(
                        onPressed: (() async{
                          await _handleSignIn();
                        }), 
                        icon: Image.network("https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png", height: 20, width: 20,),
                        label: Text('Sign in with google', style: TextStyle(fontSize: 18, color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 60, right: 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            FacebookAuth.instance.login(
                            permissions: ["public_profile", "email"]).then((value){
                              FacebookAuth.instance.getUserData().then((userData) async{
                                setState(() {
                                  _isLoggedIn = true;
                                  _userObj = userData;  
                                          // print("login $_userObj['email']"); 
                                          // print(_userObj["email"]);
                                  final Box box = Hive.box('mybox');
                                  box.put('nama', _userObj["name"]);
                                  box.put('email', _userObj["email"]);
                                  box.put('login', 'facebook');
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                                });
                              });
                            });
                          } catch (exception, stackTrace) {
                            await Sentry.captureException(
                              exception,
                              stackTrace: stackTrace,
                            );
                          }
                          // FacebookAuth.instance.login(
                          //   permissions: ["public_profile", "email"]).then((value){
                          //     FacebookAuth.instance.getUserData().then((userData) async{
                          //       setState(() {
                          //         _isLoggedIn = true;
                          //         _userObj = userData;  
                          //           // print("login $_userObj['email']"); 
                          //           // print(_userObj["email"]);
                          //         final Box box = Hive.box('mybox');
                          //         box.put('nama', _userObj["name"]);
                          //         box.put('email', _userObj["email"]);
                          //         box.put('login', 'facebook');
                          //         Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                          //       });
                          //     });
                          // });
                        }, 
                        icon: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/768px-2021_Facebook_icon.svg.png", height: 20,width: 20,),
                        label: Text('Sign in with Facebook', style: TextStyle(fontSize: 18, color: Colors.black),),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: EdgeInsets.only(top: 10, bottom: 10, right: 50, left: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => LinkedInUserWidget(
                                  appBar: AppBar(
                                    title: Text('OAuth User'),
                                  ),
                                  //destroySession: logoutUser,
                                  redirectUrl: 'https://youtube.com/callback',
                                  clientId: '86im5gggdfm1xo',
                                  clientSecret: 'bmBtJrCUmPyN3Nj0',
                                  projection:  [
                                    ProjectionParameters.id,
                                    ProjectionParameters.localizedFirstName,
                                    ProjectionParameters.localizedLastName,
                                    ProjectionParameters.firstName,
                                    ProjectionParameters.lastName,
                                    ProjectionParameters.profilePicture,
                                  ], 
                                  onGetUserProfile:
                                      (UserSucceededAction linkedInUser) {
                                            final Box box = Hive.box('mybox');
                                            box.put('nama', linkedInUser.user.firstName!.localized!.label);
                                            box.put('email', linkedInUser!.user!.email!.elements![0]!.handleDeep!.emailAddress);
                                            //     email: linkedInUser ?.email?.elements[0]?.handleDeep?.emailAddress,
                                            box.put('login', 'linkedIn');
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                                  },
                                  onError: (UserFailedAction e) {
                                  },
                                ),
                                fullscreenDialog: true,
                              ),
                          );
                        }, 
                        icon: Image.network("https://cdn-icons-png.flaticon.com/512/174/174857.png", height: 20,width: 20,),
                        label: Text('Sign in with LinkedIn', style: TextStyle(fontSize: 18, color: Colors.black),),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: EdgeInsets.only(top: 10, bottom: 10, right: 50, left: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                      ),
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