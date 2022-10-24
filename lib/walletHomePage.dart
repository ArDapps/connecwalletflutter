import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Create a connector
  final connector = WalletConnect(
    bridge: 'https://bridge.walletconnect.org',

    clientMeta: PeerMeta(
      name: ' name WalletConnect',
      description: ' description WalletConnect Developer App',
      url: 'https://URLwalletconnect.org',
      icons: [
        'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
      ],
    ),
  );

  var _session,uri,session;
  connectMetmaskWallet(BuildContext context) async{
    if(!connector.connected){
      try{
        session = await connector.createSession(onDisplayUri: (_uri) async{
          uri=_uri;
          await launchUrlString(_uri,mode: LaunchMode.externalApplication);
        });
        setState(() {
          _session=session;
        });
        print(session);
        print(uri);

      }catch(eroor){
        print("error at connect $eroor" );
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    // Subscribe to events
    connector.on('connect', (session) =>setState( () {
      _session=session;
    }));
    connector.on('session_update', (payload) =>   setState(() {
      _session=session;
    }));
    connector.on('disconnect', (session) =>   setState(() {
      _session=session;
    }));

    var account = session?.accounts[0];
    var chainId= session?.chainId;
    return Scaffold(
      appBar: AppBar(title: Text("Wallet Connect "),),
      body: (session ==null)?SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Please Clikc Button to Connect with Metamask Wallet Application"),
            ),
            TextButton(onPressed: ()=>connectMetmaskWallet(context), child: Text("Connect Wallet"))

          ],
        ),
      ):(account !=null)?Column(
        children: [
          Text("You are Connected  $account"),
          Text("Chain Id is   $chainId"),


        ],
      ):Text("No Account")
    );
  }
}
