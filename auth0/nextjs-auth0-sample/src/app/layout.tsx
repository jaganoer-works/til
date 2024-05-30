"use client";
import { Auth0Provider } from "@auth0/auth0-react";

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const domain = process.env.NEXT_PUBLIC_AUTH0_DOMAIN;
  const clientId = process.env.NEXT_PUBLIC_AUTH0_CLIENT_ID;
  const redirectUri =
    typeof window !== "undefined" ? window.location.origin : "";

  return (
    <html lang="ja">
      <Auth0Provider
        domain={domain as string}
        clientId={clientId as string}
        authorizationParams={{
          redirect_uri: redirectUri,
          audience: `https://${domain}/api/v2/`,
          scope: "read:current_user update:current_user_metadata",
        }}
      >
        <body>{children}</body>
      </Auth0Provider>
    </html>
  );
}
