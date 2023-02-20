"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mysql_1 = __importDefault(require("mysql"));
const dotenv = __importStar(require("dotenv"));
dotenv.config();
class MysqlDBC {
    constructor() {
        this.connection = () => {
            this.pool.getConnection((err, connection) => {
                if (err)
                    throw err;
                connection.release();
                //console.info('DB: pool connection');
            });
        };
        this.limit = (start, step = parseInt(process.env.DBPAG || '10')) => {
            let limit = [1, 9];
            if (start) {
                start = (start > 0) ? (start - 1) * step : 1;
                limit = [start, step];
            }
            return limit;
        };
        this.pool = mysql_1.default.createPool({
            connectionLimit: parseInt(process.env.DBCONNLIMIT || '10'),
            host: process.env.DBHOST,
            port: parseInt(process.env.DBPORT),
            user: process.env.DBUSER,
            password: process.env.DBPASSWD,
            database: process.env.DBNAME,
            debug: false
        });
    }
    statement(statement, data) {
        return mysql_1.default.format(statement, data);
    }
}
exports.default = MysqlDBC;
