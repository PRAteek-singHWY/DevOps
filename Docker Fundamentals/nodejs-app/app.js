const http = require("http");

const port = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "text/html" });
  res.end("<h1>Hello World</h1><p>Served by Node.js " + process.version + " inside a container.</p>");
});

server.listen(port, () => console.log(`node app listening on ${port}`));
