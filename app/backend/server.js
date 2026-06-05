const express = require("express");
const client = require("prom-client");

const app = express();

const register = new client.Registry();

client.collectDefaultMetrics({
    register
});

const requestCounter = new client.Counter({
    name: "api_requests_total",
    help: "Total API Requests"
});

register.registerMetric(requestCounter);

app.use((req, res, next) => {

    console.log(
        JSON.stringify({
            timestamp: new Date().toISOString(),
            service: "backend",
            method: req.method,
            path: req.path,
            level: "info"
        })
    );

    requestCounter.inc();

    next();
});

app.get("/health", (req, res) => {
    res.json({
        status: "UP"
    });
});

app.get("/api", (req, res) => {
    res.json({
        message: "Hello from Backend"
    });
});

app.get("/metrics", async (req, res) => {

    res.set("Content-Type", register.contentType);

    res.end(await register.metrics());
});

app.listen(5000, () => {
    console.log(
        JSON.stringify({
            service: "backend",
            level: "info",
            message: "Backend started",
            port: 5000
        })
    );
});