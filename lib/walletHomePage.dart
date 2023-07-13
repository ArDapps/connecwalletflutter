import 'package:connecwalletflutter/WalletConnectEthereumCredentials.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;





class WalletHomePage extends StatefulWidget {
  const WalletHomePage({Key? key}) : super(key: key);

  @override
  State<WalletHomePage> createState() => _WalletHomePage();
}

class _WalletHomePage extends State<WalletHomePage> {
  // Create an Algorand instance


  //-1 Create a connector
  final connector = WalletConnect(
    bridge: 'https://bridge.walletconnect.org',

    clientMeta: PeerMeta(
      name: ' name WalletConnect',
      description: ' description WalletConnect Developer App',
      url: 'https://URLwalletconnect.org',
      icons: [
        "https://coodes.org/wp-content/uploads/2020/07/ic.png"
      ],
    ),
  );

  //-2
  var _session,uri,session;

  //-3
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

      }catch(eroor){
        print("error at connect $eroor" );
      }
    }

  }

  EthereumAddress getEthereumAddress() {
     String publicAddress = _session.account[0];
    print(EthereumAddress.fromHex(publicAddress));

    return EthereumAddress.fromHex(publicAddress);
  }

  @override
  Widget build(BuildContext context) {
    // Subscribe to events
    connector.on('connect', (session) =>setState( () {
      _session=session;
      print(session);
    }));
    connector.on('session_update', (payload) =>   setState(() {
      _session=session;
      print(session);

    }));
    connector.on('disconnect', (session) =>   setState(() {
      _session=session;
      print(session);

    }));

    var account = session?.accounts[0];
    var chainId= session?.chainId;


 getSender() {
   if(account!=null){
     // final sender = Address.fromAlgorandAddress(address: _session.accounts[0]);
     final sender = EthereumAddress.fromHex(session.accounts[0]);

   }
 }

 //SEND ETH
    Web3Client? _client;

    sendSomeETh ( String clientAddress,String owner) async{

      final httpClient = http.Client();
      final nodeUrl = 'https://goerli.infura.io/v3/47b829e7e62f4ccfa9fe9dbd1bde1714'; // Replace with your Ethereum node URL
      _client = Web3Client(nodeUrl, httpClient);

      if (_client == null) {
        print('Web3Client is not initialized');
        return;
      }


      EthereumWalletConnectProvider provider =
      EthereumWalletConnectProvider(connector);

      // provider.sendTransaction(from:owner,to: clientAddress,value:BigInt.parse("10000"),);
      // final credentials = WalletConnectEthereumCredentials(provider: provider);

      WalletConnectEthereumCredentials credentials = WalletConnectEthereumCredentials(provider: provider);
      try {
        await _client!.sendTransaction(
          credentials,
          Transaction(
            from: EthereumAddress.fromHex(owner),
            to: EthereumAddress.fromHex(clientAddress),
            gasPrice: EtherAmount.inWei(BigInt.from(10000)),
            maxGas: 100000,
            value: EtherAmount.fromUnitAndValue(EtherUnit.wei, 10000),
          ),
        );
      }

       catch (error) {
        print('Error: $error');
      }



    }

    return Scaffold(
      appBar: AppBar(title: Text("Wallet Connect "),),
      body: (session ==null)?SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Please Clikc Button to Connect with Metamask Wallet Application"),
            ),
            TextButton(onPressed: ()=>connectMetmaskWallet(context), child: Text("Connect Wallet")),

          ],
        ),
      ):(account !=null)?Column(
        children: [
          Text("You are Connected  $account"),
          Text("Chain Id is   $chainId"),
          TextButton(onPressed: ()=>getSender(), child: Text("Print Sender Wallet")),
          TextButton(onPressed:(){
            sendSomeETh("0xc57F8B82c17C77872aa0758D00B9F1b34Fde1788",account);
          }, child: Text("Send ETH"))


        ],
      ):Text("No Account")
    );
  }
}
