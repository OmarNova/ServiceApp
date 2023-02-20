"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const MysqlDBC_1 = __importDefault(require("../db/myslq/MysqlDBC"));
class UserModel {
    constructor() {
        this.InsertUser = (nombre, apellidos, email, telefono, passwd, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `INSERT INTO users(nombres,apellidos,email,telefono,passwd) VALUES ('${nombre}', '${apellidos}','${email}','${telefono}','${passwd}');`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        this.getUser = (email, fn) => __awaiter(this, void 0, void 0, function* () {
            this.mysqlDBC.connection();
            const statement = `SELECT * FROM users WHERE email='${email}'`;
            this.mysqlDBC.pool.query(statement, (error, rows) => {
                fn(error, rows);
            });
        });
        this.mysqlDBC = new MysqlDBC_1.default();
    }
}
exports.default = UserModel;
