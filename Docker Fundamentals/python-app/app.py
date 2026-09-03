import platform

from flask import Flask

app = Flask(__name__)


@app.get("/")
def index():
    return f"<h1>Hello World</h1><p>Served by Flask on Python {platform.python_version()} inside a container.</p>"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
