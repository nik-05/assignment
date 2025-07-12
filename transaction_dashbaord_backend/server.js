const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

const mockTransactions = [
  {
    id: 1,
    amount: 1250.00,
    date: "2025-07-12T10:30:00Z",
    type: "credit",
    status: "completed"
  },
  {
    id: 2,
    amount: 750.50,
    date: "2025-07-12T10:30:00Z",
    type: "debit",
    status: "pending"
  },
  {
    id: 3,
    amount: 2100.75,
    date: "2025-07-12T10:30:00Z",
    type: "credit",
    status: "completed"
  },
  {
    id: 4,
    amount: 450.25,
    date: "2025-07-12T10:30:00Z",
    type: "debit",
    status: "failed"
  },
  {
    id: 5,
    amount: 1800.00,
    date: "2025-07-12T10:30:00Z",
    type: "credit",
    status: "completed"
  }
];

app.get('/api/transactions', (req, res) => {
  res.json(mockTransactions);
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
}); 