import 'package:flutter/material.dart';
import 'package:istanbul_nobetci_eczane/utility.dart';
import 'harita.dart';
import 'models/eczane.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NobetciEczane(),
    ),
  );
}

class NobetciEczane extends StatefulWidget {
  @override
  _NobetciEczaneState createState() => _NobetciEczaneState();
}

class _NobetciEczaneState extends State<NobetciEczane> {
  final List<Eczane> _eczaneler = [];
  bool _isClicked = false;
  String _baslik = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İstanbul Nöbetçi Eczaneler"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              toastMessage("dursunkatar.com");
            },
          ),
        ],
      ),
      body: _eczaneler.length == 0 && _isClicked
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                    child: Text(
                      _baslik,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.71,
                    child: ListView.builder(
                      itemBuilder: _itemBuilder,
                      itemCount: _eczaneler.length,
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _eczaneler.clear();
            _baslik = "";
            _isClicked = true;
          });
          nobetciEczaneler();
        },
        label: Text(
          "Eczaneleri Getir",
          style: TextStyle(fontSize: 17),
        ),
        icon: Icon(Icons.search, size: 35),
      ),
    );
  }

  void nobetciEczaneler() async {
    try {
      final String postalCode = await GeolocatorEngine.currentPostalCode();
      final String htmlPostaKodu = await Http.postaKoduAraComHtml(postalCode);
      final String ilce = await Parse.ilce(htmlPostaKodu);
      final String htmlEczane = await Http.istanbulsaglikGovTrHtml(ilce);
      final eczaneler = await Parse.eczaneler(htmlEczane);
      setState(() {
        if (eczaneler.isNotEmpty) {
          _baslik = eczaneler[0].baslik;
        }
        _eczaneler.addAll(eczaneler);
      });
    } catch (e) {
      toastMessage(e.message);
    } finally {
      setState(() {
        _isClicked = false;
      });
    }
  }

  Widget _itemBuilder(context, index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _eczaneler[index].eczaneAdi,
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
              SizedBox(
                height: 5,
              ),
              RichText(
                textAlign: TextAlign.left,
                softWrap: true,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Tel: ",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    TextSpan(
                      text: _eczaneler[index].telefon,
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              RichText(
                textAlign: TextAlign.left,
                softWrap: true,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Adres Tarifi: ",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    TextSpan(
                      text: _eczaneler[index].tarif,
                      style: TextStyle(color: Colors.blueAccent, fontSize: 17),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              RichText(
                textAlign: TextAlign.left,
                softWrap: true,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Adres: ",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    TextSpan(
                      text: _eczaneler[index].adres,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  OutlineButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Harita(
                                    _eczaneler[index].lat,
                                    _eczaneler[index].lon)));
                      },
                      icon: FaIcon(FontAwesomeIcons.mapMarked),
                      label: Text("Haritada Göster")),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      _eczaneler[index].enYakinEczane ? "En Yakın" : "",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
