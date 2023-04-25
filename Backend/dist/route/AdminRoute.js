"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const AdminController_1 = __importDefault(require("../controller/AdminController"));
class UserRoute {
    constructor() {
        this.config = () => {
            this.router.get('/', this.AdminController.index);
            this.router.post('/trabajo/categoria', this.AdminController.insertCategoria);
            this.router.delete('/trabajo/categoria/:nombre', this.AdminController.deleteCategoria);
            this.router.get('/panel', this.AdminController.VistaAdmin);
        };
        this.router = (0, express_1.Router)();
        this.AdminController = new AdminController_1.default();
        this.config();
    }
}
exports.default = UserRoute;
