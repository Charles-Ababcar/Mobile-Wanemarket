import 'dart:developer';

class City {

  int? id;
  String? title;
  int? population;

  City(int? id, String? title, int? population) {
    this.id = id;
    this.title = title;
    this.population = population;
  }

  getTitle() {
    return this.title;
  }

  static mapAll(data) {

    List<City> cities = [];
    int length = data["cities"].length;

    for(int i = 0; i < length; ++i) {
      City city = new City(
        data["cities"][i]["id"],
        data["cities"][i]["localisation"],
        data["cities"][i]["population"]
      );
      cities.add(city);
    }

    return cities;
  }

  static getCities() {
    return [
      new City(2, 'Dakar', 1075582),
      new City(3, 'Pikine', 874062),
      new City(4, 'Touba', 529176),
      new City(5, 'Guédiawaye', 293737),
      new City(6, 'Thiès', 263493),
      new City(7, 'Kaolack', 185976),
      new City(8, 'Mbour', 181825),
      new City(9, 'Saint-Louis', 171263),
      new City(10, 'Rufisque', 162055),
      new City(11, 'Ziguinchor', 158370),
      new City(12, 'Diourbel', 100445),
      new City(13, 'Louga', 82884),
      new City(14, 'Tambacounda', 78800),
      new City(15, 'Mbacké', 68054),
      new City(16, 'Kolda', 62258),
      new City(17, 'Richard-Toll', 48968),
      new City(18, 'Bargny', 41301),
      new City(19, 'Tivaouane', 39766),
      new City(20, 'Joal-Fadiouth', 39078),
      new City(21, 'Dahra', 30896),
      new City(22, 'Kaffrine', 28396),
      new City(23, 'Bignona', 27072),
      new City(24, 'Fatick', 24855),
      new City(25, 'Vélingara', 23775),
      new City(26, 'Bambey', 22591),
      new City(27, 'Sébikhotane', 21017),
      new City(28, 'Dagana', 20916),
      new City(29, 'Sédhiou', 20141),
      new City(30, 'Nguékhokh', 20031),
      new City(31, 'Diawara', 20000),
      new City(32, 'Kédougou', 18860),
      new City(33, 'Pout', 18595),
      new City(34, 'Kayar', 18010),
      new City(35, 'Matam', 17324),
      new City(36, 'Meckhe', 15912),
      new City(37, 'Nioro du Rip', 15643),
      new City(38, 'Ourossogui', 15614),
      new City(39, 'Kébémer', 15585),
      new City(40, 'Ndioum', 15546),
      new City(41, 'Koungheul', 15461),
      new City(42, 'Guinguinéo', 14296),
      new City(43, 'Linguère', 13610),
      new City(44, 'Khombole', 12823),
      new City(45, 'Bakel', 12751),
      new City(46, 'Sokone', 12645),
      new City(47, 'Diamniadio', 12326),
      new City(48, 'Mboro', 12289),
      new City(49, 'Thiadiaye', 12157),
      new City(50, 'Goudomp', 12012),
      new City(51, 'Podor', 11869),
      new City(52, 'Gossas', 11624),
      new City(53, 'Kanel', 11161),
      new City(54, 'Rosso', 10717),
      new City(55, 'Ndoffane', 10228),
      new City(56, 'Gandiaye', 10174)
    ];
  }
}