import { createRoot } from "react-dom/client";
import App from "./App";
import "./App.css";

// Mount the single-page app
createRoot(document.getElementById("root")!).render(<App />);
