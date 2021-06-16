import express from "express";
import path from "path";
import ejs from "ejs";
import cors from "cors";
import helmet from "helmet";

import routes from "./routes";

const app = express();

const PORT = 8000;

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));
app.engine("html", ejs.renderFile);

app.use(express.static(path.join(__dirname, "public")));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(helmet());

app.use(
  cors({
    origin: (origin, cb) => cb(null, true),
    credentials: true,
  })
);

routes(app);

app.listen(PORT, () => {
  console.log(`Server listening on ${PORT}`);
});

export default app;
