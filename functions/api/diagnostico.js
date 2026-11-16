// Internal configuration diagnostics are intentionally disabled in production.
// Do not expose the presence of database bindings or secret configuration publicly.
export async function onRequest() {
  return new Response("Not found", {
    status: 404,
    headers: {
      "Content-Type": "text/plain; charset=utf-8",
      "Cache-Control": "no-store"
    }
  });
}
