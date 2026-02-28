import { serve } from "https://deno.land/std@0.177.0/http/server.ts";

const ALADIN_BASE = "http://www.aladin.co.kr/ttb/api";
const TTB_KEY = Deno.env.get("ALADIN_TTB_KEY") || "ttbsund4y11232126001";

serve(async (req: Request) => {
  // CORS preflight
  if (req.method === "OPTIONS") {
    return new Response(null, {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, OPTIONS",
        "Access-Control-Allow-Headers": "*",
      },
    });
  }

  const url = new URL(req.url);
  const endpoint = url.searchParams.get("endpoint") || "ItemList.aspx";
  
  // Forward all query params except 'endpoint', add ttbkey
  const params = new URLSearchParams();
  params.set("ttbkey", TTB_KEY);
  params.set("Output", "JS");
  params.set("Version", "20131101");
  
  for (const [key, value] of url.searchParams.entries()) {
    if (key !== "endpoint") {
      params.set(key, value);
    }
  }

  const aladinUrl = `${ALADIN_BASE}/${endpoint}?${params.toString()}`;
  
  try {
    const res = await fetch(aladinUrl);
    const text = await res.text();
    
    return new Response(text, {
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        "Access-Control-Allow-Origin": "*",
      },
    });
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 500,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
    });
  }
});
