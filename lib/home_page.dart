import 'package:flutter/material.dart';
import 'authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
				child: Container(
					child: RaisedButton(
						color: Colors.yellow,
						child: Text(text),
						onPressed: (){
							setState(() {
							  text = text + "1";
							});
						} ,
					),
				),
			),
		);
	}
}