import 'dart:io';

import 'package:chat/models/messages_response.dart';
import 'package:chat/models/usuario.dart';
import 'package:chat/providers/auth_provider.dart';
import 'package:chat/providers/chat_provider.dart';
import 'package:chat/providers/socket_provider.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatProvider chatProvider;
  late SocketProvider socketProvider;
  late AuthProvider authProvider;

  bool _isWriting = false;

  List<CustomMessage> _messages = [];


  @override
  void initState() {
    super.initState();

    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);


    socketProvider.socket.on('personal-message', _listenMessage );

    _cargarMessages( chatProvider.userTo.id );

  }

  
  void _cargarMessages( String userId ) async {
     List<Message> chat = await chatProvider.getChat(userId);

      final history = chat.map( (m) => CustomMessage(
        text: m.mensaje, 
        uid: m.de,
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(
            milliseconds: 200
          )
        )..forward() // Lanza la animación inmediatamente
      ));

      setState(() {
        _messages.insertAll(0, history);
      });

  }



  void _listenMessage( dynamic payload ){

    CustomMessage newMessage = CustomMessage(
      text: payload['mensaje'], 
      uid: payload['de'],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 200
        )
      ),
    );

    setState(() {
      _messages.insert(0, newMessage);
    });

    newMessage.animationController.forward();

  }



  @override
  Widget build(BuildContext context) {


    final size = MediaQuery.of(context).size;
    final userTo = chatProvider.userTo;

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: _customAppBar(size, userTo),
      body: Container(
          padding: const EdgeInsets.only(
            top: 10
          ),
          margin: const EdgeInsets.only(
            top: 10
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20)
            )
          ),
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (_, index) => _messages[index],
                reverse: true,
              )
            ),
            const Divider(),
            Container(
              color: const Color(0xFFf2f2f2),
              height: Platform.isAndroid ? 60 : 85,
              child: _customInput(),
            )
          ],
        ),
      ),
    );
  }

  AppBar _customAppBar(Size size, Usuario userTo ) {


    return AppBar(
      elevation: 0,
      backgroundColor: Colors.deepPurple,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, size: size.width * 0.07),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              width: size.width * 0.10,
              height: size.width * 0.10,
              child: FadeInImage(
                image: NetworkImage( userTo.image ),
                placeholder: const NetworkImage(
                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.02,
          ),
          
          ( !userTo.online ) ?

          Text( userTo.name,
                style: const TextStyle(
                  fontSize: 18
                ),
              ) :
          
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text( userTo.name,
                style: const TextStyle(
                  fontSize: 18
                ),
              ),
              const Text( 'En línea', 
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70
                ),
              )
            ],
          ),


        ],
      ),
    );
  }

  Widget _customInput() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmit,
                  onChanged: (value) {
                    
                    setState(() {
                      if ( value.trim().isNotEmpty ) {
                        _isWriting = true;
                      } else {
                        _isWriting = false;
                      }
                    });

                  },
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Escribir mensaje...'),
                  focusNode: _focusNode),
            ),

            /* Botón enviar  */
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: const Text('Enviar'),
                      onPressed: _isWriting
                              ? () => _handleSubmit( _textController.text.trim() ) 
                              : null
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4.0),
                        child: IconTheme(
                          data: const IconThemeData(
                            color: Colors.blue,
                          ),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: const Icon(Icons.send),
                            onPressed: _isWriting
                              ? () => _handleSubmit( _textController.text.trim() ) 
                              : null
                          ),
                        )
                      ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String value) {

    if ( value.isEmpty ) return;

    print( value );

    _focusNode.requestFocus();
    _textController.clear();


    final newMessage = CustomMessage(
      text: value, 
      uid: authProvider.usuario.id,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 200
        )
      ),
    );
    _messages.insert(0, newMessage);

    // Empezar la animación
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;
    });

    socketProvider.emit('personal-message', {
      'de': authProvider.usuario.id,
      'para': chatProvider.userTo.id,
      'mensaje': value
    });

  }


  @override
  void dispose() {
    
    for (final message in _messages) {
      message.animationController.dispose();
    }

    socketProvider.socket.off('personal-message');
    super.dispose();
  }
}
