import chai, { expect } from "chai";
import chaiHttp from "chai-http";
import app from "../../src/index.js";

chai.use(chaiHttp);
chai.should();

describe("GET /users", () => {
  it("Should display a list of users, fetched from db", (done) => {
    chai
      .request(app)
      .get("/users")
      .then((res) => {
        expect(res).to.be.html;
        res.text.should.match(/<h1.*>Users<\/h1>/g);
        res.text.should.match(/<h3.*>.*<\/h3>/g);
        done();
      })
      .catch((err) => {
        done(err);
      });
  });
});
