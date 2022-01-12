
import 'package:chat/models/usuario.dart';
import 'package:chat/providers/auth_provider.dart';
import 'package:chat/providers/chat_provider.dart';
import 'package:chat/providers/socket_provider.dart';
import 'package:chat/providers/usuarios_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final usuariosProvider = UsuariosProvider();

  List<Usuario> usuarios = [];
  final RefreshController _refreshController = RefreshController(initialRefresh: false); 

  @override
  void initState() {
    _loadUsers();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final socketProvider = Provider.of<SocketProvider>(context);

    return Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text('Messenger'),
          elevation: 0,
          actions: [
            IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: (){

                // Desconectar el socket server
                socketProvider.disconnect();

                Navigator.pushReplacementNamed(context, 'login');
                AuthProvider.removeToken();

              }, 
              icon: const Icon(Icons.logout) 
            )
          ],
        ),
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
          child: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            child: _buildListUsers(),
            onRefresh: _loadUsers
          ),
        ));
  }

  ListView _buildListUsers() {
    return ListView.builder(
          itemCount: usuarios.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildUserItem( usuarios[index] );
          },
        );
  }

  GestureDetector _buildUserItem( Usuario usuario ) {

    final size = MediaQuery.of( context ).size;

    return GestureDetector(
            onTap: (){

              final chatProvider = Provider.of<ChatProvider>(context, listen: false);
              chatProvider.userTo = usuario;

              Navigator.pushNamed(context, 'chat');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                      width: size.width * 0.15,
                      height: size.width * 0.15,
                      child: FadeInImage(
                        image: NetworkImage( usuario.image ),
                        placeholder: const NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 20,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuario.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      Text(
                        usuario.email,
                        style: const TextStyle(color: Colors.black54, fontSize: 16),
                      )
                    ],
                  ),

                  Expanded(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.circle,
                          color: usuario.online ? Colors.green : Colors.red,
                          size: size.width * 0.03,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }


  _loadUsers() async {
  
    usuarios = await usuariosProvider.getAllUsers();
    setState(() {});

    _refreshController.refreshCompleted();
  }
}


