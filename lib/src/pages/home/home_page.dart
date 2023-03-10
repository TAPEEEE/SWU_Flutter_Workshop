import 'package:demo0/src/bloc/home/home_bloc.dart';
import 'package:demo0/src/bloc/login/login_bloc.dart';
import 'package:demo0/src/constants/asset.dart';
import 'package:demo0/src/models/youtube_response.dart';
import 'package:demo0/src/pages/app_routes.dart';
import 'package:demo0/src/pages/home/widgets/dialog_barcode_image.dart';
import 'package:demo0/src/pages/home/widgets/dialog_qr_image.dart';
import 'package:demo0/src/pages/home/widgets/dialog_scan_qrcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();

  const HomePage({Key? key}) : super(key: key);
}

class _HomePageState extends State<HomePage> {
  var _isShowListView = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomeBloc>().add(HomeEventLoadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: const Text('HomePage'),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isShowListView = !_isShowListView;
                });
              },
              icon: Icon(_isShowListView ? Icons.list : Icons.grid_3x3),
            )
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return _isShowListView ? _buildListView(state.youtubes) : _buildGridView(state.youtubes);
            },
          ),
        ));
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri _url = Uri.parse(urlString);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Widget _buildGridView(List<Youtube> youtubes) {
    return GridView.builder(
      itemCount: youtubes.length,
      itemBuilder: (BuildContext context, int index) {
        return TextButton(
          onPressed: () => _launchUrl("https://www.youtube.com/watch?v=${youtubes[index].id}"),
          child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.network(
                      youtubes[index].youtubeImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        color: Colors.black45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            youtubes[index].title,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                ],
              )),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        childAspectRatio: 1.2,
      ),
    );
  }

  Widget _buildListView(List<Youtube> youtubes) {
    return ListView.builder(
      itemCount: youtubes.length,
      itemBuilder: (BuildContext context, int index) {
        return TextButton(
          onPressed: () => _launchUrl("https://www.youtube.com/watch?v=${youtubes[index].id}"),
          child: Container(
            height: 300,
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    // avatar image
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.network(
                          youtubes[index].avatarImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // title and subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(youtubes[index].title),
                          Text(
                            youtubes[index].subtitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Image.network(
                    youtubes[index].youtubeImage,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  _showMyDialogBox(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: 100,
              child: Column(
                children: [
                  Text("Lek"),
                  ElevatedButton(
                    child: Text("Close"),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _showDialogBarcode(context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => const DialogBarcodeImage(
        color: Colors.red,
        'www.codemobiles.com',
      ),
    );
  }

  void _showDialogQRImage(context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => const DialogQRImage(
        'www.codemobiles.com',
        image: Asset.pinBikerImage,
      ),
    );
  }

  void _showScanQRCode(context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => DialogScanQRCode(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildProfile(),
          ListTile(
            onTap: () => _showImageDialog(context), //_showDialogBarcode(context),
            title: Text("MyDialog"),
            leading: Icon(Icons.dialer_sip, color: Colors.deepPurple),
            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.deepPurple),
          ),
          ListTile(
            onTap: () => _showDialogBarcode(context), //_showDialogBarcode(context),
            title: Text("BarCode"),
            leading: Icon(Icons.bar_chart_outlined, color: Colors.deepOrange),
          ),
          ListTile(
            onTap: () => _showDialogQRImage(context),
            title: Text("QRCode"),
            leading: Icon(Icons.qr_code, color: Colors.green),
          ),
          ListTile(
            onTap: () => _showScanQRCode(context),
            title: Text("Scanner"),
            leading: const Icon(Icons.qr_code_scanner, color: Colors.blueGrey),
          ),
          ListTile(
            onTap: () => Navigator.pushNamed(context, AppRoute.map),
            title: Text("Map"),
            leading: Icon(Icons.map_outlined, color: Colors.blue),
          ),
          Spacer(),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader _buildProfile() => UserAccountsDrawerHeader(
    currentAccountPicture: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const CircleAvatar(
        backgroundImage: AssetImage(Asset.cmLogoImage),
      ),
    ),
    accountName: Text('CMDev'),
    accountEmail: Text('support@codemobiles.com'),
  );

  Builder _buildLogoutButton() => Builder(
    builder: (context) => SafeArea(
      child: ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Log out'),
        onTap: () => context.read<LoginBloc>().add(LoginEvent_Logout()),
      ),
    ),
  );

  _showImageDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: 300,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SizedBox(
                        height: 200,
                        child: Image.network("https://images.ctfassets.net/4cd45et68cgf/3eMfmrIlUYM4CfEPiPED1Z/42518eb222101ab8289c3d8a0b3c901b/Kim_You-jung.jpg?w=2560")),
                  ),
                  ElevatedButton(
                    child: Text("Close"),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
          );
        });
  }
}