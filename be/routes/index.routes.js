const express = require("express");
const router = express.Router();

const {
  list_expense,
  add_expense,
  info_expense,
} = require("../controllers/index.controller");

router.get("/", list_expense);
router.post("/", add_expense);
router.get("/info", info_expense);

module.exports = router;
