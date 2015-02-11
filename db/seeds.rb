# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create([
  {
    first_name: "Alex",
    last_name: "Ford",
    email: "aford@gmail.com"
  },
  {
    first_name: "Dustin",
    last_name: "Fedako",
    email: "dfed@gmail.com"
  },
  {
    first_name: "Steven",
    last_name: "Clarke",
    email: "stevenclarke@gmail.com"
  },
])

Airbnb.create([
  {
    name: "Peaceful desert oasis  sleeps 6!",
    price: 200,
    url: "https://www.airbnb.com/rooms/4016523?s=8SZE",
    latitude: "37.137215771052496",
    longitude: "-113.60784601944984",
    meta: {
      imgUrl: "https://a0.muscache.com/ic/pictures/52722292/94429f26_original.jpg?interpolation=lanczos-none&size=x_medium&output-format=jpg&output-quality=70",
      location: "St. George",
      room_id: '4016523',
      user_id: '1'
    }
  },
  {
    name: "Peaceful Ivins Vacation Home",
    price: 149,
    latitude: "37.15275597463988",
    longitude: "-113.67242603712373",
    url: "https://www.airbnb.com/rooms/1885091?s=8SZE",
    meta: {
      imgUrl: "https://a2.muscache.com/ic/pictures/26249402/e4f0fc35_original.jpg?interpolation=lanczos-none&size=x_medium&output-format=jpg&output-quality=70",
      location: "Ivins",
      room_id: '1885091',
      user_id: '5'

    }
  },
  {
    name: "Large Home - STG,UT - Ironman 2012",
    price: 300,
    latitude: "37.16566530277204",
    longitude: "-113.65504796606449",
    url: "https://www.airbnb.com/rooms/409139?s=5bwc",
    meta: {
      room_id: '409139',
      location: "Ivins",
      user_id: '4',
      imgUrl: "https://a0.muscache.com/ic/pictures/4629134/5ac4338a_original.jpg?interpolation=lanczos-none&size=x_medium&output-format=jpg&output-quality=70"
    }
  },
  {
    name: "Private Room and Bath",
    price: 47,
    latitude: "37.1011006333438",
    longitude: "-113.559581651354",
    url: "https://www.airbnb.com/rooms/4191752?s=Foux",
    meta: {
      room_id: '4191752',
      location: "St. George",
      user_id: '4',
      imgUrl: "https://a2.muscache.com/ic/pictures/61867498/82635d4b_original.jpg?interpolation=lanczos-none&size=x_medium&output-format=jpg&output-quality=70"
    }
  }
  # {
  #   room_id: 4767660,
  #   user_id: 3,
  #   name: "Charming and Pet-Friendly Downtown",
  #   price: 165,
  #   location: "St. George",
  #   latitude: "37.106281736289986",
  #   longitude: "-113.58053904704732",
  #   url: "https://www.airbnb.com/rooms/4767660?s=Foux",
  #   imgUrl: "https://a2.muscache.com/ic/pictures/60005180/07f0c1b0_original.jpg?interpolation=lanczos-none&size=x_medium&output-format=jpg&output-quality=70"
  # },
  # {
  #   room_id: 5051637,
  #   user_id: 7,
  #   name: "Historic Mansion 6 bed 8 baths",
  #   price: 339,
  #   location: "Saint George",
  #   latitude: "37.11377080286191",
  #   longitude: "-113.58551410225276",
  #   url: "https://www.airbnb.com/rooms/5051637?s=5ebk",
  #   imgUrl: "https://a1.muscache.com/ic/pictures/65382673/8b16e58e_original.jpg?interpolation=lanczos-none&size=x_medium&output-format=jpg&output-quality=70"
  # },
  # {
  #   room_id: 2898638,
  #   user_id: 6,
  #   name: "Cute 3BD in downtown St George",
  #   price: 170,
  #   location: "St. George",
  #   latitude: "37.113679872220864",
  #   longitude: "-113.58888046307618",
  #   url: "https://www.airbnb.com/rooms/2898638?s=VOWP",
  #   imgUrl: "https://a2.muscache.com/ic/pictures/37488541/714b294a_original.jpg?interpolation=lanczos-none&size=x_medium&output-format=jpg&output-quality=70"
  # },
  # {
  #   room_id: 4228175,
  #   user_id: 8,
  #   name: "Two Bedrooms in Gorgeous St. George",
  #   price: 60,
  #   location: "St. George",
  #   latitude: "37.117811493022735",
  #   longitude: "-113.60872660456485",
  #   url: "https://www.airbnb.com/rooms/4228175?s=Foux",
  #   imgUrl: "https://a0.muscache.com/ic/pictures/62940151/f6317ed7_original.jpg?interpolation=lanczos-none&size=x_medium&output-format=jpg&output-quality=70"
  # },
  # {
  #   room_id: 3137816,
  #   user_id: 2,
  #   name: "The Zen of Comfort - Namaste'",
  #   price: 65,
  #   location: "St. George",
  #   latitude: "37.120570483149436",
  #   longitude: "-113.5969227691796",
  #   url: "https://www.airbnb.com/rooms/3137816?s=VOWP",
  #   imgUrl: "https://a0.muscache.com/ic/pictures/40013775/3df5376f_original.jpg?interpolation=lanczos-none&size=x_medium&output-format=jpg&output-quality=70"
  # },
  # {
  #   room_id: 3137461,
  #   user_id: 2,
  #   name: "Upstairs 3br 2bth Zensational Apt ",
  #   price: 185,
  #   location: "St. George",
  #   latitude: "37.121869179430874",
  #   longitude: "-113.59623475182865",
  #   url: "https://www.airbnb.com/rooms/3137461?s=ZjJe",
  #   imgUrl: "https://a1.muscache.com/ic/pictures/40008744/a93bc801_original.jpg?interpolation=lanczos-none&size=x_medium&output-format=jpg&output-quality=70"
  # },
  # {
  #   room_id: 4541130,
  #   user_id: 1,
  #   name: "Quiet Winchester Hills home",
  #   price: 150,
  #   location: "St. George",
  #   latitude: "37.209110758657225",
  #   longitude: "-113.60691806386185",
  #   url: "https://www.airbnb.com/rooms/4541130?s=o65K",
  #   imgUrl: "https://a1.muscache.com/ic/pictures/57029819/37d75f25_original.jpg?interpolation=lanczos-none&size=x_medium&output-format=jpg&output-quality=70"
  # },
  # {
  #   room_id: 4039204,
  #   user_id: 5,
  #   name: "An Elegant Stay for up to 20 People",
  #   price: 275,
  #   location: "St. George",
  #   latitude: "37.201857466182254",
  #   longitude: "-113.61852384291127",
  #   url: "https://www.airbnb.com/rooms/4039204?s=8SZE",
  #   imgUrl: "https://a0.muscache.com/ic/pictures/55115643/63ad3cb0_original.jpg?interpolation=lanczos-none&size=x_medium&output-format=jpg&output-quality=70"
  # },
  # {
  #   room_id: 1797958,
  #   user_id: 7,
  #   name: "Beautiful Prof. Decorated House",
  #   price: 400,
  #   location: "St. George",
  #   latitude: "37.19956548204917",
  #   longitude: "-113.62214929359266",
  #   url: "https://www.airbnb.com/rooms/1797958?s=ZjJe",
  #   imgUrl: "https://a2.muscache.com/ic/pictures/25304103/a4ea859b_original.jpg?interpolation=lanczos-none&size=x_medium&output-format=jpg&output-quality=70"
  # },
  # {
  #   room_id: 4541130,
  #   user_id: 9,
  #   name: "Quiet Winchester Hills home",
  #   price: 150,
  #   location: "St. George",
  #   latitude: "37.209110758657225",
  #   longitude: "-113.60691806386185",
  #   url: "https://www.airbnb.com/rooms/4541130?s=o65K",
  #   imgUrl: "https://a1.muscache.com/ic/pictures/57029819/37d75f25_original.jpg?interpolation=lanczos-none&size=x_medium&output-format=jpg&output-quality=70"
  # }
])
