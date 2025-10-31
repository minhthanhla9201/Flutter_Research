import { NextResponse } from "next/server";

let tickets = [
  {
    id: "TICKET001",
    userId: 1,
    movieId: 1,
    movieTitle: "Avengers: Endgame",
    theater: "CGV Vincom Center",
    showtime: "2025-10-31 19:30",
    seats: ["A1", "A2", "A3"],
    price: 360000,
    bookingDate: "2025-10-29 21:15",
    qrCodeData: "QRCODE-TICKET001",
  },
  {
    id: "TICKET002",
    userId: 1,
    movieId: 2,
    movieTitle: "Oppenheimer",
    theater: "Lotte Cinema Landmark",
    showtime: "2025-11-02 20:00",
    seats: ["B5", "B6"],
    price: 240000,
    bookingDate: "2025-10-29 22:00",
    qrCodeData: "QRCODE-TICKET002",
  },
  {
    id: "TICKET003",
    userId: 2,
    movieId: 3,
    movieTitle: "Inside Out 2",
    theater: "Galaxy Nguyễn Du",
    showtime: "2025-10-30 15:00",
    seats: ["C1"],
    price: 90000,
    bookingDate: "2025-10-28 14:45",
    qrCodeData: "QRCODE-TICKET003",
  },
];

export async function GET(request: Request) {
  const authHeader = request.headers.get('authorization');
  const token = authHeader?.split(' ')[1];

  if (!token) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  // Giả lập: trả về vé của user hiện tại
  const userTickets = tickets.filter(t => t.userId === 1); // Thay bằng JWT decode

  return NextResponse.json(userTickets);
}