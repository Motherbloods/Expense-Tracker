const express = require("express");
const app = express();
const cors = require("cors");
const bodyParser = require("body-parser");
require("dotenv").config();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(bodyParser.json());

module.exports = app;
