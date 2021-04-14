import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' hide Colors;
// import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:io';
import 'dart:async';
// import 'dart:convert' show json;

import "package:http/http.dart" as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:studily/homescreen/home_screen.dart';

// import 'package:googleapis/calendar/v3.dart';

// import '../secrets.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    // 'https://www.googleapis.com/auth/contacts.readonly',
    // 'https://www.googleapis.com/auth/calendar',
  ],
);

class WelcomeScreen extends StatefulWidget {
  @override
  State createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  GoogleSignInAccount _currentUser;

  // final accountCredentials = new ServiceAccountCredentials.fromJson({
  //   "private_key_id": "ed6f40ce811b1e9b9dd9dfffa8ddeb8012e84dc2",
  //   "private_key":
  //       "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC9Vr7VwISMAeUL\nMb5zYO2vjXhj9bmw6CeVm4wLyJvZ1Mk4/Q9gsGk6nkOQdNs1CsgCO/BQuL+BTTCV\nKHY6EeRyyp9PtW+S1oXHowzR+tclvalGicciGsk2KM0lCsjWgZPGhZk/AgEy/yCY\ng+JhpxI53jpaH28tib7aVA7Es5s+zSFzfsBgD/d+2tLgG6B+7/LQYTpoCh8U2VQT\nhCImKTfx/eLEFt7RfOqJY188H4oUEohA8pcL3+gteGEMceqzfQpgVGk5BA1b+Pvw\nre7VrqmGHYjD65rPTYQd7YM1W4t8osyIb+KQaFJ2yA0YHAVQGgRnrJioE94WWBEd\n/1SAwz1tAgMBAAECggEAHncjQhSgn0CSILYn2BEsHZfCBooxj01uSncwARi4jxkw\nfurP0HXXm2wqIJ0qRRjPgaCFtLoNbRpFAMh1FuHtztSwmVbvNYLZctEsYmseDD9o\nyeX9yeHifMRIQgzABS1DYGmlygrMs5kenxEgL33+WPEGQEhs5LhpzQqXzRRonKGG\nmSl25lNVBUAMj954rLm2HPnWADMl7k97eIvqB5lSR4UmvnoL8zx22wg66r30GRon\nhryumw+6XuXtfm4t/04zZ4rZfTvTCNdzrdBnxr4StI2kHahCtX87/9ehHQX3VIo5\nA/ZIcICgQgA0/RldX9q2RYA1qFqSLnWjRBOcM2yI1wKBgQDfcbihrPwHvs6u3u9R\nCU8PrBjZPFIZWdMy5MI5uNu/AeqmWOyz5xyXNoO0UuPyw3O0j+X9cys54O3Bt+Dm\nFGk1M6crW+g2lNkJwTql+IKI6zIElLkT6kSNCt53BFpOy7UDZ5OKssKgA1uIa5sQ\n5sRrpviO/0NxUZaTgY2vUuctMwKBgQDY7OxCyaIbjiAHFcuRP4XdAuuAkEGmoulP\ng4FrZgPjoP3zg1pvaK9gLqnGZIxsdA/jPkwQCSeWW/lf3/yEKZtNgeGTuDuyBe/D\nxTCfhgTuHXFBcvTGVcnpNvkHpu0WSiDtRpIzePBEq1qUAlldSfBMwg0TfWkHwdvy\nVNwIzyWq3wKBgQCGzWLoFyaNva2Pjmuu5gDOobL0DBIzvR9PivcqP75DA/L+nJNh\nDcMP7xGSDpf687OwcUf9miev6WVHA5oo9JNsR1dJL09u7mnqGqs5Si3mUI6CeP8X\nZrQoqy//eZ7J/teb0DcQ7DvCsYPdT53jmnVRxRAbpSCZEvHW18gUx900RQKBgEbX\nCEi/RBsvjLIDohjq37JPM80mTuo2JW78CRWjmP2LI6OUb8IWM797PaI2T81TEaUq\nQPizpKProUJ4CSS32am0EpCFB6mZWrVZ/gj6YT3Ji6TN/7WNaoSomSawkphG2P3j\nn/cDNaOXOds/8SMP9FN8w3xr5hLMciFvKPQPgcONAoGBAIW0MHX8r0DoDIHSkHTx\nx/jIsiUaO+pLELVEFo+4wvbJmH7+LBWOr2SNX8/3E5g2pBkYoJJDXOeQpHtSNOJr\nxYUZLC7EL22inRu3G3qIcO3QywXzw1SPRZwF63TIbM5ohCcU3PFvmUdCUE/8D4zB\nn+ligKszIz1amSjLfZ63WlQO\n-----END PRIVATE KEY-----\n",
  //   "client_email": "procrastination-app-d86b0@appspot.gserviceaccount.com",
  //   "client_id": "100498033953490242886",
  //   "type": "service_account",
  // });

  // final _scopes = [CalendarApi.calendarScope];

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      // if (_currentUser != null) {
      //   _handleGetContact();
      // }
    });

    _googleSignIn.signInSilently();
    // getCalendarEvents();
  }

  // void getCalendarEvents() {
  //   clientViaServiceAccount(accountCredentials, _googleSignIn.scopes)
  //       .then((client) {
  //     var calendar = new CalendarApi(client);
  //     var calEvents = calendar.events
  //         .list("6hgnipqibkvh77h7kr8cs09igs@group.calendar.google.com");
  //     calEvents.then((Events events) {
  //       events.items.forEach((Event event) {
  //         print(event.summary);
  //       });
  //     });
  //   });
  // }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: _handleSignIn,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Color(0xff7371FC)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google.png"), height: 28.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 0,
                top: 5,
                bottom: 5,
              ),
              // child: Text(
              //   'Sign in with Google',
              //   style: TextStyle(
              //     fontSize: 18,
              //     color: Colors.grey,
              //   ),
              // ),
            )
          ],
        ),
      ),
    );
  }

  Widget _signInButtonApple() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            // ignore: todo
            // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
            clientId: 'com.aboutyou.dart_packages.sign_in_with_apple.example',
            redirectUri: Uri.parse(
              'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
            ),
          ),
          // ignore: todo
          // TODO: Remove these if you have no need for them
          nonce: 'example-nonce',
          state: 'example-state',
        );

        print(credential);

        // This is the endpoint that will convert an authorization code obtained
        // via Sign in with Apple into a session in your system
        final signInWithAppleEndpoint = Uri(
          scheme: 'https',
          host: 'flutter-sign-in-with-apple-example.glitch.me',
          path: '/sign_in_with_apple',
          queryParameters: <String, String>{
            'code': credential.authorizationCode,
            'firstName': credential.givenName,
            'lastName': credential.familyName,
            'useBundleId':
                Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
            if (credential.state != null) 'state': credential.state,
          },
        );

        final session = await http.Client().post(
          signInWithAppleEndpoint,
        );

        // If we got this far, a session based on the Apple ID credential has been created in your system,
        // and you can now set this as the app's session
        print(session);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Color(0xff7371FC)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/apple.png"), height: 30.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 0,
                // right: 40,
                top: 5,
                bottom: 5,
              ),
              // child: Text(
              //   'Sign in with Apple',
              //   style: TextStyle(
              //     fontSize: 18,
              //     color: Colors.grey,
              //   ),
              // ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    Size size = MediaQuery.of(context).size;
    if (_currentUser != null) {
      return Stack(
        children: <Widget>[
          Scaffold(
            extendBodyBehindAppBar: true,
            body: Container(
              child: HomePage(),
              color: Colors.transparent,
            ),
          ),
        ],
      );
    } else {
      return Background(
        child: Stack(
          alignment: Alignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Positioned(
              top: 110,
              left: 125,
              child: Text(
                "Studily",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Color(0xff7371FC)),
              ),
            ),
            Positioned(
              top: 175,
              left: 130,
              child: Text(
                "Simple Organization",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Color(0xff969698)),
              ),
            ),
            Positioned(
              bottom: 150,
              child: Text(
                "Sign In",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Color(0xff969698)),
              ),
            ),
            Positioned(
              bottom: 90,
              left: 70,
              child: _signInButton(),
            ),
            Positioned(
              bottom: 90,
              right: 70,
              child: _signInButtonApple(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 240,
            left: 50,
            child: Image.asset(
              'assets/time.png',
              width: size.width * 0.8,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
