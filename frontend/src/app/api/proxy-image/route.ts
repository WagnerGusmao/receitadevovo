import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const imageUrl = searchParams.get("url");

  if (!imageUrl) {
    return new NextResponse("Missing url parameter", { status: 400 });
  }

  try {
    const response = await fetch(imageUrl);
    if (!response.ok) {
      return new NextResponse(`Failed to fetch image: ${response.statusText}`, { status: response.status });
    }

    const blob = await response.blob();
    const headers = new Headers();
    headers.set("Content-Type", response.headers.get("Content-Type") || "image/webp");
    headers.set("Access-Control-Allow-Origin", "*");

    return new NextResponse(blob, {
      status: 200,
      headers,
    });
  } catch (error: any) {
    return new NextResponse(`Error fetching image: ${error.message}`, { status: 500 });
  }
}
