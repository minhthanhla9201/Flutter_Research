import { NextResponse } from "next/server";

const movies = [
  {
      "id": 201,
      "title": "Galaxy Heroes: Awakening",
      "originalTitle": "Galaxy Heroes: Awakening",
      "slug": "galaxy-heroes-awakening",
      "duration": 130,
      "genre": ["Action", "Sci-Fi"],
      "rating": "C13",
      "posterUrl": "https://picsum.photos/id/1011/800/450",
      "bannerUrl": "https://picsum.photos/id/1012/1200/500",
      "synopsis": "A small crew must save a dying star system in an epic space saga.",
      "category": "now",
      "isHot": true,
      "releaseDate": "2025-10-10",
      "theaters": [
        {
          "theaterId": "HCM_PLC",
          "theaterName": "CGV Parkson Plaza",
          "showtimes": [
            { "time": "10:30", "format": "2D", "price": 90000 },
            { "time": "13:40", "format": "2D", "price": 110000 },
            { "time": "19:00", "format": "IMAX", "price": 220000 }
          ]
        }
      ]
    },
    {
      "id": 202,
      "title": "The Forgotten Garden",
      "originalTitle": "The Forgotten Garden",
      "slug": "forgotten-garden",
      "duration": 105,
      "genre": ["Drama", "Fantasy"],
      "rating": "P",
      "posterUrl": "https://picsum.photos/id/1013/800/450",
      "bannerUrl": "https://picsum.photos/id/1014/1200/500",
      "synopsis": "A touching journey through memory and time in an enchanted garden.",
      "category": "coming",
      "isHot": false,
      "releaseDate": "2025-12-05",
      "theaters": []
    },
    {
      "id": 203,
      "title": "Midnight Heist",
      "originalTitle": "Midnight Heist",
      "slug": "midnight-heist",
      "duration": 118,
      "genre": ["Thriller", "Crime"],
      "rating": "C16",
      "posterUrl": "https://picsum.photos/id/1015/800/450",
      "bannerUrl": "https://picsum.photos/id/1016/1200/500",
      "synopsis": "A high-stakes heist thriller that unfolds over one night.",
      "category": "special",
      "isHot": false,
      "releaseDate": "2026-02-20",
      "theaters": [
        {
          "theaterId": "DN_SUN",
          "theaterName": "CGV Sun Plaza",
          "showtimes": [{ "time": "20:00", "format": "VIP", "price": 200000 }]
        }
      ]
    },
    {
      "id": 204,
      "title": "Ocean's Echo",
      "originalTitle": "Ocean's Echo",
      "slug": "oceans-echo",
      "duration": 125,
      "genre": ["Adventure", "Drama"],
      "rating": "C13",
      "posterUrl": "https://picsum.photos/id/1020/800/450",
      "bannerUrl": "https://picsum.photos/id/1021/1200/500",
      "synopsis": "A family voyage turns into a fight for survival against nature's fury.",
      "category": "now",
      "isHot": true,
      "releaseDate": "2025-09-30",
      "theaters": [
        {
          "theaterId": "HN_MEGA",
          "theaterName": "CGV Mega Mall",
          "showtimes": [
            { "time": "11:00", "format": "2D", "price": 95000 },
            { "time": "16:30", "format": "3D", "price": 120000 }
          ]
        }
      ]
    },
    {
      "id": 205,
      "title": "Neon Runner",
      "originalTitle": "Neon Runner",
      "slug": "neon-runner",
      "duration": 98,
      "genre": ["Action", "Cyberpunk"],
      "rating": "C16",
      "posterUrl": "https://picsum.photos/id/1025/800/450",
      "bannerUrl": "https://picsum.photos/id/1026/1200/500",
      "synopsis": "A courier in a neon city uncovers a conspiracy that could topple corporations.",
      "category": "now",
      "isHot": true,
      "releaseDate": "2025-10-02",
      "theaters": []
    },
    {
      "id": 206,
      "title": "Tales of the Mountain",
      "originalTitle": "Tales of the Mountain",
      "slug": "tales-of-the-mountain",
      "duration": 140,
      "genre": ["Drama", "Historical"],
      "rating": "P",
      "posterUrl": "https://picsum.photos/id/1030/800/450",
      "bannerUrl": "https://picsum.photos/id/1031/1200/500",
      "synopsis": "An intergenerational saga set against epic mountain landscapes.",
      "category": "special",
      "isHot": false,
      "releaseDate": "2026-01-10",
      "theaters": []
    },
    {
      "id": 207,
      "title": "Quantum Fault",
      "originalTitle": "Quantum Fault",
      "slug": "quantum-fault",
      "duration": 112,
      "genre": ["Sci-Fi", "Thriller"],
      "rating": "C13",
      "posterUrl": "https://picsum.photos/id/1035/800/450",
      "bannerUrl": "https://picsum.photos/id/1036/1200/500",
      "synopsis": "Scientists race to fix a quantum anomaly that fractures reality.",
      "category": "coming",
      "isHot": false,
      "releaseDate": "2025-11-20",
      "theaters": []
    },
    {
      "id": 208,
      "title": "The Last Melody",
      "originalTitle": "The Last Melody",
      "slug": "the-last-melody",
      "duration": 100,
      "genre": ["Music", "Drama"],
      "rating": "P",
      "posterUrl": "https://picsum.photos/id/1040/800/450",
      "bannerUrl": "https://picsum.photos/id/1041/1200/500",
      "synopsis": "An aging musician embarks on one final tour that rekindles lost bonds.",
      "category": "now",
      "isHot": false,
      "releaseDate": "2025-08-15",
      "theaters": [
        {
          "theaterId": "DN_CINE",
          "theaterName": "CGV Cine Plaza",
          "showtimes": [
            { "time": "14:00", "format": "2D", "price": 90000 },
            { "time": "20:30", "format": "2D", "price": 110000 }
          ]
        }
      ]
    },
    {
      "id": 209,
      "title": "Shadow of the City",
      "originalTitle": "Shadow of the City",
      "slug": "shadow-of-the-city",
      "duration": 121,
      "genre": ["Crime", "Drama"],
      "rating": "C16",
      "posterUrl": "https://picsum.photos/id/1045/800/450",
      "bannerUrl": "https://picsum.photos/id/1046/1200/500",
      "synopsis": "A detective hunts for clues after a mysterious string of disappearances.",
      "category": "special",
      "isHot": false,
      "releaseDate": "2026-04-01",
      "theaters": []
    },
    {
      "id": 210,
      "title": "Luna & The Starforge",
      "originalTitle": "Luna & The Starforge",
      "slug": "luna-starforge",
      "duration": 127,
      "genre": ["Fantasy", "Adventure"],
      "rating": "P",
      "posterUrl": "https://picsum.photos/id/1050/800/450",
      "bannerUrl": "https://picsum.photos/id/1051/1200/500",
      "synopsis": "A young blacksmith discovers an ancient forge that reshapes destinies.",
      "category": "coming",
      "isHot": false,
      "releaseDate": "2025-12-25",
      "theaters": []
    },
    {
      "id": 211,
      "title": "City of Mirrors",
      "originalTitle": "City of Mirrors",
      "slug": "city-of-mirrors",
      "duration": 95,
      "genre": ["Mystery", "Sci-Fi"],
      "rating": "C13",
      "posterUrl": "https://picsum.photos/id/1055/800/450",
      "bannerUrl": "https://picsum.photos/id/1056/1200/500",
      "synopsis": "A journalist uncovers a mirrored city where clues reflect the past.",
      "category": "now",
      "isHot": true,
      "releaseDate": "2025-10-01",
      "theaters": [
        {
          "theaterId": "HN_CBD",
          "theaterName": "CGV CBD",
          "showtimes": [
            { "time": "12:00", "format": "2D", "price": 95000 },
            { "time": "18:00", "format": "3D", "price": 140000 }
          ]
        }
      ]
    },
    {
      "id": 212,
      "title": "Echoes of Tomorrow",
      "originalTitle": "Echoes of Tomorrow",
      "slug": "echoes-of-tomorrow",
      "duration": 132,
      "genre": ["Sci-Fi", "Drama"],
      "rating": "C13",
      "posterUrl": "https://picsum.photos/id/1060/800/450",
      "bannerUrl": "https://picsum.photos/id/1061/1200/500",
      "synopsis": "Time travelers face moral choices when altering history costs lives.",
      "category": "now",
      "isHot": false,
      "releaseDate": "2025-09-20",
      "theaters": []
    },
    {
      "id": 213,
      "title": "Rising Storm",
      "originalTitle": "Rising Storm",
      "slug": "rising-storm",
      "duration": 110,
      "genre": ["Action", "Thriller"],
      "rating": "C16",
      "posterUrl": "https://picsum.photos/id/1065/800/450",
      "bannerUrl": "https://picsum.photos/id/1066/1200/500",
      "synopsis": "An elite rescue team battles a rogue weather-engineering corporation.",
      "category": "now",
      "isHot": true,
      "releaseDate": "2025-10-05",
      "theaters": []
    },
    {
      "id": 214,
      "title": "Paper Wings",
      "originalTitle": "Paper Wings",
      "slug": "paper-wings",
      "duration": 88,
      "genre": ["Family", "Animation"],
      "rating": "P",
      "posterUrl": "https://picsum.photos/id/1070/800/450",
      "bannerUrl": "https://picsum.photos/id/1071/1200/500",
      "synopsis": "A small paper airplane's adventure across a bustling city inspires a child.",
      "category": "coming",
      "isHot": false,
      "releaseDate": "2025-11-10",
      "theaters": []
    },
    {
      "id": 215,
      "title": "Crimson Lake",
      "originalTitle": "Crimson Lake",
      "slug": "crimson-lake",
      "duration": 124,
      "genre": ["Horror", "Mystery"],
      "rating": "C18",
      "posterUrl": "https://picsum.photos/id/1075/800/450",
      "bannerUrl": "https://picsum.photos/id/1076/1200/500",
      "synopsis": "A hidden lake reveals ancestral secrets and gruesome truths.",
      "category": "special",
      "isHot": false,
      "releaseDate": "2026-05-01",
      "theaters": []
    },
    {
      "id": 216,
      "title": "Silver Lanes",
      "originalTitle": "Silver Lanes",
      "slug": "silver-lanes",
      "duration": 102,
      "genre": ["Comedy", "Drama"],
      "rating": "P",
      "posterUrl": "https://picsum.photos/id/1080/800/450",
      "bannerUrl": "https://picsum.photos/id/1081/1200/500",
      "synopsis": "A quirky tale of friends reopening a retro bowling alley.",
      "category": "now",
      "isHot": false,
      "releaseDate": "2025-09-01",
      "theaters": []
    },
    {
      "id": 217,
      "title": "Ironbound",
      "originalTitle": "Ironbound",
      "slug": "ironbound",
      "duration": 136,
      "genre": ["Action", "Adventure"],
      "rating": "C16",
      "posterUrl": "https://picsum.photos/id/1085/800/450",
      "bannerUrl": "https://picsum.photos/id/1086/1200/500",
      "synopsis": "A mercenary team searches for a legendary relic in hostile territory.",
      "category": "coming",
      "isHot": false,
      "releaseDate": "2025-12-01",
      "theaters": []
    },
    {
      "id": 218,
      "title": "Whispers & Smoke",
      "originalTitle": "Whispers & Smoke",
      "slug": "whispers-smoke",
      "duration": 97,
      "genre": ["Romance", "Drama"],
      "rating": "P",
      "posterUrl": "https://picsum.photos/id/1090/800/450",
      "bannerUrl": "https://picsum.photos/id/1091/1200/500",
      "synopsis": "Two strangers find solace and secrets in a smoky jazz bar.",
      "category": "now",
      "isHot": false,
      "releaseDate": "2025-09-12",
      "theaters": []
    },
    {
      "id": 219,
      "title": "The Clockmaker's Gift",
      "originalTitle": "The Clockmaker's Gift",
      "slug": "clockmakers-gift",
      "duration": 123,
      "genre": ["Drama", "Fantasy"],
      "rating": "P",
      "posterUrl": "https://picsum.photos/id/1095/800/450",
      "bannerUrl": "https://picsum.photos/id/1096/1200/500",
      "synopsis": "An intricate story about time, loss, and a handcrafted clock that mends hearts.",
      "category": "special",
      "isHot": false,
      "releaseDate": "2026-07-15",
      "theaters": []
    },
    {
      "id": 220,
      "title": "Velocity Shift",
      "originalTitle": "Velocity Shift",
      "slug": "velocity-shift",
      "duration": 119,
      "genre": ["Sci-Fi", "Action"],
      "rating": "C13",
      "posterUrl": "https://picsum.photos/id/1100/800/450",
      "bannerUrl": "https://picsum.photos/id/1101/1200/500",
      "synopsis": "A prototype vehicle that bends physics sparks a global chase.",
      "category": "now",
      "isHot": true,
      "releaseDate": "2025-10-08",
      "theaters": [
        {
          "theaterId": "HCM_PLC",
          "theaterName": "CGV Parkson Plaza",
          "showtimes": [
            { "time": "10:00", "format": "2D", "price": 90000 },
            { "time": "14:00", "format": "2D", "price": 110000 },
            { "time": "21:00", "format": "IMAX", "price": 230000 }
          ]
        }
      ]
    }
];

export async function GET() {
  const response = NextResponse.json(movies);
  response.headers.set('Access-Control-Allow-Origin', '*'); // hoặc chỉ cho phép domain cụ thể
  response.headers.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  response.headers.set('Access-Control-Allow-Headers', 'Content-Type');
  return response;
}
