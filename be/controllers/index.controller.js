const Expense = require("../models/expense");

const list_expense = async (req, res) => {
  try {
    const expense = await Expense.find().sort({ date: -1 }).lean();
    res.json(expense);
  } catch (err) {
    res.status(500).json({ message: err.message });
    console.error(err);
  }
};

const add_expense = async (req, res) => {
  try {
    const { name, amount, date } = req.body;

    if (!name || !amount || !date) {
      return res
        .status(500)
        .json({ message: "Invalid name or amount provided in request" });
    }

    const expense = new Expense({
      name,
      amount,
      date,
    });
    await expense.save();
    res.status(201).json(expense);
  } catch (err) {
    res.status(400).json({ message: err.message });
    console.error(err);
  }
};

// const info_expense = async (req, res) => {
//   try {
//     const { year, month } = req.query;
//     console.log(year, month);
//     let dateFilter = {};
//     if (year && month) {
//       const startDate = new Date(year, month - 1, 1);
//       const endDate = new Date(year, month, 0);
//       dateFilter = {
//         date: {
//           $gte: startDate,
//           $lte: endDate,
//         },
//       };
//     }

//     // Mencari pengeluaran tertinggi User
//     const highestExpense = await Expense.findOne(dateFilter).sort({
//       amount: -1,
//     });

//     // Mencari pengeluaran tertinggi pada tanggal tertentu
//     const highestExpenseDateResult = await Expense.aggregate([
//       { $match: dateFilter },
//       {
//         $group: {
//           _id: { $dateToString: { format: "%Y-%m-%d", date: "$date" } },
//           totalAmount: { $sum: "$amount" },
//         },
//       },
//       { $sort: { totalAmount: -1 } },
//       { $limit: 1 },
//     ]);

//     // Ambil tanggal dengan total pengeluaran tertinggi
//     const highestExpenseDate = highestExpenseDateResult[0]
//       ? highestExpenseDateResult[0]._id
//       : null;

//     let expenseDetails = [];
//     if (highestExpenseDate) {
//       expenseDetails = await Expense.find({
//         date: {
//           $gte: new Date(`${highestExpenseDate}T00:00:00Z`),
//           $lt: new Date(`${highestExpenseDate}T23:59:59Z`),
//         },
//         ...dateFilter,
//       });
//     }

//     res.json({
//       highestExpense: highestExpense
//         ? {
//             name: highestExpense.name,
//             amount: highestExpense.amount,
//             date: highestExpense.date,
//           }
//         : null,
//       highestExpenseDate: {
//         date: highestExpenseDate,
//         amount: highestExpenseDateResult[0]?.totalAmount,
//         details: expenseDetails,
//       },
//     });
//   } catch (err) {
//     res.status(500).json({ message: err.message });
//     console.error(err);
//   }
// };

const info_expense = async (req, res) => {
  try {
    const { year, month } = req.query;

    if (!year || !month) {
      return res.status(400).json({ message: "Year and month are required" });
    }

    const startDate = new Date(year, month - 1, 1);
    const endDate = new Date(year, month, 0);

    const dateFilter = {
      date: {
        $gte: startDate,
        $lte: endDate,
      },
    };

    // Calculate total expenses for the month
    const totalExpenses = await Expense.aggregate([
      { $match: dateFilter },
      { $group: { _id: null, total: { $sum: "$amount" } } },
    ]);

    // Find the highest single expense for the month
    const highestExpense = await Expense.findOne(dateFilter).sort({
      amount: -1,
    });

    // Find the date with the highest total expenses
    const highestExpenseDateResult = await Expense.aggregate([
      { $match: dateFilter },
      {
        $group: {
          _id: { $dateToString: { format: "%Y-%m-%d", date: "$date" } },
          totalAmount: { $sum: "$amount" },
        },
      },
      { $sort: { totalAmount: -1 } },
      { $limit: 1 },
    ]);

    const highestExpenseDate = highestExpenseDateResult[0] || null;

    let expenseDetails = [];
    if (highestExpenseDate) {
      expenseDetails = await Expense.find({
        date: {
          $gte: new Date(`${highestExpenseDate._id}T00:00:00Z`),
          $lt: new Date(`${highestExpenseDate._id}T23:59:59Z`),
        },
      }).sort({ amount: -1 });
    }

    res.json({
      monthYear: `${startDate.toLocaleString("default", {
        month: "long",
      })} ${year}`,
      totalExpenses: totalExpenses[0]?.total || 0,
      highestSingleExpense: highestExpense
        ? {
            name: highestExpense.name,
            amount: highestExpense.amount,
            date: highestExpense.date,
          }
        : null,
      highestExpenseDate: highestExpenseDate
        ? {
            date: highestExpenseDate._id,
            amount: highestExpenseDate.totalAmount,
            details: expenseDetails.map((expense) => ({
              name: expense.name,
              amount: expense.amount,
              date: expense.date,
            })),
          }
        : null,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
    console.error(err);
  }
};

module.exports = { list_expense, add_expense, info_expense };
