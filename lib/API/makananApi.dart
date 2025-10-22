//Buat Koneksi API
import 'dart:convert';

import 'package:pertemuan4/Model/makanan_model.dart';
import 'package:http/http.dart' as http;

class ApiService{
  //url
  static const _url = 'https://www.themealdb.com/api/json/v1/1/filter.php?a=Canadian';

  //Mengambil data dari API
  Future<List<Makanan>> fetchMakanan() async{ //untuk menahan program dan menunguuu program
  final respon = await http.get(Uri.parse(_url));
  
  try {
    if(respon.statusCode == 200){ //data didapat
      final Map<String, dynamic> json = jsonDecode(respon.body); //ubah string jadi json
      final List<dynamic> makananJson = json['meals'];
      return makananJson.map((json) => Makanan.fromJson(json)).toList();
    }else {
      throw Exception('Tidak Mendapatkan Data');
    }
  }catch (e){
    throw Exception('Koneksi Gagal');
  }
  }
}