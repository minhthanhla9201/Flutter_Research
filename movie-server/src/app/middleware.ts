import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export const runtime = 'nodejs';

const ALLOWED_ORIGINS = ['http://localhost:54495', 'http://127.0.0.1:54495', 'http://192.168.14.51:54495', '*'];
const ALLOWED_METHODS = 'GET, POST, PUT, DELETE, OPTIONS';
const ALLOWED_HEADERS = 'Content-Type, Authorization, X-Requested-With';

export function middleware(request: NextRequest) {
  console.log('MIDDLEWARE RUNNING:', request.method, request.url);
  const origin = request.headers.get('origin') ?? '';
  const isAllowedOrigin = ALLOWED_ORIGINS.includes('*') || ALLOWED_ORIGINS.includes(origin);

  const corsHeaders = {
    'Access-Control-Allow-Origin': isAllowedOrigin ? origin || '*' : 'null',
    'Access-Control-Allow-Methods': ALLOWED_METHODS,
    'Access-Control-Allow-Headers': ALLOWED_HEADERS,
    'Access-Control-Allow-Credentials': 'true',
    'Access-Control-Max-Age': '86400',
  };

  // ✅ Trường hợp preflight (OPTIONS): trả response kèm header CORS
  if (request.method === 'OPTIONS') {  
    return new NextResponse(null, {
      status: 204,
      headers: corsHeaders,
    });
  }

  // ✅ Cho các request khác đi tiếp và thêm header CORS
  const response = NextResponse.next();
  Object.entries(corsHeaders).forEach(([key, value]) => {
    response.headers.set(key, value);
  });

  return response;
}

export const config = {
  matcher: '/api/:path*',
};
