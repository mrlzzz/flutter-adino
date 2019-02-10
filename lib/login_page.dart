import 'package:flutter/material.dart';
import 'authentication.dart';
import 'home_page.dart';

enum FormMode { LOGIN, SIGNUP }

class LoginPage extends StatefulWidget {
  
  	static String tag = "login-tag";
  	LoginPage({this.auth, this.onSignedIn});
	final BaseAuth auth;
	final VoidCallback onSignedIn;

  
  	@override
  	_LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

	final _formKey = new GlobalKey<FormState>();

	String _email;
	String _password;
	String _errorMessage;

  	// Initial form is login form
  	FormMode _formMode = FormMode.LOGIN;
	bool _isLoading = false;

	bool _validateAndSave() {
		final form = _formKey.currentState;
		if (form.validate()) {
			form.save();
			return true;
		}
		return false;
  	}

	@override
  	void initState() {
		_errorMessage = "";
		_isLoading = false;
		super.initState();
  	}

	Widget _showLogo = Hero(
		tag: 'logo',
		child: CircleAvatar(
			backgroundColor: Colors.transparent,
			radius: 48.0,
			child: Image.asset("assets/logo.png")
		)
	);

	Widget _showEmailInput(){
		return TextFormField(
			keyboardType: TextInputType.emailAddress,
			autofocus: false,
			decoration: InputDecoration(
				hintText: "Email",
				contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
				border: UnderlineInputBorder()
			),
			validator: (value) => value.isEmpty ? "Email can\'t be empty!" : null,
			onSaved: (value) => _email = value,
		);
	} 

	Widget _showPasswordInput() {
		return TextFormField(
			autofocus: false,
			obscureText: true,
			decoration: InputDecoration(
				hintText: "Password",
				contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
				border: UnderlineInputBorder()
			),
			validator: (value) => value.isEmpty ? "Password can\'t be empty!" : null,
			onSaved: (value) => _password = value,
		);
	} 

	Widget _showPrimaryButton() {
		return Padding(
			padding: EdgeInsets.symmetric(vertical: 16.0),
			child: Material(
				child: MaterialButton(
					minWidth: 150.0,
					height: 42.0,
					onPressed: _validateAndSubmit,
					color: Colors.black,
					child: _formMode == FormMode.LOGIN
           				? Text('Login',
               				style: new TextStyle(fontSize: 20.0, color: Colors.white))
           				: Text('Create account',
                			style: new TextStyle(fontSize: 20.0, color: Colors.white))
				)
			)
		);
	} 

	Widget _showSecondaryButton() {
		return Padding(
			padding: EdgeInsets.symmetric(vertical: 16.0),
			child: Material(
				child: MaterialButton(
					minWidth: 150.0,
					height: 42.0,
					onPressed: (){
						_formMode == FormMode.LOGIN ? _changeFormToSignUp() : _changeFormToLogin();
					},
					color: Colors.white,
					child:_formMode == FormMode.LOGIN
        				? new Text('Sign Up!',
            				style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
        				: new Text('Log In!',
            				style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
				)
			)
		);
	} 

	Widget _showForgotLabel() {
		return FlatButton(
			child: Text(
				'Forgot password?',
				style: TextStyle(color: Colors.grey),
			),
			onPressed: () {},
   		);
	} 
	Widget _showErrorMessage() {
		if (_errorMessage.length > 0 && _errorMessage != null) {
		return new Text(
			_errorMessage,
			style: TextStyle(
				fontSize: 13.0,
				color: Colors.red,
				height: 1.0,
				fontWeight: FontWeight.w300),
		);
		} else {
		return new Container(
			height: 0.0,
		);
		}
  	}

	void _showVerifyEmailSentDialog() {
		showDialog(
		context: context,
		builder: (BuildContext context) {
			// return object of type Dialog
			return AlertDialog(
			title: new Text("Verify your account"),
			content: new Text("Link to verify account has been sent to your email"),
			actions: <Widget>[
				new FlatButton(
				child: new Text("Dismiss"),
				onPressed: () {
					_changeFormToLogin();
					Navigator.of(context).pop();
				},
				),
			],
			);
		},
		);
  	}
	
	Widget _showBody() {
		return Container(
			child: Center(
				child: Form(
					key: _formKey,
					child: ScrollConfiguration(
						behavior: MyBehavior(),
						child: ListView(
							shrinkWrap: true,
							padding: EdgeInsets.only(left: 24.0, right: 24.0),
							children: <Widget> [
								SizedBox(height: 80.0),
								Column(
									children: <Widget>[
										Image.asset("assets/logo.png"),
										SizedBox(height: 20.0),
										Text("LOGIN",
											style: TextStyle(
												fontSize: 55.0,
												letterSpacing: 3.0,
											)
										)
									]
								),
								SizedBox(height: 95.0),
								_showEmailInput(),
								SizedBox(height: 8.0),
								_showPasswordInput(),
								SizedBox(height: 24.0),
								Row(
									mainAxisAlignment: MainAxisAlignment.spaceEvenly,
									children: <Widget>[
										_showSecondaryButton(),
										_showPrimaryButton()
									],
								),
								SizedBox(height: 8.0),
								_showForgotLabel(),
							]	
						)
					),
				)
			)
		);
	}
	
	Widget _showCircularProgress(){
  		if (_isLoading) { 
			return Center(
				child: CircularProgressIndicator()
			);
  		} return Container(height: 0.0, width: 0.0,);
	}
	@override
	Widget build(BuildContext context) {
  		return new Scaffold(
			body: Stack(
				children: <Widget>[
				_showBody(),
				_showCircularProgress(),
				],
			));
	}


	void _changeFormToSignUp() {
 		_formKey.currentState.reset();
 		_errorMessage = "";
  		
		setState(() { 
			_formMode = FormMode.SIGNUP; 
		});
	}

	void _changeFormToLogin() {
		_formKey.currentState.reset();
		_errorMessage = "";



		setState(() {
			_formMode = FormMode.LOGIN;
		});
	}


_validateAndSubmit() async {
	setState(() {
		_errorMessage = "";
		_isLoading = true;
	});

	if (_validateAndSave()) {
		String userId = "";
		try {
			if (_formMode == FormMode.LOGIN) {
				userId = await widget.auth.signIn(_email, _password);
				Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user: widget.auth.getCurrentUser())));

				print('Signed in: $userId');
			} else {
				userId = await widget.auth.signUp(_email, _password);
				Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user: widget.auth.getCurrentUser())));

				print('Signed up user: $userId');
			}
			if (userId.length > 0 && userId != null) {
				widget.onSignedIn();
			}
		} catch (e) {
			print('Error: $e');
		
		setState(() {
			_isLoading = false;
			_errorMessage = e.message;
		});
		}
	}
}
}
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}