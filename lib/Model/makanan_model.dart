//Mmebuat model makanan

class Makanan{
  String? nama;
  String? img;
  String? rangking;

  //konstruktor - fungsi yang dipanggil ketika kelas dibuat
  Makanan({
    required this.nama,
    this.img,
    this.rangking
  });

  //pabrik untuk memasukkan data
  factory Makanan.fromJson(Map<String, dynamic> json){
    return Makanan(
      nama: json['strMeal']as String,
      img: json['strMealThumb']as String,
      rangking: json['idMeal']as String,
    );
  }
}