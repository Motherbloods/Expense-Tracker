const mongoose = require("mongoose");

// Ganti 'mongodb://localhost:27017/expense_tracker' dengan URI MongoDB Anda
mongoose.connect(
  "mongodb+srv://motherbloodss:XKFofTN9qGntgqbo@cluster0.ejyrmvc.mongodb.net/?retryWrites=true&w=majority",
  {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  }
);

const expenseSchema = new mongoose.Schema({
  name: { type: String, required: true, trim: true },
  amount: { type: Number, required: true, min: 0 },
  date: { type: Date, required: true, default: Date.now },
});

const Expense = mongoose.model("Expense_tracker", expenseSchema);

module.exports = Expense;
