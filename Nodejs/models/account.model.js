const mongoose = require('mongoose');
const AutoIncrement = require('mongoose-sequence')(mongoose);
const accountSchema = new mongoose.Schema({
    email: {
        type: String,
        unique: true
    },
    password: {
        type: String
    }
})


module.exports= mongoose.model('Account', accountSchema);