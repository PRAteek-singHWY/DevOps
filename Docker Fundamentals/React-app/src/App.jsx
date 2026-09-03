import React, { useState } from "react";

export default function App() {
  const [clicks, setClicks] = useState(0);
  return (
    <main style={{ fontFamily: "sans-serif", margin: "3rem" }}>
      <h1>Hello World</h1>
      <p>Built with React {React.version} and Vite, served by Nginx inside a container.</p>
      <button onClick={() => setClicks(clicks + 1)}>Clicked {clicks} times</button>
    </main>
  );
}
