import 'package:flutter/material.dart';
import 'authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_swiper/flutter_swiper.dart';



class HomePage extends StatefulWidget {
	HomePage({Key key, this.auth, this.userId, this.onSignedOut, this.user})
      : super(key: key);

	final BaseAuth auth;
	final VoidCallback onSignedOut;
	final String userId;
	final FirebaseUser user;
	
	@override
	_HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: <Widget>[
						Swiper(
							itemBuilder: (BuildContext context,int index){
								return new Image.network("http://via.placeholder.com/350x150",fit: BoxFit.fill,);
							},
						itemCount: 3,
						pagination: new SwiperPagination(),
						control: new SwiperControl(),
						),
						
					] 
				),
			),
		);
	}
}