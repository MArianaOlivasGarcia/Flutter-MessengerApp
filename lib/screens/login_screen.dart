import 'package:chat/helpers/show_alert.dart';
import 'package:chat/providers/auth_form_provider.dart';
import 'package:chat/providers/auth_provider.dart';
import 'package:chat/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.96,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const _Logo(),

              ChangeNotifierProvider(
                  create: (_) => AuthFormProvider(),
                  child: const _Form()
              ),

               Labels(
                  title: "¿No tienes una cuenta?",
                  textButton: '¡Registrarme!',
                  onTap: () => Navigator.pushReplacementNamed(context, 'register')
                ),
        
                const Text('Términos y condiciones.',
                  style: TextStyle(
                    fontWeight: FontWeight.w200
                  )
                )
            ],
          ),
        ),
      ),
    ));
  }
}






class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Image(
        image: AssetImage('assets/logo.png'),
        width: 100,
      ),
    );
  }
}






class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {


  @override
  Widget build(BuildContext context) {

    final authFormProvider = Provider.of<AuthFormProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final socketProvider = Provider.of<SocketProvider>(context);


    return Form(
      key: authFormProvider.formKey,
      child: Column(
        children: [
          
          CustomInput(
            hintText: 'Correo electrónico',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp  = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                ? null
                : 'Correo electrónico inválido';
            },
            onChanged: ( value ) => authFormProvider.email = value,
          ),


          
          CustomInput(
            hintText: 'Contraseña',
            obscureText: true,
            validator: ( value ) {
              return ( value != null && value.length >= 6 ) 
                ? null
                : 'Mínimo 6 caracteres';
            }, 
            onChanged: ( value ) => authFormProvider.password = value,
          ),


          CustomButton(
            text: 'Iniciar sesión',
            color: Colors.deepPurple,
            onPressed: authProvider.isAuthenticating ? null : () async {

                if ( !authFormProvider.isValid() ) return;

                /* Quitar el foco del teclado o lo que sea */
                FocusScope.of(context).unfocus();

                final authResponse = await authProvider.login( authFormProvider.email.trim(), authFormProvider.password.trim() );

                if ( authResponse.status ) {

                  // Conectar socket server 
                  socketProvider.connect();
                  
                  Navigator.pushReplacementNamed(context, 'home');

                } else {

                  showAlert(context, 'Oops!', authResponse.msg! );

                }


              },
          )
        ],
      ),
    );
  }
}
