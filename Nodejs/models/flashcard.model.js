const mongoose = require('mongoose');
const AutoIncrement = require('mongoose-sequence')(mongoose);
const flashCardSchema = new mongoose.Schema({
    word: {
        type: String,
    },
    meaning: {
        type: String
    },
    example: {
        type: String
    },
    isFavorite: {
        type: Boolean,
        default: false
    },
    account_email: {
        type: String
    }

})
flashCardSchema.plugin(AutoIncrement, {inc_field: 'id'});

module.exports= mongoose.model('FlashCard', flashCardSchema);