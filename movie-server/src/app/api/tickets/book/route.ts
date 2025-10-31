import { NextResponse } from 'next/server';
import { v4 as uuidv4 } from 'uuid';

let tickets: any[] = [];

export async function POST(request: Request) {
  const authHeader = request.headers.get('authorization');
  const token = authHeader?.split(' ')[1];

  if (!token) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  try {
    const payload = await request.json();
    const ticket = {
      id: uuidv4(),
      userId: payload.userId,
      movieId: payload.movieId,
      movieTitle: payload.movieTitle,
      showtime: payload.showtime,
      seats: payload.seats,
      theater: payload.theater,
      price: payload.price,
      bookingDate: new Date().toISOString(),
      qrCodeData: `TICKET:${uuidv4()}`,
    };

    tickets.push(ticket);

    return NextResponse.json({ success: true, ticket });
  } catch (error) {
    return NextResponse.json({ error: 'Invalid data' }, { status: 400 });
  }
}