"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const multer_1 = __importDefault(require("multer"));
// Settings
const storage = multer_1.default.diskStorage({
    destination: function (req, file, cb) {
        cb(null, './users');
    },
    filename: function (req, file, cb) {
        req.body.filename = file.originalname;
        req.body.tipe = file.mimetype;
        cb(null, file.originalname);
    }
});
exports.default = (0, multer_1.default)({ storage });
