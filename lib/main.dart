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
      // ListTile(
      //         leading: GoogleUserCircleAvatar(identity: _currentUser!),
      //         title: Text(_currentUser!.displayName ?? ''),
      //         subtitle: Text(_currentUser!.email),
      //         trailing: IconButton(
      //           icon: Icon(Icons.logout_outlined),
      //           onPressed: () async {
      //             try {
      //               await _googleSignIn.disconnect();
      //             } catch (error) {
      //               if (kDebugMode) {
      //                 print(error);
      //               }
      //             }
                  
      //           },
      //         ),
      //       )
          : 
          // Container(
          //     alignment: Alignment.bottomCenter,
          //     child: ElevatedButton(
          //         onPressed: ()  {
          //           //await _handleSignIn();
          //           Navigator.push(context, MaterialPageRoute(builder: (context){
          //               return Home();
          //           }));
          //         },
          //         child: Text('Sign In')),
          //   ),

          // Container(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.stretch,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       TextButton.icon(
          //         onPressed: () {
          //           Navigator.push(context, MaterialPageRoute(builder: (context){
          //               return Home();
          //           }));
          //         }, 
          //         icon: const Icon(Icons.login),
          //         label: Text('Sign In with Google')
          //       ),
          //       FloatingActionButton.extended(
          //         onPressed: () {
          //           Navigator.push(context, MaterialPageRoute(builder: (context){
          //               return Home();
          //           }));
          //           print("google");
          //         }, 
          //         label:  Text('Sign In with Google'), 
          //         backgroundColor: Colors.white,
          //         foregroundColor: Colors.black,
          //       ),SizedBox(height: 10),
          //       FloatingActionButton.extended(
          //         onPressed: () {
          //           print("yahoo");
          //         }, 
          //         label: Text('Sign in with Yahoo'),
          //         backgroundColor: Colors.white,
          //         foregroundColor: Colors.black,
          //       ), SizedBox(height: 10),
          //       FloatingActionButton.extended(
          //         onPressed: () {
                    
          //         }, 
          //         label: Text('Sign in with GitHub'),
          //         backgroundColor: Colors.white,
          //         foregroundColor: Colors.black,
          //       ), SizedBox(height: 10),
          //       FloatingActionButton.extended(
          //         onPressed: () {
                    
          //         }, 
          //         label: Text('Sign in with Facebook'),
          //         backgroundColor: Colors.white,
          //         foregroundColor: Colors.black,
          //       ), SizedBox(height: 10),
          //     ],
          //   ),
          // ),
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
              //padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
              // decoration: BoxDecoration(
              //   //border: Border.all(width: 0.03, color: Colors.white)
              //   //color: Colors.transparent,
              //   // boxShadow: [BoxShadow(
              //   //   color: Colors.white,
              //   //   blurRadius: 15,
              //   //   spreadRadius: 10
              //   // )]
              //   boxShadow: [
              //     BoxShadow(
              //       color: Color(0xFF000000).withAlpha(60),
              //       blurRadius: 6.0,
              //       spreadRadius: 0.0,
              //       offset: Offset(
              //         0.0,
              //         3.0,
              //       ),
              //     ),
              //   ],
              //   // gradient: LinearGradient(
              //   //   colors: [Colors.transparent, Colors.white, Colors.transparent],
              //   //   stops: [0.0, 0.7, 1.0]
              //   // ),
              // ),
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
                            //final box = Hive.
                            // var nama = _currentUser!.displayName;
                            // print(nama);
                            //_googleSignIn.disconnect();
                            // Navigator.push(context, MaterialPageRoute(builder: (context){
                            //   return Home(nama: nama,);
                            // }));
                          }), 
                          icon: Image.network("https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-suite-everything-you-need-know-about-google-newest-0.png", height: 20, width: 20,),
                           
                        ),
                      )
                    )
                  ],
                ),
                // SizedBox(
                //   height: 10
                // ),
                // Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: Container(
                //         child: ElevatedButton(
                //           onPressed: (() async{
                //             await _handleSignIn();
                //             // var nama = _currentUser!.displayName;
                //             // await _googleSignIn.disconnect();
                //             // // ignore: use_build_context_synchronously
                //             // Navigator.push(context, MaterialPageRoute(builder: (context){
                //             //   return Home(nama: nama,);
                //             // }));
                //           }), 
                //           child:  const Text('Sign in with yahoo', style: TextStyle(fontSize: 18), ),
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.white, elevation: 20, minimumSize: Size(50, 50), 
                //             foregroundColor: Colors.black,
                //             shape: RoundedRectangleBorder( //to set border radius to button
                //                 borderRadius: BorderRadius.circular(30)
                //             ),
                //           ),
                          
                //         )
                //       )
                //   )
                //   ],
                // ),
                // SizedBox(
                //   height: 10
                // ),
                // Row(
                //   children: <Widget>[
                //     Expanded(
                //       child: Container(
                //         child: ElevatedButton(
                //           onPressed: (() async{
                //             await _handleSignIn();
                //             // var nama = _currentUser!.displayName;
                //             // await _googleSignIn.disconnect();
                //             // Navigator.push(context, MaterialPageRoute(builder: (context){
                //             //   return Home(nama: nama,);
                //             // }));
                //           }), 
                //           child:  const Text('Sign in with github', style: TextStyle(fontSize: 18), ),
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.white, elevation: 20, minimumSize: Size(50, 50), 
                //             foregroundColor: Colors.black,
                //             shape: RoundedRectangleBorder( //to set border radius to button
                //                 borderRadius: BorderRadius.circular(30)
                //             ),
                //           ),
                          
                //         )
                //       )
                //   )
                //   ],
                // )
              ],
            )
          ],
        )
        
    );
  }
}