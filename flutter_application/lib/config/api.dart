class ApiConfig {
  static const baseUrl = "http://192.168.14.51:3000"; // Node.js server
  static const movies = "$baseUrl/api/movies";
  static const auth = "$baseUrl/api/auth/login";
  static const myTickets = "$baseUrl/api/tickets";
  static const bookTicket = "$baseUrl/api/tickets/book";
}