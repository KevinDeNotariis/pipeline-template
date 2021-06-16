import fs from "fs";
import path from "path";
import got from "got";

const routes = (app) => {
  app.get("/", (req, res) => {
    return res.render("index.html", {
      title: "My Web App With a CI / CD Pipeline",
    });
  });

  app.get("/api/users", (req, res) => {
    const users = JSON.parse(
      fs.readFileSync(path.join(__dirname, "./db.json"))
    );

    return res.json(users);
  });

  app.get("/users", async (req, res) => {
    const users = await got.get(`http://localhost:8000/api/users`).json();

    return res.render("users.html", {
      users: users,
    });
  });
};

export default routes;
