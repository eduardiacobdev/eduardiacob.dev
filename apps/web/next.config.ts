import type { NextConfig } from "next";

// Static export served by CloudFront (ADR-0005): no Node server at runtime.
// Security headers come from the CloudFront response headers policy (T3.5),
// because `headers()` does not apply to a static export.
const config: NextConfig = {
  output: "export",
  trailingSlash: true,
  reactStrictMode: true,
  images: { unoptimized: true },
  // One 404 page for every locale: the app has one root layout per locale.
  experimental: { globalNotFound: true },
};

export default config;
