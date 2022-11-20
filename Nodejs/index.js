const express = require("express");
const mongoose = require("mongoose");
const Account = require("./models/account.model");
const FlashCard = require("./models/flashcard.model");
const app = express();

app.use(express.json());

try {
  mongoose.connect("mongodb://localhost:27017/ct484");
  console.log("MongoDB connected.");

  app.listen(3000, () => console.log("Server is listening on port 3000"));
} catch (error) {
  console.log(error);
}

// --- Quản lý các tài khoản người dùng ---

// Kiểm tra thông tin đăng nhập của một người dùng
app.post("/api/login", async (req, res) => {
  try {
    var account = await Account.findOne({
      email: req.body.email,
      password: req.body.password,
    });

    if (account) {
      return res.status(200).json(account.email);
    }
  } catch (error) {
    console.log(error);
  }

  res.status(200).json(null);
});

// Đăng ký tài khoản mới
app.post("/api/signup", async (req, res) => {
  try {
    var account = await Account.findOne({
      email: req.body.email,
    });

    if (account) {
      return res.status(200).json(false);
    }

    Account.create(req.body);
  } catch (error) {
    console.log(error);

    return res.status(200).json(false);
  }

  return res.status(200).json(true);
});

// --- Kết thúc quản lý các tài khoản người dùng ---

// --- Quản lý các flashCard ---

// Lấy danh sách flashCard của một người dùng
app.get("/api/flashCard", async (req, res) => {
  var flashCards = await FlashCard.find({ account_email: req.query.email });

  res.json(flashCards);
});

// Lấy danh sách flashCard yêu thích của một người dùng
app.get("/api/flashCard/favorite", async (req, res) => {
  var flashCards = await FlashCard.find({
    account_email: req.query.email,
    isFavorite: true,
  });

  res.json(flashCards);
});

// Thêm một flashCard của một người dùng
app.post("/api/flashCard", async (req, res) => {
  req.body.account_email = req.query.email;
  await FlashCard.create(req.body);

  res.status(200).json(req.body);
});

// Cập nhật trạng thái yêu thích flashCard của một người dùng
app.put("/api/flashCard/:id/favorite/:isFavorite", async (req, res) => {
  await FlashCard.updateOne(
    { id: req.params.id },
    { $set: { isFavorite: req.params.isFavorite == "true" ? true : false } }
  );

  res.status(200).json("Toggle favorite successfully!");
});

// Cập nhật thông tin flashCard của một người dùng
app.put("/api/flashCard/:id", async (req, res) => {
  await FlashCard.updateOne({ id: req.params.id }, { $set: { ...req.body } });

  res.status(200).json(req.body);
});

// Xóa một flashCard của một người dùng
app.delete("/api/flashCard/:id", async (req, res) => {
  await FlashCard.deleteOne({ id: req.params.id });
  res.status(200).json("Delete successfully!");
});

// --- Kết thúc quản lý các flashCard ---
