"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const UserController_1 = __importDefault(require("../controller/UserController"));
class UserRoute {
    constructor() {
        this.config = () => {
            this.router.get('/', this.UserController.index);
            this.router.post('/user/register', this.UserController.register);
            this.router.post('/user/login', this.UserController.login);
        };
        this.router = (0, express_1.Router)();
        this.UserController = new UserController_1.default();
        this.config();
    }
}
exports.default = UserRoute;
