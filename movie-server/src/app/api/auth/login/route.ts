import { NextRequest, NextResponse } from "next/server";

// Danh sách người dùng giả lập (thay bằng DB sau)
const users = [
  {
    id: 1,
    username: "abc",
    password: "123456",
    name: "Nguyễn Văn A",
  },
];

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    console.log('LOGIN BODY:', body);
    const { username, password } = body;

    const user = users.find((u) => u.username === username && u.password === password);

    if (!user) {
      return NextResponse.json(
        { error: "Tên tài khoản hoặc mật khẩu không đúng" },
        { status: 401 }
      );
    }

    // Tạo token giả (thực tế: dùng JWT)
    const token = Buffer.from(`${user.id}:${Date.now()}`).toString("base64");

    return NextResponse.json({
      success: true,
      token,
      user: {
        id: user.id,
        name: user.name,
        username: user.username,
      },
    });
  } catch (error) {
    return NextResponse.json(
      { error: "Lỗi server" },
      { status: 500 }
    );
  }
}