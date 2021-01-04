class Eczane {
  String eczaneAdi;
  String telefon;
  String tarif;
  String adres;
  String sgk;
  String baslik;
  double lat;
  double lon;
  double konumFarki;
  bool enYakinEczane=false;

  Eczane.name(
      {this.eczaneAdi,
      this.telefon,
      this.tarif,
      this.adres,
      this.sgk,
      this.baslik,
      this.lat,
      this.lon,
      this.konumFarki});
}
