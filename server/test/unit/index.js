import chai, { expect } from "chai";
import chaiHttp from "chai-http";
import app from "../../src/index.js";

chai.use(chaiHttp);
chai.should();

describe("GET /", () => {
  it("Should return an HTML page", (done) => {
    chai
      .request(app)
      .get("/")
      .end(async (err, res) => {
        if (err) done(err);
        expect(res).to.be.html;
        done();
      });
  });
  it("Should contain a title as an <h1> tag", (done) => {
    chai
      .request(app)
      .get("/")
      .end(async (err, res) => {
        if (err) done(err);
        res.text.should.match(/<h1>.*<\/h1>/g);
        done();
      });
  });
});
