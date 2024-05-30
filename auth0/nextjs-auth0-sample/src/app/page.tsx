"use client";
import { useAuth0 } from "@auth0/auth0-react";

export default function Home() {
  const {
    loginWithRedirect,
    isAuthenticated,
    logout,
    getAccessTokenSilently,
    user,
  } = useAuth0();
  const redirectUri =
    typeof window !== "undefined" ? window.location.origin : "";
  const domain = process.env.NEXT_PUBLIC_AUTH0_DOMAIN;
  const apiUri = process.env.NEXT_PUBLIC_API_URL;

  const callAPIHello = async () => {
    const accessToken = await getAccessTokenSilently({
      authorizationParams: {
        audience: `https://${domain}/api/v2/`,
        scope: "read:current_user",
      },
    });

    const response = await fetch(`${apiUri}/hello`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    });
    const data = await response.json();
    console.log(data);
  };

  const callAPIGoodbye = async () => {
    const accessToken = await getAccessTokenSilently({
      authorizationParams: {
        audience: `https://${domain}/api/v2/`,
        scope: "read:current_user",
      },
    });

    const response = await fetch(`${apiUri}/goodbye`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    });
    const data = await response.json();
    console.log(data);
  };


  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      {isAuthenticated ? (
        <>
          <button
            onClick={() => logout({ logoutParams: { returnTo: redirectUri } })}
          >
            Log Out
          </button>
          <button onClick={callAPIHello}>callAPIHello</button>
          <button onClick={callAPIGoodbye}>callAPIGoodbye</button>
        </>
      ) : (
        <>
          <button onClick={() => loginWithRedirect()}>Log In</button>
        </>
      )}
    </main>
  );
}
